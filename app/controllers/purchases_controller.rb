class PurchasesController < ApplicationController
  before_action :set_purchase, only: %i[ show edit update destroy ]

  # GET /purchases or /purchases.json
  def index
    if params[:sort].present?
      @purchases = Purchase.order(params[:sort] => :desc)
    else
      @purchases = Purchase.all
    end
  end

  # GET /purchases/1 or /purchases/1.json
  def show
    log_view(@item)
  end

  # GET /purchases/new
  def new
    @purchase = Purchase.new
  end

  # GET /purchases/1/edit
  def edit
  end

  # POST /purchases or /purchases.json
  def create
    @purchase = Purchase.new(purchase_params)

    respond_to do |format|
      if @purchase.save
        format.html { redirect_to @purchase, notice: "Purchase was successfully created." }
        format.json { render :show, status: :created, location: @purchase }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchases/1 or /purchases/1.json
  def update
    data = JSON.parse(request.body.read)["purchase"]
    if @purchase.update(purchased_quantity: data["purchased_quantity"])
      render json: { success: true, message: "Purchase updated successfully" }
    else
      render json: {
        success: false,
        error: @purchase.errors.full_messages.join(", ")
      }, status: :unprocessable_entity
    end
  end

  # DELETE /purchases/1 or /purchases/1.json
  def destroy
    if @purchase.destroy
      respond_to do |format|
        format.html { redirect_to admin_dashboard_purchased_path, notice: "Purchase was successfully destroyed." }
        format.json { render json: { success: true, message: "Purchase was successfully destroyed" } }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_dashboard_purchased_path, alert: "Failed to delete purchase." }
        format.json { render json: { success: false, error: "Failed to delete purchase" }, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find(params.require(:id))
    end

    # Only allow a list of trusted parameters through.
    def purchase_params
      params.require(:purchase).permit(:user_id, :item_id, :purchase_date, :purchased_quantity)
    end
end
