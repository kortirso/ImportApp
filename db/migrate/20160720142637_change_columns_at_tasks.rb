class ChangeColumnsAtTasks < ActiveRecord::Migration
    def change
        change_column :tasks, :success, :integer, default: 0
        change_column :tasks, :failure, :integer, default: 0
    end
end
