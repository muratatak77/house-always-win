import React from "react";
import Board from "./Board";
import StartButton from "./StartButton";
import RollButton from "./RollButton";
import CashOutButton from "./CashOutButton";

export default function App() {
  return (
    <div>
      <h1>Slot Machine</h1>
      <h3>Credits: 10</h3>

      <div className="buttons">
        <StartButton />
        <RollButton />
      </div>

      <Board symbols={["C", "L", "O"]} />

      <div className="buttons">
        <CashOutButton />
      </div>
    </div>
  );
}
