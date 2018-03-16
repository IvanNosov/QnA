class Api::V1::QuestionsController < Api::V1::BaseController

  def index
    @question = Question.all 
    respond_with @question
  end
end