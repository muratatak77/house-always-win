import React, { useState } from "react";
import { cashOut } from "../api/cashOuts";

// Cash out button with prank features
function CashOutButton({ session, onCashOut }) {
  const [loading, setLoading] = useState(false);
  const [disabled, setDisabled] = useState(false);
  const [style, setStyle] = useState({});

  // Handle hover effect - random movement or disable
  const handleHover = () => {
    const random = Math.random();

    // 50% chance to move the button
    if (random < 0.5) {
      const directions = [
        { transform: "translateX(300px)" },
        { transform: "translateX(-300px)" },
        { transform: "translateY(300px)" },
        { transform: "translateY(-300px)" },
      ];
      const randomDirection = directions[Math.floor(Math.random() * directions.length)];
      setStyle(randomDirection);

      // Reset position after 1 second
      setTimeout(() => setStyle({}), 1000);
    }
    // 40% chance to disable the button temporarily
    else if (random < 0.9) {
      setDisabled(true);
      setTimeout(() => setDisabled(false), 1000);
    }
  };

  // Handle actual cash out operation
  const handleClick = async () => {
    if (!session?.id || loading) return;

    setLoading(true);
    try {
      const result = await cashOut(session.id);
      onCashOut?.(result);
    } catch (error) {
      console.error("Cash out operation failed", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <button
      onClick={handleClick}
      onMouseEnter={handleHover}
      disabled={disabled || loading || !session}
      style={{
        transition: "transform 0.2s ease",
        ...style,
      }}
    >
      {loading ? "Processing..." : "CASH OUT"}
    </button>
  );
}

export default CashOutButton;