require 'docker'

Docker.url = ENV['DOCKER_HOST'] || 'unix:///Users/ibrahim/.docker/run/docker.sock'

class CodeExecutionService
  def initialize(submission)
    @submission = submission
    @problem = submission.problem
    @solution = @problem.solution
  end

  def execute
    # Prepare test cases
    # test_cases = prepare_test_cases

    # Create temporary files for code and tests
    submission_file = write_code_to_file(@submission.code, 'submission_solution.py')
    solution_file = write_code_to_file(@solution.code, 'reference_solution.py')
    generate_tests_file = write_code_to_file(@problem.stress_test_code, 'stress_tests_generation.py')
    test_file = write_test_cases_to_run

    # Run Docker container with both solutions
    results = run_docker_execution(submission_file, solution_file, test_file, generate_tests_file)

    # Update submission with test results
    update_submission_results(results)
  end

  private

  def prepare_test_cases
    # Retrieve test cases, including dynamically generated ones
    problem_test_cases = TestCase.for_problem(@problem)
    generated_test_cases = generate_stress_test_cases

    # Combine both sets of test cases
    problem_test_cases + generated_test_cases
  end

  def generate_stress_test_cases
    # Assuming there's a method in the Problem model or a separate service
    Rails.logger.info("Generating stress test cases for problem ##{@problem.id}")
    stress_test_generator = StressTestGenerator.new(@problem)
    stress_test_generator.generate_test_cases
  end

  def write_code_to_file(code, filename)
    # Write code to a temporary file
    file_path = "/tmp/#{filename}"
    File.write(file_path, code)
    file_path
  end

  def write_test_cases_to_run
    # Create a Python test script
    test_script = <<-PYTHON
import importlib.util
import sys
import json

def load_module(file_path):
    spec = importlib.util.spec_from_file_location("solution", file_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

def run_tests(submission_module, reference_module, test_cases):
    results = []
    for test_case in test_cases:
        try:
            # Dynamically call the main function or appropriate method
            result = submission_module.solution(*test_case['input'])
            actual = reference_module.solution(*test_case['input'])
            results.append({
                'input': test_case['input'],
                'expected': actual,
                'actual': result,
                'passed': result == actual,
                'description': test_case.get('description', 'No description')
            })
        except Exception as e:
            results.append({
                'input': test_case['input'],
                'error': str(e),
                'passed': False
            })
    return results

def main():
    # Load solutions
    submission_module = load_module('/code/submission_solution.py')
    reference_module = load_module('/code/reference_solution.py')
    test_generation_module = load_module('/code/stress_tests_generation.py')

    test_cases = test_generation_module.generate_test_cases()

    # Run tests
    results = run_tests(submission_module, reference_module, test_cases)

    # Output results
    print(json.dumps({
        'submission_results': results
    }), file=sys.stdout)

if __name__ == '__main__':
    main()
    PYTHON

    # Write test script
    test_script_path = "/tmp/run_tests.py"
    File.open(test_script_path, 'w', 0644) do |f|
      f.write(test_script)
    end
    if File.exist?(test_script_path)
      Rails.logger.error("File written")
    else
      Rails.logger.error("File does not exist")
    end
    # File.write(test_script_path, test_script)

    # Write test cases to JSON
    # test_cases_json_path = "/tmp/test_cases.json"
    # File.open(test_cases_json_path, 'w', 0644) do |f|
    #   f.write(test_cases.to_json)
    # end
    # # File.write(test_cases_json_path, test_cases.to_json)
    # Rails.logger.error(Dir.pwd)

    test_script_path
  end

  def run_docker_execution(submission_file, solution_file, test_file, generate_tests_file)
    # Write test cases to JSON file and capture the path
    # test_cases_json_path = "/tmp/test_cases_#{SecureRandom.hex}.json"
    # File.write(test_cases_json_path, test_cases.to_json)

    # Create and run Docker container
    container = Docker::Container.create(
      'Image' => 'python-code-execution:latest',
      'Volumes' => {
        '/code/submission_solution.py' => {},
        '/code/reference_solution.py' => {},
        '/code/run_tests.py' => {},
        '/code/stress_tests_generation.py' => {}
      },
      'HostConfig' => {
        'Binds' => %W[#{submission_file}:/code/submission_solution.py #{solution_file}:/code/reference_solution.py #{test_file}:/code/run_tests.py #{generate_tests_file}:/code/stress_tests_generation.py],
        'Memory' => 256 * 1024 * 1024,  # 256 MB
        'CpuQuota' => 50000  # 50% of a CPU core
      }
    )

    # Start and wait for container
    container.start
    result = container.wait(30)  # 30-second timeout

    # Parse results
    output = container.logs(stdout: true)
    errors = container.logs(stderr: true)
    Rails.logger.info("result: #{result}")
    Rails.logger.info("output: #{output[8..]}")
    Rails.logger.info("errors: #{errors}")
    JSON.parse(output[8..])
  ensure
    # Clean up the temporary JSON file
    # File.delete(test_cases_json_path) if File.exist?(test_cases_json_path)
    File.delete(submission_file) if File.exist?(submission_file)
    File.delete(solution_file) if File.exist?(solution_file)
    File.delete(test_file) if File.exist?(test_file)
    File.delete(generate_tests_file) if File.exist?(generate_tests_file)

    container.delete(force: true) if container
  end

  def update_submission_results(results)
    @submission.update(
      status: results['submission_results'].all? { |r| r['passed'] } ? 'passed' : 'failed',
      test_results: results
    )
  end
end