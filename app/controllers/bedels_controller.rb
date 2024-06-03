# The controller for the Bedel model, instance of User
class BedelsController < ApplicationController
  before_action :set_bedel, only: %i[show update destroy]

  # GET /bedels
  # Will serve as a filter for the bedels
  # The bedels will be filtered by the turno and/or apellido
  def index
    # Case insensitive search

    @bedels = User.bedels.where(bedel_params.slice(:turno, :apellido))
    # Only show id, turno, nombre, apellido
    render json: @bedels
  end

  # GET /bedels/id
  def show
    # Only show safe params

    render json: @bedel
  end

  # POST /bedels
  def create
    @bedel = User.new_bedel(bedel_params)

    if @bedel.save
      render json: @bedel, status: :created
    else
      render json: @bedel.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique
    render json: { error: 'Identificador Repetido' }, status: :unprocessable_entity
  end

  # PATCH/PUT /bedels/id
  def update
    if @bedel.update(bedel_params)
      render json: @bedel
    else
      render json: @bedel.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bedels/id
  def destroy
    @bedel.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bedel
    @bedel = User.bedels.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  # Allow the following parameters: id , turno, nombre, apellido, password
  def bedel_params
    params[:nombre] = params[:nombre].capitalize if params[:nombre]
    params[:apellido] = params[:apellido].capitalize if params[:apellido]
    params[:turno] = params[:turno].downcase
    params.permit(:id, :turno, :nombre, :apellido, :password)
  end
end
