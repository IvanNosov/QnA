class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question
  before_action :set_answer, only: :destroy
  before_action :author?, only: :destroy

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
    @answer.destroy
    redirect_to @question, notice: 'Your answer was successfully deleted.'
  end


  private

  def author?
    return nil if @answer.author? current_user
    redirect_to question_path(@question), notice: 'You are not author of this answer!'
  end

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