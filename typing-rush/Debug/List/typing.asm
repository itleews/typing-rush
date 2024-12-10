
;CodeVisionAVR C Compiler V3.23a Evaluation
;(C) Copyright 1998-2015 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
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
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
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
	.DEF _success_count=R9

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
	.DB  0x51,0x57,0x45,0x52,0x41,0x53,0x44,0x46
_seg_pat:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x64,0x0,0x1,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0xF,0xA,0x7,0x5,0x3
_0x0:
	.DB  0x54,0x79,0x70,0x69,0x6E,0x67,0x20,0x52
	.DB  0x75,0x73,0x68,0x21,0x0,0x53,0x74,0x61
	.DB  0x72,0x74,0x20,0x50,0x72,0x65,0x73,0x73
	.DB  0x20,0x4B,0x45,0x59,0x31,0x0,0x5B,0x0
	.DB  0x5D,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x48,0x69,0x74,0x21,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x4D,0x69,0x73,0x73,0x21,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x3C,0x0,0x3E,0x0,0x59
	.DB  0x6F,0x75,0x20,0x57,0x69,0x6E,0x21,0x0
	.DB  0x3C,0x52,0x4F,0x55,0x4E,0x44,0x20,0x0
	.DB  0x33,0x20,0x48,0x69,0x74,0x73,0x20,0x69
	.DB  0x6E,0x20,0x0,0x73,0x0,0x47,0x61,0x6D
	.DB  0x65,0x20,0x4F,0x76,0x65,0x72,0x21,0x0
	.DB  0x3C,0x52,0x4F,0x55,0x4E,0x44,0x20,0x31
	.DB  0x3E,0x0,0x33,0x20,0x48,0x69,0x74,0x73
	.DB  0x20,0x69,0x6E,0x20,0x31,0x35,0x73,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
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
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;#include <mega128.h>
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
;#include <delay.h>
;#include <stdlib.h>
;
;// 기존 정의 유지
;#define ENABLE PORTA.2
;#define FUNCSET 0x28
;#define ENTMODE 0x06
;#define ALLCLR 0x01
;#define DISPON 0x0c
;#define LINE2 0xC0
;
;typedef unsigned char u_char;
;typedef unsigned char lcd_char;
;
;// 무작위 키 패턴 정의
;flash char key_options[8] = { 'Q', 'W', 'E', 'R', 'A', 'S', 'D', 'F' };
;flash u_char seg_pat[10] = { 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x07, 0x7f, 0x6f };
;
;u_char sec_up = 0, sec_low = 100;  // 분/초
;u_char time_limits[5] = { 15, 10, 7, 5, 3 };  // 각 라운드 제한 시간

	.DSEG
