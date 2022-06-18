require "rails_helper"

RSpec.describe ApplicationJob, :type => :job do
  describe "#perform_later" do
    it "uploads a backup" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        ApplicationJob.perform_later('backup')
      }.to have_enqueued_job
    end
  end
end