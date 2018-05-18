class ConvertersController < ApplicationController
  def index
    unless params[:q].blank?
      begin
        parser = Converter::Parser.new
        @result = parser.parse(params[:q])
      rescue ArgumentError => e
        @result = e
      end
    end
  end
end
