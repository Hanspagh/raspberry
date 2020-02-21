use Mix.Config

config :oko_controller, :viewport, %{
  name: :main_viewport,
  default_scene: {OkoController.Scene.CodeInput, nil},
  # default_scene: {OkoController.Scene.SysInfo, nil},
  size: {600, 600},
  opts: [scale: 1.0],
  drivers: [
    %{
      module: Scenic.Driver.Glfw,
      opts: [title: "MIX_TARGET=host, app = :oko_controller"]
    }
  ]
}
