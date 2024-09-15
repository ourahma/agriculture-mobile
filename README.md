# 🌿 Smart Agricultural Mobile Application

This repository contains the code for a smart agricultural mobile application developed using Flutter and Dart. The app allows users to monitor environmental data (temperature, humidity, and rain) in real-time, track specific terrain data, and get recommendations for plants suited to specific weather conditions.

The app is integrated with an ESP32 microcontroller and multiple sensors (humidity, temperature, and rain). It uses MQTT for communication and stores data in MongoDB.

## 🧑‍💻 Features

- **User Authentication**: Allows users to register and log in to the app.
- **Real-time Weather Monitoring**: Provides temperature, humidity, and rain data based on the user’s location.
- **Data History**: Users can view historical data of environmental conditions.
- **Terrain Management**: Users can track data from different terrains and add new terrains.
- **Plant Recommendations**: Based on current environmental conditions, users can get recommendations for suitable plants.
  
## 👤 Actors in the System

- **User**: Can register, log in, and interact with the system by checking weather data, terrain information, and plant recommendations.

## ⚙️ Technologies Used

| Technology      | Description                                            | Logo  |
|-----------------|--------------------------------------------------------|-------|
| **Flutter**     | Cross-platform mobile development framework.           | ![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white) |
| **Dart**        | Programming language used for building the mobile app. | ![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white) |
| **ESP32**       | Microcontroller for handling sensor data.              | ![ESP32](https://img.shields.io/badge/ESP32-ESP--32--WROOM--32D?logoColor=white) |
| **Arduino**     | Platform used to code ESP32 in C++.                    | ![Arduino](https://img.shields.io/badge/Arduino-00979D?logo=arduino&logoColor=white) |
| **MQTT**        | Protocol used for sending data from ESP32 to server.   | ![MQTT](https://img.shields.io/badge/MQTT-Brokers?logo=mqtt&logoColor=white) |
| **MongoDB**     | NoSQL database for storing sensor data.                | ![MongoDB](https://img.shields.io/badge/MongoDB-47A248?logo=mongodb&logoColor=white) |

## 📦 MQTT & Database

- **MQTT Broker**: Ensure the MQTT broker is set up to handle data transmission between the ESP32 and the server.
- **MongoDB**: Configure MongoDB to store the sensor data. You can host MongoDB locally or use a cloud solution like MongoDB Atlas.



## 🚀 Future Improvements

- Integration with weather APIs for more accurate data.
- Improved UI for better user experience.
- Notifications for extreme weather conditions.

## 💻 Contributors

- **OURAHMA Maroua** – [GitHub](https://github.com/ourahma)
- **ZENNOURI Nassima** - [GitHub](https://github.com/NassimaZENNOURI)
