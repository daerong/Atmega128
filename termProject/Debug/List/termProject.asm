
;CodeVisionAVR C Compiler V3.33 Evaluation
;(C) Copyright 1998-2018 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 14.745600 MHz
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

	#pragma AVRPART ADMIN PART_NAME ATmega128
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
	.DEF _mode=R5
	.DEF _nowStat=R4
	.DEF _leftD=R6
	.DEF _leftD_msb=R7
	.DEF _rightD=R8
	.DEF _rightD_msb=R9
	.DEF _frontD=R10
	.DEF _frontD_msb=R11
	.DEF _leftPastD=R12
	.DEF _leftPastD_msb=R13

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
	JMP  _timer0_compare
	JMP  _timer0_overflow
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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x25,0x30,0x33,0x64,0x0,0x25,0x34,0x78
	.DB  0x25,0x34,0x78,0x0,0x45,0x6E,0x64,0x20
	.DB  0x44,0x72,0x69,0x76,0x65,0x0
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
;#include <stdio.h>
;#include <delay.h>
;#include "lcd.h"

	.CSEG
_Port_Init:
; .FSTART _Port_Init
	IN   R30,0x1A
	ORI  R30,LOW(0xFF)
	OUT  0x1A,R30
	LDS  R30,100
	ORI  R30,LOW(0xF)
	STS  100,R30
	RET
; .FEND
_LCD_Data:
; .FSTART _LCD_Data
	RCALL SUBOPT_0x0
;	ch -> R17
	ORI  R30,4
	RCALL SUBOPT_0x1
	ANDI R30,0xFD
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	RJMP _0x2060002
; .FEND
_LCD_Comm:
; .FSTART _LCD_Comm
	RCALL SUBOPT_0x0
;	ch -> R17
	ANDI R30,0xFB
	RCALL SUBOPT_0x1
	ANDI R30,0xFD
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	RJMP _0x2060002
; .FEND
_LCD_CHAR:
; .FSTART _LCD_CHAR
	ST   -Y,R17
	MOV  R17,R26
;	c -> R17
	RCALL _LCD_Data
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _delay_ms
	RJMP _0x2060002
; .FEND
_LCD_STR:
; .FSTART _LCD_STR
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	*str -> R16,R17
_0x3:
	MOVW R26,R16
	LD   R30,X
	CPI  R30,0
	BREQ _0x5
	LD   R26,X
	RCALL _LCD_CHAR
	__ADDWRN 16,17,1
	RJMP _0x3
_0x5:
	RJMP _0x2060005
; .FEND
_LCD_pos:
; .FSTART _LCD_pos
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
;	col -> R16
;	row -> R17
	LDI  R26,LOW(64)
	MULS R16,R26
	MOVW R30,R0
	ADD  R30,R17
	ORI  R30,0x80
	MOV  R26,R30
	RCALL _LCD_Comm
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
_LCD_Clear:
; .FSTART _LCD_Clear
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x3
	RET
; .FEND
_LCD_Init:
; .FSTART _LCD_Init
	LDI  R26,LOW(56)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(56)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(56)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(14)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(6)
	RCALL SUBOPT_0x3
	RCALL _LCD_Clear
	RET
; .FEND
;
;#define D_A 6
;#define D_B 11
;#define D_C 30		// 신뢰할 수 있는 최대치
;#define D_D 70
;#define DELTA 1
;#define MOTOR_FAST 235
;#define MOTOR_SLOW 210
;
;#define TURN_TIME 30000
;#define MID_ANGLE 4000
;
;#define ARR_SIZE 5
;# define SWAP(x, y, temp) ( (temp)=(x), (x)=(y), (y)=(temp) )
;
;unsigned long int TCsec;
;unsigned long int TCstart;
;
;unsigned char mode;
;unsigned char nowStat;
;
;/* 서보 */
;void Init_Timer3A()
; 0000 001C {
_Init_Timer3A:
; .FSTART _Init_Timer3A
; 0000 001D 	TCCR3A = 0xAA; // FAST PWM
	LDI  R30,LOW(170)
	STS  139,R30
; 0000 001E 	TCCR3B = 0x1A; // 8분주=0.5usec
	LDI  R30,LOW(26)
	STS  138,R30
; 0000 001F 
; 0000 0020 	OCR3AH = MID_ANGLE >> 8;          // 1500usec=0도
	LDI  R30,LOW(15)
	STS  135,R30
; 0000 0021 	OCR3AL = MID_ANGLE & 0xff;
	LDI  R30,LOW(160)
	STS  134,R30
; 0000 0022 	DDRE = 0x08;               // DDRE=0x08;   // PE 3 out
	LDI  R30,LOW(8)
	OUT  0x2,R30
; 0000 0023 	ICR3H = 39999 >> 8;
	LDI  R30,LOW(156)
	STS  129,R30
; 0000 0024 	ICR3L = 39999 & 0xff;        // 0.5usec*40000=20000usec=50Hz
	LDI  R30,LOW(63)
	STS  128,R30
; 0000 0025 }
	RET
