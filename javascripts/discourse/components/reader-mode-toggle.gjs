import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import DButton from "discourse/components/d-button";
import bodyClass from "discourse/helpers/body-class";
import concatClass from "discourse/helpers/concat-class";
import icon from "discourse-common/helpers/d-icon";
import discourseLater from "discourse-common/lib/later";

export default class ReaderModeToggle extends Component {
  @tracked readerModeActive = false;
  @tracked isTransitioning = false;

  get bodyClassText() {
    return this.isTransitioning
      ? "reader-mode-transitioning reader-mode"
      : this.readerModeActive
      ? "reader-mode"
      : "";
  }

  @action
  toggleReaderMode() {
    this.isTransitioning = true;
    discourseLater(() => {
      this.readerModeActive = !this.readerModeActive;
      this.isTransitioning = false;
    }, 10);
  }

  <template>
    {{bodyClass this.bodyClassText}}
    <DButton
      @action={{this.toggleReaderMode}}
      @icon="book-reader"
      @preventFocus={{true}}
      title="Toggle Reader Mode"
      class={{concatClass
        "icon"
        "btn-default"
        "reader-mode-toggle"
        (if this.readerModeActive "active")
      }}
    />
  </template>
}
