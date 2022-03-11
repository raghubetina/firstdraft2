# frozen_string_literal: true

class CreateProjectTableColumns < ActiveRecord::Migration[6.1]
  def change
    create_table :project_table_columns, id: :uuid do |t|
      t.string :name, null: false
      t.string :underscored
      t.boolean :primary_descriptor, default: false
      t.boolean :unique_identifier, default: false
      t.string :type
      t.references :table, null: false, foreign_key: {to_table: :project_tables}, type: :uuid
      t.boolean :starter, default: false
      t.boolean :primary_identifier, default: false
      t.boolean :foreign_type, default: false
      t.references :foreign_type_for, null: true, foreign_key: {to_table: :project_table_columns}, type: :uuid

      t.timestamps
    end
  end
end
