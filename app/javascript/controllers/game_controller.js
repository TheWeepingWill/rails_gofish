import { Controller } from "@hotwired/stimulus";
import consumer from "channels/consumer";

export default class extends Controller {
  static targets = ["game_page"];

  connect() {
    this.subscription = consumer.subscriptions.create(
      {
        channel: "GameChannel",
        id: this.data.get("id"),
        user_id: this.data.get("user_id"),
      },
      {
        connected: this._connected.bind(this),
        disconnected: this._disconnected.bind(this),
        received: this._received.bind(this),
      }
    );
  }



 
  _connected() {}

  _disconnected() {}

  _received(data) {
    console.log('recieved', data)
    const element = this.game_pageTarget
    element.innerHTML = data
  }
}