AdvertSelector::Engine.routes.draw do


  get "/" => "main#index", :as => :main
  get "/clear_errors_log" => "main#clear_errors_log", :as => :clear_errors_log


  resources :banners do
    #resources :helper_items
    put 'update_running_view_count', :on => :member
  end

  resources :placements


  #match '/' => redirect {|params, request| '/advert_selector/placements' }
end
