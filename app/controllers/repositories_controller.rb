class RepositoriesController < ApplicationController
  def index
    @repositories = Repository.default_order
  end

  def show
    @repository = Repository.find(params.except(:id))
  end

  def new
    @repository = Repository.new
  end

  def create
    @repository = Repository.new(repository_params)
    if @repository.save
      redirect_to @repository, notice: '保存しました'
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def repository_params
    params.expect(repository: [:url])
  end
end
