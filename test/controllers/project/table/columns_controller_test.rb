require "test_helper"

class Project::Table::ColumnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_table_column = project_table_columns(:one)
  end

  test "should get index" do
    get project_table_columns_url
    assert_response :success
  end

  test "should get new" do
    get new_project_table_column_url
    assert_response :success
  end

  test "should create project_table_column" do
    assert_difference("Project::Table::Column.count") do
      post project_table_columns_url, params: { project_table_column: { name: @project_table_column.name, primary_descriptor: @project_table_column.primary_descriptor, table_id: @project_table_column.table_id, type: @project_table_column.type } }
    end

    assert_redirected_to project_table_column_url(Project::Table::Column.last)
  end

  test "should show project_table_column" do
    get project_table_column_url(@project_table_column)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_table_column_url(@project_table_column)
    assert_response :success
  end

  test "should update project_table_column" do
    patch project_table_column_url(@project_table_column), params: { project_table_column: { name: @project_table_column.name, primary_descriptor: @project_table_column.primary_descriptor, table_id: @project_table_column.table_id, type: @project_table_column.type } }
    assert_redirected_to project_table_column_url(@project_table_column)
  end

  test "should destroy project_table_column" do
    assert_difference("Project::Table::Column.count", -1) do
      delete project_table_column_url(@project_table_column)
    end

    assert_redirected_to project_table_columns_url
  end
end
