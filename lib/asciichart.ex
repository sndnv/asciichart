defmodule Asciichart.Charset do
  @enforce_keys [:topleft, :topright, :bottomleft, :bottomright, :dash, :pipe, :axis, :firstval]
  defstruct [:topleft, :topright, :bottomleft, :bottomright, :dash, :pipe, :axis, :firstval]

  @moduledoc """
    Defines different character sets for plotting.
  """

  @spec square() :: String.t()
  def round do
    %__MODULE__{
      topleft: <<0x256D::utf8>>,
      topright: <<0x256E::utf8>>,
      bottomleft: <<0x2570::utf8>>,
      bottomright: <<0x256F::utf8>>,
      dash: <<0x2500::utf8>>,
      pipe: <<0x2502::utf8>>,
      axis: <<0x2524::utf8>>,
      firstval: <<0x253C::utf8>>
    }
  end

  def square do
    %__MODULE__{
      topleft: <<0x250C::utf8>>,
      topright: <<0x2510::utf8>>,
      bottomleft: <<0x2514::utf8>>,
      bottomright: <<0x2518::utf8>>,
      dash: <<0x2500::utf8>>,
      pipe: <<0x2502::utf8>>,
      axis: <<0x2524::utf8>>,
      firstval: <<0x253C::utf8>>
    }
  end

  def single_char(char) when is_binary(char) do
    if String.length(char) == 1 do
      %__MODULE__{
        topleft: char,
        topright: char,
        bottomleft: char,
        bottomright: char,
        dash: char,
        pipe: char,
        axis: <<0x2524::utf8>>,
        firstval: char
      }
    else
      raise("must provide a single character, got \"#{char}\"")
    end
  end
end

defmodule Asciichart do
  @moduledoc """
    ASCII chart generation.

    Ported to Elixir from [https://github.com/kroitor/asciichart](https://github.com/kroitor/asciichart)
  """

  @doc ~S"""
  Generates a chart for the specified list of numbers.

  Optionally, the following settings can be provided:
    * :offset - the number of characters to set as the chart's offset (left)
    * :height - adjusts the height of the chart
    * :padding - one or more characters to use for the label's padding (left)
    * :charset - a customizable character set

  ## Examples
      iex> Asciichart.plot([1, 2, 3, 3, 2, 1])
      {:ok, "3.00 ┤ ╭─╮   \n2.00 ┤╭╯ ╰╮  \n1.00 ┼╯   ╰  \n          "}

      # should render as

      3.00 ┤ ╭─╮
      2.00 ┤╭╯ ╰╮
      1.00 ┼╯   ╰

      iex> Asciichart.plot([1, 2, 6, 6, 2, 1], height: 2)
      {:ok, "6.00 ┤       \n3.50 ┤ ╭─╮   \n1.00 ┼─╯ ╰─  \n          "}

      # should render as

      6.00 ┤
      3.50 ┤ ╭─╮
      1.00 ┼─╯ ╰─

      iex> Asciichart.plot([1, 2, 5, 5, 4, 3, 2, 100, 0], height: 3, offset: 10, padding: "__")
      {:ok, "    100.00    ┤      ╭╮  \n    _50.00    ┤      ││  \n    __0.00    ┼──────╯╰  \n                    "}

      # should render as

          100.00    ┤      ╭╮
          _50.00    ┤      ││
          __0.00    ┼──────╯╰


      # Rendering of empty charts is not supported

      iex> Asciichart.plot([])
      {:error, "No data"}
  """

  @spec plot([number], %{optional(atom) => any}) :: String.t()
  def plot(series, cfg \\ %{}) do
    case series do
      [] ->
        {:error, "No data"}

      [_ | _] ->
        cs = if cfg[:charset], do: cfg[:charset], else: Asciichart.Charset.round()

        minimum = Enum.min(series)
        maximum = Enum.max(series)

        interval = abs(maximum - minimum)
        offset = cfg[:offset] || 3
        height = if cfg[:height], do: cfg[:height] - 1, else: interval
        padding = cfg[:padding] || " "
        ratio = height / interval
        min2 = Float.floor(minimum * ratio)
        max2 = Float.ceil(maximum * ratio)

        intmin2 = trunc(min2)
        intmax2 = trunc(max2)

        rows = abs(intmax2 - intmin2)
        width = length(series) + offset

        # empty space
        result =
          0..(rows + 1)
          |> Enum.map(fn x ->
            {x, 0..width |> Enum.map(fn y -> {y, " "} end) |> Enum.into(%{})}
          end)
          |> Enum.into(%{})

        max_label_size =
          (maximum / 1)
          |> Float.round(2)
          |> :erlang.float_to_binary(decimals: 2)
          |> String.length()

        min_label_size =
          (minimum / 1)
          |> Float.round(2)
          |> :erlang.float_to_binary(decimals: 2)
          |> String.length()

        label_size = max(min_label_size, max_label_size)

        # axis and labels
        result =
          intmin2..intmax2
          |> Enum.reduce(result, fn y, map ->
            label =
              (maximum - (y - intmin2) * interval / rows)
              |> Float.round(2)
              |> :erlang.float_to_binary(decimals: 2)
              |> String.pad_leading(label_size, padding)

            updated_map = put_in(map[y - intmin2][max(offset - String.length(label), 0)], label)
            put_in(updated_map[y - intmin2][offset - 1], cs.axis)
          end)

        # first value
        y0 = trunc(Enum.at(series, 0) * ratio - min2)
        result = put_in(result[rows - y0][offset - 1], cs.firstval)

        # plot the line
        result =
          0..(length(series) - 2)
          |> Enum.reduce(result, fn x, map ->
            y0 = trunc(Enum.at(series, x + 0) * ratio - intmin2)
            y1 = trunc(Enum.at(series, x + 1) * ratio - intmin2)

            if y0 == y1 do
              put_in(map[rows - y0][x + offset], cs.dash)
            else
              updated_map =
                put_in(
                  map[rows - y1][x + offset],
                  if(y0 > y1, do: cs.bottomleft, else: cs.topleft)
                )

              updated_map =
                put_in(
                  updated_map[rows - y0][x + offset],
                  if(y0 > y1, do: cs.topright, else: cs.bottomright)
                )

              (min(y0, y1) + 1)..max(y0, y1)
              |> Enum.drop(-1)
              |> Enum.reduce(updated_map, fn y, map ->
                put_in(map[rows - y][x + offset], cs.pipe)
              end)
            end
          end)

        # ensures cell order, regardless of map sizes
        result =
          result
          |> Enum.sort_by(fn {k, _} -> k end)
          |> Enum.map(fn {_, x} ->
            x
            |> Enum.sort_by(fn {k, _} -> k end)
            |> Enum.map(fn {_, y} -> y end)
            |> Enum.join()
          end)
          |> Enum.join("\n")

        {:ok, result}
    end
  end
end
