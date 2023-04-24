#include <Arduino.h>
#include <WiFi.h>
#include <PubSubClient.h>
#include <Wire.h>
#include "ArduinoJson.h"
#include "DHT.h"
#define DHT11PIN 26
#define rainAnalog 4
const char *SSID = "WIN-EU1CBK63PFV 3466";
const char *PWD = "56/F315q";
const char *mac_address;
char data[100];


WiFiClient wifiClient;
PubSubClient mqttClient(wifiClient); 
char *mqttServer = "broker.hivemq.com";
int mqttPort = 1883;
unsigned long last_time  = 0;
DHT dht(DHT11PIN, DHT11);

void connectToWiFi() {
  Serial.print("Connectiog to ");
 
  WiFi.begin(SSID, PWD);
  Serial.println(SSID);
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  // get Mac Address

  //mac_address=WiFi.macAddress();
  Serial.print("Mac address is ");
  Serial.println(WiFi.macAddress());
  Serial.print("Connected.");
  
}

void callback(char* topic, byte* message, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)message[i]);
  }
  

  // Check if message contains the MAC address of this ESP32
  uint8_t mac[6];
  WiFi.macAddress(mac);
  String macAddress = "";
  for (int i = 0; i < 6; ++i) {
    macAddress += String(mac[i], 16);
  }
 // if (strcmp(macAddress.c_str(), (char*)payload) == 0) {   
   // Serial.println("MAC address matched, sending data...");
   Serial.println("");
    // Read temperature and humidity from DHT11 sensor
    float h = dht.readHumidity();
    float t = dht.readTemperature();
    int rain = analogRead(A0);
    // Check if any readings failed
    if (isnan(h) || isnan(t) || isnan(rain)) {
      Serial.println("Failed to read from sensors!");
      mqttClient.publish("esp32/data", "Failed to read from sensors!");
      return;
    }else{
       // Create JSON object to store temperature , humidity and rain data
    StaticJsonDocument<200> doc;
    doc["mac_address"]=macAddress;
    doc["temperature"] = t;
    doc["humidity"] = h;
    doc["rain"]=rain;
    char buffer[200];
    serializeJson(doc, buffer);
    // Publish the data 
    mqttClient.publish("esp32/data", buffer);
    }
//  }else{
//     mqttClient.publish("esp32/data", "Subscribe with the mac address");
//     delay(1000);
//   }
}

// MQTT client

void setupMQTT() {
  mqttClient.setServer(mqttServer, mqttPort);
  // set the callback function
  mqttClient.setCallback(callback);
}


void setup() {
  Serial.begin(9600);
  connectToWiFi();
  
  dht.begin();
  pinMode(A0,INPUT);
  delay(10);
  setupMQTT();
}


void reconnect() {
  Serial.println("Connecting to MQTT Broker...");
  while (!mqttClient.connected()) {
      Serial.println("Reconnecting to MQTT Broker..");
      String clientId = "ESP32Client-";
      clientId += String(random(0xffff), HEX);
      
      if (mqttClient.connect(clientId.c_str())) {
        Serial.println("Connected.");
        // subscribe to topic
        mqttClient.subscribe("esp32/data");
      }
      
  }
}



void loop() {
  if (!mqttClient.connected()) {
    reconnect();
  }
  delay(1000);
  mqttClient.loop();
}
