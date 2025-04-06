importScripts(
  "https://www.gstatic.com/firebasejs/10.8.0/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/10.8.0/firebase-messaging-compat.js"
);

const firebaseConfig = {
  apiKey: "AIzaSyBv3BrLnfzW3SacAi5DfKLIPvX4Vk0bmUQ",
  authDomain: "compete-6b5e3.firebaseapp.com",
  projectId: "compete-6b5e3",
  storageBucket: "compete-6b5e3.firebasestorage.app",
  messagingSenderId: "923634628182",
  appId: "1:923634628182:web:116acf2af62fb11d6a6df7",
};
firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function (payload) {
  console.log(
    "[firebase-messaging-sw.js] Received background message ",
    payload
  );
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
