###* @jsx React.DOM ###
#= require ./settings_radio_item

module.experts = window.ToolbarSettings = React.createClass
  getInitialState: ->
    saving: false
    user:   @props.user

  save: (key, value) ->
    @setState saving: true

    data = @state.user
    debugger

    $.ajax
      url:      Routes.api.update_profile_url()
      dataType: 'json'
      method:   'put'
      data:     data
      success: (data) =>
        debugger
        @setState saving: false
        TastyUtils.notify 'success', "Вам на почту отправлена ссылка для восстановления пароля"
        ReactApp.closeShellBox()
      error: (data) =>
        debugger
        @setState saving: false
        @shake()
        @refs.slug.getDOMNode().focus()
        TastyUtils.notifyErrorResponse data

    console.log 'save', key, value

  render: ->
    saveCallback = @save

    return `<div className="settings">
              <form onSubmit={this.submit}>
                <SettingsHeader user={this.state.user}/>

                <div className="settings__body">

                    <SettingsRadioItem
                      saveCallback={saveCallback}
                      user={this.state.user}
                      key='is_privacy'
                      title='Закрытый дневник?'
                      description='Управление видимостью вашего дневника. Закрытый дневник виден только тем, на кого вы подписаны.' />

                    <SettingsVkontakteItem 
                      user={this.state.user}
                      />

                    <SettingsRadioItem
                      saveCallback={saveCallback}
                      user={this.state.user}
                      key='is_daylog'
                      title='Тлогодень'
                      description='Это режим отображения, когда на странице показыватются записи только за один день.' />

                    <SettingsRadioItem
                      saveCallback={saveCallback}
                      user={this.state.user}
                      key='is_female'
                      title='Вы - девушка'
                      description='На Тейсти сложилось так, что 7 из 10 пользователей – это девушки. Поэтому по-умолчанию для всех именно такая настройка.' />

                    <SettingsEmailInput 
                      saveCallback={saveCallback}
                      user={this.state.user}/>

                    <SettingsRadioItem
                      saveCallback={saveCallback}
                      user={this.state.user}
                      key='available_notifications'
                      title='Уведомления'
                      description='Вы хотите получать уведомления о всех новых комментариях, подписчиках и личных сообщениях?' />

                    <SettingsPasswordItem 
                      saveCallback={saveCallback}
                      user={this.state.user}
                    />

                    <SettingsAccountsItem user={this.state.user} accounts={[]}/>
                </div>
              </form>
            </div>`