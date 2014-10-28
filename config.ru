require "./config/boot.rb"


# 公开界面
map("/")                { run HomeController }
map("/transactions")    { run TransactionsController }
map("/user")            { run UserController }
map("/api/v1")          { run API::Version1 }

# after login
map("/account")         { run Account::UserController }
map("/account/orders")  { run Account::OrdersController }
map("/account/renewal") { run Account::RenewalController }
map("/account/tracks")  { run Account::TracksController }
map("/account/records") { run Account::RecordsController }
map("/account/trash")   { run Account::TrashController }
# admin
map("/cpanel")          { run Cpanel::HomeController }
map("/cpanel/users")    { run Cpanel::UsersController }
map("/cpanel/packages") { run Cpanel::PackagesController }
map("/cpanel/tracks")   { run Cpanel::TracksController }
map("/cpanel/records")  { run Cpanel::RecordsController }
map("/cpanel/orders")   { run Cpanel::OrdersController }
map("/cpanel/trash")    { run Cpanel::TrashController }


#run Sinatra::Application
#Rack::Handler::Thin.run @app, :Port => 3000
