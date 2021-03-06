require 'dxruby'
require 'json'
require 'time'
require 'pp'

$PATH = File.dirname(__FILE__)

Window.width = 1280
Window.height = 960
Window.scale = 0.8
Window.caption = 'Spell Out'
Window.bgcolor = [26, 26, 26]

Font.install("#{$PATH}/assets/font/Poco.ttf")
Font.install("#{$PATH}/assets/font/misaki_gothic.ttf")

$debug_mode = ARGV.include?('debug') || ARGV.include?('-d')
$score = 0
$stage = 1

require_relative 'lib/utils/wrapper'
require_relative 'lib/utils/scene_manager'
require_relative 'lib/utils/debugger'
require_relative 'lib/utils/bgm'
require_relative 'lib/utils/se'
require_relative 'lib/utils/hp_bar'
require_relative 'lib/utils/text_box'
require_relative 'lib/utils/seek_bar'
require_relative 'lib/player'
require_relative 'lib/bullet'
require_relative 'lib/enemy'
require_relative 'lib/stage'
require_relative 'lib/data/sprite_data'
require_relative 'lib/data/enemies_data'
require_relative 'lib/data/bullet_data'
require_relative 'lib/data/stage_data'
require_relative 'lib/scenes/loading'
require_relative 'lib/scenes/title'
require_relative 'lib/scenes/stage_select'
require_relative 'lib/scenes/play_cut_in'
require_relative 'lib/scenes/play'
require_relative 'lib/scenes/menu'
require_relative 'lib/scenes/game_over'
require_relative 'lib/scenes/ranking'

Debugger.new(font_size: 48)

SceneManager.new({
  title: Title,
  stage_select: StageSelect,
  play_cut_in: PlayCutIn,
  play: Play,
  menu: Menu,
  game_over: GameOver,
  ranking: Ranking,
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
