class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comment-question-#{data['question_id']}"
  end
end
