class Todo < ApplicationRecord
  scope :incomplete, -> { where(completed: false) }
  scope :completed, -> { where(completed: true) }
end
