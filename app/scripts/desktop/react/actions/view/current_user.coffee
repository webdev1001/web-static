CurrentUserResource      = require '../../resources/current_user'
CurrentUserServerActions = require '../server/current_user'

CurrentUserViewActions =

  updateSlug: (options = {}) ->
    _.extend options, {
      data:
        slug: options.slug
    }
    @update options

  updateTitle: (options = {}) ->
    _.extend options, {
      data:
        title: options.title
    }
    @update options

  updatePrivacy: (options = {}) ->
    _.extend options, {
      data:
        is_privacy: options.privacy
    }
    @update options

  updateDaylog: (options = {}) ->
    _.extend options, {
      data:
        is_daylog: options.daylog
    }
    @update options

  updateFemale: (options = {}) ->
    _.extend options, {
      data:
        is_female: options.female
    }
    @update options

  updateAvailableNotifications: (options = {}) ->
    _.extend options, {
      data:
        available_notifications: options.availableNotifications
    }
    @update options

  update: ({data, beforeSend, success, error, complete}) ->
    CurrentUserResource.update {
      data: data
      beforeSend: beforeSend
      success: (user) =>
        CurrentUserServerActions.updateUser user
        success?(user)
      error: (data) =>
        TastyNotifyController.errorResponse data
        error?(data)
      complete: complete
    }

module.exports = CurrentUserViewActions