class RepositoryAnalyzeJob < ApplicationJob
  queue_as :default

  def perform(repository)
    repository.analyze
  end
end
