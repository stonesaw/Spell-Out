class Stage
  attr_reader :is_clear

  def initialize(name, waves)
    @name = name
    @waves = waves
    @now = 0
    @wave = @waves[@now]
    @is_clear = false
    @wave.proc_begin.call(self)
  end

  def update
    Debugger.puts("stage update")
    # if (@now == @waves.length && Enemy.list.length == 0) || (@boss_flag && !exists_boss?)
    #   @is_clear = true
    # end
    @wave.proc_update.call(self)

    # wave clear
    if Enemy.list.length == 0
      @wave.proc_end.call(self)
      @now += 1
      if @now > @waves.length - 1
        @is_clear = true
      else
        @wave = @waves[@now]
        @wave.proc_begin.call(self)
      end
    end
  end

  def draw
    Window.draw(0, 0, @wave.bg_image)
    # Sprite.draw(@wave.field_objects)
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
