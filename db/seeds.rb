# db/seeds.rb

# Clear existing data
puts "Cleaning database..."
[Solution, Hint, TestCase, Submission, Problem, Week, User].each(&:destroy_all)

# Create admin user
puts "Creating admin user..."
admin = User.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123',
  admin: true
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

# Problem templates with increasing difficulty and stress test code
problem_templates = [
  {
    title: "Two Sum",
    description: "Given an array of integers `nums` and an integer `target`, return indices of two numbers in the array that add up to the target. You may assume each input has exactly one solution.",
    difficulty_level: "Easy",
    solution_template: """def solution(nums, target):
    # Your solution here
    pass""",
    solution_code: """def solution(nums, target):
    seen = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in seen:
            return [seen[complement], i]
        seen[num] = i
    return []""",
    stress_test_code: """import random
import itertools
def generate_test_cases():
    test_cases = [
        # Basic cases
        {\"input\": [[], 0], \"description\": \"Empty array\"},
        {\"input\": [[5], 5], \"description\": \"Single element array\"},

        # Random large arrays
        {\"input\": [[random.randint(-1000, 1000) for _ in range(100)], random.randint(-2000, 2000)],
         \"description\": \"Large random array\"},

        # Edge cases
        {\"input\": [[0, 0], 0], \"description\": \"Two zeros\"},
        {\"input\": [[2**31 - 1, -(2**31), 0], 0], \"description\": \"Extreme values\"},

        # No solution cases
        {\"input\": [[1, 2, 3, 4], 10], \"description\": \"No solution exists\"},

        # Multiple solutions possible
        {\"input\": [[3, 3, 3, 3], 6], \"description\": \"Multiple identical elements\"}
    ]
    return test_cases""",
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
    solution_template: """def solution(s):
    # Your solution here
    pass""",
    solution_code: """def solution(s):
    stack = []
    brackets = {')': '(', '}': '{', ']': '['}
    for char in s:
        if char in brackets.values():
            stack.append(char)
        elif char in brackets:
            if not stack or stack.pop() != brackets[char]:
                return False
    return len(stack) == 0""",
    stress_test_code: """import random
import itertools
def generate_test_cases():
    def generate_bracket_sequence(length, balanced=True):
        if balanced:
            # Generate a balanced sequence
            opening = ['(', '{', '[']
            closing = [')', '}', ']']
            sequence = []
            stack = []

            for _ in range(length):
                if not stack or random.random() < 0.5:
                    # Add an opening bracket
                    bracket = random.choice(opening)
                    sequence.append(bracket)
                    stack.append(bracket)
                else:
                    # Add a matching closing bracket
                    last_open = stack.pop()
                    matching_close = {
                        '(': ')',
                        '{': '}',
                        '[': ']'
                    }[last_open]
                    sequence.append(matching_close)

            return ''.join(sequence)
        else:
            # Generate an unbalanced sequence
            chars = ['(', ')', '{', '}', '[', ']']
            return ''.join(random.choice(chars) for _ in range(length))

    test_cases = [
        # Basic balanced cases
        {\"input\": [\"()\"], \"description\": \"Simple balanced pair\"},
        {\"input\": [\"()[]{}\"], \"description\": \"Multiple balanced pairs\"},

        # Complex balanced cases
        {\"input\": [generate_bracket_sequence(50, balanced=True)],
         \"description\": \"Long balanced sequence\"},

        # Unbalanced cases
        {\"input\": [\"(]\"], \"description\": \"Mismatched brackets\"},
        {\"input\": [\"([)]\"], \"description\": \"Nested mismatched brackets\"},

        # Edge cases
        {\"input\": [generate_bracket_sequence(100, balanced=False)],
         \"description\": \"Long unbalanced sequence\"},

        # Extreme cases
        {\"input\": ['(' * 50 + ')' * 50], \"description\": \"Nested balanced brackets\"},
        {\"input\": ['(' * 50 + ']' * 50], \"description\": \"Extreme mismatch\"}
    ]
    return test_cases
""",
    test_cases: [
      { input: ["\"()\""], expected_output: "True" },
      { input: ["\"()[]{}\""], expected_output: "True" },
      { input: ["\"(]\""], expected_output: "False" }
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
    solution_template: """def solution(nums):
    # Your solution here
    pass""",
    solution_code: """def solution(nums):
    max_sum = current_sum = nums[0]
    for num in nums[1:]:
        current_sum = max(num, current_sum + num)
        max_sum = max(max_sum, current_sum)
    return max_sum""",
    stress_test_code: """import random
import itertools
def generate_test_cases():
    def generate_array(size, distribution='uniform'):
        if distribution == 'uniform':
            return [random.randint(-1000, 1000) for _ in range(size)]
        elif distribution == 'normal':
            return [int(random.gauss(0, 100)) for _ in range(size)]
        elif distribution == 'sparse':
            arr = [0] * size
            for _ in range(size // 10):
                arr[random.randint(0, size-1)] = random.randint(-1000, 1000)
            return arr

    test_cases = [
        # Basic cases
        {\"input\": [[1]], \"description\": \"Single positive element\"},
        {\"input\": [[-1]], \"description\": \"Single negative element\"},

        # Known pattern cases
        {\"input\": [[-2, 1, -3, 4, -1, 2, 1, -5, 4]], \"description\": \"Mixed positive and negative\"},
        {\"input\": [[5, 4, -1, 7, 8]], \"description\": \"Mostly positive\"},

        # Large random arrays
        {\"input\": [generate_array(1000, 'uniform')],
         \"description\": \"Large uniform distribution\"},

        {\"input\": [generate_array(1000, 'normal')],
         \"description\": \"Large normal distribution\"},

        # Extreme cases
        {\"input\": [[1] * 500 + [-1] * 500], \"description\": \"Alternating elements\"},
        {\"input\": [[0] * 1000], \"description\": \"All zeros\"},
        {\"input\": [[-1] * 1000], \"description\": \"All negative\"},

        # Sparse arrays
        {\"input\": [generate_array(1000, 'sparse')],
         \"description\": \"Sparse array\"}
    ]
    return test_cases""",
    test_cases: [
      { input: "[[-2,1,-3,4,-1,2,1,-5,4]]", expected_output: "6" },
      { input: "[[1]]", expected_output: "1" },
      { input: "[[5,4,-1,7,8]]", expected_output: "23" }
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
      template_code: template[:solution_template],
      stress_test_code: template[:stress_test_code]
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