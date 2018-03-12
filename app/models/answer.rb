class Answer < ApplicationRecord
  include Author
  include Voteable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable
  has_many :votes, as: :voteable
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true
  validates_uniqueness_of :best, if: :best, scope: :question_id

  accepts_nested_attributes_for :attachments
  accepts_nested_attributes_for :votes

  scope :best_answer, -> { where(best: true).limit(1) }
  scope :answers_without_best, -> { where(best: false) }

  def set_best
    return nil if best?
    question.answers.update_all(best: false)
    update(best: true)
  end

  def question_author_id
    question.user_id
  end
end
