#include <mega128.h>
#include <delay.h>
#include <stdlib.h>

// 기존 정의 유지
#define ENABLE PORTA.2
#define FUNCSET 0x28
#define ENTMODE 0x06
#define ALLCLR 0x01
#define DISPON 0x0c
#define LINE2 0xC0

typedef unsigned char u_char;
typedef unsigned char lcd_char;

// 무작위 키 패턴 정의
flash char key_options[8] = { 'Q', 'W', 'E', 'R', 'A', 'S', 'D', 'F' };
flash u_char seg_pat[10] = { 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f };

u_char sec_up = 0, sec_low = 100;  // 분/초
u_char time_limits[5] = { 15, 10, 7, 5, 3 };  // 각 라운드 제한 시간
bit timer_running = 0;  // 타이머 상태
bit game_running = 0;   // 게임 상태
char random_keys[5];  // 라운드별 패턴
char user_input[5];
u_char input_index = 0;
u_char round = 1;  // 현재 라운드 (1부터 시작)
u_char success_count = 0; // 성공 횟수

// 함수 선언
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

// 메인 함수
void main(void) {
    DDRB = 0xF0;
    DDRD = 0xF0;
    DDRG = 0x0F;

    EIMSK = 0b00110000;
    EICRB = 0b00001000;
    SREG = 0x80;

    LCD_init();
    LCD_String("Typing Rush!");  // 게임 제목
    Command(LINE2);
    LCD_String("Start Press KEY1"); 
    delay_ms(500);

    USART_Init(103);  // 9600bps

    while (1) {
        if (timer_running) {
            Time_out();

            // USART 입력 처리
            if (game_running && (UCSR0A & (1 << RXC0))) {
                char received_char = USART_Receive();
                CheckUserInput(received_char);
                USART_Transmit(received_char);
            }

            // 제한 시간 감소
            sec_low -= 1;
            if (sec_low == 0) {
                sec_low = 100;
                if (sec_up > 0) {
                    sec_up -= 1;
                }
                else {
                    GameOver();  // 시간 초과 시 게임 종료
                }
            }
        }
    }
}

// USART 초기화
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

// 패턴 생성
void GenerateRandomKeys(void) {
    int i;  // i를 int로 선언
    for (i = 0; i < 5; i++) {
        random_keys[i] = key_options[rand() % 8];  // rand() 사용
    }
}

// LCD에 패턴 표시
void DisplayPattern(void) {
    int i;  // 변수 선언을 for문 밖에서 먼저 선언
    Command(ALLCLR);
    for (i = 0; i < 5; i++) {
        LCD_String("[");
        Data(random_keys[i]);  // random_keys 배열의 각 문자 출력
        LCD_String("]");
    }
}

// 사용자 입력 처리
void CheckUserInput(char received_char) {
    user_input[input_index] = received_char;  // 사용자 입력 저장
    input_index++;  // 입력 인덱스 증가

    DisplayUserInput();  // 사용자 입력 표시

    if (received_char == random_keys[input_index - 1]) {  // 올바른 입력
        if (input_index == 5) {  // 한 줄 입력 완료
            success_count++;
            if (success_count == 3) {  // 3번 성공 시 다음 라운드
                NextRound();
            } else {
                Command(LINE2);
                LCD_String("      Hit!      ");
                delay_ms(500);
                NextAttempt();  // 새로운 줄 표시
            }
        }
    } else {  // 틀린 입력
        Command(LINE2);
        LCD_String("     Miss!     ");
        delay_ms(500);
        NextAttempt();  // 새로운 줄 표시
    }
}

// 새로운 시도 (틀리거나 한 줄 완료 시 호출)
void NextAttempt(void) {
    input_index = 0;  // 입력 인덱스 초기화
    GenerateRandomKeys();  // 새로운 패턴 생성
    DisplayPattern();  // 패턴 표시
}


// 사용자 입력을 LCD 두 번째 줄에 표시하는 함수
void DisplayUserInput(void) {
    int i;

    // 두 번째 줄로 커서 이동
    Command(LINE2);

    // 입력된 문자들을 순차적으로 LCD에 표시
    for (i = 0; i < input_index; i++) {
        LCD_String("<");
        Data(user_input[i]);
        LCD_String(">");
    }
}


// 라운드 성공 처리
void NextRound(void) {
    round++;
    if (round > 5) {  // 5라운드 클리어
        Command(ALLCLR);
        LCD_String("You Win!");
        Command(LINE2);
        delay_ms(2000);
        ResetGame();
    }
    else {
        // 라운드 시작 시 LCD에 "ROUND (숫자)" 출력
        Command(ALLCLR);  // 화면 지우기
        LCD_String("<ROUND ");
        Data('0' + round);  // 숫자 표시
        LCD_String(">");    // ">" 표시
        Command(LINE2);
        LCD_String("3 Hits in ");
        Data('0' + time_limits[round - 1] / 10);  // 10의 자리
        Data('0' + time_limits[round - 1] % 10);  // 1의 자리
        LCD_String("s");
        delay_ms(1000);     // 잠시 대기 후 라운드 진행

        sec_up = time_limits[round - 1];
        sec_low = 100;
        input_index = 0;
        success_count = 0;  // 성공 횟수 초기화
        GenerateRandomKeys();
        DisplayPattern();
    }
}


// 게임 실패 처리
void GameOver(void) {
    Command(ALLCLR);
    LCD_String("Game Over!");
    delay_ms(2000);
    ResetGame();
}

// 게임 재시작
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


// 7세그먼트 표시
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

// LCD 초기화
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

// 외부 인터럽트로 게임 시작
interrupt[EXT_INT4] void external_int4(void) {
    if (!game_running) {
        timer_running = 1;
        sec_up = time_limits[0];
        sec_low = 100;
        Command(ALLCLR);  // 화면 지우기
        LCD_String("<ROUND 1>");
        Command(LINE2);
        LCD_String("3 Hits in 15s");
        delay_ms(1000);
        GenerateRandomKeys();
        DisplayPattern();
        game_running = 1;
    }
}

// 인터럽트 초기화
interrupt[EXT_INT5] void external_int5(void) {
    ResetGame();  // 게임 리셋
    main();
}
