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
    @repository.analyze
    redirect_to @repository, notice: '解析が完了しました'
  rescue GemfileLockNotFoundError, InvalidRepositoryError => e
    @repository.errors.add(:base, e.message)
    render :new, status: :unprocessable_content
  end

  private

  def repository_params
    params.expect(repository: [:url])
  end
end
