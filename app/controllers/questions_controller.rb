class QuestionsController < ApplicationController
  protect_from_forgery prepend: true
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]
  before_action :author?, only: :destroy

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = current_user.questions.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Your question was successfully deleted.'
  end

  private

  def author?
    return nil if @question.author? current_user
    redirect_to question_path(@question), notice: 'You are not author of this answer!'
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
