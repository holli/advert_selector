AdvertSelector::Engine.routes.draw do


  resources :banners do
    #resources :helper_items
  end

  resources :placements


  match '/' => redirect {|params, request| '/advert_selector/placements' }
end
