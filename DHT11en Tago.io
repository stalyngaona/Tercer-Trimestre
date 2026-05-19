#include "DHT.h"
#include <HTTPClient.h>
#include <WiFi.h>

char serverAddress[] = "https://api.tago.io/data";  // TagoIO address
char contentHeader[] = "application/json";
char tokenHeader[] = "7f0eae31-56aa-4b09-aea5-2fea776a1d5f"; // TagoIO Token
const char *ssid = "RED MECATRONICA";
const char *password = "MECA2026@.";

WiFiClient wifia;
// HttpClient client = HttpClient(wifia, serverAddress, port);
HTTPClient client;
int status = WL_IDLE_STATUS;

// DHT configuration
#define DHTPIN 5     // Digital pin connected to the DHT sensor
#define DHTTYPE DHT22   // DHT 22  (AM2302), AM2321
DHT dht(DHTPIN, DHTTYPE);



void setup() {
  Serial.begin(115200);
  delay(10);

  WiFi.mode(WIFI_STA);
  if (ssid != "")
    WiFi.begin(ssid, password);
  WiFi.begin();
  Serial.println("");

  // Wait for connection
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
  Serial.println(F("DHTxx test!"));

  dht.begin();
}

void loop() {
  // Wait a few seconds between measurements.
  delay(2000);

    char anyData[30];
    char postData[300];
    char anyData1[30];
    char bAny[30];
    int statusCode=0;

  // Reading temperature or humidity takes about 250 milliseconds!
  // Sensor readings may also be up to 2 seconds 'old' (its a very slow sensor)
  float h = dht.readHumidity();
  // Read temperature as Celsius (the default)
  float t = dht.readTemperature();

  // Check if any reads failed and exit early (to try again).
  if (isnan(h) || isnan(t)) {
    Serial.println(F("Failed to read from DHT sensor!"));
    return;
  }

  // Compute heat index in Fahrenheit (the default)
  float hic = dht.computeHeatIndex(t, h, false);
 
  Serial.print(F("Humidity: "));
  Serial.println(h);
  strcpy(postData, "{\n\t\"variable\": \"Humidity\",\n\t\"value\": ");
  dtostrf(h, 6, 2, anyData);
  strncat(postData, anyData, 100);
  strcpy(anyData1, ",\n\t\"unit\": \"%\"\n\t}\n");
  strncat (postData, anyData1, 100);
  Serial.println(postData);
  client.begin(serverAddress);
  client.addHeader("Content-Type", contentHeader);
  client.addHeader("Device-Token", tokenHeader);
  statusCode = client.POST(postData);

  delay(30000);
  // read the status code and body of the response
  Serial.print("Status code: ");
  Serial.println(statusCode);
  Serial.println("End of POST to TagoIO");
  Serial.println();
  
  Serial.print(F("Temperature: "));
  Serial.println(t);
  strcpy(postData, "{\n\t\"variable\": \"Temperature\",\n\t\"value\": ");
  dtostrf(t, 6, 2, anyData);
  strncat(postData, anyData, 100);
  strcpy(anyData1, ",\n\t\"unit\": \"C\"\n\t}\n");
  strncat (postData, anyData1, 100);
  Serial.println(postData);
  client.begin(serverAddress);
  client.addHeader("Content-Type", contentHeader);
  client.addHeader("Device-Token", tokenHeader);
  statusCode = client.POST(postData);

  delay(30000);
  // read the status code and body of the response
  Serial.print("Status code: ");
  Serial.println(statusCode);
  Serial.println("End of POST to TagoIO");
  Serial.println();
  
  Serial.print(F("Heat index: "));
  Serial.println(hic);
  strcpy(postData, "{\n\t\"variable\": \"HIndex\",\n\t\"value\": ");
  dtostrf(hic, 6, 2, anyData);
  strncat(postData, anyData, 100);
  strcpy(anyData1, ",\n\t\"unit\": \"C\"\n\t}\n");
  strncat (postData, anyData1, 100);
  Serial.println(postData);
  client.begin(serverAddress);
  client.addHeader("Content-Type", contentHeader);
  client.addHeader("Device-Token", tokenHeader);
  statusCode = client.POST(postData);

  delay(30000);
  // read the status code and body of the response
  Serial.print("Status code: ");
  Serial.println(statusCode);
  Serial.println("End of POST to TagoIO");
  Serial.println();
}
