import { DEFAULT_MESSAGES, MORNING_MESSAGES, BEDTIME_MESSAGES, TIME_SLOTS, MESSAGE_INTERVAL, TOTAL_TRANSITION, RIDDLE_DELAY, WEATHER_CONFIG } from './constants.js';

export class MessageRotator {
  constructor(board) {
    this.board = board;
    this._sourceMessages = null;
    this.messages = [];
    this.currentIndex = -1;
    this._timer = null;
    this._timeCheckTimer = null;
    this._riddleTimer = null;
    this._paused = false;
    this._weatherMessage = null;
    this._loadMessages();
  }

  start() {
    // Show first message immediately
    this.next();

    // Begin auto-rotation
    this._scheduleNext();

    // Periodically check if the time slot has changed (every 60s)
    this._timeCheckTimer = setInterval(() => {
      this._checkTimeSlot();
    }, 60000);
  }

  stop() {
    if (this._timer) {
      clearTimeout(this._timer);
      this._timer = null;
    }
    if (this._timeCheckTimer) {
      clearInterval(this._timeCheckTimer);
      this._timeCheckTimer = null;
    }
    if (this._riddleTimer) {
      clearTimeout(this._riddleTimer);
      this._riddleTimer = null;
    }
  }

  next() {
    this.currentIndex = (this.currentIndex + 1) % this.messages.length;
    const msg = this.messages[this.currentIndex];

    if (msg && msg.type === 'riddle') {
      this._showRiddle(msg);
    } else {
      this.board.displayMessage(msg);
      this._scheduleNext();
    }
  }

  prev() {
    this.currentIndex = (this.currentIndex - 1 + this.messages.length) % this.messages.length;
    const msg = this.messages[this.currentIndex];

    if (msg && msg.type === 'riddle') {
      this._showRiddle(msg);
    } else {
      this.board.displayMessage(msg);
      this._scheduleNext();
    }
  }

  _showRiddle(riddle) {
    // Show question first
    this.board.displayMessage(riddle.question);

    // After 15 seconds, show the answer
    if (this._riddleTimer) clearTimeout(this._riddleTimer);
    this._riddleTimer = setTimeout(() => {
      this.board.displayMessage(riddle.answer);
      this._riddleTimer = null;
      // Then schedule the next message after normal interval
      this._scheduleNext();
    }, RIDDLE_DELAY);
  }

  _scheduleNext() {
    if (this._timer) clearTimeout(this._timer);
    this._timer = setTimeout(() => {
      if (!this._paused && !this.board.isTransitioning) {
        this.next();
      } else {
        // Retry shortly if transitioning
        this._scheduleNext();
      }
    }, MESSAGE_INTERVAL + TOTAL_TRANSITION);
  }

  _loadMessages() {
    const now = new Date();
    const currentTime = now.getHours() + now.getMinutes() / 60;
    let source = DEFAULT_MESSAGES;
    for (const slot of TIME_SLOTS) {
      if (currentTime >= slot.startHour && currentTime < slot.endHour) {
        source = slot.messages;
        break;
      }
    }

    if (source === this._sourceMessages) return;
    this._sourceMessages = source;

    // Shallow copy; only shuffle the default set (morning/bedtime keep their interleaved order)
    this.messages = [...source];
    if (source === DEFAULT_MESSAGES) {
      for (let i = this.messages.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [this.messages[i], this.messages[j]] = [this.messages[j], this.messages[i]];
      }
    }

    // If morning, try to inject weather message
    if (source === MORNING_MESSAGES) {
      this._fetchWeather();
    }

    this.currentIndex = -1;
  }

  async _fetchWeather() {
    try {
      const res = await fetch(WEATHER_CONFIG.url);
      if (!res.ok) return;
      const data = await res.json();
      const temp = Math.round(data.current.temperature_2m);
      const code = data.current.weather_code;
      const label = WEATHER_CONFIG.weatherCodes[code] || 'CLEAR';
      const line = `${temp}°F  ${label}`;
      this._weatherMessage = ['', '  GOOD MORNING', `  ${line}`, '', ''];
      // Insert weather at the beginning of morning rotation
      this.messages.unshift(this._weatherMessage);
      // Adjust index so we don't skip anything
      if (this.currentIndex >= 0) this.currentIndex++;
    } catch {
      // Silently skip weather on error
    }
  }

  _checkTimeSlot() {
    const prevSource = this._sourceMessages;
    this._loadMessages();
    if (this._sourceMessages !== prevSource) {
      this.next();
    }
  }
}
