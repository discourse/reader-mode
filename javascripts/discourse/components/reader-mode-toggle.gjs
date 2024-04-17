import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import didUpdate from "@ember/render-modifiers/modifiers/did-update";
import DButton from "discourse/components/d-button";
import bodyClass from "discourse/helpers/body-class";
import concatClass from "discourse/helpers/concat-class";
import icon from "discourse-common/helpers/d-icon";
import discourseLater from "discourse-common/lib/later";

export default class readerModeToggle extends Component {
  @tracked readerModeActive = false;
  @tracked isTransitioning = false;

  constructor() {
    super(...arguments);
  }

  get isActive() {
    return this.readerModeActive;
  }

  get bodyClassText() {
    return this.isTransitioning
      ? "reader-mode-transitioning reader-mode"
      : this.isActive
      ? "reader-mode"
      : "";
  }

  @action
  toggleReaderMode() {
    if (!this.isActive) {
      this.isTransitioning = true;
      discourseLater(() => {
        this.readerModeActive = !this.readerModeActive;
        this.isTransitioning = false;
      }, 10);
    } else {
      this.isTransitioning = true;
      discourseLater(() => {
        this.readerModeActive = false;
        this.isTransitioning = false;
      }, 10);
    }
  }

  <template>
    {{bodyClass this.bodyClassText}}
    <DButton
      class={{concatClass
        "icon"
        "btn-default"
        "reader-mode-toggle"
        (if this.isActive "active")
      }}
      title="Toggle Reader Mode"
      @action={{this.toggleReaderMode}}
      @preventFocus={{true}}
    >
      {{~icon "book-reader"}}
    </DButton>
  </template>
}
