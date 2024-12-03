class CodeExecutionJob < ApplicationJob
  queue_as :default

  def perform(submission_id)
    submission = Submission.find(submission_id)
    submission.update(status: 'running')
    CodeExecutionService.new(submission).execute
  rescue StandardError => e
    submission.update(status: 'error')

    Rails.logger.error("Submission execution error: #{e.message}")
  end
end