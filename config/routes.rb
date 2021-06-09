Rails.application.routes.draw do
  
  get 'mujin_items/new'
  get 'feature_masters/new'
  get 'role_masters/new'
  #devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'dashboards#show'
  get '/master_maintenance', to: 'dashboards#masters_maintenance'
  get '/user_index', to: 'dashboards#user_index'
  get '/user_role', to: 'dashboards#user_role'
  post '/updateuserrole', to: 'dashboards#updateuserrole'
  get '/user_feature_roles', to: 'dashboards#user_feature_roles'
  post '/updatesubfeatureuser', to: 'dashboards#updatesubfeatureuser'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'users/sign_in', to: 'users/sessions#new', as: :new_user_session
    get 'users/sign_out', to: 'users/sessions#destroy', as: :destroy_user_session
  end

  # credential routes
  get 'showqrcode', to: 'dashboards#qr_show'

  # Mujin routes
  #get '/mujin_dashboard',  to: 'mujins#show'
  get '/farm_management', to: 'mujins#mgmt'
  get '/mujin_map',        to: 'mujins#map'
  #get '/mujin_new',        to: 'mujins#new'
  resources :mujins
  resources :mujin_items
 

  # Farm volunteer routes

  # Job routes
  resources :job_masters

  # Good routes
  resources :good_masters

  # Role routes
  resources :role_masters
  post   '/updaterole',         to: 'role_masters#updaterole'

  # Feature routes
  resources :feature_masters

  # API
  get 'apis/scan' #first connection

end
