defmodule ShakespearePokedex.Repo.Migrations.CreatePokemons do
  use Ecto.Migration

  def change do
    create table(:pokemons) do
      add :name, :string
      add :description, :text

      timestamps()
    end
    create index("pokemons", [:name])
  end
end
