module Author
  extend ActiveSupport::Concern

  def author?(current_user)
    user == current_user
  end
end
