import client from "./axios";

// create or find by email
export async function upsertPlayerByEmail(email) {
  const res = await client.post("/players", { email });
  return res.data;
}
