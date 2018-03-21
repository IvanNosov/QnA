class QuestionMailer < ApplicationMailer
  def update_notification(user, question)
    @email = user.email
    @question = question
    @subscription = user.subscriptions.find_by_question_id(question.id)
    mail(to: @email, subject: 'Question Was Updated')
  end

  def answer_notification(user, question)
    @email = user.email
    @subscription = user.subscriptions.find_by_question_id(question.id)
    @question = question
    mail(to: @email, subject: 'Answer Was Added to Question')
  end
end
