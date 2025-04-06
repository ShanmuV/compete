const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const UserModel = require("./models/UserModel");
const EventModel = require("./models/EventModel");
const RegistrationModel = require("./models/RegistrationModel");

var token;
var admin = require("firebase-admin");

var serviceAccount = require("./env/compete-6b5e3-firebase-adminsdk-fbsvc-f64dd8a52a.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

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

// Gettinb FCM Token from front end
app.post("/receive-token", (req, res) => {
  token = req.body.token;
});

app.post("/login", async (req, res) => {
  let user = await UserModel.findOne({ username: req.body.username });
  if (!user) {
    res.status(404);
    console.log(`User ${req.body.username} Not found`);
  } else {
    if (user.password === req.body.password) {
      res.status(200);
      res.json({ message: "Logged in" });
      console.log(`User ${req.body.username} successfully logged in`);
    }
  }
});

app.post("/signup", async (req, res) => {
  let body = req.body;
  let existingUser = await UserModel.findOne({ username: body.username });
  console.log(existingUser);
  if (existingUser != null) {
    res.status(400).json({
      message: `User ${body.username} already exists under the name ${existingUser}`,
    });
    console.log(
      `User ${body.username} already exists under the name ${existingUser}`
    );
    return;
  }
  let newUser = UserModel({ username: body.username, password: body.password });
  await newUser.save();
  res.status(200).json({
    message: `User ${body.username} has been successfully registered`,
  });
});

app.post("/event", async (req, res) => {
  try {
    let body = req.body;
    console.log(body);
    let event = EventModel({
      eventName: body.eventName,
      eventDepartment: body.eventDepartment,
      eventOrganizer: body.eventOrganizer,
      eventDescription: body.eventDescription,
      eventDate: new Date(body.eventDate),
      expiresAt: new Date(body.expiresAt),
    });
    await event.save();
    res.status(200).json({ message: "Event Created." });
    if (token != null) {
      const response = await admin.messaging().send({
        token,
        notification: {
          title: `New Event from ${body.eventDepartment}!`,
          body: `${body.eventOrganizer} just announced the event ${body.eventName}`,
        },
      });
      if (response) {
        console.log("Event published!", response);
      } else {
        console.log("\nSome Error Occured while publishing event!");
      }
    }
  } catch (e) {
    console.log(e.message);
  }
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

app.get("/student-list/:eventId", async (req, res) => {
  try {
    let students = await RegistrationModel.find({
      eventID: req.params.eventId,
    });
    res.status(200);
    console.log("Sent Data: " + students + "\n\n");
    res.json(students);
  } catch (e) {
    res.status(500);
    console.log(e.message);
    res.json({ message: e.message });
  }
});

app.listen(5000, () =>
  console.log("Server running on https://localhost:5000/")
);
