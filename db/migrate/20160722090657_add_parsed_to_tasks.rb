class AddParsedToTasks < ActiveRecord::Migration
    def change
        add_column :tasks, :parsed?, :boolean, default: false
    end
end
