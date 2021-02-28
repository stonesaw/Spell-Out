class IWaveData
  attr_reader :proc_begin, :proc_update, :proc_end
  attr_accessor :field_image, :bg_image, :field_objects, :judge_flag, :spawn_tick

  def initialize(bg_image, field_objects, judge_flag: nil)
    @bg_image = bg_image
    @field_objects = field_objects
    @proc_begin = proc {}
    @proc_update = proc {}
    @proc_end = proc {}
    @judge_flag = judge_flag
    self
  end

  def when_begin(&block)
    @spawn_tick = Play.tick
    @proc_begin = block
    self
  end

  def when_update(&block)
    @proc_update = block
    self
  end

  def when_end(&block)
    @proc_end = block
    self
  end

  def passed_tick
    Play.tick - @spawn_tick
  end
end

class StageData
  class << self
    attr_accessor :list
  end

  def self.load(stage_name)
    if /(?<chapter>\d)-(?<section>\d)/ =~ stage_name
      send(:"load_#{chapter}_#{section}")
    else
      raise ArgumentError, "wrong stage_name (#{stage_name})"
    end
  end

  # return waves ( Array[IWaveData] )
  def self.load_1_1
    bg = Image.new(Window.width, Window.height, [142, 199, 95])
    field_objects = []
    2.times do |y|
      2.times do |x|
        w, h = Window.width - 100, Window.height - 100
        _x = [w * 0.2, w * 0.8]
        _y = [h * 0.2, h * 0.8]
        field_objects << Sprite.new(_x[x], _y[y], Image.new(50, 50, [70, 70, 70]))
      end
    end
    waves = []
    waves << IWaveData.new(bg, [
      Sprite.new(200, 600, Image.new(50, 50, [70, 70, 70])),
      Sprite.new(600, 200, Image.new(50, 50, [70, 70, 70]))]).
      when_begin do |wave|
        Enemy.new(SlimeWind.new, 100, 100)
      end.
      when_update do |wave|
      end
    waves << IWaveData.new(bg, []).
      when_begin do |wave|
        Enemy.new(SlimeWind.new, 100, 100)
        Enemy.new(SlimeWind.new, 700, 100)
      end
    waves << IWaveData.new(bg, field_objects).
      when_begin do |wave|
        Enemy.new(SlimeWind.new, 100, 100)
        Enemy.new(SlimeWind.new, 700, 100)
      end
  end
end
