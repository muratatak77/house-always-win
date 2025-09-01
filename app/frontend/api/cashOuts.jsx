import client from "./axios";

// POST /api/v1/cash_outs
export async function cashOut(gameSessionId) {
  const res = await client.post("/cash_outs", { game_session_id: gameSessionId });
  return res.data;
}