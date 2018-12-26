#include <mega128.h>
#include <stdio.h>
#include <delay.h>
#include "lcd.h"

#define SONAR_ARR_SIZE 3

#define D_A 5
#define D_B 13
#define D_C 20
#define DELTA 1
#define MOTOR_FAST 235
#define MOTOR_SLOW 210

int mode_arr[] = { 0, 1, 0, 1, 0, 2, 0, 2, 0, 2, 3, 4 };
int mode_index;
int mode;        // front(0), left(1), right(2), 주차 준비(3), 주차 진행(4)
int mode_change;    // don't change(0), change(1)
unsigned char i, j;
int distance;

unsigned long int TCsec;

/* 서보 */
void Init_Timer3A()
{
	TCCR3A = 0xAA; // FAST PWM
	TCCR3B = 0x1A; // 8분주=0.5usec

	OCR3AH = 3000 >> 8;          // 1500usec=0도
	OCR3AL = 3000 & 0xff;
	DDRE = 0x08;               // DDRE=0x08;   // PE 3 out  
	ICR3H = 39999 >> 8;
	ICR3L = 39999 & 0xff;        // 0.5usec*40000=20000usec=50Hz
}

void Servo_motor(int angle)
{
	OCR3AH = (angle * 14 + 3640) >> 8;
	OCR3AL = (angle * 14 + 3640) & 0xFF;
}

/* 초음파 센서 */
#define Trigger1     PORTB.0 //초음파 트리거 
#define Trigger2     PORTB.0
#define Trigger3     PORTB.0

#define Echo1        PIND.0 //초음파 에코
#define Echo2        PIND.1
#define Echo3        PIND.2

unsigned int leftD;         // 왼쪽
unsigned int frontD;        // 정면
unsigned int rightD;        // 오른쪽 
unsigned int leftPastD;         // 왼쪽
unsigned int frontPastD;        // 정면
unsigned int rightPastD;        // 오른쪽 
unsigned int sideTotalD;
unsigned int smallestD;

int L_F_R;

unsigned int temp;
// unsigned int sonar_arr[3];

unsigned char rangeStr[5];
unsigned char TCsecStr[10];

void getEchoFront() {
	while (!Echo1);//high가 될때
	TCNT1 = 0; TCCR1B = 2; //카운터시작 , 0.5분주
	while (Echo1);//low가 될때
	TCCR1B = 8; //카운터 정지 TCCR1B = 0도 가능
	frontD = TCNT1 / 116;//CM변경
	TCNT1 = 0;
}
void getEchoRight()
{
	while (!Echo2);//high가 될때
	TCNT1 = 0; TCCR1B = 2; //카운터시작 , 0.5분주
	while (Echo2);//low가 될때
	TCCR1B = 8; //카운터 정지 TCCR1B = 0도 가능
	rightD = TCNT1 / 116;//CM변경  
	TCNT1 = 0;
}
void getEchoLeft() {
	while (!Echo3);//high가 될때
	TCNT1 = 0; TCCR1B = 2; //카운터시작 , 0.5분주
	while (Echo3);//low가 될때
	TCCR1B = 8; //카운터 정지 TCCR1B = 0도 가능
	leftD = TCNT1 / 116;//CM변경      
	TCNT1 = 0;
}
/* 초음파 센서 */

/* 서보 */

void custom_port_init() {
	DDRE = 0xff;        // Servo, DC
	DDRB = 0xff;        // Sonar, DC    
	DDRD = 0x00;        // DC

	//DDRF = 0xFF;
}

/* DC MOTOR */
void TIMSK_setting() {
	TIMSK = (1 << OCIE0) | (1 << TOIE0);
}
void timer0_Init() {
	TCCR0 = (1 << WGM01) | (1 << WGM00) | (1 << CS01);
}
interrupt[TIM0_COMP] void timer0_compare() {
	PORTB.5 = 0;
	PORTB.6 = 0;
}
interrupt[TIM0_OVF] void timer0_overflow() {
	PORTB.5 = 1;
	PORTB.6 = 1;

	TCsec++;
}

void Motor_fast() {
	OCR0 = MOTOR_FAST;
}
void Motor_slow() {
	OCR0 = MOTOR_SLOW;
}
void DC_front() {
	PORTE.4 = 1;
	PORTE.5 = 0;
	PORTE.6 = 1;
	PORTE.7 = 0;
}
void DC_back() {
	PORTE.4 = 0;
	PORTE.5 = 1;
	PORTE.6 = 0;
	PORTE.7 = 1;
}

void DC_stop() {
	PORTB.5 = 0;
	PORTB.6 = 0;
	TIMSK = (0 << OCIE0) & (0 << TOIE0);
}

