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


// listen on port 3000
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});