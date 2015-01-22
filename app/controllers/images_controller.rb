class ImagesController < ApplicationController
  before_action :set_image, only: [:show, :edit, :update, :destroy]

  def location
    images = Image.all 
    @lat = params[:latitude]
    @lng = params[:longitude]
    @coords = [ @lat, @lng ]
    bearing_to_letters = 'N.png'
    @warmest = []
    @warmer = []
    @warm = []
    @cold_10 = []
    @cold_15 = []
    @cold = []
    images.each do |image|
      user_location = [@lat,@lng]
      ll = [image.latitude, image.longitude]
      distance = Geocoder::Calculations.distance_between(user_location, ll)
      bearing = Geocoder::Calculations.bearing_between(user_location, ll) 
      if bearing > 337 || bearing < 23
        bearing_to_letters = 'N.png'
      elsif bearing < 67
        bearing_to_letters = 'NE.png'
      elsif bearing < 112
        bearing_to_letters = 'E.png'
      elsif bearing < 157
        bearing_to_letters = 'SE.png'
      elsif bearing < 202
        bearing_to_letters = 'S.png'
      elsif bearing < 247
        bearing_to_letters = 'SW.png'
      elsif bearing < 292
        bearing_to_letters = 'W.png'
      elsif bearing < 337
        bearing_to_letters = 'NW.png'
      end
      holder = [DateTime.parse(image.created_at.to_s).to_i, image, bearing_to_letters, distance, ll]
      if distance < 0.11
        @warmest.append(holder)
      elsif distance < 1       
        @warmer.append(holder) 
      elsif distance < 5.0
        @warm.append(holder)
      elsif distance < 10.0
        @cold_10.append(holder)
      elsif distance < 15.0
        @cold_15.append(holder)    
      else
        @cold.append(holder)
      end
    end
    @warmest.reverse!
    @warmest = @warmest[0..19]
    @warmer.reverse!
    @warmer = @warmer[0..19]
    @warm.reverse!
    @warm = @warm[0..19]
    @cold_10.reverse!
    @cold_10 = @cold_10[0..19]
    @cold_15.reverse!
    @cold_15 = @cold_15[0..19]
    feed_length = @warm.length + @warmer.length + @warmest.length
    cold_range_end = 101 - feed_length
    @cold.reverse!
    @cold = @cold[0..cold_range_end]
  end

  # GET /images
  # GET /images.json
  def index
    @image = Image.new
    @images = Image.all
    @faces = ['face_0.png', 'face_1.png', 'face_2.png', 'face_3.png', 'face_4.png']
    @faces.shuffle!
    respond_to do |format|
      format.html
      format.js 
    end
  end

  # GET /images/1
  # GET /images/1.json
  #def show
  #end

  # GET /images/new
  #def new
  #end

  # GET /images/1/edit
  #def edit
  #end

  # POST /images
  # POST /images.json
  def create
    default_location = [36.1667,-86.7833]
    ll = [image_params[:latitude],image_params[:longitude]]
    if Geocoder::Calculations.distance_between(default_location, ll) < 25
      @image = Image.new(image_params)
      @image.save
    else
      render "toofar.js.erb"
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  #def update
  #  respond_to do |format|
  #    if @image.update(image_params)
  #      format.html { redirect_to @image, notice: 'Image was successfully updated.' }
  #      format.json { render :show, status: :ok, location: @image }
  #    else
  #      format.html { render :edit }
  #      format.json { render json: @image.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /images/1
  # DELETE /images/1.json
  #def destroy
  #  @image.destroy
  #  respond_to do |format|
  #    format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:latitude, :longitude, :photo)
    end
end
