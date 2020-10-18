require "dxruby"
require "json"
require "time"
require "pp"
require_relative "lib/public"
require_relative "lib/tools/debugger"
require_relative "lib/scene-manager"
require_relative "lib/ui"
require_relative "lib/text-box"
require_relative "lib/player"
require_relative "lib/bullet"
require_relative "lib/enemy-system"
require_relative "lib/enemies"
require_relative "lib/enemy-base"
require_relative "lib/data/enemies-data-list"
require_relative "lib/scenes/title"
require_relative "lib/scenes/play"
require_relative "lib/scenes/game-over"
require_relative "lib/scenes/ranking"


Debugger.new

SceneManager.new({
  title: Title,
  play: Play,
  game_over: GameOver,
  ranking: Ranking
})


Window.loop do
  break if Input.key_down?(K_ESCAPE)
  Mouse.update
  SceneManager.update
  SceneManager.draw
  Debugger.block_call
  Debugger.draw_msg
end
