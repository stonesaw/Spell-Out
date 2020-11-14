require "dxruby"
require "json"
require "time"
require "pp"

$PATH = File.dirname(__FILE__)

require_relative "lib/public"
require_relative "lib/tools/debugger"
require_relative "lib/scene-manager"
require_relative "lib/bgm"
require_relative "lib/ui"
require_relative "lib/text-box"
require_relative "lib/player"
require_relative "lib/player-setting"
require_relative "lib/bullet"
require_relative "lib/enemy-system"
require_relative "lib/enemies"
require_relative "lib/enemy-base"
require_relative "lib/data/enemies-data-list"
require_relative "lib/scenes/title"
require_relative "lib/scenes/play"
require_relative "lib/scenes/menu"
require_relative "lib/scenes/game-over"
require_relative "lib/scenes/ranking"


BGM.new
Debugger.new

SceneManager.new({
  title: Title,
  play: Play,
  menu: Menu,
  game_over: GameOver,
  ranking: Ranking
})


Window.loop do
  Window.close if Input.key_down?(K_ESCAPE)
  Mouse.update
  SceneManager.update
  SceneManager.draw
  BGM.update
  if $debug_mode
    Debugger.block_call
    Debugger.draw_msg
  end
end
