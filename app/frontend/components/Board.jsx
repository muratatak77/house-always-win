import React from "react";
import Cell from "./Cell";

function Board({ symbols }) {
  return (
    <div className="board">
      {symbols.map((s, i) => (
        <Cell key={i} symbol={s} />
      ))}
    </div>
  );
}

export default Board;