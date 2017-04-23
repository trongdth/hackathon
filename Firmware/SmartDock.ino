#include <Wire.h>
#include <EEPROMEx.h>
#include "RTClib.h"
#include "DHT.h"
#include "HX711.h"
#include <Adafruit_NeoPixel.h>

//#define __DEBUG_
#ifdef __DEBUG_
#define debugPrint	Serial.print
#define debugPrintln	Serial.println
#else
#define debugPrint	;
#define debugPrintln ;
#endif

#define DHTPIN	2
#define DHTTYPE	DHT11
#define NUM_LOG_ADD	 1020UL
#define LOG_SIZE		10

#define PIN_LED        6
#define NUMPIXELS      12

#define BUTTON			4
#define TIME_LONG_PRESS	1000

#define LAST_STATE_ADD	1022UL
#define DATA_FULL_ADD	1023UL
#define WEIGHT_OFFSET_ADD	1018UL
#define OFFSET_LOADCELL_ADD	1014UL		

struct logTypedef
{
	uint8_t temp;
	uint8_t humid;
	uint32_t weight;
	DateTime time;
};

RTC_DS1307 rtc;
DateTime time;
DHT dht(DHTPIN, DHTTYPE);
HX711 scale(A1, A0);

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, PIN_LED, NEO_GRB + NEO_KHZ800);

float loadCell = 0.0;
float loadCell_old = 0.0;
float temperature = 0.0;
float temperature_old = 0.0;
float humidity = 0.0;
float humidity_old = 0.0;
uint32_t weight_offset = 0;
uint32_t timeReadDHT = 0;
uint32_t timeReadLoadcell = 0;
uint32_t timeButton = 0;
uint32_t timeoutModeoffset = 0;
bool mode_offset = false;
bool mode_button = false;

uint16_t num_log = 0;
struct logTypedef logObj;
bool dataChange = false;
uint8_t dataFull = 0;

uint32_t timeLedOn = 0;

uint8_t ledState = 0;

int16_t pos = 0;
char dataReceived[20];

