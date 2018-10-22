Rails.application.routes.draw do
  resources :users, only: [:index]
  get 'users/list'
  get 'users/new'
  post 'users/create'
  patch 'users/update'
  get 'users/list'
  get 'users/show'
  get 'users/edit'
  get 'users/delete'
  get 'users/update'
  get 'users/search'
  get 'users/result'
  get 'users/search_by_email_or_permalink'
  # get 'users/list*' => 'users#list', format: true
  # post 'users/search_by_email_or_permalink*' => 'users#list', format: true
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
