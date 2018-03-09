class QuestionsController < ApplicationController
  protect_from_forgery prepend: true
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show edit update destroy vote unvote]
  before_action :author?, only: :destroy
  after_action :publish_question, only: [:create]


  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = current_user.questions.new
    @question.attachments.build
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

  def vote
    @vote = Vote.create(voteable: @question, user: current_user, value: params[:value])
    respond_to do |format|
      if @vote.save
        format.json { render json: { id: @question.id, upvotes: @question.up_votes, downvotes: @question.down_votes, total: @question.total_votes } }
      else
        format.json { render json: { error: @vote.errors.full_messages } }
      end
    end
  end

  def unvote
    @question.cancel_vote(current_user.id)
    respond_to do |format|
      format.json { render json: { id: @question.id, upvotes: @question.up_votes, downvotes: @question.down_votes, total: @question.total_votes } }
    end
  end

  private

  def author?
    return nil if @question.author? current_user
    redirect_to question_path(@question), notice: 'You are not author of this answer!'
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question}
      )
    )
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
