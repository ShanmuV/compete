import React from "react";
import "./EventItem.css";

function EventItem({ eventTitle, eventDepartment, eventOrganizer }) {
  return (
    <div className="event-item-container">
      <h2 className="event-title">{eventTitle}</h2>
      <h4 className="event-department">{eventDepartment}</h4>
      <h6 className="event-organizer">{eventOrganizer}</h6>
      <button className="event-register-button">Register</button>
    </div>
  );
}

export default EventItem;
