# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.citext :codename, null: false
      t.references :parent, null: true, foreign_key: {to_table: :projects}, type: :uuid
      t.boolean :public, default: false
      t.integer :fork_order
      t.integer :tables_count, default: 0

      t.timestamps
    end
    add_index :projects, :codename, unique: true
  end
end
