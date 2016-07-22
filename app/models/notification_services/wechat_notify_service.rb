class NotificationServices::WechatNotifyService < NotificationService
  LABEL = "wechat_notify"
  FIELDS = [
    [:api_token, {
      placeholder: 'Enter OPEN-IDs of Wechat users, separated by space',
      label:       'OPEN-IDs'
    }]
  ]

  def check_params
    if api_token.blank?
      errors.add :base, 'You must specify the OPEN-IDs'
    end
  end

  def create_notification(problem)
    return if problem.notices_count > 1 && problem.notices.reverse_ordered.skip(1).first.created_at > 1.hour.ago
    args = api_token.strip.split(/\s+/)
    args.unshift('/usr/local/bin/wechat-notify')
    IO.popen(args, 'r+') { |f|
      content = %{
timestamp: #{problem.first_notice_at.to_i}
host:      #{problem.app_name} - #{problem.environment}
action:    #{problem.notices_count} error(s)
url:       #{problem.url}

#{problem.message}
}
      puts args.join(' ') + content
      f.puts content
      f.close_write
      puts f.gets
    }
  end
end
