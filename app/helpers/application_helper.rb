module ApplicationHelper

  def formatted_city_name(city)
    "#{city.name}, #{city.country}"
  end

  def forecast_summary(days)
    summary = ""

    if days.any?(&:rain)
      summary << "Expect rain. "
    end

    temperatures = days.map { |d| d.temperature.day }
    summary << "Daily average %d°. " % temperatures.sum.fdiv(temperatures.size)

    summary << "Higest %d°. " % days.map { |d| d.temperature.max }.max
    summary << "Lowest %d°. " % days.map { |d| d.temperature.min }.min
  end
end
