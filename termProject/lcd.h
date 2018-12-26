#define LCD_WDATA PORTA // 인터럽트 헤더 파일
#define LCD_WISNT PORTA
#define LCD_CTRL PORTG //LCD 제어 포트 정의
#define LCD_EN 0 // LCD 제어 (PING 0~2)를 효과적으로 하기위한 정의
#define LCD_RW 1
#define LCD_RS 2
#define Byte unsigned char // 자주씡는 무부호 문자형 자료형을 bytr로 선언

void Port_Init(void) {
    DDRA = DDRA|0xff; // PORTA를 출력으로
    DDRG = DDRG|0x0f; // PORTG의 하위 4비트를 출력으로  	
}

void LCD_Data(Byte ch)
{
    LCD_CTRL |= (1<<LCD_RS);     //rs =1, r/w=0 으로 데이터 쓰기 싸이클 
    LCD_CTRL &= ~(1<<LCD_RW);
    LCD_CTRL |= (1<<LCD_EN);     //lcd 사용
    delay_us(50);
    LCD_WDATA = ch;              //데이터 출
    delay_us(50);
    LCD_CTRL &= ~(1<<LCD_EN);   //lcd사용안함 
}

void LCD_Comm(Byte ch)
{
    LCD_CTRL &= ~(1<<LCD_RS);     //rs =1, r/w=0 으로 데이터 쓰기 싸이클 
    LCD_CTRL &= ~(1<<LCD_RW);
    LCD_CTRL |= (1<<LCD_EN);     //lcd 사용
    delay_us(50);
    LCD_WISNT = ch;              //데이터 출
    delay_us(50);
    LCD_CTRL &= ~(1<<LCD_EN);   //lcd사용안함 
}
void LCD_CHAR(Byte c)
{
    LCD_Data(c);
    delay_ms(1);
}

void LCD_STR(Byte *str)
{
    while(*str != 0)
    {
        LCD_CHAR(*str);
        str++;
    }
}

void LCD_pos(unsigned char col, unsigned char row)
{
    LCD_Comm(0x80 | (row+col*0x40)); // row= 행 col= 열, DDRAM 주소설
}

void LCD_Clear(void)//화면 클리어
{
    LCD_Comm(0x01);
    delay_ms(2); //1.6ms 이상의 실행시간소요로 딜레이 필
}

void LCD_Init(void)
{
    LCD_Comm(0x38);    //데이터 8비트 사용 
    delay_ms(2);
    LCD_Comm(0x38);
    delay_ms(2);
    LCD_Comm(0x38);
    delay_ms(2);
    LCD_Comm(0x0e); //display ON/OFF
    delay_ms(2);
    LCD_Comm(0x06); //주소+1 커서를 우측으로 이동(3)
    delay_ms(2);
    LCD_Clear();
}

void Port_Init(void); 
void LCD_Data(Byte ch);
void LCD_Comm(Byte ch);
void LCD_CHAR(Byte c);
void LCD_STR(Byte *str);
void LCD_pos(unsigned char col, unsigned char row);
void LCD_Clear(void);
void LCD_Init(void);