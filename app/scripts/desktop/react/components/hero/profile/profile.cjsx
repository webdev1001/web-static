HeroProfileActionsContainer = require('./HeroProfileActionsContainer');

HERO_CLOSED = 'closed'
HERO_OPENED = 'opened'
HERO_OPENED_CLASS = 'hero-enabled'

window.HeroProfile = React.createClass

  propTypes:
    user:         React.PropTypes.object.isRequired
    stats:        React.PropTypes.object.isRequired
    relationship: React.PropTypes.object

  getInitialState: ->
    currentState: HERO_CLOSED

  componentDidMount: ->
    @$hero = $( @getDOMNode() )
    @heroClosedHeight = @$hero.height()

    $(window).on 'resize', @onResize
    $(window).on 'scroll', @scrollFade

    TastyEvents.on TastyEvents.keys.command_hero_open(), @open
    TastyEvents.on TastyEvents.keys.command_hero_close(), @close

  shouldComponentUpdate: (nextProps, nextState) ->
    @state.currentState != nextState.currentState

  componentWillUnmount: ->
    $(window).off 'resize', @onResize
    $(window).off 'scroll', @scrollFade

    TastyEvents.off TastyEvents.keys.command_hero_open(), @open
    TastyEvents.off TastyEvents.keys.command_hero_close(), @close

  render: ->
    followButtonVisible = !@isCurrentUser() and @props.relationship?

    return <div className="hero hero-profile">
             <CloseToolbar onClick={ this.close } />
             <div className="hero__overlay"></div>
             <div className="hero__gradient"></div>
             <div className="hero__box" ref="heroBox">
               <HeroProfileAvatar
                 user={ this.props.user }
                 onClick={ this.handleAvatarClick }
               />
               { followButtonVisible and
                 <SmartFollowStatus
                   tlogId={ this.props.user.id }
                   status={ this.props.relationship.state }
                 />
               }
               <HeroProfileHead user={ this.props.user } />
               <HeroProfileActionsContainer
                 isCurrentUser={this.isCurrentUser()}
                 relationship={this.props.relationship}
                 user={this.props.user}
               />
             </div>
             <HeroProfileStats
               user={ this.props.user }
               stats={ this.props.stats }
             />
           </div>

  isCurrentUser: ->
    if CurrentUserStore.isLogged()
      CurrentUserStore.getUser().id == @props.user.id

  open: ->
    transitionEnd = 'webkitTransitionEnd otransitionend oTransitionEnd' +
                    'msTransitionEnd transitionend'

    Mousetrap.bind 'esc', @close
    @setHeroWindowHeight()
    $('body').addClass(HERO_OPENED_CLASS).scrollTop 0

    @$hero.on transitionEnd, =>
      @setState currentState: HERO_OPENED
      $(window).on 'scroll.hero', @close
      @$hero.off transitionEnd

  close: ->
    if @isOpen()
      @setState currentState: HERO_CLOSED
      Mousetrap.unbind 'esc', @close
      $(window).off 'scroll.hero'

      @restoreInitialHeroHeight()
      setTimeout @unsetHeroHeight, 1500
      $('body').removeClass HERO_OPENED_CLASS
      TastyEvents.trigger TastyEvents.keys.hero_closed()

  setInitialHeroHeight: ->
    transitionEnd = 'webkitTransitionEnd otransitionend oTransitionEnd' +
                    'msTransitionEnd transitionend'

    @$hero.on transitionEnd, =>
      $(document).trigger 'domChanged'
      @$hero.off transitionEnd

    @initialHeroHeight = @$hero.height()
    @$hero.css 'height', @heroClosedHeight

  unsetHeroHeight: ->
    @$hero.css 'height', ''

  restoreInitialHeroHeight: -> @$hero.css 'height', @heroClosedHeight

  setHeroWindowHeight: -> @$hero.css 'height', $(window).height()

  scrollFade: ->
    $heroBox  = $( @refs.heroBox.getDOMNode() )
    height    = $heroBox.outerHeight() / 1.5
    scrollTop = $(window).scrollTop()

    # Не производим пересчёт значений, если hero уже вне поля видимости
    if scrollTop < @heroClosedHeight
      scrollTop = 0 if scrollTop < 0

      $heroBox.css
        'transform':         'translateY(' + scrollTop + 'px)'
        '-ms-transform':     'translateY(' + scrollTop + 'px)'
        '-webkit-transform': 'translateY(' + scrollTop + 'px)'
        'opacity':           Math.max(1 - scrollTop / height, 0)

  onResize: -> @setHeroWindowHeight() if @isOpen()

  isOpen: -> @state.currentState != HERO_CLOSED

  handleAvatarClick: (e) ->
    unless @isOpen()
      @setInitialHeroHeight()
      e.preventDefault()
      @open()
