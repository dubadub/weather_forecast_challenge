# Code challenge for WeatherForecast

## Setup

Run `bundle` and then `rails db:migrate`.

## Run tests

Run `bin/rspec`.

## Import all cities into database from openweathermap.org

Run `rails openweathermap:import_cities`

## Run server

Run `rails s` and `bin/webpack` in a separate tab.

## Demo

See live demo at [https://weather.alexeydubovskoy.com](https://weather.alexeydubovskoy.com)

## CI/CD

I used CircleCI workflow for setting up CI/CD and DigitalOcean Kubernetes Service managed by Terraform for base infrastructure  (I'm not sharing that code because it used in my other projects).

In that project I import shared modules and state to access that infrastructure and deploy container with the app and Postgres to Kubernetes, as well as issue certificate with LetsEncrypt.

See [terraform](https://github.com/dubadub/weather_forecast_challenge/tree/master/terraform) and [CircleCI config](https://github.com/dubadub/weather_forecast_challenge/blob/master/.circleci/config.yml).

Workflow does:

  * first it builds an image of the app and pushes it to my own private container registry;
  * then it runs tests against that image;
  * then if tests are green, it's available for deploying with previewing all the required infrastructure changes.

## Original Spec

Create a Ruby on Rails app, that given an input of the name of the city, display the 16 day weather forecast using the [http://openweathermap.org/forecast16](http://openweathermap.org/forecast16) API(need to request a free API Key). See this image for inspiration: [http://cloud.addictivetips.com/wp-content/uploads/2011/12/Forecast.png](http://cloud.addictivetips.com/wp-content/uploads/2011/12/Forecast.png)

- [x] A good example of the flow would be, to show an text input, when the user enter a city name, a request is made to the API, which will return the city 16 days forecast

- [x] This would show another page with the 16 days forecast and the simplest data like date and average temperature. Then when the user clicks on a specific day widget, brings up another page with the rest of the details like wind direction, precipitation, etc.

- [x] We are looking for at least 1 test (Integration/Components/Unit/Acceptance),
- [x] a simple CI (Continuous Integration) server working
- [x] a CD (Continuous Deployment) server working (avoid Heroku if you can)
- [x] CSS/Styles are a bonus to have not critical.
- [x] We are expecting clean code, adhering to the community standards and rails conventions.

