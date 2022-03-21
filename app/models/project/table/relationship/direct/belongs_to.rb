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

class Project::Table::Relationship::Direct::BelongsTo < Project::Table::Relationship::Direct
  belongs_to :table,
    foreign_key: :origin_id,
    counter_cache: :belongs_tos_count

  after_initialize { self.cardinality = :one }

  def self.full_construct(
    origin:, name: nil,

    destination: nil,
    destination_name: nil,

    scope: nil,
    scope_name: nil,

    foreign_key: nil,
    key: nil,
    polymorphic: false,
    counter_cache: false,
    optional: false,
    touch: false
  )

    raise ArgumentError, "Must supply :destination or :destination_name" if destination.blank? && destination_name.blank?

    if destination.blank?
      destination = origin
        .sibling_tables
        .find_by!(classified: destination_name)
    end

    foreign_key = destination.name.foreign_key if foreign_key.blank?

    fk_column = origin.columns.find_by!(underscored: foreign_key)

    key_column = if key.present?
      destination.columns.find_by!(underscored: key)
    else
      destination.primary_identifier
    end

    if scope.nil? && scope_name
      scope = destination
        .scopes
        .find_by!(underscored: scope)
    end

    name = foreign_key.chomp("_id") if name.blank?

    create(
      ### All relationship attributes
      origin: origin,
      destination: destination,
      name: name,
      scope: scope,

      #### All direct relationship attributes
      foreign_key_owner: origin,
      foreign_key: fk_column,
      key: key_column,
      polymorphic: polymorphic,

      ##### belongs_to attributes
      counter_cache: counter_cache,
      optional: optional,
      touch_option: touch
    )
  end
end
