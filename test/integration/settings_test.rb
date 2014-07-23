require 'test_helper'

class SettingsTest < ActionDispatch::IntegrationTest

  should 'add new setting' do 
    visit '/'
    assert page.has_content?("Settings")
    click_link "Add New Setting"
    assert page.has_content?("Add New Setting")

    fill_in "Name", with: 'test_setting'
    fill_in "Value", with: 'test value'
    click_button "Create Setting"
    assert page.has_content?("Success! Setting was successfully created.")
    assert page.has_content?("test_setting")
  end

  should 'show validation error' do 
    visit '/'
    assert page.has_content?("Settings")
    click_link "Add New Setting"
    assert page.has_content?("Add New Setting")

    click_button "Create Setting"
    
    assert page.has_content?("Name can't be blank")
    assert page.has_content?("Value can't be blank")
  end

  should 'show unique validation error' do 
    @setting = FactoryGirl.create(:setting)

    visit '/'
    assert page.has_content?("Settings")
    click_link "Add New Setting"
    assert page.has_content?("Add New Setting")

    fill_in "Name", with: 'test_setting'
    fill_in "Value", with: 'test value'
    click_button "Create Setting"
    assert page.has_content?("Name has already been taken")
  end

  should 'edit setting' do 
    @setting = FactoryGirl.create(:setting)
    visit '/'
    assert page.has_content?("Settings")
    assert page.has_content?("test_setting")

    click_link "Edit"
    assert page.has_content?("Edit Setting")
    fill_in "Name", with: 'updated_test_setting'
    click_button "Update Setting"
    assert page.has_content?("Success! Setting was successfully updated.")
    assert page.has_content?("updated_test_setting")
  end

  should 'delete setting' do 
    @setting = FactoryGirl.create(:setting)
    visit '/'
    assert page.has_content?("Settings")
    assert page.has_content?("test_setting")

    click_link "Delete"

    assert page.has_content?("Success! Setting was successfully deleted.")
    assert_equal false, page.has_content?("test_setting")
  end
end
