class Stage
  attr_reader :is_clear, :name, :waves, :now, :wave

  def initialize(name, waves)
    @name = name
    @waves = waves
    @now = 0
    @wave = @waves[@now]
    @is_clear = false
    @wave.proc_begin.call(@wave)
    @wave.spawn_tick = Play.tick
  end

  def update
    # if (@now == @waves.length && Enemy.list.length == 0) || (@boss_flag && !exists_boss?)
    #   @is_clear = true
    # end
    @wave.proc_update.call(@wave)

    # wave clear
    if (Enemy.list.length == 0 && @wave.judge_flag.nil?) || @wave.judge_flag == true
      @wave.proc_end.call(@wave)
      @now += 1
      if @now > @waves.length - 1
        @is_clear = true
      else
        @wave = @waves[@now]
        @wave.proc_begin.call(@wave)
        @wave.spawn_tick = Play.tick
      end
    end
  end

  def draw
    Window.draw(0, 0, @wave.bg_image)
    Sprite.draw(@wave.field_objects)
  end

  def objects
    @wave.field_objects
  end

  def objects=(item)
    @wave.field_objects = item
  end

  def exists_boss?
    @boss.each do |b|
      return true if Enemy.list.include?(b)
    end
    false
  end
end
