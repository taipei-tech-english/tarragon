class ConvertersController < ApplicationController
  def index
    unless params[:q].blank?
      parser = Converter::Parser.new
      @result = parser.parse(params[:q])
    end
  end
end
