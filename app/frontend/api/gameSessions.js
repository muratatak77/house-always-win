import client from "./axios";

export async function createSession() {
  const res = await client.post("/game_sessions");
  return res.data;
}

export async function getSession(id) {
  const res = await client.get(`/game_sessions/${id}`);
  return res.data;
}
