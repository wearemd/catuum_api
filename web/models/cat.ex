defmodule CatuumApi.Cat do
  alias Exredis.Api, as: Repo

  import Mogrify

  @uploads_path   "uploads"
  @small_cats_key "cats:400-700"

  # WIP
  @valid_sizes 400..700

  def import do
    Repo.del(@small_cats_key)

    case absolute_path |> File.ls do
      {:ok, files} ->
        files |> Enum.each(&store(&1))
      {:error, _} ->
        IO.puts "Cannot read uploads directory"
    end
  end

  def random(count) do
    filenames = Repo.srandmember([@small_cats_key, count])


    filenames |> Enum.map(fn(filename) -> 
      ext = Path.extname(filename) |> String.replace(".", "")
      %{
        path: @uploads_path <> "/" <> filename,
        content_type: "image/" <> ext
      }
    end)
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
    absolute_image_path = "/" <> path |> absolute_path

    %Mogrify.Image{width: width, height: height} = open(absolute_image_path) |> verbose

    width  = width |> String.to_integer
    height = height |> String.to_integer

    if Enum.member?(@valid_sizes, width) && Enum.member?(@valid_sizes, height) do
      IO.puts "WIP: #{path} stored"

      Repo.sadd(@small_cats_key, path)
    else 
      IO.puts "WIP: other sizes must be stored too. #{width} #{height}"
    end

    # In this case we have to wait a bit for Mogrify to be available, turn this to a Task
    Process.sleep(25)
  end

  defp absolute_path(path \\ "") do
    System.cwd() <> "/" <> @uploads_path <> path
  end
end