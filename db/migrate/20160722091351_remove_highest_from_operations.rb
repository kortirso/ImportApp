class RemoveHighestFromOperations < ActiveRecord::Migration
    def change
        remove_column :operations, :highest
    end
end
