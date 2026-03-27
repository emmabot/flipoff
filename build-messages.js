#!/usr/bin/env node

// Build script: generates messages.json from constants.js
// Run: node build-messages.js

import {
  DEFAULT_MESSAGES, MORNING_MESSAGES, BEDTIME_MESSAGES,
  GRID_COLS, GRID_ROWS, RIDDLE_DELAY, MESSAGE_INTERVAL,
  SCRAMBLE_COLORS, WEATHER_CONFIG, ROCK_PAPER_SCISSORS
} from './js/constants.js';

import { writeFileSync } from 'fs';

function normalizeMessage(msg) {
  if (msg && msg.type === 'riddle') {
    return { type: 'riddle', question: msg.question, answer: msg.answer };
  }
  if (msg && msg.type && msg.lines) {
    return { type: msg.type, lines: msg.lines };
  }
  // Plain array fallback (for backward compat)
  if (Array.isArray(msg)) {
    return { type: 'plain', lines: msg };
  }
  return msg;
}

const output = {
  config: {
    gridCols: GRID_COLS,
    gridRows: GRID_ROWS,
    riddleDelay: RIDDLE_DELAY,
    messageInterval: MESSAGE_INTERVAL,
    scrambleColors: SCRAMBLE_COLORS,
    weather: {
      url: WEATHER_CONFIG.url,
      codes: WEATHER_CONFIG.weatherCodes
    }
  },
  messages: {
    default: DEFAULT_MESSAGES.map(normalizeMessage),
    morning: MORNING_MESSAGES.map(normalizeMessage),
    bedtime: BEDTIME_MESSAGES.map(normalizeMessage),
    rps: ROCK_PAPER_SCISSORS.map(normalizeMessage)
  }
};

writeFileSync('messages.json', JSON.stringify(output, null, 2));
console.log(`Generated messages.json with ${output.messages.default.length} default, ${output.messages.morning.length} morning, ${output.messages.bedtime.length} bedtime messages`);

