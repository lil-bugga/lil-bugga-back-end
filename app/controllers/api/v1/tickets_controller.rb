class Api::V1::TicketsController < ApplicationController
  # before_action :set_ticket, only: %i[show update destroy]
  before_action :set_ticket, only: %i[show update destroy]
  before_action :set_project, only: %i[index create update]
  before_action :authenticate_user

  # GET /projects/:project_id/tickets
  # Fetch all tickets associated with project id
  # Authority limited to members of project
  def index
    if @project
      if ProjectUser.verify_role(current_user.id, @project, 'client')
        @tickets = Ticket.all_for_project(@project)
        render json: @tickets
      else
        render json: { error: 'You are not authorised' }, status: :unauthorized
      end
    else
      render json: { error: "no project found with id of #{params[:project_id]}" }, status: 404
    end
  end

  # GET /tickets/user
  # Fetch all tickets for current user
  def index_user
    @tickets = Ticket.all_for_user(current_user.id)
    render json: @tickets
  end

  # GET /tickets/all
  # Fetch all tickets
  def index_all
    @tickets = Ticket.all
    render json: @tickets
  end

  # GET /projects/:project_id/tickets/:id
  # Requires a user to have a role within the project
  def show
    if @ticket
      if ProjectUser.verify_role(current_user.id, @project, 'client')
        render json: @ticket.to_json(include: :entries)
      else
        render json: { error: 'You are not authorised' }, status: :unauthorized
      end
    else
      render json: { error: "no ticket found with id of #{params[:project_id]}" }, status: 404
    end
  end

  # POST /projects/:project_id/tickets
  # No JSON body is required
  # User must be a member of the project
  def create
    if ProjectUser.verify_role(current_user.id, @project, 'client')
      @ticket = Ticket.new(new_ticket_params)
      @ticket.user_id = current_user.id
      @ticket.project_id = @project # params[:project_id]

      if @ticket.save
        render json: @ticket, status: :created
      else
        render json: @ticket.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorised' }, status: :unauthorized
    end
  end

  # PATCH/PUT /projects/:project_id/tickets/:id
  # User must be the ticket author, or a project admin
  # Need a way for developers to affect status of project
  def update
    if current_user.id == @ticket.user_id || ProjectUser.verify_role(current_user.id, @project, 'developer')
      if params[:ticket][:status] == 'closed'
        # Unless doesn't work, but if! does for some reason?
        if !ProjectUser.verify_role(current_user.id, @project, 'owner')
          render json: { error: 'You are not authorised' }, status: :unauthorized
          return
        end
      end
      if @ticket.update(ticket_params)
        render json: @ticket
      else
        render json: @ticket.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorised' }, status: :unauthorized
    end
  end

  # DELETE /projects/:project_id/tickets/:id
  # Limited to author and project admins
  def destroy
    if current_user.id == @ticket.user_id || ProjectUser.verify_role(current_user.id, @project, 'admin')
      @ticket.destroy
    else
      render json: { error: 'You are not authorised' }, status: :unauthorized
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find_by_id(params[:id])
  end

  def set_project
    @project = params[:project_id]
  end

  def ticket_params
    params.require(:ticket).permit(:status)
  end

  # Allows a new ticket to be created with a blank POST request, or set with defined status
  def new_ticket_params
    params.require(:ticket).permit(:status) if params[:ticket].present?
  end
end
