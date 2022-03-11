class Project::Table::ColumnsController < ApplicationController
  before_action :set_column, only: %i[show edit update destroy]

  # GET /project/table/columns or /project/table/columns.json
  def index
    @columns = Project::Table::Column.all
  end

  # GET /project/table/columns/1 or /project/table/columns/1.json
  def show
  end

  # GET /project/table/columns/new
  def new
    @column = Project::Table::Column.new
  end

  # GET /project/table/columns/1/edit
  def edit
  end

  # POST /project/table/columns or /project/table/columns.json
  def create
    @column = Project::Table::Column.new(column_params)

    respond_to do |format|
      if @column.save
        format.html { redirect_to table_url(@column.table), notice: "Column was successfully created." }
        format.json { render :show, status: :created, location: @column }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @column.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /project/table/columns/1 or /project/table/columns/1.json
  def update
    respond_to do |format|
      if @column.update(column_params)
        format.html { redirect_to column_url(@column), notice: "Column was successfully updated." }
        format.json { render :show, status: :ok, location: @column }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @column.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project/table/columns/1 or /project/table/columns/1.json
  def destroy
    @column.destroy

    respond_to do |format|
      format.html { redirect_to columns_url, notice: "Column was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_column
    @column = Project::Table::Column.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def column_params
    params.require(:project_table_column).permit(:type, :name, :primary_descriptor, :table_id, :unique_identifier)
  end
end
