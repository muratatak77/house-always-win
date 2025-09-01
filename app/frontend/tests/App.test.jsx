import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom';
import App from '../components/App';
import * as api from '../api/gameSessions';
import * as rolls from '../api/rolls';

// Let's control time for tests
jest.useFakeTimers();

describe('App component tests', () => {
  // Clean up after each test
  afterEach(() => {
    jest.clearAllMocks();
    jest.clearAllTimers();
  });

  test('should show credits after starting game', async () => {
    // Mock the API
    api.createSession = jest.fn().mockResolvedValue({ id: 1, credits: 10, status: 'open' });

    render(<App />);

    // Click the start button
    fireEvent.click(screen.getByText('Start Game'));

    // Wait for credits to appear
    await waitFor(() => {
      expect(screen.getByText('Credits: 10')).toBeInTheDocument();
    });
  });

  test('should update credits after roll', async () => {
    // Set up the necessary mocks
    api.createSession = jest.fn().mockResolvedValue({ id: 1, credits: 10, status: 'open' });
    rolls.rollOnce = jest.fn().mockResolvedValue({ symbols: ['W', 'W', 'W'], credits: 50 });

    render(<App />);

    // First start the game
    fireEvent.click(screen.getByText('Start Game'));
    await screen.findByText('Credits: 10');

    // Perform a roll
    fireEvent.click(screen.getByText('Roll'));

    // Wait for animation to finish
    jest.advanceTimersByTime(3000);

    // Check if credits were updated
    expect(await screen.findByText('Credits: 50')).toBeInTheDocument();
  });
});