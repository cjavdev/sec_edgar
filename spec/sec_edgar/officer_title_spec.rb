require 'spec_helper'

describe SecEdgar::OfficerTitle do
  it "returns important for presidents" do
    expect(SecEdgar::OfficerTitle.new("President and head guy")).to be_important
    expect(SecEdgar::OfficerTitle.new("head guy and president")).to be_important
  end

  it "returns important for cfo" do
    expect(SecEdgar::OfficerTitle.new("CHIEFFINANCIALOFFICER")).to be_important
    expect(SecEdgar::OfficerTitle.new("CFO")).to be_important
  end

  it "returns important for ceo" do
    expect(SecEdgar::OfficerTitle.new("CHIEFEXECUTIVEOFFICER")).to be_important
    expect(SecEdgar::OfficerTitle.new("CEO")).to be_important
  end

  it "returns important for finance in the title" do
    expect(SecEdgar::OfficerTitle.new("CHIEFINANCE")).to be_important
    expect(SecEdgar::OfficerTitle.new("finance")).to be_important
  end
end
