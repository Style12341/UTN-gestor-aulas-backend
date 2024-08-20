Rails.application.routes.draw do
  resources :bedeles
  resources :cursos , only: [:index]
  resources :docentes , only: [:index]
  # Get current periodo
  get 'periodos/current', to: 'periodos#current'
  # Route to get periodo information for a determined año
  get 'periodos/:ano', to: 'periodos#show', as: :periodos
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post 'login', to: 'usuarios#create'
  # Reservas routes
  post 'disponibilidad/periodica', to: 'disponibilidad#periodica'
  post 'disponibilidad/esporadica', to: 'disponibilidad#esporadica'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
