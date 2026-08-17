// import dotenv
const dotenv = require("dotenv");
dotenv.config();

// import express
const express = require("express");
const app = express();

// static files
app.use(express.static("public"));

// Temp in-memory data
const vehicles = [
  {
    id: 1,
    registration: "AB23 CDE",
    make: "Hyundai",
    model: "Tucson",
    price: 13995,
    status: "Advertised"
  }
];

// route to get vehicles
app.get("/api/vehicles", (req, res) => {
  res.json(vehicles);
});

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "ok"
  });
});

const PORT = process.env.PORT || 3000;
const APP_NAME = process.env.APP_NAME || "EN Automotive";
const ENVIRONMENT = process.env.ENVIRONMENT || "development";

app.get("/info", (req, res) => {
  res.status(200).json({
    app: APP_NAME,
    environment: ENVIRONMENT
  });
});

app.get("/api/secret-check", (req, res) => {
  const suppliedKey = req.headers["x-api-key"];

  if (!process.env.API_KEY) {
    return res.status(500).json({
      error: "API key is not configured"
    });
  }

  if (suppliedKey !== process.env.API_KEY) {
    return res.status(401).json({
      error: "Unauthorized"
    });
  }

  res.status(200).json({
    authenticated: true
  });
});



// Listen on configured port
app.listen(PORT, () => {
  console.log(
    `${APP_NAME} is running on port ${PORT} in ${ENVIRONMENT}`
  );
});