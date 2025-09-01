import '@testing-library/jest-dom';
// prevent source-map-support from hijacking stack traces in Jest
try {
  require("source-map-support").install({ handleUncaughtExceptions: false });
} catch (e) {
  // ignore
}