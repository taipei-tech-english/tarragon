require 'rails_helper'

RSpec.describe Converter::Translator do
  before do
    @translator = Converter::Translator.new
  end

  describe "translates common era dates & semesters" do
    it "translates a common era date" do
      result = @translator.translate(
        {
          type: :ce_date,
          normalized: Date.new(2017,9,30)
        }
      )

      expect(result).to eq(
        {
          ce_semester:       'fall 2017',
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
      )
    end
  end
end
