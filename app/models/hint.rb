class Hint < ApplicationRecord
  belongs_to :problem

  validates :content, presence: true
  validates :order_number, presence: true,
            numericality: { only_integer: true, greater_than: 0 }

  # Ensure order numbers are unique per problem
  validates :order_number, uniqueness: { scope: :problem_id }

  # Scope to get hints in order
  scope :ordered, -> { order(order_number: :asc) }
end