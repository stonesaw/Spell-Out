class Boss < Enemies
  def initialize
    @@is_alive = true
    super
  end

  class << self
    def update
      super
      @@is_alive = !list.empty?
      p 'call'
    end

    def draw
      super
    end

    def is_alive
      @@is_alive
    end
  end
end

Boss.new