/**
* @brief Find a string in another string
* @param source The source string
* @param des The destination string
* @param from The position of source string
* @retval value The position of destination string in source string
*/
int findString(const char *source, const char *des, unsigned int from)
{
	int len_source = strlen(source);
	int len_des = strlen(des);
	for (int i = from; i < len_source; i++)
	{
		for (int j = 0; j < len_des; j++)
		{
			if (source[i + j] == des[j])
			{
				if (j == (len_des - 1))
					return i;
			}
			else break;
		}
	}
	return -1;
}
/**
* @brief Write log file to EEPROM
* @param obj Struct-logfile
* @param posLog The position in EEPROM
* @retval void
*/
void logWrite(struct logTypedef *obj, uint16_t posLog)
{
	EEPROM.updateByte(posLog * LOG_SIZE, obj->time.day());
	EEPROM.updateByte(posLog * LOG_SIZE + 1, obj->time.month());
	EEPROM.updateByte(posLog * LOG_SIZE + 2, obj->time.year() - 2000UL);

	EEPROM.updateByte(posLog * LOG_SIZE + 3, obj->time.hour());
	EEPROM.updateByte(posLog * LOG_SIZE + 4, obj->time.minute());
	EEPROM.updateByte(posLog * LOG_SIZE + 5, obj->time.second());

	EEPROM.updateByte(posLog * LOG_SIZE + 6, obj->temp);
	EEPROM.updateByte(posLog * LOG_SIZE + 7, obj->humid);
	EEPROM.updateInt(posLog * LOG_SIZE + 8, obj->weight);
	
	num_log++;
	if (num_log > 100)
	{
		num_log = 0;
		dataFull = 1;
		dataFull = EEPROM.updateByte(DATA_FULL_ADD, dataFull);
	}
	EEPROM.updateInt(NUM_LOG_ADD, num_log);
}
/**
* @brief Read log file from EEPROM
* @param obj Struct-logfile
* @param posLog The position in EEPROM
* @retval void
*/
void logRead(struct logTypedef *obj, uint16_t posLog)
{
	uint8_t tmp[6];
	uint8_t temp_tmp = 0;
	uint8_t humid_tmp = 0;
	uint16_t weight_tmp = 0;
	for (uint16_t i = 0; i < 6; i++)
	{
		tmp[i] = EEPROM.readByte(posLog * LOG_SIZE + i);
	}
	temp_tmp = EEPROM.readByte(posLog * LOG_SIZE + 6);
	humid_tmp = EEPROM.readByte(posLog * LOG_SIZE + 7);
	weight_tmp = EEPROM.readInt(posLog * LOG_SIZE + 8);

	DateTime newDate(tmp[2] + 2000UL, tmp[1], tmp[0], tmp[3], tmp[4], tmp[5]);
	obj->time = newDate;
	obj->temp = temp_tmp;
	obj->humid = humid_tmp;
	obj->weight = weight_tmp;
}
/**
* @brief Send log to BLE
* @param numLog The number of log to send
* @retval void
*/
void sendLog(uint16_t numLog)
{
	struct logTypedef obj;
	for (uint16_t i = 0; i < numLog; i++)
	{
		logRead(&obj, i);

		if (obj.time.day() < 10)
		{
			Serial.print(0);
		}
		Serial.print(obj.time.day());
		if (obj.time.month() < 10)
		{
			Serial.print(0);
		}
		Serial.print(obj.time.month());

		Serial.print(obj.time.year());
		Serial.print(' ');

		if (obj.time.hour() < 10)
		{
			Serial.print(0);
		}
		Serial.print(obj.time.hour());
		Serial.print(':');
		if (obj.time.minute() < 10)
		{
			Serial.print(0);
		}
		Serial.print(obj.time.minute());
		Serial.print(':');
		if (obj.time.second() < 10)
		{
			Serial.print(0);
		}
		Serial.print(obj.time.second());
		Serial.print('#');
		Serial.print(obj.weight);
		Serial.print('#');
		Serial.print(obj.temp);
		Serial.print('#');
		Serial.print(obj.humid);
		Serial.println();
		delay(50);
	}
	Serial.println("end");
	
}
/**
* @brief Wheel LED
* @param WheelPos Wheel position
* @retval color The color of LED
*/
uint32_t Wheel(byte WheelPos) {
	WheelPos = 255 - WheelPos;
	if (WheelPos < 85) {
		return pixels.Color(255 - WheelPos * 3, 0, WheelPos * 3);
	}
	if (WheelPos < 170) {
		WheelPos -= 85;
		return pixels.Color(0, WheelPos * 3, 255 - WheelPos * 3);
	}
	WheelPos -= 170;
	return pixels.Color(WheelPos * 3, 255 - WheelPos * 3, 0);
}
/**
* @brief Run LED rainbow animation
* @param wait The delay-time
* @retval void
*/
void rainbowCycle(uint8_t wait) {
	uint16_t i, j;

	for (j = 0; j < 256 * 2; j++) { // 5 cycles of all colors on wheel
		for (i = 0; i < pixels.numPixels(); i++) {
			pixels.setPixelColor(i, Wheel(((i * 256 / pixels.numPixels()) + j) & 255));
		}
		pixels.show();
		delay(wait);
	}
}
/**
* @brief Wheel LED
* @param WheelPos Wheel position
* @retval color The color of LED
*/
void setLedColor(uint8_t r, uint8_t g, uint8_t b)
{
	for (uint16_t i = 0; i < pixels.numPixels(); i++)
	{
		pixels.setPixelColor(i, pixels.Color(r, g, b));
	}
	pixels.show();
}

