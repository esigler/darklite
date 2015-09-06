# Code's gotta go somewhere
module Darklite
  # Utilities for common use
  class Utils
    # TODO: Convert to runtime config
    NIGHTTIME_CT = 500
    EVENING_CT = 294
    DAYTIME_CT = 153

    def self.change_lights(brightness, temperature)
      Huey::Bulb.all.update(bri: brightness, ct: temperature, on: true)
    end

    def self.turn_off_lights
      Huey::Bulb.all.update(on: false)
    end

    def self.convert_to_seconds(time)
      (time.hour * 3600) + (time.min * 60) + time.sec
    end

    def self.interpolate(start, stop, step, resolution)
      ratio = step.to_f / resolution.to_f

      if start < stop
        (((stop - start) * ratio) + start).round
      else
        (((start - stop) * (1 - ratio)) + stop).round
      end
    end

    # TODO: Convert from fixed windows to proper twilight/dusk calculations
    # rubocop:disable AbcSize, MethodLength
    def self.estimate_color_temperature(current_time, sunrise_time, sunset_time)
      current = convert_to_seconds(current_time)
      sunrise = convert_to_seconds(sunrise_time)
      sunset  = convert_to_seconds(sunset_time)

      case current
      # Morning Transition -> Daytime
      when sunrise + 1..sunrise + 600
        interpolate(NIGHTTIME_CT, DAYTIME_CT, (current - sunrise), 600)
      # Daytime -> Evening Transition
      when sunrise + 601..sunset - 1800
        DAYTIME_CT
      # Evening Transition -> Evening
      when sunset - 1799..sunset + 2400
        interpolate(DAYTIME_CT, EVENING_CT, current - (sunset - 1799), 4200)
      # Evening -> Night Transition
      when sunset + 2401..sunset + 7199
        interpolate(EVENING_CT, NIGHTTIME_CT, current - (sunset + 2401), 4800)
      else
        NIGHTTIME_CT
      end
    end
    # rubocop:enable AbcSize, MethodLength
  end
end
