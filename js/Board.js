import { Tile } from './Tile.js';
import {
  GRID_COLS, GRID_ROWS, STAGGER_DELAY, SCRAMBLE_DURATION,
  TOTAL_TRANSITION, ACCENT_COLORS, CHARSET, SCRAMBLE_COLORS
} from './constants.js';

export class Board {
  constructor(containerEl, soundEngine) {
    this.cols = GRID_COLS;
    this.rows = GRID_ROWS;
    this.soundEngine = soundEngine;
    this.isTransitioning = false;
    this.tiles = [];
    this.currentGrid = [];
    this.accentIndex = 0;

    // Build board DOM
    this.boardEl = document.createElement('div');
    this.boardEl.className = 'board';
    this.boardEl.setAttribute('role', 'region');
    this.boardEl.setAttribute('aria-label', 'Split-flap display');
    this.boardEl.style.setProperty('--grid-cols', this.cols);
    this.boardEl.style.setProperty('--grid-rows', this.rows);

    // Left accent indicators
    this.leftBar = this._createAccentBar('accent-bar-left');
    this.boardEl.appendChild(this.leftBar);

    // Tile grid — presentational, screen readers use the live region instead
    this.gridEl = document.createElement('div');
    this.gridEl.className = 'tile-grid';
    this.gridEl.setAttribute('role', 'img');
    this.gridEl.setAttribute('aria-hidden', 'true');

    for (let r = 0; r < this.rows; r++) {
      const row = [];
      const charRow = [];
      for (let c = 0; c < this.cols; c++) {
        const tile = new Tile(r, c);
        tile.setChar(' ');
        this.gridEl.appendChild(tile.el);
        row.push(tile);
        charRow.push(' ');
      }
      this.tiles.push(row);
      this.currentGrid.push(charRow);
    }

    this.boardEl.appendChild(this.gridEl);

    // Right accent indicators
    this.rightBar = this._createAccentBar('accent-bar-right');
    this.boardEl.appendChild(this.rightBar);

    // Keyboard hint — proper <button> with aria
    const hint = document.createElement('button');
    hint.className = 'keyboard-hint';
    hint.textContent = '?';
    hint.setAttribute('aria-label', 'Show keyboard shortcuts');
    hint.setAttribute('aria-expanded', 'false');
    hint.setAttribute('aria-controls', 'shortcuts-panel');
    hint.addEventListener('click', (e) => {
      e.stopPropagation();
      const panel = this.boardEl.querySelector('.shortcuts-overlay');
      if (panel) {
        const isVisible = panel.classList.toggle('visible');
        hint.setAttribute('aria-expanded', String(isVisible));
        if (isVisible) {
          panel.focus();
        }
      }
    });
    this.boardEl.appendChild(hint);

    // Shortcuts overlay — proper dialog semantics
    const overlay = document.createElement('div');
    overlay.className = 'shortcuts-overlay';
    overlay.id = 'shortcuts-panel';
    overlay.setAttribute('role', 'dialog');
    overlay.setAttribute('aria-label', 'Keyboard shortcuts');
    overlay.setAttribute('tabindex', '-1');
    overlay.innerHTML = `
      <dl class="shortcuts-list">
        <div><dt>Next message</dt><dd><kbd>Enter</kbd></dd></div>
        <div><dt>Previous</dt><dd><kbd>←</kbd></dd></div>
        <div><dt>Fullscreen</dt><dd><kbd>F</kbd></dd></div>
        <div><dt>Mute</dt><dd><kbd>M</kbd></dd></div>
      </dl>
    `;
    // Close on Escape from within the overlay
    overlay.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        e.stopPropagation();
        overlay.classList.remove('visible');
        hint.setAttribute('aria-expanded', 'false');
        hint.focus();
      }
    });
    this.boardEl.appendChild(overlay);

    // Reference to the live announcement region
    this._announceEl = document.getElementById('sr-announce');

    containerEl.appendChild(this.boardEl);
    this._updateAccentColors();
  }

  _createAccentBar(extraClass) {
    const bar = document.createElement('div');
    bar.className = `accent-bar ${extraClass}`;
    // Just 2 small stacked squares like the original
    for (let i = 0; i < 2; i++) {
      const seg = document.createElement('div');
      seg.className = 'accent-segment';
      bar.appendChild(seg);
    }
    return bar;
  }

  _updateAccentColors() {
    const color = ACCENT_COLORS[this.accentIndex % ACCENT_COLORS.length];
    const segments = this.boardEl.querySelectorAll('.accent-segment');
    segments.forEach(seg => {
      seg.style.backgroundColor = color;
      seg.style.color = color;
    });
  }

  displayMessage(lines) {
    // Stop loading scramble on first real message
    if (this._loadingActive) {
      this.stopLoadingScramble();
    }

    if (this.isTransitioning) {
      this._pendingMessage = lines;
      return;
    }
    this._pendingMessage = null;
    this.isTransitioning = true;

    // Format lines into grid
    const newGrid = this._formatToGrid(lines);

    // Determine which tiles need to change
    let hasChanges = false;
    let pendingAnimations = 0;

    const onTileComplete = () => {
      pendingAnimations--;
      if (pendingAnimations <= 0) {
        this.isTransitioning = false;
        if (this._pendingMessage) {
          this.displayMessage(this._pendingMessage);
        }
      }
    };

    for (let r = 0; r < this.rows; r++) {
      for (let c = 0; c < this.cols; c++) {
        const newChar = newGrid[r][c];
        const oldChar = this.currentGrid[r][c];

        if (newChar !== oldChar) {
          const delay = (r * this.cols + c) * STAGGER_DELAY;
          pendingAnimations++;
          this.tiles[r][c].scrambleTo(newChar, delay, onTileComplete);
          hasChanges = true;
        }
      }
    }

    // Play the single transition audio clip once
    if (hasChanges && this.soundEngine) {
      this.soundEngine.playTransition();
    }

    // Update accent bar colors
    this.accentIndex = (this.accentIndex + 1) % ACCENT_COLORS.length;
    this._updateAccentColors();

    // Update grid state and announce to screen readers
    this.currentGrid = newGrid;
    this._announceMessage(lines);

    if (!hasChanges) {
      this.isTransitioning = false;
      if (this._pendingMessage) {
        this.displayMessage(this._pendingMessage);
      }
    }
  }

  /**
   * Loading scramble — staggered cascade of random chars + colors
   * across all tiles. Runs continuously until stopLoadingScramble() or
   * the first displayMessage() call takes over.
   */
  startLoadingScramble() {
    this._loadingActive = true;
    this._loadingTimers = [];

    const totalTiles = this.rows * this.cols;

    // Stagger each tile's start by row+col position (diagonal wave)
    for (let r = 0; r < this.rows; r++) {
      for (let c = 0; c < this.cols; c++) {
        const tile = this.tiles[r][c];
        // Diagonal cascade delay: fast wave across the board
        const diag = r + c;
        const startDelay = diag * 18 + Math.random() * 30;

        const timerId = setTimeout(() => {
          if (!this._loadingActive) return;
          this._startTileLoading(tile);
        }, startDelay);

        this._loadingTimers.push(timerId);
      }
    }
  }

  /** Animate a single tile with continuous random chars + color cycling */
  _startTileLoading(tile) {
    if (!this._loadingActive) return;

    // Override gradient so colors show
    tile.frontEl.style.backgroundImage = 'none';

    let count = 0;
    const interval = 60 + Math.random() * 30; // Fast cycling

    tile._loadingTimer = setInterval(() => {
      if (!this._loadingActive) {
        clearInterval(tile._loadingTimer);
        tile._loadingTimer = null;
        return;
      }

      const randChar = CHARSET[Math.floor(Math.random() * CHARSET.length)];
      tile.frontSpan.textContent = randChar === ' ' ? '' : randChar;

      const color = SCRAMBLE_COLORS[count % SCRAMBLE_COLORS.length];
      tile.frontEl.style.backgroundColor = color;
      tile.frontSpan.style.color = '';
      count++;
    }, interval);
  }

  /** Stop the loading scramble and clean up all tiles */
  stopLoadingScramble() {
    this._loadingActive = false;

    // Clear start delays
    if (this._loadingTimers) {
      this._loadingTimers.forEach(id => clearTimeout(id));
      this._loadingTimers = null;
    }

    // Clear per-tile intervals and reset styles
    for (let r = 0; r < this.rows; r++) {
      for (let c = 0; c < this.cols; c++) {
        const tile = this.tiles[r][c];
        if (tile._loadingTimer) {
          clearInterval(tile._loadingTimer);
          tile._loadingTimer = null;
        }
        // Reset to blank — displayMessage will set the real chars
        tile.frontEl.style.backgroundColor = '';
        tile.frontEl.style.backgroundImage = '';
        tile.frontSpan.style.color = '';
        tile.frontSpan.textContent = '';
        tile.currentChar = ' ';
      }
    }
  }

  _formatToGrid(lines) {
    const grid = [];
    for (let r = 0; r < this.rows; r++) {
      const line = (lines[r] || '').toUpperCase();
      const padTotal = this.cols - line.length;
      const padLeft = Math.max(0, Math.floor(padTotal / 2));
      const padded = ' '.repeat(padLeft) + line + ' '.repeat(Math.max(0, this.cols - padLeft - line.length));
      grid.push(padded.split(''));
    }
    return grid;
  }

  /** Announce the current message text to screen readers via aria-live region */
  _announceMessage(lines) {
    if (!this._announceEl) return;
    const text = lines.filter(l => l && l.trim()).join(' — ');
    if (text) {
      this._announceEl.textContent = text;
    }
  }
}
