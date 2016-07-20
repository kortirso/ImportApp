class AddHighestToOperations < ActiveRecord::Migration
    def change
        add_column :operations, :highest, :boolean, default: false
    end
end
