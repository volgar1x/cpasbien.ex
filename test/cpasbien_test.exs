defmodule CpasbienTest do
  use ExUnit.Case

  alias Cpasbien, as: T

  test "get how i met your mother s05" do
    IO.inspect(T.search("how i met your mother s05"))
  end
end
