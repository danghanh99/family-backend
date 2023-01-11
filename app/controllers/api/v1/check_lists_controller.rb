class Api::V1::CheckListsController < ApplicationController
  before_action :set_check_list, only: %i[show update destroy]

  # GET /check_lists
  def index
    check_lists = @current_user.check_lists
    render_collection check_lists, CheckListSerializer
  end

  # GET /check_lists/1
  def show
    render_resource @check_list, :ok, CheckListSerializer
  end

  # POST /check_lists
  def create
    @check_list = CheckList.new(check_list_params)
    @check_list.user_id = @current_user.id

    if @check_list.save
      # render json: @check_list, status: :created
      render_resource @check_list, :created, CheckListSerializer
    else
      render json: @check_list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /check_lists/1
  def update
    if @check_list.update(check_list_params)
      render json: @check_list
    else
      render json: @check_list.errors, status: :unprocessable_entity
    end
  end

  # DELETE /check_lists/1
  def destroy
    @check_list.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_check_list
    @check_list = CheckList.find(params[:id])
  end

  def check_list_params
    params.permit :name
  end
end
