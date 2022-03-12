Rails.application.routes.draw do
  get "/api/ping", to: "pings#index"
  get "/api/posts", to: "posts#index"
end
