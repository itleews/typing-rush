#include <mega128.h>
#include <delay.h>
#include <stdlib.h>

// ���� ���� ����
#define ENABLE PORTA.2
#define FUNCSET 0x28
#define ENTMODE 0x06
#define ALLCLR 0x01
#define DISPON 0x0c
#define LINE2 0xC0

typedef unsigned char u_char;
typedef unsigned char lcd_char;

// ������ Ű ���� ����
flash char key_options[4] = { 'A', 'S', 'D', 'W' };
flash u_char seg_pat[10] = { 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f };

u_char sec_up = 0, sec_low = 100;  // ��/��
u_char time_limits[5] = { 30, 25, 20, 15, 10 };  // �� ���� ���� �ð�
bit timer_running = 0;  // Ÿ�̸� ����
bit game_running = 0;   // ���� ����
char random_keys[5];  // ���庰 ����
char user_input[5];
u_char input_index = 0;
u_char round = 1;  // ���� ���� (1���� ����)

// �Լ� ����
void Time_out(void);
void LCD_init(void);
void LCD_String(char flash*);
void Busy(void);
void Command(lcd_char);
void Data(lcd_char);
void GenerateRandomKeys(void);
void DisplayPattern(void);
void CheckUserInput(char);
void NextRound(void);
void GameOver(void);
void ResetGame(void);
void USART_Init(unsigned int);
char USART_Receive(void);
void USART_Transmit(char);

// ���� �Լ�
void main(void) {
    DDRB = 0xF0;
    DDRD = 0xF0;
    DDRG = 0x0F;

    EIMSK = 0b00110000;
    EICRB = 0b00001000;
    SREG = 0x80;

    LCD_init();
    LCD_String("Time Attack Typing");  // ���� ����
    Command(LINE2);                    // �� ��° �ٷ� �̵�

    while (1) {
        LCD_String("Press KEY1 to Start");  // 'Press KEY1 to Start' ǥ��
        delay_ms(500);                     // 500ms ���

        Command(ALLCLR);                   // ȭ�� �����
        delay_ms(500);                     // 500ms ���
    }

    USART_Init(103);  // 9600bps

    while (1) {
        if (timer_running) {
            Time_out();

            // USART �Է� ó��
            if (game_running && (UCSR0A & (1 << RXC0))) {
                char received_char = USART_Receive();
                CheckUserInput(received_char);
                USART_Transmit(received_char);
            }

            // ���� �ð� ����
            sec_low -= 1;
            if (sec_low == 0) {
                sec_low = 100;
                if (sec_up > 0) {
                    sec_up -= 1;
                }
                else {
                    GameOver();  // �ð� �ʰ� �� ���� ����
                }
            }
        }
    }
}

// USART �ʱ�ȭ
void USART_Init(unsigned int ubrr) {
    UBRR0H = (unsigned char)(ubrr >> 8);
    UBRR0L = (unsigned char)ubrr;
    UCSR0B = (1 << RXEN0) | (1 << TXEN0);
    UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);
}

void USART_Transmit(char data) {
    while (!(UCSR0A & (1 << UDRE0)));
    UDR0 = data;
}

char USART_Receive(void) {
    while (!(UCSR0A & (1 << RXC0)));
    return UDR0;
}

// ���� ����
void GenerateRandomKeys(void) {
    int i;  // i�� int�� ����
    for (i = 0; i < 5; i++) {
        random_keys[i] = key_options[rand() % 4];  // rand() ���
    }
}

// LCD�� ���� ǥ��
void DisplayPattern(void) {
    int i;  // ���� ������ for�� �ۿ��� ���� ����
    Command(ALLCLR);
    Command(LINE2);

    for (i = 0; i < 5; i++) {
        Data(random_keys[i]);  // random_keys �迭�� �� ���� ���
    }
}

