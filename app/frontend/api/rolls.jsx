import client from "./axios";

// POST /api/v1/rolls
export async function rollOnce(gameSessionId) {
  const res = await client.post("/rolls", {
    game_session_id: gameSessionId,
  });
  return res.data;
}
