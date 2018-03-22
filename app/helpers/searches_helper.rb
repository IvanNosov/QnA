module SearchesHelper
  def models
    %w[All User Question Answer Comment]
  end

  def link_to_question(comment)
    question = comment.commentable.is_a?(Question) ? comment.commentable : comment.commentable.question
    link_to 'Comment', question, class: 'badge badge-primary'
  end
end
