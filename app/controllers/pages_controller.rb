class PagesController < ApplicationController
  def home
    @calendar = Calendar.new
  end
end
