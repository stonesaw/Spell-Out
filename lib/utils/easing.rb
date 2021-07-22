# Easing Referrence
# https://easings.net/
# http://gizma.com/easing/


class Easing
  # 0.0 <= t < 1.0

  @_tick = 0
  @_processor = {}

  class << self
    attr_accessor :_tick, :time, :_processor

    def _update
      @_tick += 1
      @time = @_tick / 60.0

      @_processor.each { |key, process| process.call }
    end

    # return [t, b, c, d]
    private def _ease_fanc_init(start_value, change_value, duration: 1.0, _passed_tick: nil)
      if _passed_tick.nil?
        t = @time
      else
        t = (@_tick - _passed_tick) / 60.0
      end
      b = start_value.to_f
      c = change_value.to_f
      d = duration.to_f
      [t, b, c, d]
    end
  end

  Window.before_call[:easing_update] = method(:_update)

  def initialize(obj, target_attr, ease_sym, start_val, end_val)
    @obj = obj
    @target_attr = target_attr.to_sym
    @ease_sym = ease_sym

    t = self.class._tick
    case @obj
    when Array
      self.class._processor[:"#{obj.object_id}_#{@target_attr}"] = proc {
        obj.each do |o|
          o.method("#{@target_attr}=").call(
            self.class.method(ease_sym).call(start_val, end_val, _passed_tick: t)
          )
        end
      }
    else
      self.class._processor[:"#{obj.object_id}_#{@target_attr}"] = proc {
        obj.method("#{@target_attr}=").call(
          self.class.method(ease_sym).call(start_val, end_val, _passed_tick: t)
        )
      }
    end
  end


  # === sine ===
  def self.ease_in_sine(start_value, change_value, duration: 1.0, **args)
    t, b, c, d = *_ease_fanc_init(start_value, change_value, duration: duration, **args)

    t %= d # loop
    -c * Math.cos(t / d * (Math::PI / 2)) + c + b
  end

  def self.ease_out_sine(start_value, change_value, duration: 1.0, **args)
    t, b, c, d = *_ease_fanc_init(start_value, change_value, duration: duration, **args)

    t %= d # loop
    c * Math.sin(t / d * (Math::PI / 2)) + b
  end

  def self.ease_in_out_sine(start_value, change_value, duration: 1.0, **args)
    t, b, c, d = *_ease_fanc_init(start_value, change_value, duration: duration, **args)

    t %= d # loop
    -c / 2 * (Math.cos(Math::PI * t / d) - 1) + b
  end

  # === quad ===
  def self.ease_in_quad(start_value, change_value, duration: 1.0, **args)
    t, b, c, d = *_ease_fanc_init(start_value, change_value, duration: duration, **args)

    t %= d # loop
    t /= d
	  c * t * t + b
  end

  def self.ease_out_quad(start_value, change_value, duration: 1.0, **args)
    t, b, c, d = *_ease_fanc_init(start_value, change_value, duration: duration, **args)

    t %= d # loop
    t /= d
	  -c * t * (t - 2) + b
  end

  def self.ease_in_out_quad(start_value, change_value, duration: 1.0, **args)
    t, b, c, d = *_ease_fanc_init(start_value, change_value, duration: duration, **args)

    t %= d # loop
    t /= d/2
    return c / 2 * t * t + b if t < 1
    t -= 1
    -c / 2 * (t * (t - 2) - 1) + b
  end

  # === cubic ===
  def self.ease_in_cubic(start_value, change_value, duration: 1.0, **args)
    t, b, c, d = *_ease_fanc_init(start_value, change_value, duration: duration, **args)

    t %= d # loop
    t /= d
    c * t * t * t + b
  end

  def self.ease_out_cubic(start_value, change_value, duration: 1.0, **args)
    t, b, c, d = *_ease_fanc_init(start_value, change_value, duration: duration, **args)

    t %= d # loop
    t /= d
    t -= 1
    c * (t * t * t + 1) + b
  end

  def self.ease_in_out_cubic(start_value, change_value, duration: 1.0, **args)
    t, b, c, d = *_ease_fanc_init(start_value, change_value, duration: duration, **args)

    t %= d # loop
    t /= d / 2.0
    if t < 1
      c / 2.0 * t * t * t + b
    else
      t -= 2
      c / 2.0 * (t * t * t + 2) + b
    end
  end

  # === quart ===
  def self.ease_in_quart(start_value, change_value, duration: 1.0, **args)
    t, b, c, d = *_ease_fanc_init(start_value, change_value, duration: duration, **args)

    t %= d # loop
    t /= d
	  c * t * t * t * t + b
  end

  def self.ease_out_quart(start_value, change_value, duration: 1.0, **args)
    t, b, c, d = *_ease_fanc_init(start_value, change_value, duration: duration, **args)

    t %= d # loop
    t /= d
    t -= 1
    -c * (t * t * t * t - 1) + b
  end

  def self.ease_in_out_quart(start_value, change_value, duration: 1.0, **args)
    t, b, c, d = *_ease_fanc_init(start_value, change_value, duration: duration, **args)

    t %= d # loop
    t /= d / 2
    return c / 2 * t * t * t * t + b if t < 1
    t -= 2
    -c / 2 * (t * t * t * t - 2) + b
  end
end
