Rails.application.routes.draw do

  resources :cities, only: :index do
    resource :forecast, only: :show, controller: "city_forecasts"
  end

  root to: "pages#home"
end
