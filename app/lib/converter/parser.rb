module Converter
  class Parser
    def parse(raw_input)
      { type: get_type(raw_input) }
    end

    private
      DATE_DELIMITERS = '(\/|-|–|\.| )'
      DATE_RANGE_DELIMITERS = '(-|–| )'
      SEM_SPRING = 'spring'
      SEM_FALL = 'fall'

      def get_type(raw_input)
        single_ce_semester  = "(#{SEM_SPRING}|#{SEM_FALL}) " + '\d{4}'
        single_ce_date      = '\d{4}' + "#{DATE_DELIMITERS}" + '\d{1,2}' + "#{DATE_DELIMITERS}" + '\d{1,2}'
        single_mg_semester  = '\d{1,3}\-[12]'
        single_mg_date      = '\d{1,3}' + "#{DATE_DELIMITERS}" + '\d{1,2}' + "#{DATE_DELIMITERS}" + '\d{1,2}'

        processed_input     = raw_input.strip.downcase
        regex_ce_semester   = /^#{single_ce_semester}$/
        regex_ce_date       = /^#{single_ce_date}$/
        regex_ce_date_range = /^#{single_ce_date}#{DATE_RANGE_DELIMITERS}#{single_ce_date}$/
        regex_ce_semester_range = /^#{single_ce_semester}#{DATE_RANGE_DELIMITERS}#{single_ce_semester}$/
        regex_mg_semester   = /^#{single_mg_semester}$/
        regex_mg_date       = /^#{single_mg_date}$/
        regex_mg_date_range = /^#{single_mg_date}#{DATE_RANGE_DELIMITERS}#{single_mg_date}$/
        regex_mg_semester_range = /^#{single_mg_semester}#{DATE_RANGE_DELIMITERS}#{single_mg_semester}$/

        case
        when regex_ce_semester.match?(processed_input)
          type = :ce_semester if legal_ce_semester?(processed_input)
        when regex_ce_date.match?(processed_input)
          type = :ce_date if legal_ce_date?(processed_input)
        when regex_ce_date_range.match?(processed_input)
          type = :ce_date_range if legal_ce_date_range?(processed_input)
        when regex_ce_semester_range.match?(processed_input)
          type = :ce_semester_range if legal_ce_semester_range?(processed_input)
        when regex_mg_semester.match?(processed_input)
          type = :mg_semester if legal_mg_semester?(processed_input)
        when regex_mg_date.match?(processed_input)
          type = :mg_date if legal_mg_date?(processed_input)
        when regex_mg_date_range.match?(processed_input)
          type = :mg_date_range if legal_mg_date_range?(processed_input)
        when regex_mg_semester_range.match?(processed_input)
          type = :mg_semester_range if legal_mg_semester_range?(processed_input)
        else
          raise ArgumentError, 'Input is unrecognizable. Please check your input and try again.'
        end

        type
      end

      def legal_ce_semester?(input)
        year = input.split(' ')[1].to_i
        raise ArgumentError, 'Minguo wasn’t existent before 1912.' if year < 1912
        true
      end

      def legal_ce_date?(input)
        normalized_date = normalize_date_format(input)
        date_obj = convert_to_date_object(normalized_date)
        raise ArgumentError, 'Minguo wasn’t existent before 1912.' if date_obj.year < 1912
        true
      end

      def legal_ce_date_range?(input)
        normalized_input = normalize_date_format(input)
        split = normalized_input.split('/')
        date1_obj = convert_to_date_object("#{split[0]}/#{split[1]}/#{split[2]}")
        date2_obj = convert_to_date_object("#{split[3]}/#{split[4]}/#{split[5]}")

        raise ArgumentError, 'You’ve entered an invalid date range. Please check your input and try again.' if date1_obj > date2_obj
        raise ArgumentError, 'Minguo wasn’t existent before 1912.' if date1_obj.year < 1912 || date2_obj.year < 1912
        true
      end

      def legal_ce_semester_range?(input)
        normalized_input = normalize_date_format(input)
        sem1, year1, sem2, year2 = input.split('/')
        year1 = year1.to_i
        year2 = year2.to_i

        if year1 == year2
          raise ArgumentError, 'You’ve entered an invalid semester range. Please check your input and try again.' if sem1 == SEM_FALL && sem2 == SEM_SPRING
        elsif year1 > year2
          raise ArgumentError, 'You’ve entered an invalid semester range. Please check your input and try again.'
        else
          raise ArgumentError, 'Minguo wasn’t existent before 1912.' if year1 < 1912 || year2 < 1912
        end

        true
      end

      def legal_mg_semester?(input)
        year = input.split('-')[0].to_i
        raise ArgumentError, 'Minguo wasn’t existent.' if year == 0
        true
      end

      def legal_mg_date?(input)
        normalized_date = normalize_date_format(input)
        date_obj = convert_to_date_object(normalized_date)
        raise ArgumentError, 'Minguo wasn’t existent.' if date_obj.year == 0
        true
      end

      def legal_mg_date_range?(input)
        normalized_input = normalize_date_format(input)
        split = normalized_input.split('/')
        date1_obj = convert_to_date_object("#{split[0]}/#{split[1]}/#{split[2]}")
        date2_obj = convert_to_date_object("#{split[3]}/#{split[4]}/#{split[5]}")

        raise ArgumentError, 'You’ve entered an invalid date range. Please check your input and try again.' if date1_obj > date2_obj
        raise ArgumentError, 'Minguo wasn’t existent.' if date1_obj.year == 0
        true
      end

      def legal_mg_semester_range?(input)
        normalized_input = normalize_date_format(input)
        year1, sem1, year2, sem2 = input.split('/')
        year1 = year1.to_i
        year2 = year2.to_i
        sem1 = sem1.to_i
        sem2 = sem2.to_i

        if year1 == year2
          raise ArgumentError, 'You’ve entered an invalid semester range. Please check your input and try again.' if sem1 > sem2
        elsif year1 > year2
          raise ArgumentError, 'You’ve entered an invalid semester range. Please check your input and try again.'
        else
          raise ArgumentError, 'Minguo wasn’t existent.' if year1 == 0 || year2 == 0
        end

        true
      end

      def normalize_date_format(input)
        input.gsub!(/(\/|-|–|\.| )/, '/')
      end

      def convert_to_date_object(input)
        begin
          split = input.split('/').map(&:to_i)
          Date.new(split[0], split[1], split[2])
        rescue ArgumentError
          raise ArgumentError, 'You’ve entered an invalid date. Please check your input and try again.'
        end
      end
  end
end
