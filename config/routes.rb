Rails.application.routes.draw do

  root "client#ekam"

  get  "/client/login", to: "client#login"
  get  "/people", to: "client#people"
  get  "/orders", to: "client#orders"
  get  "/mainmenu", to: "client#mainmenu"
 
 resources :client do
  member do
    get 'ekam', 'delete', 'delivered', 'paid'
  end
end
  
end
