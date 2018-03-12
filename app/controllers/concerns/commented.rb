module Commented
  extend ActiveSupport::Concern

  included do
    before_action :find_commentable, only: :comment
    after_action :publish_comment, only: :comment
  end

  def comment
    @comment = @commentable.comments.build(comment_params.merge(user: current_user))
    @comment.save
  end

  private

  def publish_comment
    return if @comment.errors.any?
    question_id = @comment.commentable_type == 'Question' ? @commentable.id : @comment.commentable.question_id
    ActionCable.server.broadcast(
      "comment-question-#{question_id}",
      html: ApplicationController.render(
        partial: 'comments/comment',
        locals: { comment: @comment }
      ),
      type: @comment.commentable_type,
      id: @comment.commentable_id
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def find_commentable
    @commentable = model_klass.find(params[:id])
  end
end
