###* @jsx React.DOM ###

MOUSE_LEAVE_TIMEOUT = 300
DROPDOWN_CLOSED = 'closed'
DROPDOWN_OPENED = 'opened'

window.HeroProfile_DropdownMenu = React.createClass
  mixins: [ComponentManipulationsMixin]

  propTypes:
    userId: React.PropTypes.number.isRequired
    status: React.PropTypes.object.isRequired

  getInitialState: ->
    currentState: DROPDOWN_CLOSED
    status:       @props.status

  componentDidMount: ->
    TastyEvents.on TastyEvents.keys.follow_status_changed(@props.userId), @updateFollowStatus

  componentWillUnmount: ->
    clearTimeout @timeout if @timeout

  render: ->
    actionList = []
    dropdownMenuClasses = React.addons.classSet {
      'action-dropdown': true
      'position-top':    true
      'state--open':     !@isClosedState()
    }

    if @state.status isnt 'ignored'
      actionList.push `<HeroProfile_DropdownMenuIgnoreItem userId={ this.props.userId }
                                                           onClick={ this.activateClosedState } />`

    actionList.push `<HeroProfile_DropdownMenuReportItem userId={ this.props.userId }
                                                         onClick={ this.activateClosedState } />`

    return `<div className="dropdown-container"
                 onMouseEnter={ this.handleMouseEnter }
                 onMouseLeave={ this.handleMouseLeave }>
              <button className="action-menu-button">
                <i className="icon icon--dots" />
              </button>
              <span className={ dropdownMenuClasses }>
                { actionList }
              </span>
            </div>`

  activateClosedState: -> @safeUpdateState(currentState: DROPDOWN_CLOSED)
  activateOpenedState: -> @safeUpdateState(currentState: DROPDOWN_OPENED)

  isClosedState: -> @state.currentState is DROPDOWN_CLOSED
  isOpenedState: -> @state.currentState is DROPDOWN_OPENED

  updateFollowStatus: (newStatus) ->
    @safeUpdateState(status: newStatus)

  handleMouseEnter: ->
    clearTimeout @timeout if @timeout

    @activateOpenedState() if @isClosedState()

  handleMouseLeave: ->
    if @isOpenedState()
      @timeout = setTimeout (=> @activateClosedState()), MOUSE_LEAVE_TIMEOUT