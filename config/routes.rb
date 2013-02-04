Clubtrack::Application.routes.draw do
  devise_for :users
  
  resources :users, :clubs, :members
  resources :events do
    collection do
      get :user_lookup, :attendance
      post :submit_attendance
    end
  end


  root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
