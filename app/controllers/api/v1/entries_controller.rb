class Api::V1::EntriesController < ApplicationController
  before_action :set_entry, only: %i[show update destroy]
  before_action :set_ticket
  before_action :authenticate_user

  # GET /projects/:project_id/tickets/:ticket_id/entries
  # Fetch all entries associated with ticket id
  # Available for all members of project
  def index
    if ProjectUser.verify_role(current_user.id, @ticket.project_id, "client")
      @entries = Entry.all_for_ticket(@ticket)
      render json: @entries, status: 200
    else
      render json: {error: "You must be a member of a project to see its content"}, status: :unauthorized
    end
  end

  # GET /projects/:project_id/tickets/:ticket_id/entries/:id
  # Available for all members of project
  def show
    if ProjectUser.verify_role(current_user.id, @ticket.project_id, "client")
      render json: @entry, status: 200
    else
      render json: {error: "You must be a member of a project to see its content"}, status: :unauthorized
    end
  end

  # POST /projects/:project_id/tickets/:ticket_id/entries
  # Available for ticket author, and members greater than developer
  def create
    if @ticket.user_id == current_user.id || ProjectUser.verify_role(current_user.id, @ticket.project_id, "developer")
      @entry = Entry.new(entry_params)
      @entry.user_id = current_user.id
      @entry.ticket_id = @ticket.id # params[:ticket_id]
      if @entry.save
        render json: @entry, status: :created
      else
        render json: @entry.errors, status: :unprocessable_entity
      end
    else
      render json: {error: "You must be the entry author, or on the project team to edit this"}, status: :unauthorized
    end
  end

  # PATCH/PUT /projects/:project_id/tickets/:ticket_id/entries/:id
  # Available for ticket author, and members greater than admin
  def update
    if @ticket.user_id == current_user.id || ProjectUser.verify_role(current_user.id, @ticket.project_id, "admin")
      if @entry.update(entry_params)
        render json: @entry, status: 200
      else
        render json: @entry.errors, status: :unprocessable_entity
      end
    else
      render json: {error: "You must be the entry author, or on the admin team to edit this"}, status: :unauthorized
    end
  end

  # DELETE /projects/:project_id/tickets/:ticket_id/entries/:id
  # Available for ticket author, and members greater than admin
  def destroy
    if @ticket.user_id == current_user.id || ProjectUser.verify_role(current_user.id, @ticket.project_id, "admin")
      @entry.destroy
    else
      render json: {error: "You must be the entry author, or on the admin team to edit this"}, status: :unauthorized
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find_by_id(params[:ticket_id])
  end

  def set_entry
    @entry = Entry.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:subject, :body)
  end
end
