defmodule Input do
  @extension "txt"
  @inputpath "input/"

  def parse(day, example \\ false) do
    case example do
      true ->
        File.read!(@inputpath <> "day" <> Integer.to_string(day) <> "ex" <> "." <> @extension)

      false ->
        File.read!(@inputpath <> "day" <> Integer.to_string(day) <> "." <> @extension)
    end
  end
end
