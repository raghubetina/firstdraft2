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

class Project::Table::Relationship < ApplicationRecord
  include HasRubyIdentifierName

  belongs_to :origin,
    class_name: "Table",
    counter_cache: :relationships_as_origin_count,
    touch: true

  belongs_to :destination,
    class_name: "Table",
    optional: true,
    counter_cache: :relationships_as_destination_count,
    touch: true

  belongs_to :scope,
    optional: true

  belongs_to :foreign_key,
    class_name: "Column",
    optional: true

  belongs_to :key,
    class_name: "Column",
    optional: true

  belongs_to :foreign_key_owner,
    class_name: "Table",
    optional: true

  belongs_to :source,
    class_name: "Relationship",
    optional: true,
    counter_cache: :relationships_as_source_count

  belongs_to :through,
    class_name: "Relationship",
    optional: true,
    counter_cache: :relationships_as_through_count

  belongs_to :inverse_of,
    class_name: "Relationship",
    optional: true

  has_many :relationships_as_inverse,
    class_name: "Relationship",
    foreign_key: :inverse_of_id,
    dependent: :nullify

  has_many :relationships_as_source,
    class_name: "Relationship",
    foreign_key: :source_id,
    dependent: :destroy

  has_many :relationships_as_through,
    class_name: "Relationship",
    foreign_key: :through_id,
    dependent: :destroy

  has_one :project, through: :origin_table

  validates :underscored,
    uniqueness: {scope: :origin_id},
    unless: :polymorphic?
  # TODO: columns and associations names should be unique in the same namespace
  # https://stackoverflow.com/questions/34049308/how-to-avoid-a-race-condition-when-validating-uniqueness-across-two-tables-in-ra?lq=1

  enum cardinality: {
    one: :one,
    many: :many
  }

  scope :default_order, -> { order(:underscored) }

  scope :start_at, ->(table) { where(origin_id: table.id) }

  scope :end_at, ->(table) { where(destination_id: table.id) }

  def to_s
    underscored
  end

  def update_inverse(inverse:)
    update(inverse_of: inverse) && inverse.update(inverse_of: self)
  end

  def direct?
    self.class.ancestors.include?(Project::Table::Relationship::Direct)
  end

  def indirect?
    self.class.ancestors.include?(Project::Table::Relationship::Indirect)
  end

  def shorthand
    "#{origin.classified}##{underscored}"
  end
end
