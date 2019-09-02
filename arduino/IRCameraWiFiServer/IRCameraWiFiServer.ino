/*
 MLX90640 thermal camera connected to a SparkFun Thing Plus - ESP32 WROOM

 Created by: Christopher Black
 */

#include <WiFi.h>
#include <Wire.h>  // Used for I2C communication
#include <SFE_MicroOLED.h>  // Include the SFE_MicroOLED library
#include "MLX90640_API.h"
#include "MLX90640_I2C_Driver.h"
#include "env.h"

// MicroOLED variables
#define PIN_RESET 9  
#define DC_JUMPER 1 
MicroOLED oled(PIN_RESET, DC_JUMPER);    // I2C declaration

// WiFi variables
const char* ssid     = wifi_ssid;
const char* password = wifi_pw;
WiFiServer server(80);

// MLX90640 variables
const byte MLX90640_address = 0x33; //Default 7-bit unshifted address of the MLX90640
#define TA_SHIFT 8 //Default shift for MLX90640 in open air
static float mlx90640To[768];
paramsMLX90640 mlx90640;

void setup()
{
    Serial.begin(115200);
    delay(100);
    pinMode(13, OUTPUT);      // set the LED pin mode
    Wire.setClock(400000L);
    Wire.begin();
    
    oled.begin();    // Initialize the OLED
    oled.clear(ALL); // Clear the display's internal memory
    oled.display();  // Display what's in the buffer (splashscreen)
    delay(1000);     // Delay 1000 ms
    oled.clear(PAGE); // Clear the buffer
    oled.print("Test");
    oled.display(); // Draw on the screen

    delay(1000);

    Serial.println();
    Serial.println();
    Serial.print("Connecting to ");
    Serial.println(ssid);

    // Connect to the WiFi network
    WiFi.begin(ssid, password);
    int retry = 0;
    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        retry += 1;
        Serial.print(".");
        if (retry > 5 ) {
          // Retry after 5 seconds
          Serial.println("");
          WiFi.begin(ssid, password);
          retry = 0;
        }
    }

    Serial.println("");
    Serial.println("WiFi connected.");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
    
    server.begin();

    if (isConnected() == false)
    {
        Serial.println("MLX90640 not detected at default I2C address. Please check wiring. Freezing.");
        while (1);
    }

    Serial.println("MLX90640 online!");

    // Get device parameters - We only have to do this once
    int status;
    uint16_t eeMLX90640[832];
    status = MLX90640_DumpEE(MLX90640_address, eeMLX90640);

    if (status != 0) {
        Serial.println("Failed to load system parameters");
    }
    status = MLX90640_ExtractParameters(eeMLX90640, &mlx90640);
    if (status != 0) {
        Serial.println("Parameter extraction failed");
    }
    MLX90640_SetRefreshRate(MLX90640_address, 0x02);
}

int value = 0;
int count = 100000;

void loop(){
  if (count >= 100000) {
    long startTime = millis();
    for (byte x = 0 ; x < 2 ; x++) //Read both subpages
    {
      uint16_t mlx90640Frame[834];
      int status = MLX90640_GetFrameData(MLX90640_address, mlx90640Frame);
      if (status < 0)
      {
        Serial.print("GetFrame Error: ");
        Serial.println(status);
      }
  
      float vdd = MLX90640_GetVdd(mlx90640Frame, &mlx90640);
      float Ta = MLX90640_GetTa(mlx90640Frame, &mlx90640);

      float tr = Ta - TA_SHIFT; //Reflected temperature based on the sensor ambient temperature
      float emissivity = 0.95;

      MLX90640_CalculateTo(mlx90640Frame, &mlx90640, emissivity, tr, mlx90640To);
    }
    count = 0;
    long stopReadTime = millis();
    Serial.print("Read rate: ");
    Serial.print( 1000.0 / (stopReadTime - startTime), 2);
    Serial.println(" Hz");
  }
  count = count + 1;
  
  WiFiClient client = server.available();   // listen for incoming clients

  if (client) {                             
    Serial.println("New Client.");
    String currentLine = "";
    while (client.connected()) {
      if (client.available()) {
        char c = client.read();
        Serial.write(c);
        if (c == '\n') {
          // if the current line is blank, you got two newline characters in a row.
          // that's the end of the client HTTP request, so send a response:
          if (currentLine.length() == 0) {
            // HTTP headers always start with a response code (e.g. HTTP/1.1 200 OK)
            // and a content-type so the client knows what's coming, then a blank line:
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type:text/html");
            client.println();

            // the content of the HTTP response follows the header:
            for (int x = 0 ; x < 768 ; x++)
            {
                client.print("<span>");
                client.print(mlx90640To[x], 1);
                client.print("</span>");                    
                if( (x + 1) % 32 == 0 && x != 0) {
                  client.print("<br />");
                } else {
                  client.print("<span>, </span>");
                }
            }
            // The HTTP response ends with another blank line:
            client.println();
            // break out of the while loop:
            break;
          } else {    // if you got a newline, then clear currentLine:
            currentLine = "";
          }
        } else if (c != '\r') {  // if you got anything else but a carriage return character,
          currentLine += c;      // add it to the end of the currentLine
        }
      }
    }
    // close the connection:
    client.stop();
    Serial.println("Client Disconnected.");
  }
}

//Returns true if the MLX90640 is detected on the I2C bus

boolean isConnected()
{
  Wire.beginTransmission((uint8_t)MLX90640_address);
  if (Wire.endTransmission() != 0)
    return (false); //Sensor did not ACK
  return (true);
}
