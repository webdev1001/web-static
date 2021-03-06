classnames = require 'classnames'

window.Avatar = React.createClass
  displayName: 'Avatar'

  propTypes:
    name:     React.PropTypes.string.isRequired
    userpic:  React.PropTypes.object.isRequired
    size:     React.PropTypes.number

  # Известные размеры:
  # - settings: 110
  # - comment:  35
  # - hero:     220
  # - brick:    35

  getDefaultProps: ->
    size: 220 # Этого размера картинки хватает на все аватары

  render: ->
    avatarUrl     = @props.userpic.original_url || @props.userpic.large_url
    avatarSymbol  = @props.userpic.symbol
    avatarClasses = classnames('avatar', {
      'anonymous_char': @isAnonymous()
    })

    if avatarUrl?
      avatarUrl = ThumborService.imageUrl
        url: avatarUrl
        path: @props.userpic.thumbor_path
        size: @props.size + 'x' + @props.size
      avatarStyles = backgroundImage: "url('#{ avatarUrl }')"

      return <span style={ avatarStyles }
                   className={ avatarClasses }>
               <img src={ avatarUrl }
                    alt={ this.props.name }
                    className="avatar__img" />
             </span>
    else
      avatarStyles =
        backgroundColor: @props.userpic.default_colors.background
        color: @props.userpic.default_colors.name

      return <span style={ avatarStyles }
                   className={ avatarClasses }
                   title={ this.props.name }>
               <span className="avatar__text">
                 { avatarSymbol }
               </span>
             </span>

  isAnonymous: -> @props.userpic.kind is 'anonymous'
  isUser:      -> @props.userpic.kind is 'user'