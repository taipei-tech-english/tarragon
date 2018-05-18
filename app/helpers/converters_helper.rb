module ConvertersHelper
  def format_conversion_result(result)
    if result.is_a?(ArgumentError)
      result
    else
      if result[:type] == :ce_date
        'date in common era'
      end
    end
  end
end
