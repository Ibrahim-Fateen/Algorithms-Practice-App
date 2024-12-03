#!/bin/bash
set -e

# Ensure we're in the working directory
cd /code

# Create necessary files with proper permissions
touch submission_solution.py stress_tests_generation.py run_tests.py reference_solution.py
chmod 666 submission_solution.py stress_tests_generation.py run_tests.py reference_solution.py

chown coderunner:root submission_solution.py stress_tests_generation.py run_tests.py reference_solution.py

# Save submitted code to a file
#echo "$CODE" > submission_solution.py

# Print debugging information
#ls -l

# Generate test cases (you'll need to implement this part)
#pwd
#ls -l
#python3 generate_stress_tests.py

# Run tests with timeout and resource constraints
#timeout 5s python3 -m pytest test_cases.py
python run_tests.py