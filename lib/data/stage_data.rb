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

  def self.load(stage_str, player)
    if /(?<chapter>\d)-(?<section>\d)/ =~ stage_str
      send(:"load_#{chapter}_#{section}", player)
    else
      raise ArgumentError, "wrong stage_str (#{stage_str})"
    end
  end

  # return IStageData
  def self.load_1_1(_player)
    bg_gray = Image.new(Window.width, Window.height, [140, 140, 140])
    waves = []
    waves << IWaveData.new(bg_gray, []).
      when_begin do |stage, tick, player|
        Debugger.puts 'wave 1/3 begin!'
        Enemy.new(EnemiesData.list[:slime2], tick, 100, 100, player)
      end.
      when_update do |stage, tick, player|
        Debugger.puts 'wave 1/3 update!'
      end.
      when_end do |stage, tick, player|
        Debugger.puts 'wave 1/3 end!'
      end

    waves << IWaveData.new(bg_gray, []).
      when_begin do |stage, tick, player|
        Debugger.puts 'wave 2/3 begin!'
      end.
      when_update do |stage, tick, player|
        Debugger.puts 'wave 2/3 update!'
      end.
      when_end do |stage, tick, player|
        Debugger.puts 'wave 2/3 end!'
      end

    # return
    Stage.new('1-1', waves, _player)
  end
end
