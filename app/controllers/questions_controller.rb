class QuestionsController < ApplicationController
  protect_from_forgery prepend: true
  after_action :publish_question, only: [:create]

  include Commented
  load_and_authorize_resource

  def index
    respond_with @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
    respond_with @question
  end

  def new
    respond_with @question = current_user.questions.new
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
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with @question.destroy
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

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
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
