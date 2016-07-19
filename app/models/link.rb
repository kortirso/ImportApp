class Link < ActiveRecord::Base
    belongs_to :operation
    belongs_to :category

    validates :operation_id, :category_id, presence: true
end
