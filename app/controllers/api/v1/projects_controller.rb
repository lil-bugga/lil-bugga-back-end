class Api::V1::ProjectsController < ApplicationController
  before_action :set_project, only: %i[show update destroy]
  # Require JWT bearer token in header
  before_action :authenticate_user

  # GET /projects
  # This is a scaffold method, will need refactoring to identify projects based on users
  def index
    @projects = Project.all

    render json: @projects.to_json(include: :project_detail)
  end

  # GET /projects/1
  def show
    if @project
      render json: @project.to_json(include: :project_detail), status: 200
    else
      render json: { error: "no project found with id of #{params[:id]}" }, status: 404
    end
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
    # Do not save project if no project details have been passed
    if @project.project_detail
      if @project.save
        render json: @project, status: :created
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "A project must have a name" }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      render json: @project.to_json(include: :project_detail), status: 200
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
  end

  private

  def set_project
    # Find by null returns null value if not found, rather than find which returns an exception
    @project = Project.find_by_id(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :user_id, :status,
      project_detail_attributes: [:project_name, :description]
    )
  end
end
