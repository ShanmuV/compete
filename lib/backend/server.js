const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const UserModel = require("./models/UserModel");
const EventModel = require("./models/EventModel");
const RegistrationModel = require("./models/RegistrationModel");

const app = express();

app.use(cors());
app.use(express.json());

mongoose
  .connect(
    "mongodb+srv://shanmus063:VEevhX66okV1jPTg@compete.d5dzcfu.mongodb.net/Compete"
  )
  .then(() => {
    console.log("MongoDB logged in successfully");
  })
  .catch((e) => {
    console.log(e.message);
  });

app.post("/login", async (req, res) => {
  let user = await UserModel.find({ username: req.body.username });
  if (!user) {
    res.status(404);
    console.log(`User ${req.body.username} Not found`);
  } else {
    if (user.password === req.body.password) {
      res.status(200);
      console.log(`User ${req.body.username} successfully logged in`);
    }
  }
});

app.post("/signup", async (req, res) => {
  let body = req.body;
  let existingUser = await UserModel.find({ username: body.username });
  if (existingUser) {
    res.status(400).json({ message: `User ${body.username} already exists` });
    console.log(`User ${body.username} already exists`);
    return;
  }
  let newUser = UserModel({ username: body.username, password: body.password });
  await newUser.save();
  res.status(200).json({
    message: `User ${body.username} has been successfully registered`,
  });
});

app.post("/event", async (req, res) => {
  let body = req.body;
  console.log(body);
  let event = EventModel({
    eventName: body.eventName,
    eventDepartment: body.eventDepartment,
    eventOrganizer: body.eventOrganizer,
    eventDate: body.eventDate,
    expireAt: body.eventDate,
  });
  await event.save();
  res.send(200);
});

app.post("/register", async (req, res) => {
  let body = req.body;
  const newRegistration = new RegistrationModel(body);

  try {
    newRegistration.save();
    console.log("Registered");
    res.status(200);
    res.json({ message: "Registered Successfully" });
  } catch (e) {
    console.log("Error occured: " + e.message);
    res.status(500);
  }
});

app.get("/events", async (req, res) => {
  let events = await EventModel.find();
  res.json(events);
});

app.get("/users", async (req, res) => {
  let users = await UserModel.find();
  res.json(users);
});

app.listen(5000, () =>
  console.log("Server running on https://localhost:5000/")
);
