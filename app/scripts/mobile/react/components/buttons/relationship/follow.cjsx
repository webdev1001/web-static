cx                      = require 'react/lib/cx'
RelationshipsStore      = require '../../../stores/relationships'
RelationshipButtonMixin = require './mixins/relationship'
ComponentMixin          = require '../../../mixins/component'
ConnectStoreMixin       = require '../../../mixins/connectStore'
{ PropTypes } = React

SHOW_STATE    = 'show'
ERROR_STATE   = 'error'
PROCESS_STATE = 'process'

FRIEND_STATUS    = 'friend'
REQUESTED_STATUS = 'requested'
IGNORED_STATUS   = 'ignored'
GUESSED_STATUS   = 'guessed'
NONE_STATUS      = 'none'

#TODO: i18n
ERROR_TITLE          = 'Ошибка'
PROCESS_TITLE        = 'В процессе..'
SUBSCRIBE_TITLE      = 'Подписаться'
UNSUBSCRIBE_TITLE    = 'Отписаться'
CANCEL_REQUEST_TITLE = 'Отменить запрос'
UNBLOCK_TITLE        = 'Разблокировать'
SEND_REQUEST_TITLE   = 'Отправить запрос'
SUBSCRIBED_TITLE     = 'Подписан'
REQUESTED_TITLE      = 'Ждём одобрения'
IGNORED_TITLE        = 'Заблокирован'

module.exports = React.createClass
  displayName: 'FollowButton'
  mixins: [ConnectStoreMixin(RelationshipsStore), RelationshipButtonMixin, ComponentMixin]

  propTypes:
    user:   PropTypes.object.isRequired
    status: PropTypes.string.isRequired

  getInitialState: ->
    currentState: SHOW_STATE

  render: ->
    buttonClasses = cx
      'follow-button': true
      '__active': @isFollowStatus() && @isShowState()

    if @state.status?
      <button className={ buttonClasses }
              onClick={ @handleClick }>
        { @getTitle() }
      </button>
    else null

  isShowState:  -> @state.currentState is SHOW_STATE
  isErrorState: -> @state.currentState is ERROR_STATE

  isFollowStatus: -> @state.status is FRIEND_STATUS
  isTlogPrivate:  -> @props.user.is_privacy

  activateProcessState: -> @safeUpdateState(currentState: PROCESS_STATE)
  activateErrorState:   -> @safeUpdateState(currentState: ERROR_STATE)
  activateShowState:    -> @safeUpdateState(currentState: SHOW_STATE)

  getTitle: ->
    switch @state.currentState
      when ERROR_STATE   then return ERROR_TITLE
      when PROCESS_STATE then return PROCESS_TITLE

    switch @state.status
      when FRIEND_STATUS    then SUBSCRIBED_TITLE
      when REQUESTED_STATUS then REQUESTED_TITLE
      when IGNORED_STATUS   then IGNORED_TITLE
      when GUESSED_STATUS, NONE_STATUS
        if @isTlogPrivate() then SEND_REQUEST_TITLE else SUBSCRIBE_TITLE
      else console.warn 'Unknown follow status of FollowButton component', @state.status

  handleClick: ->
    userId = @props.user.id

    if @isShowState()
      switch @state.status
        when FRIEND_STATUS    then @unfollow userId
        when REQUESTED_STATUS then @cancel userId
        when IGNORED_STATUS   then @cancel userId
        when GUESSED_STATUS   then @follow userId
        when NONE_STATUS      then @follow userId
        else console.warn 'Unknown follow status of FollowButton component', @state.status

  getStateFromStore: ->
    status: RelationshipsStore.getStatus(@props.user.id) || @props.status