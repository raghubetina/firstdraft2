class Project::Table::Relationship::DirectsController < ApplicationController
  before_action :set_project_table_relationship_direct, only: %i[show edit update destroy]

  # GET /project/table/relationship/directs or /project/table/relationship/directs.json
  def index
    @project_table_relationship_directs = Project::Table::Relationship::Direct.all
  end

  # GET /project/table/relationship/directs/1 or /project/table/relationship/directs/1.json
  def show
  end

  # GET /project/table/relationship/directs/new
  def new
    @project_table_relationship_direct = Project::Table::Relationship::Direct.new
  end

  # GET /project/table/relationship/directs/1/edit
  def edit
  end

  # POST /project/table/relationship/directs or /project/table/relationship/directs.json
  def create
    @project_table_relationship_direct = Project::Table::Relationship::Direct.new(project_table_relationship_direct_params)

    respond_to do |format|
      if @project_table_relationship_direct.save
        format.html { redirect_to project_table_relationship_direct_url(@project_table_relationship_direct), notice: "Direct was successfully created." }
        format.json { render :show, status: :created, location: @project_table_relationship_direct }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project_table_relationship_direct.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project/table/relationship/directs/1 or /project/table/relationship/directs/1.json
  def update
    respond_to do |format|
      if @project_table_relationship_direct.update(project_table_relationship_direct_params)
        format.html { redirect_to project_table_relationship_direct_url(@project_table_relationship_direct), notice: "Direct was successfully updated." }
        format.json { render :show, status: :ok, location: @project_table_relationship_direct }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project_table_relationship_direct.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project/table/relationship/directs/1 or /project/table/relationship/directs/1.json
  def destroy
    @project_table_relationship_direct.destroy

    respond_to do |format|
      format.html { redirect_to project_table_relationship_directs_url, notice: "Direct was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_project_table_relationship_direct
    @project_table_relationship_direct = Project::Table::Relationship::Direct.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def project_table_relationship_direct_params
    params.require(:project_table_relationship_direct).permit(:origin_id, :destination_id, :scope_id, :name, :foreign_key_id, :key_id, :polymorphic, :foreign_key_owner_id, :dependent, :touch_option, :optional, :cardinality, :counter_cache, :type)
  end
end
