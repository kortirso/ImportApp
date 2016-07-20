class AddStatsToTasks < ActiveRecord::Migration
    def change
        add_column :tasks, :success, :integer, default: nil
        add_column :tasks, :failure, :integer, default: nil
    end
end
