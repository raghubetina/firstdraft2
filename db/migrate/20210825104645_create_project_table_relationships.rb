# frozen_string_literal: true

class CreateProjectTableRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :project_table_relationships, id: :uuid do |t|
      t.references :origin, null: false, foreign_key: {to_table: :project_tables}, type: :uuid
      t.references :destination, null: true, foreign_key: {to_table: :project_tables}, type: :uuid
      t.references :scope, null: true, foreign_key: {to_table: :project_table_scopes}, type: :uuid
      t.string :name
      t.references :foreign_key, null: true, foreign_key: {to_table: :project_table_columns}, type: :uuid
      t.references :key, null: true, foreign_key: {to_table: :project_table_columns}, type: :uuid
      t.boolean :polymorphic
      t.references :foreign_key_owner, null: true, foreign_key: {to_table: :project_tables}, type: :uuid
      t.string :dependent, default: "destroy"
      t.boolean :touch_option
      t.boolean :optional
      t.string :cardinality
      t.boolean :counter_cache
      t.references :source, null: true, foreign_key: {to_table: :project_table_relationships}, type: :uuid
      t.references :through, null: true, foreign_key: {to_table: :project_table_relationships}, type: :uuid
      t.references :inverse_of, null: true, foreign_key: {to_table: :project_table_relationships}, type: :uuid
      t.integer :relationships_as_source_count, default: 0
      t.integer :relationships_as_through_count, default: 0
      t.string :type
      t.string :underscored

      t.timestamps
    end
  end
end
