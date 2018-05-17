Rails.application.routes.draw do
  root to: 'converters#index'
  get  'convert', to: 'converters#index'
end
