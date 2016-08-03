Rails.application.routes.draw do




  get 'sessions/new'

  root 'static_pages#home'

  post  'comment' => 'comment#create'
  get  'help' => 'static_pages#help'
  get  'about' => 'static_pages#about'
  get  'contact' => 'static_pages#contact'
  get  'signup' => 'users#signup'
  post 'signup' => 'users#create'
  get  'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'


  get 'test' => 'static_pages#test_method'
  get 'all' => 'users#show_all_users'
  get 'feed' => 'microposts#show_all_microposts'
  get 'person' => 'users#display_user'


  get 'post' => 'microposts#post'


  # URLs for following and followers will look like /users/1/following
  # and /users/1/followers, and that is exactly what the code below arranges.
  # Since both pages will be showing data, the proper HTTP verb is a GET
  # request, so we use the get method to arrange for the URLs to respond
  # appropriately. Meanwhile, the member method arranges for the routes
  # to respond to URLs containing the user id.


  # HTTPrequest 	URL 	             Action 	      Named route
  # GET   	    /users/1/following 	following 	following_user_path(1)
  # GET 	      /users/1/followers 	followers 	followers_user_path(1)

  resources :users do
    member do
      get :following, :followers
    end
  end


  resources :users
  resources :microposts ,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]


  resources :microposts do
    resources :comments
  end



end
