class Task < ApplicationRecord
    has_many :sub_tasks, dependent: :destroy
end
