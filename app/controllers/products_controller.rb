class ProductsController < ApplicationController
  before_action :set_product, only: %i(show edit update destroy)

  # GET /products or /products.json
  def index
    @products = Product.latest
  end

  # GET /products/1 or /products/1.json
  def show
    product_not_found if @product.nil?
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    product_not_found if @product.nil?
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html do
          redirect_to product_url(@product),
                      notice: t("products.created")
        end
        format.json {render :show, status: :created, location: @product}
      else
        format.html {render :new, status: :unprocessable_entity}
        format.json do
          render json: @product.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    return product_not_found if @product.nil?

    respond_to do |format|
      if @product.update(product_params)
        format.html do
          redirect_to product_url(@product),
                      notice: t("products.updated")
        end
        format.json {render :show, status: :ok, location: @product}
      else
        format.html {render :edit, status: :unprocessable_entity}
        format.json do
          render json: @product.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    return product_not_found if @product.nil?

    respond_to do |format|
      if @product.destroy
        format.html do
          redirect_to products_url, notice: t("products.destroyed")
        end
        format.json {head :no_content}
      else
        format.html do
          redirect_to products_url,
                      notice: t("products.destroy_failed")
        end
        format.json do
          render json: @product.errors,
                 status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_product
    @product = Product.find_by(id: params[:id])
  end

  def product_params
    params.require(:product).permit(:name)
  end

  def product_not_found
    respond_to do |format|
      format.html {redirect_to products_url, notice: t("products.not_found")}
      format.json do
        render json: {error: t("products.not_found")},
               status: :not_found
      end
    end
  end
end
