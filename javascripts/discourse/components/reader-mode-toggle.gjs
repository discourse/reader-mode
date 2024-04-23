import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import willDestroy from "@ember/render-modifiers/modifiers/will-destroy";
import DButton from "discourse/components/d-button";
import bodyClass from "discourse/helpers/body-class";
import concatClass from "discourse/helpers/concat-class";
import discourseLater from "discourse-common/lib/later";
import ReaderModeOptions from "./reader-mode-options";

export default class ReaderModeToggle extends Component {
  @tracked readerModeActive = false;
  @tracked isTransitioning = false;
  @tracked topicGridWidth = undefined;
  @tracked timelineGridWidth = undefined;

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

  handleDocumentKeydown(e) {
    if (e.ctrlKey && e.key === "r") {
      this.toggleReaderMode();
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

  @action
  setupWidth() {
    this.topicGridWidth = document.documentElement
      .querySelector(".post-stream .topic-post")
      .getBoundingClientRect().width;

    this.timelineGridWidth = document.documentElement
      .querySelector(".topic-navigation")
      .getBoundingClientRect().width;

    let hasDiscoToc =
      document.documentElement.querySelector(".d-toc-installed");

    if (hasDiscoToc) {
      document.documentElement.style.setProperty(
        "--reader-mode-topic-grid",
        `75% 25%`
      );
    } else {
      document.documentElement.style.setProperty(
        "--reader-mode-topic-grid",
        `${this.topicGridWidth}px ${this.timelineGridWidth}px`
      );
    }
  }

  <template>
    {{bodyClass this.bodyClassText}}
    <DButton
      {{didInsert this.addEventListener}}
      {{didInsert this.setupWidth}}
      {{willDestroy this.cleanUpEventListener}}
      @action={{this.toggleReaderMode}}
      @icon="book-reader"
      @preventFocus={{true}}
      title="Toggle Reader Mode (ctrl + r)"
      class={{concatClass
        "icon"
        "btn-default"
        "reader-mode-toggle"
        (if this.readerModeActive "active")
      }}
    />
    {{#if this.readerModeActive}}
      <ReaderModeOptions
        @topicGridWidth={{this.topicGridWidth}}
        @timelineGridWidth={{this.timelineGridWidth}}
      />
    {{/if}}
  </template>
}
