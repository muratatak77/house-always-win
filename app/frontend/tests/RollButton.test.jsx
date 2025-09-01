import React from 'react';
import { render, screen, fireEvent, waitFor, act } from '@testing-library/react';
import RollButton from '../components/RollButton';
import * as rolls from '../api/rolls';

// Fake timers for animation testing
jest.useFakeTimers();

test('RollButton should show progressive symbol reveal', async () => {
  // Mock the roll API
  rolls.rollOnce = jest.fn().mockResolvedValue({
    symbols: ['C', 'L', 'O'],
    credits: 9
  });

  const onResult = jest.fn();
  const session = { id: 1, credits: 10 };

  render(<RollButton session={session} onRollResult={onResult} />);

  // Click the roll button
  fireEvent.click(screen.getByRole('button', { name: 'Roll' }));

  // Check credits update
  await waitFor(() => {
    expect(onResult).toHaveBeenCalledWith(expect.objectContaining({ credits: 9 }));
  });

  // Check symbol reveal sequence
  act(() => jest.advanceTimersByTime(1000));
  expect(onResult).toHaveBeenCalledWith({ symbols: ['C', 'X', 'X'] });

  act(() => jest.advanceTimersByTime(1000));
  expect(onResult).toHaveBeenCalledWith({ symbols: ['C', 'L', 'X'] });

  act(() => jest.advanceTimersByTime(1000));
  expect(onResult).toHaveBeenCalledWith({ symbols: ['C', 'L', 'O'] });

  // Verify API was called correctly
  expect(rolls.rollOnce).toHaveBeenCalledTimes(1);
  expect(rolls.rollOnce).toHaveBeenCalledWith(1);
});