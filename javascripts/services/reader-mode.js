import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import Service from "@ember/service";
import discourseLater from "discourse-common/lib/later";

export default class ReaderMode extends Service {
  @tracked readerModeActive = false;
  @tracked isTransitioning = false;
  @tracked
  topicGridWidth =
    parseInt(localStorage.getItem("readerModeTopicGridWidth"), 10) || undefined;
  @tracked
  timelineGridWidth =
    parseInt(localStorage.getItem("readerModeTimelineGridWidth"), 10) ||
    undefined;
  @tracked
  fontSizeIncrement =
    parseInt(localStorage.getItem("readerModeFontSizeIncrement"), 10) || 0;
  @tracked
  offsetIncrement =
    parseInt(localStorage.getItem("readerModeOffsetIncrement"), 10) || 0;
  @tracked
  fontFamily = localStorage.getItem("readerModeFontFamily") || "default";
  @tracked colorMode = localStorage.getItem("readerModeColorMode") || "default";

  FONT_MAX_INCREMENT = 10;
  OFFSET_MAX_INCREMENT = 208;

  @action
  toggleReaderMode() {
    this.isTransitioning = true;
    discourseLater(() => {
      this.readerModeActive = !this.readerModeActive;
      this.isTransitioning = false;
    }, 10);
  }

  @action
  selectFont(e) {
    if (e.target) {
      this.fontFamily = e.target.value;
      localStorage.setItem("readerModeFontFamily", this.fontFamily);
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
    localStorage.setItem("readerModeFontSizeIncrement", this.fontSizeIncrement);
    this.selectFontSize();
  }

  @action
  incrementFontSize() {
    if (this.fontSizeIncrement === this.FONT_MAX_INCREMENT) {
      return;
    }

    this.fontSizeIncrement += 1;
    localStorage.setItem("readerModeFontSizeIncrement", this.fontSizeIncrement);
    this.selectFontSize();
  }

  @action
  selectFontSize() {
    const setFontSize = (property, baseValue, increment) => {
      const value = increment === 0 ? baseValue : baseValue + increment * 0.125;
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
    this.offsetIncrement = Math.round(10 * (this.offsetIncrement + 20.8)) / 10;
    localStorage.setItem("readerModeOffsetIncrement", this.offsetIncrement);
    this.selectOffset(this.offsetIncrement);
  }

  @action
  decrementOffset() {
    if (Math.round(10 * (this.offsetIncrement - 20.8)) / 10 < 0) {
      this.offsetIncrement = 0;
    } else {
      this.offsetIncrement =
        Math.round(10 * (this.offsetIncrement - 20.8)) / 10;
    }
    localStorage.setItem("readerModeOffsetIncrement", this.offsetIncrement);
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
  setupWidth() {
    if (
      document.documentElement.style.getPropertyValue(
        "--reader-mode-topic-grid"
      )
    ) {
      return;
    }

    this.topicGridWidth =
      Math.round(
        10 *
          document.documentElement
            .querySelector(".post-stream .topic-post")
            .getBoundingClientRect().width
      ) / 10;

    localStorage.setItem("readerModeTopicGridWidth", this.topicGridWidth);

    this.timelineGridWidth =
      Math.round(
        10 *
          document.documentElement
            .querySelector(".topic-navigation")
            .getBoundingClientRect().width
      ) / 10;

    localStorage.setItem("readerModeTimelineGridWidth", this.timelineGridWidth);

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

  selectColors(textValue, bgValue) {
    document.documentElement.style.setProperty(
      "--reader-mode-bg-color",
      bgValue
    );
    document.documentElement.style.setProperty(
      "--reader-mode-text-color",
      textValue
    );
  }
  setDefaultColors() {
    this.colorMode = "default";
    this.selectColors("var(--primary)", "var(--secondary)");
  }

  @action
  toggleLightMode() {
    if (this.colorMode === "light") {
      this.setDefaultColors();
    } else {
      this.colorMode = "light";
      this.selectColors("#424547", "#FAFAFA");
    }
    localStorage.setItem("readerModeColorMode", this.colorMode);
  }

  @action
  toggleSepiaMode() {
    if (this.colorMode === "sepia") {
      this.setDefaultColors();
    } else {
      this.colorMode = "sepia";
      this.selectColors("#424547", "#F5F1E4");
    }
    localStorage.setItem("readerModeColorMode", this.colorMode);
  }

  @action
  toggleDarkMode() {
    if (this.colorMode === "dark") {
      this.setDefaultColors();
    } else {
      this.colorMode = "dark";
      this.selectColors("#D3D7DA", "#202121");
    }

    localStorage.setItem("readerModeColorMode", this.colorMode);
  }

  @action
  setupColors() {
    if (this.colorMode === "light") {
      this.selectColors("#424547", "#FAFAFA");
    } else if (this.colorMode === "sepia") {
      this.selectColors("#424547", "#F5F1E4");
    } else if (this.colorMode === "dark") {
      this.selectColors("#D3D7DA", "#202121");
    } else {
      this.setDefaultColors();
    }
  }
}
