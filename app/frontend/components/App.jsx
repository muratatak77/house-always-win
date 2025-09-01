import React, { useState } from "react";
import Board from "./Board";
import StartButton from "./StartButton";
import RollButton from "./RollButton";
import CashOutButton from "./CashOutButton";

// Main slot machine app component
// Manages game session state and credit display
export default function App() {
  const [session, setSession] = useState(null);
  const [credits, setCredits] = useState(0);
  const [symbols, setSymbols] = useState(["C", "L", "O"]);

  return (
    <div>
      <h1>Slot Machine</h1>
      <h3>Credits: {credits}</h3>

      <div className="buttons">
        {/* Button to start new game session */}
        <StartButton
          onSessionCreated={(sessionData) => {
            setSession(sessionData);
            setCredits(sessionData.credits);
            setSymbols(["C", "L", "O"]);
          }}
        />

        {/* Button to roll - only enabled when session exists */}
        <RollButton
          session={session}
          onRollResult={(resultData) => {
            if (resultData.credits !== undefined) {
              setCredits(resultData.credits);
            }
            if (resultData.symbols) {
              setSymbols(resultData.symbols);
            }
          }}
        />
      </div>

      <Board symbols={symbols} />

      <div className="buttons">
        <CashOutButton
          session={session}
          onCashOut={(res) => {
            setCredits(0);
          }}
        />
      </div>
    </div>
  );
}