require 'action_view'

$config['timecount'].each_with_index do |widget, index|
  widget['dateTime'] = DateTime.parse(widget['dateTime'])
end

$widget_scheduler.every '10s', first: :immediately do
  now = DateTime.now

  $config['timecount'].each_with_index do |widget, index|
    date_time = widget['dateTime']
    display = widget['display']

    years = now.year - date_time.year
    days = (now - date_time).to_i
    hours = days * 24 + (now.hour - date_time.hour)
    minutes = hours * 60 + (now.minute - date_time.minute)

    display['seconds'] = minutes * 60 + (now.second - date_time.second) if display['seconds']
    display['minutes'] = minutes if display['minutes']
    display['hours'] = hours if display['hours']
    display['days'] = days if display['days']
    display['months'] = years * 12 + (now.month - date_time.month) if display['months']
    display['years'] = years if display['years']
    display['decades'] = (years / 10).to_i if display['decades']
  end

  WidgetDatum.new(name: 'timecount', data: $config['timecount']).save
end
