const request = require("supertest");
const express = require("express");
const helmet = require("helmet");
const cors = require("cors");
const rateLimit = require("express-rate-limit");
const dotenv = require("dotenv");

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

// Security middleware
app.use(helmet());
app.use(cors({ origin: process.env.ALLOWED_ORIGIN || "*" }));

// Rate Limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 2, // Set a low limit for testing
  message: "Too many requests from this IP, please try again later",
});
app.use(limiter);

// Routes
app.get("/", (req, res) => {
  res.send("Hello Secure World!");
});

// Tests
describe("Express Server Security Tests", () => {
  it("should return 'Hello Secure World!'", async () => {
    const response = await request(app).get("/");
    expect(response.status).toBe(200);
    expect(response.text).toBe("Hello Secure World!");
  });

  it("should have security headers set by Helmet", async () => {
    const response = await request(app).get("/");
    expect(response.headers["x-dns-prefetch-control"]).toBe("off");
    expect(response.headers["x-frame-options"]).toBe("SAMEORIGIN");
    expect(response.headers["x-content-type-options"]).toBe("nosniff");
  });

  it("should include CORS headers", async () => {
    const response = await request(app).get("/");
    expect(response.headers["access-control-allow-origin"]).toBe("*");
  });

  it("should enforce rate limiting", async () => {
    await request(app).get("/");
    await request(app).get("/");

    const response = await request(app).get("/");
    expect(response.status).toBe(429); // Too Many Requests
    expect(response.text).toContain("Too many requests");
  });
});
