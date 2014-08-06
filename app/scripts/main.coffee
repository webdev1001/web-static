require './libs'
window.Routes =
  logout_path: -> TastySettings.host + '/logout'

require './shared/api-routes'

require './aapp/application'

require './aapp/filters/opecityPercentage.js.coffee'
require './aapp/filters/timeAgo.js.coffee'
require './aapp/controllers/post.js.coffee'
require './aapp/controllers/utils.coffee'
require './aapp/controllers/userToolbar.js.coffee'
require './aapp/controllers/designSettings.js.coffee'
require './aapp/controllers/comments/comments_resource.js.coffee'
require './aapp/controllers/designSettings/radio_ctrl.coffee'
require './aapp/controllers/designSettings/design_settings_saver.js.coffee'
require './aapp/controllers/designSettings/opacity_ctrl.coffee'
require './aapp/controllers/designSettings/background.coffee'
require './aapp/controllers/comments.js.coffee'
require './aapp/controllers/post/post_comments_toggle.js.coffee'
require './aapp/controllers/infiniteFeedController.coffee'
require './aapp/application.coffee'
require './aapp/services/designSettingsService.js.coffee'
require './aapp/services/declension.js.coffee'
require './aapp/services/designSettingsDragable.js.coffee'
require './aapp/directives/eatClick.js'
require './aapp/directives/enter.js'

require './react/services/positions'
require './react/services/thumbor'

require './react/mixins/unmount'
require './react/mixins/positions'
require './react/mixins/shake'
require './react/mixins/grammar'
require './react/mixins/error_timer'
require './react/mixins/activities'
require './react/mixins/requester'
require './react/mixins/dom_manipulations'
require './react/mixins/scroller'
require './react/mixins/touch'

require './react/components/avatar'

require './react/components/shellbox/email_signin_shellbox'
require './react/components/shellbox/email_signup_shellbox'
require './react/components/shellbox/recovery_shellbox'
require './react/components/shellbox/select_signin_shellbox'
require './react/components/shellbox/inviter_shellbox'

require './react/components/settings_popup/settings_avatar'
require './react/components/settings_popup/settings_title'
require './react/components/settings_popup/settings_accounts_item'
require './react/components/settings_popup/settings_email_input'
require './react/components/settings_popup/settings_email_confirmation'
require './react/components/settings_popup/settings_header'
require './react/components/settings_popup/settings_password_input'
require './react/components/settings_popup/settings_radio_item'
require './react/components/settings_popup/settings_vkontakte'
require './react/components/settings_popup/toolbar_settings'

require './react/components/toolbars/user/user'
require './react/components/toolbars/feed/feed'
require './react/components/toolbars/close/close'
require './react/components/toolbars/toolbar_item'

require './react/components/voting'
require './react/components/shellbox_layer'
require './react/components/buttons/load_more'
require './react/components/follow_status'
require './react/components/smart_follow_status'
require './react/components/follow_button'
require './react/components/relationship_following_button'
require './react/components/relationship_request_button'

require './shared/jquery.maxlength'
require './react/components/editable_field'

require './react/components/popup_box'
require './react/components/popup/popup'
require './react/components/popup/layout'
require './react/components/popup/spinner'
require './react/components/popup/header'

require './react/components/calendar/calendar'
require './react/components/calendar/calendar_timeline'
require './react/components/calendar/calendar_header'
require './react/components/calendar/calendar_period'
require './react/components/calendar/calendar_marker'

require './react/components/persons_popup/mixins/panel_mixin'
require './react/components/persons_popup/persons_popup'
require './react/components/persons_popup/menu'
require './react/components/persons_popup/menu_item'

require './react/components/persons_popup/items/item'
require './react/components/persons_popup/items/following_relationship'
require './react/components/persons_popup/items/follower_relationship'
require './react/components/persons_popup/items/request_relationship'
require './react/components/persons_popup/items/ignored_relationship'

require './react/components/persons_popup/panels/followings_panel'
require './react/components/persons_popup/panels/followers_panel'
require './react/components/persons_popup/panels/requests_panel'
require './react/components/persons_popup/panels/ignores_panel'

require './react/components/post_editor/mixins/dragging'
require './react/components/post_editor/mixins/persistence'
require './react/components/post_editor/mixins/images_form'
require './react/components/post_editor/mixins/layout'

require './react/components/post_editor/video_mediabox/video_mediabox'
require './react/components/post_editor/video_mediabox/loading'
require './react/components/post_editor/video_mediabox/insert'
require './react/components/post_editor/video_mediabox/embeded'
require './react/components/post_editor/video_mediabox/welcome'

require './react/components/post_editor/images_mediabox/loaded'
require './react/components/post_editor/images_mediabox/url_insert'
require './react/components/post_editor/images_mediabox/welcome'

require './react/components/post_editor/mediabox/actions'
require './react/components/post_editor/mediabox/layout'
require './react/components/post_editor/mediabox/loading_progress'

require './react/components/entry_metabar/dropdown_menu'
require './react/components/entry_metabar/dropdown_menu_items/item'
require './react/components/entry_metabar/dropdown_menu_items/favorite_item'
require './react/components/entry_metabar/dropdown_menu_items/watch_item'
require './react/components/entry_metabar/dropdown_menu_items/report_item'
require './react/components/entry_metabar/dropdown_menu_items/delete_item'

require './react/components/post_editor/actions'
require './react/components/post_editor/tasty_editor'
require './react/components/post_editor/post_editor'
require './react/components/post_editor/text_editor'
require './react/components/post_editor/image_editor'
require './react/components/post_editor/video_editor'
require './react/components/post_editor/quote_editor'
require './react/components/post_editor/choicer'
require './react/components/post_editor/layout'
require './react/components/post_editor/new_post'
require './react/components/post_editor/new_anonymous_post'
require './react/components/post_editor/edit_post'
require './react/components/post_editor/editor_container'
require './react/components/post_editor/demo'
# require './react/components/post_editor/images_container'

require './react/components/hero/profile/profile'
require './react/components/hero/profile/profile_avatar'
require './react/components/hero/profile/profile_head'
require './react/components/hero/profile/profile_stats'
require './react/components/hero/profile/profile_stats_item'

require './react/components/hero/profile/popup/popup'
require './react/components/hero/profile/popup/followers_popup'
require './react/components/hero/profile/popup/followings_popup'
require './react/components/hero/profile/popup/tags_popup'
require './react/components/hero/profile/popup/items/follower_item'
require './react/components/hero/profile/popup/items/following_item'
require './react/components/hero/profile/popup/items/tag_item'

require './shared/utils'
require './shared/tasty'

require './react/components/images_collage'

require './react/components/tasty_notify'
require './react/components/tasty_confirm'
require './react/controllers/tasty_notify'
require './react/controllers/tasty_events'
require './react/controllers/tasty_confirm'
require './react/controllers/tasty_notify'
require './react/controllers/shellbox'
require './react/controllers/popup'
require './react/utils'
require './react/application'

require './plugins/jquery.collage'

require './editors'

require './settings'

# React_ujs нужно подключать после того как все компоненты загружены
window.ReactUjs = require 'react_ujs'

$ ->
  window.Tasty.start access_token: window.tastyUser?.api_key?.access_token
