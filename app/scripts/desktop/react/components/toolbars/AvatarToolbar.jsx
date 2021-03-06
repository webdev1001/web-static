import Avatar from '../../../../shared/react/components/common/Avatar';

let AvatarToolbar = React.createClass({
  componentDidMount() {
    $(this.getDOMNode()).tooltip({
      title: i18n.t('avatar_toolbar_tooltip'),
      placement: 'left',
      container: '.toolbar--avatar'
    });
  },

  componentWillUnmount() {
    $(this.getDOMNode()).tooltip('destroy');
  },

  render() {
    return (
      <a href={this.props.user.tlog_url} className="toolbar toolbar--avatar">
        <div className="toolbar__toggle">
          <Avatar userpic={this.props.user.userpic} size={70} />
        </div>
      </a>
    );
  }
});

export default AvatarToolbar;