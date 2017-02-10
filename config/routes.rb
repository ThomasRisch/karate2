Karate2::Application.routes.draw do


# conventional routes
  resources :lists
  resources :invoices

# direct routes
  post "lists/courses"
  post "lists/exams"
#  get "bills/pay"
#  get "bills/remind"
#  get "bills/print"
  get "bills/filter"
  post "invoices/prepare"
  post "invoices/print"
#  post "gradings/print"

# Active Scaffold routes
  resources :notes do as_routes end
  resources :people do as_routes end
  resources :courses do as_routes end
  resources :documents do as_routes end
  resources :grades do as_routes end

# Routes with individual actions
resources :gradings do
  member do
    get 'print'
  end
  collection do
    get 'details'
  end
  as_routes
end

resources :bills do 
  member do
    get 'pay'
    get 'pay_final'
    put 'pay_final'
    get 'print'
    get 'remind'
  end
  as_routes 
end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'people§#index'
  root :to => 'people#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
