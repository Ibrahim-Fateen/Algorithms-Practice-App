class StressTestGenerator
  def initialize(problem)
    @problem = problem
  end

  def generate_test_cases
    # Prepare stress test generation script
    stress_test_script = <<-PYTHON
import sys
import json
import importlib.util
import traceback

print("Starting stress test generation", file=sys.stderr)

# Import the stress test generation module dynamically
def load_module(module_path):
    try:
        spec = importlib.util.spec_from_file_location("stress_tests", module_path)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        return module
    except Exception as e:
        print(f"Module loading error: {e}", file=sys.stderr)
        print(traceback.format_exc(), file=sys.stderr)
        raise

try:
    # Dynamically load the stress test module
    stress_test_module = load_module("/code/stress_tests.py")
    
    # Generate test cases
    test_cases = stress_test_module.generate_test_cases()
    
    # Write test cases to output
    print(json.dumps(test_cases), file=sys.stdout)
except Exception as e:
    error_info = {
        "error": str(e),
        "traceback": traceback.format_exc()
    }
    print(json.dumps(error_info), file=sys.stderr)
    print(json.dumps({"error": str(e)}))
    PYTHON

    # Determine paths
    stress_test_script_path = "/tmp/generate_stress_tests.py"
    stress_test_module_path = "/tmp/stress_tests.py"

    # Write files
    File.write(stress_test_script_path, stress_test_script)
    File.write(stress_test_module_path, @problem.stress_test_code)

    # Create and run Docker container for test generation
    container = Docker::Container.create(
      'Image' => 'python-code-execution:latest',
      'Volumes' => {
        '/code/generate_stress_tests.py' => {},
        '/code/stress_tests.py' => {}
      },
      'HostConfig' => {
        'Binds' => %W[#{stress_test_script_path}:/code/generate_stress_tests.py #{stress_test_module_path}:/code/stress_tests.py],
        'Memory' => 256 * 1024 * 1024,
        'CpuQuota' => 50000
      }
    )

    Rails.logger.info("Container created")
    Rails.logger.info("Container config: #{container.json}")

    begin
      container.start
      Rails.logger.info("Container started")

      # Optional: Wait briefly to ensure the container transitions to running
      # sleep(1)

      # Confirm container state
      container_state = container.json["State"]
      Rails.logger.info("Container state after start: #{container_state}")

      if container_state["Running"]
        # Wait for container to finish
        result = container.wait(30)
        Rails.logger.info("Container wait result: #{result}")

        stdout = container.logs(stdout: true)
        stderr = container.logs(stderr: true)

        Rails.logger.info("STDOUT: #{stdout}")
        Rails.logger.info("STDERR: #{stderr}")

        # Parse output
        parsed_output = JSON.parse(stdout[8...])
        Rails.logger.info("Test cases generated successfully")
        parsed_output
      else
        Rails.logger.error("Container is not running as expected.")
        []
      end
    rescue StandardError => e
      Rails.logger.error("Error during stress test generation: #{e.message}")
      []
    ensure
      container.delete(force: true) if container
    end
  end
end