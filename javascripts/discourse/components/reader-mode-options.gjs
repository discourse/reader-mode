import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import { array } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { eq } from "truth-helpers";
import DButton from "discourse/components/d-button";
import icon from "discourse-common/helpers/d-icon";
import DMenu from "float-kit/components/d-menu";

export default class ReaderModeOptions extends Component {
  @tracked showOptions = false;

  @action
  toggleOptions() {
    this.showOptions = !this.showOptions;
  }

  <template>
    <DMenu
      @identifier="reader-mode-options"
      @triggers={{array "click"}}
      @placementStrategy="fixed"
      @class="reader-mode-options"
      @inline={{true}}
    >
      <:trigger>
        {{icon "cog"}}
      </:trigger>
      <:content>
        <div class="reader-mode-options__body"
        >
          <div class="reader-mode-options__section">
            <h4 class="reader-mode-options__section-title">Text Settings</h4>
            <div class="reader-mode-options__section-content">
              <div class="reader-mode-options__section-item">
                <select id="font-family" {{on "input" this.args.selectFont}}>
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
                <DButton
                  @action={{this.args.decrementFontSize}}
                  @preventFocus={{true}}
                  @icon="font"
                  @class="btn-flat reader-mode-options__item-button decrease-font"
                  @disabled={{if (eq this.args.fontSizeIncrement 0) "true"}}
                  />
                <DButton
                  @action={{this.args.incrementFontSize}}
                  @preventFocus={{true}}
                  @icon="font"
                  @class="btn-flat reader-mode-options__item-button increase-font"
                  @disabled={{if (eq this.args.fontSizeIncrement this.args.FONT_MAX_INCREMENT) "true"}}
                  />
              </div>
              <div class="reader-mode-options__section-item">
                <label for="content-width">Content Width</label>
                <DButton
                  @action={{this.args.decrementOffset}}
                  @preventFocus={{true}}
                  @icon="compress-alt"
                  @class="btn-flat reader-mode-options__item-button decrease-width"
                  @disabled={{if (eq this.args.offsetIncrement 0) "true"}}
                  />
                <DButton
                  @action={{this.args.incrementOffset}}
                  @preventFocus={{true}}
                  @icon="arrows-alt-h"
                  @class="btn-flat reader-mode-options__item-button increase-width"
                  @disabled={{if (eq this.args.offsetIncrement this.args.OFFSET_MAX_INCREMENT) "true"}}
                  />
                {{!-- <label for="content-width">Content Width</label>
                <input
                  type="range"
                  id="content-width"
                  min="1"
                  max="208"
                  step="1"
                  value="0"
                  {{on "input" this.selectOffset}}
                /> --}}
              </div>
            </div>
          </div>
        </div>
      </:content>
    </DMenu>
  </template>
}
