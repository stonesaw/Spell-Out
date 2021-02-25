class IWaveData
  attr_reader :proc_begin, :proc_update, :proc_end
  attr_accessor :field_image, :bg_image

  def initialize(bg_image, field_objects)
    @bg_image = bg_image
    @field_objects = field_objects
    @proc_begin = proc {}
    @proc_update = proc {}
    @proc_end = proc {}
    self
  end

  def when_begin(&block)
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
    bg_gray = Image.new(Window.width, Window.height, [140, 140, 140])
    waves = []
    waves << IWaveData.new(bg_gray, []).
      when_begin do |stage|
        Debugger.puts 'wave 1/3 begin!'
        # Enemy.new(SlimeWind.new, 100, 100)
        # Enemy.new(SlimeWind.new, 700, 100)
      end.
      when_update do |stage|
        Debugger.puts 'wave 1/3 update!'
      end.
      when_end do |stage|
        Debugger.puts 'wave 1/3 end!'
      end

    waves << IWaveData.new(bg_gray, []).
      when_begin do |stage|
        # Debugger.puts 'wave 2/3 begin!'
        Enemy.new(SlimeWind.new, 100, 100)
      end.
      when_update do |stage|
        Debugger.puts 'wave 2/3 update!'
      end.
      when_end do |stage|
        Debugger.puts 'wave 2/3 end!'
      end
  end
end
