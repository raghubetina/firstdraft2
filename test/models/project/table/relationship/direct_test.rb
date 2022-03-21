# == Schema Information
#
# Table name: project_table_relationships
#
#  id                             :uuid             not null, primary key
#  origin_id                      :uuid             not null
#  destination_id                 :uuid
#  scope_id                       :uuid
#  name                           :string
#  foreign_key_id                 :uuid
#  key_id                         :uuid
#  polymorphic                    :boolean
#  foreign_key_owner_id           :uuid
#  dependent                      :string           default("destroy")
#  touch_option                   :boolean
#  optional                       :boolean
#  cardinality                    :string
#  counter_cache                  :boolean
#  source_id                      :uuid
#  through_id                     :uuid
#  inverse_of_id                  :uuid
#  relationships_as_source_count  :integer          default("0")
#  relationships_as_through_count :integer          default("0")
#  type                           :string
#  underscored                    :string
#  source_type                    :string
#  as_polymorphic                 :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
# Indexes
#
#  index_project_table_relationships_on_destination_id        (destination_id)
#  index_project_table_relationships_on_foreign_key_id        (foreign_key_id)
#  index_project_table_relationships_on_foreign_key_owner_id  (foreign_key_owner_id)
#  index_project_table_relationships_on_inverse_of_id         (inverse_of_id)
#  index_project_table_relationships_on_key_id                (key_id)
#  index_project_table_relationships_on_origin_id             (origin_id)
#  index_project_table_relationships_on_scope_id              (scope_id)
#  index_project_table_relationships_on_source_id             (source_id)
#  index_project_table_relationships_on_through_id            (through_id)
#

require "test_helper"

class Project::Table::Relationship::DirectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
