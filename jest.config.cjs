module.exports = {
  testEnvironment: "jsdom",
  transform: { "^.+\\.jsx?$": "babel-jest" },
  moduleFileExtensions: ["js", "jsx"],
  roots: ["<rootDir>/app/frontend"]
};
