class IStageData
  def initialize(name, wave_list)
    @name = name.to_s
    @waves = wave_list
  end
end

class IWaveData
  def initialize(bg_image, field_objects)
    @bg_image = bg_image
    @field_objects = field_objects
    @proc_started = proc {}
    @proc_update  = proc {}
    self
  end

  def when_begin(&block)
    @proc_started = block
    self
  end

  def when_update(&block)
    @proc_update = block
    self
  end

  def when_end(&block)
    @proc_started = block
    self
  end
end

class StageData
  class << self
    attr_accessor :list
  end

  def self.load(stage_str)
    if /(?<chapter>\d)-(?<section>\d)/ =~ stage_str
      send(:"load_#{chapter}_#{section}")
    else
      raise ArgumentError, "wrong stage_str (#{stage_str})"
    end
  end

  # return IStageData
  def self.load_1_1
    p "loading 1-1"
    bg_gray = Image.new(Window.width, Window.height, [140, 140, 140])
    waves = []
    waves << IWaveData.new(bg_gray, []).
      when_begin do
        p 'wave 1/3 begin!'
      end
    waves << IWaveData.new(bg_gray, []).
      when_update do
      p 'wave 2/3 update!'
    end

    # return
    IStageData.new('1-1', waves)
  end
end
