Api              = require '../../api/api'
NotifyController = require '../../controllers/notify'

REPORT_SUCCESS_MESSAGE         = -> t 'report_entry_success'
DELETE_SUCCESS_MESSAGE         = -> t 'delete_entry_success'
VOTE_SUCCESS_MESSAGE           = -> t 'vote_entry_success'
COMMENT_REPORT_SUCCESS_MESSAGE = -> t 'report_comment_success'
COMMENT_DELETE_SUCCESS_MESSAGE = -> t 'delete_comment_success'

EntryViewActions =

  addToFavorites: (entryId) ->
    Api.entry.addToFavorites entryId
      .fail (xhr) ->
        NotifyController.errorResponse xhr

  removeFromFavorites: (entryId) ->
    Api.entry.removeFromFavorites entryId
      .fail (xhr) ->
        NotifyController.errorResponse xhr

  startWatch: (entryId) ->
    Api.entry.startWatch entryId
      .fail (xhr) ->
        NotifyController.errorResponse xhr

  stopWatch: (entryId) ->
    Api.entry.stopWatch entryId
      .fail (xhr) ->
        NotifyController.errorResponse xhr

  report: (entryId) ->
    Api.entry.report entryId
      .then ->
        NotifyController.notifySuccess REPORT_SUCCESS_MESSAGE()
      .fail (xhr) ->
        NotifyController.errorResponse xhr

  delete: (entryId) ->
    Api.entry.delete entryId
      .then ->
        NotifyController.notifySuccess DELETE_SUCCESS_MESSAGE()
      .fail (xhr) ->
        NotifyController.errorResponse xhr

  vote: (entryId) ->
    Api.entry.vote entryId
      .then (rating) ->
        NotifyController.notifySuccess VOTE_SUCCESS_MESSAGE()
        rating
      .fail (xhr) ->
        NotifyController.errorResponse xhr

  loadComments: (entryId, toCommentId, limit) ->
    Api.entry.loadComments entryId, toCommentId, limit
      .fail (xhr) ->
        NotifyController.errorResponse xhr

  createComment: (entryId, text) ->
    Api.entry.createComment entryId, text
      .fail (xhr) ->
        NotifyController.errorResponse xhr

  editComment: (entryId, commentId, text) ->
    Api.entry.editComment commentId, text
      .fail (xhr) ->
        NotifyController.errorResponse xhr

  deleteComment: (entryId, commentId) ->
    Api.entry.deleteComment commentId
      .then ->
        NotifyController.notifySuccess COMMENT_DELETE_SUCCESS_MESSAGE()
      .fail (xhr) ->
        NotifyController.errorResponse xhr

  reportComment: (commentId) ->
    Api.entry.reportComment commentId
      .then ->
        NotifyController.notifySuccess COMMENT_REPORT_SUCCESS_MESSAGE()
      .fail (xhr) ->
        NotifyController.errorResponse xhr

module.exports = EntryViewActions