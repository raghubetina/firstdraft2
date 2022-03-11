# frozen_string_literal: true

class CreateProjectTables < ActiveRecord::Migration[6.1]
  def change
    create_table :project_tables, id: :uuid do |t|
      t.references :project, null: false, foreign_key: true, type: :uuid
      t.string :name, null: false
      t.string :underscored
      t.string :underscored_singular
      t.string :underscored_plural
      t.string :classified
      t.string :humanized
      t.string :humanized_plural
      t.integer :columns_count, default: 0
      t.integer :relationships_as_origin_count, default: 0
      t.integer :relationships_as_destination_count, default: 0
      t.integer :scopes_count, default: 0
      t.integer :belongs_tos_count, default: 0
      t.integer :direct_has_ones_count, default: 0
      t.integer :direct_has_manies_count, default: 0
      t.integer :indirect_has_ones_count, default: 0
      t.integer :indirect_has_manies_count, default: 0
      t.boolean :user_account, default: false

      t.timestamps
    end
  end
end
