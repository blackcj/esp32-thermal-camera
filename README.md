# ESP32 Thermal Camera

MLX90640 thermal camera connected to a SparkFun Thing Plus - ESP32 WROOM

## Components

- https://www.sparkfun.com/products/14689
- https://www.sparkfun.com/products/14844 or https://www.sparkfun.com/products/14843
- https://www.sparkfun.com/products/14427 x 2
- https://www.sparkfun.com/products/14532 (Optional)

**Total Cost: ~$115**


## Setup

1. Create an `env.h` file in the IRCameraWiFiServer folder and add your WiFi credentials
   ```
   static const char* wifi_ssid = "YOUR_WIFI_SSID";
   static const char* wifi_pw = "YOU_WIFI_PW";
   ```
2. Connect your SparkFun Thing Plus - ESP32 WROOM using this (guide)[https://learn.sparkfun.com/tutorials/esp32-thing-plus-hookup-guide] 
3. Make sure to select **Adafruit ESP32 Feather** in the Arduino IDE
4. Install the following libraries
   - SparkFun_Micro_OLED_Breakout
5. Flash the code on your device
6. Navigate to the IP address from the serial monitor


## Resources

- https://github.com/melexis/mlx90640-library
- https://github.com/sparkfun/SparkFun_MLX90640_Arduino_Example