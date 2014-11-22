class SiteDataController < ApplicationController
  before_action :set_site_datum, only: [:show, :edit, :update, :destroy]

  # GET /site_data
  # GET /site_data.json
  def index
    @site_data = SiteDatum.all
  end

  # GET /site_data/1
  # GET /site_data/1.json
  def show
  end

  # GET /site_data/new
  #NO MORE NEW ONES
 # def new
 #   @site_datum = SiteDatum.new
 # end

  # GET /site_data/1/edit
  def edit
  end

  #NO MORE NEW ONES
  # POST /site_data
  # POST /site_data.json
  #def create
  #  @site_datum = SiteDatum.new(site_datum_params)

  #  respond_to do |format|
  #    if @site_datum.save
  #      format.html { redirect_to @site_datum, notice: 'Site datum was successfully created.' }
  #      format.json { render :show, status: :created, location: @site_datum }
  #    else
  #      format.html { render :new }
  #      format.json { render json: @site_datum.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # PATCH/PUT /site_data/1
  # PATCH/PUT /site_data/1.json
  def update
    respond_to do |format|
      if @site_datum.update(site_datum_params)
        format.html { redirect_to @site_datum, notice: 'Site datum was successfully updated.' }
        format.json { render :show, status: :ok, location: @site_datum }
      else
        format.html { render :edit }
        format.json { render json: @site_datum.errors, status: :unprocessable_entity }
      end
    end
  end

  # CANNOT DELETE
  # DELETE /site_data/1
  # DELETE /site_data/1.json
  #def destroy
  #  @site_datum.destroy
  #  respond_to do |format|
  #    format.html { redirect_to site_data_url, notice: 'Site datum was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site_datum
      @site_datum = SiteDatum.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_datum_params
      params.require(:site_datum).permit(:inventory, :pappy, :pappyType)
    end
end
