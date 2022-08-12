class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    price = '100.00'
  request = PayPalCheckoutSdk::Orders::OrdersCreateRequest::new
  request.request_body({
    :intent => 'CAPTURE',
    :purchase_units => [
      {
        :amount => {
          :currency_code => 'USD',
          :value => price
        }
      }
    ]
  })
  begin
    response = @client.execute request
    order = Order.new
    order.price = price.to_i
    order.token = response.result.id
    if order.save
      return render :json => {:token => response.result.id}, :status => :ok
    end
  rescue PayPalHttp::HttpError => ioe
    # HANDLE THE ERROR
  end
  end

  def create_order

  end 

  def capture_order

  end

  private 
  def paypal_init
    client_id = 'AaqroHp0cK8sUh-4B8pX9yDjjTIrZ4RENlK0bZ3Vnll50OBRqO375pRW7UwOjq8LNbI831GjszH5RwkX'
    client_secret = ''
    environment = Paypal::SandboxEnvironment.new client_id, client_secret
    @client = Paypal:: Paypal::PayPalHttpClient.new environment
  end
end
