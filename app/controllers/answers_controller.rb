class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question
  before_action :set_answer, only: :destroy

  def new
    @answer = @question.answers.new
  end


  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question, notice: 'Your answer was added.'
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = @question.answers.find(params[:id])
    @answer.destroy if current_user.author_of?(@answer)
    redirect_to @question
  end


  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end