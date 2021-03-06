import React, { findDOMNode, PropTypes } from 'react';
import BrowserHelpers from '../../../../../../shared/helpers/browser';

class ImgFromFile {
  componentDidMount() {
    this.image = new Image();
    this.image.onload = (ev) => {
      const container = findDOMNode(this.refs.container);
      if (container instanceof HTMLElement) {
        this.image.style.width = `${ev.target.width}px`;
        this.image.style.height = `${ev.target.height}px`;
        container.appendChild(this.image);
      }
    };
    this.imageSrc = BrowserHelpers.createObjectURL(this.props.file);
    this.image.src = this.imageSrc;
  }
  componentWillUnmount() {
    BrowserHelpers.revokeObjectURL(this.imageSrc);
  }
  render() {
    return <div ref="container" />;
  }
}

ImgFromFile.propTypes = {
  file: PropTypes.object.isRequired,
}

export default ImgFromFile;
