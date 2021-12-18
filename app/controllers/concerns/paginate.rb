# frozen_string_literal: true

# Pagintation module
module Paginate
  def pagination_params
    limit = params[:limit]? Integer(params[:limit]) : 5
    page = params[:page]? Integer(params[:page]) : 1
    offset = params[:offset]? Integer(params[:offset]) : (page - 1) * limit
    page = (offset / limit + 1)  if param[:offset]

    return limit, offset, page
  end
end