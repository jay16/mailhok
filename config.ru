require "./config/boot.rb"


# public
map("/")                { run HomeController }
map("/track")           { run TrackController }
map("/transactions")    { run TransactionsController }
map("/user")            { run UserController }
map("/api/v1")          { run API::Version1 }

# after login
map("/account")         { run Account::UserController }
map("/account/orders")  { run Account::OrdersController }
map("/account/renewal") { run Account::RenewalController }
map("/account/campaigns")  { run Account::CampaignsController }
map("/account/tracks")  { run Account::TracksController }
map("/account/trash")   { run Account::TrashController }
# admin
map("/cpanel")          { run Cpanel::HomeController }
map("/cpanel/users")    { run Cpanel::UsersController }
map("/cpanel/packages") { run Cpanel::PackagesController }
map("/cpanel/tracks")   { run Cpanel::TracksController }
map("/cpanel/records")  { run Cpanel::RecordsController }
map("/cpanel/orders")   { run Cpanel::OrdersController }
map("/cpanel/trash")    { run Cpanel::TrashController }
