ConversationStore       = require '../../stores/conversation'
ConnectStoreMixin       = require '../../../../shared/react/mixins/connectStore'
ConversationHeader      = require './conversation/header'
ConversationMessages    = require './conversation/messages'
ConversationMessageForm = require './conversation/messageForm'
{ PropTypes } = React

MessengerConversation = React.createClass
  displayName: 'MessengerConversation'
  mixins: [ConnectStoreMixin(ConversationStore)]

  render: ->
    #TODO: Thumbor backgrounds
    backgroundUrl = @state.conversation.recipient.design.background_url
    conversationStyles = backgroundImage: 'url("' + backgroundUrl + '")'

    return <div className="messages__section messages__section--thread">
             <ConversationHeader slug={ @state.conversation.recipient.slug } />
             <div className="messages__body"
                  style={ conversationStyles }>
               <div className="messages__thread-overlay" />
               <ConversationMessages />
             </div>
             <div className="messages__footer">
               <ConversationMessageForm
                   convID={ @state.conversation.id }
                   canTalk={ @state.conversation.can_talk } />
             </div>
           </div>

  getStateFromStore: ->
    conversation: ConversationStore.getCurrent()

module.exports = MessengerConversation