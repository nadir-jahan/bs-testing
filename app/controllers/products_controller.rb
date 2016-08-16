class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    requestd = Vacuum.new
    unless  params[:page].present?
      params[:page] = 1
    end
    requestd.configure(aws_access_key_id: 'AKIAIP4ABLWHY7ANK2TQ',aws_secret_access_key: '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',associate_tag: 'bstoda-20' )
    response = requestd.item_search(query: {'SearchIndex' => 'FashionWomen','Keywords' => 'shoes,Handbags & Wallets','ResponseGroup' => "ItemAttributes,Images",:ItemPage =>  params[:page]})
    response_shoes = requestd.item_search(query: {'SearchIndex' => 'FashionWomen','Keywords' => 'shoes','ResponseGroup' => "ItemAttributes,Images",:ItemPage =>  params[:page]})
    hashed_response_shoes = response_shoes.to_h
    hashed_products = response.to_h
    @products = []
   
    hashed_products['ItemSearchResponse']['Items']['Item'].each do |item|
      product = OpenStruct.new
      product.asin = item['ASIN']
      product.name = item['ItemAttributes']['Title']
      product.price = item['ItemAttributes']['ListPrice']['FormattedPrice'] if item['ItemAttributes']['ListPrice']
      #product.url = item['DetailPageURL']
      product.feature = item['ItemAttributes']['Feature']
      product.image_url = item['MediumImage']['URL'] if item['LargeImage']
      product.link = item['ItemLinks']['ItemLink'][5]['URL']
      @products << product
    end
      hashed_response_shoes['ItemSearchResponse']['Items']['Item'].each do |item|
      product = OpenStruct.new
      product.asin = item['ASIN']
      product.name = item['ItemAttributes']['Title']
      product.price = item['ItemAttributes']['ListPrice']['FormattedPrice'] if item['ItemAttributes']['ListPrice']
      #product.url = item['DetailPageURL']
      product.feature = item['ItemAttributes']['Feature']
      product.image_url = item['MediumImage']['URL'] if item['LargeImage']
      product.link = item['ItemLinks']['ItemLink'][5]['URL']
      @products << product
    end

    respond_to do |format|
     format.js
     format.html
end
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.fetch(:product, {})
    end
end
