class IWaveData
  attr_reader :proc_begin, :proc_update, :proc_end
  attr_accessor :field_image, :bg_image, :field_objects, :judge_flag, :spawn_tick

  def initialize(bg_image, field_objects, use_judge_flag: false)
    @bg_image = bg_image
    @field_objects = field_objects
    @proc_begin = proc {}
    @proc_update = proc {}
    @proc_end = proc {}
    @judge_flag = use_judge_flag ? false : nil
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
      Sprite.new(600, 200, Image.new(50, 50, [70, 70, 70])),
    ]).
      when_begin do |wave|
        Enemy.new(SlimeWind.new, 100, 100)
      end.
      when_update do |wave|
      end

    waves << IWaveData.new(bg, [
      Sprite.new(800, 400, Image.new(50, 50, [70, 70, 70])),
    ]).
      when_begin do |wave|
        Enemy.new(SlimeWind.new, 100, 100)
        Enemy.new(SlimeWind.new, 700, 100)
      end

    waves << IWaveData.new(bg, field_objects).
      when_begin do |wave|
        Enemy.new(SlimeWind.new, 100, 100)
        Enemy.new(SlimeWind.new, 700, 100)
      end
    waves
  end

  def self.load_1_2
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
    waves << IWaveData.new(bg, field_objects).
      when_begin do |wave|
        Enemy.new(SlimeWind.new, 300, 110)
        Enemy.new(SlimeWind.new, 900, 350)
      end

    waves << IWaveData.new(bg, field_objects).
      when_begin do |wave|
        Enemy.new(SlimeWater.new, 300, 110)
        Enemy.new(SlimeWater.new, 900, 350)
      end
    waves
  end

  def self.load_1_3
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
    waves << IWaveData.new(bg, field_objects).
      when_begin do |wave|
        Enemy.new(SlimeWind.new, 300, 70)
        Enemy.new(SlimeWind.new, 500, 350)
        Enemy.new(SlimeWind.new, 700, 70)
        Enemy.new(SlimeWind.new, 900, 350)
      end

    waves << IWaveData.new(bg, field_objects).
      when_begin do |wave|
        Enemy.new(SlimeWater.new, 300, 350)
        Enemy.new(SlimeWater.new, 500, 70)
        Enemy.new(SlimeWater.new, 700, 350)
        Enemy.new(SlimeWater.new, 900, 70)
      end

    waves << IWaveData.new(bg, field_objects).
      when_begin do |wave|
        Enemy.new(SlimeWater.new, 300, 70)
        Enemy.new(SlimeWind.new, 500, 350)
        Enemy.new(SlimeWater.new, 700, 70)
        Enemy.new(SlimeWind.new, 900, 350)
      end
    waves
  end

  def self.load_1_4
    bg = Image.new(Window.width, Window.height, [183, 212, 116])
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
    waves << IWaveData.new(bg, field_objects).
      when_begin do |wave|
        Enemy.new(SlimeWind.new, 300, 70)
      end
    waves << IWaveData.new(bg, field_objects).
      when_begin do |wave|
        Enemy.new(SlimeWind.new, 300, 70)
      end
    waves
  end

  def self.load_1_5
    bg = Image.new(Window.width, Window.height, [183, 212, 116])
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
    waves << IWaveData.new(bg, field_objects).
      when_begin do |wave|
        Enemy.new(SlimeWind.new, 300, 70)
        Enemy.new(SlimeWind.new, 500, 350)
        Enemy.new(SlimeWind.new, 700, 70)
        Enemy.new(SlimeWind.new, 900, 350)
      end

    waves << IWaveData.new(bg, field_objects).
      when_begin do |wave|
        Enemy.new(SlimeWater.new, 300, 350)
        Enemy.new(SlimeWater.new, 500, 70)
        Enemy.new(SlimeWater.new, 700, 350)
        Enemy.new(SlimeWater.new, 900, 70)
      end

    waves << IWaveData.new(bg, field_objects).
      when_begin do |wave|
        Enemy.new(SlimeWater.new, 300, 70)
        Enemy.new(SlimeWind.new, 500, 350)
        Enemy.new(SlimeWater.new, 700, 70)
        Enemy.new(SlimeWind.new, 900, 350)
      end
    waves
  end

  def self.load_1_6
    bg = Image.new(Window.width, Window.height, [193, 201, 115])
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
    waves << IWaveData.new(bg, field_objects).
      when_begin do |wave|
        Enemy.new(SlimeWind.new, 300, 70)
        Enemy.new(SlimeWind.new, 500, 350)
      end

    waves << IWaveData.new(bg, [], use_judge_flag: true).
      when_update do |wave|
        passed_tick = Play.tick - wave.spawn_tick

        if passed_tick < 600 && passed_tick % 200 == 1
          case passed_tick / 100
          when 0
            Enemy.new(Golem.new, Window.width * 0.5, -200)
          when 2
            Enemy.new(Golem.new, Window.width * 0.3, -200)
          when 4
            Enemy.new(Golem.new, Window.width * 0.7, -200)
          end
        end

        if passed_tick % 300 == 299
          Enemy.new(SlimeWind.new, 100 + rand(Window.width - 200), -100)
        end

        if passed_tick >= 600
          exist_golelm = Enemy.list.map {|e| true if e.data.name == 'ゴーレム' }
          if exist_golelm.compact.empty?
            wave.judge_flag = true
          end
        end
      end
    waves
  end
end
