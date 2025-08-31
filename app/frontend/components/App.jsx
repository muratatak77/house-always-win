import React, { useState } from "react";
import Board from "./Board";
import StartButton from "./StartButton";
import RollButton from "./RollButton";
import CashOutButton from "./CashOutButton";

export default function App() {
  const [session, setSession] = useState(null);
  const [credits, setCredits] = useState(0); // UI shows current session credits
  const [symbols, setSymbols] = useState(["C", "L", "O"]);

  return (
    <div>
      <h1>Slot Machine</h1>
      <h3>Credits: {credits}</h3>

      <div className="buttons">
        <StartButton
          onSessionCreated={(data) => {
            setSession(data);
            setCredits(data.credits);
            setSymbols(["C", "L", "O"]); // reset symbols
          }}
        />
        <RollButton session={session} onRollResult={setCredits} />
      </div>

      <Board symbols={["C", "L", "O"]} />

      <div className="buttons">
        <CashOutButton session={session} onCashOut={setCredits} />
      </div>
    </div>
  );
}
