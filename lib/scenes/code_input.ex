defmodule OkoController.Scene.CodeInput do

  use Scenic.Scene

  alias Scenic.ViewPort
  alias Scenic.Graph
  alias Scenic.Primitive
  import Scenic.Primitives
  alias Scenic.ViewPort.Context
  alias Scenic.Component.Input
  import Scenic.Components
  alias OkoController.Components.AutoFocusTextField



  @width 600
  @height 600
  @hint_color :grey
  @default_font_size 22

  @graph Graph.build(font: :roboto, font_size: @default_font_size)
         |> rect({@width, @height}, id: :background)
         |> text("", id: :message, t: {175, 400}, fill: @hint_color)
         |> group(
          fn g ->
            g
            |> text( "_",
         fill: @hint_color,
         t: {20, 30},
         id: :text_1)
         |> rect(
          {50, 50},
          fill: :clear,
          stroke: {2, :gray},
          id: :border_1
        )
          end,
          t: {100, 300}
        )
        |> group(
          fn g ->
            g
            |> text( "_",
         fill: @hint_color,
         t: {20, 30},
         id: :text_2)
         |> rect(
          {50, 50},
          fill: :clear,
          stroke: {2, :gray},
          id: :border_2
        )
          end,
          t: {200, 300}
        )
        |> group(
          fn g ->
            g
            |> text( "_",
         fill: @hint_color,
         t: {20, 30},
         id: :text_3)
         |> rect(
          {50, 50},
          fill: :clear,
          stroke: {2, :gray},
          id: :border_3
        )
          end,
          t: {300, 300}
        )
        |> group(
          fn g ->
            g
            |> text( "_",
         fill: @hint_color,
         t: {20, 30},
         id: :text_4)
         |> rect(
          {50, 50},
          fill: :clear,
          stroke: {2, :gray},
          id: :border_4
        )
          end,
          t: {400, 300}
        )



  # ============================================================================
  # setup

  # --------------------------------------------------------
  def init(_, opts) do

    {:ok, %{graph: @graph, current_code: ""}, push: @graph}
  end


  def handle_input({:codepoint, {char, _}}, _, state) do
    { graph, new_state} =
    char
    |> accept_char?()
    |> do_handle_codepoint(char, state)
    {:noreply, new_state, push: graph}
  end

  def accept_char?(char) do
    "0123456789" =~ char
  end

  defp do_handle_codepoint(
    true,
    char,
    %{
      current_code: code,
      graph: graph,
    } = state
  ) do

    code = code <> char

    {new_code, graph} =
      cond do
        String.length(code) > 4 -> {char, reset(graph)}
        String.length(code) == 4 -> {code, success(graph, code)}
        true -> {code, graph}
    end


    length = String.length(new_code) |> Integer.to_string()
    string_id = String.to_atom("text_" <> length)
    border_id = String.to_atom("border_" <> length)

    graph =
      graph
      |> update_text(char, string_id, border_id)


    state =
      state
      |> Map.put(:graph, graph)
      |> Map.put(:current_code, new_code)


    {graph, state}
  end


  def reset(graph) do
    Graph.modify(graph, :text_1, &text(&1, "_"))
    |> Graph.modify(:text_2, &text(&1, "_"))
    |> Graph.modify(:text_3, &text(&1, "_"))
    |> Graph.modify(:text_4, &text(&1, "_"))
    |> Graph.modify(:border_1, &update_opts(&1, stroke: {2, :gray}))
    |> Graph.modify(:border_2, &update_opts(&1, stroke: {2, :gray}))
    |> Graph.modify(:border_3, &update_opts(&1, stroke: {2, :gray}))
    |> Graph.modify(:border_4, &update_opts(&1, stroke: {2, :gray}))
    |> Graph.modify(:message, &text(&1, ""))

  end

  defp do_handle_codepoint(_not_acepted, char, state), do: {:noreply, state}

  defp update_text(graph, value, id, border_id) do
    Graph.modify(graph, id, &text(&1, value))
    |> Graph.modify(border_id, &update_opts(&1, stroke: {2, :green}))
  end

  defp success(graph, code) do
    case :ets.lookup(:codes, code) do
      [{code, box}] -> Graph.modify(graph, :message, &text(&1, "Correct code for box_#{box}"))
      [] -> Graph.modify(graph, :message, &text(&1, "No box for that code"))
    end


  end

  def handle_input(msg, _context, state) do
    # IO.puts "TextField msg: #{inspect(msg)}"
    {:noreply, state}
  end


end
