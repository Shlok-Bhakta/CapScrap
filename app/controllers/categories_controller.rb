class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]

  # GET /categories or /categories.json
  def index
    logger.debug "#{current_user.email} IS VIEWING THE CATEGORIES PAGE:"
    @categories = Category.all
  end

  # GET /categories/1 or /categories/1.json
  def show
    logger.debug "#{current_user.email} IS VIEWING THE CATEGORY INFORMATION: #{@category.attributes.inspect}"
  end

  # GET /categories/new
  def new
    @category = Category.new
    logger.debug "#{current_user.email} IS VIEWING THE NEW CATEGORY INFORMATION: #{@category.attributes.inspect}"
  end

  # GET /categories/1/edit
  def edit
    logger.debug "#{current_user.email} IS EDITING THE CATEGORY INFORMATION: #{@category.attributes.inspect}"
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new(category_params)
    logger.debug "#{current_user.email} IS CREATING THE CATEGORY INFORMATION: #{@category.attributes.inspect}"

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: "Category was successfully created." }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: "Category was successfully updated." }
        format.json { render :show, status: :ok, location: @category }
        logger.debug "#{current_user.email} IS UPDATING THE CATEGORY INFORMATION: #{@category.attributes.inspect}"
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    @category.destroy!
    logger.debug "#{current_user.email} IS DELETING THE CATEGORY INFORMATION: #{@category.attributes.inspect}"

    respond_to do |format|
      format.html { redirect_to categories_path, status: :see_other, notice: "Category was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.expect(category: [ :name ])
    end
end
