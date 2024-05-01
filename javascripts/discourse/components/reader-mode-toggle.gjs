import Component from "@glimmer/component";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import willDestroy from "@ember/render-modifiers/modifiers/will-destroy";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import bodyClass from "discourse/helpers/body-class";
import concatClass from "discourse/helpers/concat-class";
import ReaderModeOptions from "./reader-mode-options";

export default class ReaderModeToggle extends Component {
  @service readerMode;

  get bodyClassText() {
    return this.readerMode.isTransitioning
      ? "reader-mode-transitioning reader-mode"
      : this.readerMode.readerModeActive
      ? "reader-mode"
      : "";
  }

  handleDocumentKeydown(e) {
    if (e.ctrlKey && e.key === "r") {
      this.readerMode.toggleReaderMode();
    }
  }

  @action
  addEventListener() {
    document.addEventListener("keydown", this.handleDocumentKeydown.bind(this));
  }

  @action
  cleanUpEventListener() {
    document.removeEventListener("keydown", this.handleDocumentKeydown);
  }

  <template>
    {{bodyClass this.bodyClassText}}
    <DButton
      {{didInsert this.addEventListener}}
      {{didInsert this.readerMode.setupWidth}}
      {{willDestroy this.cleanUpEventListener}}
      @action={{this.readerMode.toggleReaderMode}}
      @icon="book-reader"
      @preventFocus={{true}}
      title="Toggle Reader Mode (ctrl + r)"
      class={{concatClass
        "icon"
        "btn-default"
        "reader-mode-toggle"
        (if this.readerMode.readerModeActive "active")
      }}
    />
    {{#if this.readerMode.readerModeActive}}
      <ReaderModeOptions />
    {{/if}}
  </template>
}
