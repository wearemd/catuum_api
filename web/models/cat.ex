defmodule CatuumApi.Cat do
  alias Exredis.Api, as: Repo

  @uploads_path   "uploads"
  @small_cats_key "cats:400-900"

  def import do
    Repo.del(@small_cats_key)

    case System.cwd() <> "/" <> @uploads_path |> File.ls do
      {:ok, files} ->
        files |> Enum.each(&store(&1))
      {:error, _} ->
        IO.puts "Cannot read uploads directory"
    end
  end

  def random do
    filename = Repo.srandmember(@small_cats_key)
    ext      = Path.extname(filename) |> String.replace(".", "")

    %{
      path: @uploads_path <> "/" <> filename,
      content_type: "image/" <> ext
    }
  end

  defp store(path) do
    Repo.sadd(@small_cats_key, path)
  end
end