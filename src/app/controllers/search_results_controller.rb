class SearchResultsController < ApplicationController
  def new
  end

  def create
    # redirect_to root_url
    render "new"
  end
end
