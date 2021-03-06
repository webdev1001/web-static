import React, { Component, PropTypes } from 'react';
import Textarea from 'react-textarea-autosize';
import Avatar from '../../../../../shared/react/components/common/Avatar';

const REPLIES_LIMIT = 5;

export default class EntryTlogCommentForm extends Component {
  static propTypes = {
    commentator: PropTypes.object.isRequired,
    onCancel: PropTypes.func.isRequired,
    onSubmit: PropTypes.func.isRequired,
    process: PropTypes.bool,
    text: PropTypes.string,
  }
  state = {
    text: this.props.text || '',
  }
  componentDidMount() {
    // Ставим курсор в конец
    let field = React.findDOMNode(this.refs.field);

    if (field.setSelectionRange) {
      let len = field.value.length * 2;
      field.setSelectionRange(len, len);
    } else {
      field.value = field.value;
    }
  }
  render() {
    return (
      <div className="comment-form">
        <div className="comment-form__table">
          <div className="comment-form__table-cell">
            <form>
              {this.renderAvatar()}
              {this.renderSubmitButton()}
              <span className="comment-form__field">
                <Textarea
                  className="comment-form__field-textarea"
                  disabled={this.props.process}
                  onChange={this.handleChange.bind(this)}
                  onKeyDown={this.handleKeyDown.bind(this)}
                  placeholder={i18n.t('comment_form_placeholder')}
                  ref="field"
                  value={this.state.text}
                />
              </span>
            </form>
          </div>
        </div>
      </div>
    );
  }
  renderAvatar() {
    const { commentator: { userpic }, process } = this.props;
    return (
      <span className="comment-form__avatar">
        {
          process
            ? <Spinner size={30} />
            : <Avatar
                size={35}
                userpic={userpic}
              />
        }
      </span>
    );
  }
  renderSubmitButton() {
    if (!this.isEmpty() && !this.props.process) {
      return (
        <button className="comment-form__submit" onClick={::this.handleButtonClick}>
          {i18n.t('comment_form_submit')}
        </button>
      );
    }
  }
  focus() {
    this.refs.field.focus();
  }
  isEmpty() {
    return !this.state.text.trim();
  }
  clear() {
    this.setState({ text: '' });
  }
  addReply(username) {
    let userTag = `@${username}`,
        postfix = /^@/.exec(this.state.text) ? ', ' : ' ',
        newText = this.state.text,
        replies = this.getReplies();

    if (replies.length > REPLIES_LIMIT) {
      newText = this.removeLastReply();
    }
    if (!RegExp(userTag).test(newText)) {
      newText = userTag + postfix + newText;
    }

    this.setState({ text: newText }, this.focus);
  }
  getReplies() {
    let replies = [],
        text = this.state.text,
        regExp = /@[^, ]{1,}/g;

    let found, results = [];
    while (found = regExp.exec(text)) {
      results.push(found[0]);
    }
    return results;
  }
  removeLastReply() {
    return this.state.text.replace(/, @\w+(?=\s)/g, '');
  }
  submit() {
    this.props.onSubmit(this.state.text);
  }
  handleChange(e) {
    this.setState({ text: e.target.value });
  }
  handleKeyDown(e) {
    switch(e.which) {
      case 13:
        if (!this.isEmpty() && !e.shiftKey && !e.ctrlKey && !e.altKey) {
          e.preventDefault();
          this.submit();
        }
        break;
      case 27:
        this.props.onCancel();
        break;
    }
  }
  handleButtonClick(e) {
    e.preventDefault();
    this.submit();
  }
}
