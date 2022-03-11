require "test_helper"

class Project::Table::Relationship::DirectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_table_relationship_direct = project_table_relationship_directs(:one)
  end

  test "should get index" do
    get project_table_relationship_directs_url
    assert_response :success
  end

  test "should get new" do
    get new_project_table_relationship_direct_url
    assert_response :success
  end

  test "should create project_table_relationship_direct" do
    assert_difference("Project::Table::Relationship::Direct.count") do
      post project_table_relationship_directs_url, params: { project_table_relationship_direct: { cardinality: @project_table_relationship_direct.cardinality, counter_cache: @project_table_relationship_direct.counter_cache, dependent: @project_table_relationship_direct.dependent, destination_id: @project_table_relationship_direct.destination_id, foreign_key_id: @project_table_relationship_direct.foreign_key_id, foreign_key_owner_id: @project_table_relationship_direct.foreign_key_owner_id, key_id: @project_table_relationship_direct.key_id, name: @project_table_relationship_direct.name, optional: @project_table_relationship_direct.optional, origin_id: @project_table_relationship_direct.origin_id, polymorphic: @project_table_relationship_direct.polymorphic, scope_id: @project_table_relationship_direct.scope_id, touch_option: @project_table_relationship_direct.touch_option, type: @project_table_relationship_direct.type } }
    end

    assert_redirected_to project_table_relationship_direct_url(Project::Table::Relationship::Direct.last)
  end

  test "should show project_table_relationship_direct" do
    get project_table_relationship_direct_url(@project_table_relationship_direct)
    assert_response :success
  end

  test "should get edit" do
    get edit_project_table_relationship_direct_url(@project_table_relationship_direct)
    assert_response :success
  end

  test "should update project_table_relationship_direct" do
    patch project_table_relationship_direct_url(@project_table_relationship_direct), params: { project_table_relationship_direct: { cardinality: @project_table_relationship_direct.cardinality, counter_cache: @project_table_relationship_direct.counter_cache, dependent: @project_table_relationship_direct.dependent, destination_id: @project_table_relationship_direct.destination_id, foreign_key_id: @project_table_relationship_direct.foreign_key_id, foreign_key_owner_id: @project_table_relationship_direct.foreign_key_owner_id, key_id: @project_table_relationship_direct.key_id, name: @project_table_relationship_direct.name, optional: @project_table_relationship_direct.optional, origin_id: @project_table_relationship_direct.origin_id, polymorphic: @project_table_relationship_direct.polymorphic, scope_id: @project_table_relationship_direct.scope_id, touch_option: @project_table_relationship_direct.touch_option, type: @project_table_relationship_direct.type } }
    assert_redirected_to project_table_relationship_direct_url(@project_table_relationship_direct)
  end

  test "should destroy project_table_relationship_direct" do
    assert_difference("Project::Table::Relationship::Direct.count", -1) do
      delete project_table_relationship_direct_url(@project_table_relationship_direct)
    end

    assert_redirected_to project_table_relationship_directs_url
  end
end