void DC_start() {
	TIMSK = (1 << OCIE0) | (1 << TOIE0);
	PORTB.5 = 1;
	PORTB.6 = 1;
}

void DC_Left() {
	PORTE.4 = 0;
	PORTE.5 = 1;
	PORTE.6 = 1;
	PORTE.7 = 0;
}

void DC_Right() {
	PORTE.4 = 1;
	PORTE.5 = 0;
	PORTE.6 = 0;
	PORTE.7 = 1;
}

/* DC MOTOR */

void get_sonar() {
	Trigger1 = 1; delay_us(10); Trigger1 = 0; getEchoLeft(); delay_ms(10);
	LCD_pos(0, 0);
	sprintf(rangeStr, "%03d", leftD);
	LCD_STR(rangeStr);

	Trigger2 = 1; delay_us(10); Trigger2 = 0; getEchoFront(); delay_ms(10);
	LCD_pos(0, 5);
	sprintf(rangeStr, "%03d", rightD);
	LCD_STR(rangeStr);

	Trigger3 = 1; delay_us(10); Trigger3 = 0; getEchoRight(); delay_ms(10);
	LCD_pos(0, 10);
	sprintf(rangeStr, "%03d", frontD);
	LCD_STR(rangeStr);

	LCD_pos(1, 0);
	sprintf(TCsecStr, "%4x%4x", TCsec >> 16, TCsec);
	LCD_STR(TCsecStr);
}

int L_F_R_set() {
	int temp = 0;

	if (leftD < frontD) { temp = leftD; L_F_R = 0; }
	else { temp = frontD; L_F_R = 1; }

	if (temp > rightD) { temp = rightD; L_F_R = 2; }

	return temp;
}

void main() {
	SREG |= 0x80;

	custom_port_init();

	Init_Timer3A();
	Port_Init();
	LCD_Init();

	TIMSK_setting();
	timer0_Init();

	TCCR1A = 0;
	TCCR1B = 8;

	Motor_fast();

	leftD = 0;
	frontD = 0;
	rightD = 0;
	leftPastD = 0;
	frontPastD = 0;
	rightPastD = 0;
	sideTotalD = 0;
	smallestD = 0;
	distance = 0;

	TCsec = 0;

	PORTE.3 = 0;

	/* DC Default */
	PORTB.5 = 1;
	PORTB.6 = 1;

	OCR0 = MOTOR_FAST;

	DC_front();
	/* DC Default */

	L_F_R = 1;

	while (1) {
		leftPastD = leftD;
		frontPastD = frontD;
		rightPastD = rightD;

		L_F_R = 5;

		get_sonar();
		sideTotalD = leftD + rightD;
		smallestD = L_F_R_set();

		if (leftD > leftPastD - DELTA && leftD < leftPastD + DELTA && frontD > frontPastD - DELTA && frontD < frontPastD + DELTA && rightD > rightPastD - DELTA && rightD < rightPastD + DELTA) {
			switch (L_F_R) {
			case 0:
				Servo_motor(-10); Motor_fast(); DC_back(); delay_ms(500);
				break;
			case 1:
				Servo_motor(0); Motor_fast(); DC_back(); delay_ms(500);
				break;
			case 2:
				Servo_motor(10); Motor_fast(); DC_back(); delay_ms(500);
				break;
			default:
				Servo_motor(0); Motor_fast(); DC_back(); delay_ms(500);
			}
		}
		else if (smallestD < D_A) {
			switch (L_F_R) {
			case 0:
				Servo_motor(-20); Motor_fast(); DC_back(); delay_ms(500);
				break;
			case 1:
				Servo_motor(0); Motor_fast(); DC_back(); delay_ms(500);
				break;
			case 2:
				Servo_motor(20); Motor_fast(); DC_back(); delay_ms(500);
				break;
			default:
				Servo_motor(0); Motor_fast(); DC_back(); delay_ms(500);
			}
		}
		else if (sideTotalD < 40) {
			if (frontD < D_B) distance = 3;
			else if (frontD < D_C) distance = 2;
			else distance = 1;

			switch (L_F_R) {
			case 0:
				Servo_motor(5 * distance); Motor_fast(); DC_front();
				break;
			case 1:
				Servo_motor(0); Motor_fast(); DC_front();
				break;
			case 2:
				Servo_motor(-5 * distance); Motor_fast(); DC_front();
				break;
			default:
				Servo_motor(0); Motor_fast(); DC_front();
			}
		}
		else {
			if (rightD > leftD) {
				Servo_motor(35); Motor_fast(); DC_front();
			}
			else {
				Servo_motor(-35); Motor_fast(); DC_front();
			}
		}
		delay_ms(1000);
	}
}
