require 'json'

class Setting < ActiveRecord::Base

  def self.create_setting(setting_hash)
    setting = Setting.new
    setting.build(setting_hash, setting)
  end

  def self.lookup(name)
    self.find_by(setting_name: name)
  end

  def build(setting_hash, new=nil)
    setting = new || self
    if setting_hash[:name] and setting_hash[:value]
      setting_hash[:data_type] = "string" unless setting_hash[:data_type]

      setting.data_type = setting_hash[:data_type].downcase
      setting.setting_name = setting_hash[:name]
      setting.setting_value = setting_hash[:value].to_s
      setting.save
      setting
    else
      nil
    end
  end

  def value(raw=false)
    return self.setting_value if self.data_type == "string" || raw
    return self.setting_value.to_i if self.data_type == "integer"
    return self.setting_value.to_bool if self.data_type == "boolean"
    return BigDecimal.new(self.setting_value) if self.data_type == "decimal"
    return JSON.parse(self.setting_value).symbolize_keys! if self.data_type == "json"
    nil
  end

  def name
    self.setting_name
  end

  def change_value(new_value, data_type="string")
    self.update(setting_value: new_value, data_type: data_type)
  end
end
