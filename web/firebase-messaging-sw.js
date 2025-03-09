importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.1/firebase-messaging.js');

firebase.initializeApp({
  apiKey: "AIzaSyA6B5vFPd2SvIs7MfbTGFuzzwtZdAda3Bo",
  authDomain: "simple-app-notify.firebaseapp.com",
  projectId: "simple-app-notify",
  storageBucket: "simple-app-notify.appspot.com",
  messagingSenderId: "780986996030",
  appId: "1:780986996030:web:9fa10ba7d3c0e1203e486f"
});

const messaging = firebase.messaging();

// ✅ Handle background notifications
messaging.onBackgroundMessage((payload) => {
  console.log("📢 Background Message:", payload);
  self.registration.showNotification(payload.notification.title, {
    body: payload.notification.body,
    icon: "/favicon.png"
  });
});