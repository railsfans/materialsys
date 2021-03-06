Materialsys::Application.routes.draw do
	resource  :session
	match '/login' => "sessions#new", :as => "login" 
	match '/logout' => "sessions#destroy", :as => "logout"
	match 'code/importcode' => 'code#importcode'
	match 'manager/outportmaterial' => 'manager#outportmaterial'
	match 'manager/importmaterial' => 'manager#importmaterial'
	match "supplier/importsupplier"=>"supplier#importsupplier"
	match 'user/edit'=>"user#edit"
	match 'user/data'=>"user#data"
	match 'user/add'=>"user#add"

	match "bom/download1"=>"bom#download1"
	match "bom/download2"=>"bom#download2"
	match "bom/download"=>"bom#download"
	match "bom/list"=>"bom#list"
    get "project/list"
	match "code/ajax"=>"code#ajax"
	match "code/list"=>"code#list"
	match "manager/all"=>"manager#all"
	match "manager/download"=>"manager#download"
	match "sample/upload"=>"sample#upload"
	match "supplier/list"=>"supplier#list"
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
   root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
   match ':controller(/:action(/:id))(.:format)'
end
