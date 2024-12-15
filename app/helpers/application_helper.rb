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

  def flash_class(level)
    case level.to_sym
    when :notice then "alert-success" # Green for success
    when :alert then "alert-warning" # Yellow for warnings
    when :error then "alert-danger"  # Red for errors
    else "alert-info"                # Blue for generic info
    end
  end
end
