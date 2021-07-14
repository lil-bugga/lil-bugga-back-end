class Api::V1::EntriesController < ApplicationController
  before_action :set_entry, only: %i[show update destroy]

  # GET /entries
  # This is a scaffold method, will need refactoring to get entries relative to ticket
  def index
    @entries = Entry.all
    render json: @entries
  end

  # GET /entries/1
  def show
    render json: @entry
  end

  # POST /entries
  def create
    @entry = Entry.new(entry_params)

    if @entry.save
      render json: @entry, status: :created
    else
      render json: @entry.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /entries/1
  def update
    if @entry.update(entry_params)
      render json: @entry
    else
      render json: @entry.errors, status: :unprocessable_entity
    end
  end

  # DELETE /entries/1
  def destroy
    @entry.destroy
  end

  private

  def set_entry
    @entry = Entry.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:ticket_id, :author_id, :subject_string, :body)
  end
end
