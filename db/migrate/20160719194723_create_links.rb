class CreateLinks < ActiveRecord::Migration
    def change
        create_table :links do |t|
            t.references :category, foreign_key: true, null: false
            t.references :operation, foreign_key: true, null: false
            t.timestamps null: false
        end
        add_index :links, [:operation_id, :category_id]
    end
end
