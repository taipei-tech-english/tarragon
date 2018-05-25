require 'rails_helper'

RSpec.describe Converter::Parser do
  before do
    @converter = Converter::Parser.new
  end

  describe "parses common era dates & semesters" do
    context "when a match is found" do
      it "recognizes common era date" do
        result_1 = @converter.parse('1932 05 6')
        result_2 = @converter.parse('1940-7/03')
        result_3 = @converter.parse('1958.12-04')

        expect(result_1).to eq({type: :ce_date, normalized: Date.new(1932,5,6)})
        expect(result_2).to eq({type: :ce_date, normalized: Date.new(1940,7,3)})
        expect(result_3).to eq({type: :ce_date, normalized: Date.new(1958,12,4)})
      end

      it "recognizes common era date range" do
        result_1 = @converter.parse('1920.3.26 1923/7/5')
        result_2 = @converter.parse('1930/7 5-1955 7.5')

        expect(result_1).to eq({type: :ce_date_range, normalized: [ Date.new(1920,3,26), Date.new(1923,7,5) ]})
        expect(result_2).to eq({type: :ce_date_range, normalized: [ Date.new(1930,7,5), Date.new(1955,7,5) ]})
      end

      it "recognizes common era semester" do
        result_fall   = @converter.parse('Fall 2017')
        result_spring = @converter.parse('Spring 1988')
        result_fcase  = @converter.parse('faLl 1971')
        result_scase  = @converter.parse('sPriNg 1959')

        expect(result_fall).to   eq({type: :ce_semester, normalized: 'fall 2017'})
        expect(result_spring).to eq({type: :ce_semester, normalized: 'spring 1988'})
        expect(result_fcase).to  eq({type: :ce_semester, normalized: 'fall 1971'})
        expect(result_scase).to  eq({type: :ce_semester, normalized: 'spring 1959'})
      end

      it "recognizes common era semester range" do
        result_1 = @converter.parse('Spring 1997 Fall 2000')
        result_2 = @converter.parse('spring 1984–fAll 1986')

        expect(result_1).to eq({type: :ce_semester_range, normalized: ['spring 1997', 'fall 2000']})
        expect(result_2).to eq({type: :ce_semester_range, normalized: ['spring 1984', 'fall 1986']})
      end
    end

    context "when a match is not found" do
      it "rejects illegal input of common era date" do
        expect{ @converter.parse('1998 9 31') }.to raise_error(ArgumentError, 'You’ve entered an invalid date. Please check your input and try again.')
        expect{ @converter.parse('1911 12 31 ') }.to raise_error(ArgumentError, 'Minguo wasn’t existent before 1912.')
        expect{ @converter.parse(' 1000 12 31 ') }.to raise_error(ArgumentError, 'Minguo wasn’t existent before 1912.')
      end

      it "rejects illegal input of common era date range" do
        expect{ @converter.parse('2017 7 32 2018 9 30') }.to raise_error(ArgumentError, 'You’ve entered an invalid date. Please check your input and try again.')
        expect{ @converter.parse('2015 5 30 2014 1 31') }.to raise_error(ArgumentError, 'You’ve entered an invalid date range. Please check your input and try again.')
        expect{ @converter.parse('1911 2 3 1921 5 8') }.to raise_error(ArgumentError, 'Minguo wasn’t existent before 1912.')
      end

      it "rejects illegal input of common era semester" do
        expect{ @converter.parse('Whatever 1911') }.to raise_error(ArgumentError, 'Input is unrecognizable. Please check your input and try again.')
        expect{ @converter.parse('Fall 911') }.to raise_error(ArgumentError, 'Input is unrecognizable. Please check your input and try again.')
        expect{ @converter.parse('Fall 1911') }.to raise_error(ArgumentError, 'Minguo wasn’t existent before 1912.')
      end

      it "rejects illegal common era semester range" do
        expect{ @converter.parse('Fall 911 Spring 912') }.to raise_error(ArgumentError, 'Input is unrecognizable. Please check your input and try again.')
        expect{ @converter.parse('Fall 1987 Spring 1987') }.to raise_error(ArgumentError, 'You’ve entered an invalid semester range. Please check your input and try again.')
        expect{ @converter.parse('Spring 1955 Spring 1940') }.to raise_error(ArgumentError, 'You’ve entered an invalid semester range. Please check your input and try again.')
        expect{ @converter.parse('Spring 1911 Spring 1940') }.to raise_error(ArgumentError, 'Minguo wasn’t existent before 1912.')
      end
    end
  end

  describe "parses Minguo dates & semesters" do
    context "when a match is found" do
      it "recognizes Minguo date" do
        result_1 = @converter.parse('9 01 9')
        result_2 = @converter.parse('10-2.1')
        result_3 = @converter.parse('107/7/21')

        expect(result_1).to eq({type: :mg_date})
        expect(result_2).to eq({type: :mg_date})
        expect(result_3).to eq({type: :mg_date})
      end

      it "recognizes Minguo date range" do
        result_1 = @converter.parse('12.3.5-13/6/30')
        result_2 = @converter.parse('112 12.5 113-7–30')

        expect(result_1).to eq({type: :mg_date_range})
        expect(result_2).to eq({type: :mg_date_range})
      end

      it "recognizes Minguo semester" do
        result_1 = @converter.parse('10-1')
        result_2 = @converter.parse('99-2')
        result_3 = @converter.parse('125-1')
        result_4 = @converter.parse('999-2')

        expect(result_1).to eq({type: :mg_semester})
        expect(result_2).to eq({type: :mg_semester})
        expect(result_3).to eq({type: :mg_semester})
        expect(result_4).to eq({type: :mg_semester})
      end

      it "recognizes Minguo semester range" do
        result_1 = @converter.parse('88-1 88-2')
        result_2 = @converter.parse('100-1-100-2')

        expect(result_1).to eq({type: :mg_semester_range})
        expect(result_2).to eq({type: :mg_semester_range})
      end
    end

    context "when a match is not found" do
      it "rejects illegal input of Minguo date" do
        expect { @converter.parse('-0 7 9') }.to raise_error(ArgumentError, 'Input is unrecognizable. Please check your input and try again.')
        expect{ @converter.parse('105 13 5') }.to raise_error(ArgumentError, 'You’ve entered an invalid date. Please check your input and try again.')
        expect{ @converter.parse(' 0 12 31 ') }.to raise_error(ArgumentError, 'Minguo wasn’t existent.')
      end

      it "rejects illegal input of Minguo date range" do
        expect{ @converter.parse('99 9 31 100 12 5') }.to raise_error(ArgumentError, 'You’ve entered an invalid date. Please check your input and try again.')
        expect{ @converter.parse('101 6 30 101 5 30') }.to raise_error(ArgumentError, 'You’ve entered an invalid date range. Please check your input and try again.')
        expect{ @converter.parse('0 5 4 1 5 4') }.to raise_error(ArgumentError, 'Minguo wasn’t existent.')
      end

      it "rejects illegal Minguo semester" do
        expect{ @converter.parse('100-3') }.to raise_error(ArgumentError, 'Input is unrecognizable. Please check your input and try again.')
        expect{ @converter.parse('0-1') }.to raise_error(ArgumentError, 'Minguo wasn’t existent.')
      end

      it "rejects illegal input of Minguo semester range" do
        expect { @converter.parse('65-3 67-2') }.to raise_error(ArgumentError, 'Input is unrecognizable. Please check your input and try again.')
        expect{ @converter.parse('98-2 98-1') }.to raise_error(ArgumentError, 'You’ve entered an invalid semester range. Please check your input and try again.')
        expect{ @converter.parse('100-2 98-2') }.to raise_error(ArgumentError, 'You’ve entered an invalid semester range. Please check your input and try again.')
        expect{ @converter.parse('0-1 1-2') }.to raise_error(ArgumentError, 'Minguo wasn’t existent.')
      end
    end
  end
end
