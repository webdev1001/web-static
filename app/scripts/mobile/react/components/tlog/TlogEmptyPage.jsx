let TlogEmptyPage = React.createClass({

  render() {
    return (
      <div className="content-info">
        <div className="content-info__icon">
          <i className="icon icon--paper-corner" />
        </div>
        <p className="content-info__text">{i18n.t('tlog.tlog_empty_page')}</p>
      </div>
    );
  }

});

export default TlogEmptyPage;