; .FEND
;
;void Servo_motor(int angle)
; 0000 0028 {
_Servo_motor:
; .FSTART _Servo_motor
; 0000 0029 	OCR3AH = (angle * 14 + MID_ANGLE) >> 8;
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	angle -> R16,R17
	MOVW R30,R16
	LDI  R26,LOW(14)
	LDI  R27,HIGH(14)
	RCALL __MULW12
	SUBI R30,LOW(-4000)
	SBCI R31,HIGH(-4000)
	RCALL __ASRW8
	STS  135,R30
; 0000 002A 	OCR3AL = (angle * 14 + MID_ANGLE) & 0xFF;
	LDI  R26,LOW(14)
	MULS R16,R26
	MOVW R30,R0
	SUBI R30,-LOW(160)
	STS  134,R30
; 0000 002B }
_0x2060005:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;/* 초음파 센서 */
;#define Trigger1     PORTB.0 //초음파 트리거
;#define Trigger2     PORTB.0
;#define Trigger3     PORTB.0
;
;#define Echo1        PIND.0 //초음파 에코
;#define Echo2        PIND.1
;#define Echo3        PIND.2
;
;unsigned int leftArr[ARR_SIZE];         // 왼쪽
;unsigned int rightArr[ARR_SIZE];        // 정면
;unsigned int frontArr[ARR_SIZE];        // 오른쪽
;unsigned int leftD;         // 왼쪽
;unsigned int rightD;        // 정면
;unsigned int frontD;        // 오른쪽
;unsigned int leftPastD;         // 왼쪽
;unsigned int frontPastD;        // 정면
;unsigned int rightPastD;        // 오른쪽
;
;unsigned char L_R;
;
;// unsigned int sonar_arr[3];
;
;unsigned char rangeStr[5];
;unsigned char TCsecStr[10];
;
;void getEchoFront(unsigned char i) {
; 0000 0047 void getEchoFront(unsigned char i) {
_getEchoFront:
; .FSTART _getEchoFront
; 0000 0048     while (!Echo1);//high가 될때
	ST   -Y,R17
	MOV  R17,R26
;	i -> R17
_0x6:
	SBIS 0x10,0
	RJMP _0x6
; 0000 0049     TCNT1 = 0; TCCR1B = 2; //카운터시작 , 0.5분주
	RCALL SUBOPT_0x4
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 004A     while (Echo1);//low가 될때
_0x9:
	SBIC 0x10,0
	RJMP _0x9
; 0000 004B     TCCR1B = 8; //카운터 정지 TCCR1B = 0도 가능
	LDI  R30,LOW(8)
	OUT  0x2E,R30
; 0000 004C     rightArr[i] = TCNT1 / 116;//CM변경
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
; 0000 004D     TCNT1 = 0;
; 0000 004E }
	RJMP _0x2060002
; .FEND
;void getEchoRight(unsigned char i)
; 0000 0050 {
_getEchoRight:
; .FSTART _getEchoRight
; 0000 0051     while (!Echo2);//high가 될때
	ST   -Y,R17
	MOV  R17,R26
;	i -> R17
_0xC:
	SBIS 0x10,1
	RJMP _0xC
; 0000 0052     TCNT1 = 0; TCCR1B = 2; //카운터시작 , 0.5분주
	RCALL SUBOPT_0x4
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 0053     while (Echo2);//low가 될때
_0xF:
	SBIC 0x10,1
	RJMP _0xF
; 0000 0054     TCCR1B = 8; //카운터 정지 TCCR1B = 0도 가능
	LDI  R30,LOW(8)
	OUT  0x2E,R30
; 0000 0055     frontArr[i] = TCNT1 / 116;//CM변경
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x6
; 0000 0056     TCNT1 = 0;
; 0000 0057 }
	RJMP _0x2060002
; .FEND
;void getEchoLeft(unsigned char i) {
; 0000 0058 void getEchoLeft(unsigned char i) {
_getEchoLeft:
; .FSTART _getEchoLeft
; 0000 0059     while (!Echo3);//high가 될때
	ST   -Y,R17
	MOV  R17,R26
;	i -> R17
_0x12:
	SBIS 0x10,2
	RJMP _0x12
; 0000 005A     TCNT1 = 0; TCCR1B = 2; //카운터시작 , 0.5분주
	RCALL SUBOPT_0x4
	LDI  R30,LOW(2)
	OUT  0x2E,R30
; 0000 005B     while (Echo3);//low가 될때
_0x15:
	SBIC 0x10,2
	RJMP _0x15
; 0000 005C     TCCR1B = 8; //카운터 정지 TCCR1B = 0도 가능
	LDI  R30,LOW(8)
	OUT  0x2E,R30
; 0000 005D     leftArr[i] = TCNT1 / 116;//CM변경
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x6
; 0000 005E     TCNT1 = 0;
; 0000 005F }
	RJMP _0x2060002
; .FEND
;/* 초음파 센서 */
;
;/* 서보 */
;
;void custom_port_init() {
; 0000 0064 void custom_port_init() {
_custom_port_init:
; .FSTART _custom_port_init
; 0000 0065     DDRE = 0xff;        // Servo, DC
	LDI  R30,LOW(255)
	OUT  0x2,R30
; 0000 0066     DDRB = 0xff;        // Sonar, DC
	OUT  0x17,R30
; 0000 0067     DDRD = 0x00;        // DC
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0068 
; 0000 0069     //DDRF = 0xFF;
; 0000 006A }
	RET
; .FEND
;
;/* DC MOTOR */
;void TIMSK_setting() {
; 0000 006D void TIMSK_setting() {
_TIMSK_setting:
; .FSTART _TIMSK_setting
; 0000 006E     TIMSK = (1 << OCIE0) | (1 << TOIE0);
	LDI  R30,LOW(3)
	RJMP _0x2060003
; 0000 006F }
; .FEND
;void timer0_Init() {
; 0000 0070 void timer0_Init() {
_timer0_Init:
; .FSTART _timer0_Init
; 0000 0071     TCCR0 = (1 << WGM01) | (1 << WGM00) | (1 << CS01);
	LDI  R30,LOW(74)
	OUT  0x33,R30
; 0000 0072 }
	RET
; .FEND
;interrupt[TIM0_COMP] void timer0_compare() {
; 0000 0073 interrupt[16] void timer0_compare() {
_timer0_compare:
; .FSTART _timer0_compare
; 0000 0074     PORTB.5 = 0;
	CBI  0x18,5
; 0000 0075     PORTB.6 = 0;
	CBI  0x18,6
; 0000 0076 }
	RETI
; .FEND
;interrupt[TIM0_OVF] void timer0_overflow() {
; 0000 0077 interrupt[17] void timer0_overflow() {
_timer0_overflow:
; .FSTART _timer0_overflow
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0078     PORTB.5 = 1;
	SBI  0x18,5
; 0000 0079     PORTB.6 = 1;
	SBI  0x18,6
; 0000 007A 
; 0000 007B     TCsec++;
	LDI  R26,LOW(_TCsec)
	LDI  R27,HIGH(_TCsec)
	RCALL __GETD1P_INC
	__SUBD1N -1
	RCALL __PUTDP1_DEC
; 0000 007C }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
; .FEND
;
;void Motor_fast() {
; 0000 007E void Motor_fast() {
_Motor_fast:
; .FSTART _Motor_fast
; 0000 007F     OCR0 = MOTOR_FAST;
	LDI  R30,LOW(235)
	RJMP _0x2060004
; 0000 0080 }
; .FEND
;void Motor_slow() {
; 0000 0081 void Motor_slow() {
_Motor_slow:
; .FSTART _Motor_slow
; 0000 0082     OCR0 = MOTOR_SLOW;
	LDI  R30,LOW(210)
_0x2060004:
	OUT  0x31,R30
; 0000 0083 }
	RET
; .FEND
;void DC_front() {
; 0000 0084 void DC_front() {
_DC_front:
; .FSTART _DC_front
; 0000 0085     PORTE.4 = 1;
	SBI  0x3,4
; 0000 0086     PORTE.5 = 0;
	CBI  0x3,5
; 0000 0087     PORTE.6 = 1;
	SBI  0x3,6
; 0000 0088     PORTE.7 = 0;
	CBI  0x3,7
; 0000 0089 }
	RET
; .FEND
;void DC_back() {
; 0000 008A void DC_back() {
_DC_back:
; .FSTART _DC_back
; 0000 008B     PORTE.4 = 0;
	CBI  0x3,4
; 0000 008C     PORTE.5 = 1;
	SBI  0x3,5
; 0000 008D     PORTE.6 = 0;
	CBI  0x3,6
; 0000 008E     PORTE.7 = 1;
	SBI  0x3,7
; 0000 008F }
	RET
; .FEND
;
;void DC_stop() {
; 0000 0091 void DC_stop() {
_DC_stop:
; .FSTART _DC_stop
; 0000 0092     PORTB.5 = 0;
	CBI  0x18,5
; 0000 0093     PORTB.6 = 0;
	CBI  0x18,6
; 0000 0094     TIMSK = (0 << OCIE0) & (0 << TOIE0);
	LDI  R30,LOW(0)
_0x2060003:
	OUT  0x37,R30
; 0000 0095 }
	RET
; .FEND
;
;void DC_start() {
; 0000 0097 void DC_start() {
; 0000 0098     TIMSK = (1 << OCIE0) | (1 << TOIE0);
; 0000 0099     PORTB.5 = 1;
; 0000 009A     PORTB.6 = 1;
; 0000 009B }
;
;void DC_Left() {
; 0000 009D void DC_Left() {
; 0000 009E     PORTE.4 = 0;
; 0000 009F     PORTE.5 = 1;
; 0000 00A0     PORTE.6 = 1;
; 0000 00A1     PORTE.7 = 0;
; 0000 00A2 }
;
;void DC_Right() {
; 0000 00A4 void DC_Right() {
; 0000 00A5     PORTE.4 = 1;
; 0000 00A6     PORTE.5 = 0;
; 0000 00A7     PORTE.6 = 0;
; 0000 00A8     PORTE.7 = 1;
; 0000 00A9 }
;
;/* DC MOTOR */
;
;int partition(unsigned int list[], int left, int right) {
; 0000 00AD int partition(unsigned int list[], int left, int right) {
_partition:
; .FSTART _partition
; 0000 00AE     int pivot, temp;
; 0000 00AF     int low, high;
; 0000 00B0 
; 0000 00B1     low = left;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,2
	RCALL __SAVELOCR6
;	list -> Y+12
;	left -> Y+10
;	right -> Y+8
;	pivot -> R16,R17
;	temp -> R18,R19
;	low -> R20,R21
;	high -> Y+6
	__GETWRS 20,21,10
; 0000 00B2     high = right + 1;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00B3     pivot = list[left];
	RCALL SUBOPT_0x9
	LD   R16,X+
	LD   R17,X
; 0000 00B4 
; 0000 00B5     do {
_0x49:
; 0000 00B6         do {
_0x4C:
; 0000 00B7             low++;
	__ADDWRN 20,21,1
; 0000 00B8         } while (low <= right && list[low] < pivot);
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R30,R20
	CPC  R31,R21
	BRLT _0x4E
	RCALL SUBOPT_0xA
	RCALL __GETW1P
	CP   R30,R16
	CPC  R31,R17
	BRLO _0x4F
_0x4E:
	RJMP _0x4D
_0x4F:
	RJMP _0x4C
_0x4D:
; 0000 00B9 
; 0000 00BA         do {
_0x51:
; 0000 00BB             high--;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00BC         } while (high >= left && list[high] > pivot);
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x53
	RCALL SUBOPT_0xB
	RCALL __GETW1P
	CP   R16,R30
	CPC  R17,R31
	BRLO _0x54
_0x53:
	RJMP _0x52
_0x54:
	RJMP _0x51
_0x52:
; 0000 00BD 
; 0000 00BE         if (low < high) {
	RCALL SUBOPT_0xC
	BRGE _0x55
; 0000 00BF             SWAP(list[low], list[high], temp);
	RCALL SUBOPT_0xA
	LD   R18,X+
	LD   R19,X
	MOVW R30,R20
	RCALL SUBOPT_0xD
	MOVW R0,R30
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xE
	ST   Z,R18
	STD  Z+1,R19
; 0000 00C0         }
; 0000 00C1     } while (low < high);
_0x55:
	RCALL SUBOPT_0xC
	BRLT _0x49
; 0000 00C2 
; 0000 00C3     SWAP(list[left], list[high], temp);
	RCALL SUBOPT_0x9
	LD   R18,X+
	LD   R19,X
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL SUBOPT_0xD
	MOVW R0,R30
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xE
	ST   Z,R18
	STD  Z+1,R19
; 0000 00C4 
; 0000 00C5     return high;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __LOADLOCR6
	ADIW R28,14
	RET
; 0000 00C6 }
; .FEND
;
;void quick_sort(unsigned int list[], int left, int right) {
; 0000 00C8 void quick_sort(unsigned int list[], int left, int right) {
_quick_sort:
; .FSTART _quick_sort
; 0000 00C9     if (left < right) {
	RCALL __SAVELOCR6
	MOVW R16,R26
	__GETWRS 18,19,6
	__GETWRS 20,21,8
;	list -> R20,R21
;	left -> R18,R19
;	right -> R16,R17
	__CPWRR 18,19,16,17
	BRGE _0x56
; 0000 00CA         int q = partition(list, left, right);
; 0000 00CB 
; 0000 00CC         quick_sort(list, left, q - 1);
	SBIW R28,2
;	q -> Y+0
	RCALL SUBOPT_0xF
	MOVW R26,R16
	RCALL _partition
	ST   Y,R30
	STD  Y+1,R31
	RCALL SUBOPT_0xF
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,1
	RCALL _quick_sort
; 0000 00CD         quick_sort(list, q + 1, right);
	ST   -Y,R21
	ST   -Y,R20
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	RCALL _quick_sort
; 0000 00CE     }
	ADIW R28,2
; 0000 00CF }
_0x56:
	RCALL __LOADLOCR6
	ADIW R28,10
	RET
; .FEND
;
;unsigned int get_median_L(unsigned char num) {
; 0000 00D1 unsigned int get_median_L(unsigned char num) {
_get_median_L:
; .FSTART _get_median_L
; 0000 00D2     quick_sort(leftArr, 0, ARR_SIZE - 1);
	ST   -Y,R17
	MOV  R17,R26
;	num -> R17
	LDI  R30,LOW(_leftArr)
	LDI  R31,HIGH(_leftArr)
	RCALL SUBOPT_0x10
; 0000 00D3     return leftArr[num];
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x11
	RJMP _0x2060002
; 0000 00D4 }
; .FEND
;
;unsigned int get_median_F(unsigned char num) {
; 0000 00D6 unsigned int get_median_F(unsigned char num) {
_get_median_F:
; .FSTART _get_median_F
; 0000 00D7     quick_sort(frontArr, 0, ARR_SIZE - 1);
	ST   -Y,R17
	MOV  R17,R26
;	num -> R17
	LDI  R30,LOW(_frontArr)
	LDI  R31,HIGH(_frontArr)
	RCALL SUBOPT_0x10
; 0000 00D8     return frontArr[num];
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x11
	RJMP _0x2060002
; 0000 00D9 }
; .FEND
;
;unsigned int get_median_R(unsigned char num) {
; 0000 00DB unsigned int get_median_R(unsigned char num) {
_get_median_R:
; .FSTART _get_median_R
; 0000 00DC     quick_sort(rightArr, 0, ARR_SIZE - 1);
	ST   -Y,R17
	MOV  R17,R26
;	num -> R17
	LDI  R30,LOW(_rightArr)
	LDI  R31,HIGH(_rightArr)
	RCALL SUBOPT_0x10
; 0000 00DD     return rightArr[num];
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x11
	RJMP _0x2060002
; 0000 00DE }
; .FEND
;
;void get_sonar() {
; 0000 00E0 void get_sonar() {
_get_sonar:
; .FSTART _get_sonar
; 0000 00E1     unsigned char i = 0;
; 0000 00E2     for (i = 0; i < ARR_SIZE; i++) {
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	LDI  R17,LOW(0)
_0x58:
	CPI  R17,5
	BRSH _0x59
; 0000 00E3         Trigger3 = 1; delay_us(10); Trigger3 = 0; getEchoRight(i); delay_ms(10);
	RCALL SUBOPT_0x12
	RCALL _getEchoRight
	RCALL SUBOPT_0x13
; 0000 00E4         Trigger2 = 1; delay_us(10); Trigger2 = 0; getEchoFront(i); delay_ms(10);
	RCALL _getEchoFront
	RCALL SUBOPT_0x13
; 0000 00E5         Trigger1 = 1; delay_us(10); Trigger1 = 0; getEchoLeft(i); delay_ms(10);
	RCALL _getEchoLeft
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00E6     }
	SUBI R17,-1
	RJMP _0x58
_0x59:
; 0000 00E7 
; 0000 00E8     leftD = get_median_L(2);
	LDI  R26,LOW(2)
	RCALL _get_median_L
	MOVW R6,R30
; 0000 00E9     frontD = get_median_F(2);
	LDI  R26,LOW(2)
	RCALL _get_median_F
	MOVW R10,R30
; 0000 00EA     rightD = get_median_R(1);
	LDI  R26,LOW(1)
	RCALL _get_median_R
	MOVW R8,R30
; 0000 00EB 
; 0000 00EC     LCD_pos(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x14
; 0000 00ED     sprintf(rangeStr, "%03d", rightD);
	MOVW R30,R8
	RCALL SUBOPT_0x15
; 0000 00EE     LCD_STR(rangeStr);
; 0000 00EF 
; 0000 00F0     LCD_pos(0, 5);
	LDI  R26,LOW(5)
	RCALL SUBOPT_0x14
; 0000 00F1     sprintf(rangeStr, "%03d", frontD);
	MOVW R30,R10
	RCALL SUBOPT_0x15
; 0000 00F2     LCD_STR(rangeStr);
; 0000 00F3 
; 0000 00F4     LCD_pos(0, 9);
	LDI  R26,LOW(9)
	RCALL SUBOPT_0x14
; 0000 00F5     sprintf(rangeStr, "%03d", leftD);
	MOVW R30,R6
	RCALL SUBOPT_0x15
; 0000 00F6     LCD_STR(rangeStr);
; 0000 00F7 
; 0000 00F8     LCD_pos(0, 14);
	LDI  R26,LOW(14)
	RCALL _LCD_pos
; 0000 00F9     switch (mode)
	MOV  R30,R5
	LDI  R31,0
; 0000 00FA     {
; 0000 00FB     case 0:
	SBIW R30,0
	BRNE _0x69
; 0000 00FC         LCD_CHAR('A');
	LDI  R26,LOW(65)
	RJMP _0xAC
; 0000 00FD         break;
; 0000 00FE     case 1:
_0x69:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x6A
; 0000 00FF         LCD_CHAR('B');
	LDI  R26,LOW(66)
	RJMP _0xAC
; 0000 0100         break;
; 0000 0101     case 2:
_0x6A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6B
; 0000 0102         LCD_CHAR('C');
	LDI  R26,LOW(67)
	RJMP _0xAC
; 0000 0103         break;
; 0000 0104     case 3:
_0x6B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6C
; 0000 0105         LCD_CHAR('D');
	LDI  R26,LOW(68)
	RJMP _0xAC
; 0000 0106         break;
; 0000 0107     case 4:
_0x6C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x6E
; 0000 0108         LCD_CHAR('E');
	LDI  R26,LOW(69)
	RJMP _0xAC
; 0000 0109         break;
; 0000 010A     default:
_0x6E:
; 0000 010B         LCD_CHAR('Z');
	LDI  R26,LOW(90)
_0xAC:
	RCALL _LCD_CHAR
; 0000 010C         break;
; 0000 010D     }
; 0000 010E     LCD_pos(0, 15);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(15)
	RCALL _LCD_pos
; 0000 010F     LCD_CHAR(nowStat);
	MOV  R26,R4
	RCALL _LCD_CHAR
; 0000 0110 
; 0000 0111     LCD_pos(1, 0);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _LCD_pos
; 0000 0112     sprintf(TCsecStr, "%4x%4x", TCsec >> 16, TCsec);
	RCALL SUBOPT_0x16
	__POINTW1FN _0x0,5
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x17
	RCALL __LSRD16
	RCALL __PUTPARD1
	RCALL SUBOPT_0x17
	RCALL __PUTPARD1
	LDI  R24,8
	RCALL _sprintf
	ADIW R28,12
; 0000 0113     LCD_STR(TCsecStr);
	LDI  R26,LOW(_TCsecStr)
	LDI  R27,HIGH(_TCsecStr)
	RCALL _LCD_STR
; 0000 0114 }
_0x2060002:
	LD   R17,Y+
	RET
; .FEND
;
;void main() {
; 0000 0116 void main() {
_main:
; .FSTART _main
; 0000 0117     SREG |= 0x80;
	BSET 7
; 0000 0118     custom_port_init();
	RCALL _custom_port_init
; 0000 0119     Init_Timer3A();
	RCALL _Init_Timer3A
; 0000 011A     Port_Init();
	RCALL _Port_Init
; 0000 011B     LCD_Init();
	RCALL _LCD_Init
; 0000 011C     TIMSK_setting();
	RCALL _TIMSK_setting
; 0000 011D     timer0_Init();
	RCALL _timer0_Init
; 0000 011E 
; 0000 011F     TCCR1A = 0;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0120     TCCR1B = 8;
	LDI  R30,LOW(8)
	OUT  0x2E,R30
; 0000 0121     Motor_fast();
	RCALL _Motor_fast
; 0000 0122 
; 0000 0123     leftD = 0;
	CLR  R6
	CLR  R7
; 0000 0124     frontD = 0;
	CLR  R10
	CLR  R11
; 0000 0125     rightD = 0;
	CLR  R8
	CLR  R9
; 0000 0126     leftPastD = 0;
	CLR  R12
	CLR  R13
; 0000 0127     frontPastD = 0;
	LDI  R30,LOW(0)
	STS  _frontPastD,R30
	STS  _frontPastD+1,R30
; 0000 0128     rightPastD = 0;
	STS  _rightPastD,R30
	STS  _rightPastD+1,R30
; 0000 0129 
; 0000 012A     TCsec = 0;
	STS  _TCsec,R30
	STS  _TCsec+1,R30
	STS  _TCsec+2,R30
	STS  _TCsec+3,R30
; 0000 012B     TCstart = 0;
	RCALL SUBOPT_0x18
; 0000 012C 
; 0000 012D     PORTE.3 = 0;
	CBI  0x3,3
; 0000 012E 
; 0000 012F     /* DC Default */
; 0000 0130     PORTB.5 = 1;
	SBI  0x18,5
; 0000 0131     PORTB.6 = 1;
	SBI  0x18,6
; 0000 0132 
; 0000 0133     OCR0 = MOTOR_FAST;
	LDI  R30,LOW(235)
	OUT  0x31,R30
; 0000 0134 
; 0000 0135     DC_front();
	RCALL _DC_front
; 0000 0136     /* DC Default */
; 0000 0137 
; 0000 0138     L_R = 2;    //작은 값 L(0), R(1)
	LDI  R30,LOW(2)
	STS  _L_R,R30
; 0000 0139     mode = 0;
	CLR  R5
; 0000 013A     nowStat = 0;
	CLR  R4
; 0000 013B 
; 0000 013C     while (1) {
_0x75:
; 0000 013D         L_R = 0;
	LDI  R30,LOW(0)
	STS  _L_R,R30
; 0000 013E         leftPastD = leftD;
	MOVW R12,R6
; 0000 013F         frontPastD = frontD;
	__PUTWMRN _frontPastD,0,10,11
; 0000 0140         rightPastD = rightD;
	__PUTWMRN _rightPastD,0,8,9
; 0000 0141 
; 0000 0142         get_sonar();
	RCALL _get_sonar
; 0000 0143         if (leftD > rightD) L_R = 1;
	__CPWRR 8,9,6,7
	BRSH _0x78
	LDI  R30,LOW(1)
	STS  _L_R,R30
; 0000 0144 
; 0000 0145         if (!mode) TCstart = 0;
_0x78:
	TST  R5
	BRNE _0x79
	RCALL SUBOPT_0x18
; 0000 0146         else if (TCstart == 0) TCstart = TCsec;
	RJMP _0x7A
_0x79:
	LDS  R30,_TCstart
	LDS  R31,_TCstart+1
	LDS  R22,_TCstart+2
	LDS  R23,_TCstart+3
	RCALL __CPD10
	BRNE _0x7B
	RCALL SUBOPT_0x17
	STS  _TCstart,R30
	STS  _TCstart+1,R31
	STS  _TCstart+2,R22
	STS  _TCstart+3,R23
; 0000 0147 
; 0000 0148         if (TCsec > 650000) mode = 2;
_0x7B:
_0x7A:
	LDS  R26,_TCsec
	LDS  R27,_TCsec+1
	LDS  R24,_TCsec+2
	LDS  R25,_TCsec+3
	__CPD2N 0x9EB11
	BRLO _0x7C
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0000 0149 
; 0000 014A         if (mode == 2) {
_0x7C:
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x7D
; 0000 014B             nowStat = '2';
	LDI  R30,LOW(50)
	MOV  R4,R30
; 0000 014C             DC_front();
	RCALL _DC_front
; 0000 014D             Servo_motor(25);
	RCALL SUBOPT_0x19
; 0000 014E             delay_ms(200);
; 0000 014F             Servo_motor(-25);
; 0000 0150             delay_ms(200);
; 0000 0151             Servo_motor(25);
	RCALL SUBOPT_0x19
; 0000 0152             delay_ms(200);
; 0000 0153             Servo_motor(-25);
; 0000 0154             delay_ms(200);
; 0000 0155             Servo_motor(25);
	RCALL SUBOPT_0x19
; 0000 0156             delay_ms(200);
; 0000 0157             Servo_motor(-25);
; 0000 0158             delay_ms(200);
; 0000 0159             DC_stop();
	RCALL _DC_stop
; 0000 015A             LCD_Clear();
	RCALL _LCD_Clear
; 0000 015B             sprintf(TCsecStr, "End Drive");
	RCALL SUBOPT_0x16
	__POINTW1FN _0x0,12
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _sprintf
	ADIW R28,4
; 0000 015C             LCD_STR(TCsecStr);
	LDI  R26,LOW(_TCsecStr)
	LDI  R27,HIGH(_TCsecStr)
	RCALL _LCD_STR
; 0000 015D             delay_ms(50000);
	LDI  R26,LOW(50000)
	LDI  R27,HIGH(50000)
	RJMP _0xAD
; 0000 015E         }
; 0000 015F         else if (frontD < D_A && frontPastD < D_B) {
_0x7D:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R10,R30
	CPC  R11,R31
	BRSH _0x80
	LDS  R26,_frontPastD
	LDS  R27,_frontPastD+1
	SBIW R26,11
	BRLO _0x81
_0x80:
	RJMP _0x7F
_0x81:
; 0000 0160             nowStat = 'B';
	LDI  R30,LOW(66)
	RCALL SUBOPT_0x1A
; 0000 0161             DC_back();
; 0000 0162             Motor_slow();
; 0000 0163 
; 0000 0164             if (leftPastD > rightPastD) {
	BRSH _0x82
; 0000 0165                 Servo_motor(20);
	LDI  R26,LOW(20)
	LDI  R27,0
	RJMP _0xAE
; 0000 0166                 delay_ms(400);
; 0000 0167                 Servo_motor(0);
; 0000 0168             }
; 0000 0169             else {
_0x82:
; 0000 016A                 Servo_motor(-20);
	LDI  R26,LOW(65516)
	LDI  R27,HIGH(65516)
_0xAE:
	RCALL _Servo_motor
; 0000 016B                 delay_ms(400);
	RCALL SUBOPT_0x1B
; 0000 016C                 Servo_motor(0);
; 0000 016D             }
; 0000 016E             delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
; 0000 016F             mode = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0170         }
; 0000 0171         else if (leftD > leftPastD - DELTA && leftD < leftPastD + DELTA && frontD > frontPastD - DELTA && frontD < front ...
	RJMP _0x84
_0x7F:
	MOVW R30,R12
	SBIW R30,1
	CP   R30,R6
	CPC  R31,R7
	BRSH _0x86
	MOVW R30,R12
	ADIW R30,1
	CP   R6,R30
	CPC  R7,R31
	BRSH _0x86
	RCALL SUBOPT_0x1C
	SBIW R30,1
	CP   R30,R10
	CPC  R31,R11
	BRSH _0x86
	RCALL SUBOPT_0x1C
	ADIW R30,1
	CP   R10,R30
	CPC  R11,R31
	BRSH _0x86
	RCALL SUBOPT_0x1D
	SBIW R30,1
	CP   R30,R8
	CPC  R31,R9
	BRSH _0x86
	RCALL SUBOPT_0x1D
	ADIW R30,1
	CP   R8,R30
	CPC  R9,R31
	BRLO _0x87
_0x86:
	RJMP _0x85
_0x87:
; 0000 0172             nowStat = 'S';
	LDI  R30,LOW(83)
	RCALL SUBOPT_0x1A
; 0000 0173             DC_back();
; 0000 0174             Motor_slow();
; 0000 0175 
; 0000 0176             if (leftPastD > rightPastD) {
	BRSH _0x88
; 0000 0177                 Servo_motor(30);
	LDI  R26,LOW(30)
	LDI  R27,0
	RCALL SUBOPT_0x1E
; 0000 0178                 delay_ms(400);
; 0000 0179                 Servo_motor(-20);
	LDI  R26,LOW(65516)
	LDI  R27,HIGH(65516)
	RJMP _0xAF
; 0000 017A             }
; 0000 017B             else {
_0x88:
; 0000 017C                 Servo_motor(-30);
	LDI  R26,LOW(65506)
	LDI  R27,HIGH(65506)
	RCALL SUBOPT_0x1E
; 0000 017D                 delay_ms(400);
; 0000 017E                 Servo_motor(20);
	LDI  R26,LOW(20)
	LDI  R27,0
_0xAF:
	RCALL _Servo_motor
; 0000 017F             }
; 0000 0180             delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RJMP _0xAD
; 0000 0181         }
; 0000 0182         else if (mode) {
_0x85:
	TST  R5
	BREQ _0x8B
; 0000 0183             DC_front(); Motor_fast();
	RCALL _DC_front
	RCALL _Motor_fast
; 0000 0184             switch (L_R) {
	RCALL SUBOPT_0x1F
; 0000 0185             case 0:
	BRNE _0x8F
; 0000 0186                 nowStat = 'R';
	LDI  R30,LOW(82)
	RCALL SUBOPT_0x20
; 0000 0187                 DC_front(); Motor_fast();
; 0000 0188                 if (rightD > D_D) { Servo_motor(45); }
	CP   R30,R8
	CPC  R31,R9
	BRSH _0x90
	LDI  R26,LOW(45)
	RJMP _0xB0
; 0000 0189                 else if (rightD > D_C) { Servo_motor(35); }
_0x90:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CP   R30,R8
	CPC  R31,R9
	BRSH _0x92
	LDI  R26,LOW(35)
	RJMP _0xB0
; 0000 018A                 else { Servo_motor(15); }
_0x92:
	LDI  R26,LOW(15)
_0xB0:
	LDI  R27,0
	RCALL _Servo_motor
; 0000 018B                 delay_ms(400);
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RCALL _delay_ms
; 0000 018C                 break;
	RJMP _0x8E
; 0000 018D             case 1:
_0x8F:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x99
; 0000 018E                 nowStat = 'L';
	LDI  R30,LOW(76)
	RCALL SUBOPT_0x20
; 0000 018F                 DC_front(); Motor_fast();
; 0000 0190                 if (leftD > D_D) { Servo_motor(-45); }
	CP   R30,R6
	CPC  R31,R7
	BRSH _0x95
	LDI  R26,LOW(65491)
	LDI  R27,HIGH(65491)
	RJMP _0xB1
; 0000 0191                 else if (leftD > D_C) { Servo_motor(-35); }
_0x95:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CP   R30,R6
	CPC  R31,R7
	BRSH _0x97
	LDI  R26,LOW(65501)
	LDI  R27,HIGH(65501)
	RJMP _0xB1
; 0000 0192                 else { Servo_motor(-15); }
_0x97:
	LDI  R26,LOW(65521)
	LDI  R27,HIGH(65521)
_0xB1:
	RCALL _Servo_motor
; 0000 0193                 delay_ms(400);
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RCALL _delay_ms
; 0000 0194                 break;
	RJMP _0x8E
; 0000 0195 
; 0000 0196             default:
_0x99:
; 0000 0197                 DC_front(); Motor_slow(); Servo_motor(0);
	RCALL SUBOPT_0x21
; 0000 0198             }
_0x8E:
; 0000 0199             mode = 0;
	CLR  R5
; 0000 019A             delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RJMP _0xAD
; 0000 019B         }
; 0000 019C         else if (leftD >= D_B && rightD >= D_B) {
_0x8B:
	RCALL SUBOPT_0x22
	BRLO _0x9C
	RCALL SUBOPT_0x23
	BRSH _0x9D
_0x9C:
	RJMP _0x9B
_0x9D:
; 0000 019D             nowStat = 'F';
	LDI  R30,LOW(70)
	MOV  R4,R30
; 0000 019E             Servo_motor(0); delay_ms(100); DC_front(); Motor_fast();
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _Servo_motor
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
	RCALL _DC_front
	RCALL _Motor_fast
; 0000 019F         }
; 0000 01A0         else {
	RJMP _0x9E
_0x9B:
; 0000 01A1             switch (L_R) {
	RCALL SUBOPT_0x1F
; 0000 01A2             case 0:
	BRNE _0xA2
; 0000 01A3                 nowStat = 'l';
	LDI  R30,LOW(108)
	MOV  R4,R30
; 0000 01A4                 if (leftD < D_A) { mode = 1; DC_back(); Motor_fast(); Servo_motor(-45); delay_ms(400); Servo_motor(0); d ...
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R6,R30
	CPC  R7,R31
	BRSH _0xA3
	RCALL SUBOPT_0x24
	LDI  R26,LOW(65491)
	LDI  R27,HIGH(65491)
	RCALL _Servo_motor
	RCALL SUBOPT_0x1B
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
; 0000 01A5                 else if (leftD < D_B) { DC_front(); Motor_fast(); Servo_motor(5 * (D_B - leftD)); }
	RJMP _0xA4
_0xA3:
	RCALL SUBOPT_0x22
	BRSH _0xA5
	RCALL SUBOPT_0x25
	SUB  R30,R6
	SBC  R31,R7
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	RCALL __MULW12U
	MOVW R26,R30
	RCALL _Servo_motor
; 0000 01A6                 break;
_0xA5:
_0xA4:
	RJMP _0xA1
; 0000 01A7 
; 0000 01A8             case 1:
_0xA2:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xAA
; 0000 01A9                 nowStat = 'r';
	LDI  R30,LOW(114)
	MOV  R4,R30
; 0000 01AA                 if (rightD < D_A) { mode = 1; DC_back(); Motor_fast(); Servo_motor(45); delay_ms(400); Servo_motor(0); d ...
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CP   R8,R30
	CPC  R9,R31
	BRSH _0xA7
	RCALL SUBOPT_0x24
	LDI  R26,LOW(45)
	LDI  R27,0
	RCALL _Servo_motor
	RCALL SUBOPT_0x1B
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
; 0000 01AB                 else if (rightD < D_B) { DC_front(); Motor_fast(); Servo_motor(-5 * (D_B - rightD)); }
	RJMP _0xA8
_0xA7:
	RCALL SUBOPT_0x23
	BRSH _0xA9
	RCALL SUBOPT_0x25
	SUB  R30,R8
	SBC  R31,R9
	LDI  R26,LOW(65531)
	LDI  R27,HIGH(65531)
	RCALL __MULW12U
	MOVW R26,R30
	RCALL _Servo_motor
; 0000 01AC                 break;
_0xA9:
_0xA8:
	RJMP _0xA1
; 0000 01AD 
; 0000 01AE             default:
_0xAA:
; 0000 01AF                 DC_front(); Motor_slow(); Servo_motor(0);
	RCALL SUBOPT_0x21
; 0000 01B0             }
_0xA1:
; 0000 01B1 
; 0000 01B2             delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
_0xAD:
	RCALL _delay_ms
; 0000 01B3         }
_0x9E:
_0x84:
; 0000 01B4     }
	RJMP _0x75
; 0000 01B5 }
_0xAB:
	RJMP _0xAB
; .FEND
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

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	RCALL __SAVELOCR6
	MOVW R18,R26
	LDD  R21,Y+6
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	MOVW R26,R18
	ADIW R26,4
	RCALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1RNS 18,4
_0x2000012:
	MOVW R26,R18
	ADIW R26,2
	RCALL SUBOPT_0x26
	SBIW R30,1
	ST   Z,R21
_0x2000013:
	MOVW R26,R18
	RCALL __GETW1P
	TST  R31
	BRMI _0x2000014
	RCALL SUBOPT_0x26
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	MOVW R26,R18
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	RCALL __LOADLOCR6
	ADIW R28,7
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	RCALL SUBOPT_0x27
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	RCALL SUBOPT_0x27
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	RCALL SUBOPT_0x28
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x29
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2A
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2A
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	RCALL SUBOPT_0x28
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	RCALL SUBOPT_0x28
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	RCALL SUBOPT_0x27
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	RCALL SUBOPT_0x27
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x29
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	RCALL SUBOPT_0x27
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x29
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR6
	MOVW R30,R28
	RCALL __ADDW1R15
	__GETWRZ 20,21,14
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2060001
_0x2000072:
	MOVW R26,R28
	ADIW R26,8
	RCALL __ADDW2R15
	MOVW R16,R26
	__PUTWSR 20,21,8
	LDI  R30,LOW(0)
	STD  Y+10,R30
	STD  Y+10+1,R30
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,12
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2060001:
	RCALL __LOADLOCR6
	ADIW R28,12
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_TCsec:
	.BYTE 0x4
_TCstart:
	.BYTE 0x4
_leftArr:
	.BYTE 0xA
_rightArr:
	.BYTE 0xA
_frontArr:
	.BYTE 0xA
_frontPastD:
	.BYTE 0x2
_rightPastD:
	.BYTE 0x2
_L_R:
	.BYTE 0x1
_rangeStr:
	.BYTE 0x5
_TCsecStr:
	.BYTE 0xA

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R17
	MOV  R17,R26
	LDS  R30,101
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	STS  101,R30
	LDS  R30,101
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x2:
	ORI  R30,1
	STS  101,R30
	__DELAY_USB 246
	OUT  0x1B,R17
	__DELAY_USB 246
	LDS  R30,101
	ANDI R30,0xFE
	STS  101,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	RCALL _LCD_Comm
	LDI  R26,LOW(2)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	OUT  0x2C+1,R31
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	MOV  R30,R17
	LDI  R26,LOW(_rightArr)
	LDI  R27,HIGH(_rightArr)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x6:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	IN   R30,0x2C
	IN   R31,0x2C+1
	MOVW R26,R30
	LDI  R30,LOW(116)
	LDI  R31,HIGH(116)
	RCALL __DIVW21U
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	MOV  R30,R17
	LDI  R26,LOW(_frontArr)
	LDI  R27,HIGH(_frontArr)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	MOV  R30,R17
	LDI  R26,LOW(_leftArr)
	LDI  R27,HIGH(_leftArr)
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	MOVW R30,R20
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xB:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CP   R20,R30
	CPC  R21,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xD:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	LD   R30,X+
	LD   R31,X+
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	ST   -Y,R21
	ST   -Y,R20
	ST   -Y,R19
	ST   -Y,R18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x10:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(4)
	LDI  R27,0
	RJMP _quick_sort

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x12:
	SBI  0x18,0
	__DELAY_USB 49
	CBI  0x18,0
	MOV  R26,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x14:
	RCALL _LCD_pos
	LDI  R30,LOW(_rangeStr)
	LDI  R31,HIGH(_rangeStr)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x15:
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
	LDI  R26,LOW(_rangeStr)
	LDI  R27,HIGH(_rangeStr)
	RCALL _LCD_STR
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(_TCsecStr)
	LDI  R31,HIGH(_TCsecStr)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x17:
	LDS  R30,_TCsec
	LDS  R31,_TCsec+1
	LDS  R22,_TCsec+2
	LDS  R23,_TCsec+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(0)
	STS  _TCstart,R30
	STS  _TCstart+1,R30
	STS  _TCstart+2,R30
	STS  _TCstart+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:20 WORDS
SUBOPT_0x19:
	LDI  R26,LOW(25)
	LDI  R27,0
	RCALL _Servo_motor
	LDI  R26,LOW(200)
	LDI  R27,0
	RCALL _delay_ms
	LDI  R26,LOW(65511)
	LDI  R27,HIGH(65511)
	RCALL _Servo_motor
	LDI  R26,LOW(200)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	MOV  R4,R30
	RCALL _DC_back
	RCALL _Motor_slow
	LDS  R30,_rightPastD
	LDS  R31,_rightPastD+1
	CP   R30,R12
	CPC  R31,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RCALL _delay_ms
	LDI  R26,LOW(0)
	LDI  R27,0
	RJMP _Servo_motor

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDS  R30,_frontPastD
	LDS  R31,_frontPastD+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDS  R30,_rightPastD
	LDS  R31,_rightPastD+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	RCALL _Servo_motor
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDS  R30,_L_R
	LDI  R31,0
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	MOV  R4,R30
	RCALL _DC_front
	RCALL _Motor_fast
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	RCALL _DC_front
	RCALL _Motor_slow
	LDI  R26,LOW(0)
	LDI  R27,0
	RJMP _Servo_motor

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R6,R30
	CPC  R7,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R8,R30
	CPC  R9,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(1)
	MOV  R5,R30
	RCALL _DC_back
	RJMP _Motor_fast

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	RCALL _DC_front
	RCALL _Motor_fast
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x26:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x27:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x28:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x29:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2A:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ADDW1R15:
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	RET

__LSRD16:
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xE66
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
