defmodule VmesteWeb.Router do
  use VmesteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VmesteWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", VmesteWeb do
    pipe_through :api

    resources "/messages", MessageController, except: [:new, :edit]
  end
end
