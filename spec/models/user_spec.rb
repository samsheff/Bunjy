require 'spec_helper'

describe User do
  it "has a default balance of zero" do
    expect build(:user).balance == 0.0
  end
end
