const mongoose = require("mongoose");

const eventScema = new mongoose.Schema({
  eventName: { type: String, required: true },
  eventDepartment: { type: String, required: true },
  eventOrganizer: { type: String, required: true },
  eventDate: { type: Date, required: true },
  expiresAt: { type: Date, index: { expires: 0 } },
});

const EventModel = mongoose.model("event", eventScema);

module.exports = EventModel;
