class Task < ActiveRecord::Base
    has_many :operations

    validates :file, presence: true

    mount_uploader :file, FileUploader
end
