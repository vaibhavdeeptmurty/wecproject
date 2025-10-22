# NativeChatApp

A real-time chat application built using **React Native / Flutter** with **Firebase** backend services. This app supports user authentication, real-time messaging, presence indicators, & read receipts.
M A D E    B Y   V A I B H A V    W I T H   🩷 
---

## Table of Contents

- [Overview](#overview)  
- [Features](#features)   
- [Tech Stack](#tech-stack)    
- [Dependencies](#dependencies)  
- [Notes](#notes)  
- [Mentors](#mentors)  

---

## Overview

NativeChatApp is a cross-platform mobile application enabling real-time one-on-one chat using Firebase services. The app offers a seamless chat experience with features such as:

- Firebase Authentication-based user login/signup  
- User profile management (name, photo, status)  
- Real-time messaging with persistent chat history  
- Online/offline presence and last seen timestamps  
- Message status indicators (sent, delivered, read)   
- No custom backend required — fully powered by Firebase

---

## Features

1. **User Authentication**  
   - Sign up and login via Firebase Authentication using Google 
   - User profile updates (display name, photo, status)  
   - Firebase token/session management  

2. **Real-Time Messaging**  
   - One-to-one chat conversations  
   - Real-time message sending and receiving using Firestore  
   - Persistent message history  

3. **Online/Offline Status**  
   - Presence detection using Firebase Realtime Database  
   - Show last seen for offline users  

4. **Read Receipts**  
   - Sent: Message timestamp shown (no tick)  
   - Read: Double blue tick with timestamp  


---

## Tech Stack

- **Frontend:**  Flutter  
- **Backend:** Firebase (Authentication, Firestore, Cloudinary Storage)  
 

---

## Dependencies
###    for Firebase
  -firebase_core: ^4.2.0
###  for Firebase Auth
  firebase_auth: ^6.1.1
### for Google sign-in
-  using old version because I was unable to resolve the error GoogleSignInException(code GoogleSignInExceptionCode.clientConfigurationError, serverClientId must be provided on Android, null)
- google_sign_in: ^5.4.2
###  cloud firestore database
  cloud_firestore: ^6.0.3
### for user profile picture
-  path_provider: ^2.1.5
-  cached_network_image: ^3.4.1
###  to pick images from phone
-  image_picker: ^1.2.0

### for showing emojis in chat
-  emoji_picker_flutter: ^4.3.0

###  for storing images in the gallery
-  gallery_saver_plus: ^3.2.9
### for icons
-  cupertino_icons: ^1.0.8
###  to store profile picture
-  cloudinary_flutter: ^1.3.0
-  cloudinary_url_gen: ^1.8.0

## Notes
  -Firestore Storage needed me to go premium, which is why I am using Cloudinary for storing images.
  -I was unable to resolve the error while using Polylines, which is why I have not added the Live location feature. On pub.dev, the documentation is outdated and no longer works for newer versions. If I use the old version, I would need to reduce the versions of many dependencies and change the code accordingly.
 

## Mentors
  -[Kushagra Tiwari ](https://github.com/Kushagra1122/)(+91 8318661731)
  -[Nishant AS](https://github.com/NishantAS/)(+91 6360219728)
