# db/seeds.rb

# Clear existing data
puts "Cleaning database..."
[Solution, Hint, TestCase, Submission, Problem, Week, User].each(&:destroy_all)

# Create admin user
puts "Creating admin user..."
admin = User.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)

# Create regular user
puts "Creating test user..."
user = User.create!(
  email: 'user@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)

# Create weeks
puts "Creating weeks..."
weeks = []
12.times do |i|
  weeks << Week.create!(
    number: i + 1,
    theme: "#{['Arrays & Strings', 'Linked Lists', 'Trees & Graphs',
                              'Dynamic Programming', 'Recursion', 'Sorting & Searching',
                              'Stacks & Queues', 'Heaps', 'Greedy Algorithms',
                              'Backtracking', 'Bit Manipulation', 'System Design'].at(i)}",
  )
end

# Problem templates with increasing difficulty
problem_templates = [
  {
    title: "Two Sum",
    description: "Given an array of integers `nums` and an integer `target`, return indices of two numbers in the array that add up to the target. You may assume each input has exactly one solution.",
    difficulty_level: "Easy",
    solution_template: """def two_sum(nums, target):
    # Your solution here
    pass""",
    solution_code: """def two_sum(nums, target):
    seen = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i
    return []""",
    test_cases: [
      { input: "[2, 7, 11, 15], 9", expected_output: "[0, 1]" },
      { input: "[3, 2, 4], 6", expected_output: "[1, 2]" },
      { input: "[3, 3], 6", expected_output: "[0, 1]" }
    ],
    hints: [
      "Consider using a hash map to store numbers you've seen",
      "For each number, check if its complement (target - number) exists in the hash map",
      "Think about the time complexity benefits of using a hash map versus nested loops"
    ]
  },
  {
    title: "Valid Parentheses",
    description: "Given a string s containing just the characters '(', ')', '{', '}', '[' and ']', determine if the input string is valid. An input string is valid if opening brackets are closed by the same type of closing brackets, and are closed in the correct order.",
    difficulty_level: "Medium",
    solution_template: """def is_valid(s):
    # Your solution here
    pass""",
    solution_code: """def is_valid(s):
    stack = []
    brackets = {')': '(', '}': '{', ']': '['}
    for char in s:
        if char in brackets.values():
            stack.append(char)
        elif char in brackets:
            if not stack or stack.pop() != brackets[char]:
                return False
    return len(stack) == 0""",
    test_cases: [
      { input: "\"()\"", expected_output: "True" },
      { input: "\"()[]{}\"", expected_output: "True" },
      { input: "\"(]\"", expected_output: "False" }
    ],
    hints: [
      "Think about using a stack data structure",
      "What happens when you encounter an opening bracket?",
      "What happens when you encounter a closing bracket?"
    ]
  },
  {
    title: "Maximum Subarray",
    description: "Given an integer array nums, find the subarray with the largest sum, and return its sum. A subarray is a contiguous part of an array.",
    difficulty_level: "Hard",
    solution_template: """def max_subarray(nums):
    # Your solution here
    pass""",
    solution_code: """def max_subarray(nums):
    max_sum = current_sum = nums[0]
    for num in nums[1:]:
        current_sum = max(num, current_sum + num)
        max_sum = max(max_sum, current_sum)
    return max_sum""",
    test_cases: [
      { input: "[-2,1,-3,4,-1,2,1,-5,4]", expected_output: "6" },
      { input: "[1]", expected_output: "1" },
      { input: "[5,4,-1,7,8]", expected_output: "23" }
    ],
    hints: [
      "Consider using Kadane's algorithm",
      "Think about maintaining a running sum",
      "When should you reset your running sum to the current number?"
    ]
  }
]

# Create problems, solutions, hints, and test cases
puts "Creating problems, solutions, hints, and test cases..."
weeks.each do |week|
  3.times do |i|
    template = problem_templates[i]

    problem = Problem.create!(
      week: week,
      title: "#{week.number}.#{i + 1} #{template[:title]}",
      description: template[:description],
      difficulty: template[:difficulty_level],
      template_code: template[:solution_template]
    )

    # Create solution
    Solution.create!(
      problem: problem,
      code: template[:solution_code],
      time_complexity: "O(n)",
      space_complexity: "O(n)"
    )

    # Create hints
    template[:hints].each_with_index do |hint_text, index|
      Hint.create!(
        problem: problem,
        content: hint_text,
        order_number: index + 1
      )
    end

    # Create test cases
    template[:test_cases].each_with_index do |test_case, index|
      TestCase.create!(
        problem: problem,
        input: test_case[:input],
        expected_output: test_case[:expected_output],
        is_hidden: index >= 2  # Make some test cases hidden
      )
    end

    # Create some submissions for the test user
    if i.zero?  # Only create submissions for the first problem of each week
      Submission.create!(
        user: user,
        problem: problem,
        code: template[:solution_template],
        status: ['pending', 'passed', 'failed'].sample,
        test_results: {
          "case_1": { "passed": true, "input": template[:test_cases][0][:input], "expected": template[:test_cases][0][:expected_output], "got": template[:test_cases][0][:expected_output] },
          "case_2": { "passed": false, "input": template[:test_cases][1][:input], "expected": template[:test_cases][1][:expected_output], "got": "Different result" }
        }
      )
    end
  end
end

puts "Seed completed! Created:"
puts "- #{Week.count} weeks"
puts "- #{Problem.count} problems"
puts "- #{Solution.count} solutions"
puts "- #{Hint.count} hints"
puts "- #{TestCase.count} test cases"
puts "- #{Submission.count} submissions"
puts "- #{User.count} users"
puts "\nTest user credentials:"
puts "Email: user@example.com"
puts "Password: password123"
puts "\nAdmin user credentials:"
puts "Email: admin@example.com"
puts "Password: password123"