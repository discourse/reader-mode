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
  @tracked fontSizeIncrement = 0;
  @tracked offsetIncrement = 0;
  @tracked fontFamily = "default";

  FONT_MAX_INCREMENT = 10;
  OFFSET_MAX_INCREMENT = 208;

  get bodyClassText() {
    return this.isTransitioning
      ? "reader-mode-transitioning reader-mode"
      : this.readerModeActive
      ? "reader-mode"
      : "";
  }

  @action
  selectFont(e) {
    if (e.target) {
      this.fontFamily = e.target.value;
    }

    document.documentElement.style.setProperty(
      "--reader-mode-font-family",
      this.fontFamily
    );
  }

  @action
  decrementFontSize() {
    if (this.fontSizeIncrement === 0) {
      return;
    }

    this.fontSizeIncrement -= 1;
    this.selectFontSize();
  }

    @action
  incrementFontSize() {
    if (this.fontSizeIncrement === this.FONT_MAX_INCREMENT) {
      return;
    }

    this.fontSizeIncrement += 1;
    this.selectFontSize();
  }

  @action
  selectFontSize() {
    const setFontSize = (property, baseValue, increment) => {
      const value =
        increment === 0 ? baseValue : baseValue + (increment * 0.125);
      document.documentElement.style.setProperty(property, `${value}rem`);
    };

    setFontSize("--reader-mode-font-size", 1, this.fontSizeIncrement);
    setFontSize("--reader-mode-h1-font-size", 1.517, this.fontSizeIncrement);
    setFontSize("--reader-mode-h2-font-size", 1.3195, this.fontSizeIncrement);
    setFontSize("--reader-mode-h3-font-size", 1.1487, this.fontSizeIncrement);
    setFontSize("--reader-mode-h4-font-size", 1, this.fontSizeIncrement);
    setFontSize("--reader-mode-h5-font-size", 0.8706, this.fontSizeIncrement);
    setFontSize("--reader-mode-h6-font-size", 0.7579, this.fontSizeIncrement);
    setFontSize("--reader-mode-small-font-size", 0.75, this.fontSizeIncrement);
    setFontSize("--reader-mode-big-font-size", 1.5, this.fontSizeIncrement);
  }

  @action
  incrementOffset() {
    if (this.offsetIncrement === this.OFFSET_MAX_INCREMENT) {
      return;
    }

    this.offsetIncrement = Math.round(10 * (this.offsetIncrement + 20.8))/10
    this.selectOffset(this.offsetIncrement);
  }

  @action
  decrementOffset() {
    if (this.offsetIncrement === 0) {
      return;
    }

    this.offsetIncrement = Math.round(10 * (this.offsetIncrement - 20.8))/10;
    this.selectOffset();
  }
  
  @action
  selectOffset() {
    let contentWidthVariable = `-${this.offsetIncrement}px`;

    let topicBodyWidth = parseInt(
      window
        .getComputedStyle(document.documentElement)
        .getPropertyValue("--topic-body-width"),
      10
    );
    let topicbodyWidthPadding = parseInt(
      window
        .getComputedStyle(document.documentElement)
        .getPropertyValue("--topic-body-width-padding"),
      10
    );
    let additionalWidth = this.offsetIncrement;
    let topicBodyWidthVariable = `${
      topicBodyWidth + additionalWidth + topicbodyWidthPadding * 2
    }px`;

    // Move the content to the left when width increases
    document.documentElement.style.setProperty(
      "--reader-mode-offset",
      contentWidthVariable
    );
    // increase with of topic body
    document.documentElement.style.setProperty(
      "--reader-mode-topic-body-width",
      topicBodyWidthVariable
    );
    // increase defined grid width for topic content
    document.documentElement.style.setProperty(
      "--reader-mode-topic-grid",
      `${this.topicGridWidth + this.offsetIncrement}px ${
        this.timelineGridWidth
      }px`
    );
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
    if (document.documentElement.style.getPropertyValue("--reader-mode-topic-grid")) {
      console.log(document.documentElement.style.getPropertyValue("--reader-mode-topic-grid"));
      return;
    }

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
        {{didInsert this.selectFontSize}}
        {{didInsert this.selectFont}}
        {{didInsert this.selectOffset}}
        @topicGridWidth={{this.topicGridWidth}}
        @timelineGridWidth={{this.timelineGridWidth}}
        @selectFont={{this.selectFont}}
        @fontSizeIncrement={{this.fontSizeIncrement}}
        @decrementFontSize={{this.decrementFontSize}}
        @incrementFontSize={{this.incrementFontSize}}
        @FONT_MAX_INCREMENT={{this.FONT_MAX_INCREMENT}}
        @offsetIncrement={{this.offsetIncrement}}
        @OFFSET_MAX_INCREMENT={{this.OFFSET_MAX_INCREMENT}}
        @decrementOffset={{this.decrementOffset}}
        @incrementOffset={{this.incrementOffset}}
      />
    {{/if}}
  </template>
}
