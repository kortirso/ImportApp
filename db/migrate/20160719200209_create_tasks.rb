class CreateTasks < ActiveRecord::Migration
    def change
        create_table :tasks do |t|
            t.string :file
            t.timestamps null: false
        end
        add_reference :operations, :task, index: true
    end
end
