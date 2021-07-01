#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <ESP32Servo.h>

#define SERVICE_UUID        "fe16f2b0-7783-11eb-9881-0800200c9a66"
#define RED_LED_CHARACTERISTIC_UUID "69869f60-7788-11eb-9881-0800200c9a66"
#define GREEN_LED_CHARACTERISTIC_UUID "baa67b3a-b32a-11eb-8529-0242ac130003"
#define BLUE_LED_CHARACTERISTIC_UUID "788b23f8-b3e4-11eb-8529-0242ac130003"
#define SERVO_CHARACTERISTIC_UUID "c6e083e4-b3db-11eb-8529-0242ac130003"

/* LEDS */

#define LED_RED 12  
#define LED_GREEN 14
#define LED_BLUE 18

BLECharacteristic *characteristicLedRed;
BLECharacteristic *characteristicLedGreen;
BLECharacteristic *characteristicLedBlue;

const long blinkInterval = 1000;
unsigned long previousMillisRed = 0;
unsigned long previousMillisGreen = 0;
unsigned long previousMillisBlue = 0;

int redLedState = HIGH;
int greenLedState = HIGH;
int blueLedState = HIGH;

/* LEDS END */

Servo servo1;

BLECharacteristic *characteristicServo;

std::__cxx11::string previousServoValue = "0";

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) { };

    void onDisconnect(BLEServer* pServer) {
      BLEDevice::startAdvertising();
    }
};

void setup() {
  pinMode(LED_RED, OUTPUT);
  digitalWrite(LED_RED, HIGH);
  
  pinMode(LED_GREEN, OUTPUT);
  digitalWrite(LED_GREEN, HIGH);
  
  pinMode(LED_BLUE, OUTPUT);
  digitalWrite(LED_BLUE, HIGH);

  servo1.attach(21);
  servo1.write(0);

  BLEDevice::init("ESP32 BLE");
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());
  
  BLEService *pService = pServer->createService(SERVICE_UUID);
  characteristicLedRed = pService->createCharacteristic(
                                  RED_LED_CHARACTERISTIC_UUID,
                                  BLECharacteristic::PROPERTY_READ |
                                  BLECharacteristic::PROPERTY_WRITE
                                 );
  characteristicLedGreen = pService->createCharacteristic(
                                  GREEN_LED_CHARACTERISTIC_UUID,
                                  BLECharacteristic::PROPERTY_READ |
                                  BLECharacteristic::PROPERTY_WRITE
                                 );
  characteristicLedBlue = pService->createCharacteristic(
                                  BLUE_LED_CHARACTERISTIC_UUID,
                                  BLECharacteristic::PROPERTY_READ |
                                  BLECharacteristic::PROPERTY_WRITE
                                 );
  characteristicServo = pService->createCharacteristic(
                                  SERVO_CHARACTERISTIC_UUID,
                                  BLECharacteristic::PROPERTY_READ |
                                  BLECharacteristic::PROPERTY_WRITE
                                 );
  
  characteristicLedRed->setValue("0");
  characteristicLedGreen->setValue("0");
  characteristicLedBlue->setValue("0");
  
  pService->start();
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
}

void loop() {
  unsigned long currentMillis = millis();

  if (redLedState == HIGH && characteristicLedRed->getValue() == "1") {
    digitalWrite(LED_RED, LOW);
    redLedState = LOW;
    previousMillisRed = currentMillis;
  }
  
  if (greenLedState == HIGH && characteristicLedGreen->getValue() == "1") {
    digitalWrite(LED_GREEN, LOW);
    greenLedState = LOW ;
    previousMillisGreen = currentMillis;
  }
  
  if (blueLedState == HIGH && characteristicLedBlue->getValue() == "1") {
    digitalWrite(LED_BLUE, LOW);
    blueLedState = LOW ;
    previousMillisBlue = currentMillis;
  }

  if (redLedState == LOW && currentMillis - previousMillisRed >= blinkInterval) {
      redLedState = HIGH;
      digitalWrite(LED_RED, HIGH);
      characteristicLedRed->setValue("0");
  }
  
  if (greenLedState == LOW && currentMillis - previousMillisGreen >= blinkInterval) {
      greenLedState = HIGH;
      digitalWrite(LED_GREEN, HIGH);
      characteristicLedGreen->setValue("0");
  }
  
  if (blueLedState == LOW && currentMillis - previousMillisBlue >= blinkInterval) {
      blueLedState = HIGH;
      digitalWrite(LED_BLUE, HIGH);
      characteristicLedBlue->setValue("0");
  }

  if (characteristicServo->getValue() != previousServoValue) {
    previousServoValue = characteristicServo->getValue();
    String str = previousServoValue.c_str();
    servo1.write(str.toInt());
  }
}
