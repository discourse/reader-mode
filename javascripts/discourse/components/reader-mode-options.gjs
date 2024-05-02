import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { array } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import didInsert from "@ember/render-modifiers/modifiers/did-insert";
import { service } from "@ember/service";
import { eq } from "truth-helpers";
import DButton from "discourse/components/d-button";
import concatClass from "discourse/helpers/concat-class";
import icon from "discourse-common/helpers/d-icon";
import DMenu from "float-kit/components/d-menu";

export default class ReaderModeOptions extends Component {
  @service readerMode;

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
      {{didInsert this.readerMode.selectFontSize}}
      {{didInsert this.readerMode.selectFont}}
      {{didInsert this.readerMode.selectOffset}}
      {{didInsert this.readerMode.setupWidth}}
      {{didInsert this.readerMode.setupColors}}
    >
      <:trigger>
        {{icon "cog"}}
      </:trigger>
      <:content>
        <div class="reader-mode-options__body">
          <div class="reader-mode-options__section">
            <div class="reader-mode-options__section-content">
              <div class="reader-mode-options__section-item">
                <select
                  id="font-family"
                  {{on "input" this.readerMode.selectFont}}
                >
                  <option
                    selected={{if (eq this.readerMode.fontFamily "Arial") true}}
                    value="Arial"
                  >Arial</option>
                  <option
                    selected={{if (eq this.readerMode.fontFamily "Serif") true}}
                    value="Serif"
                  >Serif</option>
                  <option
                    selected={{if
                      (eq this.readerMode.fontFamily "sans-serif")
                      true
                    }}
                    value="sans-serif"
                  >Sans-serif</option>
                  <option
                    selected={{if
                      (eq this.readerMode.fontFamily "Courier")
                      true
                    }}
                    value="Courier"
                  >Courier</option>
                </select>
              </div>
              <div class="reader-mode-options__section-item">
                <DButton
                  @action={{this.readerMode.decrementFontSize}}
                  @preventFocus={{true}}
                  @icon="font"
                  @class="btn-flat reader-mode-options__item-button decrease-font text-changes"
                  @disabled={{if
                    (eq this.readerMode.fontSizeIncrement 0)
                    "true"
                  }}
                />
                <DButton
                  @action={{this.readerMode.incrementFontSize}}
                  @preventFocus={{true}}
                  @icon="font"
                  @class="btn-flat reader-mode-options__item-button increase-font text-changes"
                  @disabled={{if
                    (eq
                      this.readerMode.fontSizeIncrement
                      this.readerMode.FONT_MAX_INCREMENT
                    )
                    "true"
                  }}
                />
              </div>
              <div class="reader-mode-options__section-item">
                <DButton
                  @action={{this.readerMode.decrementOffset}}
                  @preventFocus={{true}}
                  @icon="compress-alt"
                  @class="btn-flat reader-mode-options__item-button decrease-width text-changes"
                  @disabled={{if (eq this.readerMode.offsetIncrement 0) "true"}}
                />
                <DButton
                  @action={{this.readerMode.incrementOffset}}
                  @preventFocus={{true}}
                  @icon="arrows-alt-h"
                  @class="btn-flat reader-mode-options__item-button increase-width text-changes"
                  @disabled={{if
                    (eq
                      this.readerMode.offsetIncrement
                      this.readerMode.OFFSET_MAX_INCREMENT
                    )
                    "true"
                  }}
                />
              </div>
              <div class="reader-mode-options__section-item">
                <DButton
                  @action={{this.readerMode.toggleLightMode}}
                  @preventFocus={{true}}
                  @icon="circle"
                  @class={{concatClass
                    "btn-flat reader-mode-options__item-button light-mode color-mode"
                    (if (eq this.readerMode.colorMode "light") "active")
                  }}
                />
                <DButton
                  @action={{this.readerMode.toggleSepiaMode}}
                  @preventFocus={{true}}
                  @icon="circle"
                  @class={{concatClass
                    "btn-flat reader-mode-options__item-button sepia-mode color-mode"
                    (if (eq this.readerMode.colorMode "sepia") "active")
                  }}
                />
                <DButton
                  @action={{this.readerMode.toggleDarkMode}}
                  @preventFocus={{true}}
                  @icon="circle"
                  @class={{concatClass
                    "btn-flat reader-mode-options__item-button dark-mode color-mode"
                    (if (eq this.readerMode.colorMode "dark") "active")
                  }}
                />
              </div>
            </div>
          </div>
        </div>
      </:content>
    </DMenu>
  </template>
}
