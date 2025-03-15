class RolesController < ApplicationController
  before_action :set_role, only: %i[ show edit update destroy ]

  # GET /roles or /roles.json
  def index
    @roles = Role.all
    logger.debug "#{current_user.email} IS VIEWING THE ROLES PAGE:"
  end

  # GET /roles/1 or /roles/1.json
  def show
    logger.debug "#{current_user.email} IS VIEWING THE ROLE INFORMATION: #{@role.attributes.inspect}"
  end

  # GET /roles/new
  def new
    @role = Role.new
    logger.debug "#{current_user.email} IS VIEWING THE NEW ROLE INFORMATION: #{@role.attributes.inspect}"
  end

  # GET /roles/1/edit
  def edit
    logger.debug "#{current_user.email} IS EDITING THE ROLE INFORMATION: #{@role.attributes.inspect}"
  end

  # POST /roles or /roles.json
  def create
    @role = Role.new(role_params)

    respond_to do |format|
      if @role.save
        format.html { redirect_to @role, notice: "Role was successfully created." }
        format.json { render :show, status: :created, location: @role }
        logger.debug "#{current_user.email} IS CREATING THE ROLE INFORMATION: #{@role.attributes.inspect}"
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /roles/1 or /roles/1.json
  def update
    respond_to do |format|
      if @role.update(role_params)
        format.html { redirect_to @role, notice: "Role was successfully updated." }
        format.json { render :show, status: :ok, location: @role }
        logger.debug "#{current_user.email} IS UPDATING THE ROLE INFORMATION: #{@role.attributes.inspect}"
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1 or /roles/1.json
  def destroy
    @role.destroy!
    logger.debug "#{current_user.email} IS DESTROYING THE ROLE INFORMATION: #{@role.attributes.inspect}"

    respond_to do |format|
      format.html { redirect_to roles_path, status: :see_other, notice: "Role was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role
      @role = Role.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def role_params
      params.expect(role: [ :name ])
    end
end
