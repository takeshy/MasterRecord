# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class User 
  UserFields = {
    :name => MasterRecord.string,
    :age => MasterRecord.integer,
  }
  include MasterRecord
end
class Item
  ItemFields = {
    :name => MasterRecord.string,
    :price => MasterRecord.integer,
  }
  include MasterRecord
end
class Country
  CountryFields = {
    :name => MasterRecord.string,
    :population => MasterRecord.integer,
    :salutation => lambda{|r| "'#{r}!!'" }
  }
  include MasterRecord
end
describe "Masterrecord" do
  describe "csv" do
    before do
      #1,ひろし,10
      #2,たけし,20
      #3,まこと,30
      #4,けん,40
      User.load_data(MasterRecord::CSV.load_file(File.expand_path("../data/user.csv", File.dirname(__FILE__)),true))
    end
    it{ User.find().count.should == 4}
    it{ User.find("1").name.should == "ひろし"}
    it{ User.find_by_name("ひろし")[0].age.should == 10}
    it{ User.find(:name => "たけし",:age => 21).should == []}
    it{ User.find(:name => "たけし",:age => 20).count.should == 1}
    it{ User.find_one(:name => "たけし",:age => 20).id.should == "2"}
  end
  describe "tsv" do
    before do
      #1	あめ	30
      #2	チョコレート	40
      #3	ガム	50
      Item.load_data(MasterRecord::TSV.load_file(File.expand_path("../data/item.tsv", File.dirname(__FILE__))))
    end
    it{ Item.find().count.should == 3}
    it{ Item.find_by_price(50)[0].name.should == "ガム"}
  end
  describe "yml" do
    before do
      #1:
      #  name: "Japan"
      #  population: 120000000
      #  salutation: "こんにちは"
      #2:   
      #  name: "China"
      #  population: 500000000
      #  salutation: "您好"
      Country.load_data(
        MasterRecord::YAML.load_file(Country.fields,File.expand_path("../data/country.yml", File.dirname(__FILE__))))
    end
    it{ Country.find().count.should == 2}
    it{ Country.find_one_by_population(500000000).name.should == "China"}
    it{ Country.find().map(&:salutation).should == ["こんにちは!!","您好!!"]}
  end
end
