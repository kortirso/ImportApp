class Task < ActiveRecord::Base
    has_many :operations, dependent: :destroy

    validates :file, presence: true

    mount_uploader :file, FileUploader

    after_save :parsing_task, on: :create

    private
    def parsing_task
        ParsingTaskJob.perform_later(self) unless self.parsed?
    end
end
