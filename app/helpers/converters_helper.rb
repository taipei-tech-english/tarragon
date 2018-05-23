module ConvertersHelper
  def format_conversion_result(result)
    if result.is_a?(ArgumentError)
      result
    else
      case result[:type]
        when :ce_date
          'date in common era'
        when :ce_date_range
          'date range in common era'
        when :ce_semester
          'semester in common era'
        when :ce_semester_range
          'semester range in common era'
      end
    end
  end
end
