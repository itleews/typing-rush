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
flash char key_options[8] = { 'Q', 'W', 'E', 'R', 'A', 'S', 'D', 'F' };
flash u_char seg_pat[10] = { 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f };

u_char sec_up = 0, sec_low = 100;  // ��/��
u_char time_limits[5] = { 15, 10, 7, 5, 3 };  // �� ���� ���� �ð�
bit timer_running = 0;  // Ÿ�̸� ����
bit game_running = 0;   // ���� ����
char random_keys[5];  // ���庰 ����
char user_input[5];
u_char input_index = 0;
u_char round = 1;  // ���� ���� (1���� ����)
u_char success_count = 0; // ���� Ƚ��

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
void DisplayUserInput(void);
void NextAttempt(void);

// ���� �Լ�
void main(void) {
    DDRB = 0xF0;
    DDRD = 0xF0;
    DDRG = 0x0F;

    EIMSK = 0b00110000;
    EICRB = 0b00001000;
    SREG = 0x80;

    LCD_init();
    LCD_String("Typing Rush!");  // ���� ����
    Command(LINE2);
    LCD_String("Start Press KEY1"); 
    delay_ms(500);

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
        random_keys[i] = key_options[rand() % 8];  // rand() ���
    }
}

// LCD�� ���� ǥ��
void DisplayPattern(void) {
    int i;  // ���� ������ for�� �ۿ��� ���� ����
    Command(ALLCLR);
    for (i = 0; i < 5; i++) {
        LCD_String("[");
        Data(random_keys[i]);  // random_keys �迭�� �� ���� ���
        LCD_String("]");
    }
}

// ����� �Է� ó��
void CheckUserInput(char received_char) {
    user_input[input_index] = received_char;  // ����� �Է� ����
    input_index++;  // �Է� �ε��� ����

    DisplayUserInput();  // ����� �Է� ǥ��

    if (received_char == random_keys[input_index - 1]) {  // �ùٸ� �Է�
        if (input_index == 5) {  // �� �� �Է� �Ϸ�
            success_count++;
            if (success_count == 3) {  // 3�� ���� �� ���� ����
                NextRound();
            } else {
                Command(LINE2);
                LCD_String("      Hit!      ");
                delay_ms(500);
                NextAttempt();  // ���ο� �� ǥ��
            }
        }
    } else {  // Ʋ�� �Է�
        Command(LINE2);
        LCD_String("     Miss!     ");
        delay_ms(500);
        NextAttempt();  // ���ο� �� ǥ��
    }
}

// ���ο� �õ� (Ʋ���ų� �� �� �Ϸ� �� ȣ��)
void NextAttempt(void) {
    input_index = 0;  // �Է� �ε��� �ʱ�ȭ
    GenerateRandomKeys();  // ���ο� ���� ����
    DisplayPattern();  // ���� ǥ��
}


// ����� �Է��� LCD �� ��° �ٿ� ǥ���ϴ� �Լ�
void DisplayUserInput(void) {
    int i;

    // �� ��° �ٷ� Ŀ�� �̵�
    Command(LINE2);

    // �Էµ� ���ڵ��� ���������� LCD�� ǥ��
    for (i = 0; i < input_index; i++) {
        LCD_String("<");
        Data(user_input[i]);
        LCD_String(">");
    }
}


// ���� ���� ó��
void NextRound(void) {
    round++;
    if (round > 5) {  // 5���� Ŭ����
        Command(ALLCLR);
        LCD_String("You Win!");
        Command(LINE2);
        delay_ms(2000);
        ResetGame();
    }
    else {
        // ���� ���� �� LCD�� "ROUND (����)" ���
        Command(ALLCLR);  // ȭ�� �����
        LCD_String("<ROUND ");
        Data('0' + round);  // ���� ǥ��
        LCD_String(">");    // ">" ǥ��
        Command(LINE2);
        LCD_String("3 Hits in ");
        Data('0' + time_limits[round - 1] / 10);  // 10�� �ڸ�
        Data('0' + time_limits[round - 1] % 10);  // 1�� �ڸ�
        LCD_String("s");
        delay_ms(1000);     // ��� ��� �� ���� ����

        sec_up = time_limits[round - 1];
        sec_low = 100;
        input_index = 0;
        success_count = 0;  // ���� Ƚ�� �ʱ�ȭ
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
    success_count = 0;
    game_running = 0;
    timer_running = 0;
    
    Command(LINE2);
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
        Command(ALLCLR);  // ȭ�� �����
        LCD_String("<ROUND 1>");
        Command(LINE2);
        LCD_String("3 Hits in 15s");
        delay_ms(1000);
        GenerateRandomKeys();
        DisplayPattern();
        game_running = 1;
    }
}

// ���ͷ�Ʈ �ʱ�ȭ
interrupt[EXT_INT5] void external_int5(void) {
    ResetGame();  // ���� ����
    main();
}
