require "uri"
require "net/http"
require "json"

class ClientController < ApplicationController
  
  def mainmenu
    @data = @@filter
    @orders=[]
    @orders_nopay=[]
#clients
    uri = URI("http://#{@@filter["orders"]}/admin/account.json")
    http = Net::HTTP.start(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(@@filter["id"], @@filter["name"])
    response = http.request(request)
    @bodies = JSON.parse(response.body)
#orders_wait_delivered
  i = 1
  while true
    params = {:financial_status => ["paid"], "fulfillment_status[]" => ["approved", "accepted"], :per_page => 100, :page => i}
    uri = URI("http://#{@@filter["orders"]}/admin/orders.json")
    
    http = Net::HTTP.start(uri.host, uri.port)
    uri.query = URI.encode_www_form(params)
    @text = uri.query
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(@@filter["id"], @@filter["name"])
    
    response = http.request(request)
    orders = JSON.parse(response.body)
    @orders += orders
    if orders == []
      i = 1
      break
    else
      i+=1
    end
  end
    

#orders_wait_pay
  while true
    params = {:financial_status => ["pending"], "fulfillment_status[]" => ["dispatched"], :per_page => 100, :page => i}
    uri = URI("http://#{@@filter["orders"]}/admin/orders.json")

    http = Net::HTTP.start(uri.host, uri.port)
    uri.query = URI.encode_www_form(params)
    @text = uri.query
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(@@filter["id"], @@filter["name"])

    response = http.request(request)
    orders = JSON.parse(response.body)
    @orders_nopay += orders
    if orders == []
      i = 1
      break
    else
      i+=1
    end
  end
    
  end
  
  def people
    uri = URI("http://#{@@filter["orders"]}/admin/clients.json")
    http = Net::HTTP.start(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(@@filter["id"], @@filter["name"])
    response = http.request(request)
    @bodies = JSON.parse(response.body)
  end

  def delivered
    @del = params["id"]
    uri = URI("http://#{@@filter["orders"]}/admin/orders/#{@del}.json")
    http = Net::HTTP.start(uri.host, uri.port)
    request = Net::HTTP::Put.new(uri.path, 'Content-Type' => 'application/json')
    request.basic_auth(@@filter["id"], @@filter["name"])
    request.body = ({"fulfillment_status" => "delivered"}).to_json
    response = http.request(request)

    redirect_to mainmenu_path
  end

  def paid
    @pay = params["id"]
    uri = URI("http://#{@@filter["orders"]}/admin/orders/#{@pay}.json")
    http = Net::HTTP.start(uri.host, uri.port)
    request = Net::HTTP::Put.new(uri.path, 'Content-Type' => 'application/json')
    request.basic_auth(@@filter["id"], @@filter["name"])
    request.body = ({"financial_status" => "paid"}).to_json
    response = http.request(request)

    redirect_to mainmenu_path
  end

  def show
    @keksik = params["id"]
    uri = URI("http://#{@@filter["orders"]}/admin/orders/#{@keksik}.json")
    http = Net::HTTP.start(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(@@filter["id"], @@filter["name"])
    response = http.request(request)
    @bodies = JSON.parse(response.body)
  end

  def ekam
    @client = Client.new
    
  end

  def login
    @@filter = params.require(:client).permit(:id, :name, :orders)
    
    redirect_to mainmenu_path
  end
end
