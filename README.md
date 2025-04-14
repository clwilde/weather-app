# README

## Requirements:
* Must be done in Ruby on Rails
* Accept an address as input
* Retrieve forecast data for the given address. This should include, at minimum, the current temperature (Bonus points - Retrieve high/low and/or extended forecast)
* Display the requested forecast details to the user
* Cache the forecast details for 30 minutes for all subsequent requests by zip codes. Display indicator if result is pulled from cache.
## Assumptions:
* This project is open to interpretation
* Functionality is a priority over form
* If you get stuck, complete as much as you can

## Setup:
App requires [Geoapify API key](https://www.geoapify.com) and [OpenWeather One Call 3.0 API key](https://openweathermap.org/api/one-call-3) defined as environment variables.

example .env file for development mode:
```
GEOAPIFY_API_KEY=
OPENWEATHER_API_KEY=
```
