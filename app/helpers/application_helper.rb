module ApplicationHelper
  def genre_badge_class(genre)
    case genre
    when 'one_time'
      'primary'
    when 'monthly'
      'success'
    when 'weekly'
      'info'
    when 'daily'
      'warning'
    when 'regular'
      'secondary'
    else
      'dark'
    end
  end
end
