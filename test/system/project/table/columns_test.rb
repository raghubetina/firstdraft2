require "application_system_test_case"

class Project::Table::ColumnsTest < ApplicationSystemTestCase
  setup do
    @project_table_column = project_table_columns(:one)
  end

  test "visiting the index" do
    visit project_table_columns_url
    assert_selector "h1", text: "Columns"
  end

  test "should create column" do
    visit project_table_columns_url
    click_on "New column"

    fill_in "Name", with: @project_table_column.name
    check "Primary descriptor" if @project_table_column.primary_descriptor
    fill_in "Table", with: @project_table_column.table_id
    fill_in "Type", with: @project_table_column.type
    click_on "Create Column"

    assert_text "Column was successfully created"
    click_on "Back"
  end

  test "should update Column" do
    visit project_table_column_url(@project_table_column)
    click_on "Edit this column", match: :first

    fill_in "Name", with: @project_table_column.name
    check "Primary descriptor" if @project_table_column.primary_descriptor
    fill_in "Table", with: @project_table_column.table_id
    fill_in "Type", with: @project_table_column.type
    click_on "Update Column"

    assert_text "Column was successfully updated"
    click_on "Back"
  end

  test "should destroy Column" do
    visit project_table_column_url(@project_table_column)
    click_on "Destroy this column", match: :first

    assert_text "Column was successfully destroyed"
  end
end
