# F-Pulse or Farm Pulse Application
This is an application for matching between the farm volunteer with the farmer.
## License
TBA
## Getting started
To get started with the app, clone the repon and then install the need gems:
```
$ bundle install --without production
```
Next, install webpacker:
```
$ rails webpacker:install
```
Next, migrate the database:
```
$ rails db:migrate
```
Finally, try to run the application:
```
$ rails s
```
If nothing error goes up, you may continue to get the google credential and add the application ID and secret into the environment variable named as GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET

For see the production application, see the
[*The Farm Pulse* Web](https://f-pulse.herokuapp.com)