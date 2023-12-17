defmodule AsciichartTest do
  use ExUnit.Case

  doctest Asciichart

  # Test samples based on https://github.com/madnight/asciichart/blob/master/test/Test.hs

  test "renders charts" do
    series = (1..6 |> Enum.to_list()) ++ (6..1 |> Enum.to_list())

    # default config
    expected_chart =
      [
        "6.00 ┤    ╭─╮      ",
        "5.00 ┤   ╭╯ ╰╮     ",
        "4.00 ┤  ╭╯   ╰╮    ",
        "3.00 ┤ ╭╯     ╰╮   ",
        "2.00 ┤╭╯       ╰╮  ",
        "1.00 ┼╯         ╰  ",
        "                "
      ]
      |> Enum.join("\n")

    {:ok, actual_chart} = Asciichart.plot(series)
    assert expected_chart == actual_chart

    # with precision=3
    expected_chart =
      [
        "6.000 ┤    ╭─╮      ",
        "5.000 ┤   ╭╯ ╰╮     ",
        "4.000 ┤  ╭╯   ╰╮    ",
        "3.000 ┤ ╭╯     ╰╮   ",
        "2.000 ┤╭╯       ╰╮  ",
        "1.000 ┼╯         ╰  ",
        "                "
      ]
      |> Enum.join("\n")

    {:ok, actual_chart} = Asciichart.plot(series, precision: 3)
    assert expected_chart == actual_chart

    # with precision=0
    expected_chart =
      [
        "  6 ┤    ╭─╮      ",
        "  5 ┤   ╭╯ ╰╮     ",
        "  4 ┤  ╭╯   ╰╮    ",
        "  3 ┤ ╭╯     ╰╮   ",
        "  2 ┤╭╯       ╰╮  ",
        "  1 ┼╯         ╰  ",
        "                "
      ]
      |> Enum.join("\n")

    {:ok, actual_chart} = Asciichart.plot(series, precision: 0)
    assert expected_chart == actual_chart

    # with precision=1
    expected_chart =
      [
        "6.0 ┤    ╭─╮      ",
        "5.0 ┤   ╭╯ ╰╮     ",
        "4.0 ┤  ╭╯   ╰╮    ",
        "3.0 ┤ ╭╯     ╰╮   ",
        "2.0 ┤╭╯       ╰╮  ",
        "1.0 ┼╯         ╰  ",
        "                "
      ]
      |> Enum.join("\n")

    {:ok, actual_chart} = Asciichart.plot(series, precision: 1)
    assert expected_chart == actual_chart

    series =
      [-8_975_789_655_001, 6_755_678_990_773]
      |> Stream.cycle()
      |> Stream.take(51)
      |> Enum.to_list()

    expected_chart =
      [
        " 6755678990773.00 ┤                                                    ",
        " 5706914414388.07 ┤╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮╭╮  ",
        " 4658149838003.13 ┤││││││││││││││││││││││││││││││││││││││││││││││││││  ",
        " 3609385261618.20 ┤││││││││││││││││││││││││││││││││││││││││││││││││││  ",
        " 2560620685233.27 ┤││││││││││││││││││││││││││││││││││││││││││││││││││  ",
        " 1511856108848.33 ┤││││││││││││││││││││││││││││││││││││││││││││││││││  ",
        "  463091532463.40 ┤││││││││││││││││││││││││││││││││││││││││││││││││││  ",
        " -585673043921.53 ┤││││││││││││││││││││││││││││││││││││││││││││││││││  ",
        "-1634437620306.47 ┤││││││││││││││││││││││││││││││││││││││││││││││││││  ",
        "-2683202196691.40 ┤││││││││││││││││││││││││││││││││││││││││││││││││││  ",
        "-3731966773076.33 ┤││││││││││││││││││││││││││││││││││││││││││││││││││  ",
        "-4780731349461.27 ┤││││││││││││││││││││││││││││││││││││││││││││││││││  ",
        "-5829495925846.20 ┤││││││││││││││││││││││││││││││││││││││││││││││││││  ",
        "-6878260502231.13 ┤││││││││││││││││││││││││││││││││││││││││││││││││││  ",
        "-7927025078616.07 ┤││││││││││││││││││││││││││││││││││││││││││││││││││  ",
        "-8975789655001.00 ┼╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰╯╰  ",
        "                                                       "
      ]
      |> Enum.join("\n")

    {:ok, actual_chart} = Asciichart.plot(series, height: 15)
    assert expected_chart == actual_chart

    series =
      [2591.22, 2720.08, 2723.58, 3255, 3445.28, 4382.74, 4159.46, 4137.67] ++
        [4387.46, 4630.73, 4631.69, 4638.1, 4188.84, 3686.9, 3897, 3777.29, 4208.56] ++
        [4394.64, 4322.75, 4772.97, 5640.13, 5595.23, 6013.23, 5733.9, 6140.53, 7030] ++
        [6958.21, 6570.31, 6598.77, 7776.94, 8230.69, 9326.59, 9916.54, 11616.85] ++
        [16057.14, 17178.1, 19343.04, 16454.72, 13975.44, 14428.76, 13412.44, 16937.17] ++
        [14439.47, 14188.78, 11141.25, 11522.86, 11137.24, 11158.39, 8827.63, 7700.39] ++
        [8556.61, 9477.84, 10396.63, 9830.43, 10313.08, 11019.52, 10709.53, 8787.16] ++
        [8196.9, 8196.02, 8712.89, 8138.34, 6844.32, 7417.89, 6896.28, 6939.55, 8357.04] ++
        [8273.74, 8938.3, 8978.33]

    expected_chart =
      [
        "19343.04 ┤                                                                       ",
        "18505.45 ┤                                   ╭╮                                  ",
        "17667.86 ┤                                   ││                                  ",
        "16830.27 ┤                                  ╭╯│   ╭╮                             ",
        "15992.68 ┤                                 ╭╯ ╰╮  ││                             ",
        "15155.09 ┤                                 │   │  ││                             ",
        "14317.49 ┤                                 │   │╭╮│╰─╮                           ",
        "13479.90 ┤                                 │   ╰╯╰╯  │                           ",
        "12642.31 ┤                                 │         │                           ",
        "11804.72 ┤                                ╭╯         │╭╮                         ",
        "10967.13 ┤                                │          ╰╯╰─╮      ╭─╮              ",
        "10129.54 ┤                               ╭╯              │   ╭──╯ │              ",
        " 9291.95 ┤                              ╭╯               ╰╮ ╭╯    │          ╭─  ",
        " 8454.36 ┤                             ╭╯                 │╭╯     ╰────╮   ╭─╯   ",
        " 7616.77 ┤                            ╭╯                  ╰╯           │╭╮ │     ",
        " 6779.18 ┤                        ╭───╯                                ╰╯╰─╯     ",
        " 5941.58 ┤                   ╭────╯                                              ",
        " 5103.99 ┤        ╭──╮      ╭╯                                                   ",
        " 4266.40 ┤    ╭───╯  ╰──────╯                                                    ",
        " 3428.81 ┤╭───╯                                                                  ",
        " 2591.22 ┼╯                                                                      ",
        "                                                                          "
      ]
      |> Enum.join("\n")

    {:ok, actual_chart} = Asciichart.plot(series, height: 20)
    assert expected_chart == actual_chart

    {:error, message} = Asciichart.plot([])
    assert message == "No data"
  end

  test "square charset" do
    series = (1..6 |> Enum.to_list()) ++ (6..1 |> Enum.to_list())

    expected_chart =
      [
        "6.00 ┤    ┌─┐      ",
        "5.00 ┤   ┌┘ └┐     ",
        "4.00 ┤  ┌┘   └┐    ",
        "3.00 ┤ ┌┘     └┐   ",
        "2.00 ┤┌┘       └┐  ",
        "1.00 ┼┘         └  ",
        "                "
      ]
      |> Enum.join("\n")

    {:ok, actual_chart} = Asciichart.plot(series, charset: Asciichart.Charset.square())
    assert expected_chart == actual_chart
  end

  test "single charset" do
    series = (1..6 |> Enum.to_list()) ++ (6..1 |> Enum.to_list())

    expected_chart =
      [
        "6.00 ┤    ***      ",
        "5.00 ┤   ** **     ",
        "4.00 ┤  **   **    ",
        "3.00 ┤ **     **   ",
        "2.00 ┤**       **  ",
        "1.00 **         *  ",
        "                "
      ]
      |> Enum.join("\n")

    {:ok, actual_chart} = Asciichart.plot(series, charset: Asciichart.Charset.single_char("*"))
    assert expected_chart == actual_chart
  end

  test "charset single char validation" do
    assert_raise ArgumentError, fn ->
      Asciichart.Charset.single_char("**")
    end
  end
end
