import { DEFAULT_MESSAGES, MORNING_MESSAGES, BEDTIME_MESSAGES, TIME_SLOTS, MESSAGE_INTERVAL, TOTAL_TRANSITION, RIDDLE_DELAY, WEATHER_CONFIG, ROCK_PAPER_SCISSORS } from './constants.js';

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
    this._messagesSinceRPS = 0;
    this._rpsInterval = 3 + Math.floor(Math.random() * 3); // 3-5 messages
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
    this._messagesSinceRPS++;

    if (this._messagesSinceRPS >= this._rpsInterval) {
      this._messagesSinceRPS = 0;
      this._rpsInterval = 3 + Math.floor(Math.random() * 3); // Reset to random 3-5
      const rps = ROCK_PAPER_SCISSORS[Math.floor(Math.random() * ROCK_PAPER_SCISSORS.length)];
      this._showWithDelay(rps.question, rps.answer);
      return;
    }

    this.currentIndex = (this.currentIndex + 1) % this.messages.length;
    this._displayCurrent();
  }

  prev() {
    this._messagesSinceRPS++;

    if (this._messagesSinceRPS >= this._rpsInterval) {
      this._messagesSinceRPS = 0;
      this._rpsInterval = 3 + Math.floor(Math.random() * 3);
      const rps = ROCK_PAPER_SCISSORS[Math.floor(Math.random() * ROCK_PAPER_SCISSORS.length)];
      this._showWithDelay(rps.question, rps.answer);
      return;
    }

    this.currentIndex = (this.currentIndex - 1 + this.messages.length) % this.messages.length;
    this._displayCurrent();
  }

  _displayCurrent() {
    const msg = this.messages[this.currentIndex];

    if (msg && msg.type === 'riddle') {
      this._showWithDelay(msg.question, msg.answer);
    } else if (msg && msg.type === 'joke') {
      const lines = msg.lines;
      const question = [lines[0], lines[1], lines[2], '', lines[4]];
      const answer = ['', '', lines[3], '', ''];
      this._showWithDelay(question, answer);
    } else if (msg && msg.lines) {
      this.board.displayMessage(msg.lines);
      this._scheduleNext();
    } else if (Array.isArray(msg)) {
      // Backward compat for dynamically created plain arrays (weather, moon)
      this.board.displayMessage(msg);
      this._scheduleNext();
    }
  }

  _showWithDelay(question, answer) {
    // Show question first
    this.board.displayMessage(question);

    // After delay, show the answer
    if (this._riddleTimer) clearTimeout(this._riddleTimer);
    this._riddleTimer = setTimeout(() => {
      this.board.displayMessage(answer);
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

  _getMoonPhase() {
    const now = new Date();
    // Known new moon: January 6, 2000
    const knownNewMoon = new Date(2000, 0, 6);
    const daysSince = (now - knownNewMoon) / (1000 * 60 * 60 * 24);
    const lunarCycle = 29.53;
    const phase = ((daysSince % lunarCycle) + lunarCycle) % lunarCycle;

    let phaseName;
    if (phase < 1.85) phaseName = 'NEW MOON';
    else if (phase < 5.53) phaseName = 'WAXING CRESCENT';
    else if (phase < 9.22) phaseName = 'FIRST QUARTER';
    else if (phase < 12.91) phaseName = 'WAXING GIBBOUS';
    else if (phase < 16.61) phaseName = 'FULL MOON';
    else if (phase < 20.30) phaseName = 'WANING GIBBOUS';
    else if (phase < 23.99) phaseName = 'LAST QUARTER';
    else if (phase < 27.68) phaseName = 'WANING CRESCENT';
    else phaseName = 'NEW MOON';

    return phaseName;
  }

  async _fetchWeather() {
    // Always insert moon phase, regardless of weather success
    const moonPhase = this._getMoonPhase();
    const moonMessage = { type: 'info', lines: ['', '  TONIGHTS MOON', `  ${moonPhase}`, '', ''] };

    try {
      const res = await fetch(WEATHER_CONFIG.url);
      if (!res.ok) {
        this.messages.unshift(moonMessage);
        if (this.currentIndex >= 0) this.currentIndex++;
        return;
      }
      const data = await res.json();
      const temp = Math.round(data.current.temperature_2m);
      const code = data.current.weather_code;
      const label = WEATHER_CONFIG.weatherCodes[code] || 'CLEAR';
      const line = `${temp}°F  ${label}`;
      this._weatherMessage = { type: 'info', lines: ['', '  GOOD MORNING', `  ${line}`, '', ''] };
      // Insert weather at the beginning of morning rotation
      this.messages.unshift(this._weatherMessage);
      // Adjust index so we don't skip anything
      if (this.currentIndex >= 0) this.currentIndex++;
      // Insert moon phase after weather
      this.messages.splice(1, 0, moonMessage);
      if (this.currentIndex >= 1) this.currentIndex++;
    } catch {
      // Weather failed, but still show moon phase
      this.messages.unshift(moonMessage);
      if (this.currentIndex >= 0) this.currentIndex++;
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
