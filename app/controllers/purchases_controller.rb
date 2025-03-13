class PurchasesController < ApplicationController
  before_action :set_purchase, only: %i[ show edit update destroy ]

  # GET /purchases or /purchases.json
  def index
    logger.debug "#{current_user.email} IS VIEWING THE PURCHASE PAGE:"
    if params[:sort].present?
      @purchases = Purchase.order(params[:sort] => :desc)
    else
      @purchases = Purchase.all
    end
  end

  # GET /purchases/1 or /purchases/1.json
  def show
    logger.debug "#{current_user.email} IS VIEWING THE PURCHASE INFORMATION: #{@purchase.attributes.inspect}"
  end

  # GET /purchases/new
  def new
    logger.debug "#{current_user.email} IS VIEWING THE NEW PURCHASE INFORMATION: #{@purchase.attributes.inspect}"
    @purchase = Purchase.new
  end

  # GET /purchases/1/edit
  def edit
    logger.debug "#{current_user.email} IS EDITING THE PURCHASE INFORMATION: #{@purchase.attributes.inspect}"
  end

  # POST /purchases or /purchases.json
  def create
    @purchase = Purchase.new(purchase_params)

    respond_to do |format|
      if @purchase.save
        format.html { redirect_to @purchase, notice: "Purchase was successfully created." }
        format.json { render :show, status: :created, location: @purchase }
        logger.debug "#{current_user.email} IS CREATING THE PURCHASE INFORMATION: #{@purchase.attributes.inspect}"
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /purchases/1 or /purchases/1.json
  def update
    respond_to do |format|
      if @purchase.update(purchase_params)
        format.html { redirect_to @purchase, notice: "Purchase was successfully updated." }
        format.json { render :show, status: :ok, location: @purchase }
        logger.debug "#{current_user.email} IS UPDATING THE PURCHASE INFORMATION: #{@purchase.attributes.inspect}"
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1 or /purchases/1.json
  def destroy
    @purchase.destroy!

    logger.debug "#{current_user.email} IS DELETING THE PURCHASE INFORMATION: #{@purchase.attributes.inspect}"

    respond_to do |format|
      format.html { redirect_to purchases_path, status: :see_other, notice: "Purchase was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def purchase_params
      params.expect(purchase: [ :user_id, :item_id, :purchase_date, :purchased_quantity ])
    end
end
