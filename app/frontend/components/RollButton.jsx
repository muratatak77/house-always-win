import React, { useState } from 'react';
import { rollOnce } from '../api/rolls';

function RollButton({ session, onRollResult }) {
  const [loading, setLoading] = useState(false);

  const handleRoll = async () => {
    // Don't do anything if no session or already rolling
    if (!session?.id || loading) return;

    setLoading(true);

    try {
      // Show spinning state immediately
      onRollResult({ credits: session.credits, symbols: ["X", "X", "X"] });

      const result = await rollOnce(session.id);

      if (typeof result.credits === 'number') {
        onRollResult({ credits: result.credits });
      }

      // Reveal symbols with delays for animation effect
      const [first, second, third] = result.symbols;

      setTimeout(() => {
        onRollResult({ symbols: [first, "X", "X"] });
      }, 1000);

      setTimeout(() => {
        onRollResult({ symbols: [first, second, "X"] });
      }, 2000);

      setTimeout(() => {
        onRollResult({ symbols: [first, second, third] });
        setLoading(false);
      }, 3000);

    } catch (error) {
      console.error("Roll operation failed", error);
      setLoading(false);
    }
  };

  return (
    <button onClick={handleRoll} disabled={!session || loading}>
      {loading ? "Rolling..." : "Roll"}
    </button>
  );
}

export default RollButton;