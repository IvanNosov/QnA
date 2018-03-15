class AnswersController < ApplicationController
  before_action :set_question
  after_action :publish_answer, only: [:create]

  include Commented

  load_and_authorize_resource

  respond_to :js

  def create
    @answer = @question.answers.create(answer_params.merge(user_id: current_user.id))
  end

  def edit; end

  def update
    respond_with(@answer.update(answer_params))
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

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      "question-#{@question.id}",
      ApplicationController.render(
        partial: 'answers/answer_sub',
        locals: { answer: @answer }
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
