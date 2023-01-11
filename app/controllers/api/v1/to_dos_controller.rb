class Api::V1::ToDosController < ApplicationController
  before_action :set_to_do, only: %i[show update destroy]

  # GET /to_dos
  def index
    to_dos = ToDo.all

    render json: to_dos
  end

  # GET /to_dos/1
  def show
    render json: @to_do
  end

  # POST /to_dos
  def create
    to_do = ToDo.new(to_do_params)
    to_do.user_id = @current_user.id

    if to_do.save
      render json: to_do, status: :created
    else
      render json: to_do.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /to_dos/1
  def update
    if @to_do.update(update_to_do_params)
      render json: @to_do
    else
      render json: @to_do.errors, status: :unprocessable_entity
    end
  end

  # DELETE /to_dos/1
  def destroy
    @to_do.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_to_do
    @to_do = ToDo.find(params[:id])
  rescue StandardError => e
    render json: {
             error: e.message
           },
           status: :bad_request
  end

  # Only allow a list of trusted parameters through.
  def to_do_params
    params.permit :todo_text, :is_done, :check_list_id
  end

  def update_to_do_params
    params.permit :todo_text, :is_done
  end
end
