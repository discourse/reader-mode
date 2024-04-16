import Component from "@glimmer/component";
import { service } from "@ember/service";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import DButton from "discourse/components/d-button";
import concatClass from "discourse/helpers/concat-class";
import icon from "discourse-common/helpers/d-icon";
import bodyClass from "discourse/helpers/body-class";
import { getOwner } from "@ember/application";

export default class readerModeToggle extends Component {
  @service router;
  @service site;

  @tracked isActive = false;
  @tracked viewingTopic = undefined;
  @tracked sidebarIsOpen = getOwner(this).lookup("controller:application").get("showSidebar");
  @tracked sidebarPreviousState = undefined;

  constructor() {
    super(...arguments);
  }

  get isActive() {
    return this.isActive;
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
      this.isActive = !this.isActive;
    } else {
      getOwner(this).lookup("controller:application").set("showSidebar", true);
      this.isActive = false;
    }

  }

  <template>
      {{#if this.isTopicView}}
        {{bodyClass this.bodyClassText}}
          <DButton
            class={{concatClass "icon" "btn-default" "reader-mode-toggle" (if this.isActive "active")}}
            title="Toggle Reader Mode"
            @action={{this.toggleReaderMode}}
          >
            {{~icon "book-reader"}}
          </DButton>
      {{/if}}
  </template>
}