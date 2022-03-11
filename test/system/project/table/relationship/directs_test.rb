require "application_system_test_case"

class Project::Table::Relationship::DirectsTest < ApplicationSystemTestCase
  setup do
    @project_table_relationship_direct = project_table_relationship_directs(:one)
  end

  test "visiting the index" do
    visit project_table_relationship_directs_url
    assert_selector "h1", text: "Directs"
  end

  test "should create direct" do
    visit project_table_relationship_directs_url
    click_on "New direct"

    fill_in "Cardinality", with: @project_table_relationship_direct.cardinality
    check "Counter cache" if @project_table_relationship_direct.counter_cache
    fill_in "Dependent", with: @project_table_relationship_direct.dependent
    fill_in "Destination", with: @project_table_relationship_direct.destination_id
    fill_in "Foreign key", with: @project_table_relationship_direct.foreign_key_id
    fill_in "Foreign key owner", with: @project_table_relationship_direct.foreign_key_owner_id
    fill_in "Key", with: @project_table_relationship_direct.key_id
    fill_in "Name", with: @project_table_relationship_direct.name
    check "Optional" if @project_table_relationship_direct.optional
    fill_in "Origin", with: @project_table_relationship_direct.origin_id
    check "Polymorphic" if @project_table_relationship_direct.polymorphic
    fill_in "Scope", with: @project_table_relationship_direct.scope_id
    check "Touch option" if @project_table_relationship_direct.touch_option
    fill_in "Type", with: @project_table_relationship_direct.type
    click_on "Create Direct"

    assert_text "Direct was successfully created"
    click_on "Back"
  end

  test "should update Direct" do
    visit project_table_relationship_direct_url(@project_table_relationship_direct)
    click_on "Edit this direct", match: :first

    fill_in "Cardinality", with: @project_table_relationship_direct.cardinality
    check "Counter cache" if @project_table_relationship_direct.counter_cache
    fill_in "Dependent", with: @project_table_relationship_direct.dependent
    fill_in "Destination", with: @project_table_relationship_direct.destination_id
    fill_in "Foreign key", with: @project_table_relationship_direct.foreign_key_id
    fill_in "Foreign key owner", with: @project_table_relationship_direct.foreign_key_owner_id
    fill_in "Key", with: @project_table_relationship_direct.key_id
    fill_in "Name", with: @project_table_relationship_direct.name
    check "Optional" if @project_table_relationship_direct.optional
    fill_in "Origin", with: @project_table_relationship_direct.origin_id
    check "Polymorphic" if @project_table_relationship_direct.polymorphic
    fill_in "Scope", with: @project_table_relationship_direct.scope_id
    check "Touch option" if @project_table_relationship_direct.touch_option
    fill_in "Type", with: @project_table_relationship_direct.type
    click_on "Update Direct"

    assert_text "Direct was successfully updated"
    click_on "Back"
  end

  test "should destroy Direct" do
    visit project_table_relationship_direct_url(@project_table_relationship_direct)
    click_on "Destroy this direct", match: :first

    assert_text "Direct was successfully destroyed"
  end
end
