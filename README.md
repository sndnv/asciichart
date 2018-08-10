# asciichart

[![Hex version badge](https://img.shields.io/hexpm/v/asciichart.svg)](https://hex.pm/packages/asciichart) [![Travis](https://travis-ci.org/sndnv/asciichart.svg?branch=master)](https://travis-ci.org/sndnv/asciichart) [![Coverage Status](https://coveralls.io/repos/github/sndnv/asciichart/badge.svg?branch=master)](https://coveralls.io/github/sndnv/asciichart?branch=master) [![license](https://img.shields.io/github/license/sndnv/asciichart.svg)]()

Terminal ASCII line charts in Elixir with no dependencies.

<img width="789" alt="Terminal ASCII line charts in Elixir" src="https://cloud.githubusercontent.com/assets/1294454/22818709/9f14e1c2-ef7f-11e6-978f-34b5b595fb63.png">

Ported to Elixir from [kroitor/asciichart](https://github.com/kroitor/asciichart)

## Install

Add `asciichart` to the list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:asciichart, "~> 1.0"}]
end
```

## Usage

```elixir
{:ok, chart} = Asciichart.plot([1, 2, 3, 3, 2, 1])
chart |> IO.puts()

# should render as

3.00 ┤ ╭─╮
2.00 ┤╭╯ ╰╮
1.00 ┼╯   ╰
```

## Options
One or more of following settings can be provided:
- `offset` - the number of characters to set as the chart's offset (left)
- `height` - adjusts the height of the chart
- `padding` - one or more characters to use for the label's padding (left)

```elixir
{:ok, chart} = Asciichart.plot([1, 2, 5, 5, 4, 3, 2, 100, 0], height: 3, offset: 10, padding: "__")
chart |> IO.puts()

# should render as

       ╭─> label
    ------
    100.00    ┼      ╭╮
    _50.00    ┤      ││
    __0.00    ┼──────╯╰
    --
---- ╰─> label padding
 ╰─> remaining offset (without the label)

# Rendering of empty charts is not supported

Asciichart.plot([])
{:error, "No data"}

```

## Versioning
We use [SemVer](http://semver.org/) for versioning.

## License
This project is licensed under the Apache License, Version 2.0 - see the [LICENSE](LICENSE) file for details

> Copyright 2018 https://github.com/sndnv
>
> Licensed under the Apache License, Version 2.0 (the "License");
> you may not use this file except in compliance with the License.
> You may obtain a copy of the License at
>
> http://www.apache.org/licenses/LICENSE-2.0
>
> Unless required by applicable law or agreed to in writing, software
> distributed under the License is distributed on an "AS IS" BASIS,
> WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
> See the License for the specific language governing permissions and
> limitations under the License.
