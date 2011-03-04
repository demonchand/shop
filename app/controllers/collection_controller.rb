class CollectionController < ApplicationController
  def index
    @collections = Product.all
  end

end
