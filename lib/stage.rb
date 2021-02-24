class Stage
  def initialize(waves)
    @waves = waves
    @now = 1
    @wave = waves[0]
    @is_clear = false
    @wave.proc_started.call
  end

  def update
    # TODO wave when_started の後
    if (@now == @waves.length && Enemy.list.length == 0) || (@boss_flag && !exists_boss?)
      @is_clear = true
    end
  end

  def exists_boss?
    @boss.each do |b|
      return true if Enemy.list.include?(b)
    end
    false
  end
end
