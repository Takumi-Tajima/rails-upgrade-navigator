class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.default_order
  end

  def show
    @repository = Repository.find(params[:id])
  end

  def new
    @repository = Repository.new
  end

  def create
    @repository = Repository.find_or_initialize_by(url: repository_params[:url])
    @repository.save!
    RepositoryAnalyzeJob.perform_later(@repository)
    redirect_to @repository, notice: '解析を開始しました'
  rescue ActiveRecord::RecordInvalid
    render :new, status: :unprocessable_content
  end

  private

  def repository_params
    params.expect(repository: [:url])
  end
end
