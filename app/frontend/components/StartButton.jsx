import React, { useState } from "react";
import { createSession } from "../api/gameSessions";

// starts a new session (or returns existing open one).
function StartButton({ onSessionCreated }) {
  const [loading, setLoading] = useState(false);

  const handleClick = async () => {
    setLoading(true);
    try {
      const data = await createSession();
      onSessionCreated?.(data);
    } catch (err) {
      console.error("start failed", err);
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