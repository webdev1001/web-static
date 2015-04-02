import classSet from 'react/lib/cx';
import EditorVoteButton from '../buttons/Vote';
import EditorPrivacyButton from '../buttons/Privacy';
import EditorPreviewButton from '../buttons/Preview';
import EditorSaveButton from '../buttons/Save';

let ENTRY_PRIVACY_PRIVATE = 'private',
    ENTRY_PRIVACY_PUBLIC = 'public',
    ENTRY_PRIVACY_ANONYMOUS = 'anonymous',
    ENTRY_PRIVACY_LIVE = 'live',
    TLOG_TYPE_PRIVATE = 'private',
    TLOG_TYPE_PUBLIC = 'public',
    TLOG_TYPE_ANONYMOUS = 'anonymous';

let EditorActions = React.createClass({
  propTypes: {
    entryPrivacy: React.PropTypes.string.isRequired,
    tlogType: React.PropTypes.string.isRequired,
    loading: React.PropTypes.bool.isRequired,
    creatingAttachments: React.PropTypes.bool.isRequired,
    onSaveEntry: React.PropTypes.func.isRequired,
    onChangePrivacy: React.PropTypes.func.isRequired
  },

  getInitialState() {
    return {preview: false}
  },

  componentWillUpdate(nextProps, nextState) {
    //TODO: Применятор для показа превью
    if (this.state.preview !== nextState.preview) {
      if (nextState.preview) {
        $('body').removeClass('tlog-mode-minimal').addClass('tlog-mode-full');
      } else {
        $('body').removeClass('tlog-mode-full').addClass('tlog-mode-minimal');
      }
    }
  },

  render() {
    let actionsClasses = classSet({
      'post-actions': true,
      'state--loading': this.props.loading
    });

    return (
      <div className={actionsClasses}>
        {this.renderSpinner()}
        {this.renderVoteButton()}
        {this.renderPrivacyButton()}
        <div className="post-action post-action--button">
          <EditorPreviewButton onClick={this.togglePreview} />
        </div>
        <div className="post-action post-action--button">
          <div className="button-group">
            <EditorSaveButton private={this.isEntryPrivate()} onClick={this.saveEntry} />
          </div>
        </div>
      </div>
    );
  },

  renderVoteButton() {
    if (!(this.isTlogAnonymous() || this.isEntryPrivate() || this.isTlogPrivate())) {
      return (
        <div className="post-action post-action--button">
          <EditorVoteButton enabled={this.isEntryLive()} onClick={this.handleVoteButtonClick} />
        </div>
      );
    }
  },

  renderPrivacyButton() {
    if (!this.isTlogAnonymous()) {
      return (
        <div className="post-action post-action--button">
          <EditorPrivacyButton
              live={this.isEntryLive()}
              private={this.isEntryPrivate()}
              onClick={this.handlePrivacyButtonClick} />
        </div>
      );
    }
  },

  renderSpinner() {
    if (this.props.loading) {
      return (
        <div className="post-action post-action--loader">
          <Spinner size={8} />
        </div>
      );
    }
  },

  isEntryLive() {
    return this.props.entryPrivacy == ENTRY_PRIVACY_LIVE;
  },

  isEntryPrivate() {
    return this.props.entryPrivacy == ENTRY_PRIVACY_PRIVATE;
  },

  isTlogPrivate() {
    return this.props.tlogType == TLOG_TYPE_PRIVATE;
  },

  isTlogAnonymous() {
    return this.props.tlogType == TLOG_TYPE_ANONYMOUS;
  },

  togglePreview() {
    if (this.props.loading) { return; }
    this.setState({preview: !this.state.preview});
  },

  saveEntry() {
    if (this.props.loading) { return; }
    if (this.props.creatingAttachments) {
      TastyNotifyController.notifyError(i18n.t('editor_images_not_loaded_yet_error'));
      return;
    }
    this.props.onSaveEntry();
  },

  handleVoteButtonClick() {
    if (this.props.loading) { return; }
    let newEntryPrivacy = this.isEntryLive() ? ENTRY_PRIVACY_PUBLIC : ENTRY_PRIVACY_LIVE;
    this.props.onChangePrivacy(newEntryPrivacy);
  },

  handlePrivacyButtonClick() {
    if (this.props.loading) { return; }
    let newEntryPrivacy = this.isEntryPrivate() ? ENTRY_PRIVACY_PUBLIC : ENTRY_PRIVACY_PRIVATE;
    this.props.onChangePrivacy(newEntryPrivacy);
  }
});

export default EditorActions;