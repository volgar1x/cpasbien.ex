defmodule Cpasbien do
  use HTTPoison.Base

  ## HTTPoison
  @doc false
  def process_url(url) do
    "http://www.cpasbien.pw" <> url
  end

  ## Private functions
  defp urlencode(pattern) do
    pattern
      |> Slugger.slugify
      |> :hackney_url.urlencode
  end

  ## Public API
  def search(pattern) do
    pattern = urlencode(pattern)

    get!("/recherche/#{pattern}.html").body
      |> Floki.parse
      |> Floki.find("#gauche .titre")
      |> Floki.attribute("href")
      |> Enum.map(fn(url) -> String.replace(url, "http://www.cpasbien.pw", "") end)
      |> Enum.map(&__MODULE__.torrent_url/1)
  end

  def torrent_url(item) do
    get!(item).body
      |> Floki.parse
      |> Floki.find("#telecharger")
      |> Floki.attribute("href")
  end

  def download_torrent(item, dir) do
    dest = Path.join(dir, Path.basename(item))
    data = get!(item).body
    File.write!(dest, data)
  end

  def download_torrents(pattern, [dest: dest]) do
    for torrent <- search(pattern) do
      download_torrent(torrent, dest)
    end
  end
end
