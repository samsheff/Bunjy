require 'spec_helper'

describe Setting do
  it "creates a setting (string)" do
    setting_hash = {name: "test setting name", value: "test setting value"}
    setting = Setting.create_setting(setting_hash)
    setting.should_not == nil
    setting.value.should be_a(String)
    setting.value.should == "test setting value"
  end

  it "creates a setting (boolean)" do
    setting_hash = {name: "test setting name", value: "false", data_type: "boolean"}
    setting = Setting.create_setting(setting_hash)
    setting.should_not == nil
    setting.value.should == false
  end

  it "creates a setting (integer)" do
    setting_hash = {
      name: "test setting name",
      value: 0,
      data_type: "integer"
    }
    setting = Setting.create_setting(setting_hash)
    setting.should_not == nil
    setting.value.should be_a(Integer)
    setting.value.should == 0
  end

  it "creates a setting (decimal)" do
    setting_hash = {
      name: "test setting name",
      value: BigDecimal.new("0.0"),
      data_type: "decimal"
    }
    setting = Setting.create_setting(setting_hash)
    setting.should_not == nil
    setting.value.should be_a(BigDecimal)    
    setting.value.should == 0.0
  end  

  it "creates a setting (json)" do
    setting_hash = {
      name: "test setting name",
      value: "{ \"test\": 0 }",
      data_type: "json"
    }
    setting = Setting.create_setting(setting_hash)
    setting.should_not == nil
    setting.value.should be_a(Hash)
    hash = setting.value
    hash[:test].should == 0
  end

  it "finds by name" do
    create(:setting)
    Setting.lookup("test").should be_a(Setting)
  end

  it "changes value" do
    setting = create(:setting)
    setting.value.should == "value"
    setting.change_value("newvalue")
    setting.value.should == "newvalue"
    setting.name.should == "test"
  end

  it "changes a value and data type" do
    setting = create(:setting)
    setting.value.should == "value"
    setting.change_value(0, "integer")
    setting.value.should == 0
    setting.name.should == "test"
  end
end
