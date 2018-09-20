module Converter
  class Translator < ConverterBase
    def translate(input)
      if valid_input?(input)
        get_results(input)
      end
    end

    private
      def get_results(input)
        case input[:type]
          when :ce_date
            results = {
              ce_semester:       "#{@@SEM_FALL} 2017",
              mg_semester:       '106-1',
              ce_semester_begin: Date.new(2017,8,1),
              ce_semester_end:   Date.new(2018,1,31),
              ce_school_begin:   Date.new(2017,9,11),
              ce_school_end:     Date.new(2018,1,19),
              mg_semester_begin: '106/8/1',
              mg_semester_end:   '107/1/31',
              mg_school_begin:   '106/9/11',
              mg_school_end:     '107/1/19'
            }
        end

        results
      end

      def ce_date_to_ce_semester(input)

      end

      def valid_input?(input)
        true
      end
  end
end
