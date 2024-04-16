import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { getOwner } from "@ember/application";
import { action } from "@ember/object";
import { service } from "@ember/service";
import DButton from "discourse/components/d-button";
import bodyClass from "discourse/helpers/body-class";
import concatClass from "discourse/helpers/concat-class";
import icon from "discourse-common/helpers/d-icon";

export default class readerModeToggle extends Component {
  @service router;
  @service site;

  @tracked readerModeActive = false;
  @tracked viewingTopic = undefined;
  @tracked
  sidebarIsOpen = getOwner(this).lookup("controller:application").get("showSidebar");
  @tracked sidebarPreviousState = undefined;

  constructor() {
    super(...arguments);
  }

  get isActive() {
    return this.readerModeActive;
  }

  get bodyClassText() {
    return this.isActive ? "reader-mode" : "";
  }

  get isTopicView() {
    return this.router.currentRouteName.includes("topic");
  }

  @action
  toggleReaderMode() {

    if (this.sidebarIsOpen && !this.isActive) {
      getOwner(this).lookup("controller:application").set("showSidebar", false);
      this.readerModeActive = !this.readerModeActive;
    } else {
      getOwner(this).lookup("controller:application").set("showSidebar", true);
      this.readerModeActive = false;
    }

  }

  <template>
      {{#if this.isTopicView}}
        {{bodyClass this.bodyClassText}}
          <DButton
            class={{concatClass "icon" "btn-default" "reader-mode-toggle" (if this.isActive "active")}}
            title="Toggle Reader Mode"
            @action={{this.toggleReaderMode}}
            @preventFocus={{true}}
          >
            {{~icon "book-reader"}}
          </DButton>
      {{/if}}
  </template>
}