App.widget_data = App.cable.subscriptions.create channel: 'WidgetDataChannel', widget: 'timecount',
  connected: ->
    console.log('timecount connected')

  disconnected: ->
    console.log('timecount disconnected')
    window.timecountWidget.resetTemplate()

  received: (data) ->
    console.log('timecount received data:', data)
    window.timecountWidget.renderCollection(data)

class TimecountWidget

  _this = undefined

  constructor: ->
    _this = this

    $widget = $('.widget > .timecount')
    this.template = $widget[0].innerHTML
    this.widgets = {}

    this.initWidgets()
    this.renderCollection($widget.data('preload'))

  initWidgets: ->
    $('.widget > .timecount').each ->
      $currentWidget = $(this)
      widgetId = $currentWidget.attr('id')
      _this.widgets[widgetId] = {
        $reference: $currentWidget,
        backgroundColor: $currentWidget.parent().css('background-color')
      }

  resetTemplate: ->
    for id, _ of this.widgets
      this.render(this.template, { widgetId: id })

  renderCollection: (collection) ->
    for _, widget of collection
      this.render(this.template, widget) if widget.widgetId

  render: (template, data) ->
    widgetId = data.widgetId
    renderedTemplate = Mustache.render(template, data)
    this.widgets[widgetId].$reference.html(renderedTemplate)

    $(".widget > .timecount##{widgetId} .devider .fa").css(
      'background-color',
      this.widgets[widgetId].backgroundColor
    )

$(document).ready ->
  window.timecountWidget = new TimecountWidget()
