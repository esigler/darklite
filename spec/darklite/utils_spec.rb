describe Darklite::Utils do
  let(:first_second) do
    Time.local(2015, 9, 1, 0, 0, 1)
  end

  let(:last_second) do
    Time.local(2015, 9, 1, 23, 59, 59)
  end

  let(:sunrise) do
    Time.local(2015, 9, 1, 6, 40, 0)
  end

  let(:sunset) do
    Time.local(2015, 9, 1, 19, 39, 0)
  end

  describe '#convert_to_seconds' do
    it 'returns time in seconds' do
      expect(described_class.convert_to_seconds(first_second)).to eq(1)
      expect(described_class.convert_to_seconds(last_second)).to eq(86_399)
    end
  end

  describe '#estimate_color_temperature' do
    it 'is NIGHTTIME_CT from midnight until sunrise' do
      expect_color_estimate(first_second, sunrise, sunset, 500)
      expect_color_estimate(sunrise, sunrise, sunset, 500)
    end

    it 'moves to DAYTIME_CT at sunrise' do
      expect_color_estimate(sunrise + 1, sunrise, sunset, 499)
      expect_color_estimate(sunrise + 600, sunrise, sunset, 153)
    end

    it 'stays at DAYTIME_CT from after sunrise to before sunset' do
      expect_color_estimate(sunrise + 601, sunrise, sunset, 153)
      expect_color_estimate(sunset - 1800, sunrise, sunset, 153)
    end

    it 'moves to EVENING_CT around sunset' do
      expect_color_estimate(sunset - 1799, sunrise, sunset, 153)
      expect_color_estimate(sunset - 1000, sunrise, sunset, 180)
      expect_color_estimate(sunset + 2400, sunrise, sunset, 294)
    end

    it 'moves to NIGHTTIME_CT after sunset' do
      expect_color_estimate(sunset + 2401, sunrise, sunset, 294)
      expect_color_estimate(sunset + 5000, sunrise, sunset, 406)
      expect_color_estimate(sunset + 7199, sunrise, sunset, 500)
    end

    it 'is NIGHTTIME_CT after sunset until midnight' do
      expect_color_estimate(sunset + 7200, sunrise, sunset, 500)
      expect_color_estimate(last_second, sunrise, sunset, 500)
    end
  end
end
