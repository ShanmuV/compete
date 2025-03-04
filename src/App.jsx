import React from "react";
import { useState } from "react";
import "./App.css";
import EventItem from "./Components/EventItem";

function App() {
  // let [login, setLoginForm] = useState(true);
  // const changeForms = () => {
  //   setLoginForm(!login);
  // };
  // return login ? (
  //   <div className="login-page-container">
  //     <div className="form-box">
  //       <h1 className="form-title">Login</h1>
  //       <input
  //         type="email"
  //         name="email"
  //         className="input-field"
  //         placeholder="Email"
  //       />
  //       <input
  //         type="password"
  //         name="pass"
  //         className="input-field"
  //         placeholder="Password"
  //       />
  //       <button className="submit-button">Log In</button>
  //       <h6 className="change-form-text">
  //         Don't have an Account?
  //         <span className="change-form-link" onClick={changeForms}>
  //           Sign Up
  //         </span>
  //       </h6>
  //     </div>
  //   </div>
  // ) : (
  //   <div className="login-page-container">
  //     <div className="form-box">
  //       <h1 className="form-title">Sign Up</h1>
  //       <input
  //         type="email"
  //         name="email"
  //         className="input-field"
  //         placeholder="Email"
  //       />
  //       <input
  //         type="password"
  //         name="pass"
  //         className="input-field"
  //         placeholder="Password"
  //       />
  //       <input
  //         type="password"
  //         name="conf-pass"
  //         className="input-field"
  //         placeholder="Confirm Password"
  //       />
  //       <button className="submit-button">Sign Up</button>
  //       <h6 className="change-form-text">
  //         Already have an Account?
  //         <span className="change-form-link" onClick={changeForms}>
  //           Log In
  //         </span>
  //       </h6>
  //     </div>
  //   </div>
  // );

  /* Cards and shit */
  return (
    <div className="main-page-container">
      <div className="app-bar">
        <h1 style={{ textAlign: "center", margin: "20px" }}>
          PSNA Event Management System
        </h1>
      </div>
      <div className="main-page-content">
        <div className="calendar-container">
          <h2 style={{ textAlign: "center", marginTop: "170px" }}>
            This is where the calendar goes
          </h2>
        </div>
        <div className="events-container">
          <EventItem
            eventTitle="Symposium - UTSAV"
            eventDepartment="Computer Science and Engineering"
            eventOrganizer="Ms. Santhana Prabha"
          ></EventItem>
          <EventItem
            eventTitle="Women's Day Competitions"
            eventDepartment="Computer Science and Engineering"
            eventOrganizer="Ms. Hemalatha"
          ></EventItem>
          <EventItem
            eventTitle="Poster Designing Competition"
            eventDepartment="Department of Chemistry"
            eventOrganizer="Ms. Gnanasangeetha"
          ></EventItem>
        </div>
      </div>
    </div>
  );
}

export default App;
