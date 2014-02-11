Rails.application.routes.draw do
  #get "examples/index"

  mount AdvertSelector::Engine => "/advert_selector"

  match '(:action)' => 'examples', via: [:get, :post]

end
