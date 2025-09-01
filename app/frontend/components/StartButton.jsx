import React, { useState } from "react";
import { createSession } from "../api/gameSessions";

// Button to start a new game session
// If there's already an open session, it will return that one
function StartButton({ onSessionCreated }) {
  const [loading, setLoading] = useState(false);

  const handleClick = async () => {
    setLoading(true);
    try {
      const sessionData = await createSession();

      // Pass the session data back to parent component
      if (onSessionCreated) {
        onSessionCreated(sessionData);
      }

    } catch (error) {
      console.error("Failed to start game session", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <button onClick={handleClick} disabled={loading}>
      {loading ? "Loading..." : "Start Game"}
    </button>
  );
}

export default StartButton;