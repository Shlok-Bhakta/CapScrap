class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]

  # GET /items or /items.json
  def index
    logger.debug "#{current_user.email} IS VIEWING THE ITEMS PAGE:"
    if params[:query].present?
      # Search by ID if the input is numeric; otherwise, search by name
      @items = params[:query].match?(/^\d+$/) ? Item.where(id: params[:query]) : Item.where("description ILIKE ?", "%#{params[:query]}%")
    elsif params[:sort].present?
      @items = Item.order(params[:sort] => :asc)
    else
      @items = Item.all
    end
  end

  # GET /items/1 or /items/1.json
  def show
     logger.debug "#{current_user.email} IS VIEWING THE ITEM INFORMATION: #{@item.attributes.inspect}"
  end

  # GET /items/new
  def new
    @item = Item.new
    logger.debug "#{current_user.email} IS VIEWING THE NEW ITEM INFORMATION: #{@item.attributes.inspect}"
  end

  # GET /items/1/edit
  def edit
    logger.debug "#{current_user.email} IS EDITING THE ITEM INFORMATION: #{@item.attributes.inspect}"
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
        logger.debug "#{current_user.email} IS CREATING THE ITEM INFORMATION: #{@item.attributes.inspect}"
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
        logger.debug "#{current_user.email} IS UPDATING THE ITEM INFORMATION: #{@item.attributes.inspect}"
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy!
    logger.debug "#{current_user.email} IS DELETING THE ITEM INFORMATION: #{@item.attributes.inspect}"

    respond_to do |format|
      format.html { redirect_to items_path, status: :see_other, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.expect(item: [ :category_id, :description, :location ])
    end
end