void setup()
{

  /* add setup code here */
	Serial.begin(115200);
	Serial.setTimeout(100);
	pinMode(BUTTON, INPUT);
	rtc.begin();
	dht.begin();
	pixels.begin(); // This initializes the NeoPixel library.
	pixels.clear();
	rainbowCycle(20);
	EEPROM.setMemPool(1024, EEPROMSizeATmega328);
	ledState = EEPROM.readByte(LAST_STATE_ADD);
	dataFull = EEPROM.readByte(DATA_FULL_ADD);
	if (dataFull > 1)
	{
		dataFull = 0;
		dataFull = EEPROM.updateByte(DATA_FULL_ADD, dataFull);
	}
	if (ledState > 3)
	{
		ledState = 0;
		EEPROM.updateByte(LAST_STATE_ADD, ledState);
	}
	if (ledState == 0)
	{
		setLedColor(0, 0, 0);
	}
	else if (ledState == 1)//red
	{
		setLedColor(255, 0, 0);
	}
	else if (ledState == 2)//green
	{
		setLedColor(0, 255, 0);
	}
	else if (ledState == 3)//blue
	{
		setLedColor(0, 0, 255);
	}
	scale.set_scale(1515.23f);
	

	num_log = EEPROM.readInt(NUM_LOG_ADD);
	if (num_log > 100)
	{
		num_log = 0;
		EEPROM.updateInt(NUM_LOG_ADD, num_log);
	}
	scale.tare();
	time = rtc.now();
	
	if (time.year() == 2000)// the first time I read
	{
		DateTime newDate(2017, 4, 11, 0, 0);
		//rtc.adjust(newDate);
	}
	debugPrintln("Begin");
}