// ����� �Է� ó��
void CheckUserInput(char received_char) {
    user_input[input_index] = received_char;

    if (user_input[input_index] == random_keys[input_index]) {
        input_index++;
        if (input_index == 5) {
            NextRound();  // ���� �� ���� �����
        }
    }
    else {
        GameOver();  // ���� �� ���� ����
    }
}

// ���� ���� ó��
void NextRound(void) {
    round++;
    if (round > 5) {  // 5���� Ŭ����
        Command(ALLCLR);
        LCD_String("You Win!");
        timer_running = 0;
        game_running = 0;
    }
    else {
        sec_up = time_limits[round - 1];
        sec_low = 100;
        input_index = 0;
        GenerateRandomKeys();
        DisplayPattern();
    }
}

// ���� ���� ó��
void GameOver(void) {
    Command(ALLCLR);
    LCD_String("Game Over!");
    delay_ms(2000);
    ResetGame();
}

// ���� �����
void ResetGame(void) {
    round = 1;
    sec_up = time_limits[0];
    sec_low = 100;
    input_index = 0;
    game_running = 0;
    timer_running = 0;

    Command(ALLCLR);
    LCD_String("Start Press KEY1");
}

// 7���׸�Ʈ ǥ��
void Time_out(void) {
    PORTG = 0b00001000;
    PORTD = ((seg_pat[sec_low % 10] & 0x0F) << 4) | (PORTD & 0x0F);
    PORTB = (seg_pat[sec_low % 10] & 0x70) | (PORTB & 0x0F);
    delay_us(2500);
    PORTG = 0b00000100;
    PORTD = ((seg_pat[sec_low / 10] & 0x0F) << 4) | (PORTD & 0x0F);
    PORTB = (seg_pat[sec_low / 10] & 0x70) | (PORTB & 0x0F);
    delay_us(2500);
    PORTG = 0b00000010;
    PORTD = ((seg_pat[sec_up % 10] & 0x0F) << 4) | (PORTD & 0x0F);
    PORTB = (seg_pat[sec_up % 10] & 0x70) | (PORTB & 0x0F);
    delay_us(2500);
    PORTG = 0b00000001;
    PORTD = ((seg_pat[sec_up / 10] & 0x0F) << 4) | (PORTD & 0x0F);
    PORTB = (seg_pat[sec_up / 10] & 0x70) | (PORTB & 0x0F);
    delay_us(2500);
}

// LCD �ʱ�ȭ
void LCD_init(void) {
    DDRA = 0xFF;
    PORTA = 0x00;
    Command(0x20);
    delay_ms(15);
    Command(FUNCSET);
    Command(DISPON);
    Command(ALLCLR);
    Command(ENTMODE);
}

void LCD_String(char flash* str) {
    while (*str) Data(*str++);
}

void Command(lcd_char byte) {
    Busy();
    PORTA = 0x00;
    PORTA |= (byte & 0xF0);
    delay_us(1);
    ENABLE = 1;
    delay_us(1);
    ENABLE = 0;

    PORTA = 0x00;
    PORTA |= (byte << 4);
    delay_us(1);
    ENABLE = 1;
    delay_us(1);
    ENABLE = 0;
}

void Data(lcd_char byte) {
    Busy();
    PORTA = 0x01;
    PORTA |= (byte & 0xF0);
    delay_us(1);
    ENABLE = 1;
    delay_us(1);
    ENABLE = 0;

    PORTA = 0x01;
    PORTA |= (byte << 4);
    delay_us(1);
    ENABLE = 1;
    delay_us(1);
    ENABLE = 0;
}

void Busy(void) {
    delay_ms(2);
}

// �ܺ� ���ͷ�Ʈ�� ���� ����
interrupt[EXT_INT4] void external_int4(void) {
    if (!game_running) {
        timer_running = 1;
        sec_up = time_limits[0];
        sec_low = 100;
        GenerateRandomKeys();
        DisplayPattern();
        game_running = 1;
    }
}

// ���ͷ�Ʈ �ʱ�ȭ
interrupt[EXT_INT5] void external_int5(void) {
    ResetGame();  // ���� ����
}