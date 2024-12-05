
;CodeVisionAVR C Compiler V4.03 Evaluation
;(C) Copyright 1998-2024 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega128A
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128A
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPMCSR=0x68
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x80

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _sec_up=R5
	.DEF _sec_low=R4
	.DEF _input_index=R7
	.DEF _round=R6

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _external_int4
	JMP  _external_int5
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_key_options:
	.DB  0x41,0x53,0x44,0x57
_seg_pat:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x64,0x0,0x1,0x0

_0x3:
	.DB  0x1E,0x19,0x14,0xF,0xA
_0x0:
	.DB  0x57,0x65,0x6C,0x63,0x6F,0x6D,0x65,0x20
	.DB  0x74,0x6F,0x20,0x47,0x61,0x6D,0x65,0x0
	.DB  0x53,0x74,0x61,0x72,0x74,0x20,0x50,0x72
	.DB  0x65,0x73,0x73,0x20,0x4B,0x45,0x59,0x31
	.DB  0x0,0x59,0x6F,0x75,0x20,0x57,0x69,0x6E
	.DB  0x21,0x0,0x47,0x61,0x6D,0x65,0x20,0x4F
	.DB  0x76,0x65,0x72,0x21,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x05
	.DW  _time_limits
	.DW  _0x3*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI

	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x500

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG
;void Time_out(void);
;void LCD_init(void);
;void LCD_String(char flash*);
;void Busy(void);
;void Command(lcd_char);
;void Data(lcd_char);
;void GenerateRandomKeys(void);
;void DisplayPattern(void);
;void CheckUserInput(char);
;void NextRound(void);
;void GameOver(void);
;void ResetGame(void);
;void USART_Init(unsigned int);
;char USART_Receive(void);
;void USART_Transmit(char);
;void main(void) {
; 0000 002F void main(void) {

	.CSEG
_main:
; .FSTART _main
; 0000 0030 DDRB = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 0031 DDRD = 0xF0;
	OUT  0x11,R30
; 0000 0032 DDRG = 0x0F;
	LDI  R30,LOW(15)
	STS  100,R30
; 0000 0033 
; 0000 0034 EIMSK = 0b00110000;
	LDI  R30,LOW(48)
	OUT  0x39,R30
; 0000 0035 EICRB = 0b00001000;
	LDI  R30,LOW(8)
	OUT  0x3A,R30
; 0000 0036 SREG = 0x80;
	LDI  R30,LOW(128)
	OUT  0x3F,R30
; 0000 0037 
; 0000 0038 LCD_init();
	RCALL _LCD_init
; 0000 0039 LCD_String("Welcome to Game");
	__POINTW2FN _0x0,0
	RCALL _LCD_String
; 0000 003A Command(LINE2);
	LDI  R26,LOW(192)
	RCALL SUBOPT_0x0
; 0000 003B LCD_String("Start Press KEY1");
; 0000 003C 
; 0000 003D USART_Init(103);  // 9600bps
	LDI  R26,LOW(103)
	LDI  R27,0
	RCALL _USART_Init
; 0000 003E 
; 0000 003F while (1) {
_0x4:
; 0000 0040 if (timer_running) {
	SBRS R2,0
	RJMP _0x7
; 0000 0041 Time_out();
	RCALL _Time_out
; 0000 0042 
; 0000 0043 // USART 입력 처리
; 0000 0044 if (game_running && (UCSR0A & (1 << RXC0))) {
	SBRS R2,1
	RJMP _0x9
	SBIC 0xB,7
	RJMP _0xA
_0x9:
	RJMP _0x8
_0xA:
; 0000 0045 char received_char = USART_Receive();
; 0000 0046 CheckUserInput(received_char);
	SBIW R28,1
;	received_char -> Y+0
	RCALL _USART_Receive
	ST   Y,R30
	LD   R26,Y
	RCALL _CheckUserInput
; 0000 0047 USART_Transmit(received_char);
	LD   R26,Y
	RCALL _USART_Transmit
; 0000 0048 }
	ADIW R28,1
; 0000 0049 
; 0000 004A // 제한 시간 감소
; 0000 004B sec_low -= 1;
_0x8:
	DEC  R4
; 0000 004C if (sec_low == 0) {
	TST  R4
	BRNE _0xB
; 0000 004D sec_low = 100;
	LDI  R30,LOW(100)
	MOV  R4,R30
; 0000 004E if (sec_up > 0) {
	LDI  R30,LOW(0)
	CP   R30,R5
	BRSH _0xC
; 0000 004F sec_up -= 1;
	DEC  R5
; 0000 0050 }
; 0000 0051 else {
	RJMP _0xD
_0xC:
; 0000 0052 GameOver();  // 시간 초과 시 게임 종료
	RCALL _GameOver
; 0000 0053 }
_0xD:
; 0000 0054 }
; 0000 0055 }
_0xB:
; 0000 0056 }
_0x7:
	RJMP _0x4
; 0000 0057 }
_0xE:
	RJMP _0xE
; .FEND
;void USART_Init(unsigned int ubrr) {
; 0000 005A void USART_Init(unsigned int ubrr) {
_USART_Init:
; .FSTART _USART_Init
; 0000 005B UBRR0H = (unsigned char)(ubrr >> 8);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	ubrr -> R16,R17
	STS  144,R17
; 0000 005C UBRR0L = (unsigned char)ubrr;
	OUT  0x9,R16
; 0000 005D UCSR0B = (1 << RXEN0) | (1 << TXEN0);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 005E UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 005F }
	RJMP _0x2080003
; .FEND
;void USART_Transmit(char data) {
; 0000 0061 void USART_Transmit(char data) {
_USART_Transmit:
; .FSTART _USART_Transmit
; 0000 0062 while (!(UCSR0A & (1 << UDRE0)));
	ST   -Y,R17
	MOV  R17,R26
;	data -> R17
_0xF:
	SBIS 0xB,5
	RJMP _0xF
; 0000 0063 UDR0 = data;
	OUT  0xC,R17
; 0000 0064 }
	RJMP _0x2080002
; .FEND
;char USART_Receive(void) {
; 0000 0066 char USART_Receive(void) {
_USART_Receive:
; .FSTART _USART_Receive
; 0000 0067 while (!(UCSR0A & (1 << RXC0)));
_0x12:
	SBIS 0xB,7
	RJMP _0x12
; 0000 0068 return UDR0;
	IN   R30,0xC
	RET
; 0000 0069 }
; .FEND
;void GenerateRandomKeys(void) {
; 0000 006C void GenerateRandomKeys(void) {
_GenerateRandomKeys:
; .FSTART _GenerateRandomKeys
; 0000 006D int i;  // i를 int로 선언
; 0000 006E for (i = 0; i < 5; i++) {
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x16:
	__CPWRN 16,17,5
	BRGE _0x17
; 0000 006F random_keys[i] = key_options[rand() % 4];  // rand() 사용
	MOVW R30,R16
	SUBI R30,LOW(-_random_keys)
	SBCI R31,HIGH(-_random_keys)
	PUSH R31
	PUSH R30
	RCALL _rand
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	RCALL __MANDW12
	SUBI R30,LOW(-_key_options*2)
	SBCI R31,HIGH(-_key_options*2)
	LPM  R30,Z
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0070 }
	__ADDWRN 16,17,1
	RJMP _0x16
_0x17:
; 0000 0071 }
	RJMP _0x2080003
; .FEND
;void DisplayPattern(void) {
; 0000 0074 void DisplayPattern(void) {
_DisplayPattern:
; .FSTART _DisplayPattern
; 0000 0075 int i;  // 변수 선언을 for문 밖에서 먼저 선언
; 0000 0076 Command(ALLCLR);
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	LDI  R26,LOW(1)
	RCALL _Command
; 0000 0077 Command(LINE2);
	LDI  R26,LOW(192)
	RCALL _Command
; 0000 0078 
; 0000 0079 for (i = 0; i < 5; i++) {
	__GETWRN 16,17,0
_0x19:
	__CPWRN 16,17,5
	BRGE _0x1A
; 0000 007A Data(random_keys[i]);  // random_keys 배열의 각 문자 출력
	LDI  R26,LOW(_random_keys)
	LDI  R27,HIGH(_random_keys)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	RCALL _Data
; 0000 007B }
	__ADDWRN 16,17,1
	RJMP _0x19
_0x1A:
; 0000 007C }
	RJMP _0x2080003
; .FEND
;void CheckUserInput(char received_char) {
; 0000 007F void CheckUserInput(char received_char) {
_CheckUserInput:
; .FSTART _CheckUserInput
; 0000 0080 user_input[input_index] = received_char;
	ST   -Y,R17
	MOV  R17,R26
;	received_char -> R17
	RCALL SUBOPT_0x1
	ST   Z,R17
; 0000 0081 
; 0000 0082 if (user_input[input_index] == random_keys[input_index]) {
	RCALL SUBOPT_0x1
	LD   R26,Z
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_random_keys)
	SBCI R31,HIGH(-_random_keys)
	LD   R30,Z
	CP   R30,R26
	BRNE _0x1B
; 0000 0083 input_index++;
	INC  R7
; 0000 0084 if (input_index == 5) {
	LDI  R30,LOW(5)
	CP   R30,R7
	BRNE _0x1C
; 0000 0085 NextRound();  // 성공 시 다음 라운드로
	RCALL _NextRound
; 0000 0086 }
; 0000 0087 }
_0x1C:
; 0000 0088 else {
	RJMP _0x1D
_0x1B:
; 0000 0089 GameOver();  // 실패 시 게임 종료
	RCALL _GameOver
; 0000 008A }
_0x1D:
; 0000 008B }
	RJMP _0x2080002
; .FEND
;void NextRound(void) {
; 0000 008E void NextRound(void) {
_NextRound:
; .FSTART _NextRound
; 0000 008F round++;
	INC  R6
; 0000 0090 if (round > 5) {  // 5라운드 클리어
	LDI  R30,LOW(5)
	CP   R30,R6
	BRSH _0x1E
; 0000 0091 Command(ALLCLR);
	LDI  R26,LOW(1)
	RCALL _Command
; 0000 0092 LCD_String("You Win!");
	__POINTW2FN _0x0,33
	RCALL _LCD_String
; 0000 0093 timer_running = 0;
	CLT
	BLD  R2,0
; 0000 0094 game_running = 0;
	BLD  R2,1
; 0000 0095 }
; 0000 0096 else {
	RJMP _0x1F
_0x1E:
; 0000 0097 sec_up = time_limits[round - 1];
	MOV  R30,R6
	LDI  R31,0
	SBIW R30,1
	SUBI R30,LOW(-_time_limits)
	SBCI R31,HIGH(-_time_limits)
	LD   R5,Z
; 0000 0098 sec_low = 100;
	LDI  R30,LOW(100)
	MOV  R4,R30
; 0000 0099 input_index = 0;
	CLR  R7
; 0000 009A GenerateRandomKeys();
	RCALL _GenerateRandomKeys
; 0000 009B DisplayPattern();
	RCALL _DisplayPattern
; 0000 009C }
_0x1F:
; 0000 009D }
	RET
; .FEND
;void GameOver(void) {
; 0000 00A0 void GameOver(void) {
_GameOver:
; .FSTART _GameOver
; 0000 00A1 Command(ALLCLR);
	LDI  R26,LOW(1)
	RCALL _Command
; 0000 00A2 LCD_String("Game Over!");
	__POINTW2FN _0x0,42
	RCALL _LCD_String
; 0000 00A3 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 00A4 ResetGame();
	RCALL _ResetGame
; 0000 00A5 }
	RET
; .FEND
;void ResetGame(void) {
; 0000 00A8 void ResetGame(void) {
_ResetGame:
; .FSTART _ResetGame
; 0000 00A9 round = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 00AA sec_up = time_limits[0];
	RCALL SUBOPT_0x2
; 0000 00AB sec_low = 100;
; 0000 00AC input_index = 0;
	CLR  R7
; 0000 00AD game_running = 0;
	CLT
	BLD  R2,1
; 0000 00AE timer_running = 0;
	BLD  R2,0
; 0000 00AF 
; 0000 00B0 Command(ALLCLR);
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x0
; 0000 00B1 LCD_String("Start Press KEY1");
; 0000 00B2 }
	RET
; .FEND
;void Time_out(void) {
; 0000 00B5 void Time_out(void) {
_Time_out:
; .FSTART _Time_out
; 0000 00B6 PORTG = 0b00001000;
	LDI  R30,LOW(8)
	STS  101,R30
; 0000 00B7 PORTD = ((seg_pat[sec_low % 10] & 0x0F) << 4) | (PORTD & 0x0F);
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0000 00B8 PORTB = (seg_pat[sec_low % 10] & 0x70) | (PORTB & 0x0F);
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x5
; 0000 00B9 delay_us(2500);
; 0000 00BA PORTG = 0b00000100;
	LDI  R30,LOW(4)
	STS  101,R30
; 0000 00BB PORTD = ((seg_pat[sec_low / 10] & 0x0F) << 4) | (PORTD & 0x0F);
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x4
; 0000 00BC PORTB = (seg_pat[sec_low / 10] & 0x70) | (PORTB & 0x0F);
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x5
; 0000 00BD delay_us(2500);
; 0000 00BE PORTG = 0b00000010;
	LDI  R30,LOW(2)
	STS  101,R30
; 0000 00BF PORTD = ((seg_pat[sec_up % 10] & 0x0F) << 4) | (PORTD & 0x0F);
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x4
; 0000 00C0 PORTB = (seg_pat[sec_up % 10] & 0x70) | (PORTB & 0x0F);
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x5
; 0000 00C1 delay_us(2500);
; 0000 00C2 PORTG = 0b00000001;
	LDI  R30,LOW(1)
	STS  101,R30
; 0000 00C3 PORTD = ((seg_pat[sec_up / 10] & 0x0F) << 4) | (PORTD & 0x0F);
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x4
; 0000 00C4 PORTB = (seg_pat[sec_up / 10] & 0x70) | (PORTB & 0x0F);
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x5
; 0000 00C5 delay_us(2500);
; 0000 00C6 }
	RET
; .FEND
;void LCD_init(void) {
; 0000 00C9 void LCD_init(void) {
_LCD_init:
; .FSTART _LCD_init
; 0000 00CA DDRA = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 00CB PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00CC Command(0x20);
	LDI  R26,LOW(32)
	RCALL _Command
; 0000 00CD delay_ms(15);
	LDI  R26,LOW(15)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00CE Command(FUNCSET);
	LDI  R26,LOW(40)
	RCALL _Command
; 0000 00CF Command(DISPON);
	LDI  R26,LOW(12)
	RCALL _Command
; 0000 00D0 Command(ALLCLR);
	LDI  R26,LOW(1)
	RCALL _Command
; 0000 00D1 Command(ENTMODE);
	LDI  R26,LOW(6)
	RCALL _Command
; 0000 00D2 }
	RET
; .FEND
;void LCD_String(char flash* str) {
; 0000 00D4 void LCD_String(char flash* str) {
_LCD_String:
; .FSTART _LCD_String
; 0000 00D5 while (*str) Data(*str++);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	*str -> R16,R17
_0x20:
	MOVW R30,R16
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x22
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R26,Z
	RCALL _Data
	RJMP _0x20
_0x22:
; 0000 00D6 }
_0x2080003:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;void Command(lcd_char byte) {
; 0000 00D8 void Command(lcd_char byte) {
_Command:
; .FSTART _Command
; 0000 00D9 Busy();
	ST   -Y,R17
	MOV  R17,R26
;	byte -> R17
	RCALL _Busy
; 0000 00DA PORTA = 0x00;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x9
; 0000 00DB PORTA |= (byte & 0xF0);
; 0000 00DC delay_us(1);
; 0000 00DD ENABLE = 1;
; 0000 00DE delay_us(1);
; 0000 00DF ENABLE = 0;
; 0000 00E0 
; 0000 00E1 PORTA = 0x00;
	LDI  R30,LOW(0)
	RJMP _0x2080001
; 0000 00E2 PORTA |= (byte << 4);
; 0000 00E3 delay_us(1);
; 0000 00E4 ENABLE = 1;
; 0000 00E5 delay_us(1);
; 0000 00E6 ENABLE = 0;
; 0000 00E7 }
; .FEND
;void Data(lcd_char byte) {
; 0000 00E9 void Data(lcd_char byte) {
_Data:
; .FSTART _Data
; 0000 00EA Busy();
	ST   -Y,R17
	MOV  R17,R26
;	byte -> R17
	RCALL _Busy
; 0000 00EB PORTA = 0x01;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x9
; 0000 00EC PORTA |= (byte & 0xF0);
; 0000 00ED delay_us(1);
; 0000 00EE ENABLE = 1;
; 0000 00EF delay_us(1);
; 0000 00F0 ENABLE = 0;
; 0000 00F1 
; 0000 00F2 PORTA = 0x01;
	LDI  R30,LOW(1)
_0x2080001:
	OUT  0x1B,R30
; 0000 00F3 PORTA |= (byte << 4);
	IN   R30,0x1B
	MOV  R26,R30
	MOV  R30,R17
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R26
	OUT  0x1B,R30
; 0000 00F4 delay_us(1);
	__DELAY_USB 5
; 0000 00F5 ENABLE = 1;
	SBI  0x1B,2
; 0000 00F6 delay_us(1);
	__DELAY_USB 5
; 0000 00F7 ENABLE = 0;
	CBI  0x1B,2
; 0000 00F8 }
_0x2080002:
	LD   R17,Y+
	RET
; .FEND
;void Busy(void) {
; 0000 00FA void Busy(void) {
_Busy:
; .FSTART _Busy
; 0000 00FB delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00FC }
	RET
; .FEND
;interrupt[6] void external_int4(void) {
; 0000 00FF interrupt[6] void external_int4(void) {
_external_int4:
; .FSTART _external_int4
	RCALL SUBOPT_0xA
; 0000 0100 if (!game_running) {
	SBRC R2,1
	RJMP _0x33
; 0000 0101 timer_running = 1;
	SET
	BLD  R2,0
; 0000 0102 sec_up = time_limits[0];
	RCALL SUBOPT_0x2
; 0000 0103 sec_low = 100;
; 0000 0104 GenerateRandomKeys();
	RCALL _GenerateRandomKeys
; 0000 0105 DisplayPattern();
	RCALL _DisplayPattern
; 0000 0106 game_running = 1;
	SET
	BLD  R2,1
; 0000 0107 }
; 0000 0108 }
_0x33:
	RJMP _0x34
; .FEND
;interrupt[7] void external_int5(void) {
; 0000 010B interrupt[7] void external_int5(void) {
_external_int5:
; .FSTART _external_int5
	RCALL SUBOPT_0xA
; 0000 010C ResetGame();  // 게임 리셋
	RCALL _ResetGame
; 0000 010D }
_0x34:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.CSEG

	.DSEG

	.CSEG
_rand:
; .FSTART _rand
	LDS  R30,__seed_G100
	LDS  R31,__seed_G100+1
	LDS  R22,__seed_G100+2
	LDS  R23,__seed_G100+3
	__GETD2N 0x41C64E6D
	RCALL __MULD12U
	__ADDD1N 30562
	STS  __seed_G100,R30
	STS  __seed_G100+1,R31
	STS  __seed_G100+2,R22
	STS  __seed_G100+3,R23
	movw r30,r22
	andi r31,0x7F
	RET
; .FEND

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_time_limits:
	.BYTE 0x5
_random_keys:
	.BYTE 0x5
_user_input:
	.BYTE 0x5
__seed_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	RCALL _Command
	__POINTW2FN _0x0,16
	RJMP _LCD_String

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_user_input)
	SBCI R31,HIGH(-_user_input)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDS  R5,_time_limits
	LDI  R30,LOW(100)
	MOV  R4,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	MOV  R26,R4
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	SUBI R30,LOW(-_seg_pat*2)
	SBCI R31,HIGH(-_seg_pat*2)
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x4:
	ANDI R30,LOW(0xF)
	SWAP R30
	ANDI R30,0xF0
	MOV  R26,R30
	IN   R30,0x12
	ANDI R30,LOW(0xF)
	OR   R30,R26
	OUT  0x12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x5:
	ANDI R30,LOW(0x70)
	MOV  R26,R30
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USW 10000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	MOV  R26,R4
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	SUBI R30,LOW(-_seg_pat*2)
	SBCI R31,HIGH(-_seg_pat*2)
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	MOV  R26,R5
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	SUBI R30,LOW(-_seg_pat*2)
	SBCI R31,HIGH(-_seg_pat*2)
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	MOV  R26,R5
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	SUBI R30,LOW(-_seg_pat*2)
	SBCI R31,HIGH(-_seg_pat*2)
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x9:
	OUT  0x1B,R30
	IN   R30,0x1B
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 5
	SBI  0x1B,2
	__DELAY_USB 5
	CBI  0x1B,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xA:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;RUNTIME LIBRARY

	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__MULD12:
__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	NEG  R27
	NEG  R26
	SBCI R27,0
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
