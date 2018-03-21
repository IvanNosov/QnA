module QuestionsHelper
  def subscription_link(question)
    return unless current_user
    subscription = question.subscriptions.find_by_user_id(current_user.id)
    if subscription
      link_to 'Unsubscribe', question_subscription_path(question, subscription), method: :delete, class: 'btn btn-sm btn-default'
    else
      link_to 'Subscribe', question_subscriptions_path(question), method: :post, class: 'btn btn-sm btn-default'
    end
  end
end
