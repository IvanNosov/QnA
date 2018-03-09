class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question
  before_action :set_answer, only: %i[show edit update best vote unvote destroy publish_answer]
  before_action :check_author, only: :destroy
  after_action :publish_answer, only: [:create]

  def show; end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def edit; end

  def update
    @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
  end

  def best
    @answer.set_best
  end

  def vote
    @vote = Vote.create(voteable: @answer, user: current_user, value: params[:value])
    respond_to do |format|
      if @vote.save
        format.json { render json: { id: @answer.id, upvotes: @answer.up_votes, downvotes: @answer.down_votes, total: @answer.total_votes } }
      else
        format.json { render json: { error: @vote.errors.full_messages } }
      end
    end
  end

  def unvote
    @answer.cancel_vote(current_user.id)
    respond_to do |format|
      format.json { render json: { id: @answer.id, upvotes: @answer.up_votes, downvotes: @answer.down_votes, total: @answer.total_votes } }
    end
  end

  private

  def check_author
    return nil if @answer.author? current_user
    redirect_to question_path(@question), notice: 'You are not author of this answer!'
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      "question-#{@question.id}",
      ApplicationController.render(
        partial: 'answers/answer_sub',
        locals: { answer: @answer}
      )
    )
  end
  
  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
