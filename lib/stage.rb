class Stage
  attr_reader :is_clear

  def initialize(name, waves, player)
    @name = name
    @waves = waves
    @now = 0
    @wave = @waves[@now]
    @is_clear = false
    @wave.proc_begin.call(self, 0, player)
  end

  def update(tick, player)
    Debugger.puts("stage update")
    # if (@now == @waves.length && Enemy.list.length == 0) || (@boss_flag && !exists_boss?)
    #   @is_clear = true
    # end
    @wave.proc_update.call(self, tick, player)

    # wave clear
    if Enemy.list.length == 0
      @wave.proc_end.call
      @now += 1
      if @now > @waves.length - 1
        @is_clear = true
      else
        @wave = @waves[@now]
        @wave.proc_begin.call(self, tick, player)
      end
    end
  end

  def draw
    Window.draw(0, 0, @wave.bg_image)
  end

  def exists_boss?
    @boss.each do |b|
      return true if Enemy.list.include?(b)
    end
    false
  end
end
