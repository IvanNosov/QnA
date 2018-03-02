module Voteable
  def total_votes
    up_votes - down_votes
  end

  def up_votes
    votes.where(value: true).size
  end

  def down_votes
    votes.where(value: false).size
  end

  def cancel_vote(user_id)
    vote = votes.find_by(user_id: user_id)
    vote.destroy
  end

  def voted?(user_id)
    votes.find_by(user_id: user_id) ? true : false
  end
end
