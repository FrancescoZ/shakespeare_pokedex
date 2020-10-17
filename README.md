# ShakespearePokedex

# LiveMapApp

This is a really simple [Phoenix]() Application to get informations about pokemons in a poethic way.

The creation of this project is described in [this article](https://medium.com/@francescozanoli/a-simple-poetic-pokemon-app-93ea21d00754)

## Development
### Requirements
The solution is using docker so be sure to have installed `docker-compose` and `Docker` on your machine before starting.

### How to launch it
Once you have clone the repo you just need to go into the folder and run:
> docker-compose up --build

Note: the first time it may take a while

As default the container is created, dependencies are installed, database is created and migrated but no application is started. This allow you to jump into the container and run test if you want to.
To jump into the container you can copy the output of the `docker-compose up` into another console or run this:
> docker exec -it HOSTNAME sh

replacing HOSTNAME with the container id.
To start the server you need to go run:
> mix phx.server

The server will start listening on the port `4000`, which is forwared from the container at the port `4005`

### How to run tests
Inside the container you can run unit test using:
> MIX_ENV=test mix test

### Troubleshooting
If the process doesn't work try deleting all the following images from docker if presents:
- shakespeare_pokedex_service
- postgres
- elixir
Try deleting also the folder `_build`, `deps` and deps then start the process again

## Usage
To start using the service you need to start it using the instruction above.

In order get information from the service you have to hit the endpoint `/pokemon` passing a pokemon name

⚠️ The application use a persistent database to store the data, however the api for translation has a rate limit of 5 requests per hour, this mean that you can retrieve only 5 pokemon per hour with the current setup

An example:
> curl --location --request GET 'localhost:4005/pokemon/ditto'

⚠️ if you are using the browser to query it, the first time you hit the endpoint it could give you an invalid_pokemon answer . It's the first request only.
## Future Improvements and welcome MRs

- Add token managerment for Shakespeare API
- Add production release and environment management for production

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
