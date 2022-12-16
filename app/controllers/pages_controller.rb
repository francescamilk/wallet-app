class PagesController < ApplicationController
  def home; end

  def sync
    @calendar = Calendar.new
  end
end
