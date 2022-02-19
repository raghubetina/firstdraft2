# frozen_string_literal: true
# == Schema Information
#
# Table name: project_table_scopes
#
#  id                  :uuid             not null, primary key
#  name                :string
#  underscored         :string
#  table_id            :uuid             not null
#  relationships_count :integer          default("0")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_project_table_scopes_on_table_id  (table_id)
#

class Project::Table::Scope < ApplicationRecord
  include HasRubyIdentifierName

  belongs_to :table, counter_cache: true

  has_many :relationships

  validates :underscored,
    uniqueness: {scope: :table_id}

  def to_s
    underscored
  end
end
