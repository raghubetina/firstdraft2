class Project::Table::ColumnsController < ApplicationController
  before_action :set_project_table_column, only: %i[ show edit update destroy ]

  # GET /project/table/columns or /project/table/columns.json
  def index
    @project_table_columns = Project::Table::Column.all
  end

  # GET /project/table/columns/1 or /project/table/columns/1.json
  def show
  end

  # GET /project/table/columns/new
  def new
    @project_table_column = Project::Table::Column.new
  end

  # GET /project/table/columns/1/edit
  def edit
  end

  # POST /project/table/columns or /project/table/columns.json
  def create
    @project_table_column = Project::Table::Column.new(project_table_column_params)

    respond_to do |format|
      if @project_table_column.save
        format.html { redirect_to @project_table_column.table, notice: "Column was successfully created." }
        format.json { render :show, status: :created, location: @project_table_column }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project_table_column.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project/table/columns/1 or /project/table/columns/1.json
  def update
    respond_to do |format|
      if @project_table_column.update(project_table_column_params)
        format.html { redirect_to project_table_column_url(@project_table_column), notice: "Column was successfully updated." }
        format.json { render :show, status: :ok, location: @project_table_column }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project_table_column.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project/table/columns/1 or /project/table/columns/1.json
  def destroy
    @project_table_column.destroy

    respond_to do |format|
      format.html { redirect_to project_table_columns_url, notice: "Column was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_table_column
      @project_table_column = Project::Table::Column.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def project_table_column_params
      params.require(:project_table_column).permit(:type, :name, :primary_descriptor, :table_id, :unique_identifier)
    end
end
