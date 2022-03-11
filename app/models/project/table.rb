# frozen_string_literal: true

# == Schema Information
#
# Table name: project_tables
#
#  id                                 :uuid             not null, primary key
#  project_id                         :uuid             not null
#  name                               :string           not null
#  underscored                        :string
#  underscored_singular               :string
#  underscored_plural                 :string
#  classified                         :string
#  humanized                          :string
#  humanized_plural                   :string
#  columns_count                      :integer          default("0")
#  relationships_as_origin_count      :integer          default("0")
#  relationships_as_destination_count :integer          default("0")
#  scopes_count                       :integer          default("0")
#  belongs_tos_count                  :integer          default("0")
#  direct_has_ones_count              :integer          default("0")
#  direct_has_manies_count            :integer          default("0")
#  indirect_has_ones_count            :integer          default("0")
#  indirect_has_manies_count          :integer          default("0")
#  user_account                       :boolean          default("false")
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#
# Indexes
#
#  index_project_tables_on_project_id  (project_id)
#

class Project::Table < ApplicationRecord
  include HasRubyIdentifierName

  belongs_to :project, counter_cache: true

  has_many :columns, dependent: :destroy

  has_one :primary_identifier,
    -> { primary_identifier },
    class_name: "Column"

  has_one :primary_descriptor,
    -> { primary_descriptor },
    class_name: "Column"

  has_many :unique_identifiers,
    -> { unique_identifier },
    class_name: "Column"

  has_many :scopes, dependent: :destroy

  has_many :relationships_as_origin,
    class_name: "Relationship",
    foreign_key: :origin_id,
    dependent: :destroy

  has_many :relationships_as_destination,
    class_name: "Relationship",
    foreign_key: :destination_id,
    dependent: :destroy

  has_many :belongs_tos,
    class_name: "Relationship::Direct::BelongsTo",
    foreign_key: :origin_id,
    dependent: :destroy

  has_many :direct_has_manies,
    class_name: "Relationship::Direct::HasMany",
    foreign_key: :origin_id,
    dependent: :destroy do
    def add(**kwargs)
      Project::Table::Relationship::Direct::HasSome.full_construct_with_inverse(**kwargs.merge(origin: proxy_association.owner, cardinality: :many))
    end
  end

  has_many :direct_has_ones,
    class_name: "Relationship::Direct::HasOne",
    foreign_key: :origin_id,
    dependent: :destroy do
    def add(**kwargs)
      Project::Table::Relationship::Direct::HasSome.full_construct_with_inverse(**kwargs.merge(origin: proxy_association.owner, cardinality: :one))
    end
  end

  has_many :indirect_has_manies,
    class_name: "Relationship::Indirect::HasMany",
    foreign_key: :origin_id,
    dependent: :destroy do
    def add(**kwargs)
      Project::Table::Relationship::Indirect::HasSome.full_construct_with_inverse(**kwargs.merge(origin: proxy_association.owner))
    end
  end

  has_many :indirect_has_ones,
    class_name: "Relationship::Indirect::HasOne",
    foreign_key: :origin_id,
    dependent: :destroy do
    def add(**kwargs)
      Project::Table::Relationship::Indirect::HasSome.full_construct_with_inverse(**kwargs.merge(origin: proxy_association.owner))
    end
  end

  has_many :sibling_tables, through: :project, source: :tables

  has_many :destinations, through: :relationships_as_origin

  has_many :origins, through: :relationships_as_destination

  validates :name, presence: true

  validates :underscored_singular,
    presence: true,
    uniqueness: {scope: :project_id}

  before_validation :transform_name

  scope :default_order, -> { order(:classified) }

  accepts_nested_attributes_for :columns

  after_create :create_starter_columns

  def to_s
    classified
  end

  def transform_name
    set_underscored
    self.underscored_singular = underscored.singularize
    self.underscored_plural = underscored.pluralize
    self.classified = underscored.classify
    self.humanized = underscored.humanize(capitalize: false)
    self.humanized_plural = humanized.pluralize
  end

  def create_starter_columns
    columns.create(
      [
        {
          name: "id",
          type: "Project::Table::Column::Integer",
          starter: true,
          unique_identifier: true,
          primary_identifier: true
        },
        {
          name: "created_at",
          type: "Project::Table::Column::DateTime",
          starter: true,
          primary_descriptor: primary_descriptor.blank?
        },
        {
          name: "updated_at",
          type: "Project::Table::Column::DateTime",
          starter: true
        }
      ]
    )

    if user_account?
      columns.create(
        [
          {
            name: "email",
            type: "Project::Table::Column::String",
            unique_identifier: true
          },
          {
            name: "password_digest",
            type: "Project::Table::Column::String"
          }
        ]
      )
    end
  end

  def construct_has_some_and_inverse(
    origin:, destination:, foreign_key:, cardinality:, name: nil, inverse_name: nil,
    key: nil,
    dependent: :remove,
    polymorphic: false,
    counter_cache: false,
    optional: false,
    touch: false
  )

    relationships_as_origin.initial_relationship = construct(
      name: name,
      origin: origin,
      destination: destination,
      foreign_key: foreign_key,
      key: key,
      dependent: dependent,
      polymorphic: polymorphic
    )

    inverse_relationship = BelongsTo.construct(
      name: inverse_name,
      origin: destination,
      destination: origin,
      foreign_key: foreign_key,
      key: key,
      polymorphic: polymorphic,
      counter_cache: counter_cache,
      optional: optional,
      touch: false
    )

    initial_relationship.update_inverse(inverse_relationship)
  end

  def rgl_array
    result = []

    relationships_as_origin.each do |first_hop|
      first_destination = first_hop.destination
      result << [classified, first_destination.classified]

      first_destination
        .relationships_as_origin
        .where.not(inverse_of: first_hop.id)
        .find_each do |second_hop|
          second_destination = second_hop.destination

          result << [first_destination.classified, second_destination.classified]
        end
    end

    result.flatten
  end

  require "rgl/adjacency"
  def dg
    RGL::DirectedAdjacencyGraph[*rgl_array]
  end

  require "rgl/dot"
  def write_dg
    dg.write_to_graphic_file("jpg")
  end
end
