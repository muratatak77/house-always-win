import React from "react";
import { render, screen, fireEvent, act } from "@testing-library/react";
import CashOutButton from "../components/CashOutButton";
import { cashOut } from "../api/cashOuts";

// mock the API module
jest.mock("../api/cashOuts");

describe("CashOutButton Component", () => {
  const mockSession = { id: "session-123" };
  let mockOnCashOut;

  beforeEach(() => {
    mockOnCashOut = jest.fn();
    jest.clearAllMocks();
    jest.useFakeTimers(); // Use fake timers for setTimeout tests
  });

  afterEach(() => {
    jest.runOnlyPendingTimers();
    jest.useRealTimers();
  });

  it("should render the cash out button with correct text", () => {
    render(<CashOutButton session={mockSession} />);

    const button = screen.getByRole("button", { name: /cash out/i });
    expect(button).toBeInTheDocument();
    expect(button).toBeEnabled();
  });

  it("should disable the button when no session is provided", () => {
    render(<CashOutButton session={null} />);

    const button = screen.getByRole("button");
    expect(button).toBeDisabled();
  });

  it("should call the cashOut API and callback when clicked", async () => {
    const apiResponse = { success: true, amount: 150 };
    cashOut.mockResolvedValue(apiResponse);

    render(<CashOutButton session={mockSession} onCashOut={mockOnCashOut} />);

    fireEvent.click(screen.getByRole("button", { name: /cash out/i }));

    // Verify API was called with correct session ID
    expect(cashOut).toHaveBeenCalledWith("session-123");

    // Wait for promise to resolve and verify callback
    await act(async () => { });
    expect(mockOnCashOut).toHaveBeenCalledWith(apiResponse);
  });

  it("should display loading text during API request", () => {
    // Create a promise that doesn't resolve to test loading state
    cashOut.mockImplementation(() => new Promise(() => { }));

    render(<CashOutButton session={mockSession} />);

    fireEvent.click(screen.getByRole("button", { name: /cash out/i }));

    expect(screen.getByText("Processing...")).toBeInTheDocument();
  });

  it("should move button position on hover with 50% probability", () => {
    // Mock random to always trigger movement
    jest.spyOn(Math, "random").mockReturnValue(0.3);
    jest.spyOn(Math, "floor").mockReturnValue(0); // translateX direction

    render(<CashOutButton session={mockSession} />);
    const button = screen.getByRole("button");

    fireEvent.mouseEnter(button);

    expect(button).toHaveStyle("transform: translateX(300px)");

    act(() => jest.advanceTimersByTime(1000));
    expect(button).not.toHaveStyle("transform: translateX(300px)");
  });

  it("should temporarily disable button on hover with 40% probability", () => {
    // Mock random to always trigger disable
    jest.spyOn(Math, "random").mockReturnValue(0.7);

    render(<CashOutButton session={mockSession} />);
    const button = screen.getByRole("button");

    fireEvent.mouseEnter(button);

    expect(button).toBeDisabled();

    act(() => jest.advanceTimersByTime(1000));
    expect(button).not.toBeDisabled();
  });

  it("should handle API errors gracefully", async () => {
    const consoleErrorSpy = jest.spyOn(console, "error").mockImplementation();
    const error = new Error("API unavailable");
    cashOut.mockRejectedValue(error);

    render(<CashOutButton session={mockSession} onCashOut={mockOnCashOut} />);

    const button = screen.getByText("CASH OUT");
    fireEvent.click(button);

    await act(async () => { });

    expect(consoleErrorSpy).toHaveBeenCalledWith("Cash out operation failed", error);
    consoleErrorSpy.mockRestore();
  });
});