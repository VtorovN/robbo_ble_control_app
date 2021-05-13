#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

#define SERVICE_UUID        "fe16f2b0-7783-11eb-9881-0800200c9a66"
#define RED_LED_CHARACTERISTIC_UUID "69869f60-7788-11eb-9881-0800200c9a66"
#define GREEN_LED_CHARACTERISTIC_UUID "baa67b3a-b32a-11eb-8529-0242ac130003"

#define LED_RED 12  
#define LED_GREEN 14

BLECharacteristic *characteristicLedRed;
BLECharacteristic *characteristicLedGreen;

const long blinkInterval = 1000;
unsigned long previousMillisRed = 0;
unsigned long previousMillisGreen = 0;

int redLedState = HIGH;
int greenLedState = HIGH;

void setup() {
  pinMode(LED_RED, OUTPUT);
  digitalWrite(LED_RED, HIGH);
  
  pinMode(LED_GREEN, OUTPUT);
  digitalWrite(LED_GREEN, HIGH);

  BLEDevice::init("ESP32 BLE");
  BLEServer *pServer = BLEDevice::createServer();
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
                                 
  characteristicLedRed->setValue("0");
  characteristicLedGreen->setValue("0");
  
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
}
