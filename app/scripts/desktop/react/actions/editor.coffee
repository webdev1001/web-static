_ = require 'lodash'
Api = require '../api/api'
EditorConstants = require('../constants/constants').editor
EditorStore = require '../stores/editor'
AppDispatcher = require '../dispatchers/dispatcher'
UuidService = require '../../../shared/react/services/uuid'
ApiHelpers = require '../../../shared/helpers/api'
BrowserHelpers = require '../../../shared/helpers/browser'

EditorActionCreators =

  init: ({entry, tlogType}) ->
    AppDispatcher.handleViewAction
      type: EditorConstants.INIT
      entry: entry
      tlogType: tlogType

  updateField: (key, value) ->
    AppDispatcher.handleViewAction
      type: EditorConstants.UPDATE_FIELD
      key: key
      value: value

  changeEntryType: (entryType) ->
    AppDispatcher.handleViewAction
      type: EditorConstants.CHANGE_TYPE
      entryType: entryType

  changeEntryPrivacy: (entryPrivacy) ->
    AppDispatcher.handleViewAction
      type: EditorConstants.CHANGE_PRIVACY
      entryPrivacy: entryPrivacy

  changeTitle: (title) ->
    @updateField 'title', title

  changeText: (text) ->
    @updateField 'text', text

  changeImageUrl: (imageUrl) ->
    @updateField 'imageUrl', imageUrl

  changeEmbedUrl: (embedUrl) ->
    @updateField 'embedUrl', embedUrl

  changeEmbedHtml: (embedHtml) ->
    @updateField 'embedHtml', embedHtml

  changeSource: (source) ->
    @updateField 'source', source

  createImageAttachments: (files) ->
    promises = []

    _.forEach files, (file) =>
      # Общий uuid для imageAttachment-like blob и imageAttachment
      uuid = UuidService.generate()

      # Добавляем imageAttachment-like blob объект, назначаем ему uuid
      image = new Image()
      image.onload = =>
        attachments = EditorStore.getEntryValue('imageAttachments') || []
        newAttachments = attachments[..]
        blobAttachment =
          uuid: uuid
          image:
            geometry:
              width: image.width
              height: image.height
            url: image.src

        newAttachments.push blobAttachment
        @updateField 'imageAttachments', newAttachments
      image.src = BrowserHelpers.createObjectURL file

      # Делаем запрос на создание картинки, на успешный ответ заменяем blob с uuid
      formData = new FormData()
      formData.append 'image', file

      promise = Api.editor.createImageAttachment(formData)
        .then (imageAttachment) =>
          attachments = EditorStore.getEntryValue('imageAttachments') || []
          newAttachments = attachments[..]

          blobIndex = _.findIndex newAttachments, (attachment) ->
            attachment.uuid == uuid

          if blobIndex == -1
            newAttachments.push imageAttachment
          else
            newAttachments[blobIndex] = imageAttachment

          @updateField 'imageAttachments', newAttachments

      promises.push promise

    ApiHelpers.settle promises

  deleteEmbedUrl: ->
    @changeEmbedUrl null

  deleteEmbedHtml: ->
    @changeEmbedHtml null

  deleteImageUrl: ->
    @changeImageUrl null

  deleteImageAttachments: ->
    attachments = EditorStore.getEntryValue 'imageAttachments'

    _.forEach attachments, (attachment) =>
      if not attachment.entry_id and attachment.id
        Api.editor.deleteImageAttachment attachment.id

    @updateField 'imageAttachments', []

  createEmbed: (embedUrl) ->
    Api.editor.createEmbed embedUrl

  saveEntry: ->
    data = {}
    entryID = EditorStore.getEntryID()
    entryType = EditorStore.getEntryType()
    # Сохраняем Video, Instagram и Music в video точке
    entryType = 'video' if entryType is 'music' or entryType is 'instagram'

    onSuccess = (entry) ->
      AppDispatcher.handleServerAction
        type: EditorConstants.ENTRY_SAVED
      
      if TastySettings.env is 'static-development'
        alert "Статья #{ entry.id } успешно сохранена"
      else
        TastyNotifyController.notifySuccess i18n.t 'editor_create_success'
        window.location.href = entry.entry_url

    switch entryType
      when 'text'
        data.title = EditorStore.getEntryValue 'title'
        data.text = EditorStore.getEntryValue 'text'
        data.privacy = EditorStore.getEntryPrivacy()
      when 'anonymous'
        data.title = EditorStore.getEntryValue 'title'
        data.text = EditorStore.getEntryValue 'text'
      when 'image'
        data.title = EditorStore.getEntryValue 'title'
        data.image_url = EditorStore.getEntryValue 'imageUrl'
        data.privacy = EditorStore.getEntryPrivacy()
        data.image_attachments_ids = EditorStore.getEntryImageAttachmentsIDs()
      when 'instagram', 'music', 'video'
        data.title = EditorStore.getEntryValue 'title'
        data.video_url = EditorStore.getEntryValue 'embedUrl'
        data.privacy = EditorStore.getEntryPrivacy()
      when 'quote'
        data.text = EditorStore.getEntryValue 'text'
        data.source = EditorStore.getEntryValue 'source'
        data.privacy = EditorStore.getEntryPrivacy()

    if entryID
      url = ApiRoutes.update_entry_url entryID, entryType
      Api.editor.updateEntry url, data
        .then onSuccess
    else
      url = ApiRoutes.create_entry_url entryType
      Api.editor.createEntry url, data
        .then onSuccess

module.exports = EditorActionCreators