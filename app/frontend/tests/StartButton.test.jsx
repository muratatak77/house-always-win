import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import StartButton from '../components/StartButton';
import * as api from '../api/gameSessions';

test('StartButton should create session and call callback', async () => {
  // Mock the API response
  api.createSession = jest.fn().mockResolvedValue({
    id: 1,
    credits: 10,
    status: 'open'
  });

  const onSessionCreated = jest.fn();

  render(<StartButton onSessionCreated={onSessionCreated} />);

  // Click the start button
  fireEvent.click(screen.getByText('Start Game'));

  // Check if API was called
  expect(api.createSession).toHaveBeenCalledTimes(1);

  // Wait for callback to be called with session data
  await waitFor(() => {
    expect(onSessionCreated).toHaveBeenCalledWith({
      id: 1,
      credits: 10,
      status: 'open'
    });
  });
});