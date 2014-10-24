require "./config/boot.rb"


# 公开界面
map("/")       { run HomeController }
# /login/register
map("/user")   { run UserController }

# api#v1
map("/api/v1") { run API::Version1 }

# after login
map("/account") { run AccountsController }
map("/cpanel")  { run Cpanel::HomeController }
map("/cpanel/users")    { run Cpanel::UsersController }
map("/cpanel/packages") { run Cpanel::PackagesController }
map("/cpanel/tracks")   { run Cpanel::TracksController }
map("/cpanel/records")  { run Cpanel::RecordsController }


#run Sinatra::Application
#Rack::Handler::Thin.run @app, :Port => 3000
