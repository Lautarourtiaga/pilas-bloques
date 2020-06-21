import Component from '@ember/component';
import { computed } from '@ember/object';

export default Component.extend({

    classes: computed('classes', function () {
        var _classes = ""

        if (this.initial) {
            _classes = _classes + "breadcrumb-initial-item";
        }

        if (this.selected) {
            _classes = _classes + "breadcrumb-selected-item";
        }

        return _classes;
    }),

});