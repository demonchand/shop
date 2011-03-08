class CartsController < ApplicationController
  include ActiveMerchant::Billing
  def checkout
    setup_response = gateway.setup_purchase(1000,
    :ip                => request.remote_ip,
    :return_url        => url_for(:action => 'confirm', :only_path => false),
    :cancel_return_url => root_url#url_for(:action => 'index', :only_path => false)
  )
  redirect_to gateway.redirect_url_for(setup_response.token)
  end
  # GET /carts
  # GET /carts.xml
  def index
    @carts = Cart.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @carts }
    end
  end

  # GET /carts/1
  # GET /carts/1.xml
  def show
    @cart = Cart.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cart }
    end
  end

  # GET /carts/new
  # GET /carts/new.xml
  def new
    @cart = Cart.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cart }
    end
  end

  # GET /carts/1/edit
  def edit
    @cart = Cart.find(params[:id])
  end

  # POST /carts
  # POST /carts.xml
  def create
    @cart = Cart.new(params[:cart])

    respond_to do |format|
      if @cart.save
        format.html { redirect_to(@cart, :notice => 'Cart was successfully created.') }
        format.xml  { render :xml => @cart, :status => :created, :location => @cart }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cart.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /carts/1
  # PUT /carts/1.xml
  def update
    @cart = Cart.find(params[:id])

    respond_to do |format|
      if @cart.update_attributes(params[:cart])
        format.html { redirect_to(@cart, :notice => 'Cart was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cart.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.xml
  def destroy
    @cart = Cart.find(params[:id])
    @cart.destroy

    respond_to do |format|
      format.html { redirect_to(carts_url) }
      format.xml  { head :ok }
    end
  end

  def confirm
    redirect_to :action => 'index' unless params[:token]
    details_response = gateway.details_for(params[:token])
    
    if !details_response.success?
    @message = details_response.message
    render :action => 'error'
    return
  end
    @address = details_response.address
  end
  def complete
    purchase = gateway.purchase(1000,
    :ip       => request.remote_ip,
    :payer_id => params[:payer_id],
    :token    => params[:token]
                                 )
  
    if !purchase.success?
      @message = purchase.message
      render :action => 'error'
      return
    end
  end
  
  private
  def gateway
     @gateway ||= PaypalExpressGateway.new(
    :login => "seller_1299232941_biz_api1.gmail.com",
    :password => "6LWSRTJWTLD9FMJB",
    :signature => "AR9Pt8A5jeHO4g.gC-vXGDEp.Z8VAWS97jMqCze97gVnnyb0GWgksDj."
  )
  end
end
