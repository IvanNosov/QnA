class SearchesController < ApplicationController
  def search
    @model = params[:model]
    @query = params[:query]
    @result = if @model == 'All'
                ThinkingSphinx.search @query
              else
                @model.constantize.search @query
              end
  end
end
