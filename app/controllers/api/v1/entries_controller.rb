class Api::V1::EntriesController < ApplicationController
  before_action :set_entry, only: %i[show update destroy]
  before_action :set_ticket, only: %i[index create]
  before_action :authenticate_user

  # GET /projects/:project_id/tickets/:ticket_id/entries
  # Fetch all entries associated with ticket id
  def index
    @entries = Entry.all_for_ticket(@ticket)
    render json: @entries
  end

  # GET /projects/:project_id/tickets/:ticket_id/entries/:id
  def show
    render json: @entry
  end

  # POST /projects/:project_id/tickets/:ticket_id/entries
  def create
    @entry = Entry.new(entry_params)
    @entry.user_id = current_user.id
    @entry.ticket_id = @ticket # params[:ticket_id]

    if @entry.save
      render json: @entry, status: :created
    else
      render json: @entry.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/:project_id/tickets/:ticket_id/entries/:id
  def update
    if current_user.id == @entry.user_id
      if @entry.update(entry_params)
        render json: @entry
      else
        render json: @entry.errors, status: :unprocessable_entity
      end
    else
      render json: {error: "Only the entries author can edit this entry"}
    end
  end

  # DELETE /projects/:project_id/tickets/:ticket_id/entries/:id
  def destroy
    if current_user.id == @entry.user_id
      @entry.destroy
    else
      render json: {error: "Only the entries author can delete this entry"}
    end
  end

  private

  def set_ticket
    @ticket = params[:ticket_id]
  end

  def set_entry
    @entry = Entry.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:subject, :body)
  end
end
