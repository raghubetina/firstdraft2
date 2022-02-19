# frozen_string_literal: true

class CreateProjectTableScopes < ActiveRecord::Migration[6.1]
  def change
    create_table :project_table_scopes, id: :uuid do |t|
      t.string :name
      t.string :underscored
      t.references :table, null: false, foreign_key: {to_table: :project_tables}, type: :uuid
      t.integer :relationships_count, default: 0

      t.timestamps
    end
  end
end