;bit timer_running = 0;  // 타이머 상태
;bit game_running = 0;   // 게임 상태
;char random_keys[5];  // 라운드별 패턴
;char user_input[5];
;u_char input_index = 0;
;u_char round = 1;  // 현재 라운드 (1부터 시작)
;u_char success_count = 0; // 성공 횟수
;
;// 함수 선언
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
;void DisplayUserInput(void);
;void NextAttempt(void);
;
;// 메인 함수
;void main(void) {
; 0000 0032 void main(void) {

	.CSEG
_main:
; .FSTART _main
; 0000 0033     DDRB = 0xF0;
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 0034     DDRD = 0xF0;
	OUT  0x11,R30
; 0000 0035     DDRG = 0x0F;
	LDI  R30,LOW(15)
	STS  100,R30
; 0000 0036 
; 0000 0037     EIMSK = 0b00110000;
	LDI  R30,LOW(48)
	OUT  0x39,R30
; 0000 0038     EICRB = 0b00001000;
	LDI  R30,LOW(8)
	OUT  0x3A,R30
; 0000 0039     SREG = 0x80;
	LDI  R30,LOW(128)
	OUT  0x3F,R30
; 0000 003A 
; 0000 003B     LCD_init();
	RCALL _LCD_init
; 0000 003C     LCD_String("Typing Rush!");  // 게임 제목
	__POINTW2FN _0x0,0
	RCALL _LCD_String
; 0000 003D     Command(LINE2);
	RCALL SUBOPT_0x0
; 0000 003E     LCD_String("Start Press KEY1");
; 0000 003F     delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0040 
; 0000 0041     USART_Init(103);  // 9600bps
	LDI  R26,LOW(103)
	LDI  R27,0
	RCALL _USART_Init
; 0000 0042 
; 0000 0043     while (1) {
_0x4:
; 0000 0044         if (timer_running) {
	SBRS R2,0
	RJMP _0x7
; 0000 0045             Time_out();
	RCALL _Time_out
; 0000 0046 
; 0000 0047             // USART 입력 처리
; 0000 0048             if (game_running && (UCSR0A & (1 << RXC0))) {
	SBRS R2,1
	RJMP _0x9
	SBIC 0xB,7
	RJMP _0xA
_0x9:
	RJMP _0x8
_0xA:
; 0000 0049                 char received_char = USART_Receive();
; 0000 004A                 CheckUserInput(received_char);
	SBIW R28,1
;	received_char -> Y+0
	RCALL _USART_Receive
	ST   Y,R30
	LD   R26,Y
	RCALL _CheckUserInput
; 0000 004B                 USART_Transmit(received_char);
	LD   R26,Y
	RCALL _USART_Transmit
; 0000 004C             }
	ADIW R28,1
; 0000 004D 
; 0000 004E             // 제한 시간 감소
; 0000 004F             sec_low -= 1;
_0x8:
	DEC  R4
; 0000 0050             if (sec_low == 0) {
	TST  R4
	BRNE _0xB
; 0000 0051                 sec_low = 100;
	LDI  R30,LOW(100)
	MOV  R4,R30
; 0000 0052                 if (sec_up > 0) {
	LDI  R30,LOW(0)
	CP   R30,R5
	BRSH _0xC
; 0000 0053                     sec_up -= 1;
	DEC  R5
; 0000 0054                 }
; 0000 0055                 else {
	RJMP _0xD
_0xC:
; 0000 0056                     GameOver();  // 시간 초과 시 게임 종료
	RCALL _GameOver
; 0000 0057                 }
_0xD:
; 0000 0058             }
; 0000 0059         }
_0xB:
; 0000 005A     }
_0x7:
	RJMP _0x4
; 0000 005B }
_0xE:
	RJMP _0xE
; .FEND
;
;// USART 초기화
;void USART_Init(unsigned int ubrr) {
; 0000 005E void USART_Init(unsigned int ubrr) {
_USART_Init:
; .FSTART _USART_Init
; 0000 005F     UBRR0H = (unsigned char)(ubrr >> 8);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	ubrr -> R16,R17
	STS  144,R17
; 0000 0060     UBRR0L = (unsigned char)ubrr;
	OUT  0x9,R16
; 0000 0061     UCSR0B = (1 << RXEN0) | (1 << TXEN0);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0062     UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0063 }
	RJMP _0x2080003
; .FEND
;
;void USART_Transmit(char data) {
; 0000 0065 void USART_Transmit(char data) {
_USART_Transmit:
; .FSTART _USART_Transmit
; 0000 0066     while (!(UCSR0A & (1 << UDRE0)));
	ST   -Y,R17
	MOV  R17,R26
;	data -> R17
_0xF:
	SBIS 0xB,5
	RJMP _0xF
; 0000 0067     UDR0 = data;
	OUT  0xC,R17
; 0000 0068 }
	RJMP _0x2080002
; .FEND
;
;char USART_Receive(void) {
; 0000 006A char USART_Receive(void) {
_USART_Receive:
; .FSTART _USART_Receive
; 0000 006B     while (!(UCSR0A & (1 << RXC0)));
_0x12:
	SBIS 0xB,7
	RJMP _0x12
; 0000 006C     return UDR0;
	IN   R30,0xC
	RET
; 0000 006D }
; .FEND
;
;// 패턴 생성
;void GenerateRandomKeys(void) {
; 0000 0070 void GenerateRandomKeys(void) {
_GenerateRandomKeys:
; .FSTART _GenerateRandomKeys
; 0000 0071     int i;  // i를 int로 선언
; 0000 0072     for (i = 0; i < 5; i++) {
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x16:
	__CPWRN 16,17,5
	BRGE _0x17
; 0000 0073         random_keys[i] = key_options[rand() % 8];  // rand() 사용
	MOVW R30,R16
	SUBI R30,LOW(-_random_keys)
	SBCI R31,HIGH(-_random_keys)
	PUSH R31
	PUSH R30
	RCALL _rand
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	RCALL __MANDW12
	SUBI R30,LOW(-_key_options*2)
	SBCI R31,HIGH(-_key_options*2)
	LPM  R30,Z
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0074     }
	__ADDWRN 16,17,1
	RJMP _0x16
_0x17:
; 0000 0075 }
	RJMP _0x2080003
; .FEND
;
;// LCD에 패턴 표시
;void DisplayPattern(void) {
; 0000 0078 void DisplayPattern(void) {
_DisplayPattern:
; .FSTART _DisplayPattern
; 0000 0079     int i;  // 변수 선언을 for문 밖에서 먼저 선언
; 0000 007A     Command(ALLCLR);
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	LDI  R26,LOW(1)
	RCALL _Command
; 0000 007B     for (i = 0; i < 5; i++) {
	__GETWRN 16,17,0
_0x19:
	__CPWRN 16,17,5
	BRGE _0x1A
; 0000 007C         LCD_String("[");
	__POINTW2FN _0x0,30
	RCALL _LCD_String
; 0000 007D         Data(random_keys[i]);  // random_keys 배열의 각 문자 출력
	LDI  R26,LOW(_random_keys)
	LDI  R27,HIGH(_random_keys)
	RCALL SUBOPT_0x1
; 0000 007E         LCD_String("]");
	__POINTW2FN _0x0,32
	RCALL _LCD_String
; 0000 007F     }
	__ADDWRN 16,17,1
	RJMP _0x19
_0x1A:
; 0000 0080 }
	RJMP _0x2080003
; .FEND
;
;// 사용자 입력 처리
;void CheckUserInput(char received_char) {
; 0000 0083 void CheckUserInput(char received_char) {
_CheckUserInput:
; .FSTART _CheckUserInput
; 0000 0084     user_input[input_index] = received_char;  // 사용자 입력 저장
	ST   -Y,R17
	MOV  R17,R26
;	received_char -> R17
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_user_input)
	SBCI R31,HIGH(-_user_input)
	ST   Z,R17
; 0000 0085     input_index++;  // 입력 인덱스 증가
	INC  R7
; 0000 0086 
; 0000 0087     DisplayUserInput();  // 사용자 입력 표시
	RCALL _DisplayUserInput
; 0000 0088 
; 0000 0089     if (received_char == random_keys[input_index - 1]) {  // 올바른 입력
	MOV  R30,R7
	LDI  R31,0
	SBIW R30,1
	SUBI R30,LOW(-_random_keys)
	SBCI R31,HIGH(-_random_keys)
	LD   R30,Z
	CP   R30,R17
	BRNE _0x1B
; 0000 008A         if (input_index == 5) {  // 한 줄 입력 완료
	LDI  R30,LOW(5)
	CP   R30,R7
	BRNE _0x1C
; 0000 008B             success_count++;
	INC  R9
; 0000 008C             if (success_count == 3) {  // 3번 성공 시 다음 라운드
	LDI  R30,LOW(3)
	CP   R30,R9
	BRNE _0x1D
; 0000 008D                 NextRound();
	RCALL _NextRound
; 0000 008E             } else {
	RJMP _0x1E
_0x1D:
; 0000 008F                 Command(LINE2);
	LDI  R26,LOW(192)
	RCALL _Command
; 0000 0090                 LCD_String("      Hit!      ");
	__POINTW2FN _0x0,34
	RCALL SUBOPT_0x2
; 0000 0091                 delay_ms(500);
; 0000 0092                 NextAttempt();  // 새로운 줄 표시
; 0000 0093             }
_0x1E:
; 0000 0094         }
; 0000 0095     } else {  // 틀린 입력
_0x1C:
	RJMP _0x1F
_0x1B:
; 0000 0096         Command(LINE2);
	LDI  R26,LOW(192)
	RCALL _Command
; 0000 0097         LCD_String("     Miss!     ");
	__POINTW2FN _0x0,51
	RCALL SUBOPT_0x2
; 0000 0098         delay_ms(500);
; 0000 0099         NextAttempt();  // 새로운 줄 표시
; 0000 009A     }
_0x1F:
; 0000 009B }
	RJMP _0x2080002
; .FEND
;
;// 새로운 시도 (틀리거나 한 줄 완료 시 호출)
;void NextAttempt(void) {
; 0000 009E void NextAttempt(void) {
_NextAttempt:
; .FSTART _NextAttempt
; 0000 009F     input_index = 0;  // 입력 인덱스 초기화
	CLR  R7
; 0000 00A0     GenerateRandomKeys();  // 새로운 패턴 생성
	RCALL _GenerateRandomKeys
; 0000 00A1     DisplayPattern();  // 패턴 표시
	RCALL _DisplayPattern
; 0000 00A2 }
	RET
; .FEND
;
;
;// 사용자 입력을 LCD 두 번째 줄에 표시하는 함수
;void DisplayUserInput(void) {
; 0000 00A6 void DisplayUserInput(void) {
_DisplayUserInput:
; .FSTART _DisplayUserInput
; 0000 00A7     int i;
; 0000 00A8 
; 0000 00A9     // 두 번째 줄로 커서 이동
; 0000 00AA     Command(LINE2);
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	LDI  R26,LOW(192)
	RCALL _Command
; 0000 00AB 
; 0000 00AC     // 입력된 문자들을 순차적으로 LCD에 표시
; 0000 00AD     for (i = 0; i < input_index; i++) {
	__GETWRN 16,17,0
_0x21:
	MOV  R30,R7
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x22
; 0000 00AE         LCD_String("<");
	__POINTW2FN _0x0,67
	RCALL _LCD_String
; 0000 00AF         Data(user_input[i]);
	LDI  R26,LOW(_user_input)
	LDI  R27,HIGH(_user_input)
	RCALL SUBOPT_0x1
; 0000 00B0         LCD_String(">");
	__POINTW2FN _0x0,69
	RCALL _LCD_String
; 0000 00B1     }
	__ADDWRN 16,17,1
	RJMP _0x21
_0x22:
; 0000 00B2 }
	RJMP _0x2080003
; .FEND
;
;
;// 라운드 성공 처리
;void NextRound(void) {
; 0000 00B6 void NextRound(void) {
_NextRound:
; .FSTART _NextRound
; 0000 00B7     round++;
	INC  R6
; 0000 00B8     if (round > 5) {  // 5라운드 클리어
	LDI  R30,LOW(5)
	CP   R30,R6
	BRSH _0x23
; 0000 00B9         Command(ALLCLR);
	LDI  R26,LOW(1)
	RCALL _Command
; 0000 00BA         LCD_String("You Win!");
	__POINTW2FN _0x0,71
	RCALL _LCD_String
; 0000 00BB         Command(LINE2);
	LDI  R26,LOW(192)
	RCALL _Command
; 0000 00BC         delay_ms(2000);
	RCALL SUBOPT_0x3
; 0000 00BD         ResetGame();
; 0000 00BE     }
; 0000 00BF     else {
	RJMP _0x24
_0x23:
; 0000 00C0         // 라운드 시작 시 LCD에 "ROUND (숫자)" 출력
; 0000 00C1         Command(ALLCLR);  // 화면 지우기
	LDI  R26,LOW(1)
	RCALL _Command
; 0000 00C2         LCD_String("<ROUND ");
	__POINTW2FN _0x0,80
	RCALL _LCD_String
; 0000 00C3         Data('0' + round);  // 숫자 표시
	MOV  R26,R6
	SUBI R26,-LOW(48)
	RCALL _Data
; 0000 00C4         LCD_String(">");    // ">" 표시
	__POINTW2FN _0x0,69
	RCALL _LCD_String
; 0000 00C5         Command(LINE2);
	LDI  R26,LOW(192)
	RCALL _Command
; 0000 00C6         LCD_String("3 Hits in ");
	__POINTW2FN _0x0,88
	RCALL _LCD_String
; 0000 00C7         Data('0' + time_limits[round - 1] / 10);  // 10의 자리
	RCALL SUBOPT_0x4
	RCALL __DIVW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RCALL _Data
; 0000 00C8         Data('0' + time_limits[round - 1] % 10);  // 1의 자리
	RCALL SUBOPT_0x4
	RCALL __MODW21
	SUBI R30,-LOW(48)
	MOV  R26,R30
	RCALL _Data
; 0000 00C9         LCD_String("s");
	__POINTW2FN _0x0,99
	RCALL SUBOPT_0x5
; 0000 00CA         delay_ms(1000);     // 잠시 대기 후 라운드 진행
; 0000 00CB 
; 0000 00CC         sec_up = time_limits[round - 1];
	MOV  R30,R6
	LDI  R31,0
	SBIW R30,1
	SUBI R30,LOW(-_time_limits)
	SBCI R31,HIGH(-_time_limits)
	LD   R5,Z
; 0000 00CD         sec_low = 100;
	RCALL SUBOPT_0x6
; 0000 00CE         input_index = 0;
; 0000 00CF         success_count = 0;  // 성공 횟수 초기화
; 0000 00D0         GenerateRandomKeys();
	RCALL _GenerateRandomKeys
; 0000 00D1         DisplayPattern();
	RCALL _DisplayPattern
; 0000 00D2     }
_0x24:
; 0000 00D3 }
	RET
; .FEND
;
;
;// 게임 실패 처리
;void GameOver(void) {
; 0000 00D7 void GameOver(void) {
_GameOver:
; .FSTART _GameOver
; 0000 00D8     Command(ALLCLR);
	LDI  R26,LOW(1)
	RCALL _Command
; 0000 00D9     LCD_String("Game Over!");
	__POINTW2FN _0x0,101
	RCALL _LCD_String
; 0000 00DA     delay_ms(2000);
	RCALL SUBOPT_0x3
; 0000 00DB     ResetGame();
; 0000 00DC }
	RET
; .FEND
;
;// 게임 재시작
;void ResetGame(void) {
; 0000 00DF void ResetGame(void) {
_ResetGame:
; .FSTART _ResetGame
; 0000 00E0     round = 1;
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 00E1     sec_up = time_limits[0];
	LDS  R5,_time_limits
; 0000 00E2     sec_low = 100;
	RCALL SUBOPT_0x6
; 0000 00E3     input_index = 0;
; 0000 00E4     success_count = 0;
; 0000 00E5     game_running = 0;
	CLT
	BLD  R2,1
; 0000 00E6     timer_running = 0;
	BLD  R2,0
; 0000 00E7 
; 0000 00E8     Command(LINE2);
	RCALL SUBOPT_0x0
; 0000 00E9     LCD_String("Start Press KEY1");
; 0000 00EA }
	RET
; .FEND
;
;
;// 7세그먼트 표시
;void Time_out(void) {
; 0000 00EE void Time_out(void) {
_Time_out:
; .FSTART _Time_out
; 0000 00EF     PORTG = 0b00001000;
	LDI  R30,LOW(8)
	STS  101,R30
; 0000 00F0     PORTD = ((seg_pat[sec_low % 10] & 0x0F) << 4) | (PORTD & 0x0F);
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
; 0000 00F1     PORTB = (seg_pat[sec_low % 10] & 0x70) | (PORTB & 0x0F);
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x9
; 0000 00F2     delay_us(2500);
; 0000 00F3     PORTG = 0b00000100;
	LDI  R30,LOW(4)
	STS  101,R30
; 0000 00F4     PORTD = ((seg_pat[sec_low / 10] & 0x0F) << 4) | (PORTD & 0x0F);
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x8
; 0000 00F5     PORTB = (seg_pat[sec_low / 10] & 0x70) | (PORTB & 0x0F);
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x9
; 0000 00F6     delay_us(2500);
; 0000 00F7     PORTG = 0b00000010;
	LDI  R30,LOW(2)
	STS  101,R30
; 0000 00F8     PORTD = ((seg_pat[sec_up % 10] & 0x0F) << 4) | (PORTD & 0x0F);
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x8
; 0000 00F9     PORTB = (seg_pat[sec_up % 10] & 0x70) | (PORTB & 0x0F);
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x9
; 0000 00FA     delay_us(2500);
; 0000 00FB     PORTG = 0b00000001;
	LDI  R30,LOW(1)
	STS  101,R30
; 0000 00FC     PORTD = ((seg_pat[sec_up / 10] & 0x0F) << 4) | (PORTD & 0x0F);
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x8
; 0000 00FD     PORTB = (seg_pat[sec_up / 10] & 0x70) | (PORTB & 0x0F);
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x9
; 0000 00FE     delay_us(2500);
; 0000 00FF }
	RET
; .FEND
;
;// LCD 초기화
;void LCD_init(void) {
; 0000 0102 void LCD_init(void) {
_LCD_init:
; .FSTART _LCD_init
; 0000 0103     DDRA = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0104     PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0105     Command(0x20);
	LDI  R26,LOW(32)
	RCALL _Command
; 0000 0106     delay_ms(15);
	LDI  R26,LOW(15)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0107     Command(FUNCSET);
	LDI  R26,LOW(40)
	RCALL _Command
; 0000 0108     Command(DISPON);
	LDI  R26,LOW(12)
	RCALL _Command
; 0000 0109     Command(ALLCLR);
	LDI  R26,LOW(1)
	RCALL _Command
; 0000 010A     Command(ENTMODE);
	LDI  R26,LOW(6)
	RCALL _Command
; 0000 010B }
	RET
; .FEND
;
;void LCD_String(char flash* str) {
; 0000 010D void LCD_String(char flash* str) {
_LCD_String:
; .FSTART _LCD_String
; 0000 010E     while (*str) Data(*str++);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	*str -> R16,R17
_0x25:
	MOVW R30,R16
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x27
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R26,Z
	RCALL _Data
	RJMP _0x25
_0x27:
; 0000 010F }
_0x2080003:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;void Command(lcd_char byte) {
; 0000 0111 void Command(lcd_char byte) {
_Command:
; .FSTART _Command
; 0000 0112     Busy();
	ST   -Y,R17
	MOV  R17,R26
;	byte -> R17
	RCALL _Busy
; 0000 0113     PORTA = 0x00;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0xD
; 0000 0114     PORTA |= (byte & 0xF0);
; 0000 0115     delay_us(1);
; 0000 0116     ENABLE = 1;
; 0000 0117     delay_us(1);
; 0000 0118     ENABLE = 0;
; 0000 0119 
; 0000 011A     PORTA = 0x00;
	LDI  R30,LOW(0)
	RJMP _0x2080001
; 0000 011B     PORTA |= (byte << 4);
; 0000 011C     delay_us(1);
; 0000 011D     ENABLE = 1;
; 0000 011E     delay_us(1);
; 0000 011F     ENABLE = 0;
; 0000 0120 }
; .FEND
;
;void Data(lcd_char byte) {
; 0000 0122 void Data(lcd_char byte) {
_Data:
; .FSTART _Data
; 0000 0123     Busy();
	ST   -Y,R17
	MOV  R17,R26
;	byte -> R17
	RCALL _Busy
; 0000 0124     PORTA = 0x01;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xD
; 0000 0125     PORTA |= (byte & 0xF0);
; 0000 0126     delay_us(1);
; 0000 0127     ENABLE = 1;
; 0000 0128     delay_us(1);
; 0000 0129     ENABLE = 0;
; 0000 012A 
; 0000 012B     PORTA = 0x01;
	LDI  R30,LOW(1)
_0x2080001:
	OUT  0x1B,R30
; 0000 012C     PORTA |= (byte << 4);
	IN   R30,0x1B
	MOV  R26,R30
	MOV  R30,R17
	SWAP R30
	ANDI R30,0xF0
	OR   R30,R26
	OUT  0x1B,R30
; 0000 012D     delay_us(1);
	__DELAY_USB 5
; 0000 012E     ENABLE = 1;
	SBI  0x1B,2
; 0000 012F     delay_us(1);
	__DELAY_USB 5
; 0000 0130     ENABLE = 0;
	CBI  0x1B,2
; 0000 0131 }
_0x2080002:
	LD   R17,Y+
	RET
; .FEND
;
;void Busy(void) {
; 0000 0133 void Busy(void) {
_Busy:
; .FSTART _Busy
; 0000 0134     delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0135 }
	RET
; .FEND
;
;// 외부 인터럽트로 게임 시작
;interrupt[EXT_INT4] void external_int4(void) {
; 0000 0138 interrupt[6] void external_int4(void) {
_external_int4:
; .FSTART _external_int4
	RCALL SUBOPT_0xE
; 0000 0139     if (!game_running) {
	SBRC R2,1
	RJMP _0x38
; 0000 013A         timer_running = 1;
	SET
	BLD  R2,0
; 0000 013B         sec_up = time_limits[0];
	LDS  R5,_time_limits
; 0000 013C         sec_low = 100;
	LDI  R30,LOW(100)
	MOV  R4,R30
; 0000 013D         Command(ALLCLR);  // 화면 지우기
	LDI  R26,LOW(1)
	RCALL _Command
; 0000 013E         LCD_String("<ROUND 1>");
	__POINTW2FN _0x0,112
	RCALL _LCD_String
; 0000 013F         Command(LINE2);
	LDI  R26,LOW(192)
	RCALL _Command
; 0000 0140         LCD_String("3 Hits in 15s");
	__POINTW2FN _0x0,122
	RCALL SUBOPT_0x5
; 0000 0141         delay_ms(1000);
; 0000 0142         GenerateRandomKeys();
	RCALL _GenerateRandomKeys
; 0000 0143         DisplayPattern();
	RCALL _DisplayPattern
; 0000 0144         game_running = 1;
	SET
	BLD  R2,1
; 0000 0145     }
; 0000 0146 }
_0x38:
	RJMP _0x39
; .FEND
;
;// 인터럽트 초기화
;interrupt[EXT_INT5] void external_int5(void) {
; 0000 0149 interrupt[7] void external_int5(void) {
_external_int5:
; .FSTART _external_int5
	RCALL SUBOPT_0xE
; 0000 014A     ResetGame();  // 게임 리셋
	RCALL _ResetGame
; 0000 014B     main();
	RCALL _main
; 0000 014C }
_0x39:
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
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(192)
	RCALL _Command
	__POINTW2FN _0x0,13
	RJMP _LCD_String

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	RJMP _Data

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	RCALL _LCD_String
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
	RJMP _NextAttempt

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
	RJMP _ResetGame

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	MOV  R30,R6
	LDI  R31,0
	SBIW R30,1
	SUBI R30,LOW(-_time_limits)
	SBCI R31,HIGH(-_time_limits)
	LD   R26,Z
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	RCALL _LCD_String
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(100)
	MOV  R4,R30
	CLR  R7
	CLR  R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
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
SUBOPT_0x8:
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
SUBOPT_0x9:
	ANDI R30,LOW(0x70)
	MOV  R26,R30
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USW 10000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
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
SUBOPT_0xB:
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
SUBOPT_0xC:
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
SUBOPT_0xD:
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
SUBOPT_0xE:
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
