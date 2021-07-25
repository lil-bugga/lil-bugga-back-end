class Api::V1::ProjectsController < ApplicationController
  # before_action :set_project, only: %i[show update destroy get_users add_users remove_users]
  before_action :set_project, except: %i[index create]
  before_action :user_params, only: %i[add_users remove_users update_users]
  # Require JWT bearer token in header
  before_action :authenticate_user

  # GET /projects
  # Returns all projects for which the user is associated
  def index
    @projects = Project.all_for_user(current_user.id)
    render json: @projects.to_json(include: :project_detail), status: 200
  end

  # GET /projects/:id
  # Only viewable by members of the project
  def show
    if @project
      if ProjectUser.verify_role(current_user.id, @project, 'client')
        render json: Project.build_project_object(@project, current_user.id), status: 200
      else
        render json: { error: 'You must be a member of a project to see its content' }, status: :unauthorized
      end
    else
      render json: { error: "no project found with id of #{params[:id]}" }, status: 404
    end
  end

  # POST /projects
  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id
    # Do not save project if no project details have been passed
    if @project.project_detail
      if @project.save
        render json: @project, status: :created
      else
        render json: @project.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'A project must have a name' }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/:id
  # Should be accessible to owner role only
  def update
    if @project
      if ProjectUser.verify_role(current_user.id, @project, 'owner')
        if @project.update(project_params)
          render @project.to_json(include: :project_detail), status: 200
        else
          render json: @project.errors, status: :unprocessable_entity
        end
      else
        render json: { error: 'Only the project owner can update its details' }, status: :unauthorized
      end
    else
      render json: { error: "no project found with id of #{params[:id]}" }, status: 404
    end
  end

  # GET /projects/:id/users
  # Should be accessible to all users on the project
  def get_users
    if @project
      if ProjectUser.verify_role(current_user.id, @project, 'client')
        render json: @project.project_users, status: 200
      else
        render json: { error: 'You must be a member of a project to see its content' }, status: :unauthorized
      end
    else
      render json: { error: "no project found with id of #{params[:id]}" }, status: 404
    end
  end

  # POST /projects/:id/users
  # Accessible only to the project owner
  # Limited to owner listed in project, to prevent accidental demotion of self from owner.
  def add_users
    if @project.user_id == current_user.id
      success = []
      errors = []
      @users.each do |user|
        new_user = create_user(user, @project)
        new_user.valid? ? success << new_user : errors << new_user.errors
      end
      if errors.empty?
        success.each { |user| user.save }
        render json: @project.project_users, status: :created
      else
        render json: { errors: errors }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Only the project owner can edit project users' }, status: :unauthorized
    end
  end

  # DELETE /projects/:id/users
  # Accessible only to the project owner
  # Limited to owner listed in project, to prevent accidental demotion of self from owner.
  def remove_users
    if @project.user_id == current_user.id
      success = []
      errors = []
      @users.each do |user|
        extract_user = extract_user_id(user)
        if extract_user.nil?
          errors << { error: 'User does not exist' }
        else
          project_user = ProjectUser.find_user_in_project(extract_user, @project)
          project_user.exists? ? success << project_user.ids : errors << { error: 'User does not have an assigned role in the project' }
        end
      end
      if errors.empty?
        ProjectUser.destroy(success)
        success.each.destroy
        render json: @project.project_users, status: :created
      else
        render json: { errors: errors }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Only the project owner can edit project users' }, status: :unauthorized
    end
  end

  # PATCH /projects/:id/users
  # Accessible only to the project owner
  # Limited to owner listed in project, to prevent accidental demotion of self from owner.
  def update_users
    if @project.user_id == current_user.id
      success = []
      errors = []
      @users.each do |user|
        extract_user = extract_user_id(user)
        if extract_user.nil?
          errors << { error: 'User does not exist' }
        else
          project_user = ProjectUser.find_user_in_project(extract_user, @project).first
          if project_user.nil?
            errors << { error: 'User does not have an assigned role in the project' }
          else
            project_user.role = user[:role]
            project_user.valid? ? success << project_user : errors << project_user.errors
          end
        end
      end
      if errors.empty?
        # Save is bad and shouldnt work, but update wont so here it is.
        success.each { |user| user.save }
        render json: @project.project_users, status: :created
      else
        render json: { errors: errors }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Only the project owner can edit project users' }, status: :unauthorized
    end
  end

  # DELETE /projects/1
  # Accessible only to the project owner
  # Limited to owner listed in project, to maintain highest level of integrity possible.
  def destroy
    if @project.user_id == current_user.id
      @project.destroy
    else
      render json: { error: 'Only the project owner can delete the project' }, status: :unauthorized
    end
  end

  private

  def set_project
    # Find by null returns null value if not found, rather than find which returns an exception
    @project = Project.find_by_id(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :status,
      project_detail_attributes: %i[project_name description]
    )
  end

  def user_params
    @users = params.require(:project).permit(
      project_users_attributes: %i[user_id role email]
    )[:project_users_attributes]
  end

  # Extract id from passed user object, or lookup by passed email address, cache results and return nil if not found
  def extract_user_id(params)
    User.find_by_id(params[:user_id]) || User.find_by_email(params[:email]) || nil
  end

  def create_user(user, project)
    new_user = project.project_users.new
    extract = extract_user_id(user)
    new_user.user_id = extract.id unless extract.nil?
    new_user.role = user[:role]
    new_user
  end
end
