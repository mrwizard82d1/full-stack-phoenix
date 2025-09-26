defmodule RaffleyWeb.Router do
  use RaffleyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RaffleyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :spy
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  def spy(conn, _opts) do
    greeting =
      ~w(Hi Howdy Hello)
      |> Enum.random()

    conn = assign(conn, :greeting, greeting)

    # Avoid "polluting" the server log
    # IO.inspect(conn)

    conn
  end

  scope "/", RaffleyWeb do
    pipe_through :browser

    # "Standard" HTTP routes
    # get "/", PageController, :home
    get "/rules", RuleController, :index
    get "/rules/:id", RuleController, :show

    # LiveView route
    live "/", RaffleLive.Index, :home
    live "/estimator", EstimatorLive
    live "/raffles", RaffleLive.Index
    live "/raffles/:id", RaffleLive.Show

    # Admin LiveView route
    live "/admin/raffles", AdminRaffleLive.Index
    live "/admin/raffles/new", AdminRaffleLive.Form, :new
    live "/admin/raffles/:id/edit", AdminRaffleLive.Form, :edit

    # Charity LiveView routes
    live "/charities", CharityLive.Index, :index
    live "/charities/new", CharityLive.Form, :new
    live "/charities/:id", CharityLive.Show, :show
    live "/charities/:id/edit", CharityLive.Form, :edit
  end

  # Other scopes may use custom stacks.
  # This choice is the other choice for an API: append the namesapce to
  # the `RaffleyWeb` namespace. This choice puts **all** controllers in
  # this scope in the `API` namespace. With this choice, the source code
  # for these controllers are all in the `RaffleyWeb.Api` namespace.
  scope "/api", RaffleyWeb.Api do
    pipe_through :api

    get "/raffles", RaffleController, :index
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:raffley, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RaffleyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
