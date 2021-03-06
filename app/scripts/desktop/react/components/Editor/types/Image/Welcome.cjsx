DropZone = require '../../../common/DropZone/DropZone'
{ PropTypes } = React

EditorTypeImageWelcome = React.createClass
  displayName: 'EditorTypeImageWelcome'

  propTypes:
    onClickInsertState: PropTypes.func.isRequired
    onSelectFiles: PropTypes.func.isRequired
    onDragOver: PropTypes.func.isRequired
    onDragLeave: PropTypes.func.isRequired
    onDrop: PropTypes.func.isRequired

  render: ->
    <DropZone
        global={ true }
        onDragOver={ @props.onDragOver }
        onDragLeave={ @props.onDragLeave }
        onDrop={ @handleDrop }>
      <div className="media-box__info">
        <div className="media-box__text">
          <span>{ i18n.t('editor_welcome_move_or') } </span>
          <span className="form-upload form-upload--image">
            <span className="form-upload__text">{ i18n.t('editor_welcome_choose') }</span>
            <input type="file"
                   id="image"
                   className="form-upload__input"
                   accept="image/*"
                   multiple={ true }
                   onClick={@handleClick}
                   onChange={ @handleChange } />
          </span>
          <span> { i18n.t('editor_welcome_picture_or') }</span><br />
          <a title={ i18n.t('editor_welcome_insert') }
             onClick={ @handleClickInsert }>
            { i18n.t('editor_welcome_insert') }
          </a>
          <span> { i18n.t('editor_welcome_link_to_it') }</span>
        </div>
      </div>
    </DropZone>

  handleClick: (e) ->
    e.target.value = null

  handleChange: (e) ->
    files = e.target.files
    @props.onSelectFiles files if files.length

  handleDrop: (files) ->
    @props.onDrop()
    @props.onSelectFiles files if files.length

  handleClickInsert: (e) ->
    e.preventDefault()
    @props.onClickInsertState()

module.exports = EditorTypeImageWelcome