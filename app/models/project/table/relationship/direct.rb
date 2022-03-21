# frozen_string_literal: true
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

class Project::Table::Relationship::Direct < Project::Table::Relationship
  enum dependent: {
    nil: :nil,
    remove: :remove,
    nullify: :nullify,
    restrict_with_error: :restrict_with_error
  }

  # TODO: Write custom validation for :dependent
  # belongs_to should only be destroy or delete, shouldn't be used if inverse has_many dependent is used
  # nullify should be an option only if inverse belongs_to is optional: true - or automatically set, so not even an option in the UI?
end
