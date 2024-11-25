class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    # Landing page accessible to all
  end
end