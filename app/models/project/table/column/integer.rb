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

class Project::Table::Column::Integer < Project::Table::Column
end