void loop()
{

  /* add main program code here */
	if (digitalRead(BUTTON) == HIGH)
	{
		if (mode_button == false)
		{
			timeButton = millis();
			mode_button = true;
			//debugPrintln("press");
		}

		if (ledState == 0)
		{
			/*pixels.setPixelColor(3, pixels.Color(255, 0, 0));
			pixels.setPixelColor(4, pixels.Color(255, 0, 0));
			pixels.setPixelColor(5, pixels.Color(255, 0, 0));
			pixels.setPixelColor(6, pixels.Color(255, 0, 0));
			pixels.show();*/
		}
	}
	else
	{
		mode_button = false;
		timeButton = millis();// reset time
		if (ledState == 0)
		{
			/*pixels.setPixelColor(3, pixels.Color(0, 0, 0));
			pixels.setPixelColor(4, pixels.Color(0, 0, 0));
			pixels.setPixelColor(5, pixels.Color(0, 0, 0));
			pixels.setPixelColor(6, pixels.Color(0, 0, 0));
			pixels.show();*/
		}
	}

	if ((millis() - timeButton >= TIME_LONG_PRESS) && (mode_button))
	{
		mode_offset = true;
		timeButton = millis();
	}

	if (mode_offset)
	{
		mode_offset = false;
		scale.tare();
		rainbowCycle(20);
		setLedColor(0, 0, 0);
		ledState = 0; // led off
		EEPROM.updateByte(LAST_STATE_ADD, ledState);
		/* get offset here*/
		weight_offset = (uint32_t)(scale.get_units(10));
		/* clear log*/
		num_log = 0;
		EEPROM.updateInt(NUM_LOG_ADD, num_log);
		dataFull = 0;
		dataFull = EEPROM.updateByte(DATA_FULL_ADD, dataFull);

	}
	/*check led*/
	if (ledState != 0)
	{
		if (millis() - timeLedOn >= 5000)
		{
			timeLedOn = millis();
			setLedColor(0, 0, 0);//off led
			ledState = 0;
		}
	}
	/*Read temperature and humidity*/
	if (millis() - timeReadDHT >= 2000)
	{
		timeReadDHT = millis();
		temperature = dht.readTemperature();
		humidity = dht.readHumidity();
		if (abs(temperature - temperature_old) >= 3)// differ 2 *C
		{
			temperature_old = temperature;
			logObj.temp = temperature;
			dataChange = true;
			debugPrintln("temp changed");
		}
		if (abs(humidity - humidity_old) >= 3)// differ 2 *C
		{
			humidity_old = humidity;
			logObj.humid = humidity;
			//dataChange = true;
			debugPrintln("humid changed");
		}
	}

	/* Read load cell*/
	if (millis() - timeReadLoadcell >= 1000)
	{
		timeReadLoadcell = millis();

		loadCell = scale.get_units(10);
		if (abs(loadCell - loadCell_old) >= 100)// 50g
		{
			loadCell_old = loadCell;
			logObj.weight = round(loadCell);
			dataChange = true;
		}
	}
	 /* Received data from BLE*/
	if (Serial.available() > 0)
	{
		Serial.readBytes(&dataReceived[0], 20);
		if ((pos = findString(&dataReceived[0], "d: ", 0)) != -1)		// set datetime
		{
			uint16_t date_tmp = 0;
			uint16_t month_tmp = 0;
			uint16_t year_tmp = 0;
			uint16_t hour_tmp = 0;
			uint16_t minute_tmp = 0;
			uint16_t second_tmp = 0;
			/* date month and year*/
			date_tmp = (dataReceived[pos + 3] - '0') * 10 + (dataReceived[pos + 4] - '0');
			month_tmp = (dataReceived[pos + 5] - '0') * 10 + (dataReceived[pos + 6] - '0');
			 year_tmp = (dataReceived[pos + 7] - '0') * 1000 + (dataReceived[pos + 8] - '0') * 100
				+ (dataReceived[pos + 9] - '0') * 10 + (dataReceived[pos + 10] - '0');
			/* hour minute and second*/
			hour_tmp = (dataReceived[pos + 12] - '0') * 10 + (dataReceived[pos + 13] - '0');
			minute_tmp = (dataReceived[pos + 15] - '0') * 10 + (dataReceived[pos + 16] - '0');
			second_tmp = (dataReceived[pos + 18] - '0') * 10 + (dataReceived[pos + 19] - '0');

			debugPrint(date_tmp); debugPrint('-'); debugPrint(month_tmp);	debugPrint('-'); debugPrintln(year_tmp);
			debugPrint(hour_tmp); debugPrint(':'); debugPrint(minute_tmp);	debugPrint(':'); debugPrintln(second_tmp);
			if (date_tmp <= 31 && month_tmp <= 12 && year_tmp <= 2100 && hour_tmp <= 23 && minute_tmp <= 59 && second_tmp <= 59)
			{
				DateTime newDate(year_tmp, month_tmp, date_tmp, hour_tmp, minute_tmp, second_tmp);
				time = newDate;
				rtc.adjust(newDate);
				Serial.print("OK");
			}
			else
			{
				Serial.print("NO");
				
			}
			Serial.println("end");
		}
		else if ((pos = findString(&dataReceived[0], "s: offset", 0)) != -1) // offset for weight of cup
		{
			Serial.print(weight_offset);
			delay(100);
			Serial.println("end");
		}
		else if ((pos = findString(&dataReceived[0], "t: 0", 0)) != -1)
		{
			if (num_log > 1)
			{
				if (dataFull == 0)
				{
					sendLog(num_log - 1);
				}
				else
				{
					sendLog(100);
				}
			}
			else
			{
				sendLog(0);
			}
		}
		else if ((pos = findString(&dataReceived[0], "l: r", 0)) != -1)
		{
			setLedColor(255, 0, 0);
			ledState = 1;
			timeLedOn = millis();
			EEPROM.updateByte(LAST_STATE_ADD, ledState);
			Serial.print("OK");
			Serial.println("end");
		}
		else if ((pos = findString(&dataReceived[0], "l: g", 0)) != -1)
		{
			setLedColor(0, 255, 0);
			ledState = 2;
			timeLedOn = millis();
			EEPROM.updateByte(LAST_STATE_ADD, ledState);
			Serial.print("OK");
			Serial.println("end");
		}
		else if ((pos = findString(&dataReceived[0], "l: b", 0)) != -1)
		{
			setLedColor(0, 0, 255);
			ledState = 3;
			timeLedOn = millis();
			EEPROM.updateByte(LAST_STATE_ADD, ledState);
			Serial.print("OK");
			Serial.println("end");
		}
		else if ((pos = findString(&dataReceived[0], "clear-all", 0)) != -1)
		{
			num_log = 0;
			EEPROM.updateInt(NUM_LOG_ADD, num_log);
			dataFull = 0;
			dataFull = EEPROM.updateByte(DATA_FULL_ADD, dataFull);
			Serial.print("OKend\r\n");
		}
		
	}

	if (dataChange)// write newlog, data changed
	{
		dataChange = false;
		time = rtc.now();
		logObj.time = time;
		logWrite(&logObj, num_log);
	}

}
