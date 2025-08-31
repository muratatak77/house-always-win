import axios from "axios";

const client = axios.create({
  baseURL: "/api/v1",
  withCredentials: true,
  headers: {
    "X-Requested-With": "XMLHttpRequest",
    "Content-Type": "application/json",
  },
});

// attach CSRF token from rails meta 
const token = document.querySelector("meta[name='csrf-token']");
if (token) {
  client.defaults.headers.common["X-CSRF-Token"] = token.content;
}

export default client;
