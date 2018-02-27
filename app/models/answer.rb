class Answer < ApplicationRecord
  include Author
  validates :body, presence: true
  belongs_to :question
  belongs_to :user

  validates_uniqueness_of :best, if: :best, scope: :question_id

  scope :best_answer, -> { where(best: true).limit(1) }
  scope :answers_without_best, -> { where(best: false) }

  def set_best
    return nil if best?
    question.answers.update_all(best: false)
    update(best: true)
  end
end
