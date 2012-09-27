AdvertSelector::Engine.routes.draw do


  get "/" => "main#index", :as => :main
  get "/clear_errors_log" => "main#clear_errors_log", :as => :clear_errors_log


  resources :banners do
    #resources :helper_items
  end

  resources :placements


  #match '/' => redirect {|params, request| '/advert_selector/placements' }
end
