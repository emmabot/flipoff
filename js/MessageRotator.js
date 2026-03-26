import { DEFAULT_MESSAGES, TIME_SLOTS, MESSAGE_INTERVAL, TOTAL_TRANSITION } from './constants.js';

export class MessageRotator {
  constructor(board) {
    this.board = board;
    this.messages = this._getMessagesForCurrentTime();
    this.currentIndex = -1;
    this._timer = null;
    this._timeCheckTimer = null;
    this._paused = false;
  }

  start() {
    // Show first message immediately
    this.next();

    // Begin auto-rotation
    this._timer = setInterval(() => {
      if (!this._paused && !this.board.isTransitioning) {
        this.next();
      }
    }, MESSAGE_INTERVAL + TOTAL_TRANSITION);

    // Periodically check if the time slot has changed (every 60s)
    this._timeCheckTimer = setInterval(() => {
      this._checkTimeSlot();
    }, 60000);
  }

  stop() {
    if (this._timer) {
      clearInterval(this._timer);
      this._timer = null;
    }
    if (this._timeCheckTimer) {
      clearInterval(this._timeCheckTimer);
      this._timeCheckTimer = null;
    }
  }

  next() {
    this.currentIndex = (this.currentIndex + 1) % this.messages.length;
    this.board.displayMessage(this.messages[this.currentIndex]);
    this._resetAutoRotation();
  }

  prev() {
    this.currentIndex = (this.currentIndex - 1 + this.messages.length) % this.messages.length;
    this.board.displayMessage(this.messages[this.currentIndex]);
    this._resetAutoRotation();
  }

  _getMessagesForCurrentTime() {
    const hour = new Date().getHours();
    for (const slot of TIME_SLOTS) {
      if (hour >= slot.startHour && hour < slot.endHour) {
        return slot.messages;
      }
    }
    return DEFAULT_MESSAGES;
  }

  _checkTimeSlot() {
    const newMessages = this._getMessagesForCurrentTime();
    if (newMessages !== this.messages) {
      this.messages = newMessages;
      this.currentIndex = -1;
      this.next();
    }
  }

  _resetAutoRotation() {
    // Reset timer when user manually navigates
    if (this._timer) {
      clearInterval(this._timer);
      this._timer = setInterval(() => {
        if (!this._paused && !this.board.isTransitioning) {
          this.next();
        }
      }, MESSAGE_INTERVAL + TOTAL_TRANSITION);
    }
  }
}
