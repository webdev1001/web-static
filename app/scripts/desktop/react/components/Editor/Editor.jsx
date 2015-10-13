import React, { PropTypes } from 'react';
import EditorLayout from './Layout/Layout';
import EditorActions from './Actions/Actions';
import EditorTypeSwitcher from './TypeSwitcher/TypeSwitcher';
import EditorArea from './EditorArea';
import { TLOG_ENTRY_TYPE_ANONYMOUS } from '../../../../shared/constants/TlogEntry';

class Editor {
  renderTypeSwitcher() {
    const { canChangeType, entryType, loading, onChangeType, tlogType } = this.props;
    if (tlogType !== TLOG_ENTRY_TYPE_ANONYMOUS) {
      return (
        <EditorTypeSwitcher
          canChangeType={canChangeType}
          entryType={entryType}
          loading={loading}
          onChangeType={onChangeType}
        />
      );
    }
  }
  render() {
    const { backUrl, entry, entryPrivacy, entryType, loading, onChangePrivacy,
            onPinEntry, onSaveEntry, tlog, tlogType, userID } = this.props;
    return (
      <EditorLayout backUrl={backUrl} loading={loading}>
        <EditorActions
          entryPrivacy={entryPrivacy}
          loading={loading}
          onChangePrivacy={onChangePrivacy}
          onPinEntry={onPinEntry}
          onSaveEntry={onSaveEntry}
          tlog={tlog}
          tlogType={tlogType}
          userID={userID}
        />
        <EditorArea
          entry={entry}
          entryPrivacy={entryPrivacy}
          entryType={entryType}
          loading={loading}
        />
        {this.renderTypeSwitcher()}
      </EditorLayout>
    );
  }
}

Editor.propTypes = {
  backUrl: PropTypes.string,
  canChangeType: PropTypes.bool.isRequired,
  entry: PropTypes.object.isRequired,
  entryPrivacy: PropTypes.string.isRequired,
  entryType: PropTypes.string.isRequired,
  loading: PropTypes.bool.isRequired,
  onChangePrivacy: PropTypes.func.isRequired,
  onChangeType: PropTypes.func.isRequired,
  onPinEntry: PropTypes.func.isRequired,
  onSaveEntry: PropTypes.func.isRequired,
  tlog: PropTypes.object,
  tlogType: PropTypes.string.isRequired,
  userID: PropTypes.number.isRequired,
};

export default Editor;
