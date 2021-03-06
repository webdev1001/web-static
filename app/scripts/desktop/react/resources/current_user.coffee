CurrentUserResource =

  update: ({data, beforeSend, success, error, complete}) ->
    data._method = 'PUT'

    $.ajax
      url: ApiRoutes.update_profile_url()
      method: 'POST'
      data: data
      beforeSend: beforeSend
      success: success
      error: error
      complete: complete

  stopFbCrosspost: ({ beforeSend, success, error, complete }) ->
    $.ajax({
      beforeSend,
      success,
      error,
      complete,
      url: ApiRoutes.fb_crosspost_url(),
      method: 'POST',
      data: { _method: 'DELETE' },
    });

  stopTwitterCrosspost: ({ beforeSend, success, error, complete }) ->
    $.ajax({
      beforeSend,
      success,
      error,
      complete,
      url: ApiRoutes.twitter_crosspost_url(),
      method: 'POST',
      data: { _method: 'DELETE' },
    });

  cancelEmailConfirmation: ({beforeSend, success, error, complete}) ->
    $.ajax
      url: ApiRoutes.request_confirm_url()
      method: 'POST'
      data:
        _method: 'DELETE'
      beforeSend: beforeSend
      success: success
      error: error
      complete: complete

  resendEmailConfirmation: ({beforeSend, success, error, complete}) ->
    $.ajax
      url: ApiRoutes.request_confirm_url()
      method: 'POST'
      beforeSend: beforeSend
      success: success
      error: error
      complete: complete

module.exports = CurrentUserResource
