class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]

  # GET /pictures
  # GET /pictures.json
  def index
    @pictures = Picture.all
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show
  end

  # GET /pictures/new
  def new
    @picture = Picture.new
  end

  # GET /pictures/1/edit
  def edit
  end

  # POST /pictures
  # POST /pictures.json
  def create
    @picture = Picture.new(picture_params)
    @redirect_url = pictures_url(only_path: false)

    respond_to do |format|
      if @picture.save
        format.html { redirect_to @picture, notice: 'Picture was successfully created.' }
        format.json { render :show, status: :created, location: @picture }
        format.js { render :create }
      else
        format.html { render :new }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pictures/1
  # PATCH/PUT /pictures/1.json
  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to @picture, notice: 'Picture was successfully updated.' }
        format.json { render :show, status: :ok, location: @picture }
      else
        format.html { render :edit }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to pictures_url, notice: 'Picture was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def check_status
    messages = SqsUtility.receive_messages
    Rails.logger.debug("sqs messages=" + messages.inspect)

    @pictures = []
    processed_messages = []

    messages.each do |msg|
      msg.messages.each do |m|
        Rails.logger.debug("body=" + m.body)
        begin
          result = JSON.parse(m.body)
          processed_messages.push(m) if result["env"] == Rails.env
          next unless result["status"] == "success"

          picture = Picture.find_by_id(result["id"])
          @pictures.push(picture) if picture
        rescue => e
          Rails.logger.error(e)
        end
      end
    end

    # update statuses
    Picture.where(id: @pictures.map(&:id)).update_all(thumb_created: true) if @pictures

    # delete messages
    if processed_messages.present?
      SqsUtility.delete_messages(processed_messages)
      Rails.logger.debug("delete #{processed_messages.count} messages")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picture
      @picture = Picture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_params
      params.require(:picture).permit(:memo, :thumb_created)
    end
end
