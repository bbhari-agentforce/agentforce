import { LightningElement, api } from "lwc";
import { dispatchMessagingEvent, assignMessagingEventHandler, MESSAGING_EVENT } from "lightningsnapin/eventStore";

const SLDS_MENU_SELECTOR = "slds-dropdown-trigger slds-dropdown-trigger_click";

export default class ChatHeader extends LightningElement {
  /**
  * Deployment configuration data.
  * @type {Object}
  */
  @api configuration = {};

  /**
  * The status of the conversation. Valid values:
  * - NOT_STARTED
  * - OPEN
  * - CLOSED
  * @type {ConversationStatus}
  */
  @api conversationStatus;

  /**
  * Handle minimize button click.
  */
  onMinimizeButtonClick() {
      dispatchMessagingEvent(MESSAGING_EVENT.MINIMIZE_BUTTON_CLICK, {});
  }

  /**
  * Handle close button click.
  */
  onCloseButtonClick() {
    dispatchMessagingEvent(MESSAGING_EVENT.CLOSE_CONVERSATION, {});
    dispatchMessagingEvent(MESSAGING_EVENT.CLOSE_CONTAINER, {});
  }

  connectedCallback() {
      assignMessagingEventHandler(MESSAGING_EVENT.PARTICIPANT_JOINED, (data) => {
          console.log(`Participant joined`);
      });

      assignMessagingEventHandler(MESSAGING_EVENT.PARTICIPANT_LEFT, (data) => {
          console.log(`Participant left`);
      });

      assignMessagingEventHandler(MESSAGING_EVENT.UPDATE_HEADER_TEXT, (data) => {
          console.log(`Update header text: ${data.text}`);
      });

      assignMessagingEventHandler(MESSAGING_EVENT.TOGGLE_BACK_BUTTON, (data) => {
          console.log(`Toggle back button visibility.`);
      });
  }
}