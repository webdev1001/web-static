###* @jsx React.DOM ###

FOLLOW_STATE = 0

window.GuessesTabPanel = GuessesTabPanel = React.createClass

  getInitialState: ->
    relationships: null

  componentWillMount: -> @getPanelData()

  componentWillUnmount: ->
    # Отменяем xhr запрос если пользователь не дождался загрузки данных и
    # переключился на другую вкладку
    # http://stackoverflow.com/a/446626/3800881
    @xhr.abort()

  getPanelData: ->
    @xhr = $.ajax
      url: Routes.api.relationships_to_url()
      data:
        status: FOLLOW_STATE
      success: (relationships) =>
        @setState relationships: relationships
        @props.onReady()
      error: (data, type) =>
        TastyNotifyController.errorResponse data

  render: ->
    if @state.relationships
      relationships = @state.relationships.map (relationship, i) ->
        `<GuessesTabPanelItem relationship={ relationship } key={ i }></GuessesTabPanelItem>`

      panelContent = `<ul className="persons">{ relationships }</ul>`
    else
      panelContent = `<div className="popup__text">Пусто</div>`

    return `<div className="tabs-panel">
              <div className="scroller scroller--persons js-scroller">
                <div className="scroller__pane js-scroller-pane">
                  { panelContent }
                </div>
                <div className="scroller__track js-scroller-track">
                  <div className="scroller__bar js-scroller-bar"></div>
                </div>
              </div>
            </div>`

module.exports = GuessesTabPanel