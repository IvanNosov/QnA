class Ability
  include CanCan::Ability
  attr_reader :user
  def initialize(user)
    @user = user
    if user
      user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can %i[create comment], [Question, Answer]
    can :update,  [Question, Answer], user: user
    can :destroy, [Question, Answer], user: user
    can :vote,    [Question, Answer] { |votable| votable.user != user }
    can :unvote,  [Question, Answer] { |votable| votable.user != user }
    can :best, [Answer] { |answer| answer.question.user == user }
    can :destroy, [Attachment] { |attachment| attachment.attachable.user == user }
  end
end
