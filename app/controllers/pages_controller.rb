class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:help] # Allow everyone access to help page

  def help
  end
end