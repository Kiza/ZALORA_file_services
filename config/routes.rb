Rails.application.routes.draw do
  root to: 'check#live'

  get 'check/live'
  
  post 'files', to: 'data_file#create'

  get 'files/:filename', to: 'data_file#show', constraints: { filename: /.+/ }

  delete 'files/:filename', to: 'data_file#delete', constraints: { filename: /.+/ }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
