require 'pivotal-tracker'
require 'json'
require 'dotenv'
Dotenv.load

class Pivotal

  def initialize
    PivotalTracker::Client.token = ENV["PIVOTAL_API_TOKEN"]
    @project = PivotalTracker::Project.find(ENV["PIVOTAL_PROJECT_ID"])
  end

  def cards(options = {})
    @project.stories.all(options)
  end
end