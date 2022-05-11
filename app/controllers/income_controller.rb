class IncomeController < ApplicationController
	before_action :set_income, only: %i[ show edit update destroy ]

  # GET /incomes 
  def index
    @incomes = Income.where(predefined: true).or(Income.with_user(current_user.id))
  end

  # GET /incomes/1 
  def show

  end

  # GET /incomes/new
  def new
    @income = Income.new
  end

  # GET /incomes/1/edit
  def edit
    @income = Income.find_by(id: params[:id])
  end

  # POST /expences or /expences.json
  def create
    @expence = Expence.new(expence_params)
    @expence.user_id = current_user.id
    @expence.predefined = false

    respond_to do |format|
      if @expence.save
        format.html { redirect_to expence_url(@expence), notice: "Expence was successfully created." }
        format.json { render :show, status: :created, location: @expence }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expence.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expences/1 or /expences/1.json
  def update
    respond_to do |format|
      if @expence.update(expence_params)
        format.html { redirect_to expence_url(@expence), notice: "Expence was successfully updated." }
        format.json { render :show, status: :ok, location: @expence }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expence.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expences/1 or /expences/1.json
  def destroy
    return if @expence.predefined == true
    @expence.destroy

    respond_to do |format|
      format.html { redirect_to expences_url, notice: "Expence was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expence
      @expence = Expence.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def expence_params
      params.require(:expence).permit(:name, :description, :id, :user_id)
    end
end
