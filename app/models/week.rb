class Week < ApplicationRecord
  has_many :problems, dependent: :destroy

  validates :number, presence: true, uniqueness: true

  scope :publishable, -> { where(posted: false) }

  def publish!
    update!(posted: true)
  end

  def self.current
    where(posted: true).order(number: :desc).first
  end

  def self.published
    where(posted: true)
  end

  def self.upcoming
    where(posted: false)
  end

  def self.past
    where(posted: true)
  end

  def highest_accuracy
    # Find the user with the lowest number of submissions before the first pass for all week problems
    users = User.all
    week_problems = problems
    week_problems.each do |problem|
      users = users.select do |user|
        user.submissions.where(problem: problem).passed.exists?
      end
    end
    highest_accuracy = User.first
    lowest_submissions = Float::INFINITY
    users.each do |user|
      user_submissions = 0
      week_problems.each do |problem|
        user_submissions += user.submissions.where(problem: problem).count
      end
      if user_submissions < lowest_submissions
        lowest_submissions = user_submissions
        highest_accuracy = user
      end
    end
    highest_accuracy
  end

  def fastest_solver
    # For each problem in the week, find all users who have solved it
    # Filter users that did not solve all week problems
    # Find the user with the lowest total time (until first passed submission)

    users = User.all
    week_problems = problems
    week_problems.each do |problem|
      users = users.select do |user|
        user.submissions.where(problem: problem).passed.exists?
      end
    end
    fastest_solver = User.first
    fastest_time = Float::INFINITY
    users.each do |user|
      user_time = 0
      week_problems.each do |problem|
        submission = user.submissions.where(problem: problem).passed.first
        user_time += submission.created_at.to_i if submission
      end
      fastest_time = user_time if user_time < fastest_time
      fastest_solver = user if user_time < fastest_time
    end
    fastest_solver
  end
end