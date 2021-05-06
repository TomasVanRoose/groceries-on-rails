class ItemsController < ApplicationController
  before_action :set_item, only: %i[ edit update destroy move check uncheck ]

  # GET /items or /items.json
  def index
    # Remove items that are checked off and older than 2 hours
    Item.where(checked_off: true, updated_at: ..2.hours.ago).destroy_all
    @items = Item.all
    @item = Item.new
  end
  
  # POST /items or /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to items_url, notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
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
        format.html { redirect_to items_url, notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def move
    @item.insert_at(params[:position].to_i)
    head :ok
  end

  def check
    # Move the checked off item to the bottom
    @item.move_to_bottom
    @item.checked_off = true
    @item.save
    redirect_to items_url
  end
  
  def uncheck
    # Move the checked off item to the top of the unchecked ones
    last_unchecked_pos = Item.where(checked_off: false).maximum(:position)
    @item.insert_at(last_unchecked_pos + 1)
    @item.checked_off = false
    @item.save
    redirect_to items_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :checked_off, :position, :timestamps)
    end
end
