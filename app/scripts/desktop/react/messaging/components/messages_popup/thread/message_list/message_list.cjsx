savedScrollHeight = null

window.MessagesPopup_ThreadMessageList = React.createClass
  mixins: [ScrollerMixin]

  propTypes:
    conversationId: React.PropTypes.number.isRequired

  getInitialState: -> @getStateFromStore()

  componentDidMount: ->
    @_scrollToBottom()

    MessagesStore.addChangeListener @_onStoreChange
    messagingService.openConversation @props.conversationId

  componentWillUpdate: (nextProps, nextState) ->
    if @state.messages[0]?

      if @state.messages[0]?.uuid isnt nextState.messages[0]?.uuid
        # Добавятся сообщения из истории
        scrollerNode      = @refs.scrollerPane.getDOMNode()
        savedScrollHeight = scrollerNode.scrollHeight

  componentDidUpdate: (prevProps, prevState) ->
    if prevState.messages[0]?

      if prevState.messages[0]?.uuid isnt @state.messages[0]?.uuid
        # Подгрузились сообщения из истории
        @_holdScroll()
      else if prevState.messages.length != @state.messages.length
        # Добавлено сообщение
        @_scrollToBottom()
    else
      @_scrollToBottom()

  componentWillUnmount: ->
    MessagesStore.removeChangeListener @_onStoreChange

  render: ->
    if @isEmpty()
      messages = <MessagesPopup_MessageListEmpty />
    else
      that = @
      messages = @state.messages.map (message, i) ->
        <MessagesPopup_ThreadMessageListItemManager
          message={ message }
          messagesCount={ that.state.messages.length }
          key={"#{message.id}-#{message.uuid}"}
        />

    return <div ref="scroller"
                className="scroller scroller--dark scroller--messages">
             <div ref="scrollerPane"
                  className="scroller__pane js-scroller-pane"
                  onScroll={ this.handleScroll }>
               <div ref="messageList"
                    className="messages__list">
                 <div className="messages__list-cell">
                   { messages }
                 </div>
               </div>
             </div>
             <div className="scroller__track js-scroller-track">
               <div className="scroller__bar js-scroller-bar"></div>
             </div>
           </div>

  isEmpty: -> @state.messages.length == 0

  handleScroll: ->
    scrollerPaneNode = @refs.scrollerPane.getDOMNode()

    if scrollerPaneNode.scrollTop == 0 && !@state.isAllMessagesLoaded
      MessageActions.loadMoreMessages {
        conversationId: @props.conversationId
        toMessageId:    @state.messages[0].id
      }

    TastyEvents.emit TastyEvents.keys.message_list_scrolled(), scrollerPaneNode

  getStateFromStore: ->
    messages:            MessagesStore.getMessages @props.conversationId
    isAllMessagesLoaded: MessagesStore.isAllMessagesLoaded @props.conversationId

  _scrollToBottom: ->
    scrollerNode = @refs.scrollerPane.getDOMNode()
    scrollerNode.scrollTop = scrollerNode.scrollHeight

  _holdScroll: ->
    scrollerNode = @refs.scrollerPane.getDOMNode()
    scrollerNode.scrollTop = scrollerNode.scrollHeight - savedScrollHeight
    savedScrollHeight = null

  _onStoreChange: -> @setState @getStateFromStore()