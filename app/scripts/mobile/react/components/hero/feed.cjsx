{ PropTypes } = React

HeroFeed = React.createClass
  displayName: 'HeroFeed'

  propTypes:
    title:         PropTypes.string.isRequired
    backgroundUrl: PropTypes.string.isRequired
    entriesCount:  PropTypes.number

  render: ->
    <div style={ @getHeroStyles() }
         className="hero hero--static">
      <div className="hero__overlay" />
      <div className="hero__content">
        <div className="hero__head">
          <div className="hero__title">
            <span>{ @props.title }</span>
          </div>
          { @props.entriesCount != null &&
            <div className="hero__smalltext">
              <span>{ i18n.t('hero.feed_entries_count', {count: @props.entriesCount}) }</span>
            </div>
          }
          {@props.children}
        </div>
      </div>
    </div>

  getHeroStyles: ->
    backgroundImage: "url('#{ @props.backgroundUrl }')"

module.exports = HeroFeed