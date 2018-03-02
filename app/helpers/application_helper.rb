module ApplicationHelper
  def display_style(flag)
    flag ? 'display: none' : 'display: block'
  end

  def display_voted(content)
    'display: none' unless content.voted? current_user
  end
end
