# frozen_string_literal: true

# == Schema Information
#
# Table name: project_table_columns
#
#  id                  :uuid             not null, primary key
#  name                :string           not null
#  underscored         :string
#  primary_descriptor  :boolean          default("false")
#  unique_identifier   :boolean          default("false")
#  type                :string
#  table_id            :uuid             not null
#  starter             :boolean          default("false")
#  primary_identifier  :boolean          default("false")
#  foreign_type        :boolean          default("false")
#  foreign_type_for_id :uuid
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_project_table_columns_on_foreign_type_for_id  (foreign_type_for_id)
#  index_project_table_columns_on_table_id             (table_id)
#

class Project::Table::Column < ApplicationRecord
  include HasRubyIdentifierName

  belongs_to :table, counter_cache: true, touch: true

  belongs_to :foreign_type_for, class_name: "Column", optional: true
  
  has_one :foreign_type_column, class_name: "Column", foreign_key: "foreign_type_for_id", dependent: :destroy

  has_many :relationships_as_foreign_key,
    class_name: "Relationship",
    foreign_key: "foreign_key_id",
    dependent: :destroy

  has_many :relationships_as_key,
    class_name: "Relationship",
    foreign_key: "key_id",
    dependent: :destroy

  has_one :project, through: :table

  validates :type, presence: true

  validates :underscored,
    uniqueness: {scope: :table_id}
  # TODO: columns and associations names should be unique in the same namespace

  after_save :update_siblings_primary_descriptor, if: :saved_change_to_primary_descriptor?

  scope :default_order, -> { order(primary_descriptor: :desc, starter: :asc, primary_identifier: :desc, underscored: :asc) }

  scope :primary_descriptor, -> { where(primary_descriptor: true) }

  scope :primary_identifier, -> { where(primary_identifier: true) }

  scope :unique_identifier, -> { where(unique_identifier: true) }

  def self.humanize
    name.demodulize
  end

  def to_s
    underscored
  end

  def update_siblings_primary_descriptor
    if primary_descriptor?
      table
        .columns
        .where.not(id: id)
        .update(primary_descriptor: false)
    end
  end
end

require_dependency "project/table/column/date_time"
require_dependency "project/table/column/integer"
require_dependency "project/table/column/string"
