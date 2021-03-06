/*global $ */
import Api from '../api/api';
import Submitter from '../api/submitter';
import CurrentUserStore from '../stores/current_user';
import DesignStore from '../stores/design';
import AppDispatcher from '../dispatchers/dispatcher';
import DesignPreviewService from '../services/designPreview';
import DesignConstants from '../constants/design';
import BrowserHelpers from '../../../shared/helpers/browser';

let uploadBgPromise = $.Deferred().resolve();

let DesignActionCreators = {
  initCurrent(design) {
    AppDispatcher.handleViewAction({
      type: DesignConstants.INIT_CURRENT,
      design
    });
  },

  changeOption(name, value) {
    AppDispatcher.handleViewAction({
      type: DesignConstants.CHANGE_OPTION,
      name, value
    });

    let design = DesignStore.getCurrent();
    DesignPreviewService.apply(design);
  },

  changeBgImage(file) {
    let formData = new FormData();
    formData.append('image', file);

    //TODO: Делать что-то на случай если картинка не создастся, а base64 мы уже показали
    uploadBgPromise = Api.design.createBgImage(formData)
      .then((image) => {
        this.changeOption('backgroundId', image.id);
      });

    this.changeOption('backgroundImageUrl', BrowserHelpers.createObjectURL(file));
  },

  closeDesignSettings() {
    AppDispatcher.handleViewAction({
      type: DesignConstants.CLOSE_DESIGN_SETTINGS,
    });

    let design = DesignStore.getCurrent();
    DesignPreviewService.apply(design);
  },

  saveCurrent() {
    const userID = CurrentUserStore.getUser().id;
    const unsavedFields = DesignStore.getUnsavedFields();

    if (Object.keys(unsavedFields).length === 0) {
      NoticeService.notifyError(i18n.t('design_settings_no_unsaved_fields_error'));
    } else {
      // Удаляем ключ содержащий фон картинки, если такой имеется. если мы загрузили
      // картинку, то у нас будет backgroundId его и будем передавать.
      AppDispatcher.handleViewAction({
        type: DesignConstants.SAVE_CURRENT_START,
      });

      uploadBgPromise.then(() => { //wait for bg uploads if any
        const design = DesignStore.getCurrent();
        delete design.backgroundImageUrl;
        Api.design.saveCurrent(design, userID)
          .then((design) => {
            AppDispatcher.handleServerAction({
              type: DesignConstants.SAVE_CURRENT_SUCCESS,
              design,
            });
            NoticeService.notifySuccess(i18n.t('design_settings_save_success'));
          })
          .fail(() => {
            AppDispatcher.handleServerAction({
              type: DesignConstants.SAVE_CURRENT_FAIL,
            });
            NoticeService.notifyError(i18n.t('design_settings_save_error'));
          });
      });
    }
  },

  proceedPayment() {
    let url = Routes.orders(),
        design = DesignStore.getCurrent();

    // Удаляем ключ содержащий фон картинки, если такой имеется. если мы загрузили
    // картинку, то у нас будет backgroundId его и будем передавать.
    delete design.backgroundImageUrl;
    Submitter.postRequest(url, { design });
  },
};

export default DesignActionCreators;
