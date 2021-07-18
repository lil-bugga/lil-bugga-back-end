class Api::V1::TicketsController < ApplicationController
  # before_action :set_ticket, only: %i[show update destroy]
  before_action :set_ticket, only: %i[show update destroy]
  before_action :set_project, only: %i[index create]
  before_action :authenticate_user

  # GET /projects/:project_id/tickets
  # Fetch all tickets associated with project id
  def index
    @tickets = Ticket.all_for_project(@project)
    render json: @tickets
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
  def show
    render json: @ticket.to_json(include: :entries)
  end

  # POST /projects/:project_id/tickets
  # No body required
  def create
    @ticket = Ticket.new(new_ticket_params)
    @ticket.user_id = current_user.id
    @ticket.project_id = @project # params[:project_id]

    if @ticket.save
      render json: @ticket, status: :created
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/:project_id/tickets/:id
  def update
    if @ticket.update(ticket_params)
      render json: @ticket
    else
      render json: @ticket.errors, status: :unprocessable_entity
    end
  end

  # DELETE /projects/:project_id/tickets/:id
  def destroy
    @ticket.destroy
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
