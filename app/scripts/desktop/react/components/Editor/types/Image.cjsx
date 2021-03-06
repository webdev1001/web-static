_ = require 'lodash'
classnames = require 'classnames'
EditorStore = require '../../../stores/EditorStore'
EditorActionCreators = require '../../../actions/editor'
EditorTextField = require '../fields/Text'
EditorMediaBox = require '../MediaBox/MediaBox'
EditorMediaBoxProgress = require '../MediaBox/MediaBoxProgress'
EditorTypeImageWelcome = require './Image/Welcome'
EditorTypeImageUrlInsert = require './Image/UrlInsert'
EditorTypeImageLoaded = require './Image/Loaded'
EditorTypeImageLoadingUrl = require './Image/LoadingUrl'
{ PropTypes } = React

MAX_ATTACHMENTS = 8
WELCOME_STATE = 'welcome'
INSERT_STATE = 'insert'
LOADING_URL_STATE = 'loading'
LOADED_STATE = 'loaded'

EditorTypeImage = React.createClass
  displayName: 'EditorTypeImage'

  propTypes:
    entryType: PropTypes.string.isRequired
    loading: React.PropTypes.bool.isRequired

  getInitialState: ->
    _.extend {}, this.getStateFromStore(), {
      currentState: this.getInitialCurrentState(),
      dragging: false,
      uploadingProgress: null
    }

  componentWillReceiveProps: ->
    this.setState(this.getStateFromStore());

  render: ->
    editorClasses = classnames('post', 'post--image', 'post--edit', {
      'state--insert': @isInsertState()
    })

    return <article className={ editorClasses }>
             <div className="post__content">
               <EditorMediaBox
                   entryType={ @props.entryType }
                   state={ @getMediaBoxState() }>
                 { @renderEditorScreen() }
                 { @renderProgress() }
               </EditorMediaBox>
               <EditorTextField
                   mode="rich"
                   text={this.state.title}
                   placeholder={ i18n.t('editor_description_placeholder') }
                   className="post__content"
                   onChange={ @handleChangeTitle } />
             </div>
           </article>

  renderEditorScreen: ->
    switch @state.currentState
      when WELCOME_STATE
        <EditorTypeImageWelcome
            onClickInsertState={ @activateInsertState }
            onSelectFiles={ @handleSelectFiles }
            onDragOver={ @draggingOn }
            onDragLeave={ @draggingOff }
            onDrop={ @draggingOff } />
      when INSERT_STATE
        <EditorTypeImageUrlInsert
            onInsertImageUrl={ @handleChangeImageUrl }
            onCancel={ @activateWelcomeState } />
      when LOADED_STATE
        <EditorTypeImageLoaded
            imageUrl={this.state.imageUrl}
            imageAttachments={this.state.imageAttachments}
            loading={@props.loading}
            onDelete={ @handleDeleteLoadedImages } />
      when LOADING_URL_STATE
        <EditorTypeImageLoadingUrl imageUrl={this.state.imageUrl} />
      else null

  renderProgress: ->
    if @state.uploadingProgress?
      <EditorMediaBoxProgress progress={ @state.uploadingProgress } />

  isWelcomeState: -> @state.currentState is WELCOME_STATE
  isInsertState: -> @state.currentState is INSERT_STATE
  isLoadingUrlState: -> @state.currentState is LOADING_URL_STATE

  activateInsertState: -> @setState(currentState: INSERT_STATE)
  activateLoadingUrlState: -> @setState(currentState: LOADING_URL_STATE)
  activateLoadedState: -> @setState(currentState: LOADED_STATE)
  activateWelcomeState: -> @setState(currentState: WELCOME_STATE)

  draggingOn: -> @setState(dragging: true)
  draggingOff: -> @setState(dragging: false)

  getMediaBoxState: ->
    switch
      when @isWelcomeState() then null
      when @state.dragging then 'drag-hover'
      when @isInsertState() then 'insert'
      when @isLoadingUrlState() then 'loading'
      when @state.imageAttachments.length || @state.imageUrl then 'loaded'
      else null

  getInitialCurrentState: ->
    if EditorStore.getEntryValue('imageUrl') or
       EditorStore.getEntryValue('imageAttachments')?.length
      LOADED_STATE
    else
      WELCOME_STATE

  handleDeleteLoadedImages: ->
    EditorActionCreators.deleteImageAttachments()
    EditorActionCreators.deleteImageUrl()
    @activateWelcomeState()

  handleChangeImageUrl: (imageUrl) ->
    image = new Image()
    @activateLoadingUrlState()

    @setState(imageUrl:imageUrl)

    image.onload = =>
      @activateLoadedState()
      EditorActionCreators.changeImageUrl imageUrl
    image.onerror = =>
      NoticeService.notifyError i18n.t 'editor_image_doesnt_exist', {imageUrl}
      @activateWelcomeState()

    image.src = imageUrl

  handleSelectFiles: (files) ->
    imageFiles = _.filter files, (file) ->
      file.type.match /(\.|\/)(gif|jpe?g|png)$/i

    unless imageFiles.length
      return NoticeService.notifyError i18n.t 'editor_files_without_images'

    if imageFiles.length > MAX_ATTACHMENTS
      imageFiles = imageFiles.slice(0, MAX_ATTACHMENTS)
      NoticeService.notifyError i18n.t('editor_files_limit_reached', count: MAX_ATTACHMENTS)

    EditorActionCreators.createImageAttachments imageFiles
      .progress (soFar) =>
        # Если пользователь локально удалил картинки, не показываем прогресс-бар
        if @state.imageAttachments.length
          @setState(uploadingProgress: soFar * 100)
        else
          @setState(uploadingProgress: 0)
      .always =>
        if @isMounted()
          if @state.imageAttachments.length then @activateLoadedState() else @activateWelcomeState()
          _.delay (=> @setState uploadingProgress: null), 500
    @activateLoadedState()

  handleChangeTitle: (title) ->
    EditorActionCreators.changeTitle title

  getStateFromStore: ->
    title: EditorStore.getEntryValue 'title'
    imageUrl: EditorStore.getEntryValue 'imageUrl'
    imageAttachments: EditorStore.getEntryValue('imageAttachments') || []

module.exports = EditorTypeImage