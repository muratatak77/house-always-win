import React from "react";
import { render, screen } from "@testing-library/react";
import "@testing-library/jest-dom";
import App from "../components/App";

test("APP UI", () => {
  render(<App />);

  expect(screen.getByText(/Slot Machine/i)).toBeInTheDocument();
  expect(screen.getByText(/Credits: 10/i)).toBeInTheDocument();
  expect(screen.getByText(/Start Game/i)).toBeInTheDocument();
  expect(screen.getByText(/Roll/i)).toBeInTheDocument();
  expect(screen.getByText(/Cash Out/i)).toBeInTheDocument();

  // 3 cells
  const cells = screen.getAllByText(/^[CLO]$/);
  expect(cells).toHaveLength(3);
});
