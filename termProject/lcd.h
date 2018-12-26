#define LCD_WDATA PORTA // ���ͷ�Ʈ ��� ����
#define LCD_WISNT PORTA
#define LCD_CTRL PORTG //LCD ���� ��Ʈ ����
#define LCD_EN 0 // LCD ���� (PING 0~2)�� ȿ�������� �ϱ����� ����
#define LCD_RW 1
#define LCD_RS 2
#define Byte unsigned char // ���֝��� ����ȣ ������ �ڷ����� bytr�� ����

void Port_Init(void) {
    DDRA = DDRA|0xff; // PORTA�� �������
    DDRG = DDRG|0x0f; // PORTG�� ���� 4��Ʈ�� �������  	
}

void LCD_Data(Byte ch)
{
    LCD_CTRL |= (1<<LCD_RS);     //rs =1, r/w=0 ���� ������ ���� ����Ŭ 
    LCD_CTRL &= ~(1<<LCD_RW);
    LCD_CTRL |= (1<<LCD_EN);     //lcd ���
    delay_us(50);
    LCD_WDATA = ch;              //������ ��
    delay_us(50);
    LCD_CTRL &= ~(1<<LCD_EN);   //lcd������ 
}

void LCD_Comm(Byte ch)
{
    LCD_CTRL &= ~(1<<LCD_RS);     //rs =1, r/w=0 ���� ������ ���� ����Ŭ 
    LCD_CTRL &= ~(1<<LCD_RW);
    LCD_CTRL |= (1<<LCD_EN);     //lcd ���
    delay_us(50);
    LCD_WISNT = ch;              //������ ��
    delay_us(50);
    LCD_CTRL &= ~(1<<LCD_EN);   //lcd������ 
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
    LCD_Comm(0x80 | (row+col*0x40)); // row= �� col= ��, DDRAM �ּҼ�
}

void LCD_Clear(void)//ȭ�� Ŭ����
{
    LCD_Comm(0x01);
    delay_ms(2); //1.6ms �̻��� ����ð��ҿ�� ������ ��
}

void LCD_Init(void)
{
    LCD_Comm(0x38);    //������ 8��Ʈ ��� 
    delay_ms(2);
    LCD_Comm(0x38);
    delay_ms(2);
    LCD_Comm(0x38);
    delay_ms(2);
    LCD_Comm(0x0e); //display ON/OFF
    delay_ms(2);
    LCD_Comm(0x06); //�ּ�+1 Ŀ���� �������� �̵�(3)
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