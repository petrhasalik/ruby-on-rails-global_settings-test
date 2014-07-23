require 'test_helper'

class SettingTest < ActiveSupport::TestCase
  context "creating new setting" do
    should "not save if no name" do
      @setting = FactoryGirl.build(:setting, name: nil)
      assert_equal false, @setting.save
    end

    should "not save if no value" do
      @setting = FactoryGirl.build(:setting, value: nil)
      assert_equal false, @setting.save
    end

    should "not save if name isn't unique" do
      @setting = FactoryGirl.create(:setting)
      @other_setting = FactoryGirl.build(:setting)
      assert_equal false, @other_setting.save
    end

    should "save if all ok" do
      @setting = FactoryGirl.build(:setting)
      assert_equal true, @setting.save
    end

    should "have underscore name after save" do
      @setting = FactoryGirl.create(:setting, name: "TestName")
      assert_equal "test_name", @setting.name
    end
  end

  context "updating setting" do 
    should "delete stored cache" do
      @setting = FactoryGirl.create(:setting)
      Rails.cache.fetch(["settings", @setting.name]){@setting.value}
      assert_equal @setting.value, Rails.cache.read(["settings", @setting.name])

      @setting.update value: "new value"

      assert_nil Rails.cache.read(["settings", @setting.name])
    end
  end

  context "setting exists" do
    should "get value" do 
      @setting = FactoryGirl.create(:setting)

      @test_setting = Setting.find_or_set('test_setting')
      assert_equal @setting.value, @test_setting.to_s
    end

    should "get cached value" do 
      @setting = FactoryGirl.create(:setting)

      @test_setting = Setting.find_or_set('test_setting')
      assert_equal @test_setting, Rails.cache.read(["settings", @setting.name])
    end

    should "get Integer" do 
      @setting = FactoryGirl.create(:setting)

      @test_setting = Setting.find_or_set('test_setting')
      assert_equal true, @test_setting.is_a?(Integer)
    end

    should "get Float" do 
      @setting = FactoryGirl.create(:setting, value: "3.14")

      @test_setting = Setting.find_or_set('test_setting')
      assert_equal true, @test_setting.is_a?(Float)
    end

    should "get Float if using comma" do 
      @setting = FactoryGirl.create(:setting, value: "3,14")

      @test_setting = Setting.find_or_set('test_setting')
      assert_equal true, @test_setting.is_a?(Float)
    end

    should "get Boolean" do 
      @setting = FactoryGirl.create(:setting, value: "true")

      @test_setting = Setting.find_or_set('test_setting')
      assert_equal true, @test_setting
    end

    should "get String" do 
      @setting = FactoryGirl.create(:setting, value: "This is Sparta!!!")

      @test_setting = Setting.find_or_set('test_setting')
      assert_equal true, @test_setting.is_a?(String)
    end
  end

  context "setting does not exist" do
    should "create new setting" do
      @test_setting = Setting.find_or_set('test_setting', "hello")

      assert_equal true, Setting.where(name: 'test_setting').first.present?
    end

    should "get right value" do
      @test_setting = Setting.find_or_set('test_setting', "hello")

      assert_equal "hello", @test_setting
    end

    should "get nil if no value" do
      @other_setting = Setting.find_or_set('other_setting')

      assert_nil @other_setting
    end
  end
end
