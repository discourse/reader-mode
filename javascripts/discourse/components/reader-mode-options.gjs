import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { array } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import icon from "discourse-common/helpers/d-icon";
import DMenu from "float-kit/components/d-menu";

export default class ReaderModeOptions extends Component {
  @tracked showOptions = false;
  @tracked originalWidth = undefined;

  @action
  toggleOptions() {
    this.showOptions = !this.showOptions;
  }

  @action
  selectFont(e) {
    document.documentElement.style.setProperty(
      "--reader-mode-font-family",
      e.target.value
    );
  }

  @action
  selectFontSize(e) {
    const setFontSize = (property, baseValue) => {
      const value =
        e.target.value === 0 ? baseValue : baseValue + e.target.value * 0.1;
      document.documentElement.style.setProperty(property, `${value}rem`);
    };

    setFontSize("--reader-mode-font-size", 1);
    setFontSize("--reader-mode-h1-font-size", 1.517);
    setFontSize("--reader-mode-h2-font-size", 1.3195);
    setFontSize("--reader-mode-h3-font-size", 1.1487);
    setFontSize("--reader-mode-h4-font-size", 1);
    setFontSize("--reader-mode-h5-font-size", 0.8706);
    setFontSize("--reader-mode-h6-font-size", 0.7579);
    setFontSize("--reader-mode-small-font-size", 0.75);
    setFontSize("--reader-mode-big-font-size", 1.5);
  }

  @action
  selectOffset(e) {
    let contentWidthVariable = `-${e.target.value}px`;

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
    let additionalWidth = parseInt(e.target.value, 10);
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
      "--topic-grid-width",
      `${this.originalWidth + parseInt(e.target.value, 10)}px auto`
    );
  }

  @action
  setTopicWidth() {
    this.originalWidth = document.documentElement
      .querySelector(".post-stream .topic-post")
      .getBoundingClientRect().width;
    document.documentElement.style.setProperty(
      "--topic-grid-width",
      `${this.originalWidth}px auto`
    );
  }

  <template>
    <DMenu
      {{didInsert this.setTopicWidth}}
      @identifier="reader-mode-options"
      @triggers={{array "click"}}
      @placementStrategy="fixed"
      @class="reader-mode-options"
    >
      <:trigger>
        {{icon "cog"}}
      </:trigger>
      <:content>
        <div class="reader-mode-options__body">
          <div class="reader-mode-options__section">
            <h3 class="reader-mode-options__section-title">Readability</h3>
            <div class="reader-mode-options__section-content">
              <div class="reader-mode-options__section-item">
                <label for="font-family">Font Style</label>
                <select id="font-family" {{on "input" this.selectFont}}>
                  <option value="Arial">Arial</option>
                  <option value="Arial Black">Arial Black</option>
                  <option value="Serif">Serif</option>
                  <option value="sans-serif">Sans-serif</option>
                  <option value="Times New Roman">Times New Roman</option>
                  <option value="Courier New">Courier New</option>
                  <option value="Courier">Courier</option>
                </select>
              </div>
              <div class="reader-mode-options__section-item">
                <label for="font-size">Font Size</label>
                <input
                  type="range"
                  id="font-size"
                  min="0"
                  max="10"
                  step="1"
                  value="0"
                  {{on "input" this.selectFontSize}}
                />
              </div>
              <div class="reader-mode-options__section-item">
                <label for="content-width">Content Width</label>
                <input
                  type="range"
                  id="content-width"
                  min="1"
                  max="208"
                  step="1"
                  value="0"
                  {{on "input" this.selectOffset}}
                />
              </div>
            </div>
          </div>
        </div>
      </:content>
    </DMenu>
  </template>
}
