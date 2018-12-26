#include <mega128.h>
#include <stdio.h>
#include <delay.h>
#include "lcd.h"

#define SONAR_ARR_SIZE 3

#define D_A 5			// �¿��� ���� ����
#define D_B 8			// ���� ����
#define D_C 15			// ������ȯ
#define D_LONG 60		// ���� �Ÿ��� �ָ�
#define MOTOR_FAST 210
#define MOTOR_SLOW 150

int mode_arr[] = { 0, 1, 0, 1, 0, 2, 0, 2, 0, 2, 3, 4 };
int mode_index;
int mode;        // front(0), left(1), right(2), ���� �غ�(3), ���� ����(4)
int mode_change;    // don't change(0), change(1)
unsigned char i, j;

/* ���� */
void Init_Timer3A()
{
	TCCR3A = 0xAA; // FAST PWM
	TCCR3B = 0x1A; // 8����=0.5usec

	OCR3AH = 3000 >> 8;          // 1500usec=0��
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

/* ������ ���� */
#define Trigger1     PORTB.0 //������ Ʈ���� 
#define Trigger2     PORTB.0
#define Trigger3     PORTB.0

#define Echo1        PIND.0 //������ ����
#define Echo2        PIND.1
#define Echo3        PIND.2

unsigned int rightD;        // ������ 
unsigned int frontD;        // ����
unsigned int frontPastD;
unsigned int leftD;            // ����

unsigned int temp;
// unsigned int sonar_arr[3];

unsigned char rangeStr[5];

void getEchoFront() {
	while (!Echo1);//high�� �ɶ�
	TCNT1 = 0; TCCR1B = 2; //ī���ͽ��� , 0.5����
	while (Echo1);//low�� �ɶ�
	TCCR1B = 8; //ī���� ���� TCCR1B = 0�� ����
	frontD = TCNT1 / 116;//CM����
	TCNT1 = 0;
}
void getEchoRight()
{
	while (!Echo2);//high�� �ɶ�
	TCNT1 = 0; TCCR1B = 2; //ī���ͽ��� , 0.5����
	while (Echo2);//low�� �ɶ�
	TCCR1B = 8; //ī���� ���� TCCR1B = 0�� ����
	rightD = TCNT1 / 116;//CM����  
	TCNT1 = 0;
}
void getEchoLeft() {
	while (!Echo3);//high�� �ɶ�
	TCNT1 = 0; TCCR1B = 2; //ī���ͽ��� , 0.5����
	while (Echo3);//low�� �ɶ�
	TCCR1B = 8; //ī���� ���� TCCR1B = 0�� ����
	leftD = TCNT1 / 116;//CM����      
	TCNT1 = 0;
}
/* ������ ���� */

/* ���� */

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

	frontD = 0;
	frontPastD = 0;
	rightD = 0;
	leftD = 0;

	PORTE.3 = 0;

	/* DC Default */
	PORTB.5 = 1;
	PORTB.6 = 1;

	OCR0 = MOTOR_FAST;

	DC_front();
	/* DC Default */

	mode_index = 0;
	mode = 0;
	mode_change = 0;
	temp = 0;
	i = 0x00;
	j = 0x00;

	while (1) {
		frontPastD = frontD;
		if (mode_change) { mode_change = 0; mode_index++; mode = mode_arr[mode_index]; DC_start(); }
		get_sonar();

		switch (mode) {
		case 0:        // front
			if (frontD < D_A) {
				Servo_motor(0);
				Motor_slow();
				DC_back();

				mode_change = 1;
				delay_ms(1000);
				DC_stop();
			}
			else if (rightD > leftD) {
				if (rightD < D_A) { Servo_motor(-15); Motor_slow(); DC_front(); }
				else if (rightD < D_B) { Servo_motor(-5); Motor_fast(); DC_front(); }
				else { Servo_motor(0); Motor_fast(); DC_front(); }
			}
			else {
				if (leftD < D_A) { Servo_motor(15); Motor_slow(); DC_front(); }
				else if (leftD < D_B) { Servo_motor(5); Motor_fast(); DC_front(); }
				else { Servo_motor(0); Motor_fast(); DC_front(); }
			}
			break;
		case 1:        // left
			if (frontPastD > frontD) { DC_stop(); Servo_motor(0); Motor_slow(); mode_change = 1; delay_ms(100); }
			Servo_motor(-40);
			DC_Left();
			break;
		case 2:        // right
			if (frontPastD > frontD) { DC_stop(); Servo_motor(0); Motor_slow(); mode_change = 1; delay_ms(100); }
			Servo_motor(40);
			DC_Right();
			break;
		case 3:        // ���� �غ�
			if (rightD > leftD) {
				if (leftD < D_A) { Servo_motor(15); Motor_slow(); DC_front(); }
				else if (leftD < D_B) { Servo_motor(5); Motor_fast(); DC_front(); }
				else { Servo_motor(0); Motor_fast(); DC_front(); }
			}
			else {
				if (rightD < D_A) { Servo_motor(-15); Motor_slow(); DC_front(); }
				else if (rightD < D_B) { Servo_motor(-5); Motor_fast(); DC_front(); }
				else { Servo_motor(0); Motor_fast(); DC_front(); }

			}
			break;

		default:
			mode_change = 0;
			mode = 0;
		}

		delay_ms(1000);
	}
}
