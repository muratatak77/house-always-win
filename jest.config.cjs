module.exports = {
  testEnvironment: "jsdom",
  transform: { "^.+\\.jsx?$": "babel-jest" },
  moduleFileExtensions: ["js", "jsx"],
  roots: ["<rootDir>/app/frontend"],
  setupFilesAfterEnv: ["<rootDir>/jest.setup.js"],
  modulePathIgnorePatterns: ["<rootDir>/node_modules/source-map-support"],
};