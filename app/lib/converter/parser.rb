module Converter
  class Parser < ConverterBase
    def parse(raw_input)
      get_type(raw_input)
    end

    private
      def get_type(raw_input)
        single_ce_semester  = "(#{@@SEM_SPRING}|#{@@SEM_FALL}) " + '\d{4}'
        single_ce_date      = '\d{4}' + "#{@@DATE_DELIMITERS}" + '\d{1,2}' + "#{@@DATE_DELIMITERS}" + '\d{1,2}'
        single_mg_semester  = '\d{1,3}\-[12]'
        single_mg_date      = '\d{1,3}' + "#{@@DATE_DELIMITERS}" + '\d{1,2}' + "#{@@DATE_DELIMITERS}" + '\d{1,2}'

        processed_input     = raw_input.strip.downcase
        regex_ce_semester   = /^#{single_ce_semester}$/
        regex_ce_date       = /^#{single_ce_date}$/
        regex_ce_date_range = /^#{single_ce_date}#{@@DATE_RANGE_DELIMITERS}#{single_ce_date}$/
        regex_ce_semester_range = /^#{single_ce_semester}#{@@DATE_RANGE_DELIMITERS}#{single_ce_semester}$/
        regex_mg_semester   = /^#{single_mg_semester}$/
        regex_mg_date       = /^#{single_mg_date}$/
        regex_mg_date_range = /^#{single_mg_date}#{@@DATE_RANGE_DELIMITERS}#{single_mg_date}$/
        regex_mg_semester_range = /^#{single_mg_semester}#{@@DATE_RANGE_DELIMITERS}#{single_mg_semester}$/

        case
        when regex_ce_semester.match?(processed_input)
          result = {type: :ce_semester, normalized: processed_input} if legal_ce_semester?(processed_input)

        when regex_ce_date.match?(processed_input)
          normalized_input = normalize_date_format(processed_input)
          date_obj = convert_to_date_object(normalized_input)
          result = {type: :ce_date, normalized: date_obj} if legal_ce_date?(date_obj)

        when regex_ce_date_range.match?(processed_input)
          normalized_input = normalize_date_format(processed_input)
          split = normalized_input.split('/')
          date1 = convert_to_date_object("#{split[0]}/#{split[1]}/#{split[2]}")
          date2 = convert_to_date_object("#{split[3]}/#{split[4]}/#{split[5]}")
          result = {type: :ce_date_range, normalized: [date1, date2]} if legal_ce_date_range?(date1, date2)

        when regex_ce_semester_range.match?(processed_input)
          normalized_input = normalize_date_format(processed_input)
          sem1, year1, sem2, year2 = normalized_input.split('/')
          year1 = year1.to_i
          year2 = year2.to_i
          result = {type: :ce_semester_range, normalized: ["#{sem1} #{year1}", "#{sem2} #{year2}"]} if legal_ce_semester_range?(sem1, year1, sem2, year2)

        when regex_mg_semester.match?(processed_input)
          result = {type: :mg_semester, normalized: processed_input} if legal_mg_semester?(processed_input)

        when regex_mg_date.match?(processed_input)
          normalized_date = normalize_date_format(processed_input)
          date_obj = convert_to_date_object(normalized_date, true)
          result = {type: :mg_date, normalized: date_obj} if legal_mg_date?(date_obj)

        when regex_mg_date_range.match?(processed_input)
          normalized_input = normalize_date_format(processed_input)
          split = normalized_input.split('/')
          date1 = convert_to_date_object("#{split[0]}/#{split[1]}/#{split[2]}", true)
          date2 = convert_to_date_object("#{split[3]}/#{split[4]}/#{split[5]}", true)
          result = {type: :mg_date_range, normalized: [date1, date2] } if legal_mg_date_range?(date1, date2)

        when regex_mg_semester_range.match?(processed_input)
          normalized_input = normalize_date_format(processed_input)
          year1, sem1, year2, sem2 = normalized_input.split('/')
          year1 = year1.to_i
          year2 = year2.to_i
          sem1 = sem1.to_i
          sem2 = sem2.to_i
          result = {type: :mg_semester_range, normalized: ["#{year1}-#{sem1}", "#{year2}-#{sem2}"]} if legal_mg_semester_range?(sem1, year1, sem2, year2)

        else
          raise ArgumentError, 'Input is unrecognizable. Please check your input and try again.'
        end

        result
      end

      def legal_ce_semester?(input)
        year = input.split(' ')[1].to_i
        raise ArgumentError, 'Minguo wasn’t existent before 1912.' if year < 1912
        true
      end

      def legal_ce_date?(input)
        raise ArgumentError, 'Minguo wasn’t existent before 1912.' if input.year < 1912
        true
      end

      def legal_ce_date_range?(date1, date2)
        raise ArgumentError, 'You’ve entered an invalid date range. Please check your input and try again.' if date1 > date2
        raise ArgumentError, 'Minguo wasn’t existent before 1912.' if date1.year < 1912 || date2.year < 1912
        true
      end

      def legal_ce_semester_range?(sem1, year1, sem2, year2)
        if year1 == year2
          raise ArgumentError, 'You’ve entered an invalid semester range. Please check your input and try again.' if sem1 == @@SEM_FALL && sem2 == @@SEM_SPRING
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

      def legal_mg_date?(date_obj)
        raise ArgumentError, 'Minguo wasn’t existent.' if date_obj.year == 1911
        true
      end

      def legal_mg_date_range?(date1, date2)
        raise ArgumentError, 'You’ve entered an invalid date range. Please check your input and try again.' if date1 > date2
        raise ArgumentError, 'Minguo wasn’t existent.' if date1.year == 1911
        true
      end

      def legal_mg_semester_range?(sem1, year1, sem2, year2)
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

      def convert_to_date_object(input, is_minguo = false)
        begin
          split = input.split('/').map(&:to_i)
          if is_minguo
            Date.new(split[0]+1911, split[1], split[2])
          else
            Date.new(split[0], split[1], split[2])
          end
        rescue ArgumentError
          raise ArgumentError, 'You’ve entered an invalid date. Please check your input and try again.'
        end
      end
  end
end
