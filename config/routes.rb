AdvertSelector::Engine.routes.draw do
  resources :banners

  resources :placements


  match '/' => redirect {|params, request| '/advert_selector/placements' }
end
