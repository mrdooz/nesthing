8000 78         SEI
8001 a940       LDA #$40
8003 8d1740     STA $4017 ; Joystick 2
8006 a910       LDA #$10
8008 8d0020     STA $2000 ; PPU Control Register 1
800b a906       LDA #$06
800d 8d0120     STA $2001 ; PPU Control Register 2
8010 a900       LDA #$00
8012 8d0220     STA $2002 ; PPU Status Register
8015 ad0220     LDA $2002 ; PPU Status Register
8018 2980       AND #$80
801a f0f9       BEQ 8015
801c a900       LDA #$00
801e 8d0220     STA $2002 ; PPU Status Register
8021 ad0220     LDA $2002 ; PPU Status Register
8024 2980       AND #$80
8026 f0f9       BEQ 8021
8028 a900       LDA #$00
802a 8d0220     STA $2002 ; PPU Status Register
802d ad0220     LDA $2002 ; PPU Status Register
8030 2980       AND #$80
8032 f0f9       BEQ 802d
8034 a200       LDX #$00
8036 a900       LDA #$00
8038 9500       STA $00, X
803a e8         INX
803b d0fb       BNE 8038
803d 9d0001     STA $0100, X
8040 e8         INX
8041 d0fa       BNE 803d
8043 a2ff       LDX #$ff
8045 db 9a
8046 a200       LDX #$00
8048 bd8f80     LDA $808f, X
804b dd6003     CMP $0360, X
804e d008       BNE 8058
8050 e8         INX
8051 e006       CPX #$06
8053 d0f3       BNE 8048
8055 4c6580     JMP $8065
8058 a200       LDX #$00
805a bd8f80     LDA $808f, X
805d 9d6003     STA $0360, X
8060 e8         INX
8061 e00c       CPX #$0c
8063 d0f5       BNE 805a
8065 a200       LDX #$00
8067 a900       LDA #$00
8069 9d7003     STA $0370, X
806c e8         INX
806d e080       CPX #$80
806f d0f8       BNE 8069
8071 20         JSR
8072 c0f3       CPY #$f3
8074 a910       LDA #$10
8076 8514       STA $14
8078 a906       LDA #$06
807a 8515       STA $15
807c a92e       LDA #$2e
807e 8d2540     STA $4025
8081 a514       LDA $14
8083 0990       ORA #$90
8085 8d0020     STA $2000 ; PPU Control Register 1
8088 ea         INC
8089 ea         INC
808a ea         INC
808b 4c8880     JMP $8088
808e 60         RTS
808f 1133       ORA ($33), Y
8091 5577       EOR $77, X
8093 99aa00     STA $00aa, Y
8096 0500       ORA $00
8098 00         BRK
8099 00         BRK
809a 00         BRK
809b 58         CLI
809c 40         RTI
809d db ff
809e db ff
809f db ff
80a0 ad0220     LDA $2002 ; PPU Status Register
80a3 a514       LDA $14
80a5 297f       AND #$7f
80a7 8d0020     STA $2000 ; PPU Control Register 1
80aa a517       LDA $17
80ac 8d0520     STA $2005 ; Background Scroll
80af a516       LDA $16
80b1 8d0520     STA $2005 ; Background Scroll
80b4 20         JSR
80b5 ac8cad     LDY $ad8c
80b8 db 3b
80b9 01c9       ORA ($c9, X)
80bb 00         BRK
80bc d060       BNE 811e
80be 20         JSR
80bf 5d9220     EOR $2092, X
80c2 db b7
80c3 8c2031     STY $3120 ; PPU Control Register 1
80c6 bd20b7     LDA $b720, X
80c9 bc20b9     LDY $b920, X
80cc bd201f     LDA $1f20, X
80cf db 93
80d0 20         JSR
80d1 358c       AND $8c, X
80d3 20         JSR
80d4 db 17
80d5 8e2092     STX $9220
80d8 8520       STA $20
80da 5d8320     EOR $2083, X
80dd db 47
80de 8420       STY $20
80e0 db 3f
80e1 db bb
80e2 20         JSR
80e3 db 23
80e4 db 92
80e5 20         JSR
80e6 db b7
80e7 9120       STA ($20), Y
80e9 ae9020     LDX $2090 ; PPU Control Register 1
80ec db 32
80ed 9120       STA ($20), Y
80ef 9dbe20     STA $20be, X
80f2 db 47
80f3 8920       STA #$20
80f5 ec8920     CPX $2089 ; PPU Control Register 2
80f8 c1ba       CMP ($ba, X)
80fa 20         JSR
80fb a0b9       LDY #$b9
80fd 20         JSR
80fe 1eba20     ASL $20ba, X
8101 db 5b
8102 b9203a     LDA $3a20, Y
8105 8120       STA ($20, X)
8107 6a         ROR
8108 8120       STA ($20, X)
810a 24a7       BIT $a7
810c 20         JSR
810d db 3f
810e 8220       STX #$20
8110 5d8220     EOR $2082, X
8113 4d8820     EOR $2088 ; PPU Control Register 1
8116 448a       JMP $8a
8118 20         JSR
8119 db 14
811a 8620       STX $20
811c db 5b
811d 8620       STX $20
811f c9f3       CMP #$f3
8121 20         JSR
8122 e486       CPX $86
8124 a517       LDA $17
8126 8d0520     STA $2005 ; Background Scroll
8129 a516       LDA $16
812b 8d0520     STA $2005 ; Background Scroll
812e ea         INC
812f ea         INC
8130 ea         INC
8131 a514       LDA $14
8133 0990       ORA #$90
8135 8d0020     STA $2000 ; PPU Control Register 1
8138 58         CLI
8139 40         RTI
813a a50c       LDA $0c
813c c900       CMP #$00
813e d011       BNE 8151
8140 a50a       LDA $0a
8142 c908       CMP #$08
8144 d00a       BNE 8150
8146 a504       LDA $04
8148 4505       EOR $05
814a 2504       AND $04
814c c980       CMP #$80
814e f001       BEQ 8151
8150 60         RTS
8151 a900       LDA #$00
8153 8d3801     STA $0138
8156 850c       STA $0c
8158 8d3c01     STA $013c
815b 8d3d01     STA $013d
815e 8545       STA $45
8160 a901       LDA #$01
8162 20         JSR
8163 c6f3       DEC $f3
8165 a910       LDA #$10
8167 850a       STA $0a
8169 60         RTS
816a a581       LDA $81
816c c900       CMP #$00
816e d001       BNE 8171
8170 60         RTS
8171 ad2301     LDA $0123
8174 c900       CMP #$00
8176 f001       BEQ 8179
8178 60         RTS
8179 a50a       LDA $0a
817b c920       CMP #$20
817d d001       BNE 8180
817f 60         RTS
8180 ad2201     LDA $0122
8183 f001       BEQ 8186
8185 60         RTS
8186 a50f       LDA $0f
8188 d001       BNE 818b
818a 60         RTS
818b 38         SEC
818c a538       LDA $38
818e ed1a01     SBC $011a
8191 8d2e01     STA $012e
8194 a510       LDA $10
8196 c900       CMP #$00
8198 f00e       BEQ 81a8
819a 38         SEC
819b a538       LDA $38
819d e910       SBC #$10
819f c910       CMP #$10
81a1 b00b       BCS 81ae
81a3 a910       LDA #$10
81a5 4cae81     JMP $81ae
81a8 a508       LDA $08
81aa c900       CMP #$00
81ac f00c       BEQ 81ba
81ae 38         SEC
81af ed1a01     SBC $011a
81b2 f020       BEQ 81d4
81b4 8d3101     STA $0131
81b7 4cd581     JMP $81d5
81ba a9fd       LDA #$fd
81bc 8d3101     STA $0131
81bf a504       LDA $04
81c1 2903       AND #$03
81c3 c902       CMP #$02
81c5 f00e       BEQ 81d5
81c7 a903       LDA #$03
81c9 8d3101     STA $0131
81cc a504       LDA $04
81ce 2903       AND #$03
81d0 c901       CMP #$01
81d2 f001       BEQ 81d5
81d4 60         RTS
81d5 18         CLC
81d6 ad1a01     LDA $011a
81d9 6d3101     ADC $0131
81dc c910       CMP #$10
81de b012       BCS 81f2
81e0 38         SEC
81e1 e910       SBC #$10
81e3 49ff       EOR #$ff
81e5 18         CLC
81e6 6901       ADC #$01
81e8 18         CLC
81e9 6d3101     ADC $0131
81ec 8d3101     STA $0131
81ef 4c0c82     JMP $820c
81f2 18         CLC
81f3 ad1f01     LDA $011f
81f6 6d3101     ADC $0131
81f9 c9b8       CMP #$b8
81fb 900f       BCC 820c
81fd 38         SEC
81fe e9b8       SBC #$b8
8200 49ff       EOR #$ff
8202 18         CLC
8203 6901       ADC #$01
8205 18         CLC
8206 6d3101     ADC $0131
8209 8d3101     STA $0131
820c a200       LDX #$00
820e 18         CLC
820f bd1a01     LDA $011a, X
8212 6d3101     ADC $0131
8215 9d1a01     STA $011a, X
8218 e8         INX
8219 e006       CPX #$06
821b d0f1       BNE 820e
821d a50a       LDA $0a
821f c908       CMP #$08
8221 d01b       BNE 823e
8223 18         CLC
8224 ad1a01     LDA $011a
8227 6d2e01     ADC $012e
822a 8538       STA $38
822c c910       CMP #$10
822e b005       BCS 8235
8230 a910       LDA #$10
8232 8538       STA $38
8234 60         RTS
8235 c9bc       CMP #$bc
8237 9005       BCC 823e
8239 a9bc       LDA #$bc
823b 8538       STA $38
823d 60         RTS
823e 60         RTS
823f a50a       LDA $0a
8241 c910       CMP #$10
8243 d017       BNE 825c
8245 ad1201     LDA $0112
8248 c900       CMP #$00
824a f010       BEQ 825c
824c ad2801     LDA $0128
824f c900       CMP #$00
8251 f009       BEQ 825c
8253 a908       LDA #$08
8255 850a       STA $0a
8257 a980       LDA #$80
8259 8d3801     STA $0138
825c 60         RTS
825d a581       LDA $81
825f c900       CMP #$00
8261 d001       BNE 8264
8263 60         RTS
8264 a58c       LDA $8c
8266 c900       CMP #$00
8268 d001       BNE 826b
826a 60         RTS
826b a591       LDA $91
826d 18         CLC
826e 6908       ADC #$08
8270 cd1401     CMP $0114
8273 b001       BCS 8276
8275 60         RTS
8276 18         CLC
8277 ad1401     LDA $0114
827a 6904       ADC #$04
827c c591       CMP $91
827e 9062       BCC 82e2
8280 a594       LDA $94
8282 18         CLC
8283 6908       ADC #$08
8285 cd1a01     CMP $011a
8288 9058       BCC 82e2
828a 18         CLC
828b ad1f01     LDA $011f
828e 6908       ADC #$08
8290 8d3101     STA $0131
8293 18         CLC
8294 a594       LDA $94
8296 6908       ADC #$08
8298 cd3101     CMP $0131
829b b045       BCS 82e2
829d a58c       LDA $8c
829f 48         PHA
82a0 a900       LDA #$00
82a2 858c       STA $8c
82a4 8d2801     STA $0128
82a7 85d9       STA $d9
82a9 85d8       STA $d8
82ab ad3801     LDA $0138
82ae c900       CMP #$00
82b0 f005       BEQ 82b7
82b2 a901       LDA #$01
82b4 8d3801     STA $0138
82b7 a909       LDA #$09
82b9 8588       STA $88
82bb a984       LDA #$84
82bd 8589       STA $89
82bf 20         JSR
82c0 98         TYA
82c1 9068       BCC 832b
82c3 8d2d01     STA $012d
82c6 c901       CMP #$01
82c8 f019       BEQ 82e3
82ca c902       CMP #$02
82cc f03c       BEQ 830a
82ce c903       CMP #$03
82d0 f043       BEQ 8315
82d2 c904       CMP #$04
82d4 f050       BEQ 8326
82d6 c905       CMP #$05
82d8 f055       BEQ 832f
82da c906       CMP #$06
82dc f057       BEQ 8335
82de c907       CMP #$07
82e0 f063       BEQ 8345
82e2 60         RTS
82e3 a901       LDA #$01
82e5 8d2901     STA $0129
82e8 ce0001     DEC $0100
82eb f005       BEQ 82f2
82ed ce0001     DEC $0100
82f0 d003       BNE 82f5
82f2 ee0001     INC $0100
82f5 ae0001     LDX $0100
82f8 8e0101     STX $0101
82fb 8649       STX $49
82fd 864a       STX $4a
82ff bd119a     LDA $9a11, X
8302 8d0201     STA $0102
8305 a900       LDA #$00
8307 8545       STA $45
8309 60         RTS
830a a901       LDA #$01
830c 8d2901     STA $0129
830f a901       LDA #$01
8311 8d2801     STA $0128
8314 60         RTS
8315 a902       LDA #$02
8317 8d2901     STA $0129
831a ad0e01     LDA $010e
831d f001       BEQ 8320
831f 60         RTS
8320 a908       LDA #$08
8322 20         JSR
8323 c6f3       DEC $f3
8325 60         RTS
8326 a901       LDA #$01
8328 8d2901     STA $0129
832b 20         JSR
832c 168f       ASL $8f, X
832e 60         RTS
832f a904       LDA #$04
8331 8d2901     STA $0129
8334 60         RTS
8335 a901       LDA #$01
8337 8d2901     STA $0129
833a a900       LDA #$00
833c 8d2501     STA $0125
833f a901       LDA #$01
8341 8d2401     STA $0124
8344 60         RTS
8345 a901       LDA #$01
8347 8d2901     STA $0129
834a a510       LDA $10
834c c900       CMP #$00
834e d00c       BNE 835c
8350 e60d       INC $0d
8352 a90e       LDA #$0e
8354 20         JSR
8355 c6f3       DEC $f3
8357 a926       LDA #$26
8359 8d0e01     STA $010e
835c 60         RTS
835d a581       LDA $81
835f c901       CMP #$01
8361 f001       BEQ 8364
8363 60         RTS
8364 a50f       LDA $0f
8366 c900       CMP #$00
8368 d001       BNE 836b
836a 60         RTS
836b a58c       LDA $8c
836d c900       CMP #$00
836f f001       BEQ 8372
8371 60         RTS
8372 a900       LDA #$00
8374 858d       STA $8d
8376 a90f       LDA #$0f
8378 858f       STA $8f
837a a984       LDA #$84
837c 8590       STA $90
837e a200       LDX #$00
8380 ad4501     LDA $0145
8383 8d3101     STA $0131
8386 ad3101     LDA $0131
8389 c900       CMP #$00
838b f075       BEQ 8402
838d bd8206     LDA $0682, X
8390 2908       AND #$08
8392 d009       BNE 839d
8394 e8         INX
8395 e8         INX
8396 e8         INX
8397 ce3101     DEC $0131
839a 4c8683     JMP $8386
839d bd8006     LDA $0680, X
83a0 0a         ASL
83a1 0a         ASL
83a2 0a         ASL
83a3 18         CLC
83a4 6910       ADC #$10
83a6 8591       STA $91
83a8 bd8106     LDA $0681, X
83ab 0a         ASL
83ac 0a         ASL
83ad 0a         ASL
83ae 0a         ASL
83af 18         CLC
83b0 6910       ADC #$10
83b2 8594       STA $94
83b4 20         JSR
83b5 db 9b
83b6 db 92
83b7 a200       LDX #$00
83b9 dd0384     CMP $8403, X
83bc f017       BEQ 83d5
83be e8         INX
83bf e006       CPX #$06
83c1 d0f6       BNE 83b9
83c3 2907       AND #$07
83c5 f009       BEQ 83d0
83c7 c906       CMP #$06
83c9 9016       BCC 83e1
83cb a904       LDA #$04
83cd 4ce183     JMP $83e1
83d0 a903       LDA #$03
83d2 4ce183     JMP $83e1
83d5 a907       LDA #$07
83d7 e003       CPX #$03
83d9 9006       BCC 83e1
83db a510       LDA $10
83dd d0f1       BNE 83d0
83df a906       LDA #$06
83e1 cd2d01     CMP $012d
83e4 f0ce       BEQ 83b4
83e6 858c       STA $8c
83e8 38         SEC
83e9 e901       SBC #$01
83eb 0a         ASL
83ec 0a         ASL
83ed 0a         ASL
83ee 18         CLC
83ef 658f       ADC $8f
83f1 858f       STA $8f
83f3 a590       LDA $90
83f5 6900       ADC #$00
83f7 8590       STA $90
83f9 a903       LDA #$03
83fb 8593       STA $93
83fd a901       LDA #$01
83ff 8d3e01     STA $013e
8402 60         RTS
8403 db 07
8404 db df
8405 3db91b     AND $1bb9, X
8408 5e0000     LSR $0000, X
840b 0100       ORA ($00, X)
840d 00         BRK
840e 00         BRK
840f 2224       ROL #$24
8411 2620       ROL $20
8413 28         PLP
8414 2a         ROL
8415 db ff
8416 00         BRK
8417 2c2e30     BIT $302e ; PPU Memory Address
841a 20         JSR
841b db 32
841c 34ff       BIT $ff, X
841e 00         BRK
841f 3638       ROL $38, X
8421 db 3a
8422 20         JSR
8423 3c3eff     BIT $ff3e, X
8426 00         BRK
8427 40         RTI
8428 4244       LSR #$44
842a 20         JSR
842b 4648       LSR $48
842d db ff
842e 00         BRK
842f 4a         LSR
8430 4c4e20     JMP $204e ; PPU Memory Address
8433 5052       BVC 8487
8435 db ff
8436 00         BRK
8437 5456       JMP $56, X
8439 58         CLI
843a 20         JSR
843b db 5a
843c 5cff00     JMP $00ff, X
843f 5e1517     LSR $1715, X
8442 20         JSR
8443 191bff     ORA $ff1b, Y
8446 00         BRK
8447 a50a       LDA $0a
8449 c910       CMP #$10
844b d027       BNE 8474
844d a581       LDA $81
844f c900       CMP #$00
8451 f021       BEQ 8474
8453 a50f       LDA $0f
8455 c900       CMP #$00
8457 f01b       BEQ 8474
8459 ad4501     LDA $0145
845c 8d2e01     STA $012e
845f a200       LDX #$00
8461 ad2e01     LDA $012e
8464 c900       CMP #$00
8466 f00c       BEQ 8474
8468 20         JSR
8469 78         SEI
846a 84e8       STY $e8
846c e8         INX
846d e8         INX
846e ce2e01     DEC $012e
8471 4c6184     JMP $8461
8474 20         JSR
8475 00         BRK
8476 8560       STA $60
8478 bd8006     LDA $0680, X
847b 0a         ASL
847c 0a         ASL
847d 0a         ASL
847e 18         CLC
847f 690f       ADC #$0f
8481 8d3101     STA $0131
8484 bd8106     LDA $0681, X
8487 0a         ASL
8488 0a         ASL
8489 0a         ASL
848a 0a         ASL
848b 18         CLC
848c 6910       ADC #$10
848e 8d3201     STA $0132
8491 a906       LDA #$06
8493 8d2f01     STA $012f
8496 a000       LDY #$00
8498 b99001     LDA $0190, Y
849b c900       CMP #$00
849d f022       BEQ 84c1
849f ad3101     LDA $0131
84a2 d99201     CMP $0192, Y
84a5 d01a       BNE 84c1
84a7 ad3201     LDA $0132
84aa d99301     CMP $0193, Y
84ad d012       BNE 84c1
84af bd8206     LDA $0682, X
84b2 c9f0       CMP #$f0
84b4 f029       BEQ 84df
84b6 a906       LDA #$06
84b8 999001     STA $0190, Y
84bb a900       LDA #$00
84bd 999101     STA $0191, Y
84c0 60         RTS
84c1 c8         INY
84c2 c8         INY
84c3 c8         INY
84c4 c8         INY
84c5 ce2f01     DEC $012f
84c8 d0ce       BNE 8498
84ca a906       LDA #$06
84cc 8d2f01     STA $012f
84cf a000       LDY #$00
84d1 b99001     LDA $0190, Y
84d4 c900       CMP #$00
84d6 d01e       BNE 84f6
84d8 bd8206     LDA $0682, X
84db c9f0       CMP #$f0
84dd d017       BNE 84f6
84df a901       LDA #$01
84e1 999001     STA $0190, Y
84e4 a900       LDA #$00
84e6 999101     STA $0191, Y
84e9 ad3101     LDA $0131
84ec 999201     STA $0192, Y
84ef ad3201     LDA $0132
84f2 999301     STA $0193, Y
84f5 60         RTS
84f6 c8         INY
84f7 c8         INY
84f8 c8         INY
84f9 c8         INY
84fa ce2f01     DEC $012f
84fd d0d2       BNE 84d1
84ff 60         RTS
8500 a906       LDA #$06
8502 8d2f01     STA $012f
8505 a200       LDX #$00
8507 a000       LDY #$00
8509 bd9101     LDA $0191, X
850c c900       CMP #$00
850e f006       BEQ 8516
8510 de9101     DEC $0191, X
8513 4c7385     JMP $8573
8516 bd9001     LDA $0190, X
8519 c900       CMP #$00
851b f056       BEQ 8573
851d 8e3101     STX $0131
8520 38         SEC
8521 e901       SBC #$01
8523 0a         ASL
8524 aa         LDX
8525 bd8685     LDA $8586, X
8528 c900       CMP #$00
852a f00f       BEQ 853b
852c 99cd02     STA $02cd, Y
852f bd8785     LDA $8587, X
8532 99d102     STA $02d1, Y
8535 ae3101     LDX $0131
8538 4c4e85     JMP $854e
853b ae3101     LDX $0131
853e a900       LDA #$00
8540 9d9001     STA $0190, X
8543 a9f0       LDA #$f0
8545 99cc02     STA $02cc, Y
8548 99d002     STA $02d0, Y
854b 4c7385     JMP $8573
854e bd9201     LDA $0192, X
8551 99cc02     STA $02cc, Y
8554 99d002     STA $02d0, Y
8557 a900       LDA #$00
8559 99ce02     STA $02ce, Y
855c 99d202     STA $02d2, Y
855f bd9301     LDA $0193, X
8562 99cf02     STA $02cf, Y
8565 18         CLC
8566 6908       ADC #$08
8568 99d302     STA $02d3, Y
856b fe9001     INC $0190, X
856e a903       LDA #$03
8570 9d9101     STA $0191, X
8573 8a         STX
8574 18         CLC
8575 6904       ADC #$04
8577 aa         LDX
8578 98         TYA
8579 18         CLC
857a 6908       ADC #$08
857c a8         TAY
857d ce2f01     DEC $012f
8580 f003       BEQ 8585
8582 4c0985     JMP $8509
8585 60         RTS
8586 db ff
8587 db df
8588 db d2
8589 db d3
858a d4d5       CPY $d5, X
858c d6d7       DEC $d7, X
858e deff00     DEC $00ff, X
8591 00         BRK
8592 ad2301     LDA $0123
8595 c900       CMP #$00
8597 d042       BNE 85db
8599 a581       LDA $81
859b c900       CMP #$00
859d f03b       BEQ 85da
859f ad2401     LDA $0124
85a2 c900       CMP #$00
85a4 f034       BEQ 85da
85a6 ad1f01     LDA $011f
85a9 c9b8       CMP #$b8
85ab 902d       BCC 85da
85ad a900       LDA #$00
85af 8581       STA $81
85b1 858c       STA $8c
85b3 85d9       STA $d9
85b5 850f       STA $0f
85b7 85d8       STA $d8
85b9 a901       LDA #$01
85bb 8d2301     STA $0123
85be a910       LDA #$10
85c0 850a       STA $0a
85c2 a900       LDA #$00
85c4 8d3801     STA $0138
85c7 8d2801     STA $0128
85ca a90e       LDA #$0e
85cc 8588       STA $88
85ce a986       LDA #$86
85d0 8589       STA $89
85d2 20         JSR
85d3 98         TYA
85d4 90a9       BCC 857f
85d6 db 0b
85d7 20         JSR
85d8 c6f3       DEC $f3
85da 60         RTS
85db ad1a01     LDA $011a
85de c9c8       CMP #$c8
85e0 b026       BCS 8608
85e2 ee1a01     INC $011a
85e5 ee1b01     INC $011b
85e8 ee1c01     INC $011c
85eb ee1d01     INC $011d
85ee ee1e01     INC $011e
85f1 ee1f01     INC $011f
85f4 a200       LDX #$00
85f6 bd1a01     LDA $011a, X
85f9 c9c2       CMP #$c2
85fb 9005       BCC 8602
85fd a9f0       LDA #$f0
85ff 9d1401     STA $0114, X
8602 e8         INX
8603 e006       CPX #$06
8605 d0ef       BNE 85f6
8607 60         RTS
8608 a900       LDA #$00
860a 8d2401     STA $0124
860d 60         RTS
860e 00         BRK
860f 0100       ORA ($00, X)
8611 00         BRK
8612 00         BRK
8613 00         BRK
8614 a510       LDA $10
8616 d042       BNE 865a
8618 a50a       LDA $0a
861a c910       CMP #$10
861c d019       BNE 8637
861e a500       LDA $00
8620 4501       EOR $01
8622 2500       AND $00
8624 c910       CMP #$10
8626 d032       BNE 865a
8628 a900       LDA #$00
862a 8d3d01     STA $013d
862d a901       LDA #$01
862f 8d3c01     STA $013c
8632 a920       LDA #$20
8634 850a       STA $0a
8636 60         RTS
8637 a50a       LDA $0a
8639 c920       CMP #$20
863b d01d       BNE 865a
863d a500       LDA $00
863f 4501       EOR $01
8641 2501       AND $01
8643 c910       CMP #$10
8645 d013       BNE 865a
8647 ee3d01     INC $013d
864a ad3d01     LDA $013d
864d c902       CMP #$02
864f 9009       BCC 865a
8651 a901       LDA #$01
8653 8d3c01     STA $013c
8656 a910       LDA #$10
8658 850a       STA $0a
865a 60         RTS
865b a200       LDX #$00
865d a50a       LDA $0a
865f c910       CMP #$10
8661 f001       BEQ 8664
8663 60         RTS
8664 a510       LDA $10
8666 d00c       BNE 8674
8668 a500       LDA $00
866a c990       CMP #$90
866c d006       BNE 8674
866e a51a       LDA $1a
8670 c910       CMP #$10
8672 902f       BCC 86a3
8674 bd7c03     LDA $037c, X
8677 c900       CMP #$00
8679 d049       BNE 86c4
867b e8         INX
867c e005       CPX #$05
867e d0f4       BNE 8674
8680 ad0901     LDA $0109
8683 c900       CMP #$00
8685 d016       BNE 869d
8687 a50f       LDA $0f
8689 c900       CMP #$00
868b f006       BEQ 8693
868d a581       LDA $81
868f c900       CMP #$00
8691 d031       BNE 86c4
8693 a900       LDA #$00
8695 85d8       STA $d8
8697 a901       LDA #$01
8699 8d0901     STA $0109
869c 60         RTS
869d a50f       LDA $0f
869f c900       CMP #$00
86a1 d004       BNE 86a7
86a3 20         JSR
86a4 ea         INC
86a5 db 8b
86a6 60         RTS
86a7 a581       LDA $81
86a9 c900       CMP #$00
86ab d017       BNE 86c4
86ad a900       LDA #$00
86af 8d6a01     STA $016a
86b2 8d6b01     STA $016b
86b5 8d6c01     STA $016c
86b8 c60d       DEC $0d
86ba a918       LDA #$18
86bc 850a       STA $0a
86be a901       LDA #$01
86c0 8d2201     STA $0122
86c3 60         RTS
86c4 a581       LDA $81
86c6 a000       LDY #$00
86c8 a21a       LDX #$1a
86ca c902       CMP #$02
86cc f006       BEQ 86d4
86ce a234       LDX #$34
86d0 c904       CMP #$04
86d2 d00f       BNE 86e3
86d4 b533       LDA $33, X
86d6 993300     STA $0033, Y
86d9 c8         INY
86da e8         INX
86db c01a       CPY #$1a
86dd d0f5       BNE 86d4
86df a901       LDA #$01
86e1 8581       STA $81
86e3 60         RTS
86e4 a50a       LDA $0a
86e6 c920       CMP #$20
86e8 d001       BNE 86eb
86ea 60         RTS
86eb ad3b01     LDA $013b
86ee c900       CMP #$00
86f0 f004       BEQ 86f6
86f2 ce3b01     DEC $013b
86f5 60         RTS
86f6 a512       LDA $12
86f8 0513       ORA $13
86fa f062       BEQ 875e
86fc a50a       LDA $0a
86fe c901       CMP #$01
8700 f00c       BEQ 870e
8702 a506       LDA $06
8704 c900       CMP #$00
8706 d047       BNE 874f
8708 a500       LDA $00
870a c910       CMP #$10
870c f041       BEQ 874f
870e c613       DEC $13
8710 a513       LDA $13
8712 0512       ORA $12
8714 f00b       BEQ 8721
8716 a513       LDA $13
8718 c9ff       CMP #$ff
871a d042       BNE 875e
871c c612       DEC $12
871e 4c5e87     JMP $875e
8721 a900       LDA #$00
8723 8516       STA $16
8725 e60a       INC $0a
8727 a50a       LDA $0a
8729 c909       CMP #$09
872b f022       BEQ 874f
872d c911       CMP #$11
872f f01e       BEQ 874f
8731 c904       CMP #$04
8733 f009       BEQ 873e
8735 a901       LDA #$01
8737 8512       STA $12
8739 a9e0       LDA #$e0
873b 8513       STA $13
873d 60         RTS
873e a905       LDA #$05
8740 850a       STA $0a
8742 a901       LDA #$01
8744 8510       STA $10
8746 a909       LDA #$09
8748 8512       STA $12
874a a960       LDA #$60
874c 8513       STA $13
874e 60         RTS
874f a900       LDA #$00
8751 850a       STA $0a
8753 8510       STA $10
8755 8512       STA $12
8757 8513       STA $13
8759 8521       STA $21
875b 8524       STA $24
875d 60         RTS
875e a5da       LDA $da
8760 c900       CMP #$00
8762 f002       BEQ 8766
8764 c6da       DEC $da
8766 ad2601     LDA $0126
8769 0d2701     ORA $0127
876c f020       BEQ 878e
876e ce2701     DEC $0127
8771 ad2701     LDA $0127
8774 0d2601     ORA $0126
8777 d008       BNE 8781
8779 a901       LDA #$01
877b 8d2401     STA $0124
877e 4c8e87     JMP $878e
8781 ad2701     LDA $0127
8784 c9ff       CMP #$ff
8786 d006       BNE 878e
8788 ce2601     DEC $0126
878b 4c8e87     JMP $878e
878e ad3801     LDA $0138
8791 c900       CMP #$00
8793 f009       BEQ 879e
8795 ce3801     DEC $0138
8798 d004       BNE 879e
879a a901       LDA #$01
879c 850c       STA $0c
879e a003       LDY #$03
87a0 a200       LDX #$00
87a2 b5c0       LDA $c0, X
87a4 15c1       ORA $c1, X
87a6 f00d       BEQ 87b5
87a8 38         SEC
87a9 b5c1       LDA $c1, X
87ab e901       SBC #$01
87ad 95c1       STA $c1, X
87af b5c0       LDA $c0, X
87b1 e900       SBC #$00
87b3 95c0       STA $c0, X
87b5 e8         INX
87b6 e8         INX
87b7 88         DEY
87b8 d0e8       BNE 87a2
87ba ad0e01     LDA $010e
87bd f003       BEQ 87c2
87bf ce0e01     DEC $010e
87c2 ad8e01     LDA $018e
87c5 0d8f01     ORA $018f
87c8 d001       BNE 87cb
87ca 60         RTS
87cb ce8f01     DEC $018f
87ce ad8f01     LDA $018f
87d1 0d8e01     ORA $018e
87d4 f00d       BEQ 87e3
87d6 ad8f01     LDA $018f
87d9 c9ff       CMP #$ff
87db d06f       BNE 884c
87dd ce8e01     DEC $018e
87e0 4c4c88     JMP $884c
87e3 a50a       LDA $0a
87e5 c930       CMP #$30
87e7 d029       BNE 8812
87e9 a519       LDA $19
87eb d007       BNE 87f4
87ed a900       LDA #$00
87ef 851d       STA $1d
87f1 4cf887     JMP $87f8
87f4 a900       LDA #$00
87f6 851e       STA $1e
87f8 a900       LDA #$00
87fa 8581       STA $81
87fc 850f       STA $0f
87fe 8d6a01     STA $016a
8801 8d6b01     STA $016b
8804 8d6c01     STA $016c
8807 a901       LDA #$01
8809 8d8c01     STA $018c
880c a905       LDA #$05
880e 8d8d01     STA $018d
8811 60         RTS
8812 a50a       LDA $0a
8814 c931       CMP #$31
8816 d014       BNE 882c
8818 a911       LDA #$11
881a 20         JSR
881b c6f3       DEC $f3
881d a900       LDA #$00
881f 8d8e01     STA $018e
8822 a9f0       LDA #$f0
8824 8d8f01     STA $018f
8827 a932       LDA #$32
8829 850a       STA $0a
882b 60         RTS
882c a50a       LDA $0a
882e c932       CMP #$32
8830 d005       BNE 8837
8832 a960       LDA #$60
8834 850a       STA $0a
8836 60         RTS
8837 a50a       LDA $0a
8839 c935       CMP #$35
883b d00f       BNE 884c
883d a90f       LDA #$0f
883f 20         JSR
8840 c6f3       DEC $f3
8842 a962       LDA #$62
8844 850a       STA $0a
8846 a9c8       LDA #$c8
8848 8d3b01     STA $013b
884b 60         RTS
884c 60         RTS
884d a50a       LDA $0a
884f c910       CMP #$10
8851 f001       BEQ 8854
8853 60         RTS
8854 a5d8       LDA $d8
8856 c900       CMP #$00
8858 d001       BNE 885b
885a 60         RTS
885b ad2301     LDA $0123
885e c900       CMP #$00
8860 f001       BEQ 8863
8862 60         RTS
8863 a5da       LDA $da
8865 c900       CMP #$00
8867 d049       BNE 88b2
8869 a504       LDA $04
886b 4505       EOR $05
886d 2504       AND $04
886f c980       CMP #$80
8871 d03f       BNE 88b2
8873 a5d9       LDA $d9
8875 2903       AND #$03
8877 d012       BNE 888b
8879 ad1401     LDA $0114
887c 85dc       STA $dc
887e 18         CLC
887f ad1a01     LDA $011a
8882 6908       ADC #$08
8884 85dd       STA $dd
8886 a903       LDA #$03
8888 4ca088     JMP $88a0
888b a5d9       LDA $d9
888d 290c       AND #$0c
888f d021       BNE 88b2
8891 ad1401     LDA $0114
8894 85de       STA $de
8896 18         CLC
8897 ad1a01     LDA $011a
889a 6908       ADC #$08
889c 85df       STA $df
889e a90c       LDA #$0c
88a0 05d9       ORA $d9
88a2 85d9       STA $d9
88a4 a903       LDA #$03
88a6 85da       STA $da
88a8 ad0e01     LDA $010e
88ab d005       BNE 88b2
88ad a90a       LDA #$0a
88af 20         JSR
88b0 c6f3       DEC $f3
88b2 a5d9       LDA $d9
88b4 2903       AND #$03
88b6 f019       BEQ 88d1
88b8 a5dc       LDA $dc
88ba 38         SEC
88bb e904       SBC #$04
88bd 85dc       STA $dc
88bf c910       CMP #$10
88c1 9008       BCC 88cb
88c3 a8         TAY
88c4 a6dd       LDX $dd
88c6 20         JSR
88c7 f188       SBC ($88), Y
88c9 9006       BCC 88d1
88cb a5d9       LDA $d9
88cd 290c       AND #$0c
88cf 85d9       STA $d9
88d1 a5d9       LDA $d9
88d3 290c       AND #$0c
88d5 f019       BEQ 88f0
88d7 a5de       LDA $de
88d9 38         SEC
88da e904       SBC #$04
88dc 85de       STA $de
88de c910       CMP #$10
88e0 9008       BCC 88ea
88e2 a8         TAY
88e3 a6df       LDX $df
88e5 20         JSR
88e6 f188       SBC ($88), Y
88e8 9006       BCC 88f0
88ea a5d9       LDA $d9
88ec 2903       AND #$03
88ee 85d9       STA $d9
88f0 60         RTS
88f1 38         SEC
88f2 98         TYA
88f3 e910       SBC #$10
88f5 4a         LSR
88f6 4a         LSR
88f7 4a         LSR
88f8 8d0c01     STA $010c
88fb a8         TAY
88fc 38         SEC
88fd 8a         STX
88fe 85db       STA $db
8900 e910       SBC #$10
8902 4a         LSR
8903 4a         LSR
8904 4a         LSR
8905 4a         LSR
8906 8d0d01     STA $010d
8909 aa         LDX
890a 20         JSR
890b 46ab       LSR $ab
890d ad0601     LDA $0106
8910 290c       AND #$0c
8912 8d0601     STA $0106
8915 d002       BNE 8919
8917 18         CLC
8918 60         RTS
8919 18         CLC
891a 08         PHP
891b ad0601     LDA $0106
891e 2908       AND #$08
8920 f009       BEQ 892b
8922 8d0701     STA $0107
8925 20         JSR
8926 fca928     CPX $28a9, X
8929 38         SEC
892a 08         PHP
892b a5db       LDA $db
892d 290f       AND #$0f
892f c900       CMP #$00
8931 d002       BNE 8935
8933 28         PLP
8934 60         RTS
8935 ad0601     LDA $0106
8938 2904       AND #$04
893a f009       BEQ 8945
893c 8d0701     STA $0107
893f 20         JSR
8940 fca928     CPX $28a9, X
8943 38         SEC
8944 60         RTS
8945 28         PLP
8946 60         RTS
8947 a581       LDA $81
8949 f036       BEQ 8981
894b a5d9       LDA $d9
894d 2903       AND #$03
894f f015       BEQ 8966
8951 a5dc       LDA $dc
8953 8d0c01     STA $010c
8956 a5dd       LDA $dd
8958 8d0d01     STA $010d
895b 20         JSR
895c 8289       STX #$89
895e 9006       BCC 8966
8960 a5d9       LDA $d9
8962 290c       AND #$0c
8964 85d9       STA $d9
8966 a5d9       LDA $d9
8968 290c       AND #$0c
896a f015       BEQ 8981
896c a5de       LDA $de
896e 8d0c01     STA $010c
8971 a5df       LDA $df
8973 8d0d01     STA $010d
8976 20         JSR
8977 8289       STX #$89
8979 9006       BCC 8981
897b a5d9       LDA $d9
897d 2903       AND #$03
897f 85d9       STA $d9
8981 60         RTS
8982 a200       LDX #$00
8984 b595       LDA $95, X
8986 f05d       BEQ 89e5
8988 b59b       LDA $9b, X
898a d059       BNE 89e5
898c b5ae       LDA $ae, X
898e c9e0       CMP #$e0
8990 b053       BCS 89e5
8992 ad0c01     LDA $010c
8995 d5ae       CMP $ae, X
8997 904c       BCC 89e5
8999 18         CLC
899a b5ae       LDA $ae, X
899c 690c       ADC #$0c
899e cd0c01     CMP $010c
89a1 9042       BCC 89e5
89a3 18         CLC
89a4 b5b7       LDA $b7, X
89a6 6901       ADC #$01
89a8 cd0d01     CMP $010d
89ab b008       BCS 89b5
89ad 18         CLC
89ae 690a       ADC #$0a
89b0 cd0d01     CMP $010d
89b3 b01b       BCS 89d0
89b5 18         CLC
89b6 ad0d01     LDA $010d
89b9 690d       ADC #$0d
89bb 8d3101     STA $0131
89be 18         CLC
89bf b5b7       LDA $b7, X
89c1 6901       ADC #$01
89c3 cd3101     CMP $0131
89c6 b01d       BCS 89e5
89c8 18         CLC
89c9 690a       ADC #$0a
89cb cd3101     CMP $0131
89ce 9015       BCC 89e5
89d0 a9b3       LDA #$b3
89d2 8588       STA $88
89d4 a98e       LDA #$8e
89d6 8589       STA $89
89d8 20         JSR
89d9 98         TYA
89da 90a9       BCC 8985
89dc 00         BRK
89dd 9595       STA $95, X
89df a901       LDA #$01
89e1 9598       STA $98, X
89e3 38         SEC
89e4 60         RTS
89e5 e8         INX
89e6 e003       CPX #$03
89e8 d09a       BNE 8984
89ea 18         CLC
89eb 60         RTS
89ec a581       LDA $81
89ee d001       BNE 89f1
89f0 60         RTS
89f1 a200       LDX #$00
89f3 b595       LDA $95, X
89f5 c900       CMP #$00
89f7 f045       BEQ 8a3e
89f9 b59b       LDA $9b, X
89fb d041       BNE 8a3e
89fd b5ae       LDA $ae, X
89ff c9e0       CMP #$e0
8a01 b03b       BCS 8a3e
8a03 18         CLC
8a04 ad1401     LDA $0114
8a07 6904       ADC #$04
8a09 d5ae       CMP $ae, X
8a0b 9031       BCC 8a3e
8a0d 18         CLC
8a0e b5ae       LDA $ae, X
8a10 690e       ADC #$0e
8a12 cd1401     CMP $0114
8a15 9027       BCC 8a3e
8a17 18         CLC
8a18 b5b7       LDA $b7, X
8a1a 690c       ADC #$0c
8a1c cd1a01     CMP $011a
8a1f 901d       BCC 8a3e
8a21 18         CLC
8a22 ad1f01     LDA $011f
8a25 6905       ADC #$05
8a27 d5b7       CMP $b7, X
8a29 9013       BCC 8a3e
8a2b a9b3       LDA #$b3
8a2d 8588       STA $88
8a2f a98e       LDA #$8e
8a31 8589       STA $89
8a33 20         JSR
8a34 98         TYA
8a35 90a9       BCC 89e0
8a37 00         BRK
8a38 9595       STA $95, X
8a3a a901       LDA #$01
8a3c 9598       STA $98, X
8a3e e8         INX
8a3f e003       CPX #$03
8a41 d0b0       BNE 89f3
8a43 60         RTS
8a44 ad4101     LDA $0141
8a47 c900       CMP #$00
8a49 f004       BEQ 8a4f
8a4b ce4101     DEC $0141
8a4e 60         RTS
8a4f ad2201     LDA $0122
8a52 c901       CMP #$01
8a54 d02c       BNE 8a82
8a56 18         CLC
8a57 ad1a01     LDA $011a
8a5a 6908       ADC #$08
8a5c 8d1b01     STA $011b
8a5f 8d1c01     STA $011c
8a62 6908       ADC #$08
8a64 8d1d01     STA $011d
8a67 8d1e01     STA $011e
8a6a 6908       ADC #$08
8a6c 8d1f01     STA $011f
8a6f a901       LDA #$01
8a71 8d2001     STA $0120
8a74 a909       LDA #$09
8a76 8d2101     STA $0121
8a79 ee2201     INC $0122
8a7c a910       LDA #$10
8a7e 8d4101     STA $0141
8a81 60         RTS
8a82 c902       CMP #$02
8a84 d018       BNE 8a9e
8a86 a913       LDA #$13
8a88 8d2001     STA $0120
8a8b a914       LDA #$14
8a8d 8d2101     STA $0121
8a90 ee2201     INC $0122
8a93 a90a       LDA #$0a
8a95 8d4101     STA $0141
8a98 a905       LDA #$05
8a9a 20         JSR
8a9b c6f3       DEC $f3
8a9d 60         RTS
8a9e c903       CMP #$03
8aa0 f003       BEQ 8aa5
8aa2 4c278b     JMP $8b27
8aa5 38         SEC
8aa6 ad1401     LDA $0114
8aa9 e908       SBC #$08
8aab 8d3101     STA $0131
8aae a003       LDY #$03
8ab0 a200       LDX #$00
8ab2 a906       LDA #$06
8ab4 8d3201     STA $0132
8ab7 ad3101     LDA $0131
8aba 9d5402     STA $0254, X
8abd e8         INX
8abe e8         INX
8abf e8         INX
8ac0 e8         INX
8ac1 ce3201     DEC $0132
8ac4 d0f1       BNE 8ab7
8ac6 18         CLC
8ac7 ad3101     LDA $0131
8aca 6908       ADC #$08
8acc 8d3101     STA $0131
8acf 88         DEY
8ad0 d0e0       BNE 8ab2
8ad2 38         SEC
8ad3 ad1a01     LDA $011a
8ad6 e908       SBC #$08
8ad8 8d3101     STA $0131
8adb a003       LDY #$03
8add a200       LDX #$00
8adf a906       LDA #$06
8ae1 8d3201     STA $0132
8ae4 ad3101     LDA $0131
8ae7 9d5702     STA $0257, X
8aea 18         CLC
8aeb 6908       ADC #$08
8aed e8         INX
8aee e8         INX
8aef e8         INX
8af0 e8         INX
8af1 ce3201     DEC $0132
8af4 d0f1       BNE 8ae7
8af6 88         DEY
8af7 d0e6       BNE 8adf
8af9 a000       LDY #$00
8afb a200       LDX #$00
8afd a912       LDA #$12
8aff 8d3201     STA $0132
8b02 b9c68b     LDA $8bc6, Y
8b05 9d5502     STA $0255, X
8b08 c8         INY
8b09 e8         INX
8b0a e8         INX
8b0b e8         INX
8b0c e8         INX
8b0d ce3201     DEC $0132
8b10 d0f0       BNE 8b02
8b12 a200       LDX #$00
8b14 a9f0       LDA #$f0
8b16 9d1401     STA $0114, X
8b19 e8         INX
8b1a e006       CPX #$06
8b1c d0f8       BNE 8b16
8b1e ee2201     INC $0122
8b21 a90a       LDA #$0a
8b23 8d4101     STA $0141
8b26 60         RTS
8b27 c904       CMP #$04
8b29 d022       BNE 8b4d
8b2b a000       LDY #$00
8b2d a200       LDX #$00
8b2f a912       LDA #$12
8b31 8d3201     STA $0132
8b34 b9d88b     LDA $8bd8, Y
8b37 9d5502     STA $0255, X
8b3a c8         INY
8b3b e8         INX
8b3c e8         INX
8b3d e8         INX
8b3e e8         INX
8b3f ce3201     DEC $0132
8b42 d0f0       BNE 8b34
8b44 ee2201     INC $0122
8b47 a906       LDA #$06
8b49 8d4101     STA $0141
8b4c 60         RTS
8b4d c905       CMP #$05
8b4f d019       BNE 8b6a
8b51 a200       LDX #$00
8b53 a012       LDY #$12
8b55 a9f0       LDA #$f0
8b57 9d5402     STA $0254, X
8b5a e8         INX
8b5b e8         INX
8b5c e8         INX
8b5d e8         INX
8b5e 88         DEY
8b5f d0f4       BNE 8b55
8b61 ee2201     INC $0122
8b64 a920       LDA #$20
8b66 8d4101     STA $0141
8b69 60         RTS
8b6a c906       CMP #$06
8b6c f001       BEQ 8b6f
8b6e 60         RTS
8b6f ee2201     INC $0122
8b72 a905       LDA #$05
8b74 850a       STA $0a
8b76 a93c       LDA #$3c
8b78 8d3b01     STA $013b
8b7b a519       LDA $19
8b7d c900       CMP #$00
8b7f d016       BNE 8b97
8b81 a50d       LDA $0d
8b83 851d       STA $1d
8b85 a50f       LDA $0f
8b87 851f       STA $1f
8b89 a200       LDX #$00
8b8b b5c0       LDA $c0, X
8b8d 9527       STA $27, X
8b8f e8         INX
8b90 e006       CPX #$06
8b92 d0f7       BNE 8b8b
8b94 4caa8b     JMP $8baa
8b97 a50d       LDA $0d
8b99 851e       STA $1e
8b9b a50f       LDA $0f
8b9d 8520       STA $20
8b9f a200       LDX #$00
8ba1 b5c0       LDA $c0, X
8ba3 952d       STA $2d, X
8ba5 e8         INX
8ba6 e006       CPX #$06
8ba8 d0f7       BNE 8ba1
8baa a50d       LDA $0d
8bac c900       CMP #$00
8bae f011       BEQ 8bc1
8bb0 18         CLC
8bb1 a51d       LDA $1d
8bb3 651e       ADC $1e
8bb5 c50d       CMP $0d
8bb7 d001       BNE 8bba
8bb9 60         RTS
8bba a518       LDA $18
8bbc 4519       EOR $19
8bbe 8519       STA $19
8bc0 60         RTS
8bc1 a950       LDA #$50
8bc3 850a       STA $0a
8bc5 60         RTS
8bc6 db da
8bc7 d9d8d8     CMP $d8d8, Y
8bca d9daea     CMP $eada, Y
8bcd e9e8       SBC #$e8
8bcf e8         INX
8bd0 e9ea       SBC #$ea
8bd2 db fa
8bd3 f9f8f8     SBC $f8f8, Y
8bd6 f9fadd     SBC $ddfa, Y
8bd9 dcdbdb     CPY $dbdb, X
8bdc dcdded     CPY $eddd, X
8bdf ecebeb     CPX $ebeb
8be2 ecedfd     CPX $fded
8be5 fcfbfb     CPX $fbfb, X
8be8 fcfde6     CPX $e6fd, X
8beb db 1a
8bec a905       LDA #$05
8bee 850a       STA $0a
8bf0 a93c       LDA #$3c
8bf2 8d3b01     STA $013b
8bf5 a519       LDA $19
8bf7 c900       CMP #$00
8bf9 d01d       BNE 8c18
8bfb a50d       LDA $0d
8bfd 851d       STA $1d
8bff a51a       LDA $1a
8c01 8521       STA $21
8c03 a900       LDA #$00
8c05 850f       STA $0f
8c07 851f       STA $1f
8c09 e623       INC $23
8c0b a523       LDA $23
8c0d c90a       CMP #$0a
8c0f 9023       BCC 8c34
8c11 a900       LDA #$00
8c13 8523       STA $23
8c15 e622       INC $22
8c17 60         RTS
8c18 a51a       LDA $1a
8c1a 8524       STA $24
8c1c a50d       LDA $0d
8c1e 851e       STA $1e
8c20 a900       LDA #$00
8c22 850f       STA $0f
8c24 8520       STA $20
8c26 e626       INC $26
8c28 a526       LDA $26
8c2a c90a       CMP #$0a
8c2c 9006       BCC 8c34
8c2e a900       LDA #$00
8c30 8526       STA $26
8c32 e625       INC $25
8c34 60         RTS
8c35 a500       LDA $00
8c37 8501       STA $01
8c39 a502       LDA $02
8c3b 8503       STA $03
8c3d a504       LDA $04
8c3f 8505       STA $05
8c41 a506       LDA $06
8c43 8507       STA $07
8c45 a508       LDA $08
8c47 8509       STA $09
8c49 a008       LDY #$08
8c4b a901       LDA #$01
8c4d 8d1640     STA $4016 ; Joystick 1
8c50 a900       LDA #$00
8c52 8d1640     STA $4016 ; Joystick 1
8c55 ad1640     LDA $4016 ; Joystick 1
8c58 6a         ROR
8c59 2600       ROL $00
8c5b 6a         ROR
8c5c 2606       ROL $06
8c5e ad1740     LDA $4017 ; Joystick 2
8c61 6a         ROR
8c62 2602       ROL $02
8c64 6a         ROR
8c65 2608       ROL $08
8c67 88         DEY
8c68 d0eb       BNE 8c55
8c6a a508       LDA $08
8c6c c900       CMP #$00
8c6e f022       BEQ 8c92
8c70 49ff       EOR #$ff
8c72 c920       CMP #$20
8c74 9004       BCC 8c7a
8c76 c952       CMP #$52
8c78 9009       BCC 8c83
8c7a 38         SEC
8c7b e952       SBC #$52
8c7d 8508       STA $08
8c7f c910       CMP #$10
8c81 b007       BCS 8c8a
8c83 a910       LDA #$10
8c85 8508       STA $08
8c87 4c928c     JMP $8c92
8c8a c9b0       CMP #$b0
8c8c 9004       BCC 8c92
8c8e a9b0       LDA #$b0
8c90 8508       STA $08
8c92 a500       LDA $00
8c94 8504       STA $04
8c96 a519       LDA $19
8c98 c900       CMP #$00
8c9a f004       BEQ 8ca0
8c9c a502       LDA $02
8c9e 8504       STA $04
8ca0 a506       LDA $06
8ca2 2980       AND #$80
8ca4 0504       ORA $04
8ca6 8504       STA $04
8ca8 ea         INC
8ca9 ea         INC
8caa ea         INC
8cab 60         RTS
8cac a900       LDA #$00
8cae 8d0320     STA $2003 ; Sprite Memory Address
8cb1 a902       LDA #$02
8cb3 8d1440     STA $4014 ; DMA
8cb6 60         RTS
8cb7 a50a       LDA $0a
8cb9 c908       CMP #$08
8cbb f004       BEQ 8cc1
8cbd c910       CMP #$10
8cbf d016       BNE 8cd7
8cc1 20         JSR
8cc2 db ab
8cc3 8dad3e     STA $3ead ; Background Scroll
8cc6 01c9       ORA ($c9, X)
8cc8 00         BRK
8cc9 d00c       BNE 8cd7
8ccb 20         JSR
8ccc db 33
8ccd b8         CLV
8cce 20         JSR
8ccf db fa
8cd0 b8         CLV
8cd1 20         JSR
8cd2 01c4       ORA ($c4, X)
8cd4 20         JSR
8cd5 db e3
8cd6 8c20ce     STY $ce20
8cd9 db b7
8cda 20         JSR
8cdb a5b8       LDA $b8
8cdd a900       LDA #$00
8cdf 8d3e01     STA $013e
8ce2 60         RTS
8ce3 a510       LDA $10
8ce5 f001       BEQ 8ce8
8ce7 60         RTS
8ce8 a50a       LDA $0a
8cea c908       CMP #$08
8cec f015       BEQ 8d03
8cee c910       CMP #$10
8cf0 f011       BEQ 8d03
8cf2 c918       CMP #$18
8cf4 f005       BEQ 8cfb
8cf6 c920       CMP #$20
8cf8 f009       BEQ 8d03
8cfa 60         RTS
8cfb a900       LDA #$00
8cfd 8d3601     STA $0136
8d00 8d3701     STA $0137
8d03 ad3701     LDA $0137
8d06 f004       BEQ 8d0c
8d08 ce3701     DEC $0137
8d0b 60         RTS
8d0c a91e       LDA #$1e
8d0e 8d3701     STA $0137
8d11 a906       LDA #$06
8d13 8d0120     STA $2001 ; PPU Control Register 2
8d16 a519       LDA $19
8d18 d043       BNE 8d5d
8d1a a920       LDA #$20
8d1c 8d0620     STA $2006 ; PPU Memory Address
8d1f a9f9       LDA #$f9
8d21 8d0620     STA $2006 ; PPU Memory Address
8d24 ad3601     LDA $0136
8d27 d01a       BNE 8d43
8d29 a92e       LDA #$2e
8d2b 8d0720     STA $2007 ; PPU Memory Data
8d2e a91e       LDA #$1e
8d30 8d0720     STA $2007 ; PPU Memory Data
8d33 a919       LDA #$19
8d35 8d0720     STA $2007 ; PPU Memory Data
8d38 a900       LDA #$00
8d3a 8d0520     STA $2005 ; Background Scroll
8d3d 8d0520     STA $2005 ; Background Scroll
8d40 4c9d8d     JMP $8d9d
8d43 a92d       LDA #$2d
8d45 8d0720     STA $2007 ; PPU Memory Data
8d48 a92d       LDA #$2d
8d4a 8d0720     STA $2007 ; PPU Memory Data
8d4d a92d       LDA #$2d
8d4f 8d0720     STA $2007 ; PPU Memory Data
8d52 a900       LDA #$00
8d54 8d0520     STA $2005 ; Background Scroll
8d57 8d0520     STA $2005 ; Background Scroll
8d5a 4c9d8d     JMP $8d9d
8d5d a921       LDA #$21
8d5f 8d0620     STA $2006 ; PPU Memory Address
8d62 a959       LDA #$59
8d64 8d0620     STA $2006 ; PPU Memory Address
8d67 ad3601     LDA $0136
8d6a d01a       BNE 8d86
8d6c a92f       LDA #$2f
8d6e 8d0720     STA $2007 ; PPU Memory Data
8d71 a91e       LDA #$1e
8d73 8d0720     STA $2007 ; PPU Memory Data
8d76 a919       LDA #$19
8d78 8d0720     STA $2007 ; PPU Memory Data
8d7b a900       LDA #$00
8d7d 8d0520     STA $2005 ; Background Scroll
8d80 8d0520     STA $2005 ; Background Scroll
8d83 4c9d8d     JMP $8d9d
8d86 a92d       LDA #$2d
8d88 8d0720     STA $2007 ; PPU Memory Data
8d8b a92d       LDA #$2d
8d8d 8d0720     STA $2007 ; PPU Memory Data
8d90 a92d       LDA #$2d
8d92 8d0720     STA $2007 ; PPU Memory Data
8d95 a900       LDA #$00
8d97 8d0520     STA $2005 ; Background Scroll
8d9a 8d0520     STA $2005 ; Background Scroll
8d9d a515       LDA $15
8d9f 8d0120     STA $2001 ; PPU Control Register 2
8da2 ad3601     LDA $0136
8da5 4901       EOR #$01
8da7 8d3601     STA $0136
8daa 60         RTS
8dab ad4501     LDA $0145
8dae 8d2e01     STA $012e
8db1 c900       CMP #$00
8db3 f061       BEQ 8e16
8db5 a906       LDA #$06
8db7 8d0120     STA $2001 ; PPU Control Register 2
8dba a200       LDX #$00
8dbc bd9a06     LDA $069a, X
8dbf c900       CMP #$00
8dc1 f02c       BEQ 8def
8dc3 bd9806     LDA $0698, X
8dc6 8d0620     STA $2006 ; PPU Memory Address
8dc9 bd9906     LDA $0699, X
8dcc 8d0620     STA $2006 ; PPU Memory Address
8dcf bd9a06     LDA $069a, X
8dd2 8d0720     STA $2007 ; PPU Memory Data
8dd5 18         CLC
8dd6 6901       ADC #$01
8dd8 8d0720     STA $2007 ; PPU Memory Data
8ddb a900       LDA #$00
8ddd 8d0520     STA $2005 ; Background Scroll
8de0 8d0520     STA $2005 ; Background Scroll
8de3 a915       LDA #$15
8de5 8d2601     STA $0126
8de8 a918       LDA #$18
8dea 8d2701     STA $0127
8ded c60f       DEC $0f
8def e8         INX
8df0 e8         INX
8df1 e8         INX
8df2 ce2e01     DEC $012e
8df5 d0c5       BNE 8dbc
8df7 a515       LDA $15
8df9 8d0120     STA $2001 ; PPU Control Register 2
8dfc ad0e01     LDA $010e
8dff d015       BNE 8e16
8e01 ca         DEC
8e02 ca         DEC
8e03 ca         DEC
8e04 bd9a06     LDA $069a, X
8e07 c900       CMP #$00
8e09 f006       BEQ 8e11
8e0b a902       LDA #$02
8e0d 20         JSR
8e0e c6f3       DEC $f3
8e10 60         RTS
8e11 a903       LDA #$03
8e13 20         JSR
8e14 c6f3       DEC $f3
8e16 60         RTS
8e17 20         JSR
8e18 db 3a
8e19 db 8f
8e1a a900       LDA #$00
8e1c 8d3401     STA $0134
8e1f a200       LDX #$00
8e21 bd7c03     LDA $037c, X
8e24 c900       CMP #$00
8e26 d006       BNE 8e2e
8e28 e8         INX
8e29 e006       CPX #$06
8e2b d0f4       BNE 8e21
8e2d 60         RTS
8e2e a901       LDA #$01
8e30 8d3401     STA $0134
8e33 a9ad       LDA #$ad
8e35 8588       STA $88
8e37 a98e       LDA #$8e
8e39 8589       STA $89
8e3b ad8003     LDA $0380
8e3e c900       CMP #$00
8e40 d008       BNE 8e4a
8e42 a9b3       LDA #$b3
8e44 8588       STA $88
8e46 a98e       LDA #$8e
8e48 8589       STA $89
8e4a a97c       LDA #$7c
8e4c 8586       STA $86
8e4e 858a       STA $8a
8e50 a903       LDA #$03
8e52 8587       STA $87
8e54 858b       STA $8b
8e56 a006       LDY #$06
8e58 20         JSR
8e59 fd92a9     SBC $a992, X
8e5c 7085       BVS 8de3
8e5e 8685       STX $85
8e60 8a         STX
8e61 a903       LDA #$03
8e63 8587       STA $87
8e65 858b       STA $8b
8e67 a519       LDA $19
8e69 c900       CMP #$00
8e6b f00c       BEQ 8e79
8e6d a976       LDA #$76
8e6f 8586       STA $86
8e71 858a       STA $8a
8e73 a903       LDA #$03
8e75 8587       STA $87
8e77 858b       STA $8b
8e79 a006       LDY #$06
8e7b 20         JSR
8e7c de92ad     DEC $ad92, X
8e7f 3501       AND $01, X
8e81 c900       CMP #$00
8e83 d013       BNE 8e98
8e85 a000       LDY #$00
8e87 b186       LDA ($86), Y
8e89 d96603     CMP $0366, Y
8e8c 901b       BCC 8ea9
8e8e d008       BNE 8e98
8e90 c8         INY
8e91 c006       CPY #$06
8e93 d0f2       BNE 8e87
8e95 4ca98e     JMP $8ea9
8e98 a901       LDA #$01
8e9a 8d3501     STA $0135
8e9d a000       LDY #$00
8e9f b186       LDA ($86), Y
8ea1 996603     STA $0366, Y
8ea4 c8         INY
8ea5 c006       CPY #$06
8ea7 d0f6       BNE 8e9f
8ea9 20         JSR
8eaa b98e60     LDA $608e, Y
8ead 00         BRK
8eae 00         BRK
8eaf 00         BRK
8eb0 00         BRK
8eb1 0100       ORA ($00, X)
8eb3 00         BRK
8eb4 00         BRK
8eb5 00         BRK
8eb6 0100       ORA ($00, X)
8eb8 00         BRK
8eb9 ad8c01     LDA $018c
8ebc d057       BNE 8f15
8ebe a200       LDX #$00
8ec0 a000       LDY #$00
8ec2 a519       LDA $19
8ec4 c900       CMP #$00
8ec6 f002       BEQ 8eca
8ec8 a202       LDX #$02
8eca b186       LDA ($86), Y
8ecc dd6c03     CMP $036c, X
8ecf 9044       BCC 8f15
8ed1 d008       BNE 8edb
8ed3 c8         INY
8ed4 b186       LDA ($86), Y
8ed6 dd6d03     CMP $036d, X
8ed9 903a       BCC 8f15
8edb bd6c03     LDA $036c, X
8ede c900       CMP #$00
8ee0 d00f       BNE 8ef1
8ee2 bd6d03     LDA $036d, X
8ee5 c902       CMP #$02
8ee7 d008       BNE 8ef1
8ee9 a906       LDA #$06
8eeb 9d6d03     STA $036d, X
8eee 4c098f     JMP $8f09
8ef1 18         CLC
8ef2 bd6d03     LDA $036d, X
8ef5 6906       ADC #$06
8ef7 9d6d03     STA $036d, X
8efa c90a       CMP #$0a
8efc 900b       BCC 8f09
8efe 18         CLC
8eff 6906       ADC #$06
8f01 290f       AND #$0f
8f03 9d6d03     STA $036d, X
8f06 fe6c03     INC $036c, X
8f09 e60d       INC $0d
8f0b a90e       LDA #$0e
8f0d 20         JSR
8f0e c6f3       DEC $f3
8f10 a926       LDA #$26
8f12 8d0e01     STA $010e
8f15 60         RTS
8f16 a907       LDA #$07
8f18 8581       STA $81
8f1a a200       LDX #$00
8f1c b533       LDA $33, X
8f1e 954d       STA $4d, X
8f20 e8         INX
8f21 e034       CPX #$34
8f23 d0f7       BNE 8f1c
8f25 a548       LDA $48
8f27 0a         ASL
8f28 aa         LDX
8f29 bd348f     LDA $8f34, X
8f2c 8562       STA $62
8f2e bd358f     LDA $8f35, X
8f31 857c       STA $7c
8f33 60         RTS
8f34 0102       ORA ($02, X)
8f36 00         BRK
8f37 0200       ASL #$00
8f39 01ad       ORA ($ad, X)
8f3b 4501       EOR $01
8f3d 8d2e01     STA $012e
8f40 a200       LDX #$00
8f42 ad2e01     LDA $012e
8f45 c900       CMP #$00
8f47 f048       BEQ 8f91
8f49 bd8206     LDA $0682, X
8f4c 29f0       AND #$f0
8f4e 8d3101     STA $0131
8f51 c9f0       CMP #$f0
8f53 f033       BEQ 8f88
8f55 c9e0       CMP #$e0
8f57 d012       BNE 8f6b
8f59 a9d2       LDA #$d2
8f5b 8588       STA $88
8f5d a98f       LDA #$8f
8f5f 8589       STA $89
8f61 a51a       LDA $1a
8f63 0a         ASL
8f64 18         CLC
8f65 651a       ADC $1a
8f67 0a         ASL
8f68 4c7a8f     JMP $8f7a
8f6b a992       LDA #$92
8f6d 8588       STA $88
8f6f a98f       LDA #$8f
8f71 8589       STA $89
8f73 38         SEC
8f74 ad3101     LDA $0131
8f77 e910       SBC #$10
8f79 4a         LSR
8f7a 18         CLC
8f7b 6588       ADC $88
8f7d 8588       STA $88
8f7f a589       LDA $89
8f81 6900       ADC #$00
8f83 8589       STA $89
8f85 20         JSR
8f86 98         TYA
8f87 90e8       BCC 8f71
8f89 e8         INX
8f8a e8         INX
8f8b ce2e01     DEC $012e
8f8e 4c428f     JMP $8f42
8f91 60         RTS
8f92 00         BRK
8f93 00         BRK
8f94 00         BRK
8f95 00         BRK
8f96 0500       ORA $00
8f98 00         BRK
8f99 00         BRK
8f9a 00         BRK
8f9b 00         BRK
8f9c 00         BRK
8f9d 00         BRK
8f9e 0600       ASL $00
8fa0 00         BRK
8fa1 00         BRK
8fa2 00         BRK
8fa3 00         BRK
8fa4 00         BRK
8fa5 00         BRK
8fa6 db 07
8fa7 00         BRK
8fa8 00         BRK
8fa9 00         BRK
8faa 00         BRK
8fab 00         BRK
8fac 00         BRK
8fad 00         BRK
8fae 08         PHP
8faf 00         BRK
8fb0 00         BRK
8fb1 00         BRK
8fb2 00         BRK
8fb3 00         BRK
8fb4 00         BRK
8fb5 00         BRK
8fb6 0900       ORA #$00
8fb8 00         BRK
8fb9 00         BRK
8fba 00         BRK
8fbb 00         BRK
8fbc 00         BRK
8fbd 0100       ORA ($00, X)
8fbf 00         BRK
8fc0 00         BRK
8fc1 00         BRK
8fc2 00         BRK
8fc3 00         BRK
8fc4 00         BRK
8fc5 0101       ORA ($01, X)
8fc7 00         BRK
8fc8 00         BRK
8fc9 00         BRK
8fca 00         BRK
8fcb 00         BRK
8fcc 00         BRK
8fcd 0102       ORA ($02, X)
8fcf 00         BRK
8fd0 00         BRK
8fd1 00         BRK
8fd2 00         BRK
8fd3 00         BRK
8fd4 00         BRK
8fd5 00         BRK
8fd6 00         BRK
8fd7 00         BRK
8fd8 00         BRK
8fd9 00         BRK
8fda 00         BRK
8fdb 00         BRK
8fdc 0500       ORA $00
8fde 00         BRK
8fdf 00         BRK
8fe0 00         BRK
8fe1 0100       ORA ($00, X)
8fe3 00         BRK
8fe4 00         BRK
8fe5 00         BRK
8fe6 00         BRK
8fe7 0105       ORA ($05, X)
8fe9 00         BRK
8fea 00         BRK
8feb 00         BRK
8fec 00         BRK
8fed 0200       ASL #$00
8fef 00         BRK
8ff0 00         BRK
8ff1 00         BRK
8ff2 00         BRK
8ff3 0205       ASL #$05
8ff5 00         BRK
8ff6 00         BRK
8ff7 00         BRK
8ff8 00         BRK
8ff9 db 03
8ffa 00         BRK
8ffb 00         BRK
8ffc 00         BRK
8ffd 00         BRK
8ffe 00         BRK
8fff db 03
9000 0500       ORA $00
9002 00         BRK
9003 00         BRK
9004 00         BRK
9005 db 04
9006 00         BRK
9007 00         BRK
9008 00         BRK
9009 00         BRK
900a 00         BRK
900b db 04
900c 0500       ORA $00
900e 00         BRK
900f 00         BRK
9010 00         BRK
9011 0500       ORA $00
9013 00         BRK
9014 00         BRK
9015 00         BRK
9016 00         BRK
9017 0505       ORA $05
9019 00         BRK
901a 00         BRK
901b 00         BRK
901c 00         BRK
901d 0600       ASL $00
901f 00         BRK
9020 00         BRK
9021 00         BRK
9022 00         BRK
9023 0605       ASL $05
9025 00         BRK
9026 00         BRK
9027 00         BRK
9028 00         BRK
9029 db 07
902a 00         BRK
902b 00         BRK
902c 00         BRK
902d 00         BRK
902e 00         BRK
902f db 07
9030 0500       ORA $00
9032 00         BRK
9033 00         BRK
9034 00         BRK
9035 08         PHP
9036 00         BRK
9037 00         BRK
9038 00         BRK
9039 00         BRK
903a 00         BRK
903b 08         PHP
903c 0500       ORA $00
903e 00         BRK
903f 00         BRK
9040 00         BRK
9041 0900       ORA #$00
9043 00         BRK
9044 00         BRK
9045 00         BRK
9046 00         BRK
9047 0905       ORA #$05
9049 00         BRK
904a 00         BRK
904b 00         BRK
904c 0100       ORA ($00, X)
904e 00         BRK
904f 00         BRK
9050 00         BRK
9051 00         BRK
9052 0100       ORA ($00, X)
9054 0500       ORA $00
9056 00         BRK
9057 00         BRK
9058 0101       ORA ($01, X)
905a 00         BRK
905b 00         BRK
905c 00         BRK
905d 00         BRK
905e 0101       ORA ($01, X)
9060 0500       ORA $00
9062 00         BRK
9063 00         BRK
9064 0102       ORA ($02, X)
9066 00         BRK
9067 00         BRK
9068 00         BRK
9069 00         BRK
906a 0102       ORA ($02, X)
906c 0500       ORA $00
906e 00         BRK
906f 00         BRK
9070 0103       ORA ($03, X)
9072 00         BRK
9073 00         BRK
9074 00         BRK
9075 00         BRK
9076 0103       ORA ($03, X)
9078 0500       ORA $00
907a 00         BRK
907b 00         BRK
907c 0104       ORA ($04, X)
907e 00         BRK
907f 00         BRK
9080 00         BRK
9081 00         BRK
9082 0104       ORA ($04, X)
9084 0500       ORA $00
9086 00         BRK
9087 00         BRK
9088 0105       ORA ($05, X)
908a 00         BRK
908b 00         BRK
908c 00         BRK
908d 00         BRK
908e 0105       ORA ($05, X)
9090 0500       ORA $00
9092 00         BRK
9093 00         BRK
9094 0106       ORA ($06, X)
9096 00         BRK
9097 00         BRK
9098 a510       LDA $10
909a d011       BNE 90ad
909c a97c       LDA #$7c
909e 8586       STA $86
90a0 858a       STA $8a
90a2 a903       LDA #$03
90a4 8587       STA $87
90a6 858b       STA $8b
90a8 a006       LDY #$06
90aa 20         JSR
90ab de9260     DEC $6092, X
90ae a50a       LDA $0a
90b0 c908       CMP #$08
90b2 f004       BEQ 90b8
90b4 c910       CMP #$10
90b6 d066       BNE 911e
90b8 ad2a01     LDA $012a
90bb c901       CMP #$01
90bd d05f       BNE 911e
90bf ad2901     LDA $0129
90c2 2904       AND #$04
90c4 f058       BEQ 911e
90c6 ad2c01     LDA $012c
90c9 c900       CMP #$00
90cb f004       BEQ 90d1
90cd ce2c01     DEC $012c
90d0 60         RTS
90d1 ae2b01     LDX $012b
90d4 bd1f91     LDA $911f, X
90d7 c9ff       CMP #$ff
90d9 f02f       BEQ 910a
90db c9ee       CMP #$ee
90dd f01e       BEQ 90fd
90df 8d2001     STA $0120
90e2 ee2b01     INC $012b
90e5 ee2c01     INC $012c
90e8 ad2b01     LDA $012b
90eb c909       CMP #$09
90ed 9007       BCC 90f6
90ef ce1a01     DEC $011a
90f2 ee1f01     INC $011f
90f5 60         RTS
90f6 ee1a01     INC $011a
90f9 ce1f01     DEC $011f
90fc 60         RTS
90fd ad3191     LDA $9131
9100 8d2101     STA $0121
9103 ee2b01     INC $012b
9106 ee2c01     INC $012c
9109 60         RTS
910a a900       LDA #$00
910c 8d2c01     STA $012c
910f 8d2b01     STA $012b
9112 8d2901     STA $0129
9115 a904       LDA #$04
9117 8d2a01     STA $012a
911a a901       LDA #$01
911c 85d8       STA $d8
911e 60         RTS
911f 0203       ASL #$03
9121 db 04
9122 0506       ORA $06
9124 db 07
9125 08         PHP
9126 2dee11     AND $11ee
9129 100f       BPL 913a
912b 0e0d0c     ASL $0c0d
912e db 0b
912f 0a         ASL
9130 db ff
9131 db 12
9132 a50a       LDA $0a
9134 c908       CMP #$08
9136 f004       BEQ 913c
9138 c910       CMP #$10
913a d067       BNE 91a3
913c ad2a01     LDA $012a
913f c904       CMP #$04
9141 d060       BNE 91a3
9143 ad2901     LDA $0129
9146 2903       AND #$03
9148 f059       BEQ 91a3
914a ad2c01     LDA $012c
914d c900       CMP #$00
914f f004       BEQ 9155
9151 ce2c01     DEC $012c
9154 60         RTS
9155 ae2b01     LDX $012b
9158 bda491     LDA $91a4, X
915b c9ff       CMP #$ff
915d f02f       BEQ 918e
915f c9ee       CMP #$ee
9161 f01e       BEQ 9181
9163 8d2001     STA $0120
9166 ee2b01     INC $012b
9169 ee2c01     INC $012c
916c ad2b01     LDA $012b
916f c909       CMP #$09
9171 9007       BCC 917a
9173 ce1a01     DEC $011a
9176 ee1f01     INC $011f
9179 60         RTS
917a ee1a01     INC $011a
917d ce1f01     DEC $011f
9180 60         RTS
9181 adb691     LDA $91b6
9184 8d2101     STA $0121
9187 ee2b01     INC $012b
918a ee2c01     INC $012c
918d 60         RTS
918e a900       LDA #$00
9190 8d2c01     STA $012c
9193 8d2b01     STA $012b
9196 ad2901     LDA $0129
9199 2902       AND #$02
919b 8d2901     STA $0129
919e a901       LDA #$01
91a0 8d2a01     STA $012a
91a3 60         RTS
91a4 db 0b
91a5 db 0b
91a6 0d0e0f     ORA $0f0e
91a9 1011       BPL 91bc
91ab 2dee08     AND $08ee
91ae db 07
91af 0605       ASL $05
91b1 db 04
91b2 db 03
91b3 0201       ASL #$01
91b5 db ff
91b6 09a5       ORA #$a5
91b8 0a         ASL
91b9 c908       CMP #$08
91bb f004       BEQ 91c1
91bd c910       CMP #$10
91bf d061       BNE 9222
91c1 ad2a01     LDA $012a
91c4 c901       CMP #$01
91c6 d05a       BNE 9222
91c8 ad2901     LDA $0129
91cb 2902       AND #$02
91cd f053       BEQ 9222
91cf ce1a01     DEC $011a
91d2 ce1b01     DEC $011b
91d5 ee1e01     INC $011e
91d8 ee1f01     INC $011f
91db ad1a01     LDA $011a
91de c910       CMP #$10
91e0 b012       BCS 91f4
91e2 ee1a01     INC $011a
91e5 ee1b01     INC $011b
91e8 ee1c01     INC $011c
91eb ee1d01     INC $011d
91ee ee1e01     INC $011e
91f1 ee1f01     INC $011f
91f4 ad1f01     LDA $011f
91f7 c9b1       CMP #$b1
91f9 9012       BCC 920d
91fb ce1a01     DEC $011a
91fe ce1b01     DEC $011b
9201 ce1c01     DEC $011c
9204 ce1d01     DEC $011d
9207 ce1e01     DEC $011e
920a ce1f01     DEC $011f
920d 38         SEC
920e ad1c01     LDA $011c
9211 ed1b01     SBC $011b
9214 c908       CMP #$08
9216 900a       BCC 9222
9218 a900       LDA #$00
921a 8d2901     STA $0129
921d a902       LDA #$02
921f 8d2a01     STA $012a
9222 60         RTS
9223 a50a       LDA $0a
9225 c908       CMP #$08
9227 f004       BEQ 922d
9229 c910       CMP #$10
922b d02f       BNE 925c
922d ad2a01     LDA $012a
9230 c902       CMP #$02
9232 d028       BNE 925c
9234 ad2901     LDA $0129
9237 2905       AND #$05
9239 f021       BEQ 925c
923b ee1a01     INC $011a
923e ee1b01     INC $011b
9241 ce1e01     DEC $011e
9244 ce1f01     DEC $011f
9247 ad1c01     LDA $011c
924a cd1b01     CMP $011b
924d d00d       BNE 925c
924f ad2901     LDA $0129
9252 2904       AND #$04
9254 8d2901     STA $0129
9257 a901       LDA #$01
9259 8d2a01     STA $012a
925c 60         RTS
925d ad3e01     LDA $013e
9260 c900       CMP #$00
9262 d001       BNE 9265
9264 60         RTS
9265 a58c       LDA $8c
9267 38         SEC
9268 e901       SBC #$01
926a 0a         ASL
926b 0a         ASL
926c aa         LDX
926d a000       LDY #$00
926f bd7f92     LDA $927f, X
9272 996201     STA $0162, Y
9275 e8         INX
9276 c8         INY
9277 c004       CPY #$04
9279 d0f4       BNE 926f
927b 20         JSR
927c 6a         ROR
927d a460       LDY $60
927f db 0f
9280 20         JSR
9281 2628       ROL $28
9283 db 0f
9284 20         JSR
9285 2928       AND #$28
9287 db 0f
9288 20         JSR
9289 0228       ASL #$28
928b db 0f
928c 20         JSR
928d 2128       AND ($28, X)
928f db 0f
9290 20         JSR
9291 1628       ASL $28, X
9293 db 0f
9294 20         JSR
9295 2528       AND $28
9297 db 0f
9298 20         JSR
9299 00         BRK
929a 21ad       AND ($ad, X)
929c 3101       AND ($01), Y
929e 290f       AND #$0f
92a0 aa         LDX
92a1 bdce92     LDA $92ce, X
92a4 6d3101     ADC $0131
92a7 6d7303     ADC $0373
92aa 6d7403     ADC $0374
92ad 2a         ROL
92ae 2a         ROL
92af 6d7903     ADC $0379
92b2 6d7a03     ADC $037a
92b5 6d1a01     ADC $011a
92b8 6d1b01     ADC $011b
92bb 2a         ROL
92bc 2a         ROL
92bd 2a         ROL
92be 6537       ADC $37
92c0 6538       ADC $38
92c2 6a         ROR
92c3 6a         ROR
92c4 ee3101     INC $0131
92c7 ee3101     INC $0131
92ca ee3101     INC $0131
92cd 60         RTS
92ce db 57
92cf db 12
92d0 db f3
92d1 bd339c     LDA $9c33, X
92d4 214f       AND ($4f, X)
92d6 61e7       ADC ($e7, X)
92d8 db 0f
92d9 aa         LDX
92da 7e84c6     ROR $c684, X
92dd de8a48     DEC $488a, X
92e0 98         TYA
92e1 48         PHA
92e2 aa         LDX
92e3 88         DEY
92e4 18         CLC
92e5 b186       LDA ($86), Y
92e7 7188       ADC ($88), Y
92e9 918a       STA ($8a), Y
92eb c90a       CMP #$0a
92ed 9005       BCC 92f4
92ef 38         SEC
92f0 e90a       SBC #$0a
92f2 918a       STA ($8a), Y
92f4 88         DEY
92f5 ca         DEC
92f6 d0ed       BNE 92e5
92f8 68         PLA
92f9 a8         TAY
92fa 68         PLA
92fb aa         LDX
92fc 60         RTS
92fd 8a         STX
92fe 48         PHA
92ff 98         TYA
9300 48         PHA
9301 aa         LDX
9302 88         DEY
9303 38         SEC
9304 b186       LDA ($86), Y
9306 f188       SBC ($88), Y
9308 918a       STA ($8a), Y
930a b00a       BCS 9316
930c 49ff       EOR #$ff
930e 38         SEC
930f e90a       SBC #$0a
9311 49ff       EOR #$ff
9313 918a       STA ($8a), Y
9315 18         CLC
9316 88         DEY
9317 ca         DEC
9318 d0ea       BNE 9304
931a 68         PLA
931b a8         TAY
931c 68         PLA
931d aa         LDX
931e 60         RTS
931f a50a       LDA $0a
9321 c900       CMP #$00
9323 d011       BNE 9336
9325 20         JSR
9326 05a0       ORA $a0
9328 a901       LDA #$01
932a 8512       STA $12
932c a9e0       LDA #$e0
932e 8513       STA $13
9330 a900       LDA #$00
9332 8d4401     STA $0144
9335 60         RTS
9336 a50a       LDA $0a
9338 c901       CMP #$01
933a d004       BNE 9340
933c 20         JSR
933d db 8b
933e db 9b
933f 60         RTS
9340 a50a       LDA $0a
9342 c902       CMP #$02
9344 d006       BNE 934c
9346 20         JSR
9347 f0a0       BEQ 92e9
9349 e60a       INC $0a
934b 60         RTS
934c a50a       LDA $0a
934e c903       CMP #$03
9350 d004       BNE 9356
9352 20         JSR
9353 db d7
9354 db a3
9355 60         RTS
9356 a50a       LDA $0a
9358 c904       CMP #$04
935a d004       BNE 9360
935c 20         JSR
935d 5e9f60     LSR $609f, X
9360 a50a       LDA $0a
9362 c905       CMP #$05
9364 d004       BNE 936a
9366 20         JSR
9367 db 4f
9368 9460       STY $60, X
936a a50a       LDA $0a
936c c906       CMP #$06
936e d023       BNE 9393
9370 e60a       INC $0a
9372 a510       LDA $10
9374 c900       CMP #$00
9376 f001       BEQ 9379
9378 60         RTS
9379 20         JSR
937a db af
937b 9ca980     STY $80a9, X
937e 8d3b01     STA $013b
9381 a51a       LDA $1a
9383 c921       CMP #$21
9385 f006       BEQ 938d
9387 a90d       LDA #$0d
9389 20         JSR
938a c6f3       DEC $f3
938c 60         RTS
938d a910       LDA #$10
938f 20         JSR
9390 c6f3       DEC $f3
9392 60         RTS
9393 a50a       LDA $0a
9395 c907       CMP #$07
9397 d017       BNE 93b0
9399 20         JSR
939a fd9e20     SBC $209e, X
939d 48         PHA
939e 99a91e     STA $1ea9, Y
93a1 8d0120     STA $2001 ; PPU Control Register 2
93a4 8515       STA $15
93a6 a908       LDA #$08
93a8 850a       STA $0a
93aa a9a0       LDA #$a0
93ac 8d3801     STA $0138
93af 60         RTS
93b0 a50a       LDA $0a
93b2 c950       CMP #$50
93b4 d010       BNE 93c6
93b6 a90f       LDA #$0f
93b8 20         JSR
93b9 c6f3       DEC $f3
93bb 20         JSR
93bc d69c       DEC $9c, X
93be a980       LDA #$80
93c0 8d3b01     STA $013b
93c3 e60a       INC $0a
93c5 60         RTS
93c6 a50a       LDA $0a
93c8 c951       CMP #$51
93ca d00b       BNE 93d7
93cc 20         JSR
93cd fd9ee6     SBC $e69e, X
93d0 0a         ASL
93d1 a950       LDA #$50
93d3 8d3b01     STA $013b
93d6 60         RTS
93d7 a50a       LDA $0a
93d9 c952       CMP #$52
93db d016       BNE 93f3
93dd a51d       LDA $1d
93df 051e       ORA $1e
93e1 d005       BNE 93e8
93e3 a900       LDA #$00
93e5 850a       STA $0a
93e7 60         RTS
93e8 a905       LDA #$05
93ea 850a       STA $0a
93ec a518       LDA $18
93ee 4519       EOR $19
93f0 8519       STA $19
93f2 60         RTS
93f3 a50a       LDA $0a
93f5 c960       CMP #$60
93f7 d006       BNE 93ff
93f9 20         JSR
93fa 41a1       EOR ($a1, X)
93fc e60a       INC $0a
93fe 60         RTS
93ff a50a       LDA $0a
9401 c961       CMP #$61
9403 d019       BNE 941e
9405 20         JSR
9406 db d7
9407 db a3
9408 a516       LDA $16
940a c9ef       CMP #$ef
940c f001       BEQ 940f
940e 60         RTS
940f a935       LDA #$35
9411 850a       STA $0a
9413 a906       LDA #$06
9415 8d8e01     STA $018e
9418 a980       LDA #$80
941a 8d8f01     STA $018f
941d 60         RTS
941e a50a       LDA $0a
9420 c962       CMP #$62
9422 d008       BNE 942c
9424 a900       LDA #$00
9426 8516       STA $16
9428 20         JSR
9429 db 0f
942a 9d60a5     STA $a560, X
942d 0a         ASL
942e c963       CMP #$63
9430 d01c       BNE 944e
9432 a906       LDA #$06
9434 8d0120     STA $2001 ; PPU Control Register 2
9437 8515       STA $15
9439 a51d       LDA $1d
943b 051e       ORA $1e
943d f00b       BEQ 944a
943f a518       LDA $18
9441 4519       EOR $19
9443 8519       STA $19
9445 a905       LDA #$05
9447 850a       STA $0a
9449 60         RTS
944a a900       LDA #$00
944c 850a       STA $0a
944e 60         RTS
944f a906       LDA #$06
9451 8d0120     STA $2001 ; PPU Control Register 2
9454 a50b       LDA $0b
9456 c900       CMP #$00
9458 d00f       BNE 9469
945a 20         JSR
945b db f3
945c db 9f
945d 20         JSR
945e ca         DEC
945f a120       LDA ($20, X)
9461 bd9420     LDA $2094, X
9464 e09f       CPX #$9f
9466 e60b       INC $0b
9468 60         RTS
9469 a50b       LDA $0b
946b c901       CMP #$01
946d f010       BEQ 947f
946f c902       CMP #$02
9471 f00c       BEQ 947f
9473 c903       CMP #$03
9475 f008       BEQ 947f
9477 c904       CMP #$04
9479 f004       BEQ 947f
947b c905       CMP #$05
947d d00f       BNE 948e
947f a510       LDA $10
9481 f005       BEQ 9488
9483 a906       LDA #$06
9485 850b       STA $0b
9487 60         RTS
9488 20         JSR
9489 40         RTI
948a 96e6       STX $e6, X
948c db 0b
948d 60         RTS
948e a50b       LDA $0b
9490 c906       CMP #$06
9492 d00c       BNE 94a0
9494 20         JSR
9495 db 0b
9496 db 9b
9497 20         JSR
9498 42a4       LSR #$a4
949a 20         JSR
949b 6a         ROR
949c a4e6       LDY $e6
949e db 0b
949f 60         RTS
94a0 a50b       LDA $0b
94a2 c907       CMP #$07
94a4 d006       BNE 94ac
94a6 20         JSR
94a7 cd96e6     CMP $e696
94aa db 0b
94ab 60         RTS
94ac 20         JSR
94ad ed97a9     SBC $a997
94b0 00         BRK
94b1 850b       STA $0b
94b3 e60a       INC $0a
94b5 a91e       LDA #$1e
94b7 8d0120     STA $2001 ; PPU Control Register 2
94ba 8515       STA $15
94bc 60         RTS
94bd a510       LDA $10
94bf c900       CMP #$00
94c1 f020       BEQ 94e3
94c3 a900       LDA #$00
94c5 851f       STA $1f
94c7 8519       STA $19
94c9 a901       LDA #$01
94cb 851d       STA $1d
94cd e611       INC $11
94cf a611       LDX $11
94d1 bdaa95     LDA $95aa, X
94d4 8521       STA $21
94d6 c9ff       CMP #$ff
94d8 d009       BNE 94e3
94da a200       LDX #$00
94dc 8611       STX $11
94de bdaa95     LDA $95aa, X
94e1 8521       STA $21
94e3 a519       LDA $19
94e5 c900       CMP #$00
94e7 d060       BNE 9549
94e9 a9a0       LDA #$a0
94eb 8584       STA $84
94ed a903       LDA #$03
94ef 8585       STA $85
94f1 a51d       LDA $1d
94f3 850d       STA $0d
94f5 a900       LDA #$00
94f7 850e       STA $0e
94f9 a51f       LDA $1f
94fb 850f       STA $0f
94fd a521       LDA $21
94ff 851a       STA $1a
9501 a522       LDA $22
9503 851b       STA $1b
9505 a523       LDA $23
9507 851c       STA $1c
9509 a200       LDX #$00
950b b527       LDA $27, X
950d 95c0       STA $c0, X
950f e8         INX
9510 e006       CPX #$06
9512 d0f7       BNE 950b
9514 a521       LDA $21
9516 c921       CMP #$21
9518 d004       BNE 951e
951a a900       LDA #$00
951c 851f       STA $1f
951e a51f       LDA $1f
9520 c900       CMP #$00
9522 d022       BNE 9546
9524 a621       LDX $21
9526 20         JSR
9527 b095       BCS 94be
9529 a50f       LDA $0f
952b 851f       STA $1f
952d a51a       LDA $1a
952f 0a         ASL
9530 18         CLC
9531 651a       ADC $1a
9533 0a         ASL
9534 aa         LDX
9535 a000       LDY #$00
9537 bd219a     LDA $9a21, X
953a 992700     STA $0027, Y
953d 99c000     STA $00c0, Y
9540 e8         INX
9541 c8         INY
9542 c006       CPY #$06
9544 d0f1       BNE 9537
9546 4ca695     JMP $95a6
9549 a910       LDA #$10
954b 8584       STA $84
954d a905       LDA #$05
954f 8585       STA $85
9551 a51e       LDA $1e
9553 850d       STA $0d
9555 a900       LDA #$00
9557 850e       STA $0e
9559 a520       LDA $20
955b 850f       STA $0f
955d a524       LDA $24
955f 851a       STA $1a
9561 a525       LDA $25
9563 851b       STA $1b
9565 a526       LDA $26
9567 851c       STA $1c
9569 a200       LDX #$00
956b b52d       LDA $2d, X
956d 95c0       STA $c0, X
956f e8         INX
9570 e006       CPX #$06
9572 d0f7       BNE 956b
9574 a524       LDA $24
9576 c921       CMP #$21
9578 d004       BNE 957e
957a a900       LDA #$00
957c 8520       STA $20
957e a520       LDA $20
9580 c900       CMP #$00
9582 d022       BNE 95a6
9584 a624       LDX $24
9586 20         JSR
9587 b095       BCS 951e
9589 a50f       LDA $0f
958b 8520       STA $20
958d a51a       LDA $1a
958f 0a         ASL
9590 18         CLC
9591 651a       ADC $1a
9593 0a         ASL
9594 aa         LDX
9595 a000       LDY #$00
9597 bd219a     LDA $9a21, X
959a 992d00     STA $002d, Y
959d 99c000     STA $00c0, Y
95a0 e8         INX
95a1 c8         INY
95a2 c006       CPY #$06
95a4 d0f1       BNE 9597
95a6 20         JSR
95a7 2e9b60     ROL $609b
95aa 050e       ORA $0e
95ac db 0f
95ad db 17
95ae 1effa5     ASL $a5ff, X
95b1 8485       STY $85
95b3 86a5       STX $a5
95b5 8585       STA $85
95b7 db 87
95b8 a980       LDA #$80
95ba 8588       STA $88
95bc a9ca       LDA #$ca
95be 8589       STA $89
95c0 ca         DEC
95c1 8a         STX
95c2 48         PHA
95c3 e000       CPX #$00
95c5 f005       BEQ 95cc
95c7 e689       INC $89
95c9 ca         DEC
95ca d0f7       BNE 95c3
95cc a000       LDY #$00
95ce b188       LDA ($88), Y
95d0 9186       STA ($86), Y
95d2 c8         INY
95d3 c0df       CPY #$df
95d5 d0f7       BNE 95ce
95d7 8c2f01     STY $012f
95da a900       LDA #$00
95dc 9186       STA ($86), Y
95de c8         INY
95df c000       CPY #$00
95e1 d002       BNE 95e5
95e3 e687       INC $87
95e5 c010       CPY #$10
95e7 d0f1       BNE 95da
95e9 8c2e01     STY $012e
95ec ac2f01     LDY $012f
95ef b188       LDA ($88), Y
95f1 ac2e01     LDY $012e
95f4 9186       STA ($86), Y
95f6 ee2e01     INC $012e
95f9 ee2f01     INC $012f
95fc d0ee       BNE 95ec
95fe a0ff       LDY #$ff
9600 b188       LDA ($88), Y
9602 850f       STA $0f
9604 ce2e01     DEC $012e
9607 68         PLA
9608 8588       STA $88
960a a900       LDA #$00
960c 8589       STA $89
960e a206       LDX #$06
9610 18         CLC
9611 0688       ASL $88
9613 2689       ROL $89
9615 ca         DEC
9616 d0f8       BNE 9610
9618 18         CLC
9619 a980       LDA #$80
961b 6588       ADC $88
961d 8588       STA $88
961f a9eb       LDA #$eb
9621 6589       ADC $89
9623 8589       STA $89
9625 a900       LDA #$00
9627 8d2f01     STA $012f
962a a240       LDX #$40
962c ac2f01     LDY $012f
962f b188       LDA ($88), Y
9631 ac2e01     LDY $012e
9634 9186       STA ($86), Y
9636 ee2e01     INC $012e
9639 ee2f01     INC $012f
963c ca         DEC
963d d0ed       BNE 962c
963f 60         RTS
9640 a50b       LDA $0b
9642 c901       CMP #$01
9644 d008       BNE 964e
9646 a020       LDY #$20
9648 a200       LDX #$00
964a 20         JSR
964b 1ea460     ASL $60a4, X
964e a50b       LDA $0b
9650 c902       CMP #$02
9652 d015       BNE 9669
9654 a028       LDY #$28
9656 a200       LDX #$00
9658 20         JSR
9659 1ea4a2     ASL $a2a4, X
965c 00         BRK
965d bd90a0     LDA $a090, X
9660 9d4601     STA $0146, X
9663 e8         INX
9664 e010       CPX #$10
9666 d0f5       BNE 965d
9668 60         RTS
9669 a50b       LDA $0b
966b c903       CMP #$03
966d d004       BNE 9673
966f 20         JSR
9670 42a4       LSR #$a4
9672 60         RTS
9673 a50b       LDA $0b
9675 c904       CMP #$04
9677 d00e       BNE 9687
9679 a98a       LDA #$8a
967b 8586       STA $86
967d a9a1       LDA #$a1
967f 8587       STA $87
9681 a923       LDA #$23
9683 20         JSR
9684 db 92
9685 a460       LDY $60
9687 a020       LDY #$20
9689 20         JSR
968a d8         CLD
968b a2a9       LDX #$a9
968d c485       CPY $85
968f 86a9       STX $a9
9691 9685       STX $85, X
9693 db 87
9694 20         JSR
9695 db f3
9696 db a3
9697 a921       LDA #$21
9699 8d0620     STA $2006 ; PPU Memory Address
969c a9d2       LDA #$d2
969e 8d0620     STA $2006 ; PPU Memory Address
96a1 a51b       LDA $1b
96a3 c900       CMP #$00
96a5 d002       BNE 96a9
96a7 a92d       LDA #$2d
96a9 8d0720     STA $2007 ; PPU Memory Data
96ac a51c       LDA $1c
96ae 8d0720     STA $2007 ; PPU Memory Data
96b1 a900       LDA #$00
96b3 8d0520     STA $2005 ; Background Scroll
96b6 8d0520     STA $2005 ; Background Scroll
96b9 a964       LDA #$64
96bb 8d3b01     STA $013b
96be a90e       LDA #$0e
96c0 8d0120     STA $2001 ; PPU Control Register 2
96c3 60         RTS
96c4 21cc       AND ($cc, X)
96c6 051b       ORA $1b
96c8 18         CLC
96c9 1e170d     ASL $0d17, X
96cc db ff
96cd a020       LDY #$20
96cf a200       LDX #$00
96d1 20         JSR
96d2 1ea4a9     ASL $a9a4, X
96d5 d085       BNE 965c
96d7 86a9       STX $a9
96d9 db 04
96da 8587       STA $87
96dc a519       LDA $19
96de c900       CMP #$00
96e0 f008       BEQ 96ea
96e2 a940       LDA #$40
96e4 8586       STA $86
96e6 a906       LDA #$06
96e8 8587       STA $87
96ea a923       LDA #$23
96ec 20         JSR
96ed db 92
96ee a4a9       LDY $a9
96f0 db 92
96f1 8586       STA $86
96f3 a997       LDA #$97
96f5 8587       STA $87
96f7 20         JSR
96f8 db f3
96f9 db a3
96fa a914       LDA #$14
96fc 8d0020     STA $2000 ; PPU Control Register 1
96ff a9ae       LDA #$ae
9701 8586       STA $86
9703 a997       LDA #$97
9705 8587       STA $87
9707 20         JSR
9708 db f3
9709 db a3
970a a910       LDA #$10
970c 8d0020     STA $2000 ; PPU Control Register 1
970f a96c       LDA #$6c
9711 8586       STA $86
9713 a997       LDA #$97
9715 8587       STA $87
9717 20         JSR
9718 db f3
9719 db a3
971a 20         JSR
971b db 03
971c b8         CLV
971d 20         JSR
971e db 13
971f b8         CLV
9720 a510       LDA $10
9722 c900       CMP #$00
9724 f001       BEQ 9727
9726 60         RTS
9727 a518       LDA $18
9729 c900       CMP #$00
972b f00e       BEQ 973b
972d a982       LDA #$82
972f 8586       STA $86
9731 a997       LDA #$97
9733 8587       STA $87
9735 20         JSR
9736 db f3
9737 db a3
9738 20         JSR
9739 db 23
973a b8         CLV
973b 20         JSR
973c db 33
973d b8         CLV
973e a989       LDA #$89
9740 8586       STA $86
9742 a997       LDA #$97
9744 8587       STA $87
9746 20         JSR
9747 db f3
9748 db a3
9749 a923       LDA #$23
974b 8d0620     STA $2006 ; PPU Memory Address
974e a95d       LDA #$5d
9750 8d0620     STA $2006 ; PPU Memory Address
9753 a51b       LDA $1b
9755 c900       CMP #$00
9757 d002       BNE 975b
9759 a92d       LDA #$2d
975b 8d0720     STA $2007 ; PPU Memory Data
975e a51c       LDA $1c
9760 8d0720     STA $2007 ; PPU Memory Data
9763 a900       LDA #$00
9765 8d0520     STA $2005 ; Background Scroll
9768 8d0520     STA $2005 ; Background Scroll
976b 60         RTS
976c 20         JSR
976d 790411     ADC $1104, Y
9770 db 12
9771 1011       BPL 9784
9773 20         JSR
9774 db 9a
9775 051c       ORA $1c
9777 db 0c
9778 18         CLC
9779 db 1b
977a 0e20f9     ASL $f920
977d db 03
977e 2e1e19     ROL $191e
9781 db ff
9782 2159       AND ($59, X)
9784 db 03
9785 db 2f
9786 1e19ff     ASL $ff19, X
9789 db 23
978a db 3a
978b 051b       ORA $1b
978d 18         CLC
978e 1e170d     ASL $0d17, X
9791 db ff
9792 20         JSR
9793 2118       AND ($18, X)
9795 8494       STY $94
9797 9494       STY $94, X
9799 9480       STY $80, X
979b 8182       STA ($82, X)
979d 9594       STA $94, X
979f 9494       STY $94, X
97a1 9494       STY $94, X
97a3 9494       STY $94, X
97a5 8081       STY #$81
97a7 8295       STX #$95
97a9 9494       STY $94, X
97ab 9485       STY $85, X
97ad db ff
97ae 20         JSR
97af 411c       EOR ($1c, X)
97b1 a5a5       LDA $a5
97b3 8696       STX $96
97b5 a6a4       LDX $a4
97b7 a5a5       LDA $a5
97b9 a586       LDA $86
97bb 96a6       STX $a6, X
97bd a4a5       LDY $a5
97bf a5a5       LDA $a5
97c1 8696       STX $96
97c3 a6a4       LDX $a4
97c5 a5a5       LDA $a5
97c7 a586       LDA $86
97c9 96a6       STX $a6, X
97cb a4a5       LDY $a5
97cd 20         JSR
97ce 58         CLI
97cf db 1c
97d0 a5a5       LDA $a5
97d2 8696       STX $96
97d4 a6a4       LDX $a4
97d6 a5a5       LDA $a5
97d8 a586       LDA $86
97da 96a6       STX $a6, X
97dc a4a5       LDY $a5
97de a5a5       LDA $a5
97e0 8696       STX $96
97e2 a6a4       LDX $a4
97e4 a5a5       LDA $a5
97e6 a586       LDA $86
97e8 96a6       STX $a6, X
97ea a4a5       LDY $a5
97ec db ff
97ed a521       LDA $21
97ef a419       LDY $19
97f1 c000       CPY #$00
97f3 f002       BEQ 97f7
97f5 a524       LDA $24
97f7 38         SEC
97f8 e901       SBC #$01
97fa 2903       AND #$03
97fc a2c0       LDX #$c0
97fe c900       CMP #$00
9800 f00e       BEQ 9810
9802 a2c4       LDX #$c4
9804 c901       CMP #$01
9806 f008       BEQ 9810
9808 a2c8       LDX #$c8
980a c902       CMP #$02
980c f002       BEQ 9810
980e a2cc       LDX #$cc
9810 8e3101     STX $0131
9813 a9b0       LDA #$b0
9815 8586       STA $86
9817 a906       LDA #$06
9819 8587       STA $87
981b a91c       LDA #$1c
981d 8d2e01     STA $012e
9820 a900       LDA #$00
9822 8d3201     STA $0132
9825 a000       LDY #$00
9827 a20b       LDX #$0b
9829 18         CLC
982a ad3101     LDA $0131
982d 6d3201     ADC $0132
9830 9186       STA ($86), Y
9832 c8         INY
9833 d002       BNE 9837
9835 e687       INC $87
9837 ee3201     INC $0132
983a ee3201     INC $0132
983d ad3201     LDA $0132
9840 2933       AND #$33
9842 8d3201     STA $0132
9845 ca         DEC
9846 d0e1       BNE 9829
9848 18         CLC
9849 ad3201     LDA $0132
984c 6910       ADC #$10
984e 2930       AND #$30
9850 8d3201     STA $0132
9853 ce2e01     DEC $012e
9856 d0cf       BNE 9827
9858 a9a0       LDA #$a0
985a 8586       STA $86
985c a903       LDA #$03
985e 8587       STA $87
9860 a9c0       LDA #$c0
9862 8588       STA $88
9864 a904       LDA #$04
9866 8589       STA $89
9868 a419       LDY $19
986a c000       CPY #$00
986c f010       BEQ 987e
986e a910       LDA #$10
9870 8586       STA $86
9872 a905       LDA #$05
9874 8587       STA $87
9876 a930       LDA #$30
9878 8588       STA $88
987a a906       LDA #$06
987c 8589       STA $89
987e a9b0       LDA #$b0
9880 858a       STA $8a
9882 a906       LDA #$06
9884 858b       STA $8b
9886 a900       LDA #$00
9888 8d3101     STA $0131
988b ac3101     LDY $0131
988e b186       LDA ($86), Y
9890 c900       CMP #$00
9892 f010       BEQ 98a4
9894 4a         LSR
9895 4a         LSR
9896 4a         LSR
9897 4a         LSR
9898 a8         TAY
9899 b188       LDA ($88), Y
989b c900       CMP #$00
989d f005       BEQ 98a4
989f ac3101     LDY $0131
98a2 918a       STA ($8a), Y
98a4 ee3101     INC $0131
98a7 d0e2       BNE 988b
98a9 a91c       LDA #$1c
98ab 8d2e01     STA $012e
98ae a000       LDY #$00
98b0 a9b0       LDA #$b0
98b2 8586       STA $86
98b4 a906       LDA #$06
98b6 8587       STA $87
98b8 a920       LDA #$20
98ba 8588       STA $88
98bc a942       LDA #$42
98be 8589       STA $89
98c0 a588       LDA $88
98c2 8d0620     STA $2006 ; PPU Memory Address
98c5 a589       LDA $89
98c7 8d0620     STA $2006 ; PPU Memory Address
98ca a20b       LDX #$0b
98cc b186       LDA ($86), Y
98ce 8d0720     STA $2007 ; PPU Memory Data
98d1 18         CLC
98d2 6901       ADC #$01
98d4 8d0720     STA $2007 ; PPU Memory Data
98d7 c8         INY
98d8 d002       BNE 98dc
98da e687       INC $87
98dc ca         DEC
98dd d0ed       BNE 98cc
98df a900       LDA #$00
98e1 8d0520     STA $2005 ; Background Scroll
98e4 8d0520     STA $2005 ; Background Scroll
98e7 18         CLC
98e8 a589       LDA $89
98ea 6920       ADC #$20
98ec 8589       STA $89
98ee a588       LDA $88
98f0 6900       ADC #$00
98f2 8588       STA $88
98f4 ce2e01     DEC $012e
98f7 d0c7       BNE 98c0
98f9 a51a       LDA $1a
98fb c921       CMP #$21
98fd 9048       BCC 9947
98ff a920       LDA #$20
9901 8586       STA $86
9903 a9a9       LDA #$a9
9905 8587       STA $87
9907 a948       LDA #$48
9909 8d3101     STA $0131
990c a00c       LDY #$0c
990e a208       LDX #$08
9910 a586       LDA $86
9912 8d0620     STA $2006 ; PPU Memory Address
9915 a587       LDA $87
9917 8d0620     STA $2006 ; PPU Memory Address
991a ad3101     LDA $0131
991d 8d0720     STA $2007 ; PPU Memory Data
9920 ee3101     INC $0131
9923 ca         DEC
9924 d0f4       BNE 991a
9926 a900       LDA #$00
9928 8d0520     STA $2005 ; Background Scroll
992b 8d0520     STA $2005 ; Background Scroll
992e 18         CLC
992f ad3101     LDA $0131
9932 6908       ADC #$08
9934 8d3101     STA $0131
9937 18         CLC
9938 a587       LDA $87
993a 6920       ADC #$20
993c 8587       STA $87
993e a586       LDA $86
9940 6900       ADC #$00
9942 8586       STA $86
9944 88         DEY
9945 d0c7       BNE 990e
9947 60         RTS
9948 a901       LDA #$01
994a 8581       STA $81
994c 8d2a01     STA $012a
994f a918       LDA #$18
9951 8d0a01     STA $010a
9954 a90b       LDA #$0b
9956 8d0b01     STA $010b
9959 a9cc       LDA #$cc
995b 8537       STA $37
995d a915       LDA #$15
995f 8d2601     STA $0126
9962 a918       LDA #$18
9964 8d2701     STA $0127
9967 a61a       LDX $1a
9969 bdcd99     LDA $99cd, X
996c 8d0001     STA $0100
996f 8d0101     STA $0101
9972 8549       STA $49
9974 854a       STA $4a
9976 aa         LDX
9977 bd119a     LDA $9a11, X
997a 8d0201     STA $0102
997d a901       LDA #$01
997f 8d2001     STA $0120
9982 a909       LDA #$09
9984 8d2101     STA $0121
9987 a9d0       LDA #$d0
9989 8d1401     STA $0114
998c 8d1501     STA $0115
998f 8d1601     STA $0116
9992 8d1701     STA $0117
9995 8d1801     STA $0118
9998 8d1901     STA $0119
999b a958       LDA #$58
999d 8d1a01     STA $011a
99a0 a508       LDA $08
99a2 c900       CMP #$00
99a4 f009       BEQ 99af
99a6 c9a0       CMP #$a0
99a8 9002       BCC 99ac
99aa a9a0       LDA #$a0
99ac 8d1a01     STA $011a
99af 18         CLC
99b0 ad1a01     LDA $011a
99b3 6908       ADC #$08
99b5 8d1b01     STA $011b
99b8 8d1c01     STA $011c
99bb 18         CLC
99bc 6908       ADC #$08
99be 8d1d01     STA $011d
99c1 8d1e01     STA $011e
99c4 8538       STA $38
99c6 18         CLC
99c7 6908       ADC #$08
99c9 8d1f01     STA $011f
99cc 60         RTS
99cd db 07
99ce db 07
99cf db 07
99d0 db 07
99d1 db 07
99d2 db 07
99d3 db 07
99d4 08         PHP
99d5 db 07
99d6 08         PHP
99d7 0607       ASL $07
99d9 0608       ASL $08
99db db 07
99dc 08         PHP
99dd 0607       ASL $07
99df db 07
99e0 db 07
99e1 db 07
99e2 db 07
99e3 08         PHP
99e4 db 07
99e5 db 07
99e6 db 07
99e7 08         PHP
99e8 0608       ASL $08
99ea db 07
99eb db 07
99ec db 07
99ed db 07
99ee db 07
99ef 00         BRK
99f0 08         PHP
99f1 08         PHP
99f2 0900       ORA #$00
99f4 08         PHP
99f5 08         PHP
99f6 08         PHP
99f7 00         BRK
99f8 08         PHP
99f9 0608       ASL $08
99fb 08         PHP
99fc 0907       ORA #$07
99fe 08         PHP
99ff 0608       ASL $08
9a01 08         PHP
9a02 08         PHP
9a03 00         BRK
9a04 08         PHP
9a05 00         BRK
9a06 00         BRK
9a07 00         BRK
9a08 00         BRK
9a09 08         PHP
9a0a 0908       ORA #$08
9a0c 00         BRK
9a0d 08         PHP
9a0e 00         BRK
9a0f 00         BRK
9a10 00         BRK
9a11 00         BRK
9a12 0a         ASL
9a13 db 0f
9a14 db 14
9a15 1e2837     ASL $3728, X
9a18 506e       BVC 9a88
9a1a db 87
9a1b a0b9       LDY #$b9
9a1d db d2
9a1e e6f5       INC $f5
9a20 db ff
9a21 00         BRK
9a22 00         BRK
9a23 00         BRK
9a24 00         BRK
9a25 00         BRK
9a26 00         BRK
9a27 db 07
9a28 08         PHP
9a29 0e1015     ASL $1510
9a2c 18         CLC
9a2d 00         BRK
9a2e 00         BRK
9a2f db 07
9a30 08         PHP
9a31 0e1000     ASL $0010
9a34 00         BRK
9a35 00         BRK
9a36 00         BRK
9a37 00         BRK
9a38 00         BRK
9a39 00         BRK
9a3a 00         BRK
9a3b db 07
9a3c 08         PHP
9a3d 0e1000     ASL $0010
9a40 00         BRK
9a41 db 07
9a42 08         PHP
9a43 0e1000     ASL $0010
9a46 00         BRK
9a47 00         BRK
9a48 00         BRK
9a49 db 07
9a4a 08         PHP
9a4b 00         BRK
9a4c 00         BRK
9a4d 00         BRK
9a4e 00         BRK
9a4f 00         BRK
9a50 00         BRK
9a51 00         BRK
9a52 00         BRK
9a53 00         BRK
9a54 00         BRK
9a55 00         BRK
9a56 00         BRK
9a57 00         BRK
9a58 00         BRK
9a59 00         BRK
9a5a 00         BRK
9a5b db 07
9a5c 08         PHP
9a5d 00         BRK
9a5e 00         BRK
9a5f 00         BRK
9a60 00         BRK
9a61 00         BRK
9a62 00         BRK
9a63 00         BRK
9a64 00         BRK
9a65 00         BRK
9a66 00         BRK
9a67 00         BRK
9a68 00         BRK
9a69 00         BRK
9a6a 00         BRK
9a6b 00         BRK
9a6c 00         BRK
9a6d 00         BRK
9a6e 00         BRK
9a6f db 07
9a70 08         PHP
9a71 0e1015     ASL $1510
9a74 18         CLC
9a75 00         BRK
9a76 00         BRK
9a77 00         BRK
9a78 00         BRK
9a79 00         BRK
9a7a 00         BRK
9a7b db 07
9a7c 08         PHP
9a7d 0e1015     ASL $1510
9a80 18         CLC
9a81 00         BRK
9a82 00         BRK
9a83 00         BRK
9a84 00         BRK
9a85 00         BRK
9a86 00         BRK
9a87 00         BRK
9a88 00         BRK
9a89 00         BRK
9a8a 00         BRK
9a8b 00         BRK
9a8c 00         BRK
9a8d 00         BRK
9a8e 00         BRK
9a8f 00         BRK
9a90 00         BRK
9a91 00         BRK
9a92 00         BRK
9a93 00         BRK
9a94 00         BRK
9a95 00         BRK
9a96 00         BRK
9a97 00         BRK
9a98 00         BRK
9a99 00         BRK
9a9a 00         BRK
9a9b db 07
9a9c 08         PHP
9a9d 0e1000     ASL $0010
9aa0 00         BRK
9aa1 db 07
9aa2 08         PHP
9aa3 0e1000     ASL $0010
9aa6 00         BRK
9aa7 00         BRK
9aa8 00         BRK
9aa9 db 07
9aaa 08         PHP
9aab 00         BRK
9aac 00         BRK
9aad 00         BRK
9aae 00         BRK
9aaf 00         BRK
9ab0 00         BRK
9ab1 db 07
9ab2 08         PHP
9ab3 0e1015     ASL $1510
9ab6 18         CLC
9ab7 00         BRK
9ab8 00         BRK
9ab9 00         BRK
9aba 00         BRK
9abb 00         BRK
9abc 00         BRK
9abd 00         BRK
9abe 00         BRK
9abf 00         BRK
9ac0 00         BRK
9ac1 00         BRK
9ac2 00         BRK
9ac3 00         BRK
9ac4 00         BRK
9ac5 00         BRK
9ac6 00         BRK
9ac7 00         BRK
9ac8 00         BRK
9ac9 db 07
9aca 08         PHP
9acb 0e1015     ASL $1510
9ace 18         CLC
9acf 00         BRK
9ad0 00         BRK
9ad1 00         BRK
9ad2 00         BRK
9ad3 00         BRK
9ad4 00         BRK
9ad5 00         BRK
9ad6 00         BRK
9ad7 00         BRK
9ad8 00         BRK
9ad9 00         BRK
9ada 00         BRK
9adb 00         BRK
9adc 00         BRK
9add 00         BRK
9ade 00         BRK
9adf 00         BRK
9ae0 00         BRK
9ae1 db 07
9ae2 08         PHP
9ae3 0e1015     ASL $1510
9ae6 18         CLC
9ae7 00         BRK
9ae8 00         BRK
9ae9 00         BRK
9aea 00         BRK
9aeb 00         BRK
9aec 00         BRK
9aed db 07
9aee 08         PHP
9aef 0e1015     ASL $1510
9af2 18         CLC
9af3 00         BRK
9af4 00         BRK
9af5 db 07
9af6 08         PHP
9af7 0e10ff     ASL $ff10
9afa db ff
9afb db ff
9afc db ff
9afd db ff
9afe db ff
9aff a000       LDY #$00
9b01 b186       LDA ($86), Y
9b03 990002     STA $0200, Y
9b06 c8         INY
9b07 ca         DEC
9b08 d0f7       BNE 9b01
9b0a 60         RTS
9b0b a000       LDY #$00
9b0d a9b0       LDA #$b0
9b0f 8586       STA $86
9b11 a904       LDA #$04
9b13 8587       STA $87
9b15 a519       LDA $19
9b17 c900       CMP #$00
9b19 f008       BEQ 9b23
9b1b a920       LDA #$20
9b1d 8586       STA $86
9b1f a906       LDA #$06
9b21 8587       STA $87
9b23 b186       LDA ($86), Y
9b25 994601     STA $0146, Y
9b28 c8         INY
9b29 c010       CPY #$10
9b2b d0f6       BNE 9b23
9b2d 60         RTS
9b2e a200       LDX #$00
9b30 a000       LDY #$00
9b32 38         SEC
9b33 a51a       LDA $1a
9b35 e901       SBC #$01
9b37 2903       AND #$03
9b39 0a         ASL
9b3a 0a         ASL
9b3b 0a         ASL
9b3c 0a         ASL
9b3d aa         LDX
9b3e bd4b9b     LDA $9b4b, X
9b41 995601     STA $0156, Y
9b44 e8         INX
9b45 c8         INY
9b46 c010       CPY #$10
9b48 d0f4       BNE 9b3e
9b4a 60         RTS
9b4b db 0f
9b4c 20         JSR
9b4d 1600       ASL $00, X
9b4f db 0f
9b50 302c       BMI 9b7e
9b52 db 1c
9b53 db 0f
9b54 db 27
9b55 1630       ASL $30, X
9b57 db 0f
9b58 00         BRK
9b59 00         BRK
9b5a 300f       BMI 9b6b
9b5c 20         JSR
9b5d 1600       ASL $00, X
9b5f db 0f
9b60 28         PLP
9b61 2916       AND #$16
9b63 db 0f
9b64 db 27
9b65 1630       ASL $30, X
9b67 db 0f
9b68 00         BRK
9b69 00         BRK
9b6a 300f       BMI 9b7b
9b6c 20         JSR
9b6d 1600       ASL $00, X
9b6f db 0f
9b70 3031       BMI 9ba3
9b72 210f       AND ($0f, X)
9b74 db 27
9b75 1630       ASL $30, X
9b77 db 0f
9b78 00         BRK
9b79 00         BRK
9b7a 300f       BMI 9b8b
9b7c 20         JSR
9b7d 1600       ASL $00, X
9b7f db 0f
9b80 2616       ROL $16
9b82 060f       ASL $0f
9b84 db 27
9b85 1630       ASL $30, X
9b87 db 0f
9b88 00         BRK
9b89 00         BRK
9b8a 30ad       BMI 9b39
9b8c 4401       JMP $01
9b8e c900       CMP #$00
9b90 d038       BNE 9bca
9b92 ee4401     INC $0144
9b95 a900       LDA #$00
9b97 8d3201     STA $0132
9b9a 8d3301     STA $0133
9b9d a97f       LDA #$7f
9b9f 8d0002     STA $0200
9ba2 a521       LDA $21
9ba4 c900       CMP #$00
9ba6 f004       BEQ 9bac
9ba8 c922       CMP #$22
9baa 900a       BCC 9bb6
9bac a901       LDA #$01
9bae 8521       STA $21
9bb0 8523       STA $23
9bb2 a900       LDA #$00
9bb4 8522       STA $22
9bb6 a524       LDA $24
9bb8 c900       CMP #$00
9bba f004       BEQ 9bc0
9bbc c922       CMP #$22
9bbe 900a       BCC 9bca
9bc0 a901       LDA #$01
9bc2 8524       STA $24
9bc4 8526       STA $26
9bc6 a900       LDA #$00
9bc8 8525       STA $25
9bca a500       LDA $00
9bcc 4501       EOR $01
9bce 2500       AND $00
9bd0 8d3101     STA $0131
9bd3 c910       CMP #$10
9bd5 f00b       BEQ 9be2
9bd7 a506       LDA $06
9bd9 4507       EOR $07
9bdb 2506       AND $06
9bdd d003       BNE 9be2
9bdf 4c749c     JMP $9c74
9be2 ad3301     LDA $0133
9be5 8518       STA $18
9be7 a900       LDA #$00
9be9 8519       STA $19
9beb a200       LDX #$00
9bed a900       LDA #$00
9bef 9d7003     STA $0370, X
9bf2 e8         INX
9bf3 e024       CPX #$24
9bf5 d0f8       BNE 9bef
9bf7 a90c       LDA #$0c
9bf9 20         JSR
9bfa c6f3       DEC $f3
9bfc a904       LDA #$04
9bfe 850a       STA $0a
9c00 a901       LDA #$01
9c02 8d3f01     STA $013f
9c05 a903       LDA #$03
9c07 8d4001     STA $0140
9c0a a9f0       LDA #$f0
9c0c 8d0002     STA $0200
9c0f a900       LDA #$00
9c11 8d6c03     STA $036c
9c14 8d6e03     STA $036e
9c17 a902       LDA #$02
9c19 8d6d03     STA $036d
9c1c 8d6f03     STA $036f
9c1f a900       LDA #$00
9c21 8d4401     STA $0144
9c24 8510       STA $10
9c26 8512       STA $12
9c28 8513       STA $13
9c2a a518       LDA $18
9c2c c900       CMP #$00
9c2e d01f       BNE 9c4f
9c30 a900       LDA #$00
9c32 851f       STA $1f
9c34 8520       STA $20
9c36 851e       STA $1e
9c38 a9f0       LDA #$f0
9c3a 851d       STA $1d
9c3c ad3201     LDA $0132
9c3f c905       CMP #$05
9c41 9001       BCC 9c44
9c43 60         RTS
9c44 a901       LDA #$01
9c46 8521       STA $21
9c48 8523       STA $23
9c4a a900       LDA #$00
9c4c 8522       STA $22
9c4e 60         RTS
9c4f a903       LDA #$03
9c51 851d       STA $1d
9c53 851e       STA $1e
9c55 a900       LDA #$00
9c57 851f       STA $1f
9c59 8520       STA $20
9c5b ad3201     LDA $0132
9c5e c905       CMP #$05
9c60 9001       BCC 9c63
9c62 60         RTS
9c63 a901       LDA #$01
9c65 8521       STA $21
9c67 8524       STA $24
9c69 8523       STA $23
9c6b 8526       STA $26
9c6d a900       LDA #$00
9c6f 8522       STA $22
9c71 8525       STA $25
9c73 60         RTS
9c74 a500       LDA $00
9c76 c920       CMP #$20
9c78 d024       BNE 9c9e
9c7a ad3101     LDA $0131
9c7d c920       CMP #$20
9c7f d01d       BNE 9c9e
9c81 ad0002     LDA $0200
9c84 c97f       CMP #$7f
9c86 f00b       BEQ 9c93
9c88 a900       LDA #$00
9c8a 8d3301     STA $0133
9c8d a97f       LDA #$7f
9c8f 8d0002     STA $0200
9c92 60         RTS
9c93 a901       LDA #$01
9c95 8d3301     STA $0133
9c98 a98f       LDA #$8f
9c9a 8d0002     STA $0200
9c9d 60         RTS
9c9e a500       LDA $00
9ca0 c9e0       CMP #$e0
9ca2 d00a       BNE 9cae
9ca4 ad3101     LDA $0131
9ca7 c920       CMP #$20
9ca9 d003       BNE 9cae
9cab ee3201     INC $0132
9cae 60         RTS
9caf a200       LDX #$00
9cb1 bd0e9f     LDA $9f0e, X
9cb4 9d5402     STA $0254, X
9cb7 e8         INX
9cb8 e01c       CPX #$1c
9cba d0f5       BNE 9cb1
9cbc a000       LDY #$00
9cbe b92a9f     LDA $9f2a, Y
9cc1 9d5402     STA $0254, X
9cc4 e8         INX
9cc5 c8         INY
9cc6 c014       CPY #$14
9cc8 d0f4       BNE 9cbe
9cca a519       LDA $19
9ccc c900       CMP #$00
9cce f005       BEQ 9cd5
9cd0 a9ce       LDA #$ce
9cd2 8d6d02     STA $026d
9cd5 60         RTS
9cd6 a200       LDX #$00
9cd8 bd0e9f     LDA $9f0e, X
9cdb 9d5402     STA $0254, X
9cde e8         INX
9cdf e01c       CPX #$1c
9ce1 d0f5       BNE 9cd8
9ce3 a000       LDY #$00
9ce5 b93e9f     LDA $9f3e, Y
9ce8 9d5402     STA $0254, X
9ceb e8         INX
9cec c8         INY
9ced c020       CPY #$20
9cef d0f4       BNE 9ce5
9cf1 a519       LDA $19
9cf3 f005       BEQ 9cfa
9cf5 a9ce       LDA #$ce
9cf7 8d6d02     STA $026d
9cfa a518       LDA $18
9cfc d010       BNE 9d0e
9cfe a007       LDY #$07
9d00 a200       LDX #$00
9d02 a9f0       LDA #$f0
9d04 9d5402     STA $0254, X
9d07 e8         INX
9d08 e8         INX
9d09 e8         INX
9d0a e8         INX
9d0b 88         DEY
9d0c d0f6       BNE 9d04
9d0e 60         RTS
9d0f a50b       LDA $0b
9d11 c900       CMP #$00
9d13 d01e       BNE 9d33
9d15 a001       LDY #$01
9d17 b9f19f     LDA $9ff1, Y
9d1a 99f19f     STA $9ff1, Y
9d1d a906       LDA #$06
9d1f 8d0120     STA $2001 ; PPU Control Register 2
9d22 a020       LDY #$20
9d24 a200       LDX #$00
9d26 20         JSR
9d27 1ea4a0     ASL $a0a4, X
9d2a 28         PLP
9d2b a200       LDX #$00
9d2d 20         JSR
9d2e 1ea4e6     ASL $e6a4, X
9d31 db 0b
9d32 60         RTS
9d33 a50b       LDA $0b
9d35 c901       CMP #$01
9d37 d013       BNE 9d4c
9d39 a200       LDX #$00
9d3b bd0a9e     LDA $9e0a, X
9d3e 9d4601     STA $0146, X
9d41 e8         INX
9d42 e010       CPX #$10
9d44 d0f5       BNE 9d3b
9d46 20         JSR
9d47 42a4       LSR #$a4
9d49 e60b       INC $0b
9d4b 60         RTS
9d4c a50b       LDA $0b
9d4e c902       CMP #$02
9d50 d008       BNE 9d5a
9d52 a020       LDY #$20
9d54 20         JSR
9d55 d8         CLD
9d56 a2e6       LDX #$e6
9d58 db 0b
9d59 60         RTS
9d5a a50b       LDA $0b
9d5c c903       CMP #$03
9d5e d03e       BNE 9d9e
9d60 a91a       LDA #$1a
9d62 8586       STA $86
9d64 a99e       LDA #$9e
9d66 8587       STA $87
9d68 20         JSR
9d69 db f3
9d6a db a3
9d6b 20         JSR
9d6c d69c       DEC $9c, X
9d6e a00f       LDY #$0f
9d70 a200       LDX #$00
9d72 bd5402     LDA $0254, X
9d75 c9f0       CMP #$f0
9d77 f006       BEQ 9d7f
9d79 38         SEC
9d7a e976       SBC #$76
9d7c 9d5402     STA $0254, X
9d7f 18         CLC
9d80 bd5702     LDA $0257, X
9d83 6918       ADC #$18
9d85 9d5702     STA $0257, X
9d88 e8         INX
9d89 e8         INX
9d8a e8         INX
9d8b e8         INX
9d8c 88         DEY
9d8d d0e3       BNE 9d72
9d8f e60b       INC $0b
9d91 a91e       LDA #$1e
9d93 8d0120     STA $2001 ; PPU Control Register 2
9d96 8515       STA $15
9d98 a996       LDA #$96
9d9a 8d3b01     STA $013b
9d9d 60         RTS
9d9e a50b       LDA $0b
9da0 c904       CMP #$04
9da2 d01d       BNE 9dc1
9da4 a9eb       LDA #$eb
9da6 8586       STA $86
9da8 a99e       LDA #$9e
9daa 8587       STA $87
9dac a906       LDA #$06
9dae 8d0120     STA $2001 ; PPU Control Register 2
9db1 20         JSR
9db2 db f3
9db3 db a3
9db4 a515       LDA $15
9db6 8d0120     STA $2001 ; PPU Control Register 2
9db9 e60b       INC $0b
9dbb a90a       LDA #$0a
9dbd 8d3b01     STA $013b
9dc0 60         RTS
9dc1 a50b       LDA $0b
9dc3 c905       CMP #$05
9dc5 d01d       BNE 9de4
9dc7 a9f1       LDA #$f1
9dc9 8586       STA $86
9dcb a99e       LDA #$9e
9dcd 8587       STA $87
9dcf a906       LDA #$06
9dd1 8d0120     STA $2001 ; PPU Control Register 2
9dd4 20         JSR
9dd5 db f3
9dd6 db a3
9dd7 a515       LDA $15
9dd9 8d0120     STA $2001 ; PPU Control Register 2
9ddc e60b       INC $0b
9dde a90a       LDA #$0a
9de0 8d3b01     STA $013b
9de3 60         RTS
9de4 a9f7       LDA #$f7
9de6 8586       STA $86
9de8 a99e       LDA #$9e
9dea 8587       STA $87
9dec a906       LDA #$06
9dee 8d0120     STA $2001 ; PPU Control Register 2
9df1 20         JSR
9df2 db f3
9df3 db a3
9df4 a515       LDA $15
9df6 8d0120     STA $2001 ; PPU Control Register 2
9df9 a903       LDA #$03
9dfb 20         JSR
9dfc c6f3       DEC $f3
9dfe e60a       INC $0a
9e00 a900       LDA #$00
9e02 850b       STA $0b
9e04 a9f0       LDA #$f0
9e06 8d3b01     STA $013b
9e09 60         RTS
9e0a db 0f
9e0b 3016       BMI 9e23
9e0d 060f       ASL $0f
9e0f 3016       BMI 9e27
9e11 060f       ASL $0f
9e13 3016       BMI 9e2b
9e15 060f       ASL $0f
9e17 3016       BMI 9e2f
9e19 0622       ASL $22
9e1b 0e042d     ASL $2d04 ; Sprite Memory Data
9e1e db 3b
9e1f 3c2d22     BIT $222d, X
9e22 2e043d     ROL $3d04 ; Sprite Memory Data
9e25 3e3f70     ROL $703f, X
9e28 224e       ROL #$4e
9e2a db 04
9e2b 7172       ADC ($72), Y
9e2d db 73
9e2e 7422       JMP (ABS) $22, X
9e30 6e0475     ROR $7504
9e33 7677       ROR $77, X
9e35 db b2
9e36 228e       ROL #$8e
9e38 db 04
9e39 db b3
9e3a 2db4b5     AND $b5b4
9e3d 22ae       ROL #$ae
9e3f db 04
9e40 b62d       LDX $2d, X
9e42 db b7
9e43 c422       CPY $22
9e45 ce04c5     DEC $c504
9e48 c6c7       DEC $c7
9e4a d422       CPY $22, X
9e4c ee04d5     INC $d504
9e4f 2dd6d7     AND $d7d6
9e52 db 23
9e53 0e04e4     ASL $e404
9e56 e5e6       SBC $e6
9e58 db e7
9e59 2181       AND ($81, X)
9e5b 0528       ORA $28
9e5d 2929       AND #$29
9e5f 2a         ROL
9e60 3021       BMI 9e83
9e62 a105       LDA ($05, X)
9e64 3132       AND ($32), Y
9e66 db 33
9e67 db 33
9e68 3421       BIT $21, X
9e6a db ba
9e6b 05a3       ORA $a3
9e6d db 93
9e6e 2929       AND #$29
9e70 db 83
9e71 21da       AND ($da, X)
9e73 05a7       ORA $a7
9e75 db 33
9e76 db 33
9e77 db 97
9e78 db 87
9e79 21a9       AND ($a9, X)
9e7b db 04
9e7c 2c2929     BIT $2929 ; PPU Control Register 2
9e7f db 0b
9e80 21c9       AND ($c9, X)
9e82 db 04
9e83 db 27
9e84 db 33
9e85 db 33
9e86 db 0f
9e87 2193       AND ($93, X)
9e89 db 04
9e8a db 13
9e8b 2929       AND #$29
9e8d db 14
9e8e 21b3       AND ($b3, X)
9e90 db 04
9e91 1533       ORA $33, X
9e93 db 33
9e94 1622       ASL $22, X
9e96 2503       AND $03
9e98 3536       AND $36, X
9e9a db 37
9e9b 2269       ROL #$69
9e9d db 03
9e9e 3536       AND $36, X
9ea0 db 37
9ea1 2237       ROL #$37
9ea3 db 03
9ea4 2223       ROL #$23
9ea6 2422       BIT $22
9ea8 7403       JMP (ABS) $03, X
9eaa 2223       ROL #$23
9eac 2422       BIT $22
9eae db 0c
9eaf 0238       ASL #$38
9eb1 392232     AND $3222, Y
9eb4 0225       ASL #$25
9eb6 2622       ROL $22
9eb8 8a         STX
9eb9 01f4       ORA ($f4, X)
9ebb 2295       ROL #$95
9ebd 01f5       ORA ($f5, X)
9ebf 22ac       ROL #$ac
9ec1 01f6       ORA ($f6, X)
9ec3 22b2       ROL #$b2
9ec5 01f7       ORA ($f7, X)
9ec7 db 23
9ec8 40         RTI
9ec9 20         JSR
9eca db 3a
9ecb db 3a
9ecc db 3a
9ecd db 3a
9ece db 3a
9ecf db 3a
9ed0 db 3a
9ed1 db 3a
9ed2 db 3a
9ed3 db 3a
9ed4 db 3a
9ed5 db 3a
9ed6 db 3a
9ed7 db 3a
9ed8 db 3a
9ed9 db 3a
9eda db 3a
9edb db 3a
9edc db 3a
9edd db 3a
9ede db 3a
9edf db 3a
9ee0 db 3a
9ee1 db 3a
9ee2 db 3a
9ee3 db 3a
9ee4 db 3a
9ee5 db 3a
9ee6 db 3a
9ee7 db 3a
9ee8 db 3a
9ee9 db 3a
9eea db ff
9eeb 224f       ROL #$4f
9eed 022b       ASL #$2b
9eef db 1a
9ef0 db ff
9ef1 224f       ROL #$4f
9ef3 021d       ASL #$1d
9ef5 db 1f
9ef6 db ff
9ef7 224f       ROL #$4f
9ef9 0220       ASL #$20
9efb 21ff       AND ($ff, X)
9efd a00f       LDY #$0f
9eff a200       LDX #$00
9f01 a9f0       LDA #$f0
9f03 9d5402     STA $0254, X
9f06 e8         INX
9f07 e8         INX
9f08 e8         INX
9f09 e8         INX
9f0a 88         DEY
9f0b d0f6       BNE 9f03
9f0d 60         RTS
9f0e a8         TAY
9f0f db cb
9f10 00         BRK
9f11 4a         LSR
9f12 a8         TAY
9f13 cc0052     CPY $5200
9f16 a8         TAY
9f17 c400       CPY $00
9f19 db 5a
9f1a a8         TAY
9f1b c600       DEC $00
9f1d 62a8       ROR #$a8
9f1f db c3
9f20 00         BRK
9f21 6a         ROR
9f22 a8         TAY
9f23 c200       DEC #$00
9f25 db 72
9f26 a8         TAY
9f27 cd0082     CMP $8200
9f2a b8         CLV
9f2b c200       DEC #$00
9f2d db 52
9f2e b8         CLV
9f2f db c3
9f30 00         BRK
9f31 db 5a
9f32 b8         CLV
9f33 c400       CPY $00
9f35 62b8       ROR #$b8
9f37 c500       CMP $00
9f39 6a         ROR
9f3a b8         CLV
9f3b c600       DEC $00
9f3d db 72
9f3e b8         CLV
9f3f db c7
9f40 00         BRK
9f41 46b8       LSR $b8
9f43 c400       CPY $00
9f45 4eb8c8     LSR $c8b8
9f48 00         BRK
9f49 56b8       LSR $b8, X
9f4b db c3
9f4c 00         BRK
9f4d 5eb8c9     LSR $c9b8, X
9f50 00         BRK
9f51 6eb8ca     ROR $cab8
9f54 00         BRK
9f55 76b8       ROR $b8, X
9f57 db c3
9f58 00         BRK
9f59 7eb8c2     ROR $c2b8, X
9f5c 00         BRK
9f5d 86ad       STX $ad
9f5f 40         RTI
9f60 01f0       ORA ($f0, X)
9f62 db 04
9f63 ce4001     DEC $0140
9f66 60         RTS
9f67 ad3f01     LDA $013f
9f6a f041       BEQ 9fad
9f6c c90b       CMP #$0b
9f6e d00a       BNE 9f7a
9f70 a900       LDA #$00
9f72 8d3f01     STA $013f
9f75 a905       LDA #$05
9f77 850a       STA $0a
9f79 60         RTS
9f7a a9ae       LDA #$ae
9f7c 8586       STA $86
9f7e a99f       LDA #$9f
9f80 8587       STA $87
9f82 a518       LDA $18
9f84 f008       BEQ 9f8e
9f86 a9ba       LDA #$ba
9f88 8586       STA $86
9f8a a99f       LDA #$9f
9f8c 8587       STA $87
9f8e ad3f01     LDA $013f
9f91 2901       AND #$01
9f93 f00d       BEQ 9fa2
9f95 18         CLC
9f96 a586       LDA $86
9f98 6919       ADC #$19
9f9a 8586       STA $86
9f9c a587       LDA $87
9f9e 6900       ADC #$00
9fa0 8587       STA $87
9fa2 20         JSR
9fa3 db f3
9fa4 db a3
9fa5 ee3f01     INC $013f
9fa8 a91e       LDA #$1e
9faa 8d4001     STA $0140
9fad 60         RTS
9fae 220c       ROL #$0c
9fb0 08         PHP
9fb1 012d       ORA ($2d, X)
9fb3 19150a     ORA $0a15, Y
9fb6 220e       ROL #$0e
9fb8 db 1b
9fb9 db ff
9fba 224c       ROL #$4c
9fbc 0902       ORA #$02
9fbe 2d1915     AND $1519
9fc1 0a         ASL
9fc2 220e       ROL #$0e
9fc4 db 1b
9fc5 db 1c
9fc6 db ff
9fc7 220c       ROL #$0c
9fc9 08         PHP
9fca 2d2d2d     AND $2d2d ; Background Scroll
9fcd 2d2d2d     AND $2d2d ; Background Scroll
9fd0 2d2dff     AND $ff2d
9fd3 224c       ROL #$4c
9fd5 092d       ORA #$2d
9fd7 2d2d2d     AND $2d2d ; Background Scroll
9fda 2d2d2d     AND $2d2d ; Background Scroll
9fdd 2d2dff     AND $ff2d
9fe0 a000       LDY #$00
9fe2 a51a       LDA $1a
9fe4 c921       CMP #$21
9fe6 d002       BNE 9fea
9fe8 a001       LDY #$01
9fea b9f19f     LDA $9ff1, Y
9fed 99f19f     STA $9ff1, Y
9ff0 60         RTS
9ff1 00         BRK
9ff2 01a2       ORA ($a2, X)
9ff4 db 33
9ff5 a900       LDA #$00
9ff7 9500       STA $00, X
9ff9 e8         INX
9ffa d0fb       BNE 9ff7
9ffc 9d0001     STA $0100, X
9fff e8         INX
a000 e0a0       CPX #$a0
a002 d0f8       BNE 9ffc
a004 60         RTS
a005 a50b       LDA $0b
a007 d042       BNE a04b
a009 a906       LDA #$06
a00b 8d0120     STA $2001 ; PPU Control Register 2
a00e a200       LDX #$00
a010 bd90a0     LDA $a090, X
a013 9d4601     STA $0146, X
a016 e8         INX
a017 e020       CPX #$20
a019 d0f5       BNE a010
a01b 20         JSR
a01c 42a4       LSR #$a4
a01e 20         JSR
a01f 6a         ROR
a020 a420       LDY $20
a022 db c3
a023 db f3
a024 20         JSR
a025 db f3
a026 db 9f
a027 20         JSR
a028 ca         DEC
a029 a1a2       LDA ($a2, X)
a02b 00         BRK
a02c bd84a0     LDA $a084, X
a02f 9dcc02     STA $02cc, X
a032 e8         INX
a033 e00c       CPX #$0c
a035 d0f5       BNE a02c
a037 a000       LDY #$00
a039 b9f19f     LDA $9ff1, Y
a03c 99f19f     STA $9ff1, Y
a03f a908       LDA #$08
a041 8d3b01     STA $013b
a044 a900       LDA #$00
a046 8516       STA $16
a048 e60b       INC $0b
a04a 60         RTS
a04b a020       LDY #$20
a04d a200       LDX #$00
a04f 20         JSR
a050 1ea4a0     ASL $a0a4, X
a053 28         PLP
a054 a200       LDX #$00
a056 20         JSR
a057 1ea4a9     ASL $a9a4, X
a05a b085       BCS 9fe1
a05c 86a9       STX $a9
a05e a085       LDY #$85
a060 db 87
a061 a923       LDA #$23
a063 20         JSR
a064 db 92
a065 a4a0       LDY $a0
a067 20         JSR
a068 20         JSR
a069 d8         CLD
a06a a2a9       LDX #$a9
a06c cc8586     CPY $8685
a06f a9a4       LDA #$a4
a071 8587       STA $87
a073 20         JSR
a074 db f3
a075 db a3
a076 e60a       INC $0a
a078 a900       LDA #$00
a07a 850b       STA $0b
a07c a91e       LDA #$1e
a07e 8d0120     STA $2001 ; PPU Control Register 2
a081 8515       STA $15
a083 60         RTS
a084 db 47
a085 ee0096     INC $9600
a088 db 47
a089 db ef
a08a 00         BRK
a08b 9e4ffe     STX $fe4f, X
a08e 00         BRK
a08f 960f       STX $0f, X
a091 3030       BMI a0c3
a093 300f       BMI a0a4
a095 3016       BMI a0ad
a097 300f       BMI a0a8
a099 3024       BMI a0bf
a09b 010f       ORA ($0f, X)
a09d 3016       BMI a0b5
a09f 300f       BMI a0b0
a0a1 3024       BMI a0c7
a0a3 00         BRK
a0a4 db 0f
a0a5 00         BRK
a0a6 00         BRK
a0a7 00         BRK
a0a8 db 0f
a0a9 00         BRK
a0aa 00         BRK
a0ab 00         BRK
a0ac db 0f
a0ad 00         BRK
a0ae 00         BRK
a0af 00         BRK
a0b0 5050       BVC a102
a0b2 5050       BVC a104
a0b4 5050       BVC a106
a0b6 5050       BVC a108
a0b8 00         BRK
a0b9 00         BRK
a0ba 00         BRK
a0bb 00         BRK
a0bc 00         BRK
a0bd 00         BRK
a0be 00         BRK
a0bf 00         BRK
a0c0 aa         LDX
a0c1 aa         LDX
a0c2 aa         LDX
a0c3 aa         LDX
a0c4 aa         LDX
a0c5 aa         LDX
a0c6 aa         LDX
a0c7 aa         LDX
a0c8 00         BRK
a0c9 00         BRK
a0ca 00         BRK
a0cb 00         BRK
a0cc 00         BRK
a0cd 00         BRK
a0ce 00         BRK
a0cf 00         BRK
a0d0 00         BRK
a0d1 00         BRK
a0d2 00         BRK
a0d3 00         BRK
a0d4 00         BRK
a0d5 00         BRK
a0d6 00         BRK
a0d7 00         BRK
a0d8 00         BRK
a0d9 00         BRK
a0da 40         RTI
a0db 5050       BVC a12d
a0dd 1000       BPL a0df
a0df 00         BRK
a0e0 00         BRK
a0e1 00         BRK
a0e2 00         BRK
a0e3 00         BRK
a0e4 00         BRK
a0e5 00         BRK
a0e6 00         BRK
a0e7 00         BRK
a0e8 00         BRK
a0e9 00         BRK
a0ea 00         BRK
a0eb 00         BRK
a0ec 00         BRK
a0ed 00         BRK
a0ee 00         BRK
a0ef 00         BRK
a0f0 a906       LDA #$06
a0f2 8d0120     STA $2001 ; PPU Control Register 2
a0f5 a200       LDX #$00
a0f7 bd90a0     LDA $a090, X
a0fa 9d4601     STA $0146, X
a0fd e8         INX
a0fe e010       CPX #$10
a100 d0f5       BNE a0f7
a102 20         JSR
a103 42a4       LSR #$a4
a105 a020       LDY #$20
a107 a200       LDX #$00
a109 20         JSR
a10a 1ea4a0     ASL $a0a4, X
a10d 28         PLP
a10e a200       LDX #$00
a110 20         JSR
a111 1ea4a9     ASL $a9a4, X
a114 8a         STX
a115 8586       STA $86
a117 a9a1       LDA #$a1
a119 8587       STA $87
a11b a92b       LDA #$2b
a11d 20         JSR
a11e db 92
a11f a4a0       LDY $a0
a121 28         PLP
a122 20         JSR
a123 d8         CLD
a124 a2a9       LDX #$a9
a126 68         PLA
a127 8586       STA $86
a129 a9a5       LDA #$a5
a12b 8587       STA $87
a12d 20         JSR
a12e db f3
a12f db a3
a130 a901       LDA #$01
a132 8521       STA $21
a134 8524       STA $24
a136 8523       STA $23
a138 8526       STA $26
a13a a900       LDA #$00
a13c 8522       STA $22
a13e 8525       STA $25
a140 60         RTS
a141 a000       LDY #$00
a143 b9f19f     LDA $9ff1, Y
a146 99f19f     STA $9ff1, Y
a149 a906       LDA #$06
a14b 8d0120     STA $2001 ; PPU Control Register 2
a14e a200       LDX #$00
a150 bd90a0     LDA $a090, X
a153 9d4601     STA $0146, X
a156 e8         INX
a157 e010       CPX #$10
a159 d0f5       BNE a150
a15b 20         JSR
a15c 42a4       LSR #$a4
a15e a020       LDY #$20
a160 a200       LDX #$00
a162 20         JSR
a163 1ea4a0     ASL $a0a4, X
a166 28         PLP
a167 a200       LDX #$00
a169 20         JSR
a16a 1ea4a9     ASL $a9a4, X
a16d 8a         STX
a16e 8586       STA $86
a170 a9a1       LDA #$a1
a172 8587       STA $87
a174 a92b       LDA #$2b
a176 20         JSR
a177 db 92
a178 a4a0       LDY $a0
a17a 28         PLP
a17b 20         JSR
a17c d8         CLD
a17d a2a9       LDX #$a9
a17f db 3a
a180 8586       STA $86
a182 a9a6       LDA #$a6
a184 8587       STA $87
a186 20         JSR
a187 db f3
a188 db a3
a189 60         RTS
a18a f0f0       BEQ a17c
a18c f0f0       BEQ a17e
a18e f0f0       BEQ a180
a190 f0f0       BEQ a182
a192 00         BRK
a193 00         BRK
a194 00         BRK
a195 00         BRK
a196 00         BRK
a197 00         BRK
a198 00         BRK
a199 00         BRK
a19a 00         BRK
a19b 00         BRK
a19c 00         BRK
a19d 00         BRK
a19e 00         BRK
a19f 00         BRK
a1a0 00         BRK
a1a1 00         BRK
a1a2 00         BRK
a1a3 00         BRK
a1a4 00         BRK
a1a5 00         BRK
a1a6 00         BRK
a1a7 00         BRK
a1a8 00         BRK
a1a9 00         BRK
a1aa 00         BRK
a1ab 00         BRK
a1ac 00         BRK
a1ad 00         BRK
a1ae 00         BRK
a1af 00         BRK
a1b0 00         BRK
a1b1 00         BRK
a1b2 00         BRK
a1b3 00         BRK
a1b4 00         BRK
a1b5 00         BRK
a1b6 00         BRK
a1b7 00         BRK
a1b8 00         BRK
a1b9 00         BRK
a1ba 00         BRK
a1bb 00         BRK
a1bc 00         BRK
a1bd 00         BRK
a1be 00         BRK
a1bf 00         BRK
a1c0 00         BRK
a1c1 00         BRK
a1c2 00         BRK
a1c3 00         BRK
a1c4 00         BRK
a1c5 00         BRK
a1c6 00         BRK
a1c7 00         BRK
a1c8 00         BRK
a1c9 00         BRK
a1ca a9d8       LDA #$d8
a1cc 8586       STA $86
a1ce a9a1       LDA #$a1
a1d0 8587       STA $87
a1d2 a200       LDX #$00
a1d4 20         JSR
a1d5 db ff
a1d6 db 9a
a1d7 60         RTS
a1d8 f0cf       BEQ a1a9
a1da 00         BRK
a1db 50f0       BVC a1cd
a1dd 0100       ORA ($00, X)
a1df 00         BRK
a1e0 f009       BEQ a1eb
a1e2 00         BRK
a1e3 00         BRK
a1e4 f009       BEQ a1ef
a1e6 00         BRK
a1e7 00         BRK
a1e8 f009       BEQ a1f3
a1ea 40         RTI
a1eb 00         BRK
a1ec f009       BEQ a1f7
a1ee 40         RTI
a1ef 00         BRK
a1f0 f001       BEQ a1f3
a1f2 40         RTI
a1f3 00         BRK
a1f4 f000       BEQ a1f6
a1f6 00         BRK
a1f7 00         BRK
a1f8 f000       BEQ a1fa
a1fa 00         BRK
a1fb 00         BRK
a1fc f000       BEQ a1fe
a1fe 00         BRK
a1ff 00         BRK
a200 f000       BEQ a202
a202 00         BRK
a203 00         BRK
a204 f01e       BEQ a224
a206 0200       ASL #$00
a208 f01e       BEQ a228
a20a 0200       ASL #$00
a20c f01e       BEQ a22c
a20e 0200       ASL #$00
a210 f01d       BEQ a22f
a212 0200       ASL #$00
a214 f01d       BEQ a233
a216 4200       LSR #$00
a218 f01d       BEQ a237
a21a 0200       ASL #$00
a21c f01d       BEQ a23b
a21e 4200       LSR #$00
a220 f000       BEQ a222
a222 00         BRK
a223 00         BRK
a224 f000       BEQ a226
a226 00         BRK
a227 00         BRK
a228 f01e       BEQ a248
a22a 0200       ASL #$00
a22c f000       BEQ a22e
a22e 4200       LSR #$00
a230 f000       BEQ a232
a232 4200       LSR #$00
a234 f000       BEQ a236
a236 4200       LSR #$00
a238 f000       BEQ a23a
a23a 0200       ASL #$00
a23c f000       BEQ a23e
a23e 0200       ASL #$00
a240 f000       BEQ a242
a242 0200       ASL #$00
a244 f000       BEQ a246
a246 4200       LSR #$00
a248 f000       BEQ a24a
a24a 4200       LSR #$00
a24c f000       BEQ a24e
a24e 4200       LSR #$00
a250 f000       BEQ a252
a252 0200       ASL #$00
a254 f000       BEQ a256
a256 0200       ASL #$00
a258 f000       BEQ a25a
a25a 0200       ASL #$00
a25c f000       BEQ a25e
a25e 4200       LSR #$00
a260 f000       BEQ a262
a262 4200       LSR #$00
a264 f000       BEQ a266
a266 4200       LSR #$00
a268 f000       BEQ a26a
a26a 0200       ASL #$00
a26c f000       BEQ a26e
a26e 0200       ASL #$00
a270 f000       BEQ a272
a272 0200       ASL #$00
a274 f000       BEQ a276
a276 0100       ORA ($00, X)
a278 f000       BEQ a27a
a27a 0100       ORA ($00, X)
a27c f000       BEQ a27e
a27e 0100       ORA ($00, X)
a280 f000       BEQ a282
a282 0100       ORA ($00, X)
a284 f000       BEQ a286
a286 0100       ORA ($00, X)
a288 f000       BEQ a28a
a28a 0100       ORA ($00, X)
a28c f000       BEQ a28e
a28e 0100       ORA ($00, X)
a290 f000       BEQ a292
a292 0100       ORA ($00, X)
a294 f000       BEQ a296
a296 0100       ORA ($00, X)
a298 f000       BEQ a29a
a29a 0100       ORA ($00, X)
a29c f000       BEQ a29e
a29e 0100       ORA ($00, X)
a2a0 f000       BEQ a2a2
a2a2 0100       ORA ($00, X)
a2a4 f000       BEQ a2a6
a2a6 00         BRK
a2a7 50f0       BVC a299
a2a9 00         BRK
a2aa 00         BRK
a2ab 00         BRK
a2ac f000       BEQ a2ae
a2ae 00         BRK
a2af 00         BRK
a2b0 f000       BEQ a2b2
a2b2 00         BRK
a2b3 00         BRK
a2b4 f000       BEQ a2b6
a2b6 00         BRK
a2b7 00         BRK
a2b8 f000       BEQ a2ba
a2ba 00         BRK
a2bb 00         BRK
a2bc f000       BEQ a2be
a2be 00         BRK
a2bf 00         BRK
a2c0 f000       BEQ a2c2
a2c2 00         BRK
a2c3 00         BRK
a2c4 f000       BEQ a2c6
a2c6 00         BRK
a2c7 00         BRK
a2c8 f000       BEQ a2ca
a2ca 00         BRK
a2cb 00         BRK
a2cc f000       BEQ a2ce
a2ce 00         BRK
a2cf 00         BRK
a2d0 f000       BEQ a2d2
a2d2 00         BRK
a2d3 00         BRK
a2d4 f000       BEQ a2d6
a2d6 00         BRK
a2d7 00         BRK
a2d8 8c2e01     STY $012e
a2db a938       LDA #$38
a2dd 8586       STA $86
a2df a9a3       LDA #$a3
a2e1 8587       STA $87
a2e3 c020       CPY #$20
a2e5 f008       BEQ a2ef
a2e7 a969       LDA #$69
a2e9 8586       STA $86
a2eb a9a3       LDA #$a3
a2ed 8587       STA $87
a2ef a518       LDA $18
a2f1 d00d       BNE a300
a2f3 18         CLC
a2f4 a586       LDA $86
a2f6 691c       ADC #$1c
a2f8 8586       STA $86
a2fa a587       LDA $87
a2fc 6900       ADC #$00
a2fe 8587       STA $87
a300 20         JSR
a301 db f3
a302 db a3
a303 a970       LDA #$70
a305 8586       STA $86
a307 a903       LDA #$03
a309 8587       STA $87
a30b ac2e01     LDY $012e
a30e a262       LDX #$62
a310 20         JSR
a311 db 9a
a312 db a3
a313 a966       LDA #$66
a315 8586       STA $86
a317 a903       LDA #$03
a319 8587       STA $87
a31b ac2e01     LDY $012e
a31e a26d       LDX #$6d
a320 20         JSR
a321 db 9a
a322 db a3
a323 a518       LDA $18
a325 f010       BEQ a337
a327 a976       LDA #$76
a329 8586       STA $86
a32b a903       LDA #$03
a32d 8587       STA $87
a32f ac2e01     LDY $012e
a332 a277       LDX #$77
a334 20         JSR
a335 db 9a
a336 db a3
a337 60         RTS
a338 20         JSR
a339 4418       JMP $18
a33b 2e1e19     ROL $191e
a33e 2d2d2d     AND $2d2d ; Background Scroll
a341 2d1112     AND $1211
a344 1011       BPL a357
a346 2d1c0c     AND $0c1c
a349 18         CLC
a34a db 1b
a34b 0e2d2d     ASL $2d2d ; Background Scroll
a34e 2d2d2f     AND $2f2d ; Background Scroll
a351 1e19ff     ASL $ff19, X
a354 20         JSR
a355 4411       JMP $11
a357 2e1e19     ROL $191e
a35a 2d2d2d     AND $2d2d ; Background Scroll
a35d 2d1112     AND $1211
a360 1011       BPL a373
a362 2d1c0c     AND $0c1c
a365 18         CLC
a366 db 1b
a367 0eff28     ASL $28ff ; PPU Memory Data
a36a 4418       JMP $18
a36c 2e1e19     ROL $191e
a36f 2d2d2d     AND $2d2d ; Background Scroll
a372 2d1112     AND $1211
a375 1011       BPL a388
a377 2d1c0c     AND $0c1c
a37a 18         CLC
a37b db 1b
a37c 0e2d2d     ASL $2d2d ; Background Scroll
a37f 2d2d2f     AND $2f2d ; Background Scroll
a382 1e19ff     ASL $ff19, X
a385 28         PLP
a386 4411       JMP $11
a388 2e1e19     ROL $191e
a38b 2d2d2d     AND $2d2d ; Background Scroll
a38e 2d1112     AND $1211
a391 1011       BPL a3a4
a393 2d1c0c     AND $0c1c
a396 18         CLC
a397 db 1b
a398 0eff98     ASL $98ff
a39b 8d0620     STA $2006 ; PPU Memory Address
a39e 8a         STX
a39f 8d0620     STA $2006 ; PPU Memory Address
a3a2 a000       LDY #$00
a3a4 b186       LDA ($86), Y
a3a6 998203     STA $0382, Y
a3a9 c900       CMP #$00
a3ab d00a       BNE a3b7
a3ad a92d       LDA #$2d
a3af 998203     STA $0382, Y
a3b2 c8         INY
a3b3 c004       CPY #$04
a3b5 d0ed       BNE a3a4
a3b7 b186       LDA ($86), Y
a3b9 998203     STA $0382, Y
a3bc c8         INY
a3bd c006       CPY #$06
a3bf d0f6       BNE a3b7
a3c1 a200       LDX #$00
a3c3 bd8203     LDA $0382, X
a3c6 8d0720     STA $2007 ; PPU Memory Data
a3c9 e8         INX
a3ca e006       CPX #$06
a3cc d0f5       BNE a3c3
a3ce a900       LDA #$00
a3d0 8d0520     STA $2005 ; Background Scroll
a3d3 8d0520     STA $2005 ; Background Scroll
a3d6 60         RTS
a3d7 a516       LDA $16
a3d9 c9ef       CMP #$ef
a3db f015       BEQ a3f2
a3dd a90e       LDA #$0e
a3df 8d0120     STA $2001 ; PPU Control Register 2
a3e2 8515       STA $15
a3e4 e616       INC $16
a3e6 e616       INC $16
a3e8 a516       LDA $16
a3ea c9f0       CMP #$f0
a3ec 9004       BCC a3f2
a3ee a9ef       LDA #$ef
a3f0 8516       STA $16
a3f2 60         RTS
a3f3 a000       LDY #$00
a3f5 b186       LDA ($86), Y
a3f7 c9ff       CMP #$ff
a3f9 d001       BNE a3fc
a3fb 60         RTS
a3fc 8d0620     STA $2006 ; PPU Memory Address
a3ff c8         INY
a400 b186       LDA ($86), Y
a402 8d0620     STA $2006 ; PPU Memory Address
a405 c8         INY
a406 b186       LDA ($86), Y
a408 aa         LDX
a409 c8         INY
a40a b186       LDA ($86), Y
a40c 8d0720     STA $2007 ; PPU Memory Data
a40f c8         INY
a410 ca         DEC
a411 d0f7       BNE a40a
a413 a900       LDA #$00
a415 8d0520     STA $2005 ; Background Scroll
a418 8d0520     STA $2005 ; Background Scroll
a41b 4cf5a3     JMP $a3f5
a41e 98         TYA
a41f 8d0620     STA $2006 ; PPU Memory Address
a422 8a         STX
a423 8d0620     STA $2006 ; PPU Memory Address
a426 a000       LDY #$00
a428 a200       LDX #$00
a42a a92d       LDA #$2d
a42c 8d0720     STA $2007 ; PPU Memory Data
a42f e8         INX
a430 e000       CPX #$00
a432 d0f8       BNE a42c
a434 c8         INY
a435 c004       CPY #$04
a437 d0f3       BNE a42c
a439 a900       LDA #$00
a43b 8d0520     STA $2005 ; Background Scroll
a43e 8d0520     STA $2005 ; Background Scroll
a441 60         RTS
a442 a93f       LDA #$3f
a444 8d0620     STA $2006 ; PPU Memory Address
a447 a900       LDA #$00
a449 8d0620     STA $2006 ; PPU Memory Address
a44c a000       LDY #$00
a44e b94601     LDA $0146, Y
a451 8d0720     STA $2007 ; PPU Memory Data
a454 c8         INY
a455 c010       CPY #$10
a457 d0f5       BNE a44e
a459 a93f       LDA #$3f
a45b 8d0620     STA $2006 ; PPU Memory Address
a45e a900       LDA #$00
a460 8d0620     STA $2006 ; PPU Memory Address
a463 8d0620     STA $2006 ; PPU Memory Address
a466 8d0620     STA $2006 ; PPU Memory Address
a469 60         RTS
a46a a93f       LDA #$3f
a46c 8d0620     STA $2006 ; PPU Memory Address
a46f a910       LDA #$10
a471 8d0620     STA $2006 ; PPU Memory Address
a474 a000       LDY #$00
a476 b95601     LDA $0156, Y
a479 8d0720     STA $2007 ; PPU Memory Data
a47c c8         INY
a47d c010       CPY #$10
a47f d0f5       BNE a476
a481 a93f       LDA #$3f
a483 8d0620     STA $2006 ; PPU Memory Address
a486 a900       LDA #$00
a488 8d0620     STA $2006 ; PPU Memory Address
a48b 8d0620     STA $2006 ; PPU Memory Address
a48e 8d0620     STA $2006 ; PPU Memory Address
a491 60         RTS
a492 8d0620     STA $2006 ; PPU Memory Address
a495 a9c0       LDA #$c0
a497 8d0620     STA $2006 ; PPU Memory Address
a49a a000       LDY #$00
a49c b186       LDA ($86), Y
a49e 8d0720     STA $2007 ; PPU Memory Data
a4a1 c8         INY
a4a2 c040       CPY #$40
a4a4 d0f6       BNE a49c
a4a6 a900       LDA #$00
a4a8 8d0520     STA $2005 ; Background Scroll
a4ab 8d0520     STA $2005 ; Background Scroll
a4ae 60         RTS
a4af 8d0620     STA $2006 ; PPU Memory Address
a4b2 a9c0       LDA #$c0
a4b4 8d0620     STA $2006 ; PPU Memory Address
a4b7 a000       LDY #$00
a4b9 a900       LDA #$00
a4bb 8d0720     STA $2007 ; PPU Memory Data
a4be c8         INY
a4bf c040       CPY #$40
a4c1 d0f8       BNE a4bb
a4c3 a900       LDA #$00
a4c5 8d0520     STA $2005 ; Background Scroll
a4c8 8d0520     STA $2005 ; Background Scroll
a4cb 60         RTS
a4cc 2108       AND ($08, X)
a4ce 1030       BPL a500
a4d0 3132       AND ($32), Y
a4d2 db 33
a4d3 3435       BIT $35, X
a4d5 3637       ROL $37, X
a4d7 38         SEC
a4d8 393a3b     AND $3b3a, Y
a4db 3c3d3e     BIT $3e3d, X
a4de db 3f
a4df 2128       AND ($28, X)
a4e1 1040       BPL a523
a4e3 4142       EOR ($42, X)
a4e5 db 43
a4e6 4445       JMP $45
a4e8 4647       LSR $47
a4ea 48         PHA
a4eb 494a       EOR #$4a
a4ed db 4b
a4ee 4c4d4e     JMP $4e4d
a4f1 db 4f
a4f2 2148       AND ($48, X)
a4f4 1050       BPL a546
a4f6 5152       EOR ($52), Y
a4f8 db 53
a4f9 5455       JMP $55, X
a4fb 5657       LSR $57, X
a4fd 58         CLI
a4fe 595a5b     EOR $5b5a, Y
a501 5c5d5e     JMP $5e5d, X
a504 db 5f
a505 220c       ROL #$0c
a507 08         PHP
a508 012d       ORA ($2d, X)
a50a 19150a     ORA $0a15, Y
a50d 220e       ROL #$0e
a50f db 1b
a510 224c       ROL #$4c
a512 0902       ORA #$02
a514 2d1915     AND $1519
a517 0a         ASL
a518 220e       ROL #$0e
a51a db 1b
a51b db 1c
a51c 22cb       ROL #$cb
a51e 0a         ASL
a51f 60         RTS
a520 6162       ADC ($62, X)
a522 db 63
a523 6465       JMP (ABS) $65
a525 6667       ROR $67
a527 68         PLA
a528 6922       ADC #$22
a52a db eb
a52b 0a         ASL
a52c 7071       BVS a59f
a52e db 72
a52f db 73
a530 7475       JMP (ABS) $75, X
a532 7677       ROR $77, X
a534 78         SEI
a535 792324     ADC $2423, Y
a538 18         CLC
a539 28         PLP
a53a 2d1d0a     AND $0a1d
a53d db 12
a53e 1d182d     ORA $2d18, X
a541 db 0c
a542 18         CLC
a543 db 1b
a544 19181b     ORA $1b18, Y
a547 0a         ASL
a548 1d1218     ORA $1812, X
a54b db 17
a54c 2d0109     AND $0901
a54f 08         PHP
a550 0623       ASL $23
a552 6613       ROR $13
a554 0a         ASL
a555 1515       ORA $15, X
a557 2d1b12     AND $121b
a55a 1011       BPL a56d
a55c 1d1c2d     ORA $2d1c, X
a55f db 1b
a560 0e1c0e     ASL $0e1c
a563 db 1b
a564 db 1f
a565 0e0dff     ASL $ff0d
a568 28         PLP
a569 db e3
a56a db 13
a56b 1d110e     ORA $0e11, X
a56e 2d0e1b     AND $1b0e
a571 0a         ASL
a572 2d0a17     AND $170a
a575 0d2d1d     ORA $1d2d
a578 db 12
a579 160e       ASL $0e, X
a57b 2d180f     AND $0f18
a57e 2923       AND #$23
a580 161d       ASL $1d, X
a582 1112       ORA ($12), Y
a584 db 1c
a585 2d1c1d     AND $1d1c
a588 18         CLC
a589 db 1b
a58a 222d       ROL #$2d
a58c db 12
a58d db 1c
a58e 2d1e17     AND $171e
a591 db 14
a592 db 17
a593 18         CLC
a594 20         JSR
a595 db 17
a596 db 27
a597 2983       AND #$83
a599 150a       ORA $0a, X
a59b db 0f
a59c 1d0e1b     ORA $1b0e, X
a59f 2d1d11     AND $111d
a5a2 0e2d16     ASL $162d
a5a5 18         CLC
a5a6 1d110e     ORA $0e11, X
a5a9 db 1b
a5aa 2d1c11     AND $111c
a5ad db 12
a5ae 1929c3     ORA $c329, Y
a5b1 192a0a     ORA $0a2a, Y
a5b4 db 1b
a5b5 db 14
a5b6 0a         ASL
a5b7 db 17
a5b8 18         CLC
a5b9 db 12
a5ba 0d242d     ORA $2d24 ; Sprite Memory Data
a5bd 20         JSR
a5be 0a         ASL
a5bf db 1c
a5c0 2d0d0e     AND $0e0d
a5c3 db 1c
a5c4 1d1b18     ORA $181b, X
a5c7 220e       ROL #$0e
a5c9 0d252a     ORA $2a25 ; Background Scroll
a5cc db 03
a5cd db 13
a5ce 0a         ASL
a5cf 2d1c19     AND $191c
a5d2 0a         ASL
a5d3 db 0c
a5d4 0e0c1b     ASL $1b0c
a5d7 0a         ASL
a5d8 db 0f
a5d9 1d2d2a     ORA $2a2d, X
a5dc db 1f
a5dd 0a         ASL
a5de 1e1c24     ASL $241c, X
a5e1 2a         ROL
a5e2 db 43
a5e3 db 17
a5e4 db 1c
a5e5 db 0c
a5e6 db 1b
a5e7 0a         ASL
a5e8 160b       ASL $0b, X
a5ea 150e       ORA $0e, X
a5ec 0d2d0a     ORA $0a2d
a5ef 20         JSR
a5f0 0a         ASL
a5f1 222d       ROL #$2d
a5f3 db 0f
a5f4 db 1b
a5f5 18         CLC
a5f6 162d       ASL $2d, X
a5f8 db 12
a5f9 1d272a     ORA $2a27, X
a5fc db a3
a5fd 0e0b1e     ASL $1e0b
a600 1d2d18     ORA $182d, X
a603 db 17
a604 1522       ORA $22, X
a606 2d1d18     AND $181d
a609 2d0b0e     AND $0e0b
a60c 2a         ROL
a60d db e3
a60e db 17
a60f 1d1b0a     ORA $0a1b, X
a612 19190e     ORA $0e19, Y
a615 0d2d12     ORA $122d
a618 db 17
a619 2d1c19     AND $191c
a61c 0a         ASL
a61d db 0c
a61e 0e2d20     ASL $202d ; Background Scroll
a621 0a         ASL
a622 db 1b
a623 190e0d     ORA $0d0e, Y
a626 db 2b
a627 db 23
a628 100b       BPL a635
a62a 222d       ROL #$2d
a62c db 1c
a62d 18         CLC
a62e 160e       ASL $0e, X
a630 18         CLC
a631 db 17
a632 0e2727     ASL $2727 ; PPU Memory Data
a635 db 27
a636 db 27
a637 db 27
a638 db 27
a639 db ff
a63a 28         PLP
a63b db e3
a63c db 1a
a63d 0d1216     ORA $1612
a640 0e171c     ASL $1c17
a643 db 12
a644 18         CLC
a645 db 17
a646 260c       ROL $0c
a648 18         CLC
a649 db 17
a64a 1d1b18     ORA $181b, X
a64d 1515       ORA $15, X
a64f db 12
a650 db 17
a651 102d       BPL a680
a653 db 0f
a654 18         CLC
a655 db 1b
a656 1d2923     ORA $2329, X
a659 db 12
a65a 2a         ROL
a65b 0d1811     ORA $1118
a65e 242d       BIT $2d
a660 110a       ORA ($0a), Y
a662 db 1c
a663 2d1718     AND $1817
a666 20         JSR
a667 2d0b0e     AND $0e0b
a66a 0e1729     ASL $2917 ; PPU Memory Data
a66d db 63
a66e db 14
a66f 0d0e16     ORA $160e
a672 18         CLC
a673 1512       ORA $12, X
a675 db 1c
a676 110e       ORA ($0e), Y
a678 0d252d     ORA $2d25 ; Background Scroll
a67b 0a         ASL
a67c db 17
a67d 0d2d1d     ORA $1d2d
a680 db 12
a681 160e       ASL $0e, X
a683 29a3       AND #$a3
a685 191c1d     ORA $1d1c, Y
a688 0a         ASL
a689 db 1b
a68a 1d0e0d     ORA $0d0e, X
a68d 2d0f15     AND $150f
a690 18         CLC
a691 20         JSR
a692 db 12
a693 db 17
a694 102d       BPL a6c3
a696 db 1b
a697 0e1f0e     ASL $0e1f
a69a db 1b
a69b db 1c
a69c 1522       ORA $22, X
a69e db 27
a69f 2a         ROL
a6a0 db 03
a6a1 18         CLC
a6a2 2a         ROL
a6a3 db 1f
a6a4 0a         ASL
a6a5 1e1c24     ASL $241c, X
a6a8 2d160a     AND $0a16
a6ab db 17
a6ac 0a         ASL
a6ad 100e       BPL a6bd
a6af 0d2d1d     ORA $1d2d
a6b2 18         CLC
a6b3 2d0e1c     AND $1c0e
a6b6 db 0c
a6b7 0a         ASL
a6b8 190e2a     ORA $2a0e, Y
a6bb db 43
a6bc 190f1b     ORA $1b0f, Y
a6bf 18         CLC
a6c0 162d       ASL $2d, X
a6c2 1d110e     ORA $0e11, X
a6c5 2d0d12     AND $120d
a6c8 db 1c
a6c9 1d181b     ORA $1b18, X
a6cc 1d0e0d     ORA $0d0e, X
a6cf 2d1c19     AND $191c
a6d2 0a         ASL
a6d3 db 0c
a6d4 0e272a     ASL $2a27 ; PPU Memory Data
a6d7 db a3
a6d8 160b       ASL $0b, X
a6da 1e1d2d     ASL $2d1d, X
a6dd 1d110e     ORA $0e11, X
a6e0 2d1b0e     AND $0e1b
a6e3 0a         ASL
a6e4 152d       ORA $2d, X
a6e6 db 1f
a6e7 18         CLC
a6e8 220a       ROL #$0a
a6ea 100e       BPL a6fa
a6ec 2d180f     AND $0f18
a6ef 2a         ROL
a6f0 db e3
a6f1 18         CLC
a6f2 2a         ROL
a6f3 0a         ASL
a6f4 db 1b
a6f5 db 14
a6f6 0a         ASL
a6f7 db 17
a6f8 18         CLC
a6f9 db 12
a6fa 0d242d     ORA $2d24 ; Sprite Memory Data
a6fd db 12
a6fe db 17
a6ff 2d1d11     AND $111d
a702 0e2d10     ASL $102d
a705 0a         ASL
a706 150a       ORA $0a, X
a708 2122       AND ($22, X)
a70a db 2b
a70b db 23
a70c 1611       ASL $11, X
a70e 0a         ASL
a70f db 1c
a710 2d1817     AND $1718
a713 1522       ORA $22, X
a715 2d1c1d     AND $1d1c
a718 0a         ASL
a719 db 1b
a71a 1d0e0d     ORA $0d0e, X
a71d db 27
a71e db 27
a71f db 27
a720 db 27
a721 db 27
a722 db 27
a723 db ff
a724 a900       LDA #$00
a726 8d4501     STA $0145
a729 a50a       LDA $0a
a72b c910       CMP #$10
a72d d010       BNE a73f
a72f a50f       LDA $0f
a731 c900       CMP #$00
a733 f00a       BEQ a73f
a735 ad0501     LDA $0105
a738 c900       CMP #$00
a73a f004       BEQ a740
a73c ce0501     DEC $0105
a73f 60         RTS
a740 a581       LDA $81
a742 8582       STA $82
a744 a903       LDA #$03
a746 8583       STA $83
a748 a000       LDY #$00
a74a 98         TYA
a74b 48         PHA
a74c a582       LDA $82
a74e 6a         ROR
a74f 8582       STA $82
a751 905a       BCC a7ad
a753 a200       LDX #$00
a755 b93300     LDA $0033, Y
a758 8d3101     STA $0131
a75b b533       LDA $33, X
a75d 993300     STA $0033, Y
a760 ad3101     LDA $0131
a763 9533       STA $33, X
a765 e8         INX
a766 c8         INY
a767 e01a       CPX #$1a
a769 d0ea       BNE a755
a76b 20         JSR
a76c db b7
a76d db a7
a76e 20         JSR
a76f 0a         ASL
a770 a8         TAY
a771 20         JSR
a772 db 9f
a773 a8         TAY
a774 20         JSR
a775 9daf20     STA $20af, X
a778 db c7
a779 a8         TAY
a77a 20         JSR
a77b db ba
a77c db ab
a77d 20         JSR
a77e db 7f
a77f a920       LDA #$20
a781 fca920     CPX $20a9, X
a784 20         JSR
a785 db ab
a786 a545       LDA $45
a788 c900       CMP #$00
a78a f006       BEQ a792
a78c c646       DEC $46
a78e d0db       BNE a76b
a790 c645       DEC $45
a792 68         PLA
a793 48         PHA
a794 a8         TAY
a795 a200       LDX #$00
a797 b93300     LDA $0033, Y
a79a 8d3101     STA $0131
a79d b533       LDA $33, X
a79f 993300     STA $0033, Y
a7a2 ad3101     LDA $0131
a7a5 9533       STA $33, X
a7a7 e8         INX
a7a8 c8         INY
a7a9 e01a       CPX #$1a
a7ab d0ea       BNE a797
a7ad 68         PLA
a7ae 18         CLC
a7af 691a       ADC #$1a
a7b1 a8         TAY
a7b2 c683       DEC $83
a7b4 d094       BNE a74a
a7b6 60         RTS
a7b7 a545       LDA $45
a7b9 d035       BNE a7f0
a7bb a96d       LDA #$6d
a7bd 8543       STA $43
a7bf a9ac       LDA #$ac
a7c1 8544       STA $44
a7c3 18         CLC
a7c4 a548       LDA $48
a7c6 6544       ADC $44
a7c8 8544       STA $44
a7ca 18         CLC
a7cb a549       LDA $49
a7cd 0a         ASL
a7ce 0a         ASL
a7cf 0a         ASL
a7d0 0a         ASL
a7d1 6543       ADC $43
a7d3 8543       STA $43
a7d5 a544       LDA $44
a7d7 6900       ADC #$00
a7d9 8544       STA $44
a7db a000       LDY #$00
a7dd b143       LDA ($43), Y
a7df 8545       STA $45
a7e1 a900       LDA #$00
a7e3 8546       STA $46
a7e5 a002       LDY #$02
a7e7 b143       LDA ($43), Y
a7e9 8d0501     STA $0105
a7ec a904       LDA #$04
a7ee 8547       STA $47
a7f0 a546       LDA $46
a7f2 d006       BNE a7fa
a7f4 a001       LDY #$01
a7f6 b143       LDA ($43), Y
a7f8 8546       STA $46
a7fa a447       LDY $47
a7fc b143       LDA ($43), Y
a7fe 8535       STA $35
a800 c8         INY
a801 b143       LDA ($43), Y
a803 8536       STA $36
a805 e647       INC $47
a807 e647       INC $47
a809 60         RTS
a80a a900       LDA #$00
a80c 8d2e01     STA $012e
a80f 8534       STA $34
a811 8d0401     STA $0104
a814 a533       LDA $33
a816 2901       AND #$01
a818 d021       BNE a83b
a81a 38         SEC
a81b a537       LDA $37
a81d e535       SBC $35
a81f 8537       STA $37
a821 c910       CMP #$10
a823 b004       BCS a829
a825 a910       LDA #$10
a827 8537       STA $37
a829 a537       LDA $37
a82b c910       CMP #$10
a82d d013       BNE a842
a82f a534       LDA $34
a831 0901       ORA #$01
a833 8d0401     STA $0104
a836 8534       STA $34
a838 4c42a8     JMP $a842
a83b 18         CLC
a83c a537       LDA $37
a83e 6535       ADC $35
a840 8537       STA $37
a842 a533       LDA $33
a844 2902       AND #$02
a846 f01e       BEQ a866
a848 38         SEC
a849 a538       LDA $38
a84b e536       SBC $36
a84d 8538       STA $38
a84f c910       CMP #$10
a851 b004       BCS a857
a853 a910       LDA #$10
a855 8538       STA $38
a857 a538       LDA $38
a859 c910       CMP #$10
a85b d006       BNE a863
a85d a534       LDA $34
a85f 0902       ORA #$02
a861 8534       STA $34
a863 4c81a8     JMP $a881
a866 18         CLC
a867 a538       LDA $38
a869 6536       ADC $36
a86b 8538       STA $38
a86d c9bc       CMP #$bc
a86f 9004       BCC a875
a871 a9bc       LDA #$bc
a873 8538       STA $38
a875 a538       LDA $38
a877 c9bc       CMP #$bc
a879 d006       BNE a881
a87b a534       LDA $34
a87d 0902       ORA #$02
a87f 8534       STA $34
a881 a534       LDA $34
a883 d019       BNE a89e
a885 a533       LDA $33
a887 2901       AND #$01
a889 d013       BNE a89e
a88b ad2e01     LDA $012e
a88e c901       CMP #$01
a890 f00c       BEQ a89e
a892 a537       LDA $37
a894 c9cd       CMP #$cd
a896 9006       BCC a89e
a898 ee2e01     INC $012e
a89b 4c14a8     JMP $a814
a89e 60         RTS
a89f 38         SEC
a8a0 a537       LDA $37
a8a2 e910       SBC #$10
a8a4 4a         LSR
a8a5 4a         LSR
a8a6 4a         LSR
a8a7 8539       STA $39
a8a9 38         SEC
a8aa a537       LDA $37
a8ac e910       SBC #$10
a8ae 2907       AND #$07
a8b0 853a       STA $3a
a8b2 38         SEC
a8b3 a538       LDA $38
a8b5 e910       SBC #$10
a8b7 4a         LSR
a8b8 4a         LSR
a8b9 4a         LSR
a8ba 4a         LSR
a8bb 853b       STA $3b
a8bd 38         SEC
a8be a538       LDA $38
a8c0 e910       SBC #$10
a8c2 290f       AND #$0f
a8c4 853c       STA $3c
a8c6 60         RTS
a8c7 a900       LDA #$00
a8c9 8d1201     STA $0112
a8cc a533       LDA $33
a8ce 2901       AND #$01
a8d0 f051       BEQ a923
a8d2 18         CLC
a8d3 a537       LDA $37
a8d5 6904       ADC #$04
a8d7 cd1401     CMP $0114
a8da 9047       BCC a923
a8dc 18         CLC
a8dd ad1401     LDA $0114
a8e0 6903       ADC #$03
a8e2 c537       CMP $37
a8e4 903d       BCC a923
a8e6 18         CLC
a8e7 a538       LDA $38
a8e9 6904       ADC #$04
a8eb cd1a01     CMP $011a
a8ee 9033       BCC a923
a8f0 a200       LDX #$00
a8f2 a538       LDA $38
a8f4 cd1a01     CMP $011a
a8f7 902b       BCC a924
a8f9 a202       LDX #$02
a8fb cd1b01     CMP $011b
a8fe 9024       BCC a924
a900 a204       LDX #$04
a902 18         CLC
a903 6901       ADC #$01
a905 cd1d01     CMP $011d
a908 901a       BCC a924
a90a a206       LDX #$06
a90c a538       LDA $38
a90e cd1f01     CMP $011f
a911 9011       BCC a924
a913 a208       LDX #$08
a915 38         SEC
a916 ed1f01     SBC $011f
a919 c905       CMP #$05
a91b 9007       BCC a924
a91d a20a       LDX #$0a
a91f c908       CMP #$08
a921 9001       BCC a924
a923 60         RTS
a924 bd73a9     LDA $a973, X
a927 8533       STA $33
a929 bd74a9     LDA $a974, X
a92c 8548       STA $48
a92e ad0001     LDA $0100
a931 8549       STA $49
a933 ad0101     LDA $0101
a936 854a       STA $4a
a938 a900       LDA #$00
a93a 8d0501     STA $0105
a93d 8545       STA $45
a93f a901       LDA #$01
a941 8d1201     STA $0112
a944 a915       LDA #$15
a946 8d2601     STA $0126
a949 a918       LDA #$18
a94b 8d2701     STA $0127
a94e ad2801     LDA $0128
a951 c900       CMP #$00
a953 f013       BEQ a968
a955 38         SEC
a956 ad1401     LDA $0114
a959 e904       SBC #$04
a95b 8537       STA $37
a95d ad0e01     LDA $010e
a960 d010       BNE a972
a962 a904       LDA #$04
a964 20         JSR
a965 c6f3       DEC $f3
a967 60         RTS
a968 ad0e01     LDA $010e
a96b d005       BNE a972
a96d a901       LDA #$01
a96f 20         JSR
a970 c6f3       DEC $f3
a972 60         RTS
a973 0202       ASL #$02
a975 0201       ASL #$01
a977 0200       ASL #$00
a979 00         BRK
a97a 00         BRK
a97b 00         BRK
a97c 0100       ORA ($00, X)
a97e 02ad       ASL #$ad
a980 db 12
a981 01c9       ORA ($c9, X)
a983 00         BRK
a984 f001       BEQ a987
a986 60         RTS
a987 ad0401     LDA $0104
a98a c900       CMP #$00
a98c f038       BEQ a9c6
a98e a61a       LDX $1a
a990 bdef99     LDA $99ef, X
a993 c900       CMP #$00
a995 f028       BEQ a9bf
a997 cd0001     CMP $0100
a99a f023       BEQ a9bf
a99c 9021       BCC a9bf
a99e 8d0001     STA $0100
a9a1 8d0101     STA $0101
a9a4 8549       STA $49
a9a6 8563       STA $63
a9a8 857d       STA $7d
a9aa 854a       STA $4a
a9ac 8564       STA $64
a9ae 857e       STA $7e
a9b0 aa         LDX
a9b1 bd119a     LDA $9a11, X
a9b4 8d0201     STA $0102
a9b7 a900       LDA #$00
a9b9 8545       STA $45
a9bb 855f       STA $5f
a9bd 8579       STA $79
a9bf a533       LDA $33
a9c1 4534       EOR $34
a9c3 8533       STA $33
a9c5 60         RTS
a9c6 a534       LDA $34
a9c8 c900       CMP #$00
a9ca f02c       BEQ a9f8
a9cc a900       LDA #$00
a9ce 8545       STA $45
a9d0 a533       LDA $33
a9d2 4534       EOR $34
a9d4 8533       STA $33
a9d6 2901       AND #$01
a9d8 d01e       BNE a9f8
a9da ad0001     LDA $0100
a9dd c549       CMP $49
a9df f007       BEQ a9e8
a9e1 8549       STA $49
a9e3 854a       STA $4a
a9e5 4cf1a9     JMP $a9f1
a9e8 ad0101     LDA $0101
a9eb c54a       CMP $4a
a9ed f009       BEQ a9f8
a9ef 854a       STA $4a
a9f1 a448       LDY $48
a9f3 b9f9a9     LDA $a9f9, Y
a9f6 8548       STA $48
a9f8 60         RTS
a9f9 0100       ORA ($00, X)
a9fb 01ad       ORA ($ad, X)
a9fd db 0c
a9fe 018d       ORA ($8d, X)
aa00 2e01ad     ROL $ad01
aa03 0d018d     ORA $8d01
aa06 db 2f
aa07 01ad       ORA ($ad, X)
aa09 db 07
aa0a 01c9       ORA ($c9, X)
aa0c 00         BRK
aa0d d001       BNE aa10
aa0f 60         RTS
aa10 98         TYA
aa11 48         PHA
aa12 ee0201     INC $0102
aa15 a2ff       LDX #$ff
aa17 ad0201     LDA $0102
aa1a e8         INX
aa1b dd119a     CMP $9a11, X
aa1e f003       BEQ aa23
aa20 b0f8       BCS aa1a
aa22 ca         DEC
aa23 e000       CPX #$00
aa25 f00d       BEQ aa34
aa27 8e0101     STX $0101
aa2a ad0001     LDA $0100
aa2d c90f       CMP #$0f
aa2f f003       BEQ aa34
aa31 8e0001     STX $0100
aa34 ad0701     LDA $0107
aa37 c908       CMP #$08
aa39 d005       BNE aa40
aa3b a000       LDY #$00
aa3d 4c64aa     JMP $aa64
aa40 c904       CMP #$04
aa42 d008       BNE aa4c
aa44 a001       LDY #$01
aa46 ee2f01     INC $012f
aa49 4c64aa     JMP $aa64
aa4c c902       CMP #$02
aa4e d008       BNE aa58
aa50 a00b       LDY #$0b
aa52 ee2e01     INC $012e
aa55 4c64aa     JMP $aa64
aa58 c901       CMP #$01
aa5a d0d8       BNE aa34
aa5c a00c       LDY #$0c
aa5e ee2e01     INC $012e
aa61 ee2f01     INC $012f
aa64 a9f0       LDA #$f0
aa66 8d3301     STA $0133
aa69 b141       LDA ($41), Y
aa6b c9f0       CMP #$f0
aa6d f014       BEQ aa83
aa6f b141       LDA ($41), Y
aa71 38         SEC
aa72 e901       SBC #$01
aa74 9141       STA ($41), Y
aa76 2907       AND #$07
aa78 d009       BNE aa83
aa7a b141       LDA ($41), Y
aa7c 8d3301     STA $0133
aa7f a900       LDA #$00
aa81 9141       STA ($41), Y
aa83 adb006     LDA $06b0
aa86 8d3101     STA $0131
aa89 a900       LDA #$00
aa8b 8d3201     STA $0132
aa8e a920       LDA #$20
aa90 8586       STA $86
aa92 a942       LDA #$42
aa94 8587       STA $87
aa96 ae2e01     LDX $012e
aa99 e000       CPX #$00
aa9b f01c       BEQ aab9
aa9d 18         CLC
aa9e ad3201     LDA $0132
aaa1 6910       ADC #$10
aaa3 2930       AND #$30
aaa5 8d3201     STA $0132
aaa8 18         CLC
aaa9 a587       LDA $87
aaab 6920       ADC #$20
aaad 8587       STA $87
aaaf a586       LDA $86
aab1 6900       ADC #$00
aab3 8586       STA $86
aab5 ca         DEC
aab6 4c99aa     JMP $aa99
aab9 ad2f01     LDA $012f
aabc 0a         ASL
aabd 18         CLC
aabe 6587       ADC $87
aac0 8587       STA $87
aac2 a586       LDA $86
aac4 6900       ADC #$00
aac6 8586       STA $86
aac8 ad2f01     LDA $012f
aacb 2901       AND #$01
aacd 0a         ASL
aace 18         CLC
aacf 6d3201     ADC $0132
aad2 6d3101     ADC $0131
aad5 8d3101     STA $0131
aad8 ad4501     LDA $0145
aadb 0a         ASL
aadc 18         CLC
aadd 6d4501     ADC $0145
aae0 aa         LDX
aae1 a586       LDA $86
aae3 9d9806     STA $0698, X
aae6 a587       LDA $87
aae8 9d9906     STA $0699, X
aaeb ad3101     LDA $0131
aaee 9d9a06     STA $069a, X
aaf1 ad3301     LDA $0133
aaf4 c9f0       CMP #$f0
aaf6 d005       BNE aafd
aaf8 a900       LDA #$00
aafa 9d9a06     STA $069a, X
aafd ad4501     LDA $0145
ab00 0a         ASL
ab01 18         CLC
ab02 6d4501     ADC $0145
ab05 aa         LDX
ab06 ad2e01     LDA $012e
ab09 9d8006     STA $0680, X
ab0c e8         INX
ab0d ad2f01     LDA $012f
ab10 9d8006     STA $0680, X
ab13 e8         INX
ab14 ad3301     LDA $0133
ab17 9d8006     STA $0680, X
ab1a ee4501     INC $0145
ab1d 68         PLA
ab1e a8         TAY
ab1f 60         RTS
ab20 a537       LDA $37
ab22 c9f0       CMP #$f0
ab24 901f       BCC ab45
ab26 a583       LDA $83
ab28 c903       CMP #$03
ab2a d002       BNE ab2e
ab2c a201       LDX #$01
ab2e c902       CMP #$02
ab30 d002       BNE ab34
ab32 a202       LDX #$02
ab34 c901       CMP #$01
ab36 d002       BNE ab3a
ab38 a204       LDX #$04
ab3a 8a         STX
ab3b 49ff       EOR #$ff
ab3d 2581       AND $81
ab3f 8581       STA $81
ab41 a900       LDA #$00
ab43 8545       STA $45
ab45 60         RTS
ab46 98         TYA
ab47 48         PHA
ab48 a584       LDA $84
ab4a 8541       STA $41
ab4c a585       LDA $85
ab4e 8542       STA $42
ab50 c000       CPY #$00
ab52 f012       BEQ ab66
ab54 18         CLC
ab55 a541       LDA $41
ab57 6d0b01     ADC $010b
ab5a 8541       STA $41
ab5c a542       LDA $42
ab5e 6900       ADC #$00
ab60 8542       STA $42
ab62 88         DEY
ab63 4c50ab     JMP $ab50
ab66 18         CLC
ab67 8a         STX
ab68 6541       ADC $41
ab6a 8541       STA $41
ab6c a900       LDA #$00
ab6e 6542       ADC $42
ab70 8542       STA $42
ab72 a900       LDA #$00
ab74 8d0601     STA $0106
ab77 a000       LDY #$00
ab79 b141       LDA ($41), Y
ab7b c900       CMP #$00
ab7d f008       BEQ ab87
ab7f ad0601     LDA $0106
ab82 0908       ORA #$08
ab84 8d0601     STA $0106
ab87 a001       LDY #$01
ab89 b141       LDA ($41), Y
ab8b c900       CMP #$00
ab8d f008       BEQ ab97
ab8f ad0601     LDA $0106
ab92 0904       ORA #$04
ab94 8d0601     STA $0106
ab97 a00b       LDY #$0b
ab99 b141       LDA ($41), Y
ab9b c900       CMP #$00
ab9d f008       BEQ aba7
ab9f ad0601     LDA $0106
aba2 0902       ORA #$02
aba4 8d0601     STA $0106
aba7 a00c       LDY #$0c
aba9 b141       LDA ($41), Y
abab c900       CMP #$00
abad f008       BEQ abb7
abaf ad0601     LDA $0106
abb2 0901       ORA #$01
abb4 8d0601     STA $0106
abb7 68         PLA
abb8 a8         TAY
abb9 60         RTS
abba a200       LDX #$00
abbc a534       LDA $34
abbe f001       BEQ abc1
abc0 60         RTS
abc1 b595       LDA $95, X
abc3 f03e       BEQ ac03
abc5 b59b       LDA $9b, X
abc7 d03a       BNE ac03
abc9 b5ae       LDA $ae, X
abcb c9e0       CMP #$e0
abcd b034       BCS ac03
abcf a538       LDA $38
abd1 d5b7       CMP $b7, X
abd3 902e       BCC ac03
abd5 18         CLC
abd6 b5b7       LDA $b7, X
abd8 690c       ADC #$0c
abda c538       CMP $38
abdc 9025       BCC ac03
abde a537       LDA $37
abe0 d5ae       CMP $ae, X
abe2 901f       BCC ac03
abe4 18         CLC
abe5 b5ae       LDA $ae, X
abe7 690c       ADC #$0c
abe9 c537       CMP $37
abeb 9016       BCC ac03
abed a9b3       LDA #$b3
abef 8588       STA $88
abf1 a98e       LDA #$8e
abf3 8589       STA $89
abf5 20         JSR
abf6 98         TYA
abf7 90a9       BCC aba2
abf9 00         BRK
abfa 9595       STA $95, X
abfc a901       LDA #$01
abfe 9598       STA $98, X
ac00 20         JSR
ac01 09ac       ORA #$ac
ac03 e8         INX
ac04 e003       CPX #$03
ac06 d0b9       BNE abc1
ac08 60         RTS
ac09 a533       LDA $33
ac0b c900       CMP #$00
ac0d d013       BNE ac22
ac0f 18         CLC
ac10 b5ae       LDA $ae, X
ac12 6908       ADC #$08
ac14 c537       CMP $37
ac16 9005       BCC ac1d
ac18 a902       LDA #$02
ac1a 8534       STA $34
ac1c 60         RTS
ac1d a901       LDA #$01
ac1f 8534       STA $34
ac21 60         RTS
ac22 a533       LDA $33
ac24 c902       CMP #$02
ac26 d013       BNE ac3b
ac28 18         CLC
ac29 b5ae       LDA $ae, X
ac2b 6908       ADC #$08
ac2d c537       CMP $37
ac2f 9005       BCC ac36
ac31 a902       LDA #$02
ac33 8534       STA $34
ac35 60         RTS
ac36 a901       LDA #$01
ac38 8534       STA $34
ac3a 60         RTS
ac3b a533       LDA $33
ac3d c901       CMP #$01
ac3f d013       BNE ac54
ac41 18         CLC
ac42 b5ae       LDA $ae, X
ac44 6908       ADC #$08
ac46 c537       CMP $37
ac48 9005       BCC ac4f
ac4a a901       LDA #$01
ac4c 8534       STA $34
ac4e 60         RTS
ac4f a902       LDA #$02
ac51 8534       STA $34
ac53 60         RTS
ac54 a533       LDA $33
ac56 c903       CMP #$03
ac58 d012       BNE ac6c
ac5a 18         CLC
ac5b b5ae       LDA $ae, X
ac5d 6908       ADC #$08
ac5f c537       CMP $37
ac61 9005       BCC ac68
ac63 a901       LDA #$01
ac65 8534       STA $34
ac67 60         RTS
ac68 a902       LDA #$02
ac6a 8534       STA $34
ac6c 60         RTS
ac6d 0101       ORA ($01, X)
ac6f 0500       ORA $00
ac71 0201       ASL #$01
ac73 00         BRK
ac74 00         BRK
ac75 00         BRK
ac76 00         BRK
ac77 00         BRK
ac78 00         BRK
ac79 00         BRK
ac7a 00         BRK
ac7b 00         BRK
ac7c 00         BRK
ac7d 0101       ORA ($01, X)
ac7f db 04
ac80 00         BRK
ac81 0201       ASL #$01
ac83 00         BRK
ac84 00         BRK
ac85 00         BRK
ac86 00         BRK
ac87 00         BRK
ac88 00         BRK
ac89 00         BRK
ac8a 00         BRK
ac8b 00         BRK
ac8c 00         BRK
ac8d 0101       ORA ($01, X)
ac8f db 03
ac90 00         BRK
ac91 0201       ASL #$01
ac93 00         BRK
ac94 00         BRK
ac95 00         BRK
ac96 00         BRK
ac97 00         BRK
ac98 00         BRK
ac99 00         BRK
ac9a 00         BRK
ac9b 00         BRK
ac9c 00         BRK
ac9d 0101       ORA ($01, X)
ac9f 0200       ASL #$00
aca1 0201       ASL #$01
aca3 00         BRK
aca4 00         BRK
aca5 00         BRK
aca6 00         BRK
aca7 00         BRK
aca8 00         BRK
aca9 00         BRK
acaa 00         BRK
acab 00         BRK
acac 00         BRK
acad 0101       ORA ($01, X)
acaf 0100       ORA ($00, X)
acb1 0201       ASL #$01
acb3 00         BRK
acb4 00         BRK
acb5 00         BRK
acb6 00         BRK
acb7 00         BRK
acb8 00         BRK
acb9 00         BRK
acba 00         BRK
acbb 00         BRK
acbc 00         BRK
acbd 0201       ASL #$01
acbf 00         BRK
acc0 00         BRK
acc1 0201       ASL #$01
acc3 0100       ORA ($00, X)
acc5 00         BRK
acc6 00         BRK
acc7 00         BRK
acc8 00         BRK
acc9 00         BRK
acca 00         BRK
accb 00         BRK
accc 00         BRK
accd 0101       ORA ($01, X)
accf 00         BRK
acd0 00         BRK
acd1 0201       ASL #$01
acd3 00         BRK
acd4 00         BRK
acd5 00         BRK
acd6 00         BRK
acd7 00         BRK
acd8 00         BRK
acd9 00         BRK
acda 00         BRK
acdb 00         BRK
acdc 00         BRK
acdd db 04
acde 0100       ORA ($00, X)
ace0 00         BRK
ace1 0201       ASL #$01
ace3 0201       ASL #$01
ace5 db 03
ace6 0103       ORA ($03, X)
ace8 0200       ASL #$00
acea 00         BRK
aceb 00         BRK
acec 00         BRK
aced 0201       ASL #$01
acef 00         BRK
acf0 00         BRK
acf1 db 03
acf2 0103       ORA ($03, X)
acf4 0200       ASL #$00
acf6 00         BRK
acf7 00         BRK
acf8 00         BRK
acf9 00         BRK
acfa 00         BRK
acfb 00         BRK
acfc 00         BRK
acfd 0102       ORA ($02, X)
acff 00         BRK
ad00 00         BRK
ad01 0201       ASL #$01
ad03 0201       ASL #$01
ad05 00         BRK
ad06 00         BRK
ad07 00         BRK
ad08 00         BRK
ad09 00         BRK
ad0a 00         BRK
ad0b 00         BRK
ad0c 00         BRK
ad0d 0202       ASL #$02
ad0f 00         BRK
ad10 00         BRK
ad11 0201       ASL #$01
ad13 0201       ASL #$01
ad15 0201       ASL #$01
ad17 db 03
ad18 0100       ORA ($00, X)
ad1a 00         BRK
ad1b 00         BRK
ad1c 00         BRK
ad1d 0202       ASL #$02
ad1f 00         BRK
ad20 00         BRK
ad21 0201       ASL #$01
ad23 0201       ASL #$01
ad25 db 03
ad26 0103       ORA ($03, X)
ad28 0200       ASL #$00
ad2a 00         BRK
ad2b 00         BRK
ad2c 00         BRK
ad2d 0202       ASL #$02
ad2f 00         BRK
ad30 00         BRK
ad31 db 03
ad32 0103       ORA ($03, X)
ad34 0202       ASL #$02
ad36 0103       ORA ($03, X)
ad38 0200       ASL #$00
ad3a 00         BRK
ad3b 00         BRK
ad3c 00         BRK
ad3d 0103       ORA ($03, X)
ad3f 00         BRK
ad40 00         BRK
ad41 0201       ASL #$01
ad43 0201       ASL #$01
ad45 0201       ASL #$01
ad47 00         BRK
ad48 00         BRK
ad49 00         BRK
ad4a 00         BRK
ad4b 00         BRK
ad4c 00         BRK
ad4d 0203       ASL #$03
ad4f 00         BRK
ad50 00         BRK
ad51 0201       ASL #$01
ad53 db 03
ad54 0103       ORA ($03, X)
ad56 0202       ASL #$02
ad58 0102       ORA ($02, X)
ad5a 0102       ORA ($02, X)
ad5c 0102       ORA ($02, X)
ad5e db 03
ad5f 00         BRK
ad60 00         BRK
ad61 0201       ASL #$01
ad63 db 03
ad64 0103       ORA ($03, X)
ad66 0202       ASL #$02
ad68 0102       ORA ($02, X)
ad6a 0102       ORA ($02, X)
ad6c 0101       ORA ($01, X)
ad6e 0105       ORA ($05, X)
ad70 00         BRK
ad71 0101       ORA ($01, X)
ad73 00         BRK
ad74 00         BRK
ad75 00         BRK
ad76 00         BRK
ad77 00         BRK
ad78 00         BRK
ad79 00         BRK
ad7a 00         BRK
ad7b 00         BRK
ad7c 00         BRK
ad7d 0101       ORA ($01, X)
ad7f db 04
ad80 00         BRK
ad81 0101       ORA ($01, X)
ad83 00         BRK
ad84 00         BRK
ad85 00         BRK
ad86 00         BRK
ad87 00         BRK
ad88 00         BRK
ad89 00         BRK
ad8a 00         BRK
ad8b 00         BRK
ad8c 00         BRK
ad8d 0101       ORA ($01, X)
ad8f db 03
ad90 00         BRK
ad91 0101       ORA ($01, X)
ad93 00         BRK
ad94 00         BRK
ad95 00         BRK
ad96 00         BRK
ad97 00         BRK
ad98 00         BRK
ad99 00         BRK
ad9a 00         BRK
ad9b 00         BRK
ad9c 00         BRK
ad9d 0101       ORA ($01, X)
ad9f 0200       ASL #$00
ada1 0101       ORA ($01, X)
ada3 00         BRK
ada4 00         BRK
ada5 00         BRK
ada6 00         BRK
ada7 00         BRK
ada8 00         BRK
ada9 00         BRK
adaa 00         BRK
adab 00         BRK
adac 00         BRK
adad 0101       ORA ($01, X)
adaf 0100       ORA ($00, X)
adb1 0101       ORA ($01, X)
adb3 00         BRK
adb4 00         BRK
adb5 00         BRK
adb6 00         BRK
adb7 00         BRK
adb8 00         BRK
adb9 00         BRK
adba 00         BRK
adbb 00         BRK
adbc 00         BRK
adbd 0101       ORA ($01, X)
adbf 00         BRK
adc0 00         BRK
adc1 0101       ORA ($01, X)
adc3 00         BRK
adc4 00         BRK
adc5 00         BRK
adc6 00         BRK
adc7 00         BRK
adc8 00         BRK
adc9 00         BRK
adca 00         BRK
adcb 00         BRK
adcc 00         BRK
adcd 0201       ASL #$01
adcf 00         BRK
add0 00         BRK
add1 0101       ORA ($01, X)
add3 0202       ASL #$02
add5 00         BRK
add6 00         BRK
add7 00         BRK
add8 00         BRK
add9 00         BRK
adda 00         BRK
addb 00         BRK
addc 00         BRK
addd 0101       ORA ($01, X)
addf 00         BRK
ade0 00         BRK
ade1 0202       ASL #$02
ade3 00         BRK
ade4 00         BRK
ade5 00         BRK
ade6 00         BRK
ade7 00         BRK
ade8 00         BRK
ade9 00         BRK
adea 00         BRK
adeb 00         BRK
adec 00         BRK
aded 0201       ASL #$01
adef 00         BRK
adf0 00         BRK
adf1 0202       ASL #$02
adf3 db 03
adf4 db 03
adf5 00         BRK
adf6 00         BRK
adf7 00         BRK
adf8 00         BRK
adf9 00         BRK
adfa 00         BRK
adfb 00         BRK
adfc 00         BRK
adfd 0101       ORA ($01, X)
adff 00         BRK
ae00 00         BRK
ae01 db 03
ae02 db 03
ae03 00         BRK
ae04 00         BRK
ae05 00         BRK
ae06 00         BRK
ae07 00         BRK
ae08 00         BRK
ae09 00         BRK
ae0a 00         BRK
ae0b 00         BRK
ae0c 00         BRK
ae0d 0202       ASL #$02
ae0f 00         BRK
ae10 00         BRK
ae11 db 03
ae12 db 03
ae13 00         BRK
ae14 00         BRK
ae15 0202       ASL #$02
ae17 0202       ASL #$02
ae19 00         BRK
ae1a 00         BRK
ae1b 00         BRK
ae1c 00         BRK
ae1d 0102       ORA ($02, X)
ae1f 00         BRK
ae20 00         BRK
ae21 0202       ASL #$02
ae23 0202       ASL #$02
ae25 00         BRK
ae26 00         BRK
ae27 00         BRK
ae28 00         BRK
ae29 00         BRK
ae2a 00         BRK
ae2b 00         BRK
ae2c 00         BRK
ae2d 0202       ASL #$02
ae2f 00         BRK
ae30 00         BRK
ae31 0202       ASL #$02
ae33 0202       ASL #$02
ae35 0202       ASL #$02
ae37 db 03
ae38 db 03
ae39 00         BRK
ae3a 00         BRK
ae3b 00         BRK
ae3c 00         BRK
ae3d 0102       ORA ($02, X)
ae3f 00         BRK
ae40 00         BRK
ae41 0202       ASL #$02
ae43 db 03
ae44 db 03
ae45 00         BRK
ae46 00         BRK
ae47 00         BRK
ae48 00         BRK
ae49 00         BRK
ae4a 00         BRK
ae4b 00         BRK
ae4c 00         BRK
ae4d 0202       ASL #$02
ae4f 00         BRK
ae50 00         BRK
ae51 0202       ASL #$02
ae53 db 03
ae54 db 03
ae55 db 03
ae56 db 03
ae57 db 03
ae58 db 03
ae59 00         BRK
ae5a 00         BRK
ae5b 00         BRK
ae5c 00         BRK
ae5d 0202       ASL #$02
ae5f 00         BRK
ae60 00         BRK
ae61 0202       ASL #$02
ae63 db 03
ae64 db 03
ae65 db 03
ae66 db 03
ae67 db 03
ae68 db 03
ae69 00         BRK
ae6a 00         BRK
ae6b 00         BRK
ae6c 00         BRK
ae6d 0101       ORA ($01, X)
ae6f 0500       ORA $00
ae71 0102       ORA ($02, X)
ae73 00         BRK
ae74 00         BRK
ae75 00         BRK
ae76 00         BRK
ae77 00         BRK
ae78 00         BRK
ae79 00         BRK
ae7a 00         BRK
ae7b 00         BRK
ae7c 00         BRK
ae7d 0101       ORA ($01, X)
ae7f db 04
ae80 00         BRK
ae81 0102       ORA ($02, X)
ae83 00         BRK
ae84 00         BRK
ae85 00         BRK
ae86 00         BRK
ae87 00         BRK
ae88 00         BRK
ae89 00         BRK
ae8a 00         BRK
ae8b 00         BRK
ae8c 00         BRK
ae8d 0101       ORA ($01, X)
ae8f db 03
ae90 00         BRK
ae91 0102       ORA ($02, X)
ae93 00         BRK
ae94 00         BRK
ae95 00         BRK
ae96 00         BRK
ae97 00         BRK
ae98 00         BRK
ae99 00         BRK
ae9a 00         BRK
ae9b 00         BRK
ae9c 00         BRK
ae9d 0101       ORA ($01, X)
ae9f 0200       ASL #$00
aea1 0102       ORA ($02, X)
aea3 00         BRK
aea4 00         BRK
aea5 00         BRK
aea6 00         BRK
aea7 00         BRK
aea8 00         BRK
aea9 00         BRK
aeaa 00         BRK
aeab 00         BRK
aeac 00         BRK
aead 0101       ORA ($01, X)
aeaf 0100       ORA ($00, X)
aeb1 0102       ORA ($02, X)
aeb3 00         BRK
aeb4 00         BRK
aeb5 00         BRK
aeb6 00         BRK
aeb7 00         BRK
aeb8 00         BRK
aeb9 00         BRK
aeba 00         BRK
aebb 00         BRK
aebc 00         BRK
aebd 0201       ASL #$01
aebf 00         BRK
aec0 00         BRK
aec1 0102       ORA ($02, X)
aec3 00         BRK
aec4 0100       ORA ($00, X)
aec6 00         BRK
aec7 00         BRK
aec8 00         BRK
aec9 00         BRK
aeca 00         BRK
aecb 00         BRK
aecc 00         BRK
aecd 0101       ORA ($01, X)
aecf 00         BRK
aed0 00         BRK
aed1 0102       ORA ($02, X)
aed3 00         BRK
aed4 00         BRK
aed5 00         BRK
aed6 00         BRK
aed7 00         BRK
aed8 00         BRK
aed9 00         BRK
aeda 00         BRK
aedb 00         BRK
aedc 00         BRK
aedd db 04
aede 0100       ORA ($00, X)
aee0 00         BRK
aee1 0102       ORA ($02, X)
aee3 0102       ORA ($02, X)
aee5 0103       ORA ($03, X)
aee7 0203       ASL #$03
aee9 00         BRK
aeea 00         BRK
aeeb 00         BRK
aeec 00         BRK
aeed 0201       ASL #$01
aeef 00         BRK
aef0 00         BRK
aef1 0103       ORA ($03, X)
aef3 0203       ASL #$03
aef5 00         BRK
aef6 00         BRK
aef7 00         BRK
aef8 00         BRK
aef9 00         BRK
aefa 00         BRK
aefb 00         BRK
aefc 00         BRK
aefd 0102       ORA ($02, X)
aeff 00         BRK
af00 00         BRK
af01 0102       ORA ($02, X)
af03 0102       ORA ($02, X)
af05 00         BRK
af06 00         BRK
af07 00         BRK
af08 00         BRK
af09 00         BRK
af0a 00         BRK
af0b 00         BRK
af0c 00         BRK
af0d 0202       ASL #$02
af0f 00         BRK
af10 00         BRK
af11 0102       ORA ($02, X)
af13 0102       ORA ($02, X)
af15 0102       ORA ($02, X)
af17 0103       ORA ($03, X)
af19 00         BRK
af1a 00         BRK
af1b 00         BRK
af1c 00         BRK
af1d 0202       ASL #$02
af1f 00         BRK
af20 00         BRK
af21 0102       ORA ($02, X)
af23 0102       ORA ($02, X)
af25 0103       ORA ($03, X)
af27 0203       ASL #$03
af29 00         BRK
af2a 00         BRK
af2b 00         BRK
af2c 00         BRK
af2d 0202       ASL #$02
af2f 00         BRK
af30 00         BRK
af31 0103       ORA ($03, X)
af33 0203       ASL #$03
af35 0102       ORA ($02, X)
af37 0203       ASL #$03
af39 00         BRK
af3a 00         BRK
af3b 00         BRK
af3c 00         BRK
af3d 0103       ORA ($03, X)
af3f 00         BRK
af40 00         BRK
af41 0102       ORA ($02, X)
af43 0102       ORA ($02, X)
af45 0102       ORA ($02, X)
af47 00         BRK
af48 00         BRK
af49 00         BRK
af4a 00         BRK
af4b 00         BRK
af4c 00         BRK
af4d 0203       ASL #$03
af4f 00         BRK
af50 00         BRK
af51 0102       ORA ($02, X)
af53 0103       ORA ($03, X)
af55 0203       ASL #$03
af57 0102       ORA ($02, X)
af59 0102       ORA ($02, X)
af5b 0102       ORA ($02, X)
af5d 0203       ASL #$03
af5f 00         BRK
af60 00         BRK
af61 0102       ORA ($02, X)
af63 0103       ORA ($03, X)
af65 0203       ASL #$03
af67 0102       ORA ($02, X)
af69 0102       ORA ($02, X)
af6b 0102       ORA ($02, X)
af6d 0104       ORA ($04, X)
af6f 00         BRK
af70 00         BRK
af71 0201       ASL #$01
af73 0201       ASL #$01
af75 0201       ASL #$01
af77 0201       ASL #$01
af79 00         BRK
af7a 00         BRK
af7b 00         BRK
af7c 00         BRK
af7d 0102       ORA ($02, X)
af7f 00         BRK
af80 00         BRK
af81 db 03
af82 db 03
af83 db 03
af84 db 03
af85 00         BRK
af86 00         BRK
af87 00         BRK
af88 00         BRK
af89 00         BRK
af8a 00         BRK
af8b 00         BRK
af8c 00         BRK
af8d 0104       ORA ($04, X)
af8f 00         BRK
af90 00         BRK
af91 0102       ORA ($02, X)
af93 0102       ORA ($02, X)
af95 0102       ORA ($02, X)
af97 0102       ORA ($02, X)
af99 00         BRK
af9a 00         BRK
af9b 00         BRK
af9c 00         BRK
af9d a900       LDA #$00
af9f 8d0701     STA $0107
afa2 8d0801     STA $0108
afa5 a535       LDA $35
afa7 0536       ORA $36
afa9 d001       BNE afac
afab 60         RTS
afac a51a       LDA $1a
afae c921       CMP #$21
afb0 9065       BCC b017
afb2 18         CLC
afb3 a537       LDA $37
afb5 6903       ADC #$03
afb7 c928       CMP #$28
afb9 b001       BCS afbc
afbb 60         RTS
afbc a537       LDA $37
afbe c988       CMP #$88
afc0 9001       BCC afc3
afc2 60         RTS
afc3 18         CLC
afc4 a538       LDA $38
afc6 6903       ADC #$03
afc8 c950       CMP #$50
afca b001       BCS afcd
afcc 60         RTS
afcd a538       LDA $38
afcf c980       CMP #$80
afd1 9001       BCC afd4
afd3 60         RTS
afd4 ee6601     INC $0166
afd7 a533       LDA $33
afd9 2901       AND #$01
afdb d00c       BNE afe9
afdd 18         CLC
afde a537       LDA $37
afe0 6904       ADC #$04
afe2 c988       CMP #$88
afe4 b009       BCS afef
afe6 4c03b0     JMP $b003
afe9 a537       LDA $37
afeb c928       CMP #$28
afed b014       BCS b003
afef a901       LDA #$01
aff1 8534       STA $34
aff3 a537       LDA $37
aff5 c950       CMP #$50
aff7 b005       BCS affe
aff9 a924       LDA #$24
affb 8537       STA $37
affd 60         RTS
affe a988       LDA #$88
b000 8537       STA $37
b002 60         RTS
b003 a902       LDA #$02
b005 8534       STA $34
b007 a538       LDA $38
b009 c960       CMP #$60
b00b b005       BCS b012
b00d a94c       LDA #$4c
b00f 8538       STA $38
b011 60         RTS
b012 a980       LDA #$80
b014 8538       STA $38
b016 60         RTS
b017 ad0c01     LDA $010c
b01a 853d       STA $3d
b01c ad0d01     LDA $010d
b01f 853e       STA $3e
b021 a53a       LDA $3a
b023 853f       STA $3f
b025 a53c       LDA $3c
b027 8540       STA $40
b029 a534       LDA $34
b02b c903       CMP #$03
b02d d001       BNE b030
b02f 60         RTS
b030 18         CLC
b031 a539       LDA $39
b033 6901       ADC #$01
b035 cd0a01     CMP $010a
b038 9001       BCC b03b
b03a 60         RTS
b03b a533       LDA $33
b03d c902       CMP #$02
b03f f003       BEQ b044
b041 4c64b2     JMP $b264
b044 a439       LDY $39
b046 a63b       LDX $3b
b048 a534       LDA $34
b04a 2901       AND #$01
b04c d017       BNE b065
b04e a53a       LDA $3a
b050 c900       CMP #$00
b052 d006       BNE b05a
b054 88         DEY
b055 a901       LDA #$01
b057 8d0801     STA $0108
b05a a53a       LDA $3a
b05c c905       CMP #$05
b05e 9005       BCC b065
b060 a901       LDA #$01
b062 8d0801     STA $0108
b065 a534       LDA $34
b067 2902       AND #$02
b069 d01d       BNE b088
b06b a53c       LDA $3c
b06d c900       CMP #$00
b06f d009       BNE b07a
b071 ca         DEC
b072 ad0801     LDA $0108
b075 0902       ORA #$02
b077 8d0801     STA $0108
b07a a53c       LDA $3c
b07c c90d       CMP #$0d
b07e 9008       BCC b088
b080 ad0801     LDA $0108
b083 0902       ORA #$02
b085 8d0801     STA $0108
b088 8c0c01     STY $010c
b08b 8e0d01     STX $010d
b08e 20         JSR
b08f 46ab       LSR $ab
b091 ad0801     LDA $0108
b094 c901       CMP #$01
b096 d024       BNE b0bc
b098 ad0601     LDA $0106
b09b 2908       AND #$08
b09d f01a       BEQ b0b9
b09f a53a       LDA $3a
b0a1 c900       CMP #$00
b0a3 f006       BEQ b0ab
b0a5 a900       LDA #$00
b0a7 853a       STA $3a
b0a9 e639       INC $39
b0ab a534       LDA $34
b0ad 0901       ORA #$01
b0af 8534       STA $34
b0b1 ad0601     LDA $0106
b0b4 2908       AND #$08
b0b6 8d0701     STA $0107
b0b9 4c5fb2     JMP $b25f
b0bc ad0801     LDA $0108
b0bf c902       CMP #$02
b0c1 d024       BNE b0e7
b0c3 ad0601     LDA $0106
b0c6 2908       AND #$08
b0c8 f01a       BEQ b0e4
b0ca a53c       LDA $3c
b0cc c900       CMP #$00
b0ce f006       BEQ b0d6
b0d0 a900       LDA #$00
b0d2 853c       STA $3c
b0d4 e63b       INC $3b
b0d6 a534       LDA $34
b0d8 0902       ORA #$02
b0da 8534       STA $34
b0dc ad0601     LDA $0106
b0df 2908       AND #$08
b0e1 8d0701     STA $0107
b0e4 4c5fb2     JMP $b25f
b0e7 ad0801     LDA $0108
b0ea c903       CMP #$03
b0ec d0f6       BNE b0e4
b0ee ad0601     LDA $0106
b0f1 c908       CMP #$08
b0f3 f003       BEQ b0f8
b0f5 4c7cb1     JMP $b17c
b0f8 a53a       LDA $3a
b0fa c53c       CMP $3c
b0fc d006       BNE b104
b0fe a535       LDA $35
b100 c536       CMP $36
b102 f04e       BEQ b152
b104 a53a       LDA $3a
b106 c900       CMP #$00
b108 f01e       BEQ b128
b10a a53c       LDA $3c
b10c c900       CMP #$00
b10e f02d       BEQ b13d
b110 a539       LDA $39
b112 c53d       CMP $3d
b114 f027       BEQ b13d
b116 a93f       LDA #$3f
b118 c900       CMP #$00
b11a f021       BEQ b13d
b11c a53b       LDA $3b
b11e c53e       CMP $3e
b120 f006       BEQ b128
b122 a940       LDA #$40
b124 c900       CMP #$00
b126 d02a       BNE b152
b128 a53a       LDA $3a
b12a c900       CMP #$00
b12c f006       BEQ b134
b12e a900       LDA #$00
b130 853a       STA $3a
b132 e639       INC $39
b134 a534       LDA $34
b136 0901       ORA #$01
b138 8534       STA $34
b13a 4c73b1     JMP $b173
b13d a53c       LDA $3c
b13f c900       CMP #$00
b141 f006       BEQ b149
b143 a900       LDA #$00
b145 853c       STA $3c
b147 e63b       INC $3b
b149 a534       LDA $34
b14b 0902       ORA #$02
b14d 8534       STA $34
b14f 4c73b1     JMP $b173
b152 a53a       LDA $3a
b154 c900       CMP #$00
b156 f006       BEQ b15e
b158 a900       LDA #$00
b15a 853a       STA $3a
b15c e639       INC $39
b15e a53c       LDA $3c
b160 c900       CMP #$00
b162 f006       BEQ b16a
b164 a900       LDA #$00
b166 853c       STA $3c
b168 e63b       INC $3b
b16a a534       LDA $34
b16c 0903       ORA #$03
b16e 8534       STA $34
b170 4c73b1     JMP $b173
b173 ad0601     LDA $0106
b176 8d0701     STA $0107
b179 4c5fb2     JMP $b25f
b17c ad0601     LDA $0106
b17f c904       CMP #$04
b181 d01b       BNE b19e
b183 a53a       LDA $3a
b185 c900       CMP #$00
b187 f006       BEQ b18f
b189 a900       LDA #$00
b18b 853a       STA $3a
b18d e639       INC $39
b18f a534       LDA $34
b191 0901       ORA #$01
b193 8534       STA $34
b195 ad0601     LDA $0106
b198 8d0701     STA $0107
b19b 4c5fb2     JMP $b25f
b19e ad0601     LDA $0106
b1a1 c902       CMP #$02
b1a3 d01b       BNE b1c0
b1a5 a53c       LDA $3c
b1a7 c900       CMP #$00
b1a9 f006       BEQ b1b1
b1ab a900       LDA #$00
b1ad 853c       STA $3c
b1af e63b       INC $3b
b1b1 a534       LDA $34
b1b3 0902       ORA #$02
b1b5 8534       STA $34
b1b7 ad0601     LDA $0106
b1ba 8d0701     STA $0107
b1bd 4c5fb2     JMP $b25f
b1c0 ad0601     LDA $0106
b1c3 c90c       CMP #$0c
b1c5 d022       BNE b1e9
b1c7 a53a       LDA $3a
b1c9 c900       CMP #$00
b1cb f006       BEQ b1d3
b1cd a900       LDA #$00
b1cf 853a       STA $3a
b1d1 e639       INC $39
b1d3 a208       LDX #$08
b1d5 a53c       LDA $3c
b1d7 c90f       CMP #$0f
b1d9 d002       BNE b1dd
b1db a204       LDX #$04
b1dd 8e0701     STX $0107
b1e0 a534       LDA $34
b1e2 0901       ORA #$01
b1e4 8534       STA $34
b1e6 4c5fb2     JMP $b25f
b1e9 ad0601     LDA $0106
b1ec c90a       CMP #$0a
b1ee d022       BNE b212
b1f0 a53c       LDA $3c
b1f2 c900       CMP #$00
b1f4 f006       BEQ b1fc
b1f6 a900       LDA #$00
b1f8 853c       STA $3c
b1fa e63b       INC $3b
b1fc a208       LDX #$08
b1fe a53a       LDA $3a
b200 c907       CMP #$07
b202 d002       BNE b206
b204 a202       LDX #$02
b206 8e0701     STX $0107
b209 a534       LDA $34
b20b 0902       ORA #$02
b20d 8534       STA $34
b20f 4c5fb2     JMP $b25f
b212 ad0601     LDA $0106
b215 c900       CMP #$00
b217 f046       BEQ b25f
b219 c906       CMP #$06
b21b f004       BEQ b221
b21d c90e       CMP #$0e
b21f d03e       BNE b25f
b221 a53a       LDA $3a
b223 c900       CMP #$00
b225 f006       BEQ b22d
b227 a900       LDA #$00
b229 853a       STA $3a
b22b e639       INC $39
b22d a53c       LDA $3c
b22f c900       CMP #$00
b231 f006       BEQ b239
b233 a900       LDA #$00
b235 853c       STA $3c
b237 e63b       INC $3b
b239 a534       LDA $34
b23b 0903       ORA #$03
b23d 8534       STA $34
b23f a902       LDA #$02
b241 8d0701     STA $0107
b244 a200       LDX #$00
b246 bc60b2     LDY $b260, X
b249 b141       LDA ($41), Y
b24b c900       CMP #$00
b24d f004       BEQ b253
b24f c9f0       CMP #$f0
b251 d006       BNE b259
b253 e8         INX
b254 e002       CPX #$02
b256 d0ee       BNE b246
b258 60         RTS
b259 bd62b2     LDA $b262, X
b25c 8d0701     STA $0107
b25f 60         RTS
b260 010b       ORA ($0b, X)
b262 db 04
b263 02a5       ASL #$a5
b265 db 33
b266 c900       CMP #$00
b268 f003       BEQ b26d
b26a 4c45b4     JMP $b445
b26d a439       LDY $39
b26f a63b       LDX $3b
b271 a534       LDA $34
b273 2901       AND #$01
b275 d017       BNE b28e
b277 a53a       LDA $3a
b279 c900       CMP #$00
b27b d006       BNE b283
b27d 88         DEY
b27e a901       LDA #$01
b280 8d0801     STA $0108
b283 a53a       LDA $3a
b285 c905       CMP #$05
b287 9005       BCC b28e
b289 a901       LDA #$01
b28b 8d0801     STA $0108
b28e a534       LDA $34
b290 2902       AND #$02
b292 d00e       BNE b2a2
b294 a53c       LDA $3c
b296 c90c       CMP #$0c
b298 9008       BCC b2a2
b29a ad0801     LDA $0108
b29d 0902       ORA #$02
b29f 8d0801     STA $0108
b2a2 8c0c01     STY $010c
b2a5 8e0d01     STX $010d
b2a8 20         JSR
b2a9 46ab       LSR $ab
b2ab ad0801     LDA $0108
b2ae c901       CMP #$01
b2b0 d024       BNE b2d6
b2b2 ad0601     LDA $0106
b2b5 2908       AND #$08
b2b7 f01a       BEQ b2d3
b2b9 a53a       LDA $3a
b2bb c900       CMP #$00
b2bd f006       BEQ b2c5
b2bf e639       INC $39
b2c1 a900       LDA #$00
b2c3 853a       STA $3a
b2c5 a534       LDA $34
b2c7 0901       ORA #$01
b2c9 8534       STA $34
b2cb ad0601     LDA $0106
b2ce 2908       AND #$08
b2d0 8d0701     STA $0107
b2d3 4c40b4     JMP $b440
b2d6 ad0801     LDA $0108
b2d9 c902       CMP #$02
b2db d01c       BNE b2f9
b2dd ad0601     LDA $0106
b2e0 2904       AND #$04
b2e2 f012       BEQ b2f6
b2e4 a90c       LDA #$0c
b2e6 853c       STA $3c
b2e8 a534       LDA $34
b2ea 0902       ORA #$02
b2ec 8534       STA $34
b2ee ad0601     LDA $0106
b2f1 2904       AND #$04
b2f3 8d0701     STA $0107
b2f6 4c40b4     JMP $b440
b2f9 ad0801     LDA $0108
b2fc c903       CMP #$03
b2fe d0f6       BNE b2f6
b300 ad0601     LDA $0106
b303 c904       CMP #$04
b305 d06e       BNE b375
b307 a53a       LDA $3a
b309 c53c       CMP $3c
b30b d006       BNE b313
b30d a535       LDA $35
b30f c536       CMP $36
b311 f040       BEQ b353
b313 a53a       LDA $3a
b315 c900       CMP #$00
b317 f018       BEQ b331
b319 a53c       LDA $3c
b31b c90c       CMP #$0c
b31d f027       BEQ b346
b31f a53a       LDA $3a
b321 c53d       CMP $3d
b323 f021       BEQ b346
b325 a53f       LDA $3f
b327 c900       CMP #$00
b329 f01b       BEQ b346
b32b a540       LDA $40
b32d c90c       CMP #$0c
b32f 9022       BCC b353
b331 a53a       LDA $3a
b333 c900       CMP #$00
b335 f006       BEQ b33d
b337 a900       LDA #$00
b339 853a       STA $3a
b33b e639       INC $39
b33d a534       LDA $34
b33f 0901       ORA #$01
b341 8534       STA $34
b343 4c6cb3     JMP $b36c
b346 a90c       LDA #$0c
b348 853c       STA $3c
b34a a534       LDA $34
b34c 0902       ORA #$02
b34e 8534       STA $34
b350 4c6cb3     JMP $b36c
b353 a53a       LDA $3a
b355 c900       CMP #$00
b357 f006       BEQ b35f
b359 a900       LDA #$00
b35b 853a       STA $3a
b35d e639       INC $39
b35f a90c       LDA #$0c
b361 853c       STA $3c
b363 a534       LDA $34
b365 0903       ORA #$03
b367 8534       STA $34
b369 4c6cb3     JMP $b36c
b36c ad0601     LDA $0106
b36f 8d0701     STA $0107
b372 4c40b4     JMP $b440
b375 ad0601     LDA $0106
b378 c908       CMP #$08
b37a d01b       BNE b397
b37c a53a       LDA $3a
b37e c900       CMP #$00
b380 f006       BEQ b388
b382 a900       LDA #$00
b384 853a       STA $3a
b386 e639       INC $39
b388 a534       LDA $34
b38a 0901       ORA #$01
b38c 8534       STA $34
b38e ad0601     LDA $0106
b391 8d0701     STA $0107
b394 4c40b4     JMP $b440
b397 ad0601     LDA $0106
b39a c901       CMP #$01
b39c d013       BNE b3b1
b39e a90c       LDA #$0c
b3a0 853c       STA $3c
b3a2 a534       LDA $34
b3a4 0902       ORA #$02
b3a6 8534       STA $34
b3a8 ad0601     LDA $0106
b3ab 8d0701     STA $0107
b3ae 4c40b4     JMP $b440
b3b1 ad0601     LDA $0106
b3b4 c90c       CMP #$0c
b3b6 d022       BNE b3da
b3b8 a53a       LDA $3a
b3ba c900       CMP #$00
b3bc f006       BEQ b3c4
b3be a900       LDA #$00
b3c0 853a       STA $3a
b3c2 e639       INC $39
b3c4 a208       LDX #$08
b3c6 a53c       LDA $3c
b3c8 c90f       CMP #$0f
b3ca d002       BNE b3ce
b3cc a204       LDX #$04
b3ce 8e0701     STX $0107
b3d1 a534       LDA $34
b3d3 0901       ORA #$01
b3d5 8534       STA $34
b3d7 4c40b4     JMP $b440
b3da ad0601     LDA $0106
b3dd c905       CMP #$05
b3df d01a       BNE b3fb
b3e1 a90c       LDA #$0c
b3e3 853c       STA $3c
b3e5 a204       LDX #$04
b3e7 a53a       LDA $3a
b3e9 c907       CMP #$07
b3eb d002       BNE b3ef
b3ed a201       LDX #$01
b3ef 8e0701     STX $0107
b3f2 a534       LDA $34
b3f4 0902       ORA #$02
b3f6 8534       STA $34
b3f8 4c40b4     JMP $b440
b3fb ad0601     LDA $0106
b3fe c900       CMP #$00
b400 f03e       BEQ b440
b402 c909       CMP #$09
b404 f004       BEQ b40a
b406 c90d       CMP #$0d
b408 d036       BNE b440
b40a a53a       LDA $3a
b40c c900       CMP #$00
b40e f006       BEQ b416
b410 a900       LDA #$00
b412 853a       STA $3a
b414 e639       INC $39
b416 a90c       LDA #$0c
b418 853c       STA $3c
b41a a534       LDA $34
b41c 0903       ORA #$03
b41e 8534       STA $34
b420 a901       LDA #$01
b422 8d0701     STA $0107
b425 a200       LDX #$00
b427 bc41b4     LDY $b441, X
b42a b141       LDA ($41), Y
b42c c900       CMP #$00
b42e f004       BEQ b434
b430 c9f0       CMP #$f0
b432 d006       BNE b43a
b434 e8         INX
b435 e002       CPX #$02
b437 d0ee       BNE b427
b439 60         RTS
b43a bd43b4     LDA $b443, X
b43d 8d0701     STA $0107
b440 60         RTS
b441 00         BRK
b442 db 0c
b443 08         PHP
b444 01a5       ORA ($a5, X)
b446 db 33
b447 c903       CMP #$03
b449 f003       BEQ b44e
b44b 4c2db6     JMP $b62d
b44e 18         CLC
b44f a539       LDA $39
b451 6901       ADC #$01
b453 cd0a01     CMP $010a
b456 f0f3       BEQ b44b
b458 a439       LDY $39
b45a a63b       LDX $3b
b45c a53a       LDA $3a
b45e c904       CMP #$04
b460 9005       BCC b467
b462 a901       LDA #$01
b464 8d0801     STA $0108
b467 a534       LDA $34
b469 2902       AND #$02
b46b d01d       BNE b48a
b46d a53c       LDA $3c
b46f c900       CMP #$00
b471 d009       BNE b47c
b473 ca         DEC
b474 ad0801     LDA $0108
b477 0902       ORA #$02
b479 8d0801     STA $0108
b47c a53c       LDA $3c
b47e c90d       CMP #$0d
b480 9008       BCC b48a
b482 ad0801     LDA $0108
b485 0902       ORA #$02
b487 8d0801     STA $0108
b48a 8c0c01     STY $010c
b48d 8e0d01     STX $010d
b490 20         JSR
b491 46ab       LSR $ab
b493 ad0801     LDA $0108
b496 c901       CMP #$01
b498 d01c       BNE b4b6
b49a ad0601     LDA $0106
b49d 2902       AND #$02
b49f f012       BEQ b4b3
b4a1 a904       LDA #$04
b4a3 853a       STA $3a
b4a5 a534       LDA $34
b4a7 0901       ORA #$01
b4a9 8534       STA $34
b4ab ad0601     LDA $0106
b4ae 2902       AND #$02
b4b0 8d0701     STA $0107
b4b3 4c28b6     JMP $b628
b4b6 ad0801     LDA $0108
b4b9 c902       CMP #$02
b4bb d024       BNE b4e1
b4bd ad0601     LDA $0106
b4c0 2908       AND #$08
b4c2 f01a       BEQ b4de
b4c4 a53c       LDA $3c
b4c6 c900       CMP #$00
b4c8 f006       BEQ b4d0
b4ca a900       LDA #$00
b4cc 853c       STA $3c
b4ce e63b       INC $3b
b4d0 a534       LDA $34
b4d2 0902       ORA #$02
b4d4 8534       STA $34
b4d6 ad0601     LDA $0106
b4d9 2908       AND #$08
b4db 8d0701     STA $0107
b4de 4c28b6     JMP $b628
b4e1 ad0801     LDA $0108
b4e4 c903       CMP #$03
b4e6 d0f6       BNE b4de
b4e8 ad0601     LDA $0106
b4eb c902       CMP #$02
b4ed d06e       BNE b55d
b4ef a53a       LDA $3a
b4f1 c53c       CMP $3c
b4f3 d006       BNE b4fb
b4f5 a535       LDA $35
b4f7 c536       CMP $36
b4f9 f040       BEQ b53b
b4fb a53a       LDA $3a
b4fd c904       CMP #$04
b4ff f018       BEQ b519
b501 a53c       LDA $3c
b503 c900       CMP #$00
b505 f01f       BEQ b526
b507 a53f       LDA $3f
b509 c93d       CMP #$3d
b50b b019       BCS b526
b50d a53b       LDA $3b
b50f c53e       CMP $3e
b511 f006       BEQ b519
b513 a940       LDA #$40
b515 c900       CMP #$00
b517 d022       BNE b53b
b519 a904       LDA #$04
b51b 853a       STA $3a
b51d a534       LDA $34
b51f 0901       ORA #$01
b521 8534       STA $34
b523 4c54b5     JMP $b554
b526 a53c       LDA $3c
b528 c900       CMP #$00
b52a f006       BEQ b532
b52c a900       LDA #$00
b52e 853c       STA $3c
b530 e63b       INC $3b
b532 a534       LDA $34
b534 0902       ORA #$02
b536 8534       STA $34
b538 4c54b5     JMP $b554
b53b a904       LDA #$04
b53d 853a       STA $3a
b53f a53c       LDA $3c
b541 c900       CMP #$00
b543 f006       BEQ b54b
b545 a900       LDA #$00
b547 853c       STA $3c
b549 e63b       INC $3b
b54b a534       LDA $34
b54d 0903       ORA #$03
b54f 8534       STA $34
b551 4c54b5     JMP $b554
b554 ad0601     LDA $0106
b557 8d0701     STA $0107
b55a 4c28b6     JMP $b628
b55d ad0601     LDA $0106
b560 c908       CMP #$08
b562 d01b       BNE b57f
b564 a53c       LDA $3c
b566 c900       CMP #$00
b568 f006       BEQ b570
b56a a900       LDA #$00
b56c 853c       STA $3c
b56e e63b       INC $3b
b570 a534       LDA $34
b572 0902       ORA #$02
b574 8534       STA $34
b576 ad0601     LDA $0106
b579 8d0701     STA $0107
b57c 4c28b6     JMP $b628
b57f ad0601     LDA $0106
b582 c901       CMP #$01
b584 d013       BNE b599
b586 a904       LDA #$04
b588 853a       STA $3a
b58a a534       LDA $34
b58c 0901       ORA #$01
b58e 8534       STA $34
b590 ad0601     LDA $0106
b593 8d0701     STA $0107
b596 4c28b6     JMP $b628
b599 ad0601     LDA $0106
b59c c90a       CMP #$0a
b59e d022       BNE b5c2
b5a0 a53c       LDA $3c
b5a2 c900       CMP #$00
b5a4 f006       BEQ b5ac
b5a6 a900       LDA #$00
b5a8 853c       STA $3c
b5aa e63b       INC $3b
b5ac a208       LDX #$08
b5ae a53a       LDA $3a
b5b0 c907       CMP #$07
b5b2 d002       BNE b5b6
b5b4 a202       LDX #$02
b5b6 8e0701     STX $0107
b5b9 a534       LDA $34
b5bb 0902       ORA #$02
b5bd 8534       STA $34
b5bf 4c28b6     JMP $b628
b5c2 ad0601     LDA $0106
b5c5 c903       CMP #$03
b5c7 d01a       BNE b5e3
b5c9 a904       LDA #$04
b5cb 853a       STA $3a
b5cd a202       LDX #$02
b5cf a53c       LDA $3c
b5d1 c90f       CMP #$0f
b5d3 d002       BNE b5d7
b5d5 a201       LDX #$01
b5d7 8e0701     STX $0107
b5da a534       LDA $34
b5dc 0901       ORA #$01
b5de 8534       STA $34
b5e0 4c28b6     JMP $b628
b5e3 ad0601     LDA $0106
b5e6 c900       CMP #$00
b5e8 f03e       BEQ b628
b5ea c909       CMP #$09
b5ec f004       BEQ b5f2
b5ee c90b       CMP #$0b
b5f0 d036       BNE b628
b5f2 a904       LDA #$04
b5f4 853a       STA $3a
b5f6 a53c       LDA $3c
b5f8 c900       CMP #$00
b5fa f006       BEQ b602
b5fc a900       LDA #$00
b5fe 853c       STA $3c
b600 e63b       INC $3b
b602 a534       LDA $34
b604 0903       ORA #$03
b606 8534       STA $34
b608 a908       LDA #$08
b60a 8d0701     STA $0107
b60d a200       LDX #$00
b60f bc29b6     LDY $b629, X
b612 b141       LDA ($41), Y
b614 c900       CMP #$00
b616 f004       BEQ b61c
b618 c9f0       CMP #$f0
b61a d006       BNE b622
b61c e8         INX
b61d e002       CPX #$02
b61f d0ee       BNE b60f
b621 60         RTS
b622 bd2bb6     LDA $b62b, X
b625 8d0701     STA $0107
b628 60         RTS
b629 00         BRK
b62a db 0c
b62b 08         PHP
b62c 01a5       ORA ($a5, X)
b62e db 33
b62f c901       CMP #$01
b631 f001       BEQ b634
b633 60         RTS
b634 18         CLC
b635 a539       LDA $39
b637 6901       ADC #$01
b639 cd0a01     CMP $010a
b63c f0f5       BEQ b633
b63e a439       LDY $39
b640 a63b       LDX $3b
b642 a53a       LDA $3a
b644 c904       CMP #$04
b646 9005       BCC b64d
b648 a901       LDA #$01
b64a 8d0801     STA $0108
b64d a534       LDA $34
b64f 2902       AND #$02
b651 d00e       BNE b661
b653 a53c       LDA $3c
b655 c90c       CMP #$0c
b657 9008       BCC b661
b659 ad0801     LDA $0108
b65c 0902       ORA #$02
b65e 8d0801     STA $0108
b661 8c0c01     STY $010c
b664 8e0d01     STX $010d
b667 20         JSR
b668 46ab       LSR $ab
b66a ad0801     LDA $0108
b66d c901       CMP #$01
b66f d01c       BNE b68d
b671 ad0601     LDA $0106
b674 2902       AND #$02
b676 f012       BEQ b68a
b678 a904       LDA #$04
b67a 853a       STA $3a
b67c a534       LDA $34
b67e 0901       ORA #$01
b680 8534       STA $34
b682 ad0601     LDA $0106
b685 2902       AND #$02
b687 8d0701     STA $0107
b68a 4cc9b7     JMP $b7c9
b68d ad0801     LDA $0108
b690 c902       CMP #$02
b692 d01c       BNE b6b0
b694 ad0601     LDA $0106
b697 2904       AND #$04
b699 f012       BEQ b6ad
b69b a90c       LDA #$0c
b69d 853c       STA $3c
b69f a534       LDA $34
b6a1 0902       ORA #$02
b6a3 8534       STA $34
b6a5 ad0601     LDA $0106
b6a8 2904       AND #$04
b6aa 8d0701     STA $0107
b6ad 4cc9b7     JMP $b7c9
b6b0 ad0801     LDA $0108
b6b3 c903       CMP #$03
b6b5 d0f6       BNE b6ad
b6b7 ad0601     LDA $0106
b6ba c901       CMP #$01
b6bc d058       BNE b716
b6be a53a       LDA $3a
b6c0 c53c       CMP $3c
b6c2 d006       BNE b6ca
b6c4 a535       LDA $35
b6c6 c536       CMP $36
b6c8 f032       BEQ b6fc
b6ca a53a       LDA $3a
b6cc c904       CMP #$04
b6ce f012       BEQ b6e2
b6d0 a53c       LDA $3c
b6d2 c90c       CMP #$0c
b6d4 f019       BEQ b6ef
b6d6 a53f       LDA $3f
b6d8 c904       CMP #$04
b6da b013       BCS b6ef
b6dc a540       LDA $40
b6de c90c       CMP #$0c
b6e0 901a       BCC b6fc
b6e2 a904       LDA #$04
b6e4 853a       STA $3a
b6e6 a534       LDA $34
b6e8 0901       ORA #$01
b6ea 8534       STA $34
b6ec 4c0db7     JMP $b70d
b6ef a90c       LDA #$0c
b6f1 853c       STA $3c
b6f3 a534       LDA $34
b6f5 0902       ORA #$02
b6f7 8534       STA $34
b6f9 4c0db7     JMP $b70d
b6fc a904       LDA #$04
b6fe 853a       STA $3a
b700 a90c       LDA #$0c
b702 853c       STA $3c
b704 a534       LDA $34
b706 0903       ORA #$03
b708 8534       STA $34
b70a 4c0db7     JMP $b70d
b70d ad0601     LDA $0106
b710 8d0701     STA $0107
b713 4cc9b7     JMP $b7c9
b716 ad0601     LDA $0106
b719 c904       CMP #$04
b71b d013       BNE b730
b71d a90c       LDA #$0c
b71f 853c       STA $3c
b721 a534       LDA $34
b723 0902       ORA #$02
b725 8534       STA $34
b727 ad0601     LDA $0106
b72a 8d0701     STA $0107
b72d 4cc9b7     JMP $b7c9
b730 ad0601     LDA $0106
b733 c902       CMP #$02
b735 d013       BNE b74a
b737 a904       LDA #$04
b739 853a       STA $3a
b73b a534       LDA $34
b73d 0901       ORA #$01
b73f 8534       STA $34
b741 ad0601     LDA $0106
b744 8d0701     STA $0107
b747 4cc9b7     JMP $b7c9
b74a ad0601     LDA $0106
b74d c905       CMP #$05
b74f d01a       BNE b76b
b751 a90c       LDA #$0c
b753 853c       STA $3c
b755 a204       LDX #$04
b757 a53a       LDA $3a
b759 c907       CMP #$07
b75b d002       BNE b75f
b75d a201       LDX #$01
b75f 8e0701     STX $0107
b762 a534       LDA $34
b764 0902       ORA #$02
b766 8534       STA $34
b768 4cc9b7     JMP $b7c9
b76b ad0601     LDA $0106
b76e c903       CMP #$03
b770 d01a       BNE b78c
b772 a904       LDA #$04
b774 853a       STA $3a
b776 a202       LDX #$02
b778 a53c       LDA $3c
b77a c90f       CMP #$0f
b77c d002       BNE b780
b77e a201       LDX #$01
b780 8e0701     STX $0107
b783 a534       LDA $34
b785 0901       ORA #$01
b787 8534       STA $34
b789 4cc9b7     JMP $b7c9
b78c ad0601     LDA $0106
b78f c900       CMP #$00
b791 f036       BEQ b7c9
b793 c906       CMP #$06
b795 f004       BEQ b79b
b797 c907       CMP #$07
b799 d02e       BNE b7c9
b79b a904       LDA #$04
b79d 853a       STA $3a
b79f a90c       LDA #$0c
b7a1 853c       STA $3c
b7a3 a534       LDA $34
b7a5 0903       ORA #$03
b7a7 8534       STA $34
b7a9 a904       LDA #$04
b7ab 8d0701     STA $0107
b7ae a200       LDX #$00
b7b0 bccab7     LDY $b7ca, X
b7b3 b141       LDA ($41), Y
b7b5 c900       CMP #$00
b7b7 f004       BEQ b7bd
b7b9 c9f0       CMP #$f0
b7bb d006       BNE b7c3
b7bd e8         INX
b7be e002       CPX #$02
b7c0 d0ee       BNE b7b0
b7c2 60         RTS
b7c3 bdccb7     LDA $b7cc, X
b7c6 8d0701     STA $0107
b7c9 60         RTS
b7ca 010b       ORA ($0b, X)
b7cc db 04
b7cd 02ad       ASL #$ad
b7cf 3e01c9     ROL $c901, X
b7d2 00         BRK
b7d3 d02d       BNE b802
b7d5 a510       LDA $10
b7d7 c900       CMP #$00
b7d9 d027       BNE b802
b7db ad4501     LDA $0145
b7de c900       CMP #$00
b7e0 d020       BNE b802
b7e2 ad3401     LDA $0134
b7e5 c900       CMP #$00
b7e7 f019       BEQ b802
b7e9 a519       LDA $19
b7eb c900       CMP #$00
b7ed d006       BNE b7f5
b7ef 20         JSR
b7f0 db 13
b7f1 b8         CLV
b7f2 4cf8b7     JMP $b7f8
b7f5 20         JSR
b7f6 db 23
b7f7 b8         CLV
b7f8 ad3501     LDA $0135
b7fb c900       CMP #$00
b7fd f003       BEQ b802
b7ff 20         JSR
b800 db 03
b801 b8         CLV
b802 60         RTS
b803 a966       LDA #$66
b805 8586       STA $86
b807 a903       LDA #$03
b809 8587       STA $87
b80b a020       LDY #$20
b80d a2b9       LDX #$b9
b80f 20         JSR
b810 db 9a
b811 db a3
b812 60         RTS
b813 a970       LDA #$70
b815 8586       STA $86
b817 a903       LDA #$03
b819 8587       STA $87
b81b a021       LDY #$21
b81d a219       LDX #$19
b81f 20         JSR
b820 db 9a
b821 db a3
b822 60         RTS
b823 a976       LDA #$76
b825 8586       STA $86
b827 a903       LDA #$03
b829 8587       STA $87
b82b a021       LDY #$21
b82d a279       LDX #$79
b82f 20         JSR
b830 db 9a
b831 db a3
b832 60         RTS
b833 a50d       LDA $0d
b835 050e       ORA $0e
b837 f05f       BEQ b898
b839 18         CLC
b83a a50d       LDA $0d
b83c e50e       SBC $0e
b83e f058       BEQ b898
b840 9056       BCC b898
b842 a50e       LDA $0e
b844 e60e       INC $0e
b846 c906       CMP #$06
b848 b04e       BCS b898
b84a 0a         ASL
b84b aa         LDX
b84c bd99b8     LDA $b899, X
b84f 8d0620     STA $2006 ; PPU Memory Address
b852 bd9ab8     LDA $b89a, X
b855 8d0620     STA $2006 ; PPU Memory Address
b858 a9b0       LDA #$b0
b85a 8d0720     STA $2007 ; PPU Memory Data
b85d a9b1       LDA #$b1
b85f 8d0720     STA $2007 ; PPU Memory Data
b862 a900       LDA #$00
b864 8d0520     STA $2005 ; Background Scroll
b867 8d0520     STA $2005 ; Background Scroll
b86a 4c33b8     JMP $b833
b86d c60e       DEC $0e
b86f a50e       LDA $0e
b871 c906       CMP #$06
b873 b023       BCS b898
b875 0a         ASL
b876 aa         LDX
b877 bd99b8     LDA $b899, X
b87a 8d0620     STA $2006 ; PPU Memory Address
b87d bd9ab8     LDA $b89a, X
b880 8d0620     STA $2006 ; PPU Memory Address
b883 a92d       LDA #$2d
b885 8d0720     STA $2007 ; PPU Memory Data
b888 a92d       LDA #$2d
b88a 8d0720     STA $2007 ; PPU Memory Data
b88d a900       LDA #$00
b88f 8d0520     STA $2005 ; Background Scroll
b892 8d0520     STA $2005 ; Background Scroll
b895 4c33b8     JMP $b833
b898 60         RTS
b899 21d9       AND ($d9, X)
b89b 21db       AND ($db, X)
b89d 21dd       AND ($dd, X)
b89f 21f9       AND ($f9, X)
b8a1 21fb       AND ($fb, X)
b8a3 21fd       AND ($fd, X)
b8a5 ad3e01     LDA $013e
b8a8 c900       CMP #$00
b8aa d03b       BNE b8e7
b8ac a50a       LDA $0a
b8ae c920       CMP #$20
b8b0 d018       BNE b8ca
b8b2 ad3c01     LDA $013c
b8b5 c901       CMP #$01
b8b7 d02e       BNE b8e7
b8b9 a9e8       LDA #$e8
b8bb 8586       STA $86
b8bd a9b8       LDA #$b8
b8bf 8587       STA $87
b8c1 20         JSR
b8c2 db f3
b8c3 db a3
b8c4 a900       LDA #$00
b8c6 8d3c01     STA $013c
b8c9 60         RTS
b8ca a50a       LDA $0a
b8cc c910       CMP #$10
b8ce d017       BNE b8e7
b8d0 ad3c01     LDA $013c
b8d3 c901       CMP #$01
b8d5 d010       BNE b8e7
b8d7 a9f1       LDA #$f1
b8d9 8586       STA $86
b8db a9b8       LDA #$b8
b8dd 8587       STA $87
b8df 20         JSR
b8e0 db f3
b8e1 db a3
b8e2 a900       LDA #$00
b8e4 8d3c01     STA $013c
b8e7 60         RTS
b8e8 229a       ROL #$9a
b8ea 0519       ORA $19
b8ec 0a         ASL
b8ed 1e1c0e     ASL $0e1c, X
b8f0 db ff
b8f1 229a       ROL #$9a
b8f3 052d       ORA $2d
b8f5 2d2d2d     AND $2d2d ; Background Scroll
b8f8 2dffad     AND $adff
b8fb 2401       BIT $01
b8fd c900       CMP #$00
b8ff f053       BEQ b954
b901 ad2501     LDA $0125
b904 c900       CMP #$00
b906 f004       BEQ b90c
b908 ce2501     DEC $0125
b90b 60         RTS
b90c a200       LDX #$00
b90e ad2401     LDA $0124
b911 c901       CMP #$01
b913 d002       BNE b917
b915 a203       LDX #$03
b917 a514       LDA $14
b919 0904       ORA #$04
b91b 8d0020     STA $2000 ; PPU Control Register 1
b91e a923       LDA #$23
b920 8d0620     STA $2006 ; PPU Memory Address
b923 a938       LDA #$38
b925 8d0620     STA $2006 ; PPU Memory Address
b928 bd55b9     LDA $b955, X
b92b 8d0720     STA $2007 ; PPU Memory Data
b92e bd56b9     LDA $b956, X
b931 8d0720     STA $2007 ; PPU Memory Data
b934 bd57b9     LDA $b957, X
b937 8d0720     STA $2007 ; PPU Memory Data
b93a a900       LDA #$00
b93c 8d0520     STA $2005 ; Background Scroll
b93f 8d0520     STA $2005 ; Background Scroll
b942 a902       LDA #$02
b944 8d2501     STA $0125
b947 ad2401     LDA $0124
b94a 4903       EOR #$03
b94c 8d2401     STA $0124
b94f a514       LDA $14
b951 8d0020     STA $2000 ; PPU Control Register 1
b954 60         RTS
b955 8d9dad     STA $ad9d
b958 db 8f
b959 db 9f
b95a db af
b95b a5d8       LDA $d8
b95d c900       CMP #$00
b95f d004       BNE b965
b961 a900       LDA #$00
b963 85d9       STA $d9
b965 a5d9       LDA $d9
b967 2903       AND #$03
b969 d004       BNE b96f
b96b a9f0       LDA #$f0
b96d 85dc       STA $dc
b96f a5dc       LDA $dc
b971 8d3802     STA $0238
b974 8d3c02     STA $023c
b977 a5dd       LDA $dd
b979 8d3b02     STA $023b
b97c 18         CLC
b97d 6908       ADC #$08
b97f 8d3f02     STA $023f
b982 a5d9       LDA $d9
b984 290c       AND #$0c
b986 d004       BNE b98c
b988 a9f0       LDA #$f0
b98a 85de       STA $de
b98c a5de       LDA $de
b98e 8d4002     STA $0240
b991 8d4402     STA $0244
b994 a5df       LDA $df
b996 8d4302     STA $0243
b999 18         CLC
b99a 6908       ADC #$08
b99c 8d4702     STA $0247
b99f 60         RTS
b9a0 a581       LDA $81
b9a2 2901       AND #$01
b9a4 d004       BNE b9aa
b9a6 a9f0       LDA #$f0
b9a8 8537       STA $37
b9aa a537       LDA $37
b9ac 8d2c02     STA $022c
b9af a538       LDA $38
b9b1 8d2f02     STA $022f
b9b4 a9f0       LDA #$f0
b9b6 8d5002     STA $0250
b9b9 a58c       LDA $8c
b9bb c900       CMP #$00
b9bd f02c       BEQ b9eb
b9bf ad2401     LDA $0124
b9c2 c900       CMP #$00
b9c4 f025       BEQ b9eb
b9c6 a591       LDA $91
b9c8 c9d0       CMP #$d0
b9ca 901f       BCC b9eb
b9cc c9d9       CMP #$d9
b9ce b01b       BCS b9eb
b9d0 ad4201     LDA $0142
b9d3 4901       EOR #$01
b9d5 8d4201     STA $0142
b9d8 c900       CMP #$00
b9da f00f       BEQ b9eb
b9dc a537       LDA $37
b9de 8d5002     STA $0250
b9e1 a538       LDA $38
b9e3 8d5302     STA $0253
b9e6 a9f0       LDA #$f0
b9e8 8d2c02     STA $022c
b9eb a01a       LDY #$1a
b9ed a581       LDA $81
b9ef 2902       AND #$02
b9f1 d005       BNE b9f8
b9f3 a9f0       LDA #$f0
b9f5 993700     STA $0037, Y
b9f8 b93700     LDA $0037, Y
b9fb 8d3002     STA $0230
b9fe b93800     LDA $0038, Y
ba01 8d3302     STA $0233
ba04 a034       LDY #$34
ba06 a581       LDA $81
ba08 2904       AND #$04
ba0a d005       BNE ba11
ba0c a9f0       LDA #$f0
ba0e 993700     STA $0037, Y
ba11 b93700     LDA $0037, Y
ba14 8d3402     STA $0234
ba17 b93800     LDA $0038, Y
ba1a 8d3702     STA $0237
ba1d 60         RTS
ba1e a50a       LDA $0a
ba20 c910       CMP #$10
ba22 f030       BEQ ba54
ba24 c908       CMP #$08
ba26 f02c       BEQ ba54
ba28 c918       CMP #$18
ba2a f028       BEQ ba54
ba2c c920       CMP #$20
ba2e f024       BEQ ba54
ba30 c930       CMP #$30
ba32 f020       BEQ ba54
ba34 c931       CMP #$31
ba36 f01c       BEQ ba54
ba38 c932       CMP #$32
ba3a f018       BEQ ba54
ba3c c980       CMP #$80
ba3e f014       BEQ ba54
ba40 a9f0       LDA #$f0
ba42 8d1401     STA $0114
ba45 8d1501     STA $0115
ba48 8d1601     STA $0116
ba4b 8d1701     STA $0117
ba4e 8d1801     STA $0118
ba51 8d1901     STA $0119
ba54 ad1401     LDA $0114
ba57 8d0402     STA $0204
ba5a ad2001     LDA $0120
ba5d 8d0502     STA $0205
ba60 ad1a01     LDA $011a
ba63 8d0702     STA $0207
ba66 ad1501     LDA $0115
ba69 8d0802     STA $0208
ba6c ad2101     LDA $0121
ba6f 8d0902     STA $0209
ba72 ad1b01     LDA $011b
ba75 8d0b02     STA $020b
ba78 ad1601     LDA $0116
ba7b 8d0c02     STA $020c
ba7e ad2101     LDA $0121
ba81 8d0d02     STA $020d
ba84 ad1c01     LDA $011c
ba87 8d0f02     STA $020f
ba8a ad1701     LDA $0117
ba8d 8d1002     STA $0210
ba90 ad2101     LDA $0121
ba93 8d1102     STA $0211
ba96 ad1d01     LDA $011d
ba99 8d1302     STA $0213
ba9c ad1801     LDA $0118
ba9f 8d1402     STA $0214
baa2 ad2101     LDA $0121
baa5 8d1502     STA $0215
baa8 ad1e01     LDA $011e
baab 8d1702     STA $0217
baae ad1901     LDA $0119
bab1 8d1802     STA $0218
bab4 ad2001     LDA $0120
bab7 8d1902     STA $0219
baba ad1f01     LDA $011f
babd 8d1b02     STA $021b
bac0 60         RTS
bac1 a50a       LDA $0a
bac3 c920       CMP #$20
bac5 d001       BNE bac8
bac7 60         RTS
bac8 a58c       LDA $8c
baca c900       CMP #$00
bacc f00a       BEQ bad8
bace a50a       LDA $0a
bad0 c908       CMP #$08
bad2 f008       BEQ badc
bad4 c910       CMP #$10
bad6 f004       BEQ badc
bad8 a9f0       LDA #$f0
bada 8591       STA $91
badc a591       LDA $91
bade c9f0       CMP #$f0
bae0 900b       BCC baed
bae2 a900       LDA #$00
bae4 858c       STA $8c
bae6 a9f0       LDA #$f0
bae8 8591       STA $91
baea 4cffba     JMP $baff
baed a48d       LDY $8d
baef b18f       LDA ($8f), Y
baf1 8592       STA $92
baf3 c9ff       CMP #$ff
baf5 d008       BNE baff
baf7 a000       LDY #$00
baf9 848d       STY $8d
bafb b18f       LDA ($8f), Y
bafd 8592       STA $92
baff a591       LDA $91
bb01 8d4802     STA $0248
bb04 a592       LDA $92
bb06 8d4902     STA $0249
bb09 a593       LDA $93
bb0b 8d4a02     STA $024a
bb0e a594       LDA $94
bb10 8d4b02     STA $024b
bb13 a591       LDA $91
bb15 8d4c02     STA $024c
bb18 a592       LDA $92
bb1a 18         CLC
bb1b 6901       ADC #$01
bb1d 8d4d02     STA $024d
bb20 a593       LDA $93
bb22 8d4e02     STA $024e
bb25 a594       LDA $94
bb27 18         CLC
bb28 6908       ADC #$08
bb2a 8d4f02     STA $024f
bb2d e691       INC $91
bb2f a58e       LDA $8e
bb31 c900       CMP #$00
bb33 f003       BEQ bb38
bb35 c68e       DEC $8e
bb37 60         RTS
bb38 e68d       INC $8d
bb3a a903       LDA #$03
bb3c 858e       STA $8e
bb3e 60         RTS
bb3f a50a       LDA $0a
bb41 c910       CMP #$10
bb43 f004       BEQ bb49
bb45 c918       CMP #$18
bb47 d012       BNE bb5b
bb49 a51a       LDA $1a
bb4b c921       CMP #$21
bb4d d00c       BNE bb5b
bb4f 20         JSR
bb50 db 5f
bb51 db bb
bb52 20         JSR
bb53 db e7
bb54 db bb
bb55 20         JSR
bb56 28         PLP
bb57 bc206b     LDY $6b20, X
bb5a bc206a     LDY $6a20, X
bb5d be60a5     LDX $a560, X
bb60 81f0       STA ($f0, X)
bb62 6ead69     ROR $69ad
bb65 01c9       ORA ($c9, X)
bb67 00         BRK
bb68 f004       BEQ bb6e
bb6a ce6901     DEC $0169
bb6d 60         RTS
bb6e ad8201     LDA $0182
bb71 c901       CMP #$01
bb73 d05c       BNE bbd1
bb75 ae6801     LDX $0168
bb78 a901       LDA #$01
bb7a 9d6a01     STA $016a, X
bb7d a958       LDA #$58
bb7f 9d6d01     STA $016d, X
bb82 a964       LDA #$64
bb84 9d7001     STA $0170, X
bb87 a91e       LDA #$1e
bb89 8d6901     STA $0169
bb8c a0ff       LDY #$ff
bb8e c8         INY
bb8f ad1a01     LDA $011a
bb92 d9d2bb     CMP $bbd2, Y
bb95 b0f7       BCS bb8e
bb97 98         TYA
bb98 0a         ASL
bb99 a8         TAY
bb9a b9d9bb     LDA $bbd9, Y
bb9d 9d7901     STA $0179, X
bba0 b9dabb     LDA $bbda, Y
bba3 9d7c01     STA $017c, X
bba6 a900       LDA #$00
bba8 9d8501     STA $0185, X
bbab bd8701     LDA $0187, X
bbae a901       LDA #$01
bbb0 8d7f01     STA $017f
bbb3 ee6801     INC $0168
bbb6 ad6801     LDA $0168
bbb9 c903       CMP #$03
bbbb d014       BNE bbd1
bbbd a900       LDA #$00
bbbf 8d6801     STA $0168
bbc2 a902       LDA #$02
bbc4 8d8201     STA $0182
bbc7 a900       LDA #$00
bbc9 8d8301     STA $0183
bbcc a908       LDA #$08
bbce 8d8401     STA $0184
bbd1 60         RTS
bbd2 20         JSR
bbd3 38         SEC
bbd4 5068       BVC bc3e
bbd6 8098       STY #$98
bbd8 b005       BCS bbdf
bbda fd05fe     SBC $fe05, X
bbdd 05ff       ORA $ff
bbdf 0500       ORA $00
bbe1 0501       ORA $01
bbe3 0502       ORA $02
bbe5 0503       ORA $03
bbe7 a200       LDX #$00
bbe9 bd7f01     LDA $017f, X
bbec c900       CMP #$00
bbee f006       BEQ bbf6
bbf0 de7f01     DEC $017f, X
bbf3 4c22bc     JMP $bc22
bbf6 bd6a01     LDA $016a, X
bbf9 c900       CMP #$00
bbfb f025       BEQ bc22
bbfd a902       LDA #$02
bbff 9d7f01     STA $017f, X
bc02 18         CLC
bc03 bd6d01     LDA $016d, X
bc06 7d7901     ADC $0179, X
bc09 9d6d01     STA $016d, X
bc0c c9f0       CMP #$f0
bc0e 9008       BCC bc18
bc10 a900       LDA #$00
bc12 9d6a01     STA $016a, X
bc15 9d7f01     STA $017f, X
bc18 18         CLC
bc19 bd7001     LDA $0170, X
bc1c 7d7c01     ADC $017c, X
bc1f 9d7001     STA $0170, X
bc22 e8         INX
bc23 e003       CPX #$03
bc25 d0c2       BNE bbe9
bc27 60         RTS
bc28 a200       LDX #$00
bc2a bd8501     LDA $0185, X
bc2d c900       CMP #$00
bc2f f006       BEQ bc37
bc31 de8501     DEC $0185, X
bc34 4c5cbc     JMP $bc5c
bc37 bd6a01     LDA $016a, X
bc3a c900       CMP #$00
bc3c f01e       BEQ bc5c
bc3e a905       LDA #$05
bc40 9d8501     STA $0185, X
bc43 bc8701     LDY $0187, X
bc46 b962bc     LDA $bc62, Y
bc49 c9ff       CMP #$ff
bc4b d009       BNE bc56
bc4d a900       LDA #$00
bc4f 9d8701     STA $0187, X
bc52 a8         TAY
bc53 b962bc     LDA $bc62, Y
bc56 9d7301     STA $0173, X
bc59 fe8701     INC $0187, X
bc5c e8         INX
bc5d e003       CPX #$03
bc5f d0c9       BNE bc2a
bc61 60         RTS
bc62 20         JSR
bc63 2122       AND ($22, X)
bc65 db 23
bc66 2425       BIT $25
bc68 2627       ROL $27
bc6a db ff
bc6b a200       LDX #$00
bc6d bd6a01     LDA $016a, X
bc70 c900       CMP #$00
bc72 f03d       BEQ bcb1
bc74 18         CLC
bc75 bd6d01     LDA $016d, X
bc78 6906       ADC #$06
bc7a cd1401     CMP $0114
bc7d 9032       BCC bcb1
bc7f 18         CLC
bc80 ad1401     LDA $0114
bc83 6906       ADC #$06
bc85 dd6d01     CMP $016d, X
bc88 9027       BCC bcb1
bc8a 18         CLC
bc8b bd7001     LDA $0170, X
bc8e 6906       ADC #$06
bc90 cd1a01     CMP $011a
bc93 901c       BCC bcb1
bc95 18         CLC
bc96 ad1f01     LDA $011f
bc99 6906       ADC #$06
bc9b dd7001     CMP $0170, X
bc9e 9011       BCC bcb1
bca0 a900       LDA #$00
bca2 8581       STA $81
bca4 8d8201     STA $0182
bca7 8d6a01     STA $016a
bcaa 8d6b01     STA $016b
bcad 8d6c01     STA $016c
bcb0 60         RTS
bcb1 e8         INX
bcb2 e003       CPX #$03
bcb4 d0b7       BNE bc6d
bcb6 60         RTS
bcb7 a50a       LDA $0a
bcb9 c910       CMP #$10
bcbb f001       BEQ bcbe
bcbd 60         RTS
bcbe ad8b01     LDA $018b
bcc1 c900       CMP #$00
bcc3 f004       BEQ bcc9
bcc5 ce8b01     DEC $018b
bcc8 60         RTS
bcc9 ad8a01     LDA $018a
bccc c900       CMP #$00
bcce d037       BNE bd07
bcd0 ad6601     LDA $0166
bcd3 cd6701     CMP $0167
bcd6 d001       BNE bcd9
bcd8 60         RTS
bcd9 a909       LDA #$09
bcdb 8588       STA $88
bcdd a984       LDA #$84
bcdf 8589       STA $89
bce1 20         JSR
bce2 98         TYA
bce3 90ad       BCC bc92
bce5 6601       ROR $01
bce7 8d6701     STA $0167
bcea c910       CMP #$10
bcec d00f       BNE bcfd
bcee a930       LDA #$30
bcf0 850a       STA $0a
bcf2 a900       LDA #$00
bcf4 8d8e01     STA $018e
bcf7 a932       LDA #$32
bcf9 8d8f01     STA $018f
bcfc 60         RTS
bcfd ad0e01     LDA $010e
bd00 d005       BNE bd07
bd02 a906       LDA #$06
bd04 20         JSR
bd05 c6f3       DEC $f3
bd07 a200       LDX #$00
bd09 bd4a01     LDA $014a, X
bd0c 8d3101     STA $0131
bd0f bd4e01     LDA $014e, X
bd12 9d4a01     STA $014a, X
bd15 ad3101     LDA $0131
bd18 9d4e01     STA $014e, X
bd1b e8         INX
bd1c e004       CPX #$04
bd1e d0e9       BNE bd09
bd20 20         JSR
bd21 42a4       LSR #$a4
bd23 ad8a01     LDA $018a
bd26 4901       EOR #$01
bd28 8d8a01     STA $018a
bd2b a905       LDA #$05
bd2d 8d8b01     STA $018b
bd30 60         RTS
bd31 ad8d01     LDA $018d
bd34 c900       CMP #$00
bd36 f004       BEQ bd3c
bd38 ce8d01     DEC $018d
bd3b 60         RTS
bd3c ad8c01     LDA $018c
bd3f c900       CMP #$00
bd41 d001       BNE bd44
bd43 60         RTS
bd44 ad8c01     LDA $018c
bd47 c90d       CMP #$0d
bd49 d014       BNE bd5f
bd4b a900       LDA #$00
bd4d 8d8c01     STA $018c
bd50 a931       LDA #$31
bd52 850a       STA $0a
bd54 a900       LDA #$00
bd56 8d8e01     STA $018e
bd59 a93c       LDA #$3c
bd5b 8d8f01     STA $018f
bd5e 60         RTS
bd5f c901       CMP #$01
bd61 d005       BNE bd68
bd63 a907       LDA #$07
bd65 20         JSR
bd66 c6f3       DEC $f3
bd68 38         SEC
bd69 ad8c01     LDA $018c
bd6c e901       SBC #$01
bd6e 0a         ASL
bd6f aa         LDX
bd70 bda1bd     LDA $bda1, X
bd73 8d0620     STA $2006 ; PPU Memory Address
bd76 bda2bd     LDA $bda2, X
bd79 8d0620     STA $2006 ; PPU Memory Address
bd7c a906       LDA #$06
bd7e 8d0120     STA $2001 ; PPU Control Register 2
bd81 a208       LDX #$08
bd83 a92d       LDA #$2d
bd85 8d0720     STA $2007 ; PPU Memory Data
bd88 ca         DEC
bd89 d0fa       BNE bd85
bd8b a900       LDA #$00
bd8d 8d0520     STA $2005 ; Background Scroll
bd90 8d0520     STA $2005 ; Background Scroll
bd93 a515       LDA $15
bd95 8d0120     STA $2001 ; PPU Control Register 2
bd98 a915       LDA #$15
bd9a 8d8d01     STA $018d
bd9d ee8c01     INC $018c
bda0 60         RTS
bda1 20         JSR
bda2 a920       LDA #$20
bda4 c920       CMP #$20
bda6 e921       SBC #$21
bda8 0921       ORA #$21
bdaa 2921       AND #$21
bdac 4921       EOR #$21
bdae 6921       ADC #$21
bdb0 8921       STA #$21
bdb2 a921       LDA #$21
bdb4 c921       CMP #$21
bdb6 e922       SBC #$22
bdb8 09a5       ORA #$a5
bdba 0a         ASL
bdbb c910       CMP #$10
bdbd d066       BNE be25
bdbf a51a       LDA $1a
bdc1 c921       CMP #$21
bdc3 d060       BNE be25
bdc5 ad8c01     LDA $018c
bdc8 c900       CMP #$00
bdca d059       BNE be25
bdcc ad8301     LDA $0183
bdcf 0d8401     ORA $0184
bdd2 f00e       BEQ bde2
bdd4 ce8401     DEC $0184
bdd7 ad8401     LDA $0184
bdda c9ff       CMP #$ff
bddc d047       BNE be25
bdde ce8301     DEC $0183
bde1 60         RTS
bde2 ad8b01     LDA $018b
bde5 d03e       BNE be25
bde7 ad8201     LDA $0182
bdea c900       CMP #$00
bdec d016       BNE be04
bdee a926       LDA #$26
bdf0 8586       STA $86
bdf2 a9be       LDA #$be
bdf4 8587       STA $87
bdf6 20         JSR
bdf7 db f3
bdf8 db a3
bdf9 a901       LDA #$01
bdfb 8d8201     STA $0182
bdfe a902       LDA #$02
be00 8d6901     STA $0169
be03 60         RTS
be04 ad8201     LDA $0182
be07 c902       CMP #$02
be09 d01a       BNE be25
be0b a948       LDA #$48
be0d 8586       STA $86
be0f a9be       LDA #$be
be11 8587       STA $87
be13 20         JSR
be14 db f3
be15 db a3
be16 a900       LDA #$00
be18 8d8201     STA $0182
be1b a901       LDA #$01
be1d 8d8301     STA $0183
be20 a900       LDA #$00
be22 8d8401     STA $0184
be25 60         RTS
be26 2149       AND ($49, X)
be28 08         PHP
be29 40         RTI
be2a 4142       EOR ($42, X)
be2c db 43
be2d 4445       JMP $45
be2f 4647       LSR $47
be31 2169       AND ($69, X)
be33 08         PHP
be34 5051       BVC be87
be36 db 52
be37 db 53
be38 5455       JMP $55, X
be3a 5657       LSR $57, X
be3c 2189       AND ($89, X)
be3e 08         PHP
be3f 60         RTS
be40 6162       ADC ($62, X)
be42 db 63
be43 6465       JMP (ABS) $65
be45 6667       ROR $67
be47 db ff
be48 2149       AND ($49, X)
be4a 08         PHP
be4b 98         TYA
be4c 999a9b     STA $9b9a, Y
be4f 9c9d9e     STY $9e9d, X
be52 db 9f
be53 2169       AND ($69, X)
be55 08         PHP
be56 a8         TAY
be57 a9aa       LDA #$aa
be59 db ab
be5a acadae     LDY $aead
be5d db af
be5e 2189       AND ($89, X)
be60 08         PHP
be61 b8         CLV
be62 b9babb     LDA $bbba, Y
be65 bcbdbe     LDY $bebd, X
be68 db bf
be69 db ff
be6a a200       LDX #$00
be6c a000       LDY #$00
be6e bd6a01     LDA $016a, X
be71 c900       CMP #$00
be73 d005       BNE be7a
be75 a9f0       LDA #$f0
be77 9d6d01     STA $016d, X
be7a bd6d01     LDA $016d, X
be7d 992002     STA $0220, Y
be80 bd7301     LDA $0173, X
be83 992102     STA $0221, Y
be86 bd7601     LDA $0176, X
be89 992202     STA $0222, Y
be8c bd7001     LDA $0170, X
be8f 992302     STA $0223, Y
be92 98         TYA
be93 18         CLC
be94 6904       ADC #$04
be96 a8         TAY
be97 e8         INX
be98 e003       CPX #$03
be9a d0d2       BNE be6e
be9c 60         RTS
be9d a51a       LDA $1a
be9f c921       CMP #$21
bea1 f019       BEQ bebc
bea3 a50a       LDA $0a
bea5 c908       CMP #$08
bea7 f004       BEQ bead
bea9 c910       CMP #$10
beab d00c       BNE beb9
bead 20         JSR
beae 39c320     AND $20c3, Y
beb1 db 87
beb2 db bf
beb3 20         JSR
beb4 bdbe20     LDA $20be, X
beb7 b1c3       LDA ($c3), Y
beb9 20         JSR
beba a8         TAY
bebb c460       CPY $60
bebd ad0f01     LDA $010f
bec0 c905       CMP #$05
bec2 f037       BEQ befb
bec4 c900       CMP #$00
bec6 d032       BNE befa
bec8 a200       LDX #$00
beca a000       LDY #$00
becc b595       LDA $95, X
bece 1598       ORA $98, X
bed0 d008       BNE beda
bed2 b9c000     LDA $00c0, Y
bed5 19c100     ORA $00c1, Y
bed8 f008       BEQ bee2
beda c8         INY
bedb c8         INY
bedc e8         INX
bedd e003       CPX #$03
bedf d0eb       BNE becc
bee1 60         RTS
bee2 86ad       STX $ad
bee4 a901       LDA #$01
bee6 8d0f01     STA $010f
bee9 a200       LDX #$00
beeb 8e1001     STX $0110
beee ad1a01     LDA $011a
bef1 c968       CMP #$68
bef3 9005       BCC befa
bef5 a201       LDX #$01
bef7 8e1001     STX $0110
befa 60         RTS
befb ee0f01     INC $010f
befe a6ad       LDX $ad
bf00 a900       LDA #$00
bf02 959e       STA $9e, X
bf04 a901       LDA #$01
bf06 9595       STA $95, X
bf08 a901       LDA #$01
bf0a 959b       STA $9b, X
bf0c a903       LDA #$03
bf0e 95bd       STA $bd, X
bf10 a906       LDA #$06
bf12 95d5       STA $d5, X
bf14 a900       LDA #$00
bf16 95d2       STA $d2, X
bf18 a51a       LDA $1a
bf1a 38         SEC
bf1b e901       SBC #$01
bf1d 2903       AND #$03
bf1f 8d3101     STA $0131
bf22 0a         ASL
bf23 a8         TAY
bf24 8a         STX
bf25 0a         ASL
bf26 aa         LDX
bf27 b9c2c5     LDA $c5c2, Y
bf2a 95cc       STA $cc, X
bf2c b9c3c5     LDA $c5c3, Y
bf2f 95cd       STA $cd, X
bf31 ad3101     LDA $0131
bf34 0a         ASL
bf35 0a         ASL
bf36 18         CLC
bf37 6d3101     ADC $0131
bf3a 0a         ASL
bf3b 8d3201     STA $0132
bf3e a990       LDA #$90
bf40 95c6       STA $c6, X
bf42 a9c5       LDA #$c5
bf44 95c7       STA $c7, X
bf46 18         CLC
bf47 b5c6       LDA $c6, X
bf49 6d3201     ADC $0132
bf4c 95c6       STA $c6, X
bf4e b5c7       LDA $c7, X
bf50 6900       ADC #$00
bf52 95c7       STA $c7, X
bf54 a1c6       LDA ($c6, X)
bf56 8d3101     STA $0131
bf59 a6ad       LDX $ad
bf5b a902       LDA #$02
bf5d 95ba       STA $ba, X
bf5f a934       LDA #$34
bf61 8d3201     STA $0132
bf64 ad1001     LDA $0110
bf67 c900       CMP #$00
bf69 f009       BEQ bf74
bf6b a900       LDA #$00
bf6d 95ba       STA $ba, X
bf6f a98c       LDA #$8c
bf71 8d3201     STA $0132
bf74 a900       LDA #$00
bf76 95ae       STA $ae, X
bf78 ad3101     LDA $0131
bf7b 95b1       STA $b1, X
bf7d a901       LDA #$01
bf7f 95b4       STA $b4, X
bf81 ad3201     LDA $0132
bf84 95b7       STA $b7, X
bf86 60         RTS
bf87 a200       LDX #$00
bf89 b595       LDA $95, X
bf8b c900       CMP #$00
bf8d f018       BEQ bfa7
bf8f b5bd       LDA $bd, X
bf91 c900       CMP #$00
bf93 f005       BEQ bf9a
bf95 d6bd       DEC $bd, X
bf97 4ca7bf     JMP $bfa7
bf9a a903       LDA #$03
bf9c 95bd       STA $bd, X
bf9e 20         JSR
bf9f adbf20     LDA $20bf ; PPU Memory Data
bfa2 1dc020     ORA $20c0, X
bfa5 c0c0       CPY #$c0
bfa7 e8         INX
bfa8 e003       CPX #$03
bfaa d0dd       BNE bf89
bfac 60         RTS
bfad b59e       LDA $9e, X
bfaf c900       CMP #$00
bfb1 f001       BEQ bfb4
bfb3 60         RTS
bfb4 b59b       LDA $9b, X
bfb6 f011       BEQ bfc9
bfb8 f6ae       INC $ae, X
bfba b5ae       LDA $ae, X
bfbc c910       CMP #$10
bfbe b001       BCS bfc1
bfc0 60         RTS
bfc1 a900       LDA #$00
bfc3 959b       STA $9b, X
bfc5 ee0f01     INC $010f
bfc8 60         RTS
bfc9 20         JSR
bfca d6c0       DEC $c0, X
bfcc b5ae       LDA $ae, X
bfce c9b0       CMP #$b0
bfd0 9005       BCC bfd7
bfd2 a902       LDA #$02
bfd4 959e       STA $9e, X
bfd6 60         RTS
bfd7 c960       CMP #$60
bfd9 9041       BCC c01c
bfdb 38         SEC
bfdc e910       SBC #$10
bfde 4a         LSR
bfdf 4a         LSR
bfe0 4a         LSR
bfe1 8d3101     STA $0131
bfe4 0a         ASL
bfe5 0a         ASL
bfe6 18         CLC
bfe7 6d3101     ADC $0131
bfea 0a         ASL
bfeb 18         CLC
bfec 6d3101     ADC $0131
bfef 6584       ADC $84
bff1 8586       STA $86
bff3 a585       LDA $85
bff5 6900       ADC #$00
bff7 8587       STA $87
bff9 a000       LDY #$00
bffb b186       LDA ($86), Y
bffd c900       CMP #$00
bfff d01b       BNE c01c
c001 c8         INY
c002 c024       CPY #$24
c004 d0f5       BNE bffb
c006 a901       LDA #$01
c008 959e       STA $9e, X
c00a a900       LDA #$00
c00c 95a4       STA $a4, X
c00e 95a1       STA $a1, X
c010 95a7       STA $a7, X
c012 b5b7       LDA $b7, X
c014 c968       CMP #$68
c016 b004       BCS c01c
c018 a901       LDA #$01
c01a 95a7       STA $a7, X
c01c 60         RTS
c01d b59e       LDA $9e, X
c01f c901       CMP #$01
c021 f001       BEQ c024
c023 60         RTS
c024 8a         STX
c025 48         PHA
c026 0a         ASL
c027 aa         LDX
c028 b5cc       LDA $cc, X
c02a 8586       STA $86
c02c b5cd       LDA $cd, X
c02e 8587       STA $87
c030 68         PLA
c031 aa         LDX
c032 b4a1       LDY $a1, X
c034 b186       LDA ($86), Y
c036 c980       CMP #$80
c038 d00a       BNE c044
c03a 88         DEY
c03b 88         DEY
c03c 94a1       STY $a1, X
c03e b5a4       LDA $a4, X
c040 4901       EOR #$01
c042 95a4       STA $a4, X
c044 b186       LDA ($86), Y
c046 18         CLC
c047 75ae       ADC $ae, X
c049 95ae       STA $ae, X
c04b c8         INY
c04c b5a7       LDA $a7, X
c04e 55a4       EOR $a4, X
c050 d00a       BNE c05c
c052 b186       LDA ($86), Y
c054 18         CLC
c055 75b7       ADC $b7, X
c057 95b7       STA $b7, X
c059 4c67c0     JMP $c067
c05c b186       LDA ($86), Y
c05e 49ff       EOR #$ff
c060 18         CLC
c061 6901       ADC #$01
c063 75b7       ADC $b7, X
c065 95b7       STA $b7, X
c067 b5a4       LDA $a4, X
c069 c900       CMP #$00
c06b d007       BNE c074
c06d f6a1       INC $a1, X
c06f f6a1       INC $a1, X
c071 4c7ec0     JMP $c07e
c074 d6a1       DEC $a1, X
c076 d6a1       DEC $a1, X
c078 d004       BNE c07e
c07a a900       LDA #$00
c07c 95a4       STA $a4, X
c07e b5b7       LDA $b7, X
c080 c911       CMP #$11
c082 b019       BCS c09d
c084 a910       LDA #$10
c086 95b7       STA $b7, X
c088 b5a7       LDA $a7, X
c08a f004       BEQ c090
c08c b5a4       LDA $a4, X
c08e f025       BEQ c0b5
c090 a900       LDA #$00
c092 95a1       STA $a1, X
c094 95a4       STA $a4, X
c096 a901       LDA #$01
c098 95a7       STA $a7, X
c09a 4cb5c0     JMP $c0b5
c09d c9b0       CMP #$b0
c09f 9014       BCC c0b5
c0a1 a9b0       LDA #$b0
c0a3 95b7       STA $b7, X
c0a5 b5a7       LDA $a7, X
c0a7 d004       BNE c0ad
c0a9 b5a4       LDA $a4, X
c0ab f008       BEQ c0b5
c0ad a900       LDA #$00
c0af 95a1       STA $a1, X
c0b1 95a4       STA $a4, X
c0b3 95a7       STA $a7, X
c0b5 b5ae       LDA $ae, X
c0b7 c9b0       CMP #$b0
c0b9 9004       BCC c0bf
c0bb a902       LDA #$02
c0bd 959e       STA $9e, X
c0bf 60         RTS
c0c0 b59e       LDA $9e, X
c0c2 c902       CMP #$02
c0c4 f001       BEQ c0c7
c0c6 60         RTS
c0c7 f6ae       INC $ae, X
c0c9 b5ae       LDA $ae, X
c0cb c9f0       CMP #$f0
c0cd 9006       BCC c0d5
c0cf a900       LDA #$00
c0d1 9595       STA $95, X
c0d3 959e       STA $9e, X
c0d5 60         RTS
c0d6 b5ba       LDA $ba, X
c0d8 c900       CMP #$00
c0da d037       BNE c113
c0dc f6ae       INC $ae, X
c0de 20         JSR
c0df c4c1       CPY $c1
c0e1 b004       BCS c0e7
c0e3 20         JSR
c0e4 4dc260     EOR $60c2
c0e7 d6ae       DEC $ae, X
c0e9 f6b7       INC $b7, X
c0eb 20         JSR
c0ec fec1b0     INC $b0c1, X
c0ef db 04
c0f0 20         JSR
c0f1 a9c2       LDA #$c2
c0f3 60         RTS
c0f4 d6b7       DEC $b7, X
c0f6 b5b7       LDA $b7, X
c0f8 c9b0       CMP #$b0
c0fa f012       BEQ c10e
c0fc 8e2f01     STX $012f
c0ff 20         JSR
c100 db 9b
c101 db 92
c102 ae2f01     LDX $012f
c105 2901       AND #$01
c107 f005       BEQ c10e
c109 a901       LDA #$01
c10b 95ba       STA $ba, X
c10d 60         RTS
c10e a902       LDA #$02
c110 95ba       STA $ba, X
c112 60         RTS
c113 b5ba       LDA $ba, X
c115 c901       CMP #$01
c117 d023       BNE c13c
c119 f6b7       INC $b7, X
c11b 20         JSR
c11c fec1b0     INC $b0c1, X
c11f 08         PHP
c120 a900       LDA #$00
c122 95ba       STA $ba, X
c124 20         JSR
c125 a9c2       LDA #$c2
c127 60         RTS
c128 d6b7       DEC $b7, X
c12a d6ae       DEC $ae, X
c12c 20         JSR
c12d c4c1       CPY $c1
c12f b004       BCS c135
c131 20         JSR
c132 7dc260     ADC $60c2, X
c135 f6ae       INC $ae, X
c137 a902       LDA #$02
c139 95ba       STA $ba, X
c13b 60         RTS
c13c b5ba       LDA $ba, X
c13e c902       CMP #$02
c140 d037       BNE c179
c142 f6ae       INC $ae, X
c144 20         JSR
c145 c4c1       CPY $c1
c147 b004       BCS c14d
c149 20         JSR
c14a 4dc260     EOR $60c2
c14d d6ae       DEC $ae, X
c14f d6b7       DEC $b7, X
c151 20         JSR
c152 fec1b0     INC $b0c1, X
c155 db 04
c156 20         JSR
c157 91c2       STA ($c2), Y
c159 60         RTS
c15a f6b7       INC $b7, X
c15c b5b7       LDA $b7, X
c15e c910       CMP #$10
c160 f012       BEQ c174
c162 8e2f01     STX $012f
c165 20         JSR
c166 db 9b
c167 db 92
c168 ae2f01     LDX $012f
c16b 2901       AND #$01
c16d f005       BEQ c174
c16f a900       LDA #$00
c171 95ba       STA $ba, X
c173 60         RTS
c174 a903       LDA #$03
c176 95ba       STA $ba, X
c178 60         RTS
c179 b5ba       LDA $ba, X
c17b c903       CMP #$03
c17d d023       BNE c1a2
c17f d6b7       DEC $b7, X
c181 20         JSR
c182 fec1b0     INC $b0c1, X
c185 08         PHP
c186 a902       LDA #$02
c188 95ba       STA $ba, X
c18a 20         JSR
c18b 91c2       STA ($c2), Y
c18d 60         RTS
c18e f6b7       INC $b7, X
c190 d6ae       DEC $ae, X
c192 20         JSR
c193 c4c1       CPY $c1
c195 b004       BCS c19b
c197 20         JSR
c198 7dc260     ADC $60c2, X
c19b f6ae       INC $ae, X
c19d a900       LDA #$00
c19f 95ba       STA $ba, X
c1a1 60         RTS
c1a2 b5ba       LDA $ba, X
c1a4 c904       CMP #$04
c1a6 d015       BNE c1bd
c1a8 b5aa       LDA $aa, X
c1aa c900       CMP #$00
c1ac f00f       BEQ c1bd
c1ae d6aa       DEC $aa, X
c1b0 d6ae       DEC $ae, X
c1b2 20         JSR
c1b3 c4c1       CPY $c1
c1b5 b004       BCS c1bb
c1b7 20         JSR
c1b8 7dc260     ADC $60c2, X
c1bb f6ae       INC $ae, X
c1bd a900       LDA #$00
c1bf 95ba       STA $ba, X
c1c1 95aa       STA $aa, X
c1c3 60         RTS
c1c4 b5ae       LDA $ae, X
c1c6 c90f       CMP #$0f
c1c8 f030       BEQ c1fa
c1ca a000       LDY #$00
c1cc b5ae       LDA $ae, X
c1ce 2907       AND #$07
c1d0 c907       CMP #$07
c1d2 f00a       BEQ c1de
c1d4 a016       LDY #$16
c1d6 b5ae       LDA $ae, X
c1d8 2907       AND #$07
c1da c901       CMP #$01
c1dc d01e       BNE c1fc
c1de 8c3101     STY $0131
c1e1 20         JSR
c1e2 db ff
c1e3 c2ac       DEC #$ac
c1e5 3101       AND ($01), Y
c1e7 b186       LDA ($86), Y
c1e9 c900       CMP #$00
c1eb d00d       BNE c1fa
c1ed b5b7       LDA $b7, X
c1ef 290f       AND #$0f
c1f1 f009       BEQ c1fc
c1f3 c8         INY
c1f4 b186       LDA ($86), Y
c1f6 c900       CMP #$00
c1f8 f002       BEQ c1fc
c1fa 38         SEC
c1fb 60         RTS
c1fc 18         CLC
c1fd 60         RTS
c1fe b5b7       LDA $b7, X
c200 c910       CMP #$10
c202 9004       BCC c208
c204 c9b1       CMP #$b1
c206 9002       BCC c20a
c208 38         SEC
c209 60         RTS
c20a a000       LDY #$00
c20c b5b7       LDA $b7, X
c20e 290f       AND #$0f
c210 c90f       CMP #$0f
c212 f00a       BEQ c21e
c214 a001       LDY #$01
c216 b5b7       LDA $b7, X
c218 290f       AND #$0f
c21a c901       CMP #$01
c21c d02d       BNE c24b
c21e 8c3101     STY $0131
c221 20         JSR
c222 db ff
c223 c2ac       DEC #$ac
c225 3101       AND ($01), Y
c227 b186       LDA ($86), Y
c229 c900       CMP #$00
c22b d01c       BNE c249
c22d 18         CLC
c22e 98         TYA
c22f 690b       ADC #$0b
c231 a8         TAY
c232 b186       LDA ($86), Y
c234 c900       CMP #$00
c236 d011       BNE c249
c238 b5ae       LDA $ae, X
c23a 2907       AND #$07
c23c f00d       BEQ c24b
c23e 18         CLC
c23f 98         TYA
c240 690b       ADC #$0b
c242 a8         TAY
c243 b186       LDA ($86), Y
c245 c900       CMP #$00
c247 f002       BEQ c24b
c249 38         SEC
c24a 60         RTS
c24b 18         CLC
c24c 60         RTS
c24d 20         JSR
c24e bdc290     LDA $90c2, X
c251 29b5       AND #$b5
c253 aed9ae     LDX $aed9
c256 00         BRK
c257 b022       BCS c27b
c259 8a         STX
c25a 48         PHA
c25b 20         JSR
c25c db 9b
c25d db 92
c25e 2903       AND #$03
c260 c900       CMP #$00
c262 f00b       BEQ c26f
c264 c902       CMP #$02
c266 f007       BEQ c26f
c268 a8         TAY
c269 68         PLA
c26a aa         LDX
c26b 94ba       STY $ba, X
c26d 38         SEC
c26e 60         RTS
c26f 68         PLA
c270 aa         LDX
c271 a904       LDA #$04
c273 95ba       STA $ba, X
c275 a920       LDA #$20
c277 95aa       STA $aa, X
c279 38         SEC
c27a 60         RTS
c27b 18         CLC
c27c 60         RTS
c27d 20         JSR
c27e bdc290     LDA $90c2, X
c281 0db5ae     ORA $aeb5
c284 d9ae00     CMP $00ae, Y
c287 9006       BCC c28f
c289 a900       LDA #$00
c28b 95ba       STA $ba, X
c28d 38         SEC
c28e 60         RTS
c28f 18         CLC
c290 60         RTS
c291 20         JSR
c292 bdc290     LDA $90c2, X
c295 11b5       ORA ($b5), Y
c297 db b7
c298 d9b700     CMP $00b7, Y
c29b 900a       BCC c2a7
c29d a904       LDA #$04
c29f 95ba       STA $ba, X
c2a1 a920       LDA #$20
c2a3 95aa       STA $aa, X
c2a5 38         SEC
c2a6 60         RTS
c2a7 18         CLC
c2a8 60         RTS
c2a9 20         JSR
c2aa bdc290     LDA $90c2, X
c2ad 0db5b7     ORA $b7b5
c2b0 d9b700     CMP $00b7, Y
c2b3 b006       BCS c2bb
c2b5 a902       LDA #$02
c2b7 95ba       STA $ba, X
c2b9 38         SEC
c2ba 60         RTS
c2bb 18         CLC
c2bc 60         RTS
c2bd a000       LDY #$00
c2bf 8c3101     STY $0131
c2c2 ec3101     CPX $0131
c2c5 f031       BEQ c2f8
c2c7 b99500     LDA $0095, Y
c2ca c900       CMP #$00
c2cc f02a       BEQ c2f8
c2ce 18         CLC
c2cf b9b700     LDA $00b7, Y
c2d2 690f       ADC #$0f
c2d4 d5b7       CMP $b7, X
c2d6 9020       BCC c2f8
c2d8 18         CLC
c2d9 b5b7       LDA $b7, X
c2db 690f       ADC #$0f
c2dd d9b700     CMP $00b7, Y
c2e0 9016       BCC c2f8
c2e2 b9ae00     LDA $00ae, Y
c2e5 18         CLC
c2e6 690f       ADC #$0f
c2e8 d5ae       CMP $ae, X
c2ea 900c       BCC c2f8
c2ec b5ae       LDA $ae, X
c2ee 18         CLC
c2ef 690f       ADC #$0f
c2f1 d9ae00     CMP $00ae, Y
c2f4 9002       BCC c2f8
c2f6 38         SEC
c2f7 60         RTS
c2f8 c8         INY
c2f9 c003       CPY #$03
c2fb d0c2       BNE c2bf
c2fd 18         CLC
c2fe 60         RTS
c2ff a584       LDA $84
c301 8586       STA $86
c303 a585       LDA $85
c305 8587       STA $87
c307 38         SEC
c308 b5ae       LDA $ae, X
c30a e910       SBC #$10
c30c 4a         LSR
c30d 4a         LSR
c30e 4a         LSR
c30f 8d3201     STA $0132
c312 0a         ASL
c313 0a         ASL
c314 18         CLC
c315 6d3201     ADC $0132
c318 0a         ASL
c319 18         CLC
c31a 6d3201     ADC $0132
c31d 8d3201     STA $0132
c320 38         SEC
c321 b5b7       LDA $b7, X
c323 e910       SBC #$10
c325 4a         LSR
c326 4a         LSR
c327 4a         LSR
c328 4a         LSR
c329 18         CLC
c32a 6d3201     ADC $0132
c32d 18         CLC
c32e 6586       ADC $86
c330 8586       STA $86
c332 a587       LDA $87
c334 6900       ADC #$00
c336 8587       STA $87
c338 60         RTS
c339 a000       LDY #$00
c33b a595       LDA $95
c33d c900       CMP #$00
c33f f021       BEQ c362
c341 a5d5       LDA $d5
c343 c900       CMP #$00
c345 f005       BEQ c34c
c347 c6d5       DEC $d5
c349 4c62c3     JMP $c362
c34c a90a       LDA #$0a
c34e 85d5       STA $d5
c350 e6d2       INC $d2
c352 a4d2       LDY $d2
c354 b1c6       LDA ($c6), Y
c356 c9ff       CMP #$ff
c358 d006       BNE c360
c35a a000       LDY #$00
c35c 84d2       STY $d2
c35e b1c6       LDA ($c6), Y
c360 85b1       STA $b1
c362 a596       LDA $96
c364 c900       CMP #$00
c366 f021       BEQ c389
c368 a5d6       LDA $d6
c36a c900       CMP #$00
c36c f005       BEQ c373
c36e c6d6       DEC $d6
c370 4c89c3     JMP $c389
c373 a906       LDA #$06
c375 85d6       STA $d6
c377 e6d3       INC $d3
c379 a4d3       LDY $d3
c37b b1c8       LDA ($c8), Y
c37d c9ff       CMP #$ff
c37f d006       BNE c387
c381 a000       LDY #$00
c383 84d3       STY $d3
c385 b1c8       LDA ($c8), Y
c387 85b2       STA $b2
c389 a597       LDA $97
c38b c900       CMP #$00
c38d f021       BEQ c3b0
c38f a5d7       LDA $d7
c391 c900       CMP #$00
c393 f005       BEQ c39a
c395 c6d7       DEC $d7
c397 4cb0c3     JMP $c3b0
c39a a906       LDA #$06
c39c 85d7       STA $d7
c39e e6d4       INC $d4
c3a0 a4d4       LDY $d4
c3a2 b1ca       LDA ($ca), Y
c3a4 c9ff       CMP #$ff
c3a6 d006       BNE c3ae
c3a8 a000       LDY #$00
c3aa 84d4       STY $d4
c3ac b1ca       LDA ($ca), Y
c3ae 85b3       STA $b3
c3b0 60         RTS
c3b1 a200       LDX #$00
c3b3 b498       LDY $98, X
c3b5 c000       CPY #$00
c3b7 f03d       BEQ c3f6
c3b9 b5d5       LDA $d5, X
c3bb c900       CMP #$00
c3bd f005       BEQ c3c4
c3bf d6d5       DEC $d5, X
c3c1 4cf6c3     JMP $c3f6
c3c4 c001       CPY #$01
c3c6 d016       BNE c3de
c3c8 ad0e01     LDA $010e
c3cb d011       BNE c3de
c3cd 8c3101     STY $0131
c3d0 8e3201     STX $0132
c3d3 a909       LDA #$09
c3d5 20         JSR
c3d6 c6f3       DEC $f3
c3d8 ac3101     LDY $0131
c3db ae3201     LDX $0132
c3de a906       LDA #$06
c3e0 95d5       STA $d5, X
c3e2 f698       INC $98, X
c3e4 88         DEY
c3e5 b9fcc3     LDA $c3fc, Y
c3e8 95b1       STA $b1, X
c3ea c900       CMP #$00
c3ec d008       BNE c3f6
c3ee a9f0       LDA #$f0
c3f0 95ae       STA $ae, X
c3f2 a900       LDA #$00
c3f4 9598       STA $98, X
c3f6 e8         INX
c3f7 e003       CPX #$03
c3f9 d0b8       BNE c3b3
c3fb 60         RTS
c3fc e0e2       CPX #$e2
c3fe e4e6       CPX $e6
c400 00         BRK
c401 ad2301     LDA $0123
c404 d074       BNE c47a
c406 a50a       LDA $0a
c408 c908       CMP #$08
c40a f004       BEQ c410
c40c c910       CMP #$10
c40e d06a       BNE c47a
c410 ad1101     LDA $0111
c413 c900       CMP #$00
c415 f004       BEQ c41b
c417 ce1101     DEC $0111
c41a 60         RTS
c41b ad0f01     LDA $010f
c41e c900       CMP #$00
c420 f058       BEQ c47a
c422 0a         ASL
c423 0a         ASL
c424 aa         LDX
c425 bd7fc4     LDA $c47f, X
c428 c900       CMP #$00
c42a f04e       BEQ c47a
c42c c9ff       CMP #$ff
c42e d006       BNE c436
c430 a900       LDA #$00
c432 8d0f01     STA $010f
c435 60         RTS
c436 a000       LDY #$00
c438 ad1001     LDA $0110
c43b c900       CMP #$00
c43d f002       BEQ c441
c43f a002       LDY #$02
c441 a906       LDA #$06
c443 8d0120     STA $2001 ; PPU Control Register 2
c446 b97bc4     LDA $c47b, Y
c449 8d0620     STA $2006 ; PPU Memory Address
c44c b97cc4     LDA $c47c, Y
c44f 8d0620     STA $2006 ; PPU Memory Address
c452 bd7fc4     LDA $c47f, X
c455 8d0720     STA $2007 ; PPU Memory Data
c458 bd80c4     LDA $c480, X
c45b 8d0720     STA $2007 ; PPU Memory Data
c45e bd81c4     LDA $c481, X
c461 8d0720     STA $2007 ; PPU Memory Data
c464 a900       LDA #$00
c466 8d0520     STA $2005 ; Background Scroll
c469 8d0520     STA $2005 ; Background Scroll
c46c a515       LDA $15
c46e 8d0120     STA $2001 ; PPU Control Register 2
c471 bd82c4     LDA $c482, X
c474 8d1101     STA $0111
c477 ee0f01     INC $010f
c47a 60         RTS
c47b 20         JSR
c47c 2620       ROL $20
c47e 3100       AND ($00), Y
c480 00         BRK
c481 00         BRK
c482 00         BRK
c483 9091       BCC c416
c485 db 92
c486 08         PHP
c487 a0a1       LDY #$a1
c489 a208       LDX #$08
c48b 2d2d2d     AND $2d2d ; Background Scroll
c48e 08         PHP
c48f 2d2d2d     AND $2d2d ; Background Scroll
c492 0200       ASL #$00
c494 00         BRK
c495 00         BRK
c496 00         BRK
c497 00         BRK
c498 00         BRK
c499 00         BRK
c49a 00         BRK
c49b a0a1       LDY #$a1
c49d a208       LDX #$08
c49f 9091       BCC c432
c4a1 db 92
c4a2 08         PHP
c4a3 8081       STY #$81
c4a5 8210       STX #$10
c4a7 db ff
c4a8 a200       LDX #$00
c4aa a000       LDY #$00
c4ac a581       LDA $81
c4ae c900       CMP #$00
c4b0 f008       BEQ c4ba
c4b2 b99500     LDA $0095, Y
c4b5 199800     ORA $0098, Y
c4b8 d005       BNE c4bf
c4ba a9f0       LDA #$f0
c4bc 99ae00     STA $00ae, Y
c4bf b9ae00     LDA $00ae, Y
c4c2 9d9c02     STA $029c, X
c4c5 b9b100     LDA $00b1, Y
c4c8 9d9d02     STA $029d, X
c4cb b9b400     LDA $00b4, Y
c4ce 9d9e02     STA $029e, X
c4d1 b9b700     LDA $00b7, Y
c4d4 9d9f02     STA $029f, X
c4d7 b9ae00     LDA $00ae, Y
c4da 18         CLC
c4db 6900       ADC #$00
c4dd 9da002     STA $02a0, X
c4e0 b9b100     LDA $00b1, Y
c4e3 18         CLC
c4e4 6901       ADC #$01
c4e6 9da102     STA $02a1, X
c4e9 b9b400     LDA $00b4, Y
c4ec 9da202     STA $02a2, X
c4ef b9b700     LDA $00b7, Y
c4f2 18         CLC
c4f3 6908       ADC #$08
c4f5 9da302     STA $02a3, X
c4f8 b9ae00     LDA $00ae, Y
c4fb 18         CLC
c4fc 6908       ADC #$08
c4fe 9da402     STA $02a4, X
c501 b9b100     LDA $00b1, Y
c504 18         CLC
c505 6910       ADC #$10
c507 9da502     STA $02a5, X
c50a b9b400     LDA $00b4, Y
c50d 9da602     STA $02a6, X
c510 b9b700     LDA $00b7, Y
c513 18         CLC
c514 6900       ADC #$00
c516 9da702     STA $02a7, X
c519 b9ae00     LDA $00ae, Y
c51c 18         CLC
c51d 6908       ADC #$08
c51f 9da802     STA $02a8, X
c522 b9b100     LDA $00b1, Y
c525 18         CLC
c526 6911       ADC #$11
c528 9da902     STA $02a9, X
c52b b9b400     LDA $00b4, Y
c52e 9daa02     STA $02aa, X
c531 b9b700     LDA $00b7, Y
c534 18         CLC
c535 6908       ADC #$08
c537 9dab02     STA $02ab, X
c53a b99800     LDA $0098, Y
c53d c902       CMP #$02
c53f 900e       BCC c54f
c541 a902       LDA #$02
c543 9d9e02     STA $029e, X
c546 9da202     STA $02a2, X
c549 9da602     STA $02a6, X
c54c 9daa02     STA $02aa, X
c54f b9b100     LDA $00b1, Y
c552 2901       AND #$01
c554 f02c       BEQ c582
c556 dea102     DEC $02a1, X
c559 dea102     DEC $02a1, X
c55c dea902     DEC $02a9, X
c55f dea902     DEC $02a9, X
c562 bd9e02     LDA $029e, X
c565 0940       ORA #$40
c567 9d9e02     STA $029e, X
c56a bda202     LDA $02a2, X
c56d 0940       ORA #$40
c56f 9da202     STA $02a2, X
c572 bda602     LDA $02a6, X
c575 0940       ORA #$40
c577 9da602     STA $02a6, X
c57a bdaa02     LDA $02aa, X
c57d 0940       ORA #$40
c57f 9daa02     STA $02aa, X
c582 8a         STX
c583 18         CLC
c584 6910       ADC #$10
c586 aa         LDX
c587 c8         INY
c588 c003       CPY #$03
c58a f003       BEQ c58f
c58c 4cacc4     JMP $c4ac
c58f 60         RTS
c590 60         RTS
c591 6264       ROR #$64
c593 6668       ROR $68
c595 6a         ROR
c596 6c6eff     JMP (ABS) $ff6e
c599 db ff
c59a 8082       STY #$82
c59c 8486       STY $86
c59e 8183       STA ($83, X)
c5a0 85ff       STA $ff
c5a2 db ff
c5a3 db ff
c5a4 a6a8       LDX $a8
c5a6 aa         LDX
c5a7 acaec0     LDY $c0ae
c5aa db ff
c5ab db ff
c5ac db ff
c5ad db ff
c5ae 88         DEY
c5af 8a         STX
c5b0 8c8ea0     STY $a08e
c5b3 8d888a     STA $8a88
c5b6 8c8ea0     STY $a08e
c5b9 8da2a4     STA $a4a2
c5bc a4a2       LDY $a2
c5be a0ff       LDY #$ff
c5c0 db ff
c5c1 db ff
c5c2 ca         DEC
c5c3 c50a       CMP $0a
c5c5 c64a       DEC $4a
c5c7 c68a       DEC $8a
c5c9 c602       DEC $02
c5cb 00         BRK
c5cc 02ff       ASL #$ff
c5ce 0200       ASL #$00
c5d0 02ff       ASL #$ff
c5d2 0200       ASL #$00
c5d4 02ff       ASL #$ff
c5d6 02ff       ASL #$ff
c5d8 02ff       ASL #$ff
c5da 02ff       ASL #$ff
c5dc 02fe       ASL #$fe
c5de 02fe       ASL #$fe
c5e0 02fe       ASL #$fe
c5e2 02fd       ASL #$fd
c5e4 02fd       ASL #$fd
c5e6 01fd       ORA ($fd, X)
c5e8 01fe       ORA ($fe, X)
c5ea 01fd       ORA ($fd, X)
c5ec 01fc       ORA ($fc, X)
c5ee db ff
c5ef fdfffd     SBC $fdff, X
c5f2 fefdfe     INC $fefd, X
c5f5 fdfefd     SBC $fdfe, X
c5f8 fefefe     INC $fefe, X
c5fb fefeff     INC $fffe, X
c5fe fefffe     INC $feff, X
c601 db ff
c602 fefffe     INC $feff, X
c605 00         BRK
c606 feff80     INC $80ff, X
c609 00         BRK
c60a 0200       ASL #$00
c60c 02ff       ASL #$ff
c60e 0200       ASL #$00
c610 02ff       ASL #$ff
c612 0200       ASL #$00
c614 02ff       ASL #$ff
c616 02ff       ASL #$ff
c618 02ff       ASL #$ff
c61a 02ff       ASL #$ff
c61c 02fe       ASL #$fe
c61e 02fe       ASL #$fe
c620 02fe       ASL #$fe
c622 02fd       ASL #$fd
c624 02fd       ASL #$fd
c626 01fd       ORA ($fd, X)
c628 01fe       ORA ($fe, X)
c62a 01fd       ORA ($fd, X)
c62c 01fc       ORA ($fc, X)
c62e db ff
c62f fdfffd     SBC $fdff, X
c632 fefdfe     INC $fefd, X
c635 fdfefd     SBC $fdfe, X
c638 fefefe     INC $fefe, X
c63b fefeff     INC $fffe, X
c63e fefffe     INC $feff, X
c641 db ff
c642 fefffe     INC $feff, X
c645 00         BRK
c646 feff80     INC $80ff, X
c649 00         BRK
c64a 0200       ASL #$00
c64c 02ff       ASL #$ff
c64e 0200       ASL #$00
c650 02ff       ASL #$ff
c652 0200       ASL #$00
c654 02ff       ASL #$ff
c656 02ff       ASL #$ff
c658 02ff       ASL #$ff
c65a 02ff       ASL #$ff
c65c 02fe       ASL #$fe
c65e 02fe       ASL #$fe
c660 02fe       ASL #$fe
c662 02fd       ASL #$fd
c664 02fd       ASL #$fd
c666 01fd       ORA ($fd, X)
c668 01fe       ORA ($fe, X)
c66a 01fd       ORA ($fd, X)
c66c 01fc       ORA ($fc, X)
c66e db ff
c66f fdfffd     SBC $fdff, X
c672 fefdfe     INC $fefd, X
c675 fdfefd     SBC $fdfe, X
c678 fefefe     INC $fefe, X
c67b fefeff     INC $fffe, X
c67e fefffe     INC $feff, X
c681 db ff
c682 fefffe     INC $feff, X
c685 00         BRK
c686 feff80     INC $80ff, X
c689 00         BRK
c68a 0200       ASL #$00
c68c 02ff       ASL #$ff
c68e 0200       ASL #$00
c690 02ff       ASL #$ff
c692 0200       ASL #$00
c694 02ff       ASL #$ff
c696 02ff       ASL #$ff
c698 02ff       ASL #$ff
c69a 02ff       ASL #$ff
c69c 02fe       ASL #$fe
c69e 02fe       ASL #$fe
c6a0 02fe       ASL #$fe
c6a2 02fd       ASL #$fd
c6a4 02fd       ASL #$fd
c6a6 01fd       ORA ($fd, X)
c6a8 01fe       ORA ($fe, X)
c6aa 01fd       ORA ($fd, X)
c6ac 01fc       ORA ($fc, X)
c6ae db ff
c6af fdfffd     SBC $fdff, X
c6b2 fefdfe     INC $fefd, X
c6b5 fdfefd     SBC $fdfe, X
c6b8 fefefe     INC $fefe, X
c6bb fefeff     INC $fffe, X
c6be fefffe     INC $feff, X
c6c1 db ff
c6c2 fefffe     INC $feff, X
c6c5 00         BRK
c6c6 feff80     INC $80ff, X
c6c9 00         BRK
c6ca db ff
c6cb db ff
c6cc db ff
c6cd db ff
c6ce db ff
c6cf db ff
c6d0 db ff
c6d1 db ff
c6d2 db ff
c6d3 db ff
c6d4 db ff
c6d5 db ff
c6d6 db ff
c6d7 db ff
c6d8 db ff
c6d9 db ff
c6da db ff
c6db db ff
c6dc db ff
c6dd db ff
c6de db ff
c6df db ff
c6e0 db ff
c6e1 db ff
c6e2 db ff
c6e3 db ff
c6e4 db ff
c6e5 db ff
c6e6 db ff
c6e7 db ff
c6e8 db ff
c6e9 db ff
c6ea db ff
c6eb db ff
c6ec db ff
c6ed db ff
c6ee db ff
c6ef db ff
c6f0 db ff
c6f1 db ff
c6f2 db ff
c6f3 db ff
c6f4 db ff
c6f5 db ff
c6f6 db ff
c6f7 db ff
c6f8 db ff
c6f9 db ff
c6fa db ff
c6fb db ff
c6fc db ff
c6fd db ff
c6fe db ff
c6ff db ff
c700 db ff
c701 db ff
c702 db ff
c703 db ff
c704 db ff
c705 db ff
c706 db ff
c707 db ff
c708 db ff
c709 db ff
c70a db ff
c70b db ff
c70c db ff
c70d db ff
c70e db ff
c70f db ff
c710 db ff
c711 db ff
c712 db ff
c713 db ff
c714 db ff
c715 db ff
c716 db ff
c717 db ff
c718 db ff
c719 db ff
c71a db ff
c71b db ff
c71c db ff
c71d db ff
c71e db ff
c71f db ff
c720 db ff
c721 db ff
c722 db ff
c723 db ff
c724 db ff
c725 db ff
c726 db ff
c727 db ff
c728 db ff
c729 db ff
c72a db ff
c72b db ff
c72c db ff
c72d db ff
c72e db ff
c72f db ff
c730 db ff
c731 db ff
c732 db ff
c733 db ff
c734 db ff
c735 db ff
c736 db ff
c737 db ff
c738 db ff
c739 db ff
c73a db ff
c73b db ff
c73c db ff
c73d db ff
c73e db ff
c73f db ff
c740 db ff
c741 db ff
c742 db ff
c743 db ff
c744 db ff
c745 db ff
c746 db ff
c747 db ff
c748 db ff
c749 db ff
c74a db ff
c74b db ff
c74c db ff
c74d db ff
c74e db ff
c74f db ff
c750 db ff
c751 db ff
c752 db ff
c753 db ff
c754 db ff
c755 db ff
c756 db ff
c757 db ff
c758 db ff
c759 db ff
c75a db ff
c75b db ff
c75c db ff
c75d db ff
c75e db ff
c75f db ff
c760 db ff
c761 db ff
c762 db ff
c763 db ff
c764 db ff
c765 db ff
c766 db ff
c767 db ff
c768 db ff
c769 db ff
c76a db ff
c76b db ff
c76c db ff
c76d db ff
c76e db ff
c76f db ff
c770 db ff
c771 db ff
c772 db ff
c773 db ff
c774 db ff
c775 db ff
c776 db ff
c777 db ff
c778 db ff
c779 db ff
c77a db ff
c77b db ff
c77c db ff
c77d db ff
c77e db ff
c77f db ff
c780 db ff
c781 db ff
c782 db ff
c783 db ff
c784 db ff
c785 db ff
c786 db ff
c787 db ff
c788 db ff
c789 db ff
c78a db ff
c78b db ff
c78c db ff
c78d db ff
c78e db ff
c78f db ff
c790 db ff
c791 db ff
c792 db ff
c793 db ff
c794 db ff
c795 db ff
c796 db ff
c797 db ff
c798 db ff
c799 db ff
c79a db ff
c79b db ff
c79c db ff
c79d db ff
c79e db ff
c79f db ff
c7a0 db ff
c7a1 db ff
c7a2 db ff
c7a3 db ff
c7a4 db ff
c7a5 db ff
c7a6 db ff
c7a7 db ff
c7a8 db ff
c7a9 db ff
c7aa db ff
c7ab db ff
c7ac db ff
c7ad db ff
c7ae db ff
c7af db ff
c7b0 db ff
c7b1 db ff
c7b2 db ff
c7b3 db ff
c7b4 db ff
c7b5 db ff
c7b6 db ff
c7b7 db ff
c7b8 db ff
c7b9 db ff
c7ba db ff
c7bb db ff
c7bc db ff
c7bd db ff
c7be db ff
c7bf db ff
c7c0 db ff
c7c1 db ff
c7c2 db ff
c7c3 db ff
c7c4 db ff
c7c5 db ff
c7c6 db ff
c7c7 db ff
c7c8 db ff
c7c9 db ff
c7ca db ff
c7cb db ff
c7cc db ff
c7cd db ff
c7ce db ff
c7cf db ff
c7d0 db ff
c7d1 db ff
c7d2 db ff
c7d3 db ff
c7d4 db ff
c7d5 db ff
c7d6 db ff
c7d7 db ff
c7d8 db ff
c7d9 db ff
c7da db ff
c7db db ff
c7dc db ff
c7dd db ff
c7de db ff
c7df db ff
c7e0 db ff
c7e1 db ff
c7e2 db ff
c7e3 db ff
c7e4 db ff
c7e5 db ff
c7e6 db ff
c7e7 db ff
c7e8 db ff
c7e9 db ff
c7ea db ff
c7eb db ff
c7ec db ff
c7ed db ff
c7ee db ff
c7ef db ff
c7f0 db ff
c7f1 db ff
c7f2 db ff
c7f3 db ff
c7f4 db ff
c7f5 db ff
c7f6 db ff
c7f7 db ff
c7f8 db ff
c7f9 db ff
c7fa db ff
c7fb db ff
c7fc db ff
c7fd db ff
c7fe db ff
c7ff db ff
c800 db ff
c801 db ff
c802 db ff
c803 db ff
c804 db ff
c805 db ff
c806 db ff
c807 db ff
c808 db ff
c809 db ff
c80a db ff
c80b db ff
c80c db ff
c80d db ff
c80e db ff
c80f db ff
c810 db ff
c811 db ff
c812 db ff
c813 db ff
c814 db ff
c815 db ff
c816 db ff
c817 db ff
c818 db ff
c819 db ff
c81a db ff
c81b db ff
c81c db ff
c81d db ff
c81e db ff
c81f db ff
c820 db ff
c821 db ff
c822 db ff
c823 db ff
c824 db ff
c825 db ff
c826 db ff
c827 db ff
c828 db ff
c829 db ff
c82a db ff
c82b db ff
c82c db ff
c82d db ff
c82e db ff
c82f db ff
c830 db ff
c831 db ff
c832 db ff
c833 db ff
c834 db ff
c835 db ff
c836 db ff
c837 db ff
c838 db ff
c839 db ff
c83a db ff
c83b db ff
c83c db ff
c83d db ff
c83e db ff
c83f db ff
c840 db ff
c841 db ff
c842 db ff
c843 db ff
c844 db ff
c845 db ff
c846 db ff
c847 db ff
c848 db ff
c849 db ff
c84a db ff
c84b db ff
c84c db ff
c84d db ff
c84e db ff
c84f db ff
c850 db ff
c851 db ff
c852 db ff
c853 db ff
c854 db ff
c855 db ff
c856 db ff
c857 db ff
c858 db ff
c859 db ff
c85a db ff
c85b db ff
c85c db ff
c85d db ff
c85e db ff
c85f db ff
c860 db ff
c861 db ff
c862 db ff
c863 db ff
c864 db ff
c865 db ff
c866 db ff
c867 db ff
c868 db ff
c869 db ff
c86a db ff
c86b db ff
c86c db ff
c86d db ff
c86e db ff
c86f db ff
c870 db ff
c871 db ff
c872 db ff
c873 db ff
c874 db ff
c875 db ff
c876 db ff
c877 db ff
c878 db ff
c879 db ff
c87a db ff
c87b db ff
c87c db ff
c87d db ff
c87e db ff
c87f db ff
c880 db ff
c881 db ff
c882 db ff
c883 db ff
c884 db ff
c885 db ff
c886 db ff
c887 db ff
c888 db ff
c889 db ff
c88a db ff
c88b db ff
c88c db ff
c88d db ff
c88e db ff
c88f db ff
c890 db ff
c891 db ff
c892 db ff
c893 db ff
c894 db ff
c895 db ff
c896 db ff
c897 db ff
c898 db ff
c899 db ff
c89a db ff
c89b db ff
c89c db ff
c89d db ff
c89e db ff
c89f db ff
c8a0 db ff
c8a1 db ff
c8a2 db ff
c8a3 db ff
c8a4 db ff
c8a5 db ff
c8a6 db ff
c8a7 db ff
c8a8 db ff
c8a9 db ff
c8aa db ff
c8ab db ff
c8ac db ff
c8ad db ff
c8ae db ff
c8af db ff
c8b0 db ff
c8b1 db ff
c8b2 db ff
c8b3 db ff
c8b4 db ff
c8b5 db ff
c8b6 db ff
c8b7 db ff
c8b8 db ff
c8b9 db ff
c8ba db ff
c8bb db ff
c8bc db ff
c8bd db ff
c8be db ff
c8bf db ff
c8c0 db ff
c8c1 db ff
c8c2 db ff
c8c3 db ff
c8c4 db ff
c8c5 db ff
c8c6 db ff
c8c7 db ff
c8c8 db ff
c8c9 db ff
c8ca db ff
c8cb db ff
c8cc db ff
c8cd db ff
c8ce db ff
c8cf db ff
c8d0 db ff
c8d1 db ff
c8d2 db ff
c8d3 db ff
c8d4 db ff
c8d5 db ff
c8d6 db ff
c8d7 db ff
c8d8 db ff
c8d9 db ff
c8da db ff
c8db db ff
c8dc db ff
c8dd db ff
c8de db ff
c8df db ff
c8e0 db ff
c8e1 db ff
c8e2 db ff
c8e3 db ff
c8e4 db ff
c8e5 db ff
c8e6 db ff
c8e7 db ff
c8e8 db ff
c8e9 db ff
c8ea db ff
c8eb db ff
c8ec db ff
c8ed db ff
c8ee db ff
c8ef db ff
c8f0 db ff
c8f1 db ff
c8f2 db ff
c8f3 db ff
c8f4 db ff
c8f5 db ff
c8f6 db ff
c8f7 db ff
c8f8 db ff
c8f9 db ff
c8fa db ff
c8fb db ff
c8fc db ff
c8fd db ff
c8fe db ff
c8ff db ff
c900 db ff
c901 db ff
c902 db ff
c903 db ff
c904 db ff
c905 db ff
c906 db ff
c907 db ff
c908 db ff
c909 db ff
c90a db ff
c90b db ff
c90c db ff
c90d db ff
c90e db ff
c90f db ff
c910 db ff
c911 db ff
c912 db ff
c913 db ff
c914 db ff
c915 db ff
c916 db ff
c917 db ff
c918 db ff
c919 db ff
c91a db ff
c91b db ff
c91c db ff
c91d db ff
c91e db ff
c91f db ff
c920 db ff
c921 db ff
c922 db ff
c923 db ff
c924 db ff
c925 db ff
c926 db ff
c927 db ff
c928 db ff
c929 db ff
c92a db ff
c92b db ff
c92c db ff
c92d db ff
c92e db ff
c92f db ff
c930 db ff
c931 db ff
c932 db ff
c933 db ff
c934 db ff
c935 db ff
c936 db ff
c937 db ff
c938 db ff
c939 db ff
c93a db ff
c93b db ff
c93c db ff
c93d db ff
c93e db ff
c93f db ff
c940 db ff
c941 db ff
c942 db ff
c943 db ff
c944 db ff
c945 db ff
c946 db ff
c947 db ff
c948 db ff
c949 db ff
c94a db ff
c94b db ff
c94c db ff
c94d db ff
c94e db ff
c94f db ff
c950 db ff
c951 db ff
c952 db ff
c953 db ff
c954 db ff
c955 db ff
c956 db ff
c957 db ff
c958 db ff
c959 db ff
c95a db ff
c95b db ff
c95c db ff
c95d db ff
c95e db ff
c95f db ff
c960 db ff
c961 db ff
c962 db ff
c963 db ff
c964 db ff
c965 db ff
c966 db ff
c967 db ff
c968 db ff
c969 db ff
c96a db ff
c96b db ff
c96c db ff
c96d db ff
c96e db ff
c96f db ff
c970 db ff
c971 db ff
c972 db ff
c973 db ff
c974 db ff
c975 db ff
c976 db ff
c977 db ff
c978 db ff
c979 db ff
c97a db ff
c97b db ff
c97c db ff
c97d db ff
c97e db ff
c97f db ff
c980 db ff
c981 db ff
c982 db ff
c983 db ff
c984 db ff
c985 db ff
c986 db ff
c987 db ff
c988 db ff
c989 db ff
c98a db ff
c98b db ff
c98c db ff
c98d db ff
c98e db ff
c98f db ff
c990 db ff
c991 db ff
c992 db ff
c993 db ff
c994 db ff
c995 db ff
c996 db ff
c997 db ff
c998 db ff
c999 db ff
c99a db ff
c99b db ff
c99c db ff
c99d db ff
c99e db ff
c99f db ff
c9a0 db ff
c9a1 db ff
c9a2 db ff
c9a3 db ff
c9a4 db ff
c9a5 db ff
c9a6 db ff
c9a7 db ff
c9a8 db ff
c9a9 db ff
c9aa db ff
c9ab db ff
c9ac db ff
c9ad db ff
c9ae db ff
c9af db ff
c9b0 db ff
c9b1 db ff
c9b2 db ff
c9b3 db ff
c9b4 db ff
c9b5 db ff
c9b6 db ff
c9b7 db ff
c9b8 db ff
c9b9 db ff
c9ba db ff
c9bb db ff
c9bc db ff
c9bd db ff
c9be db ff
c9bf db ff
c9c0 db ff
c9c1 db ff
c9c2 db ff
c9c3 db ff
c9c4 db ff
c9c5 db ff
c9c6 db ff
c9c7 db ff
c9c8 db ff
c9c9 db ff
c9ca db ff
c9cb db ff
c9cc db ff
c9cd db ff
c9ce db ff
c9cf db ff
c9d0 db ff
c9d1 db ff
c9d2 db ff
c9d3 db ff
c9d4 db ff
c9d5 db ff
c9d6 db ff
c9d7 db ff
c9d8 db ff
c9d9 db ff
c9da db ff
c9db db ff
c9dc db ff
c9dd db ff
c9de db ff
c9df db ff
c9e0 db ff
c9e1 db ff
c9e2 db ff
c9e3 db ff
c9e4 db ff
c9e5 db ff
c9e6 db ff
c9e7 db ff
c9e8 db ff
c9e9 db ff
c9ea db ff
c9eb db ff
c9ec db ff
c9ed db ff
c9ee db ff
c9ef db ff
c9f0 db ff
c9f1 db ff
c9f2 db ff
c9f3 db ff
c9f4 db ff
c9f5 db ff
c9f6 db ff
c9f7 db ff
c9f8 db ff
c9f9 db ff
c9fa db ff
c9fb db ff
c9fc db ff
c9fd db ff
c9fe db ff
c9ff db ff
ca00 db ff
ca01 db ff
ca02 db ff
ca03 db ff
ca04 db ff
ca05 db ff
ca06 db ff
ca07 db ff
ca08 db ff
ca09 db ff
ca0a db ff
ca0b db ff
ca0c db ff
ca0d db ff
ca0e db ff
ca0f db ff
ca10 db ff
ca11 db ff
ca12 db ff
ca13 db ff
ca14 db ff
ca15 db ff
ca16 db ff
ca17 db ff
ca18 db ff
ca19 db ff
ca1a db ff
ca1b db ff
ca1c db ff
ca1d db ff
ca1e db ff
ca1f db ff
ca20 db ff
ca21 db ff
ca22 db ff
ca23 db ff
ca24 db ff
ca25 db ff
ca26 db ff
ca27 db ff
ca28 db ff
ca29 db ff
ca2a db ff
ca2b db ff
ca2c db ff
ca2d db ff
ca2e db ff
ca2f db ff
ca30 db ff
ca31 db ff
ca32 db ff
ca33 db ff
ca34 db ff
ca35 db ff
ca36 db ff
ca37 db ff
ca38 db ff
ca39 db ff
ca3a db ff
ca3b db ff
ca3c db ff
ca3d db ff
ca3e db ff
ca3f db ff
ca40 db ff
ca41 db ff
ca42 db ff
ca43 db ff
ca44 db ff
ca45 db ff
ca46 db ff
ca47 db ff
ca48 db ff
ca49 db ff
ca4a db ff
ca4b db ff
ca4c db ff
ca4d db ff
ca4e db ff
ca4f db ff
ca50 db ff
ca51 db ff
ca52 db ff
ca53 db ff
ca54 db ff
ca55 db ff
ca56 db ff
ca57 db ff
ca58 db ff
ca59 db ff
ca5a db ff
ca5b db ff
ca5c db ff
ca5d db ff
ca5e db ff
ca5f db ff
ca60 db ff
ca61 db ff
ca62 db ff
ca63 db ff
ca64 db ff
ca65 db ff
ca66 db ff
ca67 db ff
ca68 db ff
ca69 db ff
ca6a db ff
ca6b db ff
ca6c db ff
ca6d db ff
ca6e db ff
ca6f db ff
ca70 db ff
ca71 db ff
ca72 db ff
ca73 db ff
ca74 db ff
ca75 db ff
ca76 db ff
ca77 db ff
ca78 db ff
ca79 db ff
ca7a db ff
ca7b db ff
ca7c db ff
ca7d db ff
ca7e db ff
ca7f db ff
ca80 00         BRK
ca81 00         BRK
ca82 00         BRK
ca83 00         BRK
ca84 00         BRK
ca85 00         BRK
ca86 00         BRK
ca87 00         BRK
ca88 00         BRK
ca89 00         BRK
ca8a 00         BRK
ca8b 00         BRK
ca8c 00         BRK
ca8d 00         BRK
ca8e 00         BRK
ca8f 00         BRK
ca90 00         BRK
ca91 00         BRK
ca92 00         BRK
ca93 00         BRK
ca94 00         BRK
ca95 00         BRK
ca96 00         BRK
ca97 00         BRK
ca98 00         BRK
ca99 00         BRK
ca9a 00         BRK
ca9b 00         BRK
ca9c 00         BRK
ca9d 00         BRK
ca9e 00         BRK
ca9f 00         BRK
caa0 00         BRK
caa1 00         BRK
caa2 00         BRK
caa3 00         BRK
caa4 00         BRK
caa5 00         BRK
caa6 00         BRK
caa7 00         BRK
caa8 00         BRK
caa9 00         BRK
caaa 00         BRK
caab 00         BRK
caac e2e2       INC #$e2
caae e2e2       INC #$e2
cab0 e2e2       INC #$e2
cab2 e2e2       INC #$e2
cab4 e2e2       INC #$e2
cab6 e251       INC #$51
cab8 595951     EOR $5159, Y
cabb 595159     EOR $5951, Y
cabe 5159       EOR ($59), Y
cac0 5159       EOR ($59), Y
cac2 8189       STA ($89, X)
cac4 8981       STA #$81
cac6 8989       STA #$89
cac8 8189       STA ($89, X)
caca 8189       STA ($89, X)
cacc 8969       STA #$69
cace 6169       ADC ($69, X)
cad0 6169       ADC ($69, X)
cad2 6169       ADC ($69, X)
cad4 6961       ADC #$61
cad6 6961       ADC #$61
cad8 7179       ADC ($79), Y
cada 7179       ADC ($79), Y
cadc 7179       ADC ($79), Y
cade 797179     ADC $7971, Y
cae1 797149     ADC $4971, Y
cae4 4941       EOR #$41
cae6 4949       EOR #$49
cae8 4141       EOR ($41, X)
caea 4149       EOR ($49, X)
caec 4149       EOR ($49, X)
caee 00         BRK
caef 00         BRK
caf0 00         BRK
caf1 00         BRK
caf2 00         BRK
caf3 00         BRK
caf4 00         BRK
caf5 00         BRK
caf6 00         BRK
caf7 00         BRK
caf8 00         BRK
caf9 00         BRK
cafa 00         BRK
cafb 00         BRK
cafc 00         BRK
cafd 00         BRK
cafe 00         BRK
caff 00         BRK
cb00 00         BRK
cb01 00         BRK
cb02 00         BRK
cb03 00         BRK
cb04 00         BRK
cb05 00         BRK
cb06 00         BRK
cb07 00         BRK
cb08 00         BRK
cb09 00         BRK
cb0a 00         BRK
cb0b 00         BRK
cb0c 00         BRK
cb0d 00         BRK
cb0e 00         BRK
cb0f 00         BRK
cb10 00         BRK
cb11 00         BRK
cb12 00         BRK
cb13 00         BRK
cb14 00         BRK
cb15 00         BRK
cb16 00         BRK
cb17 00         BRK
cb18 00         BRK
cb19 00         BRK
cb1a 00         BRK
cb1b 00         BRK
cb1c 00         BRK
cb1d 00         BRK
cb1e 00         BRK
cb1f 00         BRK
cb20 00         BRK
cb21 00         BRK
cb22 00         BRK
cb23 00         BRK
cb24 00         BRK
cb25 00         BRK
cb26 00         BRK
cb27 00         BRK
cb28 00         BRK
cb29 00         BRK
cb2a 00         BRK
cb2b 00         BRK
cb2c 00         BRK
cb2d 00         BRK
cb2e 00         BRK
cb2f 00         BRK
cb30 00         BRK
cb31 00         BRK
cb32 00         BRK
cb33 00         BRK
cb34 00         BRK
cb35 00         BRK
cb36 00         BRK
cb37 00         BRK
cb38 00         BRK
cb39 00         BRK
cb3a 00         BRK
cb3b 00         BRK
cb3c 00         BRK
cb3d 00         BRK
cb3e 00         BRK
cb3f 00         BRK
cb40 00         BRK
cb41 00         BRK
cb42 00         BRK
cb43 00         BRK
cb44 00         BRK
cb45 00         BRK
cb46 00         BRK
cb47 00         BRK
cb48 00         BRK
cb49 00         BRK
cb4a 00         BRK
cb4b 00         BRK
cb4c 00         BRK
cb4d 00         BRK
cb4e 00         BRK
cb4f 00         BRK
cb50 00         BRK
cb51 00         BRK
cb52 00         BRK
cb53 00         BRK
cb54 00         BRK
cb55 00         BRK
cb56 00         BRK
cb57 00         BRK
cb58 00         BRK
cb59 00         BRK
cb5a 00         BRK
cb5b 00         BRK
cb5c 00         BRK
cb5d 00         BRK
cb5e 00         BRK
cb5f db 0f
cb60 3016       BMI cb78
cb62 100f       BPL cb73
cb64 0110       ORA ($10, X)
cb66 160f       ASL $0f, X
cb68 0111       ORA ($11, X)
cb6a db 27
cb6b db 0f
cb6c 0125       ORA ($25, X)
cb6e 2900       AND #$00
cb70 00         BRK
cb71 00         BRK
cb72 00         BRK
cb73 6e6e6e     ROR $6e6e
cb76 6c6c00     JMP (ABS) $006c
cb79 00         BRK
cb7a 00         BRK
cb7b 00         BRK
cb7c 00         BRK
cb7d 7c0042     JMP (ABS) $4200, X
cb80 00         BRK
cb81 00         BRK
cb82 00         BRK
cb83 00         BRK
cb84 00         BRK
cb85 00         BRK
cb86 00         BRK
cb87 00         BRK
cb88 00         BRK
cb89 00         BRK
cb8a 00         BRK
cb8b 00         BRK
cb8c 00         BRK
cb8d 00         BRK
cb8e 00         BRK
cb8f 00         BRK
cb90 00         BRK
cb91 00         BRK
cb92 00         BRK
cb93 00         BRK
cb94 00         BRK
cb95 00         BRK
cb96 2900       AND #$00
cb98 00         BRK
cb99 00         BRK
cb9a 00         BRK
cb9b 00         BRK
cb9c 00         BRK
cb9d 00         BRK
cb9e 00         BRK
cb9f 00         BRK
cba0 00         BRK
cba1 2131       AND ($31, X)
cba3 00         BRK
cba4 00         BRK
cba5 00         BRK
cba6 00         BRK
cba7 00         BRK
cba8 00         BRK
cba9 00         BRK
cbaa 00         BRK
cbab 00         BRK
cbac 2131       AND ($31, X)
cbae 4100       EOR ($00, X)
cbb0 00         BRK
cbb1 00         BRK
cbb2 00         BRK
cbb3 00         BRK
cbb4 00         BRK
cbb5 00         BRK
cbb6 00         BRK
cbb7 2131       AND ($31, X)
cbb9 4961       EOR #$61
cbbb 00         BRK
cbbc 00         BRK
cbbd 00         BRK
cbbe 00         BRK
cbbf 00         BRK
cbc0 00         BRK
cbc1 00         BRK
cbc2 2939       AND #$39
cbc4 4161       EOR ($61, X)
cbc6 5100       EOR ($00), Y
cbc8 00         BRK
cbc9 00         BRK
cbca 00         BRK
cbcb 00         BRK
cbcc 00         BRK
cbcd 2131       AND ($31, X)
cbcf 4161       EOR ($61, X)
cbd1 5129       EOR ($29), Y
cbd3 00         BRK
cbd4 00         BRK
cbd5 00         BRK
cbd6 00         BRK
cbd7 00         BRK
cbd8 2131       AND ($31, X)
cbda 4169       EOR ($69, X)
cbdc 5121       EOR ($21), Y
cbde 390000     AND $0000, Y
cbe1 00         BRK
cbe2 00         BRK
cbe3 2131       AND ($31, X)
cbe5 4961       EOR #$61
cbe7 5121       EOR ($21), Y
cbe9 3141       AND ($41), Y
cbeb 00         BRK
cbec 00         BRK
cbed 00         BRK
cbee 2931       AND #$31
cbf0 4169       EOR ($69, X)
cbf2 592131     EOR $3121, Y
cbf5 4961       EOR #$61
cbf7 00         BRK
cbf8 00         BRK
cbf9 2131       AND ($31, X)
cbfb 4161       EOR ($61, X)
cbfd 5121       EOR ($21), Y
cbff 3141       AND ($41), Y
cc01 6951       ADC #$51
cc03 00         BRK
cc04 e2e2       INC #$e2
cc06 e2e2       INC #$e2
cc08 e2e2       INC #$e2
cc0a e2e2       INC #$e2
cc0c e2e2       INC #$e2
cc0e 2900       AND #$00
cc10 00         BRK
cc11 00         BRK
cc12 00         BRK
cc13 00         BRK
cc14 00         BRK
cc15 00         BRK
cc16 00         BRK
cc17 00         BRK
cc18 00         BRK
cc19 00         BRK
cc1a 00         BRK
cc1b 00         BRK
cc1c 00         BRK
cc1d 00         BRK
cc1e 00         BRK
cc1f 00         BRK
cc20 00         BRK
cc21 00         BRK
cc22 00         BRK
cc23 00         BRK
cc24 00         BRK
cc25 00         BRK
cc26 00         BRK
cc27 00         BRK
cc28 00         BRK
cc29 00         BRK
cc2a 00         BRK
cc2b 00         BRK
cc2c 00         BRK
cc2d 00         BRK
cc2e 00         BRK
cc2f 00         BRK
cc30 00         BRK
cc31 00         BRK
cc32 00         BRK
cc33 00         BRK
cc34 00         BRK
cc35 00         BRK
cc36 00         BRK
cc37 00         BRK
cc38 00         BRK
cc39 00         BRK
cc3a 00         BRK
cc3b 00         BRK
cc3c 00         BRK
cc3d 00         BRK
cc3e 00         BRK
cc3f 00         BRK
cc40 00         BRK
cc41 00         BRK
cc42 00         BRK
cc43 00         BRK
cc44 00         BRK
cc45 00         BRK
cc46 00         BRK
cc47 00         BRK
cc48 00         BRK
cc49 00         BRK
cc4a 00         BRK
cc4b 00         BRK
cc4c 00         BRK
cc4d 00         BRK
cc4e 00         BRK
cc4f 00         BRK
cc50 00         BRK
cc51 00         BRK
cc52 00         BRK
cc53 00         BRK
cc54 00         BRK
cc55 00         BRK
cc56 00         BRK
cc57 00         BRK
cc58 00         BRK
cc59 00         BRK
cc5a 00         BRK
cc5b 00         BRK
cc5c 00         BRK
cc5d 00         BRK
cc5e 00         BRK
cc5f db 0f
cc60 3016       BMI cc78
cc62 100f       BPL cc73
cc64 0910       ORA #$10
cc66 260f       ROL $0f
cc68 0921       ORA #$21
cc6a 290f       AND #$0f
cc6c 0911       ORA #$11
cc6e 1600       ASL $00, X
cc70 00         BRK
cc71 6e6c6e     ROR $6e6c
cc74 6e6c00     ROR $006c
cc77 00         BRK
cc78 00         BRK
cc79 00         BRK
cc7a 00         BRK
cc7b 00         BRK
cc7c 00         BRK
cc7d 7c0042     JMP (ABS) $4200, X
cc80 00         BRK
cc81 00         BRK
cc82 00         BRK
cc83 00         BRK
cc84 00         BRK
cc85 00         BRK
cc86 00         BRK
cc87 00         BRK
cc88 00         BRK
cc89 00         BRK
cc8a 00         BRK
cc8b 00         BRK
cc8c 00         BRK
cc8d 00         BRK
cc8e 00         BRK
cc8f 00         BRK
cc90 00         BRK
cc91 00         BRK
cc92 00         BRK
cc93 00         BRK
cc94 00         BRK
cc95 00         BRK
cc96 00         BRK
cc97 00         BRK
cc98 00         BRK
cc99 00         BRK
cc9a 00         BRK
cc9b 00         BRK
cc9c 00         BRK
cc9d 00         BRK
cc9e 00         BRK
cc9f 00         BRK
cca0 00         BRK
cca1 4149       EOR ($49, X)
cca3 4149       EOR ($49, X)
cca5 4141       EOR ($41, X)
cca7 4941       EOR #$41
cca9 4141       EOR ($41, X)
ccab 4900       EOR #$00
ccad 00         BRK
ccae 00         BRK
ccaf 00         BRK
ccb0 00         BRK
ccb1 00         BRK
ccb2 00         BRK
ccb3 00         BRK
ccb4 00         BRK
ccb5 00         BRK
ccb6 00         BRK
ccb7 1119       ORA ($19), Y
ccb9 11f0       ORA ($f0), Y
ccbb f0f0       BEQ ccad
ccbd f0f0       BEQ ccaf
ccbf f0f0       BEQ ccb1
ccc1 f000       BEQ ccc3
ccc3 00         BRK
ccc4 00         BRK
ccc5 00         BRK
ccc6 00         BRK
ccc7 00         BRK
ccc8 00         BRK
ccc9 00         BRK
ccca 00         BRK
cccb 00         BRK
cccc 00         BRK
cccd 5151       EOR ($51), Y
cccf 595151     EOR $5151, Y
ccd2 5159       EOR ($59), Y
ccd4 5151       EOR ($51), Y
ccd6 5159       EOR ($59), Y
ccd8 00         BRK
ccd9 00         BRK
ccda 00         BRK
ccdb 00         BRK
ccdc 00         BRK
ccdd 00         BRK
ccde 00         BRK
ccdf 00         BRK
cce0 00         BRK
cce1 00         BRK
cce2 00         BRK
cce3 f0f0       BEQ ccd5
cce5 f0f0       BEQ ccd7
cce7 f0f0       BEQ ccd9
cce9 f0f0       BEQ ccdb
cceb 1111       ORA ($11), Y
cced 1100       ORA ($00), Y
ccef 00         BRK
ccf0 00         BRK
ccf1 00         BRK
ccf2 00         BRK
ccf3 00         BRK
ccf4 00         BRK
ccf5 00         BRK
ccf6 00         BRK
ccf7 00         BRK
ccf8 00         BRK
ccf9 797171     ADC $7171, Y
ccfc 797171     ADC $7171, Y
ccff 797179     ADC $7971, Y
cd02 7171       ADC ($71), Y
cd04 00         BRK
cd05 00         BRK
cd06 00         BRK
cd07 00         BRK
cd08 00         BRK
cd09 00         BRK
cd0a 00         BRK
cd0b 00         BRK
cd0c 00         BRK
cd0d 00         BRK
cd0e 00         BRK
cd0f 6161       ADC ($61, X)
cd11 61f0       ADC ($f0, X)
cd13 f0f0       BEQ cd05
cd15 f0f0       BEQ cd07
cd17 f0f0       BEQ cd09
cd19 f000       BEQ cd1b
cd1b 00         BRK
cd1c 00         BRK
cd1d 00         BRK
cd1e 00         BRK
cd1f 00         BRK
cd20 00         BRK
cd21 00         BRK
cd22 00         BRK
cd23 00         BRK
cd24 00         BRK
cd25 6161       ADC ($61, X)
cd27 6961       ADC #$61
cd29 6961       ADC #$61
cd2b 6161       ADC ($61, X)
cd2d 6169       ADC ($69, X)
cd2f 6100       ADC ($00, X)
cd31 00         BRK
cd32 00         BRK
cd33 00         BRK
cd34 00         BRK
cd35 00         BRK
cd36 00         BRK
cd37 00         BRK
cd38 00         BRK
cd39 00         BRK
cd3a 00         BRK
cd3b f0f0       BEQ cd2d
cd3d f0f0       BEQ cd2f
cd3f f0f0       BEQ cd31
cd41 f0f0       BEQ cd33
cd43 6161       ADC ($61, X)
cd45 6100       ADC ($00, X)
cd47 00         BRK
cd48 00         BRK
cd49 00         BRK
cd4a 00         BRK
cd4b 00         BRK
cd4c 00         BRK
cd4d 00         BRK
cd4e 00         BRK
cd4f 00         BRK
cd50 00         BRK
cd51 00         BRK
cd52 00         BRK
cd53 00         BRK
cd54 00         BRK
cd55 00         BRK
cd56 00         BRK
cd57 00         BRK
cd58 00         BRK
cd59 00         BRK
cd5a 00         BRK
cd5b 00         BRK
cd5c 00         BRK
cd5d 00         BRK
cd5e 00         BRK
cd5f db 0f
cd60 3016       BMI cd78
cd62 100f       BPL cd73
cd64 0129       ORA ($29, X)
cd66 28         PLP
cd67 db 0f
cd68 0130       ORA ($30, X)
cd6a 160f       ASL $0f, X
cd6c 0125       ORA ($25, X)
cd6e 1100       ORA ($00), Y
cd70 6c0000     JMP (ABS) $0000
cd73 6c6e6e     JMP (ABS) $6e6e
cd76 6c0000     JMP (ABS) $0000
cd79 00         BRK
cd7a 00         BRK
cd7b 00         BRK
cd7c 00         BRK
cd7d 00         BRK
cd7e 7e3800     ROR $0038, X
cd81 00         BRK
cd82 00         BRK
cd83 00         BRK
cd84 00         BRK
cd85 00         BRK
cd86 00         BRK
cd87 00         BRK
cd88 00         BRK
cd89 00         BRK
cd8a 00         BRK
cd8b 00         BRK
cd8c 00         BRK
cd8d 00         BRK
cd8e 00         BRK
cd8f 00         BRK
cd90 00         BRK
cd91 00         BRK
cd92 00         BRK
cd93 00         BRK
cd94 00         BRK
cd95 00         BRK
cd96 00         BRK
cd97 00         BRK
cd98 00         BRK
cd99 00         BRK
cd9a 00         BRK
cd9b 00         BRK
cd9c 00         BRK
cd9d 00         BRK
cd9e 00         BRK
cd9f 00         BRK
cda0 00         BRK
cda1 00         BRK
cda2 00         BRK
cda3 00         BRK
cda4 00         BRK
cda5 00         BRK
cda6 00         BRK
cda7 00         BRK
cda8 00         BRK
cda9 00         BRK
cdaa 00         BRK
cdab 00         BRK
cdac 00         BRK
cdad e281       INC #$81
cdaf 4171       EOR ($71, X)
cdb1 00         BRK
cdb2 8941       STA #$41
cdb4 69e2       ADC #$e2
cdb6 00         BRK
cdb7 00         BRK
cdb8 6149       ADC ($49, X)
cdba 8151       STA ($51, X)
cdbc 00         BRK
cdbd 4181       EOR ($81, X)
cdbf e261       INC #$61
cdc1 00         BRK
cdc2 00         BRK
cdc3 4171       EOR ($71, X)
cdc5 598100     EOR $0081, Y
cdc8 61e2       ADC ($e2, X)
cdca 8141       STA ($41, X)
cdcc 00         BRK
cdcd 00         BRK
cdce 8151       STA ($51, X)
cdd0 7141       ADC ($41), Y
cdd2 00         BRK
cdd3 e261       INC #$61
cdd5 4189       EOR ($89, X)
cdd7 00         BRK
cdd8 00         BRK
cdd9 5181       EOR ($81), Y
cddb 4161       EOR ($61, X)
cddd 00         BRK
cdde 8141       STA ($41, X)
cde0 7151       ADC ($51), Y
cde2 00         BRK
cde3 00         BRK
cde4 7141       ADC ($41), Y
cde6 81e2       STA ($e2, X)
cde8 00         BRK
cde9 4181       EOR ($81, X)
cdeb 5171       EOR ($71), Y
cded 00         BRK
cdee 00         BRK
cdef 4161       EOR ($61, X)
cdf1 e281       INC #$81
cdf3 00         BRK
cdf4 7151       ADC ($51), Y
cdf6 8141       STA ($41, X)
cdf8 00         BRK
cdf9 00         BRK
cdfa 89e2       STA #$e2
cdfc 6141       ADC ($41, X)
cdfe 00         BRK
cdff 5171       EOR ($71), Y
ce01 4181       EOR ($81, X)
ce03 00         BRK
ce04 00         BRK
ce05 e281       INC #$81
ce07 4971       EOR #$71
ce09 00         BRK
ce0a 8141       STA ($41, X)
ce0c 61e2       ADC ($e2, X)
ce0e 00         BRK
ce0f 00         BRK
ce10 6141       ADC ($41, X)
ce12 8151       STA ($51, X)
ce14 00         BRK
ce15 4181       EOR ($81, X)
ce17 e261       INC #$61
ce19 00         BRK
ce1a 00         BRK
ce1b 4171       EOR ($71, X)
ce1d 5189       EOR ($89), Y
ce1f 00         BRK
ce20 69e2       ADC #$e2
ce22 8141       STA ($41, X)
ce24 00         BRK
ce25 00         BRK
ce26 8151       STA ($51, X)
ce28 7141       ADC ($41), Y
ce2a 00         BRK
ce2b e261       INC #$61
ce2d 4181       EOR ($81, X)
ce2f 00         BRK
ce30 00         BRK
ce31 5181       EOR ($81), Y
ce33 4161       EOR ($61, X)
ce35 00         BRK
ce36 8941       STA #$41
ce38 7159       ADC ($59), Y
ce3a 00         BRK
ce3b 00         BRK
ce3c 7141       ADC ($41), Y
ce3e 81e2       STA ($e2, X)
ce40 00         BRK
ce41 4181       EOR ($81, X)
ce43 5171       EOR ($71), Y
ce45 00         BRK
ce46 00         BRK
ce47 00         BRK
ce48 00         BRK
ce49 00         BRK
ce4a 00         BRK
ce4b 00         BRK
ce4c 00         BRK
ce4d 00         BRK
ce4e 00         BRK
ce4f 00         BRK
ce50 00         BRK
ce51 00         BRK
ce52 00         BRK
ce53 00         BRK
ce54 00         BRK
ce55 00         BRK
ce56 00         BRK
ce57 00         BRK
ce58 00         BRK
ce59 00         BRK
ce5a 00         BRK
ce5b 00         BRK
ce5c 00         BRK
ce5d 00         BRK
ce5e 00         BRK
ce5f db 0f
ce60 3016       BMI ce78
ce62 100f       BPL ce73
ce64 1610       ASL $10, X
ce66 110f       ORA ($0f), Y
ce68 1627       ASL $27, X
ce6a 290f       AND #$0f
ce6c 1616       ASL $16, X
ce6e 2500       AND $00
ce70 00         BRK
ce71 00         BRK
ce72 00         BRK
ce73 6e6c6e     ROR $6e6c
ce76 6e6c00     ROR $006c
ce79 00         BRK
ce7a 00         BRK
ce7b 00         BRK
ce7c 00         BRK
ce7d 7c0070     JMP (ABS) $7000, X
ce80 00         BRK
ce81 00         BRK
ce82 00         BRK
ce83 00         BRK
ce84 00         BRK
ce85 00         BRK
ce86 00         BRK
ce87 00         BRK
ce88 00         BRK
ce89 00         BRK
ce8a 00         BRK
ce8b 00         BRK
ce8c 00         BRK
ce8d 00         BRK
ce8e 00         BRK
ce8f 00         BRK
ce90 00         BRK
ce91 00         BRK
ce92 00         BRK
ce93 00         BRK
ce94 00         BRK
ce95 00         BRK
ce96 00         BRK
ce97 00         BRK
ce98 00         BRK
ce99 8900       STA #$00
ce9b 00         BRK
ce9c 00         BRK
ce9d 8900       STA #$00
ce9f 00         BRK
cea0 00         BRK
cea1 00         BRK
cea2 00         BRK
cea3 00         BRK
cea4 00         BRK
cea5 8100       STA ($00, X)
cea7 8900       STA #$00
cea9 00         BRK
ceaa 00         BRK
ceab 00         BRK
ceac 00         BRK
cead 00         BRK
ceae 00         BRK
ceaf 00         BRK
ceb0 8900       STA #$00
ceb2 8900       STA #$00
ceb4 00         BRK
ceb5 00         BRK
ceb6 00         BRK
ceb7 00         BRK
ceb8 00         BRK
ceb9 00         BRK
ceba e2e2       INC #$e2
cebc e2e2       INC #$e2
cebe e200       INC #$00
cec0 00         BRK
cec1 00         BRK
cec2 00         BRK
cec3 00         BRK
cec4 00         BRK
cec5 e2e2       INC #$e2
cec7 e2e2       INC #$e2
cec9 e200       INC #$00
cecb 00         BRK
cecc 00         BRK
cecd 00         BRK
cece 00         BRK
cecf e2e2       INC #$e2
ced1 59e259     EOR $59e2, Y
ced4 e2e2       INC #$e2
ced6 00         BRK
ced7 00         BRK
ced8 00         BRK
ced9 00         BRK
ceda e2e2       INC #$e2
cedc 59e251     EOR $51e2, Y
cedf e2e2       INC #$e2
cee1 00         BRK
cee2 00         BRK
cee3 00         BRK
cee4 e2e2       INC #$e2
cee6 e2e2       INC #$e2
cee8 e2e2       INC #$e2
ceea e2e2       INC #$e2
ceec e200       INC #$00
ceee 00         BRK
ceef e2e2       INC #$e2
cef1 e2e2       INC #$e2
cef3 e2e2       INC #$e2
cef5 e2e2       INC #$e2
cef7 e200       INC #$00
cef9 00         BRK
cefa e200       INC #$00
cefc e2e2       INC #$e2
cefe e2e2       INC #$e2
cf00 e200       INC #$00
cf02 e200       INC #$00
cf04 00         BRK
cf05 e200       INC #$00
cf07 e200       INC #$00
cf09 00         BRK
cf0a 00         BRK
cf0b e200       INC #$00
cf0d e200       INC #$00
cf0f 00         BRK
cf10 e200       INC #$00
cf12 e200       INC #$00
cf14 00         BRK
cf15 00         BRK
cf16 e200       INC #$00
cf18 e200       INC #$00
cf1a 00         BRK
cf1b 00         BRK
cf1c 00         BRK
cf1d 00         BRK
cf1e e200       INC #$00
cf20 e200       INC #$00
cf22 00         BRK
cf23 00         BRK
cf24 00         BRK
cf25 00         BRK
cf26 00         BRK
cf27 00         BRK
cf28 00         BRK
cf29 e200       INC #$00
cf2b e200       INC #$00
cf2d 00         BRK
cf2e 00         BRK
cf2f 00         BRK
cf30 00         BRK
cf31 00         BRK
cf32 00         BRK
cf33 00         BRK
cf34 00         BRK
cf35 00         BRK
cf36 00         BRK
cf37 00         BRK
cf38 00         BRK
cf39 00         BRK
cf3a 00         BRK
cf3b 00         BRK
cf3c 00         BRK
cf3d 00         BRK
cf3e 00         BRK
cf3f 00         BRK
cf40 00         BRK
cf41 00         BRK
cf42 00         BRK
cf43 00         BRK
cf44 00         BRK
cf45 00         BRK
cf46 00         BRK
cf47 00         BRK
cf48 00         BRK
cf49 00         BRK
cf4a 00         BRK
cf4b 00         BRK
cf4c 00         BRK
cf4d 00         BRK
cf4e 00         BRK
cf4f 00         BRK
cf50 00         BRK
cf51 00         BRK
cf52 00         BRK
cf53 00         BRK
cf54 00         BRK
cf55 00         BRK
cf56 00         BRK
cf57 00         BRK
cf58 00         BRK
cf59 00         BRK
cf5a 00         BRK
cf5b 00         BRK
cf5c 00         BRK
cf5d 00         BRK
cf5e 00         BRK
cf5f db 0f
cf60 3016       BMI cf78
cf62 100f       BPL cf73
cf64 0110       ORA ($10, X)
cf66 160f       ASL $0f, X
cf68 0110       ORA ($10, X)
cf6a db 27
cf6b db 0f
cf6c 0100       ORA ($00, X)
cf6e 00         BRK
cf6f 00         BRK
cf70 00         BRK
cf71 00         BRK
cf72 00         BRK
cf73 00         BRK
cf74 6e0000     ROR $0000
cf77 6e0000     ROR $0000
cf7a 00         BRK
cf7b 00         BRK
cf7c 00         BRK
cf7d 7c0043     JMP (ABS) $4300, X
cf80 00         BRK
cf81 00         BRK
cf82 00         BRK
cf83 00         BRK
cf84 00         BRK
cf85 00         BRK
cf86 00         BRK
cf87 00         BRK
cf88 00         BRK
cf89 00         BRK
cf8a 00         BRK
cf8b 00         BRK
cf8c 00         BRK
cf8d 00         BRK
cf8e 00         BRK
cf8f 00         BRK
cf90 00         BRK
cf91 00         BRK
cf92 00         BRK
cf93 00         BRK
cf94 00         BRK
cf95 00         BRK
cf96 00         BRK
cf97 00         BRK
cf98 00         BRK
cf99 00         BRK
cf9a 00         BRK
cf9b 00         BRK
cf9c 00         BRK
cf9d 00         BRK
cf9e 00         BRK
cf9f 00         BRK
cfa0 00         BRK
cfa1 6100       ADC ($00, X)
cfa3 5100       EOR ($00), Y
cfa5 4100       EOR ($00, X)
cfa7 4100       EOR ($00, X)
cfa9 5100       EOR ($00), Y
cfab 6169       ADC ($69, X)
cfad 00         BRK
cfae 590049     EOR $4900, Y
cfb1 00         BRK
cfb2 4900       EOR #$00
cfb4 590069     EOR $6900, Y
cfb7 6100       ADC ($00, X)
cfb9 5100       EOR ($00), Y
cfbb 4100       EOR ($00, X)
cfbd 4100       EOR ($00, X)
cfbf 5100       EOR ($00), Y
cfc1 6161       ADC ($61, X)
cfc3 00         BRK
cfc4 f029       BEQ cfef
cfc6 f029       BEQ cff1
cfc8 f029       BEQ cff3
cfca f000       BEQ cfcc
cfcc 6961       ADC #$61
cfce 00         BRK
cfcf 5100       EOR ($00), Y
cfd1 4100       EOR ($00, X)
cfd3 4900       EOR #$00
cfd5 590061     EOR $6100, Y
cfd8 6100       ADC ($00, X)
cfda 5100       EOR ($00), Y
cfdc 4100       EOR ($00, X)
cfde 4100       EOR ($00, X)
cfe0 5100       EOR ($00), Y
cfe2 6169       ADC ($69, X)
cfe4 00         BRK
cfe5 5100       EOR ($00), Y
cfe7 4100       EOR ($00, X)
cfe9 4100       EOR ($00, X)
cfeb 5100       EOR ($00), Y
cfed 6161       ADC ($61, X)
cfef 00         BRK
cff0 5100       EOR ($00), Y
cff2 4100       EOR ($00, X)
cff4 4100       EOR ($00, X)
cff6 5100       EOR ($00), Y
cff8 6161       ADC ($61, X)
cffa 00         BRK
cffb 590041     EOR $4100, Y
cffe 00         BRK
cfff 4100       EOR ($00, X)
d001 5100       EOR ($00), Y
d003 6129       ADC ($29, X)
d005 00         BRK
d006 f000       BEQ d008
d008 f000       BEQ d00a
d00a f000       BEQ d00c
d00c f000       BEQ d00e
d00e 2961       AND #$61
d010 00         BRK
d011 5100       EOR ($00), Y
d013 4100       EOR ($00, X)
d015 4100       EOR ($00, X)
d017 5100       EOR ($00), Y
d019 6100       ADC ($00, X)
d01b 00         BRK
d01c 00         BRK
d01d 00         BRK
d01e 00         BRK
d01f 00         BRK
d020 00         BRK
d021 00         BRK
d022 00         BRK
d023 00         BRK
d024 00         BRK
d025 00         BRK
d026 00         BRK
d027 00         BRK
d028 00         BRK
d029 00         BRK
d02a 00         BRK
d02b 00         BRK
d02c 00         BRK
d02d 00         BRK
d02e 00         BRK
d02f 00         BRK
d030 00         BRK
d031 00         BRK
d032 00         BRK
d033 00         BRK
d034 00         BRK
d035 00         BRK
d036 00         BRK
d037 00         BRK
d038 00         BRK
d039 00         BRK
d03a 00         BRK
d03b 00         BRK
d03c 00         BRK
d03d 00         BRK
d03e 00         BRK
d03f 00         BRK
d040 00         BRK
d041 00         BRK
d042 00         BRK
d043 00         BRK
d044 00         BRK
d045 00         BRK
d046 00         BRK
d047 00         BRK
d048 00         BRK
d049 00         BRK
d04a 00         BRK
d04b 00         BRK
d04c 00         BRK
d04d 00         BRK
d04e 00         BRK
d04f 00         BRK
d050 00         BRK
d051 00         BRK
d052 00         BRK
d053 00         BRK
d054 00         BRK
d055 00         BRK
d056 00         BRK
d057 00         BRK
d058 00         BRK
d059 00         BRK
d05a 00         BRK
d05b 00         BRK
d05c 00         BRK
d05d 00         BRK
d05e 00         BRK
d05f db 0f
d060 3016       BMI d078
d062 100f       BPL d073
d064 0911       ORA #$11
d066 260f       ROL $0f
d068 0928       ORA #$28
d06a 160f       ASL $0f, X
d06c 0928       ORA #$28
d06e 2900       AND #$00
d070 00         BRK
d071 6e006e     ROR $6e00
d074 6e6c00     ROR $006c
d077 00         BRK
d078 00         BRK
d079 00         BRK
d07a 00         BRK
d07b 00         BRK
d07c 00         BRK
d07d 00         BRK
d07e 7c3d00     JMP (ABS) $003d, X
d081 00         BRK
d082 00         BRK
d083 00         BRK
d084 00         BRK
d085 00         BRK
d086 00         BRK
d087 00         BRK
d088 00         BRK
d089 00         BRK
d08a 00         BRK
d08b 00         BRK
d08c 00         BRK
d08d 00         BRK
d08e 00         BRK
d08f 00         BRK
d090 00         BRK
d091 00         BRK
d092 00         BRK
d093 00         BRK
d094 00         BRK
d095 00         BRK
d096 00         BRK
d097 00         BRK
d098 00         BRK
d099 00         BRK
d09a 00         BRK
d09b 00         BRK
d09c 00         BRK
d09d 00         BRK
d09e 00         BRK
d09f 00         BRK
d0a0 00         BRK
d0a1 00         BRK
d0a2 00         BRK
d0a3 00         BRK
d0a4 00         BRK
d0a5 00         BRK
d0a6 00         BRK
d0a7 00         BRK
d0a8 00         BRK
d0a9 00         BRK
d0aa 00         BRK
d0ab 00         BRK
d0ac 00         BRK
d0ad 00         BRK
d0ae 00         BRK
d0af 00         BRK
d0b0 8131       STA ($31, X)
d0b2 6100       ADC ($00, X)
d0b4 00         BRK
d0b5 00         BRK
d0b6 00         BRK
d0b7 00         BRK
d0b8 00         BRK
d0b9 00         BRK
d0ba 8141       STA ($41, X)
d0bc 6931       ADC #$31
d0be 8100       STA ($00, X)
d0c0 00         BRK
d0c1 00         BRK
d0c2 00         BRK
d0c3 00         BRK
d0c4 00         BRK
d0c5 3161       AND ($61), Y
d0c7 4181       EOR ($81, X)
d0c9 2100       AND ($00, X)
d0cb 00         BRK
d0cc 00         BRK
d0cd 00         BRK
d0ce 00         BRK
d0cf 4161       EOR ($61, X)
d0d1 398141     AND $4181, Y
d0d4 592100     EOR $0021, Y
d0d7 00         BRK
d0d8 00         BRK
d0d9 00         BRK
d0da 6141       ADC ($41, X)
d0dc 8121       STA ($21, X)
d0de 5141       EOR ($41), Y
d0e0 8100       STA ($00, X)
d0e2 00         BRK
d0e3 00         BRK
d0e4 00         BRK
d0e5 3189       AND ($89), Y
d0e7 4159       EOR ($59, X)
d0e9 2181       AND ($81, X)
d0eb 4100       EOR ($00, X)
d0ed 00         BRK
d0ee 00         BRK
d0ef 00         BRK
d0f0 8121       STA ($21, X)
d0f2 5149       EOR ($49), Y
d0f4 8931       STA #$31
d0f6 6100       ADC ($00, X)
d0f8 00         BRK
d0f9 00         BRK
d0fa 00         BRK
d0fb 4151       EOR ($51, X)
d0fd 2181       AND ($81, X)
d0ff 4161       EOR ($61, X)
d101 3100       AND ($00), Y
d103 00         BRK
d104 00         BRK
d105 00         BRK
d106 5141       EOR ($41), Y
d108 8131       STA ($31, X)
d10a 6141       ADC ($41, X)
d10c 8100       STA ($00, X)
d10e 00         BRK
d10f 00         BRK
d110 00         BRK
d111 00         BRK
d112 8149       STA ($49, X)
d114 6131       ADC ($31, X)
d116 8900       STA #$00
d118 00         BRK
d119 00         BRK
d11a 00         BRK
d11b 00         BRK
d11c 00         BRK
d11d 3161       AND ($61), Y
d11f 4181       EOR ($81, X)
d121 2100       AND ($00, X)
d123 00         BRK
d124 00         BRK
d125 00         BRK
d126 00         BRK
d127 00         BRK
d128 00         BRK
d129 3181       AND ($81), Y
d12b 4100       EOR ($00, X)
d12d 00         BRK
d12e 00         BRK
d12f 00         BRK
d130 00         BRK
d131 00         BRK
d132 00         BRK
d133 00         BRK
d134 00         BRK
d135 00         BRK
d136 00         BRK
d137 00         BRK
d138 00         BRK
d139 00         BRK
d13a 00         BRK
d13b 00         BRK
d13c 00         BRK
d13d 00         BRK
d13e 00         BRK
d13f 00         BRK
d140 00         BRK
d141 00         BRK
d142 00         BRK
d143 00         BRK
d144 00         BRK
d145 00         BRK
d146 00         BRK
d147 00         BRK
d148 00         BRK
d149 00         BRK
d14a 00         BRK
d14b 00         BRK
d14c 00         BRK
d14d 00         BRK
d14e 00         BRK
d14f 00         BRK
d150 00         BRK
d151 00         BRK
d152 00         BRK
d153 00         BRK
d154 00         BRK
d155 00         BRK
d156 00         BRK
d157 00         BRK
d158 00         BRK
d159 00         BRK
d15a 00         BRK
d15b 00         BRK
d15c 00         BRK
d15d 00         BRK
d15e 00         BRK
d15f db 0f
d160 3016       BMI d178
d162 100f       BPL d173
d164 0127       ORA ($27, X)
d166 290f       AND #$0f
d168 0116       ORA ($16, X)
d16a 260f       ROL $0f
d16c 0111       ORA ($11, X)
d16e 2100       AND ($00, X)
d170 00         BRK
d171 6e6e6e     ROR $6e6e
d174 6c6c00     JMP (ABS) $006c
d177 6c0000     JMP (ABS) $0000
d17a 00         BRK
d17b 00         BRK
d17c 00         BRK
d17d 00         BRK
d17e 00         BRK
d17f 4400       JMP $00
d181 00         BRK
d182 00         BRK
d183 00         BRK
d184 00         BRK
d185 00         BRK
d186 00         BRK
d187 00         BRK
d188 00         BRK
d189 00         BRK
d18a 00         BRK
d18b 00         BRK
d18c 00         BRK
d18d 00         BRK
d18e 00         BRK
d18f 00         BRK
d190 00         BRK
d191 00         BRK
d192 00         BRK
d193 00         BRK
d194 00         BRK
d195 00         BRK
d196 00         BRK
d197 00         BRK
d198 00         BRK
d199 00         BRK
d19a 00         BRK
d19b 00         BRK
d19c 00         BRK
d19d 00         BRK
d19e 00         BRK
d19f 00         BRK
d1a0 00         BRK
d1a1 00         BRK
d1a2 f000       BEQ d1a4
d1a4 00         BRK
d1a5 f000       BEQ d1a7
d1a7 f000       BEQ d1a9
d1a9 00         BRK
d1aa f000       BEQ d1ac
d1ac 00         BRK
d1ad f0f0       BEQ d19f
d1af 00         BRK
d1b0 00         BRK
d1b1 00         BRK
d1b2 00         BRK
d1b3 00         BRK
d1b4 f0f0       BEQ d1a6
d1b6 00         BRK
d1b7 00         BRK
d1b8 00         BRK
d1b9 00         BRK
d1ba 00         BRK
d1bb 00         BRK
d1bc 2900       AND #$00
d1be 00         BRK
d1bf 00         BRK
d1c0 00         BRK
d1c1 00         BRK
d1c2 00         BRK
d1c3 00         BRK
d1c4 00         BRK
d1c5 00         BRK
d1c6 f041       BEQ d209
d1c8 f000       BEQ d1ca
d1ca 00         BRK
d1cb 00         BRK
d1cc 00         BRK
d1cd 00         BRK
d1ce 00         BRK
d1cf f000       BEQ d1d1
d1d1 00         BRK
d1d2 8900       STA #$00
d1d4 00         BRK
d1d5 f000       BEQ d1d7
d1d7 00         BRK
d1d8 00         BRK
d1d9 00         BRK
d1da 00         BRK
d1db 00         BRK
d1dc 00         BRK
d1dd 6900       ADC #$00
d1df 00         BRK
d1e0 00         BRK
d1e1 00         BRK
d1e2 00         BRK
d1e3 00         BRK
d1e4 00         BRK
d1e5 f000       BEQ d1e7
d1e7 00         BRK
d1e8 5100       EOR ($00), Y
d1ea 00         BRK
d1eb f000       BEQ d1ed
d1ed 00         BRK
d1ee 00         BRK
d1ef 00         BRK
d1f0 00         BRK
d1f1 00         BRK
d1f2 f041       BEQ d235
d1f4 f000       BEQ d1f6
d1f6 00         BRK
d1f7 00         BRK
d1f8 00         BRK
d1f9 00         BRK
d1fa 00         BRK
d1fb 00         BRK
d1fc 00         BRK
d1fd 00         BRK
d1fe 8900       STA #$00
d200 00         BRK
d201 00         BRK
d202 00         BRK
d203 00         BRK
d204 00         BRK
d205 f0f0       BEQ d1f7
d207 00         BRK
d208 00         BRK
d209 00         BRK
d20a 00         BRK
d20b 00         BRK
d20c f0f0       BEQ d1fe
d20e 00         BRK
d20f 00         BRK
d210 f000       BEQ d212
d212 00         BRK
d213 f000       BEQ d215
d215 f000       BEQ d217
d217 00         BRK
d218 f000       BEQ d21a
d21a 00         BRK
d21b 00         BRK
d21c 00         BRK
d21d 00         BRK
d21e 00         BRK
d21f 00         BRK
d220 00         BRK
d221 00         BRK
d222 00         BRK
d223 00         BRK
d224 00         BRK
d225 00         BRK
d226 00         BRK
d227 00         BRK
d228 00         BRK
d229 00         BRK
d22a 00         BRK
d22b 00         BRK
d22c 00         BRK
d22d 00         BRK
d22e 00         BRK
d22f 00         BRK
d230 00         BRK
d231 00         BRK
d232 00         BRK
d233 00         BRK
d234 00         BRK
d235 00         BRK
d236 00         BRK
d237 00         BRK
d238 00         BRK
d239 00         BRK
d23a 00         BRK
d23b 00         BRK
d23c 00         BRK
d23d 00         BRK
d23e 00         BRK
d23f 00         BRK
d240 00         BRK
d241 00         BRK
d242 00         BRK
d243 00         BRK
d244 00         BRK
d245 00         BRK
d246 00         BRK
d247 00         BRK
d248 00         BRK
d249 00         BRK
d24a 00         BRK
d24b 00         BRK
d24c 00         BRK
d24d 00         BRK
d24e 00         BRK
d24f 00         BRK
d250 00         BRK
d251 00         BRK
d252 00         BRK
d253 00         BRK
d254 00         BRK
d255 00         BRK
d256 00         BRK
d257 00         BRK
d258 00         BRK
d259 00         BRK
d25a 00         BRK
d25b 00         BRK
d25c 00         BRK
d25d 00         BRK
d25e 00         BRK
d25f db 0f
d260 3016       BMI d278
d262 100f       BPL d273
d264 1628       ASL $28, X
d266 260f       ROL $0f
d268 1627       ASL $27, X
d26a 290f       AND #$0f
d26c 1616       ASL $16, X
d26e 1100       ORA ($00), Y
d270 00         BRK
d271 6e006e     ROR $6e00
d274 6c6e00     JMP (ABS) $006e
d277 6c0000     JMP (ABS) $0000
d27a 00         BRK
d27b 00         BRK
d27c 00         BRK
d27d 00         BRK
d27e 7c0700     JMP (ABS) $0007, X
d281 00         BRK
d282 00         BRK
d283 00         BRK
d284 00         BRK
d285 00         BRK
d286 00         BRK
d287 00         BRK
d288 00         BRK
d289 00         BRK
d28a 00         BRK
d28b 00         BRK
d28c 00         BRK
d28d 00         BRK
d28e 00         BRK
d28f 00         BRK
d290 00         BRK
d291 00         BRK
d292 00         BRK
d293 00         BRK
d294 00         BRK
d295 00         BRK
d296 00         BRK
d297 f000       BEQ d299
d299 f000       BEQ d29b
d29b 00         BRK
d29c 00         BRK
d29d f000       BEQ d29f
d29f f000       BEQ d2a1
d2a1 00         BRK
d2a2 f049       BEQ d2ed
d2a4 f000       BEQ d2a6
d2a6 00         BRK
d2a7 00         BRK
d2a8 f049       BEQ d2f3
d2aa f000       BEQ d2ac
d2ac 00         BRK
d2ad f069       BEQ d318
d2af f000       BEQ d2b1
d2b1 00         BRK
d2b2 00         BRK
d2b3 f069       BEQ d31e
d2b5 f000       BEQ d2b7
d2b7 00         BRK
d2b8 f0f0       BEQ d2aa
d2ba f000       BEQ d2bc
d2bc 00         BRK
d2bd 00         BRK
d2be f0f0       BEQ d2b0
d2c0 f000       BEQ d2c2
d2c2 00         BRK
d2c3 00         BRK
d2c4 00         BRK
d2c5 00         BRK
d2c6 00         BRK
d2c7 00         BRK
d2c8 00         BRK
d2c9 00         BRK
d2ca 00         BRK
d2cb 00         BRK
d2cc 00         BRK
d2cd 00         BRK
d2ce 00         BRK
d2cf 00         BRK
d2d0 796961     ADC $6169, Y
d2d3 6989       ADC #$89
d2d5 00         BRK
d2d6 00         BRK
d2d7 00         BRK
d2d8 00         BRK
d2d9 00         BRK
d2da 00         BRK
d2db 794139     ADC $3941, Y
d2de 4189       EOR ($89, X)
d2e0 00         BRK
d2e1 00         BRK
d2e2 00         BRK
d2e3 00         BRK
d2e4 00         BRK
d2e5 00         BRK
d2e6 7139       ADC ($39), Y
d2e8 4931       EOR #$31
d2ea 8900       STA #$00
d2ec 00         BRK
d2ed 00         BRK
d2ee 00         BRK
d2ef 00         BRK
d2f0 00         BRK
d2f1 794131     ADC $3141, Y
d2f4 4981       EOR #$81
d2f6 00         BRK
d2f7 00         BRK
d2f8 00         BRK
d2f9 00         BRK
d2fa 00         BRK
d2fb 00         BRK
d2fc 7139       ADC ($39), Y
d2fe 4139       EOR ($39, X)
d300 8100       STA ($00, X)
d302 00         BRK
d303 00         BRK
d304 00         BRK
d305 00         BRK
d306 00         BRK
d307 796169     ADC $6961, Y
d30a 6989       ADC #$89
d30c 00         BRK
d30d 00         BRK
d30e 00         BRK
d30f 00         BRK
d310 00         BRK
d311 00         BRK
d312 00         BRK
d313 00         BRK
d314 00         BRK
d315 00         BRK
d316 00         BRK
d317 00         BRK
d318 00         BRK
d319 00         BRK
d31a 00         BRK
d31b 00         BRK
d31c 00         BRK
d31d 00         BRK
d31e 00         BRK
d31f 00         BRK
d320 00         BRK
d321 00         BRK
d322 00         BRK
d323 00         BRK
d324 00         BRK
d325 00         BRK
d326 00         BRK
d327 00         BRK
d328 00         BRK
d329 00         BRK
d32a 00         BRK
d32b 00         BRK
d32c 00         BRK
d32d 00         BRK
d32e 00         BRK
d32f 00         BRK
d330 00         BRK
d331 00         BRK
d332 00         BRK
d333 00         BRK
d334 00         BRK
d335 00         BRK
d336 00         BRK
d337 00         BRK
d338 00         BRK
d339 00         BRK
d33a 00         BRK
d33b 00         BRK
d33c 00         BRK
d33d 00         BRK
d33e 00         BRK
d33f 00         BRK
d340 00         BRK
d341 00         BRK
d342 00         BRK
d343 00         BRK
d344 00         BRK
d345 00         BRK
d346 00         BRK
d347 00         BRK
d348 00         BRK
d349 00         BRK
d34a 00         BRK
d34b 00         BRK
d34c 00         BRK
d34d 00         BRK
d34e 00         BRK
d34f 00         BRK
d350 00         BRK
d351 00         BRK
d352 00         BRK
d353 00         BRK
d354 00         BRK
d355 00         BRK
d356 00         BRK
d357 00         BRK
d358 00         BRK
d359 00         BRK
d35a 00         BRK
d35b 00         BRK
d35c 00         BRK
d35d 00         BRK
d35e 00         BRK
d35f db 0f
d360 3016       BMI d378
d362 100f       BPL d373
d364 0128       ORA ($28, X)
d366 110f       ORA ($0f), Y
d368 0129       ORA ($29, X)
d36a 210f       AND ($0f, X)
d36c 0125       ORA ($25, X)
d36e db 27
d36f 00         BRK
d370 00         BRK
d371 00         BRK
d372 6e6c00     ROR $006c
d375 6e6c6e     ROR $6e6c
d378 00         BRK
d379 00         BRK
d37a 00         BRK
d37b 00         BRK
d37c 00         BRK
d37d 00         BRK
d37e 7c2200     JMP (ABS) $0022, X
d381 f000       BEQ d383
d383 00         BRK
d384 00         BRK
d385 00         BRK
d386 00         BRK
d387 00         BRK
d388 00         BRK
d389 00         BRK
d38a 00         BRK
d38b 00         BRK
d38c 00         BRK
d38d 00         BRK
d38e 00         BRK
d38f 00         BRK
d390 00         BRK
d391 00         BRK
d392 00         BRK
d393 00         BRK
d394 00         BRK
d395 00         BRK
d396 00         BRK
d397 f000       BEQ d399
d399 00         BRK
d39a 00         BRK
d39b 00         BRK
d39c 00         BRK
d39d 00         BRK
d39e 00         BRK
d39f 00         BRK
d3a0 00         BRK
d3a1 00         BRK
d3a2 f000       BEQ d3a4
d3a4 00         BRK
d3a5 00         BRK
d3a6 00         BRK
d3a7 00         BRK
d3a8 00         BRK
d3a9 00         BRK
d3aa 00         BRK
d3ab 00         BRK
d3ac 00         BRK
d3ad f000       BEQ d3af
d3af 00         BRK
d3b0 00         BRK
d3b1 00         BRK
d3b2 6900       ADC #$00
d3b4 00         BRK
d3b5 00         BRK
d3b6 00         BRK
d3b7 00         BRK
d3b8 f000       BEQ d3ba
d3ba 00         BRK
d3bb 00         BRK
d3bc 6139       ADC ($39, X)
d3be 6100       ADC ($00, X)
d3c0 00         BRK
d3c1 00         BRK
d3c2 00         BRK
d3c3 f000       BEQ d3c5
d3c5 00         BRK
d3c6 6931       ADC #$31
d3c8 6931       ADC #$31
d3ca 6900       ADC #$00
d3cc 00         BRK
d3cd 00         BRK
d3ce f000       BEQ d3d0
d3d0 6939       ADC #$39
d3d2 69e3       ADC #$e3
d3d4 6939       ADC #$39
d3d6 6900       ADC #$00
d3d8 00         BRK
d3d9 f000       BEQ d3db
d3db 00         BRK
d3dc 6131       ADC ($31, X)
d3de 6931       ADC #$31
d3e0 6100       ADC ($00, X)
d3e2 00         BRK
d3e3 00         BRK
d3e4 f000       BEQ d3e6
d3e6 00         BRK
d3e7 00         BRK
d3e8 6939       ADC #$39
d3ea 6900       ADC #$00
d3ec 00         BRK
d3ed 00         BRK
d3ee 00         BRK
d3ef f000       BEQ d3f1
d3f1 00         BRK
d3f2 00         BRK
d3f3 00         BRK
d3f4 6900       ADC #$00
d3f6 00         BRK
d3f7 00         BRK
d3f8 00         BRK
d3f9 00         BRK
d3fa f000       BEQ d3fc
d3fc 00         BRK
d3fd 00         BRK
d3fe 00         BRK
d3ff 00         BRK
d400 00         BRK
d401 00         BRK
d402 00         BRK
d403 00         BRK
d404 00         BRK
d405 f000       BEQ d407
d407 00         BRK
d408 00         BRK
d409 00         BRK
d40a 00         BRK
d40b 00         BRK
d40c 00         BRK
d40d 00         BRK
d40e 00         BRK
d40f 00         BRK
d410 f000       BEQ d412
d412 00         BRK
d413 00         BRK
d414 00         BRK
d415 00         BRK
d416 00         BRK
d417 00         BRK
d418 00         BRK
d419 00         BRK
d41a 00         BRK
d41b f000       BEQ d41d
d41d 00         BRK
d41e 00         BRK
d41f 00         BRK
d420 00         BRK
d421 00         BRK
d422 00         BRK
d423 00         BRK
d424 00         BRK
d425 00         BRK
d426 f0f0       BEQ d418
d428 f0f0       BEQ d41a
d42a f0f0       BEQ d41c
d42c f0f0       BEQ d41e
d42e f0f0       BEQ d420
d430 00         BRK
d431 00         BRK
d432 00         BRK
d433 00         BRK
d434 00         BRK
d435 00         BRK
d436 00         BRK
d437 00         BRK
d438 00         BRK
d439 00         BRK
d43a 00         BRK
d43b 00         BRK
d43c 00         BRK
d43d 00         BRK
d43e 00         BRK
d43f 00         BRK
d440 00         BRK
d441 00         BRK
d442 00         BRK
d443 00         BRK
d444 00         BRK
d445 00         BRK
d446 00         BRK
d447 00         BRK
d448 00         BRK
d449 00         BRK
d44a 00         BRK
d44b 00         BRK
d44c 00         BRK
d44d 00         BRK
d44e 00         BRK
d44f 00         BRK
d450 00         BRK
d451 00         BRK
d452 00         BRK
d453 00         BRK
d454 00         BRK
d455 00         BRK
d456 00         BRK
d457 00         BRK
d458 00         BRK
d459 00         BRK
d45a 00         BRK
d45b 00         BRK
d45c 00         BRK
d45d 00         BRK
d45e 00         BRK
d45f db 0f
d460 3016       BMI d478
d462 100f       BPL d473
d464 0928       ORA #$28
d466 100f       BPL d477
d468 0911       ORA #$11
d46a 210f       AND ($0f, X)
d46c 0911       ORA #$11
d46e 1000       BPL d470
d470 00         BRK
d471 00         BRK
d472 6e0000     ROR $0000
d475 6c0000     JMP (ABS) $0000
d478 00         BRK
d479 00         BRK
d47a 00         BRK
d47b 00         BRK
d47c 00         BRK
d47d 7e7c19     ROR $197c, X
d480 00         BRK
d481 00         BRK
d482 00         BRK
d483 00         BRK
d484 00         BRK
d485 00         BRK
d486 00         BRK
d487 00         BRK
d488 00         BRK
d489 00         BRK
d48a 00         BRK
d48b 00         BRK
d48c 00         BRK
d48d 00         BRK
d48e 00         BRK
d48f 00         BRK
d490 00         BRK
d491 00         BRK
d492 00         BRK
d493 00         BRK
d494 00         BRK
d495 00         BRK
d496 00         BRK
d497 00         BRK
d498 00         BRK
d499 00         BRK
d49a 00         BRK
d49b 00         BRK
d49c 00         BRK
d49d 00         BRK
d49e 00         BRK
d49f 00         BRK
d4a0 00         BRK
d4a1 00         BRK
d4a2 00         BRK
d4a3 00         BRK
d4a4 00         BRK
d4a5 00         BRK
d4a6 00         BRK
d4a7 00         BRK
d4a8 00         BRK
d4a9 00         BRK
d4aa 00         BRK
d4ab 00         BRK
d4ac 00         BRK
d4ad db e3
d4ae db e3
d4af db e3
d4b0 db e3
d4b1 db e3
d4b2 db e3
d4b3 db e3
d4b4 db e3
d4b5 db e3
d4b6 00         BRK
d4b7 00         BRK
d4b8 db e3
d4b9 00         BRK
d4ba 00         BRK
d4bb 00         BRK
d4bc 00         BRK
d4bd 00         BRK
d4be 00         BRK
d4bf 00         BRK
d4c0 db e3
d4c1 00         BRK
d4c2 00         BRK
d4c3 db e3
d4c4 00         BRK
d4c5 db e3
d4c6 db e3
d4c7 db e3
d4c8 db e3
d4c9 db e3
d4ca 00         BRK
d4cb db e3
d4cc 00         BRK
d4cd 00         BRK
d4ce db e3
d4cf 00         BRK
d4d0 db e3
d4d1 00         BRK
d4d2 00         BRK
d4d3 00         BRK
d4d4 db e3
d4d5 00         BRK
d4d6 db e3
d4d7 00         BRK
d4d8 00         BRK
d4d9 db e3
d4da 00         BRK
d4db db e3
d4dc 00         BRK
d4dd db e3
d4de 00         BRK
d4df db e3
d4e0 00         BRK
d4e1 db e3
d4e2 00         BRK
d4e3 00         BRK
d4e4 db e3
d4e5 00         BRK
d4e6 db e3
d4e7 00         BRK
d4e8 00         BRK
d4e9 00         BRK
d4ea db e3
d4eb 00         BRK
d4ec db e3
d4ed 00         BRK
d4ee 00         BRK
d4ef db e3
d4f0 00         BRK
d4f1 db e3
d4f2 db e3
d4f3 db e3
d4f4 db e3
d4f5 db e3
d4f6 00         BRK
d4f7 db e3
d4f8 00         BRK
d4f9 00         BRK
d4fa db e3
d4fb 00         BRK
d4fc 00         BRK
d4fd 00         BRK
d4fe 00         BRK
d4ff 00         BRK
d500 00         BRK
d501 00         BRK
d502 db e3
d503 00         BRK
d504 00         BRK
d505 db e3
d506 db e3
d507 db e3
d508 db e3
d509 db e3
d50a db e3
d50b db e3
d50c db e3
d50d db e3
d50e 00         BRK
d50f 00         BRK
d510 00         BRK
d511 00         BRK
d512 00         BRK
d513 00         BRK
d514 00         BRK
d515 00         BRK
d516 00         BRK
d517 00         BRK
d518 00         BRK
d519 00         BRK
d51a 00         BRK
d51b 00         BRK
d51c 00         BRK
d51d 00         BRK
d51e 00         BRK
d51f 00         BRK
d520 00         BRK
d521 00         BRK
d522 00         BRK
d523 00         BRK
d524 00         BRK
d525 00         BRK
d526 00         BRK
d527 00         BRK
d528 00         BRK
d529 00         BRK
d52a 00         BRK
d52b 00         BRK
d52c 00         BRK
d52d 00         BRK
d52e 00         BRK
d52f 00         BRK
d530 00         BRK
d531 00         BRK
d532 00         BRK
d533 00         BRK
d534 00         BRK
d535 00         BRK
d536 00         BRK
d537 00         BRK
d538 00         BRK
d539 00         BRK
d53a 00         BRK
d53b 00         BRK
d53c 00         BRK
d53d 00         BRK
d53e 00         BRK
d53f 00         BRK
d540 00         BRK
d541 00         BRK
d542 00         BRK
d543 00         BRK
d544 00         BRK
d545 00         BRK
d546 00         BRK
d547 00         BRK
d548 00         BRK
d549 00         BRK
d54a 00         BRK
d54b 00         BRK
d54c 00         BRK
d54d 00         BRK
d54e 00         BRK
d54f 00         BRK
d550 00         BRK
d551 00         BRK
d552 00         BRK
d553 00         BRK
d554 00         BRK
d555 00         BRK
d556 00         BRK
d557 00         BRK
d558 00         BRK
d559 00         BRK
d55a 00         BRK
d55b 00         BRK
d55c 00         BRK
d55d 00         BRK
d55e 00         BRK
d55f db 0f
d560 3016       BMI d578
d562 100f       BPL d573
d564 0110       ORA ($10, X)
d566 00         BRK
d567 db 0f
d568 0100       ORA ($00, X)
d56a 00         BRK
d56b db 0f
d56c 0100       ORA ($00, X)
d56e 00         BRK
d56f 00         BRK
d570 00         BRK
d571 00         BRK
d572 00         BRK
d573 00         BRK
d574 00         BRK
d575 00         BRK
d576 00         BRK
d577 00         BRK
d578 00         BRK
d579 00         BRK
d57a 00         BRK
d57b 00         BRK
d57c 00         BRK
d57d 7c0031     JMP (ABS) $3100, X
d580 00         BRK
d581 00         BRK
d582 00         BRK
d583 00         BRK
d584 00         BRK
d585 00         BRK
d586 00         BRK
d587 00         BRK
d588 00         BRK
d589 00         BRK
d58a 00         BRK
d58b 00         BRK
d58c 00         BRK
d58d 00         BRK
d58e 00         BRK
d58f 00         BRK
d590 00         BRK
d591 00         BRK
d592 00         BRK
d593 00         BRK
d594 00         BRK
d595 00         BRK
d596 f0f0       BEQ d588
d598 f0f0       BEQ d58a
d59a f0f0       BEQ d58c
d59c f0f0       BEQ d58e
d59e f0f0       BEQ d590
d5a0 f000       BEQ d5a2
d5a2 00         BRK
d5a3 00         BRK
d5a4 00         BRK
d5a5 f000       BEQ d5a7
d5a7 00         BRK
d5a8 00         BRK
d5a9 f029       BEQ d5d4
d5ab 00         BRK
d5ac 00         BRK
d5ad f049       BEQ d5f8
d5af 00         BRK
d5b0 f000       BEQ d5b2
d5b2 00         BRK
d5b3 00         BRK
d5b4 f000       BEQ d5b6
d5b6 00         BRK
d5b7 00         BRK
d5b8 f000       BEQ d5ba
d5ba 00         BRK
d5bb f000       BEQ d5bd
d5bd f000       BEQ d5bf
d5bf f000       BEQ d5c1
d5c1 00         BRK
d5c2 00         BRK
d5c3 f000       BEQ d5c5
d5c5 00         BRK
d5c6 f000       BEQ d5c8
d5c8 f000       BEQ d5ca
d5ca f000       BEQ d5cc
d5cc 00         BRK
d5cd 00         BRK
d5ce f000       BEQ d5d0
d5d0 00         BRK
d5d1 f049       BEQ d61c
d5d3 f000       BEQ d5d5
d5d5 f000       BEQ d5d7
d5d7 00         BRK
d5d8 00         BRK
d5d9 f000       BEQ d5db
d5db 29f0       AND #$f0
d5dd 00         BRK
d5de f069       BEQ d649
d5e0 f000       BEQ d5e2
d5e2 00         BRK
d5e3 00         BRK
d5e4 f000       BEQ d5e6
d5e6 00         BRK
d5e7 f059       BEQ d642
d5e9 f000       BEQ d5eb
d5eb f000       BEQ d5ed
d5ed 00         BRK
d5ee 00         BRK
d5ef f000       BEQ d5f1
d5f1 00         BRK
d5f2 f000       BEQ d5f4
d5f4 f000       BEQ d5f6
d5f6 f000       BEQ d5f8
d5f8 00         BRK
d5f9 00         BRK
d5fa f000       BEQ d5fc
d5fc 00         BRK
d5fd f000       BEQ d5ff
d5ff f000       BEQ d601
d601 f000       BEQ d603
d603 00         BRK
d604 00         BRK
d605 f039       BEQ d640
d607 00         BRK
d608 00         BRK
d609 00         BRK
d60a f000       BEQ d60c
d60c 00         BRK
d60d 00         BRK
d60e 00         BRK
d60f 00         BRK
d610 f000       BEQ d612
d612 00         BRK
d613 00         BRK
d614 00         BRK
d615 f000       BEQ d617
d617 00         BRK
d618 00         BRK
d619 2900       AND #$00
d61b f0f0       BEQ d60d
d61d f0f0       BEQ d60f
d61f f0f0       BEQ d611
d621 f0f0       BEQ d613
d623 f0f0       BEQ d615
d625 00         BRK
d626 00         BRK
d627 00         BRK
d628 00         BRK
d629 00         BRK
d62a 00         BRK
d62b 00         BRK
d62c 00         BRK
d62d 00         BRK
d62e 00         BRK
d62f 00         BRK
d630 00         BRK
d631 00         BRK
d632 00         BRK
d633 00         BRK
d634 00         BRK
d635 00         BRK
d636 00         BRK
d637 00         BRK
d638 00         BRK
d639 00         BRK
d63a 00         BRK
d63b 00         BRK
d63c 00         BRK
d63d 00         BRK
d63e 00         BRK
d63f 00         BRK
d640 00         BRK
d641 00         BRK
d642 00         BRK
d643 00         BRK
d644 00         BRK
d645 00         BRK
d646 00         BRK
d647 00         BRK
d648 00         BRK
d649 00         BRK
d64a 00         BRK
d64b 00         BRK
d64c 00         BRK
d64d 00         BRK
d64e 00         BRK
d64f 00         BRK
d650 00         BRK
d651 00         BRK
d652 00         BRK
d653 00         BRK
d654 00         BRK
d655 00         BRK
d656 00         BRK
d657 00         BRK
d658 00         BRK
d659 00         BRK
d65a 00         BRK
d65b 00         BRK
d65c 00         BRK
d65d 00         BRK
d65e 00         BRK
d65f db 0f
d660 3016       BMI d678
d662 100f       BPL d673
d664 1628       ASL $28, X
d666 260f       ROL $0f
d668 1621       ASL $21, X
d66a 160f       ASL $0f, X
d66c 1629       ASL $29, X
d66e 1100       ORA ($00), Y
d670 00         BRK
d671 6e6c6c     ROR $6c6c
d674 6e6e00     ROR $006e
d677 00         BRK
d678 00         BRK
d679 00         BRK
d67a 00         BRK
d67b 00         BRK
d67c 00         BRK
d67d 00         BRK
d67e 7c0800     JMP (ABS) $0008, X
d681 00         BRK
d682 00         BRK
d683 00         BRK
d684 00         BRK
d685 00         BRK
d686 00         BRK
d687 00         BRK
d688 00         BRK
d689 00         BRK
d68a 00         BRK
d68b 00         BRK
d68c 00         BRK
d68d 00         BRK
d68e 00         BRK
d68f 00         BRK
d690 00         BRK
d691 00         BRK
d692 00         BRK
d693 00         BRK
d694 00         BRK
d695 00         BRK
d696 00         BRK
d697 00         BRK
d698 00         BRK
d699 00         BRK
d69a 00         BRK
d69b 00         BRK
d69c 00         BRK
d69d 00         BRK
d69e 00         BRK
d69f 00         BRK
d6a0 00         BRK
d6a1 00         BRK
d6a2 00         BRK
d6a3 00         BRK
d6a4 00         BRK
d6a5 00         BRK
d6a6 00         BRK
d6a7 00         BRK
d6a8 00         BRK
d6a9 00         BRK
d6aa 00         BRK
d6ab 00         BRK
d6ac 00         BRK
d6ad 8181       STA ($81, X)
d6af 00         BRK
d6b0 1111       ORA ($11), Y
d6b2 1100       ORA ($00), Y
d6b4 8181       STA ($81, X)
d6b6 00         BRK
d6b7 00         BRK
d6b8 1111       ORA ($11), Y
d6ba 00         BRK
d6bb 8181       STA ($81, X)
d6bd 8100       STA ($00, X)
d6bf 1111       ORA ($11), Y
d6c1 00         BRK
d6c2 00         BRK
d6c3 6161       ADC ($61, X)
d6c5 00         BRK
d6c6 5159       EOR ($59), Y
d6c8 5100       EOR ($00), Y
d6ca 6169       ADC ($69, X)
d6cc 00         BRK
d6cd 00         BRK
d6ce 7179       ADC ($79), Y
d6d0 00         BRK
d6d1 4141       EOR ($41, X)
d6d3 4100       EOR ($00, X)
d6d5 7171       ADC ($71), Y
d6d7 00         BRK
d6d8 00         BRK
d6d9 4141       EOR ($41, X)
d6db 00         BRK
d6dc 7171       ADC ($71), Y
d6de 7100       ADC ($00), Y
d6e0 4141       EOR ($41, X)
d6e2 00         BRK
d6e3 00         BRK
d6e4 5151       EOR ($51), Y
d6e6 00         BRK
d6e7 6169       ADC ($69, X)
d6e9 6100       ADC ($00, X)
d6eb 5151       EOR ($51), Y
d6ed 00         BRK
d6ee 00         BRK
d6ef 8981       STA #$81
d6f1 00         BRK
d6f2 1111       ORA ($11), Y
d6f4 1100       ORA ($00), Y
d6f6 8981       STA #$81
d6f8 00         BRK
d6f9 00         BRK
d6fa 1111       ORA ($11), Y
d6fc 00         BRK
d6fd 8181       STA ($81, X)
d6ff 8100       STA ($00, X)
d701 1111       ORA ($11), Y
d703 00         BRK
d704 00         BRK
d705 00         BRK
d706 00         BRK
d707 00         BRK
d708 00         BRK
d709 00         BRK
d70a 00         BRK
d70b 00         BRK
d70c 00         BRK
d70d 00         BRK
d70e 00         BRK
d70f 00         BRK
d710 00         BRK
d711 00         BRK
d712 00         BRK
d713 00         BRK
d714 00         BRK
d715 00         BRK
d716 00         BRK
d717 00         BRK
d718 00         BRK
d719 00         BRK
d71a 00         BRK
d71b 00         BRK
d71c 00         BRK
d71d 00         BRK
d71e 00         BRK
d71f 00         BRK
d720 00         BRK
d721 00         BRK
d722 00         BRK
d723 00         BRK
d724 00         BRK
d725 00         BRK
d726 00         BRK
d727 00         BRK
d728 00         BRK
d729 00         BRK
d72a 00         BRK
d72b 00         BRK
d72c 00         BRK
d72d 00         BRK
d72e 00         BRK
d72f 00         BRK
d730 00         BRK
d731 00         BRK
d732 00         BRK
d733 00         BRK
d734 00         BRK
d735 00         BRK
d736 00         BRK
d737 00         BRK
d738 00         BRK
d739 00         BRK
d73a 00         BRK
d73b 00         BRK
d73c 00         BRK
d73d 00         BRK
d73e 00         BRK
d73f 00         BRK
d740 00         BRK
d741 00         BRK
d742 00         BRK
d743 00         BRK
d744 00         BRK
d745 00         BRK
d746 00         BRK
d747 00         BRK
d748 00         BRK
d749 00         BRK
d74a 00         BRK
d74b 00         BRK
d74c 00         BRK
d74d 00         BRK
d74e 00         BRK
d74f 00         BRK
d750 00         BRK
d751 00         BRK
d752 00         BRK
d753 00         BRK
d754 00         BRK
d755 00         BRK
d756 00         BRK
d757 00         BRK
d758 00         BRK
d759 00         BRK
d75a 00         BRK
d75b 00         BRK
d75c 00         BRK
d75d 00         BRK
d75e 00         BRK
d75f db 0f
d760 3016       BMI d778
d762 100f       BPL d773
d764 0127       ORA ($27, X)
d766 300f       BMI d777
d768 0111       ORA ($11, X)
d76a 250f       AND $0f
d76c 0116       ORA ($16, X)
d76e 2900       AND #$00
d770 6e0000     ROR $0000
d773 6e6c6c     ROR $6c6c
d776 6e6c00     ROR $006c
d779 00         BRK
d77a 00         BRK
d77b 00         BRK
d77c 00         BRK
d77d 00         BRK
d77e 00         BRK
d77f 38         SEC
d780 00         BRK
d781 00         BRK
d782 00         BRK
d783 00         BRK
d784 00         BRK
d785 00         BRK
d786 00         BRK
d787 00         BRK
d788 00         BRK
d789 00         BRK
d78a 00         BRK
d78b 00         BRK
d78c 00         BRK
d78d 00         BRK
d78e 00         BRK
d78f 00         BRK
d790 00         BRK
d791 00         BRK
d792 00         BRK
d793 00         BRK
d794 00         BRK
d795 00         BRK
d796 00         BRK
d797 00         BRK
d798 00         BRK
d799 00         BRK
d79a 00         BRK
d79b 00         BRK
d79c 00         BRK
d79d 00         BRK
d79e 00         BRK
d79f 00         BRK
d7a0 00         BRK
d7a1 59e3e3     EOR $e3e3, Y
d7a4 db e3
d7a5 db e3
d7a6 db e3
d7a7 db e3
d7a8 db e3
d7a9 db e3
d7aa db e3
d7ab 59f000     EOR $00f0, Y
d7ae 00         BRK
d7af 00         BRK
d7b0 00         BRK
d7b1 00         BRK
d7b2 00         BRK
d7b3 00         BRK
d7b4 00         BRK
d7b5 00         BRK
d7b6 f069       BEQ d821
d7b8 6161       ADC ($61, X)
d7ba 6161       ADC ($61, X)
d7bc 6161       ADC ($61, X)
d7be 6161       ADC ($61, X)
d7c0 6161       ADC ($61, X)
d7c2 00         BRK
d7c3 00         BRK
d7c4 00         BRK
d7c5 00         BRK
d7c6 00         BRK
d7c7 00         BRK
d7c8 00         BRK
d7c9 00         BRK
d7ca 00         BRK
d7cb 00         BRK
d7cc 00         BRK
d7cd 29e3       AND #$e3
d7cf db e3
d7d0 db e3
d7d1 db e3
d7d2 db e3
d7d3 db e3
d7d4 db e3
d7d5 db e3
d7d6 db e3
d7d7 29f0       AND #$f0
d7d9 00         BRK
d7da 00         BRK
d7db 00         BRK
d7dc 00         BRK
d7dd 00         BRK
d7de 00         BRK
d7df 00         BRK
d7e0 00         BRK
d7e1 00         BRK
d7e2 f061       BEQ d845
d7e4 6161       ADC ($61, X)
d7e6 6161       ADC ($61, X)
d7e8 6161       ADC ($61, X)
d7ea 6161       ADC ($61, X)
d7ec 6169       ADC ($69, X)
d7ee 00         BRK
d7ef 00         BRK
d7f0 00         BRK
d7f1 00         BRK
d7f2 00         BRK
d7f3 00         BRK
d7f4 00         BRK
d7f5 00         BRK
d7f6 00         BRK
d7f7 00         BRK
d7f8 00         BRK
d7f9 69e3       ADC #$e3
d7fb db e3
d7fc db e3
d7fd db e3
d7fe db e3
d7ff db e3
d800 db e3
d801 db e3
d802 db e3
d803 69f0       ADC #$f0
d805 00         BRK
d806 00         BRK
d807 00         BRK
d808 00         BRK
d809 00         BRK
d80a 00         BRK
d80b 00         BRK
d80c 00         BRK
d80d 00         BRK
d80e f059       BEQ d869
d810 5151       EOR ($51), Y
d812 5151       EOR ($51), Y
d814 5151       EOR ($51), Y
d816 5151       EOR ($51), Y
d818 5159       EOR ($59), Y
d81a 00         BRK
d81b 00         BRK
d81c 00         BRK
d81d 00         BRK
d81e 00         BRK
d81f 00         BRK
d820 00         BRK
d821 00         BRK
d822 00         BRK
d823 00         BRK
d824 00         BRK
d825 595151     EOR $5151, Y
d828 5151       EOR ($51), Y
d82a 5151       EOR ($51), Y
d82c 5151       EOR ($51), Y
d82e 5159       EOR ($59), Y
d830 f000       BEQ d832
d832 00         BRK
d833 00         BRK
d834 00         BRK
d835 00         BRK
d836 00         BRK
d837 00         BRK
d838 00         BRK
d839 00         BRK
d83a f000       BEQ d83c
d83c 00         BRK
d83d 00         BRK
d83e 00         BRK
d83f 00         BRK
d840 00         BRK
d841 00         BRK
d842 00         BRK
d843 00         BRK
d844 00         BRK
d845 00         BRK
d846 00         BRK
d847 00         BRK
d848 00         BRK
d849 00         BRK
d84a 00         BRK
d84b 00         BRK
d84c 00         BRK
d84d 00         BRK
d84e 00         BRK
d84f 00         BRK
d850 00         BRK
d851 00         BRK
d852 00         BRK
d853 00         BRK
d854 00         BRK
d855 00         BRK
d856 00         BRK
d857 00         BRK
d858 00         BRK
d859 00         BRK
d85a 00         BRK
d85b 00         BRK
d85c 00         BRK
d85d 00         BRK
d85e 00         BRK
d85f db 0f
d860 3016       BMI d878
d862 100f       BPL d873
d864 0928       ORA #$28
d866 110f       ORA ($0f), Y
d868 0928       ORA #$28
d86a 160f       ASL $0f, X
d86c 0910       ORA #$10
d86e 2600       ROL $00
d870 00         BRK
d871 6e0000     ROR $0000
d874 6e6e00     ROR $006e
d877 00         BRK
d878 00         BRK
d879 00         BRK
d87a 00         BRK
d87b 00         BRK
d87c 00         BRK
d87d 7c7c4d     JMP (ABS) $4d7c, X
d880 00         BRK
d881 00         BRK
d882 00         BRK
d883 00         BRK
d884 00         BRK
d885 00         BRK
d886 00         BRK
d887 00         BRK
d888 00         BRK
d889 00         BRK
d88a 00         BRK
d88b 00         BRK
d88c 00         BRK
d88d 00         BRK
d88e 00         BRK
d88f 00         BRK
d890 00         BRK
d891 00         BRK
d892 00         BRK
d893 00         BRK
d894 00         BRK
d895 00         BRK
d896 00         BRK
d897 00         BRK
d898 00         BRK
d899 00         BRK
d89a 00         BRK
d89b 00         BRK
d89c 00         BRK
d89d 00         BRK
d89e 00         BRK
d89f 00         BRK
d8a0 00         BRK
d8a1 31e3       AND ($e3), Y
d8a3 db e3
d8a4 3131       AND ($31), Y
d8a6 3131       AND ($31), Y
d8a8 31e3       AND ($e3), Y
d8aa db e3
d8ab 3931e3     AND $e331, Y
d8ae 81e3       STA ($e3, X)
d8b0 3131       AND ($31), Y
d8b2 31e3       AND ($e3), Y
d8b4 41e3       EOR ($e3, X)
d8b6 3131       AND ($31), Y
d8b8 db e3
d8b9 8181       STA ($81, X)
d8bb db e3
d8bc db e3
d8bd db e3
d8be 4941       EOR #$41
d8c0 db e3
d8c1 3139       AND ($39), Y
d8c3 db e3
d8c4 8189       STA ($89, X)
d8c6 81e3       STA ($e3, X)
d8c8 4141       EOR ($41, X)
d8ca 41e3       EOR ($e3, X)
d8cc 3131       AND ($31), Y
d8ce db e3
d8cf 8181       STA ($81, X)
d8d1 89e3       STA #$e3
d8d3 4149       EOR ($49, X)
d8d5 41e3       EOR ($e3, X)
d8d7 3131       AND ($31), Y
d8d9 db e3
d8da 8181       STA ($81, X)
d8dc 81e3       STA ($e3, X)
d8de 4141       EOR ($41, X)
d8e0 49e3       EOR #$e3
d8e2 3131       AND ($31), Y
d8e4 db e3
d8e5 8981       STA #$81
d8e7 81e3       STA ($e3, X)
d8e9 4141       EOR ($41, X)
d8eb 41e3       EOR ($e3, X)
d8ed 3131       AND ($31), Y
d8ef db e3
d8f0 8181       STA ($81, X)
d8f2 81e3       STA ($e3, X)
d8f4 4141       EOR ($41, X)
d8f6 49e3       EOR #$e3
d8f8 3931e3     AND $e331, Y
d8fb 8181       STA ($81, X)
d8fd 81e3       STA ($e3, X)
d8ff 4941       EOR #$41
d901 41e3       EOR ($e3, X)
d903 3139       AND ($39), Y
d905 31e3       AND ($e3), Y
d907 8181       STA ($81, X)
d909 db e3
d90a 4141       EOR ($41, X)
d90c db e3
d90d 393131     AND $3131, Y
d910 3139       AND ($39), Y
d912 db e3
d913 81e3       STA ($e3, X)
d915 41e3       EOR ($e3, X)
d917 3131       AND ($31), Y
d919 3131       AND ($31), Y
d91b 3131       AND ($31), Y
d91d 31e3       AND ($e3), Y
d91f db e3
d920 db e3
d921 3131       AND ($31), Y
d923 3131       AND ($31), Y
d925 00         BRK
d926 00         BRK
d927 00         BRK
d928 00         BRK
d929 00         BRK
d92a 00         BRK
d92b 00         BRK
d92c 00         BRK
d92d 00         BRK
d92e 00         BRK
d92f 00         BRK
d930 00         BRK
d931 00         BRK
d932 00         BRK
d933 00         BRK
d934 00         BRK
d935 00         BRK
d936 00         BRK
d937 00         BRK
d938 00         BRK
d939 00         BRK
d93a 00         BRK
d93b 00         BRK
d93c 00         BRK
d93d 00         BRK
d93e 00         BRK
d93f 00         BRK
d940 00         BRK
d941 00         BRK
d942 00         BRK
d943 00         BRK
d944 00         BRK
d945 00         BRK
d946 00         BRK
d947 00         BRK
d948 00         BRK
d949 00         BRK
d94a 00         BRK
d94b 00         BRK
d94c 00         BRK
d94d 00         BRK
d94e 00         BRK
d94f 00         BRK
d950 00         BRK
d951 00         BRK
d952 00         BRK
d953 00         BRK
d954 00         BRK
d955 00         BRK
d956 00         BRK
d957 00         BRK
d958 00         BRK
d959 00         BRK
d95a 00         BRK
d95b 00         BRK
d95c 00         BRK
d95d 00         BRK
d95e 00         BRK
d95f db 0f
d960 3016       BMI d978
d962 100f       BPL d973
d964 0110       ORA ($10, X)
d966 210f       AND ($0f, X)
d968 0110       ORA ($10, X)
d96a db 27
d96b db 0f
d96c 0110       ORA ($10, X)
d96e 2900       AND #$00
d970 00         BRK
d971 00         BRK
d972 6e6e00     ROR $006e
d975 00         BRK
d976 00         BRK
d977 6e0000     ROR $0000
d97a 00         BRK
d97b 00         BRK
d97c 00         BRK
d97d 7c0084     JMP (ABS) $8400, X
d980 00         BRK
d981 00         BRK
d982 00         BRK
d983 00         BRK
d984 00         BRK
d985 00         BRK
d986 00         BRK
d987 00         BRK
d988 00         BRK
d989 00         BRK
d98a 00         BRK
d98b 00         BRK
d98c 00         BRK
d98d 00         BRK
d98e 00         BRK
d98f 00         BRK
d990 00         BRK
d991 00         BRK
d992 00         BRK
d993 00         BRK
d994 00         BRK
d995 00         BRK
d996 00         BRK
d997 00         BRK
d998 00         BRK
d999 00         BRK
d99a 00         BRK
d99b f000       BEQ d99d
d99d 00         BRK
d99e 00         BRK
d99f 00         BRK
d9a0 00         BRK
d9a1 00         BRK
d9a2 00         BRK
d9a3 00         BRK
d9a4 1119       ORA ($19), Y
d9a6 00         BRK
d9a7 191100     ORA $0011, Y
d9aa 00         BRK
d9ab 00         BRK
d9ac 00         BRK
d9ad 191900     ORA $0019, Y
d9b0 00         BRK
d9b1 f000       BEQ d9b3
d9b3 00         BRK
d9b4 191900     ORA $0019, Y
d9b7 1100       ORA ($00), Y
d9b9 00         BRK
d9ba 8989       STA #$89
d9bc 00         BRK
d9bd 8989       STA #$89
d9bf 00         BRK
d9c0 00         BRK
d9c1 1100       ORA ($00), Y
d9c3 8181       STA ($81, X)
d9c5 00         BRK
d9c6 00         BRK
d9c7 f000       BEQ d9c9
d9c9 00         BRK
d9ca 8181       STA ($81, X)
d9cc 00         BRK
d9cd 8900       STA #$00
d9cf 00         BRK
d9d0 4141       EOR ($41, X)
d9d2 00         BRK
d9d3 4141       EOR ($41, X)
d9d5 00         BRK
d9d6 00         BRK
d9d7 8900       STA #$00
d9d9 4949       EOR #$49
d9db 00         BRK
d9dc 00         BRK
d9dd f000       BEQ d9df
d9df 00         BRK
d9e0 4141       EOR ($41, X)
d9e2 00         BRK
d9e3 4100       EOR ($00, X)
d9e5 00         BRK
d9e6 5159       EOR ($59), Y
d9e8 00         BRK
d9e9 595900     EOR $0059, Y
d9ec 00         BRK
d9ed 4900       EOR #$00
d9ef 5151       EOR ($51), Y
d9f1 00         BRK
d9f2 00         BRK
d9f3 f000       BEQ d9f5
d9f5 00         BRK
d9f6 5159       EOR ($59), Y
d9f8 00         BRK
d9f9 5100       EOR ($00), Y
d9fb 00         BRK
d9fc 6969       ADC #$69
d9fe 00         BRK
d9ff 6161       ADC ($61, X)
da01 00         BRK
da02 00         BRK
da03 5100       EOR ($00), Y
da05 6969       ADC #$69
da07 00         BRK
da08 00         BRK
da09 f000       BEQ da0b
da0b 00         BRK
da0c 6969       ADC #$69
da0e 00         BRK
da0f 6900       ADC #$00
da11 00         BRK
da12 4149       EOR ($49, X)
da14 00         BRK
da15 4949       EOR #$49
da17 00         BRK
da18 00         BRK
da19 6900       ADC #$00
da1b 4941       EOR #$41
da1d 00         BRK
da1e 00         BRK
da1f 00         BRK
da20 00         BRK
da21 00         BRK
da22 4149       EOR ($49, X)
da24 00         BRK
da25 4900       EOR #$00
da27 00         BRK
da28 00         BRK
da29 00         BRK
da2a 00         BRK
da2b 00         BRK
da2c 00         BRK
da2d 00         BRK
da2e 00         BRK
da2f 4900       EOR #$00
da31 00         BRK
da32 00         BRK
da33 00         BRK
da34 00         BRK
da35 00         BRK
da36 00         BRK
da37 00         BRK
da38 00         BRK
da39 00         BRK
da3a 00         BRK
da3b 00         BRK
da3c 00         BRK
da3d 00         BRK
da3e 00         BRK
da3f 00         BRK
da40 00         BRK
da41 00         BRK
da42 00         BRK
da43 00         BRK
da44 00         BRK
da45 00         BRK
da46 00         BRK
da47 00         BRK
da48 00         BRK
da49 00         BRK
da4a 00         BRK
da4b 00         BRK
da4c 00         BRK
da4d 00         BRK
da4e 00         BRK
da4f 00         BRK
da50 00         BRK
da51 00         BRK
da52 00         BRK
da53 00         BRK
da54 00         BRK
da55 00         BRK
da56 00         BRK
da57 00         BRK
da58 00         BRK
da59 00         BRK
da5a 00         BRK
da5b 00         BRK
da5c 00         BRK
da5d 00         BRK
da5e 00         BRK
da5f db 0f
da60 3016       BMI da78
da62 100f       BPL da73
da64 1628       ASL $28, X
da66 300f       BMI da77
da68 1627       ASL $27, X
da6a 290f       AND #$0f
da6c 1616       ASL $16, X
da6e 1100       ORA ($00), Y
da70 6e0000     ROR $0000
da73 6e6c6e     ROR $6e6c
da76 00         BRK
da77 6c0000     JMP (ABS) $0000
da7a 00         BRK
da7b 00         BRK
da7c 00         BRK
da7d 00         BRK
da7e 7c3c00     JMP (ABS) $003c, X
da81 00         BRK
da82 00         BRK
da83 00         BRK
da84 00         BRK
da85 00         BRK
da86 00         BRK
da87 00         BRK
da88 00         BRK
da89 00         BRK
da8a 00         BRK
da8b 00         BRK
da8c 00         BRK
da8d 00         BRK
da8e 00         BRK
da8f 00         BRK
da90 00         BRK
da91 00         BRK
da92 00         BRK
da93 00         BRK
da94 00         BRK
da95 00         BRK
da96 00         BRK
da97 00         BRK
da98 00         BRK
da99 00         BRK
da9a 00         BRK
da9b e400       CPX $00
da9d 00         BRK
da9e 00         BRK
da9f 00         BRK
daa0 00         BRK
daa1 00         BRK
daa2 00         BRK
daa3 00         BRK
daa4 6161       ADC ($61, X)
daa6 e441       CPX $41
daa8 4100       EOR ($00, X)
daaa 00         BRK
daab 00         BRK
daac 00         BRK
daad 00         BRK
daae 6961       ADC #$61
dab0 1111       ORA ($11), Y
dab2 1149       ORA ($49), Y
dab4 4100       EOR ($00, X)
dab6 00         BRK
dab7 00         BRK
dab8 6161       ADC ($61, X)
daba 1111       ORA ($11), Y
dabc 1111       ORA ($11), Y
dabe 1141       ORA ($41), Y
dac0 4900       EOR #$00
dac2 00         BRK
dac3 6161       ADC ($61, X)
dac5 1111       ORA ($11), Y
dac7 1111       ORA ($11), Y
dac9 1141       ORA ($41), Y
dacb 4100       EOR ($00, X)
dacd 00         BRK
dace 6169       ADC ($69, X)
dad0 1119       ORA ($19), Y
dad2 191119     ORA $1911, Y
dad5 4149       EOR ($49, X)
dad7 00         BRK
dad8 00         BRK
dad9 e400       CPX $00
dadb e400       CPX $00
dadd e400       CPX $00
dadf e400       CPX $00
dae1 e400       CPX $00
dae3 00         BRK
dae4 00         BRK
dae5 00         BRK
dae6 00         BRK
dae7 00         BRK
dae8 e400       CPX $00
daea 00         BRK
daeb 00         BRK
daec 00         BRK
daed 00         BRK
daee 00         BRK
daef 00         BRK
daf0 00         BRK
daf1 00         BRK
daf2 00         BRK
daf3 e400       CPX $00
daf5 00         BRK
daf6 00         BRK
daf7 00         BRK
daf8 00         BRK
daf9 00         BRK
dafa 00         BRK
dafb 00         BRK
dafc f000       BEQ dafe
dafe f000       BEQ db00
db00 00         BRK
db01 00         BRK
db02 00         BRK
db03 00         BRK
db04 00         BRK
db05 00         BRK
db06 00         BRK
db07 f0f0       BEQ daf9
db09 f000       BEQ db0b
db0b 00         BRK
db0c 00         BRK
db0d 00         BRK
db0e 00         BRK
db0f 00         BRK
db10 00         BRK
db11 00         BRK
db12 00         BRK
db13 f000       BEQ db15
db15 00         BRK
db16 00         BRK
db17 00         BRK
db18 00         BRK
db19 00         BRK
db1a 00         BRK
db1b 00         BRK
db1c 00         BRK
db1d 00         BRK
db1e 00         BRK
db1f 00         BRK
db20 00         BRK
db21 00         BRK
db22 00         BRK
db23 00         BRK
db24 00         BRK
db25 00         BRK
db26 00         BRK
db27 00         BRK
db28 00         BRK
db29 00         BRK
db2a 00         BRK
db2b 00         BRK
db2c 00         BRK
db2d 00         BRK
db2e 00         BRK
db2f 00         BRK
db30 00         BRK
db31 00         BRK
db32 00         BRK
db33 00         BRK
db34 00         BRK
db35 00         BRK
db36 00         BRK
db37 00         BRK
db38 00         BRK
db39 00         BRK
db3a 00         BRK
db3b 00         BRK
db3c 00         BRK
db3d 00         BRK
db3e 00         BRK
db3f 00         BRK
db40 00         BRK
db41 00         BRK
db42 00         BRK
db43 00         BRK
db44 00         BRK
db45 00         BRK
db46 00         BRK
db47 00         BRK
db48 00         BRK
db49 00         BRK
db4a 00         BRK
db4b 00         BRK
db4c 00         BRK
db4d 00         BRK
db4e 00         BRK
db4f 00         BRK
db50 00         BRK
db51 00         BRK
db52 00         BRK
db53 00         BRK
db54 00         BRK
db55 00         BRK
db56 00         BRK
db57 00         BRK
db58 00         BRK
db59 00         BRK
db5a 00         BRK
db5b 00         BRK
db5c 00         BRK
db5d 00         BRK
db5e 00         BRK
db5f db 0f
db60 3016       BMI db78
db62 100f       BPL db73
db64 0128       ORA ($28, X)
db66 100f       BPL db77
db68 0111       ORA ($11, X)
db6a 300f       BMI db7b
db6c 0129       ORA ($29, X)
db6e 3000       BMI db70
db70 6e0000     ROR $0000
db73 6c006c     JMP (ABS) $6c00
db76 00         BRK
db77 00         BRK
db78 00         BRK
db79 00         BRK
db7a 00         BRK
db7b 00         BRK
db7c 00         BRK
db7d 7e7c2f     ROR $2f7c, X
db80 00         BRK
db81 00         BRK
db82 00         BRK
db83 00         BRK
db84 00         BRK
db85 00         BRK
db86 00         BRK
db87 00         BRK
db88 00         BRK
db89 00         BRK
db8a 00         BRK
db8b 00         BRK
db8c 00         BRK
db8d 00         BRK
db8e 00         BRK
db8f 00         BRK
db90 00         BRK
db91 00         BRK
db92 00         BRK
db93 00         BRK
db94 00         BRK
db95 00         BRK
db96 00         BRK
db97 00         BRK
db98 00         BRK
db99 00         BRK
db9a 00         BRK
db9b 00         BRK
db9c 00         BRK
db9d 00         BRK
db9e 00         BRK
db9f 00         BRK
dba0 00         BRK
dba1 2100       AND ($00, X)
dba3 f081       BEQ db26
dba5 8989       STA #$89
dba7 8181       STA ($81, X)
dba9 f000       BEQ dbab
dbab 2129       AND ($29, X)
dbad 00         BRK
dbae f0f0       BEQ dba0
dbb0 8181       STA ($81, X)
dbb2 89f0       STA #$f0
dbb4 f000       BEQ dbb6
dbb6 2121       AND ($21, X)
dbb8 00         BRK
dbb9 f000       BEQ dbbb
dbbb f081       BEQ db3e
dbbd f000       BEQ dbbf
dbbf f000       BEQ dbc1
dbc1 2921       AND #$21
dbc3 00         BRK
dbc4 f000       BEQ dbc6
dbc6 49e4       EOR #$e4
dbc8 4100       EOR ($00, X)
dbca f000       BEQ dbcc
dbcc 2121       AND ($21, X)
dbce 00         BRK
dbcf f000       BEQ dbd1
dbd1 4100       EOR ($00, X)
dbd3 4900       EOR #$00
dbd5 f000       BEQ dbd7
dbd7 2121       AND ($21, X)
dbd9 00         BRK
dbda f000       BEQ dbdc
dbdc 4100       EOR ($00, X)
dbde 4100       EOR ($00, X)
dbe0 f000       BEQ dbe2
dbe2 2121       AND ($21, X)
dbe4 00         BRK
dbe5 f000       BEQ dbe7
dbe7 4900       EOR #$00
dbe9 4100       EOR ($00, X)
dbeb f000       BEQ dbed
dbed 2129       AND ($29, X)
dbef 00         BRK
dbf0 f000       BEQ dbf2
dbf2 4100       EOR ($00, X)
dbf4 4900       EOR #$00
dbf6 f000       BEQ dbf8
dbf8 2121       AND ($21, X)
dbfa 00         BRK
dbfb f000       BEQ dbfd
dbfd 4900       EOR #$00
dbff 4900       EOR #$00
dc01 f000       BEQ dc03
dc03 2921       AND #$21
dc05 f0f0       BEQ dbf7
dc07 f041       BEQ dc4a
dc09 00         BRK
dc0a 41f0       EOR ($f0, X)
dc0c f0f0       BEQ dbfe
dc0e 2100       AND ($00, X)
dc10 00         BRK
dc11 00         BRK
dc12 00         BRK
dc13 00         BRK
dc14 00         BRK
dc15 00         BRK
dc16 00         BRK
dc17 00         BRK
dc18 00         BRK
dc19 00         BRK
dc1a 00         BRK
dc1b 00         BRK
dc1c 00         BRK
dc1d 00         BRK
dc1e 00         BRK
dc1f 00         BRK
dc20 00         BRK
dc21 00         BRK
dc22 00         BRK
dc23 00         BRK
dc24 00         BRK
dc25 00         BRK
dc26 00         BRK
dc27 00         BRK
dc28 00         BRK
dc29 00         BRK
dc2a 00         BRK
dc2b 00         BRK
dc2c 00         BRK
dc2d 00         BRK
dc2e 00         BRK
dc2f 00         BRK
dc30 00         BRK
dc31 00         BRK
dc32 00         BRK
dc33 00         BRK
dc34 00         BRK
dc35 00         BRK
dc36 00         BRK
dc37 00         BRK
dc38 00         BRK
dc39 00         BRK
dc3a 00         BRK
dc3b 00         BRK
dc3c 00         BRK
dc3d 00         BRK
dc3e 00         BRK
dc3f 00         BRK
dc40 00         BRK
dc41 00         BRK
dc42 00         BRK
dc43 00         BRK
dc44 00         BRK
dc45 00         BRK
dc46 00         BRK
dc47 00         BRK
dc48 00         BRK
dc49 00         BRK
dc4a 00         BRK
dc4b 00         BRK
dc4c 00         BRK
dc4d 00         BRK
dc4e 00         BRK
dc4f 00         BRK
dc50 00         BRK
dc51 00         BRK
dc52 00         BRK
dc53 00         BRK
dc54 00         BRK
dc55 00         BRK
dc56 00         BRK
dc57 00         BRK
dc58 00         BRK
dc59 00         BRK
dc5a 00         BRK
dc5b 00         BRK
dc5c 00         BRK
dc5d 00         BRK
dc5e 00         BRK
dc5f db 0f
dc60 3016       BMI dc78
dc62 100f       BPL dc73
dc64 0928       ORA #$28
dc66 db 27
dc67 db 0f
dc68 0926       ORA #$26
dc6a 290f       AND #$0f
dc6c 0910       ORA #$10
dc6e 00         BRK
dc6f 00         BRK
dc70 00         BRK
dc71 6c006e     JMP (ABS) $6e00
dc74 00         BRK
dc75 00         BRK
dc76 00         BRK
dc77 6e0000     ROR $0000
dc7a 00         BRK
dc7b 00         BRK
dc7c 00         BRK
dc7d 7c7c2c     JMP (ABS) $2c7c, X
dc80 00         BRK
dc81 00         BRK
dc82 00         BRK
dc83 00         BRK
dc84 00         BRK
dc85 00         BRK
dc86 00         BRK
dc87 00         BRK
dc88 00         BRK
dc89 00         BRK
dc8a 00         BRK
dc8b 00         BRK
dc8c 00         BRK
dc8d 00         BRK
dc8e 00         BRK
dc8f 00         BRK
dc90 00         BRK
dc91 00         BRK
dc92 00         BRK
dc93 00         BRK
dc94 00         BRK
dc95 00         BRK
dc96 00         BRK
dc97 00         BRK
dc98 00         BRK
dc99 00         BRK
dc9a 00         BRK
dc9b 00         BRK
dc9c 00         BRK
dc9d 00         BRK
dc9e 00         BRK
dc9f 00         BRK
dca0 00         BRK
dca1 00         BRK
dca2 00         BRK
dca3 f0f0       BEQ dc95
dca5 f0f0       BEQ dc97
dca7 f0f0       BEQ dc99
dca9 f000       BEQ dcab
dcab 00         BRK
dcac 00         BRK
dcad 00         BRK
dcae 4159       EOR ($59, X)
dcb0 69f0       ADC #$f0
dcb2 6159       ADC ($59, X)
dcb4 4900       EOR #$00
dcb6 00         BRK
dcb7 00         BRK
dcb8 00         BRK
dcb9 4951       EOR #$51
dcbb 61f0       ADC ($f0, X)
dcbd 6959       ADC #$59
dcbf 4100       EOR ($00, X)
dcc1 00         BRK
dcc2 00         BRK
dcc3 00         BRK
dcc4 4151       EOR ($51, X)
dcc6 69f0       ADC #$f0
dcc8 6151       ADC ($51, X)
dcca 4100       EOR ($00, X)
dccc 00         BRK
dccd 00         BRK
dcce 00         BRK
dccf 4959       EOR #$59
dcd1 61f0       ADC ($f0, X)
dcd3 6951       ADC #$51
dcd5 4900       EOR #$00
dcd7 00         BRK
dcd8 00         BRK
dcd9 00         BRK
dcda 4151       EOR ($51, X)
dcdc 61f0       ADC ($f0, X)
dcde 6151       ADC ($51, X)
dce0 4100       EOR ($00, X)
dce2 00         BRK
dce3 00         BRK
dce4 00         BRK
dce5 4159       EOR ($59, X)
dce7 61f0       ADC ($f0, X)
dce9 6159       ADC ($59, X)
dceb 4100       EOR ($00, X)
dced 00         BRK
dcee 00         BRK
dcef 00         BRK
dcf0 4951       EOR #$51
dcf2 69f0       ADC #$f0
dcf4 6951       ADC #$51
dcf6 4900       EOR #$00
dcf8 00         BRK
dcf9 00         BRK
dcfa 00         BRK
dcfb f0f0       BEQ dced
dcfd f0f0       BEQ dcef
dcff f0f0       BEQ dcf1
dd01 f000       BEQ dd03
dd03 00         BRK
dd04 00         BRK
dd05 00         BRK
dd06 00         BRK
dd07 00         BRK
dd08 00         BRK
dd09 00         BRK
dd0a 00         BRK
dd0b 00         BRK
dd0c 00         BRK
dd0d 00         BRK
dd0e 00         BRK
dd0f 00         BRK
dd10 00         BRK
dd11 00         BRK
dd12 00         BRK
dd13 00         BRK
dd14 00         BRK
dd15 00         BRK
dd16 00         BRK
dd17 00         BRK
dd18 00         BRK
dd19 00         BRK
dd1a 00         BRK
dd1b 00         BRK
dd1c 00         BRK
dd1d 00         BRK
dd1e 00         BRK
dd1f 00         BRK
dd20 00         BRK
dd21 00         BRK
dd22 00         BRK
dd23 00         BRK
dd24 00         BRK
dd25 00         BRK
dd26 00         BRK
dd27 00         BRK
dd28 00         BRK
dd29 00         BRK
dd2a 00         BRK
dd2b 00         BRK
dd2c 00         BRK
dd2d 00         BRK
dd2e 00         BRK
dd2f 00         BRK
dd30 00         BRK
dd31 00         BRK
dd32 00         BRK
dd33 00         BRK
dd34 00         BRK
dd35 00         BRK
dd36 00         BRK
dd37 00         BRK
dd38 00         BRK
dd39 00         BRK
dd3a 00         BRK
dd3b 00         BRK
dd3c 00         BRK
dd3d 00         BRK
dd3e 00         BRK
dd3f 00         BRK
dd40 00         BRK
dd41 00         BRK
dd42 00         BRK
dd43 00         BRK
dd44 00         BRK
dd45 00         BRK
dd46 00         BRK
dd47 00         BRK
dd48 00         BRK
dd49 00         BRK
dd4a 00         BRK
dd4b 00         BRK
dd4c 00         BRK
dd4d 00         BRK
dd4e 00         BRK
dd4f 00         BRK
dd50 00         BRK
dd51 00         BRK
dd52 00         BRK
dd53 00         BRK
dd54 00         BRK
dd55 00         BRK
dd56 00         BRK
dd57 00         BRK
dd58 00         BRK
dd59 00         BRK
dd5a 00         BRK
dd5b 00         BRK
dd5c 00         BRK
dd5d 00         BRK
dd5e 00         BRK
dd5f db 0f
dd60 3016       BMI dd78
dd62 100f       BPL dd73
dd64 0128       ORA ($28, X)
dd66 290f       AND #$0f
dd68 0128       ORA ($28, X)
dd6a 160f       ASL $0f, X
dd6c 0128       ORA ($28, X)
dd6e 1100       ORA ($00), Y
dd70 00         BRK
dd71 00         BRK
dd72 00         BRK
dd73 6e6e6e     ROR $6e6e
dd76 00         BRK
dd77 00         BRK
dd78 00         BRK
dd79 00         BRK
dd7a 00         BRK
dd7b 00         BRK
dd7c 00         BRK
dd7d 00         BRK
dd7e 7c2a00     JMP (ABS) $002a, X
dd81 00         BRK
dd82 00         BRK
dd83 00         BRK
dd84 00         BRK
dd85 00         BRK
dd86 00         BRK
dd87 00         BRK
dd88 00         BRK
dd89 00         BRK
dd8a 00         BRK
dd8b 00         BRK
dd8c 00         BRK
dd8d 00         BRK
dd8e 00         BRK
dd8f 00         BRK
dd90 00         BRK
dd91 00         BRK
dd92 00         BRK
dd93 00         BRK
dd94 00         BRK
dd95 00         BRK
dd96 00         BRK
dd97 00         BRK
dd98 00         BRK
dd99 00         BRK
dd9a 00         BRK
dd9b 00         BRK
dd9c 00         BRK
dd9d 00         BRK
dd9e 00         BRK
dd9f 00         BRK
dda0 00         BRK
dda1 41f0       EOR ($f0, X)
dda3 29f0       AND #$f0
dda5 31f0       AND ($f0), Y
dda7 49f0       EOR #$f0
dda9 71f0       ADC ($f0), Y
ddab 2979       AND #$79
ddad f0e4       BEQ dd93
ddaf f0e4       BEQ dd95
ddb1 f0e4       BEQ dd97
ddb3 f0e4       BEQ dd99
ddb5 f039       BEQ ddf0
ddb7 00         BRK
ddb8 00         BRK
ddb9 7100       ADC ($00), Y
ddbb 00         BRK
ddbc 00         BRK
ddbd 00         BRK
ddbe 00         BRK
ddbf 00         BRK
ddc0 00         BRK
ddc1 00         BRK
ddc2 00         BRK
ddc3 f000       BEQ ddc5
ddc5 f071       BEQ de38
ddc7 f000       BEQ ddc9
ddc9 f000       BEQ ddcb
ddcb f000       BEQ ddcd
ddcd 00         BRK
ddce f000       BEQ ddd0
ddd0 f000       BEQ ddd2
ddd2 f079       BEQ de4d
ddd4 f000       BEQ ddd6
ddd6 f000       BEQ ddd8
ddd8 00         BRK
ddd9 f000       BEQ dddb
dddb f000       BEQ dddd
dddd f000       BEQ dddf
dddf f079       BEQ de5a
dde1 f000       BEQ dde3
dde3 00         BRK
dde4 00         BRK
dde5 00         BRK
dde6 00         BRK
dde7 00         BRK
dde8 00         BRK
dde9 00         BRK
ddea 00         BRK
ddeb 00         BRK
ddec 00         BRK
dded 00         BRK
ddee 00         BRK
ddef f000       BEQ ddf1
ddf1 f000       BEQ ddf3
ddf3 f071       BEQ de66
ddf5 f000       BEQ ddf7
ddf7 f000       BEQ ddf9
ddf9 00         BRK
ddfa f000       BEQ ddfc
ddfc f079       BEQ de77
ddfe f000       BEQ de00
de00 f000       BEQ de02
de02 f000       BEQ de04
de04 00         BRK
de05 00         BRK
de06 79f000     ADC $00f0, Y
de09 f000       BEQ de0b
de0b f000       BEQ de0d
de0d 00         BRK
de0e 00         BRK
de0f 790000     ADC $0000, Y
de12 00         BRK
de13 00         BRK
de14 f000       BEQ de16
de16 00         BRK
de17 00         BRK
de18 00         BRK
de19 00         BRK
de1a 00         BRK
de1b 00         BRK
de1c 00         BRK
de1d 00         BRK
de1e 00         BRK
de1f 00         BRK
de20 00         BRK
de21 00         BRK
de22 00         BRK
de23 00         BRK
de24 00         BRK
de25 00         BRK
de26 00         BRK
de27 00         BRK
de28 00         BRK
de29 00         BRK
de2a 00         BRK
de2b 00         BRK
de2c 00         BRK
de2d 00         BRK
de2e 00         BRK
de2f 00         BRK
de30 00         BRK
de31 00         BRK
de32 00         BRK
de33 00         BRK
de34 00         BRK
de35 00         BRK
de36 00         BRK
de37 00         BRK
de38 00         BRK
de39 00         BRK
de3a 00         BRK
de3b 00         BRK
de3c 00         BRK
de3d 00         BRK
de3e 00         BRK
de3f 00         BRK
de40 00         BRK
de41 00         BRK
de42 00         BRK
de43 00         BRK
de44 00         BRK
de45 00         BRK
de46 00         BRK
de47 00         BRK
de48 00         BRK
de49 00         BRK
de4a 00         BRK
de4b 00         BRK
de4c 00         BRK
de4d 00         BRK
de4e 00         BRK
de4f 00         BRK
de50 00         BRK
de51 00         BRK
de52 00         BRK
de53 00         BRK
de54 00         BRK
de55 00         BRK
de56 00         BRK
de57 00         BRK
de58 00         BRK
de59 00         BRK
de5a 00         BRK
de5b 00         BRK
de5c 00         BRK
de5d 00         BRK
de5e 00         BRK
de5f db 0f
de60 3016       BMI de78
de62 100f       BPL de73
de64 1628       ASL $28, X
de66 290f       AND #$0f
de68 1610       ASL $10, X
de6a 250f       AND $0f
de6c 1621       ASL $21, X
de6e 2600       ROL $00
de70 00         BRK
de71 6e6c6e     ROR $6e6c
de74 00         BRK
de75 00         BRK
de76 6e0000     ROR $0000
de79 00         BRK
de7a 00         BRK
de7b 00         BRK
de7c 00         BRK
de7d 7c7c14     JMP (ABS) $147c, X
de80 00         BRK
de81 00         BRK
de82 00         BRK
de83 00         BRK
de84 00         BRK
de85 00         BRK
de86 00         BRK
de87 00         BRK
de88 00         BRK
de89 00         BRK
de8a 00         BRK
de8b 00         BRK
de8c 00         BRK
de8d 00         BRK
de8e 00         BRK
de8f 00         BRK
de90 00         BRK
de91 00         BRK
de92 00         BRK
de93 00         BRK
de94 00         BRK
de95 00         BRK
de96 00         BRK
de97 00         BRK
de98 00         BRK
de99 00         BRK
de9a 00         BRK
de9b 00         BRK
de9c 00         BRK
de9d 00         BRK
de9e 00         BRK
de9f 00         BRK
dea0 00         BRK
dea1 00         BRK
dea2 f029       BEQ decd
dea4 2121       AND ($21, X)
dea6 2121       AND ($21, X)
dea8 2921       AND #$21
deaa f000       BEQ deac
deac 00         BRK
dead f000       BEQ deaf
deaf 00         BRK
deb0 00         BRK
deb1 00         BRK
deb2 00         BRK
deb3 00         BRK
deb4 00         BRK
deb5 f000       BEQ deb7
deb7 00         BRK
deb8 f000       BEQ deba
deba f0f0       BEQ deac
debc f0f0       BEQ deae
debe f000       BEQ dec0
dec0 f000       BEQ dec2
dec2 00         BRK
dec3 f000       BEQ dec5
dec5 f061       BEQ df28
dec7 6161       ADC ($61, X)
dec9 f000       BEQ decb
decb f000       BEQ decd
decd 00         BRK
dece f000       BEQ ded0
ded0 f079       BEQ df4b
ded2 7171       ADC ($71), Y
ded4 f000       BEQ ded6
ded6 f000       BEQ ded8
ded8 00         BRK
ded9 f000       BEQ dedb
dedb f041       BEQ df1e
dedd 4941       EOR #$41
dedf f000       BEQ dee1
dee1 f000       BEQ dee3
dee3 00         BRK
dee4 f000       BEQ dee6
dee6 f021       BEQ df09
dee8 2121       AND ($21, X)
deea f000       BEQ deec
deec f000       BEQ deee
deee 00         BRK
deef f000       BEQ def1
def1 f031       BEQ df24
def3 3139       AND ($39), Y
def5 f000       BEQ def7
def7 f000       BEQ def9
def9 00         BRK
defa f000       BEQ defc
defc 00         BRK
defd 00         BRK
defe 00         BRK
deff 00         BRK
df00 00         BRK
df01 00         BRK
df02 f000       BEQ df04
df04 00         BRK
df05 f000       BEQ df07
df07 00         BRK
df08 00         BRK
df09 00         BRK
df0a 00         BRK
df0b 00         BRK
df0c 00         BRK
df0d f000       BEQ df0f
df0f 00         BRK
df10 f0f0       BEQ df02
df12 f0f0       BEQ df04
df14 f0f0       BEQ df06
df16 f0f0       BEQ df08
df18 f000       BEQ df1a
df1a 00         BRK
df1b 00         BRK
df1c 00         BRK
df1d 00         BRK
df1e 00         BRK
df1f 00         BRK
df20 00         BRK
df21 00         BRK
df22 00         BRK
df23 00         BRK
df24 00         BRK
df25 00         BRK
df26 00         BRK
df27 00         BRK
df28 00         BRK
df29 00         BRK
df2a 00         BRK
df2b 00         BRK
df2c 00         BRK
df2d 00         BRK
df2e 00         BRK
df2f 00         BRK
df30 00         BRK
df31 00         BRK
df32 00         BRK
df33 00         BRK
df34 00         BRK
df35 00         BRK
df36 00         BRK
df37 00         BRK
df38 00         BRK
df39 00         BRK
df3a 00         BRK
df3b 00         BRK
df3c 00         BRK
df3d 00         BRK
df3e 00         BRK
df3f 00         BRK
df40 00         BRK
df41 00         BRK
df42 00         BRK
df43 00         BRK
df44 00         BRK
df45 00         BRK
df46 00         BRK
df47 00         BRK
df48 00         BRK
df49 00         BRK
df4a 00         BRK
df4b 00         BRK
df4c 00         BRK
df4d 00         BRK
df4e 00         BRK
df4f 00         BRK
df50 00         BRK
df51 00         BRK
df52 00         BRK
df53 00         BRK
df54 00         BRK
df55 00         BRK
df56 00         BRK
df57 00         BRK
df58 00         BRK
df59 00         BRK
df5a 00         BRK
df5b 00         BRK
df5c 00         BRK
df5d 00         BRK
df5e 00         BRK
df5f db 0f
df60 3016       BMI df78
df62 100f       BPL df73
df64 0128       ORA ($28, X)
df66 210f       AND ($0f, X)
df68 0126       ORA ($26, X)
df6a 290f       AND #$0f
df6c 0125       ORA ($25, X)
df6e 1100       ORA ($00), Y
df70 00         BRK
df71 6c6e6e     JMP (ABS) $6e6e
df74 00         BRK
df75 6e6c00     ROR $006c
df78 00         BRK
df79 00         BRK
df7a 00         BRK
df7b 00         BRK
df7c 00         BRK
df7d 00         BRK
df7e 7c1600     JMP (ABS) $0016, X
df81 00         BRK
df82 00         BRK
df83 00         BRK
df84 00         BRK
df85 00         BRK
df86 00         BRK
df87 00         BRK
df88 00         BRK
df89 00         BRK
df8a 00         BRK
df8b 00         BRK
df8c 00         BRK
df8d 00         BRK
df8e 00         BRK
df8f 00         BRK
df90 00         BRK
df91 00         BRK
df92 00         BRK
df93 00         BRK
df94 00         BRK
df95 00         BRK
df96 00         BRK
df97 00         BRK
df98 00         BRK
df99 00         BRK
df9a 00         BRK
df9b 00         BRK
df9c 00         BRK
df9d 00         BRK
df9e 00         BRK
df9f 00         BRK
dfa0 00         BRK
dfa1 8981       STA #$81
dfa3 8181       STA ($81, X)
dfa5 8981       STA #$81
dfa7 8181       STA ($81, X)
dfa9 8181       STA ($81, X)
dfab 8181       STA ($81, X)
dfad 8181       STA ($81, X)
dfaf 8181       STA ($81, X)
dfb1 8189       STA ($89, X)
dfb3 8181       STA ($81, X)
dfb5 8189       STA ($89, X)
dfb7 00         BRK
dfb8 00         BRK
dfb9 00         BRK
dfba 00         BRK
dfbb 00         BRK
dfbc 00         BRK
dfbd 00         BRK
dfbe 00         BRK
dfbf 00         BRK
dfc0 00         BRK
dfc1 00         BRK
dfc2 51f0       EOR ($f0), Y
dfc4 00         BRK
dfc5 f051       BEQ e018
dfc7 5951f0     EOR $f051, Y
dfca 00         BRK
dfcb f051       BEQ e01e
dfcd 51f0       EOR ($f0), Y
dfcf 00         BRK
dfd0 f051       BEQ e023
dfd2 5151       EOR ($51), Y
dfd4 f000       BEQ dfd6
dfd6 f051       BEQ e029
dfd8 59f000     EOR $00f0, Y
dfdb f051       BEQ e02e
dfdd 5159       EOR ($59), Y
dfdf f000       BEQ dfe1
dfe1 f059       BEQ e03c
dfe3 51f0       EOR ($f0), Y
dfe5 00         BRK
dfe6 f059       BEQ e041
dfe8 5151       EOR ($51), Y
dfea f000       BEQ dfec
dfec f051       BEQ e03f
dfee 00         BRK
dfef 00         BRK
dff0 00         BRK
dff1 00         BRK
dff2 00         BRK
dff3 00         BRK
dff4 00         BRK
dff5 00         BRK
dff6 00         BRK
dff7 00         BRK
dff8 00         BRK
dff9 1111       ORA ($11), Y
dffb 191111     ORA $1111, Y
dffe 1111       ORA ($11), Y
e000 1111       ORA ($11), Y
e002 191111     ORA $1111, Y
e005 1111       ORA ($11), Y
e007 1111       ORA ($11), Y
e009 191111     ORA $1111, Y
e00c 1111       ORA ($11), Y
e00e 1100       ORA ($00), Y
e010 00         BRK
e011 00         BRK
e012 00         BRK
e013 00         BRK
e014 00         BRK
e015 00         BRK
e016 00         BRK
e017 00         BRK
e018 00         BRK
e019 00         BRK
e01a 00         BRK
e01b 00         BRK
e01c 00         BRK
e01d 00         BRK
e01e 00         BRK
e01f 00         BRK
e020 00         BRK
e021 00         BRK
e022 00         BRK
e023 00         BRK
e024 00         BRK
e025 00         BRK
e026 00         BRK
e027 00         BRK
e028 00         BRK
e029 00         BRK
e02a 00         BRK
e02b 00         BRK
e02c 00         BRK
e02d 00         BRK
e02e 00         BRK
e02f 00         BRK
e030 00         BRK
e031 00         BRK
e032 00         BRK
e033 00         BRK
e034 00         BRK
e035 00         BRK
e036 00         BRK
e037 00         BRK
e038 00         BRK
e039 00         BRK
e03a 00         BRK
e03b 00         BRK
e03c 00         BRK
e03d 00         BRK
e03e 00         BRK
e03f 00         BRK
e040 00         BRK
e041 00         BRK
e042 00         BRK
e043 00         BRK
e044 00         BRK
e045 00         BRK
e046 00         BRK
e047 00         BRK
e048 00         BRK
e049 00         BRK
e04a 00         BRK
e04b 00         BRK
e04c 00         BRK
e04d 00         BRK
e04e 00         BRK
e04f 00         BRK
e050 00         BRK
e051 00         BRK
e052 00         BRK
e053 00         BRK
e054 00         BRK
e055 00         BRK
e056 00         BRK
e057 00         BRK
e058 00         BRK
e059 00         BRK
e05a 00         BRK
e05b 00         BRK
e05c 00         BRK
e05d 00         BRK
e05e 00         BRK
e05f db 0f
e060 3016       BMI e078
e062 100f       BPL e073
e064 0928       ORA #$28
e066 db 27
e067 db 0f
e068 0916       ORA #$16
e06a 300f       BMI e07b
e06c 0900       ORA #$00
e06e 00         BRK
e06f 00         BRK
e070 6e0000     ROR $0000
e073 00         BRK
e074 6c0000     JMP (ABS) $0000
e077 6e0000     ROR $0000
e07a 00         BRK
e07b 00         BRK
e07c 00         BRK
e07d 00         BRK
e07e 7c4000     JMP (ABS) $0040, X
e081 00         BRK
e082 00         BRK
e083 00         BRK
e084 00         BRK
e085 00         BRK
e086 00         BRK
e087 00         BRK
e088 00         BRK
e089 00         BRK
e08a 00         BRK
e08b 00         BRK
e08c 00         BRK
e08d 00         BRK
e08e 00         BRK
e08f 00         BRK
e090 00         BRK
e091 00         BRK
e092 00         BRK
e093 00         BRK
e094 00         BRK
e095 00         BRK
e096 6969       ADC #$69
e098 6161       ADC ($61, X)
e09a 6161       ADC ($61, X)
e09c 6169       ADC ($69, X)
e09e 6161       ADC ($61, X)
e0a0 6100       ADC ($00, X)
e0a2 00         BRK
e0a3 00         BRK
e0a4 00         BRK
e0a5 00         BRK
e0a6 00         BRK
e0a7 00         BRK
e0a8 00         BRK
e0a9 00         BRK
e0aa 00         BRK
e0ab 00         BRK
e0ac e4e4       CPX $e4
e0ae e400       CPX $00
e0b0 e4e4       CPX $e4
e0b2 e400       CPX $00
e0b4 e4e4       CPX $e4
e0b6 e4e4       CPX $e4
e0b8 49e4       EOR #$e4
e0ba 00         BRK
e0bb e449       CPX $49
e0bd e400       CPX $00
e0bf e449       CPX $49
e0c1 e4e4       CPX $e4
e0c3 e4e4       CPX $e4
e0c5 00         BRK
e0c6 e4e4       CPX $e4
e0c8 e400       CPX $00
e0ca e4e4       CPX $e4
e0cc e400       CPX $00
e0ce 00         BRK
e0cf 00         BRK
e0d0 00         BRK
e0d1 00         BRK
e0d2 00         BRK
e0d3 00         BRK
e0d4 00         BRK
e0d5 00         BRK
e0d6 00         BRK
e0d7 00         BRK
e0d8 00         BRK
e0d9 00         BRK
e0da e4e4       CPX $e4
e0dc e400       CPX $00
e0de e4e4       CPX $e4
e0e0 e400       CPX $00
e0e2 00         BRK
e0e3 00         BRK
e0e4 00         BRK
e0e5 e459       CPX $59
e0e7 e400       CPX $00
e0e9 e459       CPX $59
e0eb e400       CPX $00
e0ed 00         BRK
e0ee 00         BRK
e0ef 00         BRK
e0f0 e4e4       CPX $e4
e0f2 e400       CPX $00
e0f4 e4e4       CPX $e4
e0f6 e400       CPX $00
e0f8 00         BRK
e0f9 00         BRK
e0fa 00         BRK
e0fb 00         BRK
e0fc 00         BRK
e0fd 00         BRK
e0fe 00         BRK
e0ff 00         BRK
e100 00         BRK
e101 00         BRK
e102 00         BRK
e103 00         BRK
e104 e4e4       CPX $e4
e106 e400       CPX $00
e108 e4e4       CPX $e4
e10a e400       CPX $00
e10c e4e4       CPX $e4
e10e e4e4       CPX $e4
e110 69e4       ADC #$e4
e112 00         BRK
e113 e469       CPX $69
e115 e400       CPX $00
e117 e469       CPX $69
e119 e4e4       CPX $e4
e11b e4e4       CPX $e4
e11d 00         BRK
e11e e4e4       CPX $e4
e120 e400       CPX $00
e122 e4e4       CPX $e4
e124 e400       CPX $00
e126 00         BRK
e127 00         BRK
e128 00         BRK
e129 00         BRK
e12a 00         BRK
e12b 00         BRK
e12c 00         BRK
e12d 00         BRK
e12e 00         BRK
e12f 00         BRK
e130 00         BRK
e131 00         BRK
e132 00         BRK
e133 00         BRK
e134 00         BRK
e135 00         BRK
e136 00         BRK
e137 00         BRK
e138 00         BRK
e139 00         BRK
e13a 00         BRK
e13b 00         BRK
e13c 00         BRK
e13d 00         BRK
e13e 00         BRK
e13f 00         BRK
e140 00         BRK
e141 00         BRK
e142 00         BRK
e143 00         BRK
e144 00         BRK
e145 00         BRK
e146 00         BRK
e147 00         BRK
e148 00         BRK
e149 00         BRK
e14a 00         BRK
e14b 00         BRK
e14c 00         BRK
e14d 00         BRK
e14e 00         BRK
e14f 00         BRK
e150 00         BRK
e151 00         BRK
e152 00         BRK
e153 00         BRK
e154 00         BRK
e155 00         BRK
e156 00         BRK
e157 00         BRK
e158 00         BRK
e159 00         BRK
e15a 00         BRK
e15b 00         BRK
e15c 00         BRK
e15d 00         BRK
e15e 00         BRK
e15f db 0f
e160 3016       BMI e178
e162 100f       BPL e173
e164 0110       ORA ($10, X)
e166 160f       ASL $0f, X
e168 0110       ORA ($10, X)
e16a 290f       AND #$0f
e16c 0110       ORA ($10, X)
e16e 1100       ORA ($00), Y
e170 00         BRK
e171 00         BRK
e172 00         BRK
e173 6e6e6e     ROR $6e6e
e176 00         BRK
e177 00         BRK
e178 00         BRK
e179 00         BRK
e17a 00         BRK
e17b 00         BRK
e17c 00         BRK
e17d 7c0053     JMP (ABS) $5300, X
e180 00         BRK
e181 00         BRK
e182 00         BRK
e183 00         BRK
e184 00         BRK
e185 00         BRK
e186 00         BRK
e187 00         BRK
e188 00         BRK
e189 00         BRK
e18a 00         BRK
e18b 00         BRK
e18c 00         BRK
e18d 00         BRK
e18e 00         BRK
e18f 00         BRK
e190 00         BRK
e191 00         BRK
e192 00         BRK
e193 00         BRK
e194 00         BRK
e195 00         BRK
e196 00         BRK
e197 00         BRK
e198 00         BRK
e199 00         BRK
e19a 00         BRK
e19b 00         BRK
e19c 00         BRK
e19d 00         BRK
e19e 00         BRK
e19f 00         BRK
e1a0 00         BRK
e1a1 00         BRK
e1a2 00         BRK
e1a3 00         BRK
e1a4 00         BRK
e1a5 00         BRK
e1a6 00         BRK
e1a7 00         BRK
e1a8 00         BRK
e1a9 00         BRK
e1aa 00         BRK
e1ab 00         BRK
e1ac 00         BRK
e1ad 00         BRK
e1ae 00         BRK
e1af 00         BRK
e1b0 00         BRK
e1b1 00         BRK
e1b2 00         BRK
e1b3 00         BRK
e1b4 00         BRK
e1b5 00         BRK
e1b6 00         BRK
e1b7 00         BRK
e1b8 00         BRK
e1b9 00         BRK
e1ba 00         BRK
e1bb 191911     ORA $1119, Y
e1be 00         BRK
e1bf 00         BRK
e1c0 00         BRK
e1c1 00         BRK
e1c2 00         BRK
e1c3 00         BRK
e1c4 00         BRK
e1c5 00         BRK
e1c6 1119       ORA ($19), Y
e1c8 190000     ORA $0000, Y
e1cb 00         BRK
e1cc 00         BRK
e1cd 00         BRK
e1ce 00         BRK
e1cf 00         BRK
e1d0 00         BRK
e1d1 191119     ORA $1911, Y
e1d4 00         BRK
e1d5 00         BRK
e1d6 00         BRK
e1d7 00         BRK
e1d8 00         BRK
e1d9 00         BRK
e1da 00         BRK
e1db 196111     ORA $1161, Y
e1de 6119       ADC ($19, X)
e1e0 00         BRK
e1e1 00         BRK
e1e2 00         BRK
e1e3 00         BRK
e1e4 00         BRK
e1e5 00         BRK
e1e6 6161       ADC ($61, X)
e1e8 6161       ADC ($61, X)
e1ea 6100       ADC ($00, X)
e1ec 00         BRK
e1ed 00         BRK
e1ee 00         BRK
e1ef 00         BRK
e1f0 6161       ADC ($61, X)
e1f2 6161       ADC ($61, X)
e1f4 6161       ADC ($61, X)
e1f6 6100       ADC ($00, X)
e1f8 00         BRK
e1f9 00         BRK
e1fa 00         BRK
e1fb 6161       ADC ($61, X)
e1fd 6161       ADC ($61, X)
e1ff 6161       ADC ($61, X)
e201 6100       ADC ($00, X)
e203 00         BRK
e204 00         BRK
e205 6161       ADC ($61, X)
e207 6161       ADC ($61, X)
e209 6161       ADC ($61, X)
e20b 6161       ADC ($61, X)
e20d 6100       ADC ($00, X)
e20f 6161       ADC ($61, X)
e211 6161       ADC ($61, X)
e213 6161       ADC ($61, X)
e215 6161       ADC ($61, X)
e217 6161       ADC ($61, X)
e219 6100       ADC ($00, X)
e21b 00         BRK
e21c 00         BRK
e21d 00         BRK
e21e 00         BRK
e21f 00         BRK
e220 00         BRK
e221 00         BRK
e222 00         BRK
e223 00         BRK
e224 00         BRK
e225 00         BRK
e226 00         BRK
e227 00         BRK
e228 00         BRK
e229 00         BRK
e22a 00         BRK
e22b 00         BRK
e22c 00         BRK
e22d 00         BRK
e22e 00         BRK
e22f 00         BRK
e230 00         BRK
e231 00         BRK
e232 00         BRK
e233 00         BRK
e234 00         BRK
e235 00         BRK
e236 00         BRK
e237 00         BRK
e238 00         BRK
e239 00         BRK
e23a 00         BRK
e23b 00         BRK
e23c 00         BRK
e23d 00         BRK
e23e 00         BRK
e23f 00         BRK
e240 00         BRK
e241 00         BRK
e242 00         BRK
e243 00         BRK
e244 00         BRK
e245 00         BRK
e246 00         BRK
e247 00         BRK
e248 00         BRK
e249 00         BRK
e24a 00         BRK
e24b 00         BRK
e24c 00         BRK
e24d 00         BRK
e24e 00         BRK
e24f 00         BRK
e250 00         BRK
e251 00         BRK
e252 00         BRK
e253 00         BRK
e254 00         BRK
e255 00         BRK
e256 00         BRK
e257 00         BRK
e258 00         BRK
e259 00         BRK
e25a 00         BRK
e25b 00         BRK
e25c 00         BRK
e25d 00         BRK
e25e 00         BRK
e25f db 0f
e260 3016       BMI e278
e262 100f       BPL e273
e264 1611       ASL $11, X
e266 300f       BMI e277
e268 1600       ASL $00, X
e26a 00         BRK
e26b db 0f
e26c 1600       ASL $00, X
e26e 00         BRK
e26f 00         BRK
e270 6e0000     ROR $0000
e273 00         BRK
e274 00         BRK
e275 6c0000     JMP (ABS) $0000
e278 00         BRK
e279 00         BRK
e27a 00         BRK
e27b 00         BRK
e27c 00         BRK
e27d 00         BRK
e27e 00         BRK
e27f 3500       AND $00, X
e281 00         BRK
e282 00         BRK
e283 00         BRK
e284 00         BRK
e285 00         BRK
e286 00         BRK
e287 00         BRK
e288 00         BRK
e289 00         BRK
e28a 00         BRK
e28b 00         BRK
e28c 00         BRK
e28d 00         BRK
e28e 00         BRK
e28f 00         BRK
e290 00         BRK
e291 00         BRK
e292 00         BRK
e293 00         BRK
e294 00         BRK
e295 00         BRK
e296 00         BRK
e297 00         BRK
e298 00         BRK
e299 00         BRK
e29a 00         BRK
e29b 00         BRK
e29c 00         BRK
e29d 00         BRK
e29e 00         BRK
e29f 00         BRK
e2a0 00         BRK
e2a1 595151     EOR $5151, Y
e2a4 5151       EOR ($51), Y
e2a6 595151     EOR $5151, Y
e2a9 5151       EOR ($51), Y
e2ab 5141       EOR ($41), Y
e2ad 4141       EOR ($41, X)
e2af 4141       EOR ($41, X)
e2b1 4141       EOR ($41, X)
e2b3 4149       EOR ($49, X)
e2b5 4141       EOR ($41, X)
e2b7 6169       ADC ($69, X)
e2b9 6169       ADC ($69, X)
e2bb 6161       ADC ($61, X)
e2bd 6161       ADC ($61, X)
e2bf 6161       ADC ($61, X)
e2c1 69f0       ADC #$f0
e2c3 f0f0       BEQ e2b5
e2c5 f051       BEQ e318
e2c7 5151       EOR ($51), Y
e2c9 f0f0       BEQ e2bb
e2cb f0f0       BEQ e2bd
e2cd f041       BEQ e310
e2cf 49f0       EOR #$f0
e2d1 e5e5       SBC $e5
e2d3 e5f0       SBC $f0
e2d5 4149       EOR ($49, X)
e2d7 f0f0       BEQ e2c9
e2d9 5151       EOR ($51), Y
e2db f000       BEQ e2dd
e2dd 00         BRK
e2de 00         BRK
e2df f061       BEQ e342
e2e1 61f0       ADC ($f0, X)
e2e3 f000       BEQ e2e5
e2e5 00         BRK
e2e6 00         BRK
e2e7 00         BRK
e2e8 00         BRK
e2e9 00         BRK
e2ea 00         BRK
e2eb 00         BRK
e2ec 00         BRK
e2ed f0f0       BEQ e2df
e2ef 00         BRK
e2f0 00         BRK
e2f1 00         BRK
e2f2 00         BRK
e2f3 00         BRK
e2f4 00         BRK
e2f5 00         BRK
e2f6 00         BRK
e2f7 00         BRK
e2f8 f0f0       BEQ e2ea
e2fa 00         BRK
e2fb 00         BRK
e2fc 00         BRK
e2fd 00         BRK
e2fe 00         BRK
e2ff 00         BRK
e300 00         BRK
e301 00         BRK
e302 00         BRK
e303 f0f0       BEQ e2f5
e305 00         BRK
e306 00         BRK
e307 f041       BEQ e34a
e309 4141       EOR ($41, X)
e30b f000       BEQ e30d
e30d 00         BRK
e30e f0f0       BEQ e300
e310 e5e5       SBC $e5
e312 f0f0       BEQ e304
e314 f0f0       BEQ e306
e316 f0e5       BEQ e2fd
e318 e5f0       SBC $f0
e31a 00         BRK
e31b 00         BRK
e31c 00         BRK
e31d 00         BRK
e31e 00         BRK
e31f 00         BRK
e320 00         BRK
e321 00         BRK
e322 00         BRK
e323 00         BRK
e324 00         BRK
e325 00         BRK
e326 00         BRK
e327 00         BRK
e328 00         BRK
e329 00         BRK
e32a 00         BRK
e32b 00         BRK
e32c 00         BRK
e32d 00         BRK
e32e 00         BRK
e32f 00         BRK
e330 00         BRK
e331 00         BRK
e332 00         BRK
e333 00         BRK
e334 00         BRK
e335 00         BRK
e336 00         BRK
e337 00         BRK
e338 00         BRK
e339 00         BRK
e33a 00         BRK
e33b 00         BRK
e33c 00         BRK
e33d 00         BRK
e33e 00         BRK
e33f 00         BRK
e340 00         BRK
e341 00         BRK
e342 00         BRK
e343 00         BRK
e344 00         BRK
e345 00         BRK
e346 00         BRK
e347 00         BRK
e348 00         BRK
e349 00         BRK
e34a 00         BRK
e34b 00         BRK
e34c 00         BRK
e34d 00         BRK
e34e 00         BRK
e34f 00         BRK
e350 00         BRK
e351 00         BRK
e352 00         BRK
e353 00         BRK
e354 00         BRK
e355 00         BRK
e356 00         BRK
e357 00         BRK
e358 00         BRK
e359 00         BRK
e35a 00         BRK
e35b 00         BRK
e35c 00         BRK
e35d 00         BRK
e35e 00         BRK
e35f db 0f
e360 3016       BMI e378
e362 100f       BPL e373
e364 0128       ORA ($28, X)
e366 290f       AND #$0f
e368 0110       ORA ($10, X)
e36a 160f       ASL $0f, X
e36c 0111       ORA ($11, X)
e36e 2900       AND #$00
e370 00         BRK
e371 00         BRK
e372 00         BRK
e373 6e6e6c     ROR $6c6e
e376 00         BRK
e377 00         BRK
e378 00         BRK
e379 00         BRK
e37a 00         BRK
e37b 00         BRK
e37c 00         BRK
e37d 7c7c36     JMP (ABS) $367c, X
e380 00         BRK
e381 00         BRK
e382 00         BRK
e383 00         BRK
e384 00         BRK
e385 00         BRK
e386 00         BRK
e387 00         BRK
e388 00         BRK
e389 00         BRK
e38a 00         BRK
e38b 00         BRK
e38c 00         BRK
e38d 00         BRK
e38e 00         BRK
e38f 00         BRK
e390 00         BRK
e391 00         BRK
e392 00         BRK
e393 00         BRK
e394 00         BRK
e395 00         BRK
e396 00         BRK
e397 00         BRK
e398 00         BRK
e399 00         BRK
e39a 00         BRK
e39b 00         BRK
e39c 00         BRK
e39d 00         BRK
e39e 00         BRK
e39f 00         BRK
e3a0 00         BRK
e3a1 00         BRK
e3a2 00         BRK
e3a3 00         BRK
e3a4 00         BRK
e3a5 00         BRK
e3a6 00         BRK
e3a7 00         BRK
e3a8 00         BRK
e3a9 00         BRK
e3aa 00         BRK
e3ab 00         BRK
e3ac 00         BRK
e3ad 00         BRK
e3ae f0e5       BEQ e395
e3b0 e5f0       SBC $f0
e3b2 00         BRK
e3b3 00         BRK
e3b4 00         BRK
e3b5 00         BRK
e3b6 00         BRK
e3b7 00         BRK
e3b8 f000       BEQ e3ba
e3ba 00         BRK
e3bb 00         BRK
e3bc 00         BRK
e3bd f000       BEQ e3bf
e3bf 00         BRK
e3c0 00         BRK
e3c1 00         BRK
e3c2 f000       BEQ e3c4
e3c4 00         BRK
e3c5 3139       AND ($39), Y
e3c7 00         BRK
e3c8 00         BRK
e3c9 f000       BEQ e3cb
e3cb 00         BRK
e3cc 00         BRK
e3cd f000       BEQ e3cf
e3cf 6969       ADC #$69
e3d1 6969       ADC #$69
e3d3 00         BRK
e3d4 f000       BEQ e3d6
e3d6 00         BRK
e3d7 00         BRK
e3d8 f000       BEQ e3da
e3da 00         BRK
e3db 797900     ADC $0079, Y
e3de 00         BRK
e3df f000       BEQ e3e1
e3e1 00         BRK
e3e2 00         BRK
e3e3 00         BRK
e3e4 f000       BEQ e3e6
e3e6 00         BRK
e3e7 00         BRK
e3e8 00         BRK
e3e9 f000       BEQ e3eb
e3eb 00         BRK
e3ec 00         BRK
e3ed 00         BRK
e3ee 00         BRK
e3ef 00         BRK
e3f0 f0f0       BEQ e3e2
e3f2 f0f0       BEQ e3e4
e3f4 00         BRK
e3f5 00         BRK
e3f6 00         BRK
e3f7 00         BRK
e3f8 00         BRK
e3f9 00         BRK
e3fa 00         BRK
e3fb 00         BRK
e3fc 00         BRK
e3fd 00         BRK
e3fe 00         BRK
e3ff 00         BRK
e400 00         BRK
e401 00         BRK
e402 00         BRK
e403 00         BRK
e404 00         BRK
e405 00         BRK
e406 00         BRK
e407 00         BRK
e408 00         BRK
e409 00         BRK
e40a 00         BRK
e40b 00         BRK
e40c 00         BRK
e40d 00         BRK
e40e 00         BRK
e40f 00         BRK
e410 00         BRK
e411 00         BRK
e412 00         BRK
e413 00         BRK
e414 00         BRK
e415 00         BRK
e416 00         BRK
e417 00         BRK
e418 00         BRK
e419 00         BRK
e41a 00         BRK
e41b 00         BRK
e41c 00         BRK
e41d 00         BRK
e41e 00         BRK
e41f 00         BRK
e420 00         BRK
e421 00         BRK
e422 00         BRK
e423 00         BRK
e424 00         BRK
e425 00         BRK
e426 00         BRK
e427 00         BRK
e428 00         BRK
e429 00         BRK
e42a 00         BRK
e42b 00         BRK
e42c 00         BRK
e42d 00         BRK
e42e 00         BRK
e42f 00         BRK
e430 00         BRK
e431 00         BRK
e432 00         BRK
e433 00         BRK
e434 00         BRK
e435 00         BRK
e436 00         BRK
e437 00         BRK
e438 00         BRK
e439 00         BRK
e43a 00         BRK
e43b 00         BRK
e43c 00         BRK
e43d 00         BRK
e43e 00         BRK
e43f 00         BRK
e440 00         BRK
e441 00         BRK
e442 00         BRK
e443 00         BRK
e444 00         BRK
e445 00         BRK
e446 00         BRK
e447 00         BRK
e448 00         BRK
e449 00         BRK
e44a 00         BRK
e44b 00         BRK
e44c 00         BRK
e44d 00         BRK
e44e 00         BRK
e44f 00         BRK
e450 00         BRK
e451 00         BRK
e452 00         BRK
e453 00         BRK
e454 00         BRK
e455 00         BRK
e456 00         BRK
e457 00         BRK
e458 00         BRK
e459 00         BRK
e45a 00         BRK
e45b 00         BRK
e45c 00         BRK
e45d 00         BRK
e45e 00         BRK
e45f db 0f
e460 3016       BMI e478
e462 100f       BPL e473
e464 0928       ORA #$28
e466 100f       BPL e477
e468 0921       ORA #$21
e46a 110f       ORA ($0f), Y
e46c 0925       ORA #$25
e46e 00         BRK
e46f 00         BRK
e470 00         BRK
e471 00         BRK
e472 6c0000     JMP (ABS) $0000
e475 6e6c00     ROR $006c
e478 00         BRK
e479 00         BRK
e47a 00         BRK
e47b 00         BRK
e47c 00         BRK
e47d 7e7c0a     ROR $0a7c, X
e480 00         BRK
e481 00         BRK
e482 00         BRK
e483 00         BRK
e484 00         BRK
e485 00         BRK
e486 00         BRK
e487 00         BRK
e488 00         BRK
e489 00         BRK
e48a 00         BRK
e48b 00         BRK
e48c 00         BRK
e48d 00         BRK
e48e 00         BRK
e48f 00         BRK
e490 00         BRK
e491 00         BRK
e492 00         BRK
e493 00         BRK
e494 00         BRK
e495 00         BRK
e496 00         BRK
e497 00         BRK
e498 00         BRK
e499 00         BRK
e49a 00         BRK
e49b 00         BRK
e49c 00         BRK
e49d 00         BRK
e49e 00         BRK
e49f 00         BRK
e4a0 00         BRK
e4a1 00         BRK
e4a2 00         BRK
e4a3 00         BRK
e4a4 00         BRK
e4a5 00         BRK
e4a6 00         BRK
e4a7 00         BRK
e4a8 00         BRK
e4a9 00         BRK
e4aa 00         BRK
e4ab 00         BRK
e4ac 00         BRK
e4ad 00         BRK
e4ae 00         BRK
e4af 00         BRK
e4b0 00         BRK
e4b1 00         BRK
e4b2 00         BRK
e4b3 00         BRK
e4b4 00         BRK
e4b5 00         BRK
e4b6 00         BRK
e4b7 00         BRK
e4b8 00         BRK
e4b9 00         BRK
e4ba 00         BRK
e4bb 00         BRK
e4bc 00         BRK
e4bd 00         BRK
e4be 00         BRK
e4bf 00         BRK
e4c0 00         BRK
e4c1 00         BRK
e4c2 00         BRK
e4c3 00         BRK
e4c4 00         BRK
e4c5 00         BRK
e4c6 00         BRK
e4c7 00         BRK
e4c8 00         BRK
e4c9 00         BRK
e4ca 00         BRK
e4cb 00         BRK
e4cc 00         BRK
e4cd e5e5       SBC $e5
e4cf e5e5       SBC $e5
e4d1 e5e5       SBC $e5
e4d3 e5e5       SBC $e5
e4d5 e5e5       SBC $e5
e4d7 e581       SBC $81
e4d9 8981       STA #$81
e4db 8189       STA ($89, X)
e4dd 8181       STA ($81, X)
e4df 8181       STA ($81, X)
e4e1 8189       STA ($89, X)
e4e3 e5e5       SBC $e5
e4e5 e5e5       SBC $e5
e4e7 e5e5       SBC $e5
e4e9 e5e5       SBC $e5
e4eb e5e5       SBC $e5
e4ed e500       SBC $00
e4ef 00         BRK
e4f0 00         BRK
e4f1 00         BRK
e4f2 00         BRK
e4f3 00         BRK
e4f4 00         BRK
e4f5 00         BRK
e4f6 00         BRK
e4f7 00         BRK
e4f8 00         BRK
e4f9 e5e5       SBC $e5
e4fb e5e5       SBC $e5
e4fd e5e5       SBC $e5
e4ff e5e5       SBC $e5
e501 e5e5       SBC $e5
e503 e559       SBC $59
e505 595959     EOR $5959, Y
e508 595159     EOR $5951, Y
e50b 595959     EOR $5959, Y
e50e 59e5e5     EOR $e5e5, Y
e511 e5e5       SBC $e5
e513 e5e5       SBC $e5
e515 e5e5       SBC $e5
e517 e5e5       SBC $e5
e519 e500       SBC $00
e51b 00         BRK
e51c 00         BRK
e51d 00         BRK
e51e 00         BRK
e51f 00         BRK
e520 00         BRK
e521 00         BRK
e522 00         BRK
e523 00         BRK
e524 00         BRK
e525 00         BRK
e526 00         BRK
e527 00         BRK
e528 00         BRK
e529 00         BRK
e52a 00         BRK
e52b 00         BRK
e52c 00         BRK
e52d 00         BRK
e52e 00         BRK
e52f 00         BRK
e530 00         BRK
e531 00         BRK
e532 00         BRK
e533 00         BRK
e534 00         BRK
e535 00         BRK
e536 00         BRK
e537 00         BRK
e538 00         BRK
e539 00         BRK
e53a 00         BRK
e53b 00         BRK
e53c 00         BRK
e53d 00         BRK
e53e 00         BRK
e53f 00         BRK
e540 00         BRK
e541 00         BRK
e542 00         BRK
e543 00         BRK
e544 00         BRK
e545 00         BRK
e546 00         BRK
e547 00         BRK
e548 00         BRK
e549 00         BRK
e54a 00         BRK
e54b 00         BRK
e54c 00         BRK
e54d 00         BRK
e54e 00         BRK
e54f 00         BRK
e550 00         BRK
e551 00         BRK
e552 00         BRK
e553 00         BRK
e554 00         BRK
e555 00         BRK
e556 00         BRK
e557 00         BRK
e558 00         BRK
e559 00         BRK
e55a 00         BRK
e55b 00         BRK
e55c 00         BRK
e55d 00         BRK
e55e 00         BRK
e55f db 0f
e560 3016       BMI e578
e562 100f       BPL e573
e564 0110       ORA ($10, X)
e566 db 27
e567 db 0f
e568 0110       ORA ($10, X)
e56a 160f       ASL $0f, X
e56c 0100       ORA ($00, X)
e56e 00         BRK
e56f 00         BRK
e570 00         BRK
e571 00         BRK
e572 00         BRK
e573 00         BRK
e574 6e0000     ROR $0000
e577 6e0000     ROR $0000
e57a 00         BRK
e57b 00         BRK
e57c 00         BRK
e57d 7c0042     JMP (ABS) $4200, X
e580 00         BRK
e581 00         BRK
e582 00         BRK
e583 00         BRK
e584 00         BRK
e585 00         BRK
e586 00         BRK
e587 00         BRK
e588 00         BRK
e589 00         BRK
e58a 00         BRK
e58b 00         BRK
e58c 00         BRK
e58d 00         BRK
e58e 00         BRK
e58f 00         BRK
e590 00         BRK
e591 00         BRK
e592 00         BRK
e593 00         BRK
e594 00         BRK
e595 00         BRK
e596 00         BRK
e597 00         BRK
e598 00         BRK
e599 00         BRK
e59a 00         BRK
e59b 00         BRK
e59c 00         BRK
e59d 00         BRK
e59e 00         BRK
e59f 00         BRK
e5a0 00         BRK
e5a1 6161       ADC ($61, X)
e5a3 6161       ADC ($61, X)
e5a5 6161       ADC ($61, X)
e5a7 6161       ADC ($61, X)
e5a9 6961       ADC #$61
e5ab 6961       ADC #$61
e5ad f0f0       BEQ e59f
e5af f079       BEQ e62a
e5b1 f079       BEQ e62c
e5b3 f0f0       BEQ e5a5
e5b5 f069       BEQ e620
e5b7 69f0       ADC #$f0
e5b9 00         BRK
e5ba 00         BRK
e5bb 00         BRK
e5bc 00         BRK
e5bd 00         BRK
e5be 00         BRK
e5bf 00         BRK
e5c0 f061       BEQ e623
e5c2 61f0       ADC ($f0, X)
e5c4 7100       ADC ($00), Y
e5c6 00         BRK
e5c7 00         BRK
e5c8 00         BRK
e5c9 00         BRK
e5ca 79f061     ADC $61f0, Y
e5cd 69f0       ADC #$f0
e5cf 797100     ADC $0071, Y
e5d2 00         BRK
e5d3 00         BRK
e5d4 7171       ADC ($71), Y
e5d6 f061       BEQ e639
e5d8 00         BRK
e5d9 61f0       ADC ($f0, X)
e5db 7171       ADC ($71), Y
e5dd 00         BRK
e5de 7171       ADC ($71), Y
e5e0 f061       BEQ e643
e5e2 00         BRK
e5e3 00         BRK
e5e4 00         BRK
e5e5 61f0       ADC ($f0, X)
e5e7 797171     ADC $7171, Y
e5ea f061       BEQ e64d
e5ec 00         BRK
e5ed 00         BRK
e5ee 00         BRK
e5ef 00         BRK
e5f0 00         BRK
e5f1 61f0       ADC ($f0, X)
e5f3 71f0       ADC ($f0), Y
e5f5 6100       ADC ($00, X)
e5f7 00         BRK
e5f8 00         BRK
e5f9 00         BRK
e5fa 00         BRK
e5fb 00         BRK
e5fc 00         BRK
e5fd 6171       ADC ($71, X)
e5ff 6100       ADC ($00, X)
e601 00         BRK
e602 00         BRK
e603 00         BRK
e604 00         BRK
e605 00         BRK
e606 00         BRK
e607 00         BRK
e608 00         BRK
e609 6100       ADC ($00, X)
e60b 00         BRK
e60c 00         BRK
e60d 00         BRK
e60e 00         BRK
e60f 00         BRK
e610 00         BRK
e611 00         BRK
e612 00         BRK
e613 00         BRK
e614 00         BRK
e615 00         BRK
e616 00         BRK
e617 00         BRK
e618 00         BRK
e619 00         BRK
e61a 00         BRK
e61b 00         BRK
e61c 00         BRK
e61d 00         BRK
e61e 00         BRK
e61f 00         BRK
e620 00         BRK
e621 00         BRK
e622 00         BRK
e623 00         BRK
e624 00         BRK
e625 00         BRK
e626 00         BRK
e627 00         BRK
e628 00         BRK
e629 00         BRK
e62a 00         BRK
e62b 00         BRK
e62c 00         BRK
e62d 00         BRK
e62e 00         BRK
e62f 00         BRK
e630 00         BRK
e631 00         BRK
e632 00         BRK
e633 00         BRK
e634 00         BRK
e635 00         BRK
e636 00         BRK
e637 00         BRK
e638 00         BRK
e639 00         BRK
e63a 00         BRK
e63b 00         BRK
e63c 00         BRK
e63d 00         BRK
e63e 00         BRK
e63f 00         BRK
e640 00         BRK
e641 00         BRK
e642 00         BRK
e643 00         BRK
e644 00         BRK
e645 00         BRK
e646 00         BRK
e647 00         BRK
e648 00         BRK
e649 00         BRK
e64a 00         BRK
e64b 00         BRK
e64c 00         BRK
e64d 00         BRK
e64e 00         BRK
e64f 00         BRK
e650 00         BRK
e651 00         BRK
e652 00         BRK
e653 00         BRK
e654 00         BRK
e655 00         BRK
e656 00         BRK
e657 00         BRK
e658 00         BRK
e659 00         BRK
e65a 00         BRK
e65b 00         BRK
e65c 00         BRK
e65d 00         BRK
e65e 00         BRK
e65f db 0f
e660 3016       BMI e678
e662 100f       BPL e673
e664 1628       ASL $28, X
e666 110f       ORA ($0f), Y
e668 1628       ASL $28, X
e66a 250f       AND $0f
e66c 1600       ASL $00, X
e66e 00         BRK
e66f 00         BRK
e670 00         BRK
e671 00         BRK
e672 00         BRK
e673 00         BRK
e674 00         BRK
e675 6e6e00     ROR $006e
e678 00         BRK
e679 00         BRK
e67a 00         BRK
e67b 00         BRK
e67c 00         BRK
e67d 00         BRK
e67e 7c2d00     JMP (ABS) $002d, X
e681 00         BRK
e682 00         BRK
e683 00         BRK
e684 00         BRK
e685 00         BRK
e686 00         BRK
e687 00         BRK
e688 00         BRK
e689 00         BRK
e68a 00         BRK
e68b 00         BRK
e68c 00         BRK
e68d 00         BRK
e68e 00         BRK
e68f 00         BRK
e690 00         BRK
e691 00         BRK
e692 00         BRK
e693 00         BRK
e694 00         BRK
e695 00         BRK
e696 00         BRK
e697 00         BRK
e698 00         BRK
e699 00         BRK
e69a 00         BRK
e69b 00         BRK
e69c 00         BRK
e69d 00         BRK
e69e 00         BRK
e69f 00         BRK
e6a0 00         BRK
e6a1 6161       ADC ($61, X)
e6a3 6161       ADC ($61, X)
e6a5 f000       BEQ e6a7
e6a7 f069       BEQ e712
e6a9 6161       ADC ($61, X)
e6ab 6149       ADC ($49, X)
e6ad 4141       EOR ($41, X)
e6af 49f0       EOR #$f0
e6b1 00         BRK
e6b2 f041       BEQ e6f5
e6b4 4141       EOR ($41, X)
e6b6 49f0       EOR #$f0
e6b8 f0f0       BEQ e6aa
e6ba f0f0       BEQ e6ac
e6bc 00         BRK
e6bd f0f0       BEQ e6af
e6bf f0f0       BEQ e6b1
e6c1 f071       BEQ e734
e6c3 7171       ADC ($71), Y
e6c5 79f000     ADC $00f0, Y
e6c8 f071       BEQ e73b
e6ca 7171       ADC ($71), Y
e6cc 7121       ADC ($21), Y
e6ce 2121       AND ($21, X)
e6d0 21f0       AND ($f0, X)
e6d2 00         BRK
e6d3 f029       BEQ e6fe
e6d5 2121       AND ($21, X)
e6d7 2169       AND ($69, X)
e6d9 6161       ADC ($61, X)
e6db 61f0       ADC ($f0, X)
e6dd 00         BRK
e6de f061       BEQ e741
e6e0 6161       ADC ($61, X)
e6e2 69e5       ADC #$e5
e6e4 e5e5       SBC $e5
e6e6 e5f0       SBC $f0
e6e8 00         BRK
e6e9 f0e5       BEQ e6d0
e6eb e5e5       SBC $e5
e6ed e521       SBC $21
e6ef 2129       AND ($29, X)
e6f1 21f0       AND ($f0, X)
e6f3 00         BRK
e6f4 f021       BEQ e717
e6f6 2121       AND ($21, X)
e6f8 2971       AND #$71
e6fa 7171       ADC ($71), Y
e6fc 71f0       ADC ($f0), Y
e6fe 00         BRK
e6ff f071       BEQ e772
e701 7171       ADC ($71), Y
e703 7141       ADC ($41), Y
e705 4141       EOR ($41, X)
e707 41f0       EOR ($f0, X)
e709 00         BRK
e70a f041       BEQ e74d
e70c 4141       EOR ($41, X)
e70e 4100       EOR ($00, X)
e710 00         BRK
e711 00         BRK
e712 00         BRK
e713 00         BRK
e714 00         BRK
e715 00         BRK
e716 00         BRK
e717 00         BRK
e718 00         BRK
e719 00         BRK
e71a 00         BRK
e71b 00         BRK
e71c 00         BRK
e71d 00         BRK
e71e 00         BRK
e71f 00         BRK
e720 00         BRK
e721 00         BRK
e722 00         BRK
e723 00         BRK
e724 00         BRK
e725 00         BRK
e726 00         BRK
e727 00         BRK
e728 00         BRK
e729 00         BRK
e72a 00         BRK
e72b 00         BRK
e72c 00         BRK
e72d 00         BRK
e72e 00         BRK
e72f 00         BRK
e730 00         BRK
e731 00         BRK
e732 00         BRK
e733 00         BRK
e734 00         BRK
e735 00         BRK
e736 00         BRK
e737 00         BRK
e738 00         BRK
e739 00         BRK
e73a 00         BRK
e73b 00         BRK
e73c 00         BRK
e73d 00         BRK
e73e 00         BRK
e73f 00         BRK
e740 00         BRK
e741 00         BRK
e742 00         BRK
e743 00         BRK
e744 00         BRK
e745 00         BRK
e746 00         BRK
e747 00         BRK
e748 00         BRK
e749 00         BRK
e74a 00         BRK
e74b 00         BRK
e74c 00         BRK
e74d 00         BRK
e74e 00         BRK
e74f 00         BRK
e750 00         BRK
e751 00         BRK
e752 00         BRK
e753 00         BRK
e754 00         BRK
e755 00         BRK
e756 00         BRK
e757 00         BRK
e758 00         BRK
e759 00         BRK
e75a 00         BRK
e75b 00         BRK
e75c 00         BRK
e75d 00         BRK
e75e 00         BRK
e75f db 0f
e760 3016       BMI e778
e762 100f       BPL e773
e764 0128       ORA ($28, X)
e766 290f       AND #$0f
e768 0110       ORA ($10, X)
e76a 110f       ORA ($0f), Y
e76c 0125       ORA ($25, X)
e76e 2600       ROL $00
e770 00         BRK
e771 6e006e     ROR $6e00
e774 00         BRK
e775 6e6c00     ROR $006c
e778 00         BRK
e779 00         BRK
e77a 00         BRK
e77b 00         BRK
e77c 00         BRK
e77d 7c7c48     JMP (ABS) $487c, X
e780 00         BRK
e781 00         BRK
e782 00         BRK
e783 00         BRK
e784 00         BRK
e785 00         BRK
e786 00         BRK
e787 00         BRK
e788 00         BRK
e789 00         BRK
e78a 00         BRK
e78b 00         BRK
e78c 00         BRK
e78d 00         BRK
e78e 00         BRK
e78f 00         BRK
e790 00         BRK
e791 00         BRK
e792 00         BRK
e793 00         BRK
e794 00         BRK
e795 00         BRK
e796 00         BRK
e797 00         BRK
e798 00         BRK
e799 00         BRK
e79a 00         BRK
e79b 00         BRK
e79c 00         BRK
e79d 00         BRK
e79e 00         BRK
e79f 00         BRK
e7a0 00         BRK
e7a1 00         BRK
e7a2 00         BRK
e7a3 00         BRK
e7a4 00         BRK
e7a5 00         BRK
e7a6 00         BRK
e7a7 00         BRK
e7a8 00         BRK
e7a9 00         BRK
e7aa 00         BRK
e7ab 00         BRK
e7ac 2179       AND ($79, X)
e7ae 00         BRK
e7af 00         BRK
e7b0 00         BRK
e7b1 00         BRK
e7b2 00         BRK
e7b3 00         BRK
e7b4 00         BRK
e7b5 00         BRK
e7b6 00         BRK
e7b7 2171       AND ($71, X)
e7b9 3149       AND ($49), Y
e7bb 00         BRK
e7bc 00         BRK
e7bd 00         BRK
e7be 00         BRK
e7bf 00         BRK
e7c0 00         BRK
e7c1 00         BRK
e7c2 2171       AND ($71, X)
e7c4 394121     AND $2141, Y
e7c7 790000     ADC $0000, Y
e7ca 00         BRK
e7cb 00         BRK
e7cc 00         BRK
e7cd 2971       AND #$71
e7cf 3141       AND ($41), Y
e7d1 2171       AND ($71, X)
e7d3 3149       AND ($49), Y
e7d5 00         BRK
e7d6 00         BRK
e7d7 00         BRK
e7d8 e579       SBC $79
e7da 394121     AND $2141, Y
e7dd 793141     ADC $4131, Y
e7e0 2171       AND ($71, X)
e7e2 00         BRK
e7e3 00         BRK
e7e4 f0e5       BEQ e7cb
e7e6 4929       EOR #$29
e7e8 7131       ADC ($31), Y
e7ea 4121       EOR ($21, X)
e7ec 793900     ADC $0039, Y
e7ef 00         BRK
e7f0 00         BRK
e7f1 f0e5       BEQ e7d8
e7f3 793941     ADC $4139, Y
e7f6 2171       AND ($71, X)
e7f8 3100       AND ($00), Y
e7fa 00         BRK
e7fb 00         BRK
e7fc 00         BRK
e7fd 00         BRK
e7fe f0e5       BEQ e7e5
e800 4929       EOR #$29
e802 7131       ADC ($31), Y
e804 00         BRK
e805 00         BRK
e806 00         BRK
e807 00         BRK
e808 00         BRK
e809 00         BRK
e80a 00         BRK
e80b f0e5       BEQ e7f2
e80d 793900     ADC $0039, Y
e810 00         BRK
e811 00         BRK
e812 00         BRK
e813 00         BRK
e814 00         BRK
e815 00         BRK
e816 00         BRK
e817 00         BRK
e818 f0e5       BEQ e7ff
e81a 00         BRK
e81b 00         BRK
e81c 00         BRK
e81d 00         BRK
e81e 00         BRK
e81f 00         BRK
e820 00         BRK
e821 00         BRK
e822 00         BRK
e823 00         BRK
e824 00         BRK
e825 00         BRK
e826 00         BRK
e827 00         BRK
e828 00         BRK
e829 00         BRK
e82a 00         BRK
e82b 00         BRK
e82c 00         BRK
e82d 00         BRK
e82e 00         BRK
e82f 00         BRK
e830 00         BRK
e831 00         BRK
e832 00         BRK
e833 00         BRK
e834 00         BRK
e835 00         BRK
e836 00         BRK
e837 00         BRK
e838 00         BRK
e839 00         BRK
e83a 00         BRK
e83b 00         BRK
e83c 00         BRK
e83d 00         BRK
e83e 00         BRK
e83f 00         BRK
e840 00         BRK
e841 00         BRK
e842 00         BRK
e843 00         BRK
e844 00         BRK
e845 00         BRK
e846 00         BRK
e847 00         BRK
e848 00         BRK
e849 00         BRK
e84a 00         BRK
e84b 00         BRK
e84c 00         BRK
e84d 00         BRK
e84e 00         BRK
e84f 00         BRK
e850 00         BRK
e851 00         BRK
e852 00         BRK
e853 00         BRK
e854 00         BRK
e855 00         BRK
e856 00         BRK
e857 00         BRK
e858 00         BRK
e859 00         BRK
e85a 00         BRK
e85b 00         BRK
e85c 00         BRK
e85d 00         BRK
e85e 00         BRK
e85f db 0f
e860 3016       BMI e878
e862 100f       BPL e873
e864 0928       ORA #$28
e866 250f       AND $0f
e868 0910       ORA #$10
e86a 210f       AND ($0f, X)
e86c 0926       ORA #$26
e86e 2900       AND #$00
e870 00         BRK
e871 6c6e6e     JMP (ABS) $6e6e
e874 00         BRK
e875 00         BRK
e876 6e0000     ROR $0000
e879 00         BRK
e87a 00         BRK
e87b 00         BRK
e87c 00         BRK
e87d 7c7c37     JMP (ABS) $377c, X
e880 00         BRK
e881 00         BRK
e882 00         BRK
e883 00         BRK
e884 00         BRK
e885 00         BRK
e886 00         BRK
e887 00         BRK
e888 00         BRK
e889 00         BRK
e88a 00         BRK
e88b 00         BRK
e88c 00         BRK
e88d 00         BRK
e88e 00         BRK
e88f 00         BRK
e890 00         BRK
e891 00         BRK
e892 00         BRK
e893 00         BRK
e894 00         BRK
e895 00         BRK
e896 00         BRK
e897 00         BRK
e898 00         BRK
e899 00         BRK
e89a 00         BRK
e89b 00         BRK
e89c 00         BRK
e89d 00         BRK
e89e 00         BRK
e89f 00         BRK
e8a0 00         BRK
e8a1 6900       ADC #$00
e8a3 590041     EOR $4100, Y
e8a6 00         BRK
e8a7 790069     ADC $6900, Y
e8aa 00         BRK
e8ab 59e500     EOR $00e5, Y
e8ae e500       SBC $00
e8b0 e500       SBC $00
e8b2 e500       SBC $00
e8b4 e500       SBC $00
e8b6 e500       SBC $00
e8b8 4900       EOR #$00
e8ba 590069     EOR $6900, Y
e8bd 00         BRK
e8be 2100       AND ($00, X)
e8c0 4900       EOR #$00
e8c2 00         BRK
e8c3 e500       SBC $00
e8c5 e500       SBC $00
e8c7 e500       SBC $00
e8c9 e500       SBC $00
e8cb e500       SBC $00
e8cd 2900       AND #$00
e8cf 6100       ADC ($00, X)
e8d1 590049     EOR $4900, Y
e8d4 00         BRK
e8d5 790069     ADC $6900, Y
e8d8 e500       SBC $00
e8da e500       SBC $00
e8dc e500       SBC $00
e8de e500       SBC $00
e8e0 e500       SBC $00
e8e2 e500       SBC $00
e8e4 790049     ADC $4900, Y
e8e7 00         BRK
e8e8 590069     EOR $6900, Y
e8eb 00         BRK
e8ec 2100       AND ($00, X)
e8ee 00         BRK
e8ef e500       SBC $00
e8f1 e500       SBC $00
e8f3 e500       SBC $00
e8f5 e500       SBC $00
e8f7 e500       SBC $00
e8f9 4900       EOR #$00
e8fb 2100       AND ($00, X)
e8fd 6900       ADC #$00
e8ff 590049     EOR $4900, Y
e902 00         BRK
e903 79e500     ADC $00e5, Y
e906 e500       SBC $00
e908 e500       SBC $00
e90a e500       SBC $00
e90c e500       SBC $00
e90e e500       SBC $00
e910 6900       ADC #$00
e912 790049     ADC $4900, Y
e915 00         BRK
e916 590061     EOR $6100, Y
e919 00         BRK
e91a 00         BRK
e91b e500       SBC $00
e91d e500       SBC $00
e91f e500       SBC $00
e921 e500       SBC $00
e923 e500       SBC $00
e925 590049     EOR $4900, Y
e928 00         BRK
e929 2900       AND #$00
e92b 6900       ADC #$00
e92d 590049     EOR $4900, Y
e930 e500       SBC $00
e932 e500       SBC $00
e934 e500       SBC $00
e936 e500       SBC $00
e938 e500       SBC $00
e93a e500       SBC $00
e93c 00         BRK
e93d 00         BRK
e93e 00         BRK
e93f 00         BRK
e940 00         BRK
e941 00         BRK
e942 00         BRK
e943 00         BRK
e944 00         BRK
e945 00         BRK
e946 00         BRK
e947 00         BRK
e948 00         BRK
e949 00         BRK
e94a 00         BRK
e94b 00         BRK
e94c 00         BRK
e94d 00         BRK
e94e 00         BRK
e94f 00         BRK
e950 00         BRK
e951 00         BRK
e952 00         BRK
e953 00         BRK
e954 00         BRK
e955 00         BRK
e956 00         BRK
e957 00         BRK
e958 00         BRK
e959 00         BRK
e95a 00         BRK
e95b 00         BRK
e95c 00         BRK
e95d 00         BRK
e95e 00         BRK
e95f db 0f
e960 3016       BMI e978
e962 100f       BPL e973
e964 0110       ORA ($10, X)
e966 160f       ASL $0f, X
e968 0111       ORA ($11, X)
e96a 290f       AND #$0f
e96c 0126       ORA ($26, X)
e96e 2500       AND $00
e970 00         BRK
e971 6c006e     JMP (ABS) $6e00
e974 6e6c6e     ROR $6e6c
e977 00         BRK
e978 00         BRK
e979 00         BRK
e97a 00         BRK
e97b 00         BRK
e97c 00         BRK
e97d 7c004e     JMP (ABS) $4e00, X
e980 00         BRK
e981 00         BRK
e982 00         BRK
e983 00         BRK
e984 00         BRK
e985 00         BRK
e986 00         BRK
e987 00         BRK
e988 00         BRK
e989 00         BRK
e98a 00         BRK
e98b 00         BRK
e98c 00         BRK
e98d 00         BRK
e98e 00         BRK
e98f 00         BRK
e990 00         BRK
e991 00         BRK
e992 00         BRK
e993 00         BRK
e994 00         BRK
e995 00         BRK
e996 00         BRK
e997 00         BRK
e998 00         BRK
e999 00         BRK
e99a 00         BRK
e99b 00         BRK
e99c 00         BRK
e99d 00         BRK
e99e 00         BRK
e99f 00         BRK
e9a0 00         BRK
e9a1 00         BRK
e9a2 00         BRK
e9a3 f000       BEQ e9a5
e9a5 f000       BEQ e9a7
e9a7 f000       BEQ e9a9
e9a9 f000       BEQ e9ab
e9ab 00         BRK
e9ac 00         BRK
e9ad 00         BRK
e9ae f000       BEQ e9b0
e9b0 f000       BEQ e9b2
e9b2 f000       BEQ e9b4
e9b4 f000       BEQ e9b6
e9b6 00         BRK
e9b7 00         BRK
e9b8 00         BRK
e9b9 f000       BEQ e9bb
e9bb f000       BEQ e9bd
e9bd f000       BEQ e9bf
e9bf f000       BEQ e9c1
e9c1 00         BRK
e9c2 00         BRK
e9c3 00         BRK
e9c4 f000       BEQ e9c6
e9c6 f000       BEQ e9c8
e9c8 f059       BEQ ea23
e9ca 5100       EOR ($00), Y
e9cc 00         BRK
e9cd 00         BRK
e9ce 00         BRK
e9cf f000       BEQ e9d1
e9d1 f000       BEQ e9d3
e9d3 f000       BEQ e9d5
e9d5 f000       BEQ e9d7
e9d7 00         BRK
e9d8 00         BRK
e9d9 00         BRK
e9da f000       BEQ e9dc
e9dc f061       BEQ ea3f
e9de 6161       ADC ($61, X)
e9e0 6100       ADC ($00, X)
e9e2 00         BRK
e9e3 00         BRK
e9e4 00         BRK
e9e5 f000       BEQ e9e7
e9e7 f000       BEQ e9e9
e9e9 f000       BEQ e9eb
e9eb f000       BEQ e9ed
e9ed 00         BRK
e9ee 00         BRK
e9ef 00         BRK
e9f0 f051       BEQ ea43
e9f2 5151       EOR ($51), Y
e9f4 595151     EOR $5151, Y
e9f7 00         BRK
e9f8 00         BRK
e9f9 00         BRK
e9fa 00         BRK
e9fb f000       BEQ e9fd
e9fd f000       BEQ e9ff
e9ff f000       BEQ ea01
ea01 f000       BEQ ea03
ea03 00         BRK
ea04 00         BRK
ea05 00         BRK
ea06 8981       STA #$81
ea08 8189       STA ($89, X)
ea0a 8981       STA #$81
ea0c 8100       STA ($00, X)
ea0e 00         BRK
ea0f 00         BRK
ea10 00         BRK
ea11 e5e5       SBC $e5
ea13 e5e5       SBC $e5
ea15 e5e5       SBC $e5
ea17 e500       SBC $00
ea19 00         BRK
ea1a 00         BRK
ea1b 00         BRK
ea1c 00         BRK
ea1d 00         BRK
ea1e 00         BRK
ea1f 00         BRK
ea20 00         BRK
ea21 00         BRK
ea22 00         BRK
ea23 00         BRK
ea24 00         BRK
ea25 00         BRK
ea26 00         BRK
ea27 00         BRK
ea28 00         BRK
ea29 00         BRK
ea2a 00         BRK
ea2b 00         BRK
ea2c 00         BRK
ea2d 00         BRK
ea2e 00         BRK
ea2f 00         BRK
ea30 00         BRK
ea31 00         BRK
ea32 00         BRK
ea33 00         BRK
ea34 00         BRK
ea35 00         BRK
ea36 00         BRK
ea37 00         BRK
ea38 00         BRK
ea39 00         BRK
ea3a 00         BRK
ea3b 00         BRK
ea3c 00         BRK
ea3d 00         BRK
ea3e 00         BRK
ea3f 00         BRK
ea40 00         BRK
ea41 00         BRK
ea42 00         BRK
ea43 00         BRK
ea44 00         BRK
ea45 00         BRK
ea46 00         BRK
ea47 00         BRK
ea48 00         BRK
ea49 00         BRK
ea4a 00         BRK
ea4b 00         BRK
ea4c 00         BRK
ea4d 00         BRK
ea4e 00         BRK
ea4f 00         BRK
ea50 00         BRK
ea51 00         BRK
ea52 00         BRK
ea53 00         BRK
ea54 00         BRK
ea55 00         BRK
ea56 00         BRK
ea57 00         BRK
ea58 00         BRK
ea59 00         BRK
ea5a 00         BRK
ea5b 00         BRK
ea5c 00         BRK
ea5d 00         BRK
ea5e 00         BRK
ea5f db 0f
ea60 3016       BMI ea78
ea62 100f       BPL ea73
ea64 1628       ASL $28, X
ea66 160f       ASL $0f, X
ea68 1628       ASL $28, X
ea6a 110f       ORA ($0f), Y
ea6c 1610       ASL $10, X
ea6e db 27
ea6f 00         BRK
ea70 00         BRK
ea71 00         BRK
ea72 00         BRK
ea73 00         BRK
ea74 6e6e00     ROR $006e
ea77 6e0000     ROR $0000
ea7a 00         BRK
ea7b 00         BRK
ea7c 00         BRK
ea7d 7c7c1a     JMP (ABS) $1a7c, X
ea80 00         BRK
ea81 00         BRK
ea82 00         BRK
ea83 00         BRK
ea84 00         BRK
ea85 00         BRK
ea86 00         BRK
ea87 00         BRK
ea88 00         BRK
ea89 00         BRK
ea8a 00         BRK
ea8b 00         BRK
ea8c 00         BRK
ea8d 00         BRK
ea8e 00         BRK
ea8f 00         BRK
ea90 00         BRK
ea91 00         BRK
ea92 00         BRK
ea93 00         BRK
ea94 00         BRK
ea95 00         BRK
ea96 00         BRK
ea97 00         BRK
ea98 00         BRK
ea99 00         BRK
ea9a 00         BRK
ea9b 00         BRK
ea9c 00         BRK
ea9d 00         BRK
ea9e 00         BRK
ea9f 00         BRK
eaa0 00         BRK
eaa1 00         BRK
eaa2 00         BRK
eaa3 00         BRK
eaa4 00         BRK
eaa5 00         BRK
eaa6 00         BRK
eaa7 00         BRK
eaa8 00         BRK
eaa9 00         BRK
eaaa 00         BRK
eaab 00         BRK
eaac 00         BRK
eaad 00         BRK
eaae 00         BRK
eaaf 00         BRK
eab0 00         BRK
eab1 00         BRK
eab2 00         BRK
eab3 00         BRK
eab4 00         BRK
eab5 00         BRK
eab6 00         BRK
eab7 00         BRK
eab8 00         BRK
eab9 00         BRK
eaba 00         BRK
eabb 00         BRK
eabc 00         BRK
eabd 00         BRK
eabe 00         BRK
eabf 00         BRK
eac0 00         BRK
eac1 00         BRK
eac2 00         BRK
eac3 00         BRK
eac4 00         BRK
eac5 00         BRK
eac6 00         BRK
eac7 00         BRK
eac8 00         BRK
eac9 00         BRK
eaca 00         BRK
eacb 00         BRK
eacc 00         BRK
eacd 00         BRK
eace 00         BRK
eacf 00         BRK
ead0 00         BRK
ead1 00         BRK
ead2 00         BRK
ead3 00         BRK
ead4 00         BRK
ead5 00         BRK
ead6 00         BRK
ead7 00         BRK
ead8 00         BRK
ead9 00         BRK
eada 00         BRK
eadb 00         BRK
eadc 00         BRK
eadd 00         BRK
eade 00         BRK
eadf 00         BRK
eae0 00         BRK
eae1 00         BRK
eae2 00         BRK
eae3 00         BRK
eae4 00         BRK
eae5 00         BRK
eae6 00         BRK
eae7 00         BRK
eae8 00         BRK
eae9 00         BRK
eaea 00         BRK
eaeb 00         BRK
eaec 00         BRK
eaed 00         BRK
eaee 00         BRK
eaef 00         BRK
eaf0 00         BRK
eaf1 00         BRK
eaf2 00         BRK
eaf3 00         BRK
eaf4 00         BRK
eaf5 00         BRK
eaf6 00         BRK
eaf7 00         BRK
eaf8 00         BRK
eaf9 00         BRK
eafa 00         BRK
eafb 00         BRK
eafc 00         BRK
eafd 00         BRK
eafe 00         BRK
eaff 00         BRK
eb00 00         BRK
eb01 00         BRK
eb02 00         BRK
eb03 00         BRK
eb04 00         BRK
eb05 00         BRK
eb06 00         BRK
eb07 00         BRK
eb08 00         BRK
eb09 00         BRK
eb0a 00         BRK
eb0b 00         BRK
eb0c 00         BRK
eb0d 00         BRK
eb0e 00         BRK
eb0f 00         BRK
eb10 00         BRK
eb11 00         BRK
eb12 00         BRK
eb13 00         BRK
eb14 00         BRK
eb15 00         BRK
eb16 00         BRK
eb17 00         BRK
eb18 00         BRK
eb19 00         BRK
eb1a 00         BRK
eb1b 00         BRK
eb1c 00         BRK
eb1d 00         BRK
eb1e 00         BRK
eb1f 00         BRK
eb20 00         BRK
eb21 00         BRK
eb22 00         BRK
eb23 00         BRK
eb24 00         BRK
eb25 00         BRK
eb26 00         BRK
eb27 00         BRK
eb28 00         BRK
eb29 00         BRK
eb2a 00         BRK
eb2b 00         BRK
eb2c 00         BRK
eb2d 00         BRK
eb2e 00         BRK
eb2f 00         BRK
eb30 00         BRK
eb31 00         BRK
eb32 00         BRK
eb33 00         BRK
eb34 00         BRK
eb35 00         BRK
eb36 00         BRK
eb37 00         BRK
eb38 00         BRK
eb39 00         BRK
eb3a 00         BRK
eb3b 00         BRK
eb3c 00         BRK
eb3d 00         BRK
eb3e 00         BRK
eb3f 00         BRK
eb40 00         BRK
eb41 00         BRK
eb42 00         BRK
eb43 00         BRK
eb44 00         BRK
eb45 00         BRK
eb46 00         BRK
eb47 00         BRK
eb48 00         BRK
eb49 00         BRK
eb4a 00         BRK
eb4b 00         BRK
eb4c 00         BRK
eb4d 00         BRK
eb4e 00         BRK
eb4f 00         BRK
eb50 00         BRK
eb51 00         BRK
eb52 00         BRK
eb53 00         BRK
eb54 00         BRK
eb55 00         BRK
eb56 00         BRK
eb57 00         BRK
eb58 00         BRK
eb59 00         BRK
eb5a 00         BRK
eb5b 00         BRK
eb5c 00         BRK
eb5d 00         BRK
eb5e 00         BRK
eb5f db 0f
eb60 3016       BMI eb78
eb62 100f       BPL eb73
eb64 0606       ASL $06
eb66 160f       ASL $0f, X
eb68 0630       ASL $30
eb6a 300f       BMI eb7b
eb6c db 0f
eb6d db 0f
eb6e db 0f
eb6f 00         BRK
eb70 00         BRK
eb71 00         BRK
eb72 00         BRK
eb73 00         BRK
eb74 00         BRK
eb75 00         BRK
eb76 00         BRK
eb77 00         BRK
eb78 00         BRK
eb79 00         BRK
eb7a 00         BRK
eb7b 00         BRK
eb7c 00         BRK
eb7d 00         BRK
eb7e 00         BRK
eb7f 4240       LSR #$40
eb81 5050       BVC ebd3
eb83 5050       BVC ebd5
eb85 5000       BVC eb87
eb87 00         BRK
eb88 4455       JMP $55
eb8a 5555       EOR $55, X
eb8c 5555       EOR $55, X
eb8e 00         BRK
eb8f 00         BRK
eb90 c8         INY
eb91 db fa
eb92 db fa
eb93 db fa
eb94 db fa
eb95 db fa
eb96 00         BRK
eb97 00         BRK
eb98 4455       JMP $55
eb9a 5555       EOR $55, X
eb9c 5555       EOR $55, X
eb9e 00         BRK
eb9f 00         BRK
eba0 4455       JMP $55
eba2 5555       EOR $55, X
eba4 5555       EOR $55, X
eba6 00         BRK
eba7 00         BRK
eba8 4455       JMP $55
ebaa 5555       EOR $55, X
ebac 5555       EOR $55, X
ebae 00         BRK
ebaf 00         BRK
ebb0 4455       JMP $55
ebb2 5555       EOR $55, X
ebb4 5555       EOR $55, X
ebb6 00         BRK
ebb7 00         BRK
ebb8 4455       JMP $55
ebba 5555       EOR $55, X
ebbc 5555       EOR $55, X
ebbe 00         BRK
ebbf 00         BRK
ebc0 40         RTI
ebc1 5050       BVC ec13
ebc3 5050       BVC ec15
ebc5 5000       BVC ebc7
ebc7 00         BRK
ebc8 44aa       JMP $aa
ebca db ff
ebcb 5555       EOR $55, X
ebcd 5500       EOR $00, X
ebcf 00         BRK
ebd0 44aa       JMP $aa
ebd2 db ff
ebd3 9565       STA $65, X
ebd5 5500       EOR $00, X
ebd7 00         BRK
ebd8 445a       JMP $5a
ebda db 5f
ebdb 595e57     EOR $575e, Y
ebde 00         BRK
ebdf 00         BRK
ebe0 4455       JMP $55
ebe2 5555       EOR $55, X
ebe4 5555       EOR $55, X
ebe6 00         BRK
ebe7 00         BRK
ebe8 4455       JMP $55
ebea 5555       EOR $55, X
ebec 5555       EOR $55, X
ebee 00         BRK
ebef 00         BRK
ebf0 4455       JMP $55
ebf2 5555       EOR $55, X
ebf4 5555       EOR $55, X
ebf6 00         BRK
ebf7 00         BRK
ebf8 4455       JMP $55
ebfa 5555       EOR $55, X
ebfc 5555       EOR $55, X
ebfe 00         BRK
ebff 00         BRK
ec00 40         RTI
ec01 5050       BVC ec53
ec03 5050       BVC ec55
ec05 5000       BVC ec07
ec07 00         BRK
ec08 84a5       STY $a5
ec0a 5555       EOR $55, X
ec0c 5555       EOR $55, X
ec0e 00         BRK
ec0f 00         BRK
ec10 48         PHA
ec11 db 5a
ec12 db 5a
ec13 db 5a
ec14 db 9a
ec15 aa         LDX
ec16 00         BRK
ec17 00         BRK
ec18 ccff5f     CPY $5fff
ec1b db 5f
ec1c db 5f
ec1d db 5f
ec1e 00         BRK
ec1f 00         BRK
ec20 4c5f5f     JMP $5f5f
ec23 db 5f
ec24 db df
ec25 db ff
ec26 00         BRK
ec27 00         BRK
ec28 4455       JMP $55
ec2a 5555       EOR $55, X
ec2c 5555       EOR $55, X
ec2e 00         BRK
ec2f 00         BRK
ec30 4455       JMP $55
ec32 5555       EOR $55, X
ec34 5555       EOR $55, X
ec36 00         BRK
ec37 00         BRK
ec38 4455       JMP $55
ec3a 5555       EOR $55, X
ec3c 5555       EOR $55, X
ec3e 00         BRK
ec3f 00         BRK
ec40 40         RTI
ec41 5050       BVC ec93
ec43 5050       BVC ec95
ec45 5000       BVC ec47
ec47 00         BRK
ec48 4495       JMP $95
ec4a e595       SBC $95
ec4c 6555       ADC $55
ec4e 00         BRK
ec4f 00         BRK
ec50 44be       JMP $be
ec52 db 6b
ec53 95e9       STA $e9, X
ec55 7600       ROR $00, X
ec57 00         BRK
ec58 4496       JMP $96
ec5a e99d       SBC #$9d
ec5c db 6b
ec5d 5600       LSR $00, X
ec5f 00         BRK
ec60 44be       JMP $be
ec62 db 6b
ec63 95e9       STA $e9, X
ec65 7600       ROR $00, X
ec67 00         BRK
ec68 4455       JMP $55
ec6a 5555       EOR $55, X
ec6c 5555       EOR $55, X
ec6e 00         BRK
ec6f 00         BRK
ec70 4455       JMP $55
ec72 5555       EOR $55, X
ec74 5555       EOR $55, X
ec76 00         BRK
ec77 00         BRK
ec78 4455       JMP $55
ec7a 5555       EOR $55, X
ec7c 5555       EOR $55, X
ec7e 00         BRK
ec7f 00         BRK
ec80 40         RTI
ec81 5050       BVC ecd3
ec83 5050       BVC ecd5
ec85 5000       BVC ec87
ec87 00         BRK
ec88 4455       JMP $55
ec8a db 9a
ec8b 995655     STA $5556, Y
ec8e 00         BRK
ec8f 00         BRK
ec90 4455       JMP $55
ec92 5555       EOR $55, X
ec94 5555       EOR $55, X
ec96 00         BRK
ec97 00         BRK
ec98 4455       JMP $55
ec9a 5555       EOR $55, X
ec9c 5555       EOR $55, X
ec9e 00         BRK
ec9f 00         BRK
eca0 4455       JMP $55
eca2 5555       EOR $55, X
eca4 5555       EOR $55, X
eca6 00         BRK
eca7 00         BRK
eca8 4455       JMP $55
ecaa 5555       EOR $55, X
ecac 5555       EOR $55, X
ecae 00         BRK
ecaf 00         BRK
ecb0 4455       JMP $55
ecb2 5555       EOR $55, X
ecb4 5555       EOR $55, X
ecb6 00         BRK
ecb7 00         BRK
ecb8 4455       JMP $55
ecba 5555       EOR $55, X
ecbc 5555       EOR $55, X
ecbe 00         BRK
ecbf 00         BRK
ecc0 40         RTI
ecc1 5050       BVC ed13
ecc3 5050       BVC ed15
ecc5 5000       BVC ecc7
ecc7 00         BRK
ecc8 4499       JMP $99
ecca dddd99     CMP $99dd, X
eccd 5500       EOR $00, X
eccf 00         BRK
ecd0 4499       JMP $99
ecd2 dddd99     CMP $99dd, X
ecd5 5500       EOR $00, X
ecd7 00         BRK
ecd8 4499       JMP $99
ecda dddd99     CMP $99dd, X
ecdd 5500       EOR $00, X
ecdf 00         BRK
ece0 4455       JMP $55
ece2 5555       EOR $55, X
ece4 5555       EOR $55, X
ece6 00         BRK
ece7 00         BRK
ece8 4455       JMP $55
ecea 5555       EOR $55, X
ecec 5555       EOR $55, X
ecee 00         BRK
ecef 00         BRK
ecf0 4455       JMP $55
ecf2 5555       EOR $55, X
ecf4 5555       EOR $55, X
ecf6 00         BRK
ecf7 00         BRK
ecf8 4455       JMP $55
ecfa 5555       EOR $55, X
ecfc 5555       EOR $55, X
ecfe 00         BRK
ecff 00         BRK
ed00 40         RTI
ed01 5050       BVC ed53
ed03 5050       BVC ed55
ed05 5000       BVC ed07
ed07 00         BRK
ed08 4455       JMP $55
ed0a 55f5       EOR $f5, X
ed0c 5555       EOR $55, X
ed0e 00         BRK
ed0f 00         BRK
ed10 44d5       JMP $d5
ed12 db 5f
ed13 a55a       LDA $5a
ed15 5500       EOR $00, X
ed17 00         BRK
ed18 4495       JMP $95
ed1a db 5a
ed1b f55f       SBC $5f, X
ed1d 5500       EOR $00, X
ed1f 00         BRK
ed20 4455       JMP $55
ed22 db 5f
ed23 5556       EOR $56, X
ed25 5500       EOR $00, X
ed27 00         BRK
ed28 4455       JMP $55
ed2a 5555       EOR $55, X
ed2c 5555       EOR $55, X
ed2e 00         BRK
ed2f 00         BRK
ed30 4455       JMP $55
ed32 5555       EOR $55, X
ed34 5555       EOR $55, X
ed36 00         BRK
ed37 00         BRK
ed38 4455       JMP $55
ed3a 5555       EOR $55, X
ed3c 5555       EOR $55, X
ed3e 00         BRK
ed3f 00         BRK
ed40 40         RTI
ed41 5050       BVC ed93
ed43 5050       BVC ed95
ed45 5000       BVC ed47
ed47 00         BRK
ed48 4455       JMP $55
ed4a 5555       EOR $55, X
ed4c 5555       EOR $55, X
ed4e 00         BRK
ed4f 00         BRK
ed50 4455       JMP $55
ed52 5576       EOR $76, X
ed54 5555       EOR $55, X
ed56 00         BRK
ed57 00         BRK
ed58 4455       JMP $55
ed5a 5556       EOR $56, X
ed5c 5555       EOR $55, X
ed5e 00         BRK
ed5f 00         BRK
ed60 4455       JMP $55
ed62 5555       EOR $55, X
ed64 5555       EOR $55, X
ed66 00         BRK
ed67 00         BRK
ed68 4455       JMP $55
ed6a 5555       EOR $55, X
ed6c 5555       EOR $55, X
ed6e 00         BRK
ed6f 00         BRK
ed70 4455       JMP $55
ed72 5555       EOR $55, X
ed74 5555       EOR $55, X
ed76 00         BRK
ed77 00         BRK
ed78 4455       JMP $55
ed7a 5555       EOR $55, X
ed7c 5555       EOR $55, X
ed7e 00         BRK
ed7f 00         BRK
ed80 40         RTI
ed81 5050       BVC edd3
ed83 5050       BVC edd5
ed85 5000       BVC ed87
ed87 00         BRK
ed88 4459       JMP $59
ed8a 5555       EOR $55, X
ed8c 595500     EOR $0055, Y
ed8f 00         BRK
ed90 4455       JMP $55
ed92 db b7
ed93 a577       LDA $77
ed95 5500       EOR $00, X
ed97 00         BRK
ed98 4455       JMP $55
ed9a db 7b
ed9b db 5a
ed9c db 77
ed9d 5500       EOR $00, X
ed9f 00         BRK
eda0 4455       JMP $55
eda2 5555       EOR $55, X
eda4 5555       EOR $55, X
eda6 00         BRK
eda7 00         BRK
eda8 4455       JMP $55
edaa 5555       EOR $55, X
edac 5555       EOR $55, X
edae 00         BRK
edaf 00         BRK
edb0 4455       JMP $55
edb2 5555       EOR $55, X
edb4 5555       EOR $55, X
edb6 00         BRK
edb7 00         BRK
edb8 4455       JMP $55
edba 5555       EOR $55, X
edbc 5555       EOR $55, X
edbe 00         BRK
edbf 00         BRK
edc0 40         RTI
edc1 5050       BVC ee13
edc3 5050       BVC ee15
edc5 5000       BVC edc7
edc7 00         BRK
edc8 4455       JMP $55
edca 55a5       EOR $a5, X
edcc 6555       ADC $55
edce 00         BRK
edcf 00         BRK
edd0 4455       JMP $55
edd2 db 9a
edd3 aeaa56     LDX $56aa
edd6 00         BRK
edd7 00         BRK
edd8 4455       JMP $55
edda 5559       EOR $59, X
eddc 5555       EOR $55, X
edde 00         BRK
eddf 00         BRK
ede0 4455       JMP $55
ede2 5555       EOR $55, X
ede4 5555       EOR $55, X
ede6 00         BRK
ede7 00         BRK
ede8 4455       JMP $55
edea 5555       EOR $55, X
edec 5555       EOR $55, X
edee 00         BRK
edef 00         BRK
edf0 4455       JMP $55
edf2 5555       EOR $55, X
edf4 5555       EOR $55, X
edf6 00         BRK
edf7 00         BRK
edf8 4455       JMP $55
edfa 5555       EOR $55, X
edfc 5555       EOR $55, X
edfe 00         BRK
edff 00         BRK
ee00 40         RTI
ee01 5050       BVC ee53
ee03 5050       BVC ee55
ee05 5000       BVC ee07
ee07 00         BRK
ee08 4455       JMP $55
ee0a 5555       EOR $55, X
ee0c 5555       EOR $55, X
ee0e 00         BRK
ee0f 00         BRK
ee10 4455       JMP $55
ee12 5555       EOR $55, X
ee14 5555       EOR $55, X
ee16 00         BRK
ee17 00         BRK
ee18 4455       JMP $55
ee1a 5555       EOR $55, X
ee1c 5555       EOR $55, X
ee1e 00         BRK
ee1f 00         BRK
ee20 4455       JMP $55
ee22 5555       EOR $55, X
ee24 5555       EOR $55, X
ee26 00         BRK
ee27 00         BRK
ee28 4455       JMP $55
ee2a 5555       EOR $55, X
ee2c 5555       EOR $55, X
ee2e 00         BRK
ee2f 00         BRK
ee30 4455       JMP $55
ee32 5555       EOR $55, X
ee34 5555       EOR $55, X
ee36 00         BRK
ee37 00         BRK
ee38 4455       JMP $55
ee3a 5555       EOR $55, X
ee3c 5555       EOR $55, X
ee3e 00         BRK
ee3f 00         BRK
ee40 40         RTI
ee41 5050       BVC ee93
ee43 5050       BVC ee95
ee45 5000       BVC ee47
ee47 00         BRK
ee48 44d5       JMP $d5
ee4a 5555       EOR $55, X
ee4c 5555       EOR $55, X
ee4e 00         BRK
ee4f 00         BRK
ee50 4455       JMP $55
ee52 5567       EOR $67, X
ee54 7555       ADC $55, X
ee56 00         BRK
ee57 00         BRK
ee58 4495       JMP $95
ee5a 5555       EOR $55, X
ee5c 5555       EOR $55, X
ee5e 00         BRK
ee5f 00         BRK
ee60 4455       JMP $55
ee62 5555       EOR $55, X
ee64 5555       EOR $55, X
ee66 00         BRK
ee67 00         BRK
ee68 4455       JMP $55
ee6a 5555       EOR $55, X
ee6c 5555       EOR $55, X
ee6e 00         BRK
ee6f 00         BRK
ee70 4455       JMP $55
ee72 5555       EOR $55, X
ee74 5555       EOR $55, X
ee76 00         BRK
ee77 00         BRK
ee78 4455       JMP $55
ee7a 5555       EOR $55, X
ee7c 5555       EOR $55, X
ee7e 00         BRK
ee7f 00         BRK
ee80 40         RTI
ee81 5050       BVC eed3
ee83 5050       BVC eed5
ee85 5000       BVC ee87
ee87 00         BRK
ee88 4455       JMP $55
ee8a 5555       EOR $55, X
ee8c 5555       EOR $55, X
ee8e 00         BRK
ee8f 00         BRK
ee90 44fa       JMP $fa
ee92 9dafd9     STA $d9af, X
ee95 7600       ROR $00, X
ee97 00         BRK
ee98 4455       JMP $55
ee9a 5555       EOR $55, X
ee9c 5555       EOR $55, X
ee9e 00         BRK
ee9f 00         BRK
eea0 4455       JMP $55
eea2 5555       EOR $55, X
eea4 5555       EOR $55, X
eea6 00         BRK
eea7 00         BRK
eea8 4455       JMP $55
eeaa 5555       EOR $55, X
eeac 5555       EOR $55, X
eeae 00         BRK
eeaf 00         BRK
eeb0 4455       JMP $55
eeb2 5555       EOR $55, X
eeb4 5555       EOR $55, X
eeb6 00         BRK
eeb7 00         BRK
eeb8 4455       JMP $55
eeba 5555       EOR $55, X
eebc 5555       EOR $55, X
eebe 00         BRK
eebf 00         BRK
eec0 40         RTI
eec1 5050       BVC ef13
eec3 5050       BVC ef15
eec5 5000       BVC eec7
eec7 00         BRK
eec8 48         PHA
eec9 db 5f
eeca db 5f
eecb db 5f
eecc db 5f
eecd db 5b
eece 00         BRK
eecf 00         BRK
eed0 4c5f5f     JMP $5f5f
eed3 db 5f
eed4 db 5f
eed5 db 5f
eed6 00         BRK
eed7 00         BRK
eed8 84af       STY $af
eeda db af
eedb db af
eedc db af
eedd db a7
eede 00         BRK
eedf 00         BRK
eee0 48         PHA
eee1 db 5a
eee2 db 5a
eee3 db 5a
eee4 db 5a
eee5 db 5a
eee6 00         BRK
eee7 00         BRK
eee8 4455       JMP $55
eeea 5555       EOR $55, X
eeec 5555       EOR $55, X
eeee 00         BRK
eeef 00         BRK
eef0 4455       JMP $55
eef2 5555       EOR $55, X
eef4 5555       EOR $55, X
eef6 00         BRK
eef7 00         BRK
eef8 4455       JMP $55
eefa 5555       EOR $55, X
eefc 5555       EOR $55, X
eefe 00         BRK
eeff 00         BRK
ef00 40         RTI
ef01 5050       BVC ef53
ef03 5050       BVC ef55
ef05 5000       BVC ef07
ef07 00         BRK
ef08 4495       JMP $95
ef0a 6555       ADC $55
ef0c f555       SBC $55, X
ef0e 00         BRK
ef0f 00         BRK
ef10 4499       JMP $99
ef12 aa         LDX
ef13 ddff55     CMP $55ff, X
ef16 00         BRK
ef17 00         BRK
ef18 4459       JMP $59
ef1a aa         LDX
ef1b dd7f55     CMP $557f, X
ef1e 00         BRK
ef1f 00         BRK
ef20 4455       JMP $55
ef22 5555       EOR $55, X
ef24 5555       EOR $55, X
ef26 00         BRK
ef27 00         BRK
ef28 4455       JMP $55
ef2a 5555       EOR $55, X
ef2c 5555       EOR $55, X
ef2e 00         BRK
ef2f 00         BRK
ef30 4455       JMP $55
ef32 5555       EOR $55, X
ef34 5555       EOR $55, X
ef36 00         BRK
ef37 00         BRK
ef38 4455       JMP $55
ef3a 5555       EOR $55, X
ef3c 5555       EOR $55, X
ef3e 00         BRK
ef3f 00         BRK
ef40 40         RTI
ef41 5050       BVC ef93
ef43 5050       BVC ef95
ef45 5000       BVC ef47
ef47 00         BRK
ef48 4455       JMP $55
ef4a a595       LDA $95
ef4c 6555       ADC $55
ef4e 00         BRK
ef4f 00         BRK
ef50 88         DEY
ef51 aa         LDX
ef52 db fa
ef53 d9baaa     CMP $aaba, Y
ef56 00         BRK
ef57 00         BRK
ef58 ccffaf     CPY $afff
ef5b 9defff     STA $ffef, X
ef5e 00         BRK
ef5f 00         BRK
ef60 48         PHA
ef61 db 5a
ef62 5555       EOR $55, X
ef64 595a00     EOR $005a, Y
ef67 00         BRK
ef68 4455       JMP $55
ef6a 5555       EOR $55, X
ef6c 5555       EOR $55, X
ef6e 00         BRK
ef6f 00         BRK
ef70 4455       JMP $55
ef72 5555       EOR $55, X
ef74 5555       EOR $55, X
ef76 00         BRK
ef77 00         BRK
ef78 4455       JMP $55
ef7a 5555       EOR $55, X
ef7c 5555       EOR $55, X
ef7e 00         BRK
ef7f 00         BRK
ef80 40         RTI
ef81 5050       BVC efd3
ef83 5050       BVC efd5
ef85 5000       BVC ef87
ef87 00         BRK
ef88 44a5       JMP $a5
ef8a aa         LDX
ef8b adf775     LDA $75f7
ef8e 00         BRK
ef8f 00         BRK
ef90 445a       JMP $5a
ef92 db 5a
ef93 db 5a
ef94 5e5700     LSR $0057, X
ef97 00         BRK
ef98 4455       JMP $55
ef9a 5555       EOR $55, X
ef9c 5555       EOR $55, X
ef9e 00         BRK
ef9f 00         BRK
efa0 4455       JMP $55
efa2 5555       EOR $55, X
efa4 5555       EOR $55, X
efa6 00         BRK
efa7 00         BRK
efa8 4455       JMP $55
efaa 5555       EOR $55, X
efac 5555       EOR $55, X
efae 00         BRK
efaf 00         BRK
efb0 4455       JMP $55
efb2 5555       EOR $55, X
efb4 5555       EOR $55, X
efb6 00         BRK
efb7 00         BRK
efb8 4455       JMP $55
efba 5555       EOR $55, X
efbc 5555       EOR $55, X
efbe 00         BRK
efbf 00         BRK
efc0 40         RTI
efc1 5050       BVC f013
efc3 5050       BVC f015
efc5 5000       BVC efc7
efc7 00         BRK
efc8 88         DEY
efc9 5555       EOR $55, X
efcb 5555       EOR $55, X
efcd 990000     STA $0000, Y
efd0 88         DEY
efd1 5599       EOR $99, X
efd3 db 9b
efd4 5599       EOR $99, X
efd6 00         BRK
efd7 00         BRK
efd8 88         DEY
efd9 5599       EOR $99, X
efdb 995599     STA $9955, Y
efde 00         BRK
efdf 00         BRK
efe0 4455       JMP $55
efe2 5555       EOR $55, X
efe4 5555       EOR $55, X
efe6 00         BRK
efe7 00         BRK
efe8 4455       JMP $55
efea 5555       EOR $55, X
efec 5555       EOR $55, X
efee 00         BRK
efef 00         BRK
eff0 4455       JMP $55
eff2 5555       EOR $55, X
eff4 5555       EOR $55, X
eff6 00         BRK
eff7 00         BRK
eff8 4455       JMP $55
effa 5555       EOR $55, X
effc 5555       EOR $55, X
effe 00         BRK
efff 00         BRK
f000 40         RTI
f001 5050       BVC f053
f003 5050       BVC f055
f005 5000       BVC f007
f007 00         BRK
f008 4455       JMP $55
f00a e5d5       SBC $d5
f00c 6555       ADC $55
f00e 00         BRK
f00f 00         BRK
f010 4455       JMP $55
f012 eedd66     INC $66dd
f015 5500       EOR $00, X
f017 00         BRK
f018 4455       JMP $55
f01a 5e5d56     LSR $565d, X
f01d 5500       EOR $00, X
f01f 00         BRK
f020 4455       JMP $55
f022 5555       EOR $55, X
f024 5555       EOR $55, X
f026 00         BRK
f027 00         BRK
f028 4455       JMP $55
f02a 5555       EOR $55, X
f02c 5555       EOR $55, X
f02e 00         BRK
f02f 00         BRK
f030 4455       JMP $55
f032 5555       EOR $55, X
f034 5555       EOR $55, X
f036 00         BRK
f037 00         BRK
f038 4455       JMP $55
f03a 5555       EOR $55, X
f03c 5555       EOR $55, X
f03e 00         BRK
f03f 00         BRK
f040 40         RTI
f041 5050       BVC f093
f043 5050       BVC f095
f045 5000       BVC f047
f047 00         BRK
f048 849d       STY $9d
f04a 9d9599     STA $9995, X
f04d dd0000     CMP $0000, X
f050 4455       JMP $55
f052 595995     EOR $9559, Y
f055 5500       EOR $00, X
f057 00         BRK
f058 8495       STY $95
f05a 595955     EOR $5559, Y
f05d 5500       EOR $00, X
f05f 00         BRK
f060 4455       JMP $55
f062 5555       EOR $55, X
f064 5555       EOR $55, X
f066 00         BRK
f067 00         BRK
f068 4455       JMP $55
f06a 5555       EOR $55, X
f06c 5555       EOR $55, X
f06e 00         BRK
f06f 00         BRK
f070 4455       JMP $55
f072 5555       EOR $55, X
f074 5555       EOR $55, X
f076 00         BRK
f077 00         BRK
f078 4455       JMP $55
f07a 5555       EOR $55, X
f07c 5555       EOR $55, X
f07e 00         BRK
f07f 00         BRK
f080 40         RTI
f081 5050       BVC f0d3
f083 5050       BVC f0d5
f085 5000       BVC f087
f087 00         BRK
f088 4459       JMP $59
f08a db 5a
f08b db 5a
f08c db 5a
f08d 5500       EOR $00, X
f08f 00         BRK
f090 4455       JMP $55
f092 9daf55     STA $55af, X
f095 5500       EOR $00, X
f097 00         BRK
f098 4455       JMP $55
f09a 5555       EOR $55, X
f09c 5555       EOR $55, X
f09e 00         BRK
f09f 00         BRK
f0a0 4455       JMP $55
f0a2 5555       EOR $55, X
f0a4 5555       EOR $55, X
f0a6 00         BRK
f0a7 00         BRK
f0a8 4455       JMP $55
f0aa 5555       EOR $55, X
f0ac 5555       EOR $55, X
f0ae 00         BRK
f0af 00         BRK
f0b0 4455       JMP $55
f0b2 5555       EOR $55, X
f0b4 5555       EOR $55, X
f0b6 00         BRK
f0b7 00         BRK
f0b8 4455       JMP $55
f0ba 5555       EOR $55, X
f0bc 5555       EOR $55, X
f0be 00         BRK
f0bf 00         BRK
f0c0 40         RTI
f0c1 5050       BVC f113
f0c3 5050       BVC f115
f0c5 5000       BVC f0c7
f0c7 00         BRK
f0c8 4455       JMP $55
f0ca 5555       EOR $55, X
f0cc 5555       EOR $55, X
f0ce 00         BRK
f0cf 00         BRK
f0d0 88         DEY
f0d1 5599       EOR $99, X
f0d3 aa         LDX
f0d4 5599       EOR $99, X
f0d6 00         BRK
f0d7 00         BRK
f0d8 88         DEY
f0d9 aa         LDX
f0da aa         LDX
f0db aa         LDX
f0dc aa         LDX
f0dd aa         LDX
f0de 00         BRK
f0df 00         BRK
f0e0 4455       JMP $55
f0e2 5555       EOR $55, X
f0e4 5555       EOR $55, X
f0e6 00         BRK
f0e7 00         BRK
f0e8 4455       JMP $55
f0ea 5555       EOR $55, X
f0ec 5555       EOR $55, X
f0ee 00         BRK
f0ef 00         BRK
f0f0 4455       JMP $55
f0f2 5555       EOR $55, X
f0f4 5555       EOR $55, X
f0f6 00         BRK
f0f7 00         BRK
f0f8 4455       JMP $55
f0fa 5555       EOR $55, X
f0fc 5555       EOR $55, X
f0fe 00         BRK
f0ff 00         BRK
f100 40         RTI
f101 5050       BVC f153
f103 5050       BVC f155
f105 5000       BVC f107
f107 00         BRK
f108 4c6f5f     JMP $5f6f
f10b db 6f
f10c db 5f
f10d db 6f
f10e 00         BRK
f10f 00         BRK
f110 4455       JMP $55
f112 5555       EOR $55, X
f114 5555       EOR $55, X
f116 00         BRK
f117 00         BRK
f118 4475       JMP $75
f11a 5575       EOR $75, X
f11c 5575       EOR $75, X
f11e 00         BRK
f11f 00         BRK
f120 4455       JMP $55
f122 5555       EOR $55, X
f124 5555       EOR $55, X
f126 00         BRK
f127 00         BRK
f128 4455       JMP $55
f12a 5555       EOR $55, X
f12c 5555       EOR $55, X
f12e 00         BRK
f12f 00         BRK
f130 4455       JMP $55
f132 5555       EOR $55, X
f134 5555       EOR $55, X
f136 00         BRK
f137 00         BRK
f138 4455       JMP $55
f13a 5555       EOR $55, X
f13c 5555       EOR $55, X
f13e 00         BRK
f13f 00         BRK
f140 40         RTI
f141 5050       BVC f193
f143 5050       BVC f195
f145 5000       BVC f147
f147 00         BRK
f148 4455       JMP $55
f14a 5555       EOR $55, X
f14c 5555       EOR $55, X
f14e 00         BRK
f14f 00         BRK
f150 4455       JMP $55
f152 5555       EOR $55, X
f154 5555       EOR $55, X
f156 00         BRK
f157 00         BRK
f158 4455       JMP $55
f15a 5555       EOR $55, X
f15c 5555       EOR $55, X
f15e 00         BRK
f15f 00         BRK
f160 4455       JMP $55
f162 5555       EOR $55, X
f164 5555       EOR $55, X
f166 00         BRK
f167 00         BRK
f168 4455       JMP $55
f16a 5555       EOR $55, X
f16c 5555       EOR $55, X
f16e 00         BRK
f16f 00         BRK
f170 4455       JMP $55
f172 5555       EOR $55, X
f174 5555       EOR $55, X
f176 00         BRK
f177 00         BRK
f178 4455       JMP $55
f17a 5555       EOR $55, X
f17c 5555       EOR $55, X
f17e 00         BRK
f17f 00         BRK
f180 40         RTI
f181 5050       BVC f1d3
f183 5050       BVC f1d5
f185 5000       BVC f187
f187 00         BRK
f188 c8         INY
f189 db fa
f18a db fa
f18b db fa
f18c db fa
f18d db fa
f18e 00         BRK
f18f 00         BRK
f190 44a5       JMP $a5
f192 595ad5     EOR $d55a, Y
f195 7500       ADC $00, X
f197 00         BRK
f198 44a5       JMP $a5
f19a 5555       EOR $55, X
f19c 9565       STA $65, X
f19e 00         BRK
f19f 00         BRK
f1a0 4455       JMP $55
f1a2 5555       EOR $55, X
f1a4 5555       EOR $55, X
f1a6 00         BRK
f1a7 00         BRK
f1a8 4455       JMP $55
f1aa 5555       EOR $55, X
f1ac 5555       EOR $55, X
f1ae 00         BRK
f1af 00         BRK
f1b0 4455       JMP $55
f1b2 5555       EOR $55, X
f1b4 5555       EOR $55, X
f1b6 00         BRK
f1b7 00         BRK
f1b8 4455       JMP $55
f1ba 5555       EOR $55, X
f1bc 5555       EOR $55, X
f1be 00         BRK
f1bf 00         BRK
f1c0 40         RTI
f1c1 5050       BVC f213
f1c3 5050       BVC f215
f1c5 5000       BVC f1c7
f1c7 00         BRK
f1c8 4455       JMP $55
f1ca 5555       EOR $55, X
f1cc 5555       EOR $55, X
f1ce 00         BRK
f1cf 00         BRK
f1d0 4459       JMP $59
f1d2 db fa
f1d3 5655       LSR $55, X
f1d5 5500       EOR $00, X
f1d7 00         BRK
f1d8 4455       JMP $55
f1da 5555       EOR $55, X
f1dc 5555       EOR $55, X
f1de 00         BRK
f1df 00         BRK
f1e0 4455       JMP $55
f1e2 5555       EOR $55, X
f1e4 5555       EOR $55, X
f1e6 00         BRK
f1e7 00         BRK
f1e8 4455       JMP $55
f1ea 5555       EOR $55, X
f1ec 5555       EOR $55, X
f1ee 00         BRK
f1ef 00         BRK
f1f0 4455       JMP $55
f1f2 5555       EOR $55, X
f1f4 5555       EOR $55, X
f1f6 00         BRK
f1f7 00         BRK
f1f8 4455       JMP $55
f1fa 5555       EOR $55, X
f1fc 5555       EOR $55, X
f1fe 00         BRK
f1ff 00         BRK
f200 40         RTI
f201 5050       BVC f253
f203 5050       BVC f255
f205 5000       BVC f207
f207 00         BRK
f208 4455       JMP $55
f20a 5555       EOR $55, X
f20c 5555       EOR $55, X
f20e 00         BRK
f20f 00         BRK
f210 4455       JMP $55
f212 5555       EOR $55, X
f214 5555       EOR $55, X
f216 00         BRK
f217 00         BRK
f218 88         DEY
f219 aa         LDX
f21a aa         LDX
f21b aa         LDX
f21c aa         LDX
f21d aa         LDX
f21e 00         BRK
f21f 00         BRK
f220 4455       JMP $55
f222 5555       EOR $55, X
f224 5555       EOR $55, X
f226 00         BRK
f227 00         BRK
f228 4455       JMP $55
f22a 5555       EOR $55, X
f22c 5555       EOR $55, X
f22e 00         BRK
f22f 00         BRK
f230 4455       JMP $55
f232 5555       EOR $55, X
f234 5555       EOR $55, X
f236 00         BRK
f237 00         BRK
f238 4455       JMP $55
f23a 5555       EOR $55, X
f23c 5555       EOR $55, X
f23e 00         BRK
f23f 00         BRK
f240 40         RTI
f241 5050       BVC f293
f243 5050       BVC f295
f245 5000       BVC f247
f247 00         BRK
f248 4455       JMP $55
f24a 9595       STA $95, X
f24c 5555       EOR $55, X
f24e 00         BRK
f24f 00         BRK
f250 4459       JMP $59
f252 a6a5       LDX $a5
f254 6a         ROR
f255 5500       EOR $00, X
f257 00         BRK
f258 4455       JMP $55
f25a 5556       EOR $56, X
f25c 5555       EOR $55, X
f25e 00         BRK
f25f 00         BRK
f260 4455       JMP $55
f262 5555       EOR $55, X
f264 5555       EOR $55, X
f266 00         BRK
f267 00         BRK
f268 4455       JMP $55
f26a 5555       EOR $55, X
f26c 5555       EOR $55, X
f26e 00         BRK
f26f 00         BRK
f270 4455       JMP $55
f272 5555       EOR $55, X
f274 5555       EOR $55, X
f276 00         BRK
f277 00         BRK
f278 4455       JMP $55
f27a 5555       EOR $55, X
f27c 5555       EOR $55, X
f27e 00         BRK
f27f 00         BRK
f280 40         RTI
f281 5050       BVC f2d3
f283 5050       BVC f2d5
f285 5000       BVC f287
f287 00         BRK
f288 48         PHA
f289 db 5a
f28a 5655       LSR $55, X
f28c db 5a
f28d db 5a
f28e 00         BRK
f28f 00         BRK
f290 8caf67     STY $67af
f293 55af       EOR $af, X
f295 db af
f296 00         BRK
f297 00         BRK
f298 4c5f57     JMP $575f
f29b 555f       EOR $5f, X
f29d db 5f
f29e 00         BRK
f29f 00         BRK
f2a0 4455       JMP $55
f2a2 5555       EOR $55, X
f2a4 5555       EOR $55, X
f2a6 00         BRK
f2a7 00         BRK
f2a8 4455       JMP $55
f2aa 5555       EOR $55, X
f2ac 5555       EOR $55, X
f2ae 00         BRK
f2af 00         BRK
f2b0 4455       JMP $55
f2b2 5555       EOR $55, X
f2b4 5555       EOR $55, X
f2b6 00         BRK
f2b7 00         BRK
f2b8 4455       JMP $55
f2ba 5555       EOR $55, X
f2bc 5555       EOR $55, X
f2be 00         BRK
f2bf 00         BRK
f2c0 40         RTI
f2c1 5050       BVC f313
f2c3 5050       BVC f315
f2c5 5000       BVC f2c7
f2c7 00         BRK
f2c8 c495       CPY $95
f2ca 7555       ADC $55, X
f2cc 5555       EOR $55, X
f2ce 00         BRK
f2cf 00         BRK
f2d0 8c99ff     STY $ff99
f2d3 99f795     STA $95f7, Y
f2d6 00         BRK
f2d7 00         BRK
f2d8 4455       JMP $55
f2da 59599f     EOR $9f59, Y
f2dd 990000     STA $0000, Y
f2e0 4455       JMP $55
f2e2 5555       EOR $55, X
f2e4 5555       EOR $55, X
f2e6 00         BRK
f2e7 00         BRK
f2e8 4455       JMP $55
f2ea 5555       EOR $55, X
f2ec 5555       EOR $55, X
f2ee 00         BRK
f2ef 00         BRK
f2f0 4455       JMP $55
f2f2 5555       EOR $55, X
f2f4 5555       EOR $55, X
f2f6 00         BRK
f2f7 00         BRK
f2f8 4455       JMP $55
f2fa 5555       EOR $55, X
f2fc 5555       EOR $55, X
f2fe 00         BRK
f2ff 00         BRK
f300 40         RTI
f301 5050       BVC f353
f303 5050       BVC f355
f305 5000       BVC f307
f307 00         BRK
f308 48         PHA
f309 6559       ADC $59
f30b 6d7965     ADC $6579
f30e 00         BRK
f30f 00         BRK
f310 4c7965     JMP $6579
f313 596d79     EOR $796d, Y
f316 00         BRK
f317 00         BRK
f318 48         PHA
f319 6d7965     ADC $6579
f31c 596d00     EOR $006d, Y
f31f 00         BRK
f320 4459       JMP $59
f322 5d5955     EOR $5559, X
f325 590000     EOR $0000, Y
f328 4455       JMP $55
f32a 5555       EOR $55, X
f32c 5555       EOR $55, X
f32e 00         BRK
f32f 00         BRK
f330 4455       JMP $55
f332 5555       EOR $55, X
f334 5555       EOR $55, X
f336 00         BRK
f337 00         BRK
f338 4455       JMP $55
f33a 5555       EOR $55, X
f33c 5555       EOR $55, X
f33e 00         BRK
f33f 00         BRK
f340 40         RTI
f341 5050       BVC f393
f343 5050       BVC f395
f345 5000       BVC f347
f347 00         BRK
f348 4455       JMP $55
f34a 5555       EOR $55, X
f34c 5555       EOR $55, X
f34e 00         BRK
f34f 00         BRK
f350 4455       JMP $55
f352 55a5       EOR $a5, X
f354 a555       LDA $55
f356 00         BRK
f357 00         BRK
f358 44d5       JMP $d5
f35a f5f5       SBC $f5, X
f35c f555       SBC $55, X
f35e 00         BRK
f35f 00         BRK
f360 4455       JMP $55
f362 5555       EOR $55, X
f364 5555       EOR $55, X
f366 00         BRK
f367 00         BRK
f368 4455       JMP $55
f36a 5555       EOR $55, X
f36c 5555       EOR $55, X
f36e 00         BRK
f36f 00         BRK
f370 4455       JMP $55
f372 5555       EOR $55, X
f374 5555       EOR $55, X
f376 00         BRK
f377 00         BRK
f378 4455       JMP $55
f37a 5555       EOR $55, X
f37c 5555       EOR $55, X
f37e 00         BRK
f37f 00         BRK
f380 40         RTI
f381 5050       BVC f3d3
f383 5050       BVC f3d5
f385 5000       BVC f387
f387 00         BRK
f388 4455       JMP $55
f38a 5555       EOR $55, X
f38c 5555       EOR $55, X
f38e 00         BRK
f38f 00         BRK
f390 4455       JMP $55
f392 5555       EOR $55, X
f394 5555       EOR $55, X
f396 00         BRK
f397 00         BRK
f398 4455       JMP $55
f39a 5555       EOR $55, X
f39c 5555       EOR $55, X
f39e 00         BRK
f39f 00         BRK
f3a0 4455       JMP $55
f3a2 5555       EOR $55, X
f3a4 5555       EOR $55, X
f3a6 00         BRK
f3a7 00         BRK
f3a8 4455       JMP $55
f3aa 5555       EOR $55, X
f3ac 5555       EOR $55, X
f3ae 00         BRK
f3af 00         BRK
f3b0 4455       JMP $55
f3b2 5555       EOR $55, X
f3b4 5555       EOR $55, X
f3b6 00         BRK
f3b7 00         BRK
f3b8 4455       JMP $55
f3ba 5555       EOR $55, X
f3bc 5555       EOR $55, X
f3be 00         BRK
f3bf 00         BRK
f3c0 4cccf3     JMP $f3cc
f3c3 4c20f4     JMP $f420
f3c6 4c22f4     JMP $f422
f3c9 4c86f4     JMP $f486
f3cc a91f       LDA #$1f
f3ce 8d1540     STA $4015 ; Sound Switch
f3d1 a9c0       LDA #$c0
f3d3 8d1740     STA $4017 ; Joystick 2
f3d6 a9f0       LDA #$f0
f3d8 8d0040     STA $4000
f3db 8d0440     STA $4004
f3de 8d0c40     STA $400c
f3e1 a980       LDA #$80
f3e3 8d0840     STA $4008
f3e6 a978       LDA #$78
f3e8 8d0140     STA $4001
f3eb 8d0540     STA $4005
f3ee 8d0940     STA $4009
f3f1 8d0d40     STA $400d
f3f4 a9f0       LDA #$f0
f3f6 8d0240     STA $4002
f3f9 8d0640     STA $4006
f3fc 8d0a40     STA $400a
f3ff 8d0e40     STA $400e
f402 a908       LDA #$08
f404 8d0340     STA $4003
f407 8d0740     STA $4007
f40a 8d0b40     STA $400b
f40d 8d0f40     STA $400f
f410 a900       LDA #$00
f412 8d1040     STA $4010
f415 a203       LDX #$03
f417 a97c       LDA #$7c
f419 9d4a03     STA $034a, X
f41c ca         DEC
f41d 10fa       BPL f419
f41f 60         RTS
f420 a900       LDA #$00
f422 a2ff       LDX #$ff
f424 8e0003     STX $0300
f427 0a         ASL
f428 aa         LDX
f429 bdebf8     LDA $f8eb, X
f42c 85f3       STA $f3
f42e e8         INX
f42f bdebf8     LDA $f8eb, X
f432 85f4       STA $f4
f434 a000       LDY #$00
f436 b1f3       LDA ($f3), Y
f438 3046       BMI f480
f43a 85f5       STA $f5
f43c 0a         ASL
f43d 85f6       STA $f6
f43f b1f3       LDA ($f3), Y
f441 aa         LDX
f442 bda3f8     LDA $f8a3, X
f445 0d0103     ORA $0301
f448 8d0103     STA $0301
f44b a6f5       LDX $f5
f44d a900       LDA #$00
f44f 9d4603     STA $0346, X
f452 9d1a03     STA $031a, X
f455 9d3e03     STA $033e, X
f458 9d1603     STA $0316, X
f45b 9d4203     STA $0342, X
f45e 9d2603     STA $0326, X
f461 a6f6       LDX $f6
f463 c8         INY
f464 b1f3       LDA ($f3), Y
f466 9d2e03     STA $032e, X
f469 c8         INY
f46a b1f3       LDA ($f3), Y
f46c 9d2f03     STA $032f, X
f46f c8         INY
f470 a900       LDA #$00
f472 9d0203     STA $0302, X
f475 9d0303     STA $0303, X
f478 9d0a03     STA $030a, X
f47b 9d0b03     STA $030b, X
f47e f0b6       BEQ f436
f480 a200       LDX #$00
f482 8e0003     STX $0300
f485 60         RTS
f486 ad0003     LDA $0300
f489 d0fa       BNE f485
f48b a910       LDA #$10
f48d 85eb       STA $eb
f48f ad0103     LDA $0301
f492 a200       LDX #$00
f494 20         JSR
f495 9df48d     STA $8df4, X
f498 0103       ORA ($03, X)
f49a 4c92f6     JMP $f692
f49d 85e1       STA $e1
f49f a901       LDA #$01
f4a1 86e3       STX $e3
f4a3 85ea       STA $ea
f4a5 9d2203     STA $0322, X
f4a8 24e1       BIT $e1
f4aa f009       BEQ f4b5
f4ac 48         PHA
f4ad 8a         STX
f4ae 0a         ASL
f4af 85e2       STA $e2
f4b1 20         JSR
f4b2 c0f4       CPY #$f4
f4b4 68         PLA
f4b5 a6e3       LDX $e3
f4b7 e8         INX
f4b8 0a         ASL
f4b9 c5eb       CMP $eb
f4bb d0e4       BNE f4a1
f4bd a5e1       LDA $e1
f4bf 60         RTS
f4c0 bd4203     LDA $0342, X
f4c3 f008       BEQ f4cd
f4c5 de4203     DEC $0342, X
f4c8 f003       BEQ f4cd
f4ca 4cedf4     JMP $f4ed
f4cd a6e2       LDX $e2
f4cf bd2e03     LDA $032e, X
f4d2 85e4       STA $e4
f4d4 bd2f03     LDA $032f, X
f4d7 85e5       STA $e5
f4d9 a6e3       LDX $e3
f4db 20         JSR
f4dc eef420     INC $20f4 ; Sprite Memory Data
f4df 85f6       STA $f6
f4e1 a6e2       LDX $e2
f4e3 a5e4       LDA $e4
f4e5 9d2e03     STA $032e, X
f4e8 a5e5       LDA $e5
f4ea 9d2f03     STA $032f, X
f4ed 60         RTS
f4ee bd3e03     LDA $033e, X
f4f1 29df       AND #$df
f4f3 9d3e03     STA $033e, X
f4f6 a9ff       LDA #$ff
f4f8 9d2203     STA $0322, X
f4fb a000       LDY #$00
f4fd a6e3       LDX $e3
f4ff bd4203     LDA $0342, X
f502 d00b       BNE f50f
f504 b1e4       LDA ($e4), Y
f506 c8         INY
f507 0900       ORA #$00
f509 102c       BPL f537
f50b c9c0       CMP #$c0
f50d b001       BCS f510
f50f 60         RTS
f510 290f       AND #$0f
f512 0a         ASL
f513 85e6       STA $e6
f515 add1f7     LDA $f7d1
f518 65e6       ADC $e6
f51a 85e6       STA $e6
f51c add2f7     LDA $f7d2
f51f 6900       ADC #$00
f521 85e7       STA $e7
f523 98         TYA
f524 48         PHA
f525 a000       LDY #$00
f527 b1e6       LDA ($e6), Y
f529 48         PHA
f52a c8         INY
f52b b1e6       LDA ($e6), Y
f52d 85e7       STA $e7
f52f 68         PLA
f530 85e6       STA $e6
f532 68         PLA
f533 a8         TAY
f534 6ce600     JMP (ABS) $00e6
f537 48         PHA
f538 8a         STX
f539 2903       AND #$03
f53b c903       CMP #$03
f53d d004       BNE f543
f53f 68         PLA
f540 4c6ef5     JMP $f56e
f543 68         PLA
f544 c97c       CMP #$7c
f546 f026       BEQ f56e
f548 48         PHA
f549 290f       AND #$0f
f54b 85e6       STA $e6
f54d bd4603     LDA $0346, X
f550 290f       AND #$0f
f552 18         CLC
f553 65e6       ADC $e6
f555 291f       AND #$1f
f557 c90c       CMP #$0c
f559 9003       BCC f55e
f55b 18         CLC
f55c 6904       ADC #$04
f55e 85e6       STA $e6
f560 68         PLA
f561 29f0       AND #$f0
f563 65e6       ADC $e6
f565 85e6       STA $e6
f567 bd4603     LDA $0346, X
f56a 29f0       AND #$f0
f56c 65e6       ADC $e6
f56e 9d4a03     STA $034a, X
f571 a900       LDA #$00
f573 e008       CPX #$08
f575 d006       BNE f57d
f577 8d3303     STA $0333
f57a 8d2f03     STA $032f
f57d 9d2a03     STA $032a, X
f580 9d2603     STA $0326, X
f583 b1e4       LDA ($e4), Y
f585 c8         INY
f586 0900       ORA #$00
f588 1012       BPL f59c
f58a c9c0       CMP #$c0
f58c b00e       BCS f59c
f58e 293f       AND #$3f
f590 aa         LDX
f591 bdabf8     LDA $f8ab, X
f594 a6e3       LDX $e3
f596 9d1203     STA $0312, X
f599 4ca0f5     JMP $f5a0
f59c bd1203     LDA $0312, X
f59f 88         DEY
f5a0 9d4203     STA $0342, X
f5a3 4cfdf4     JMP $f4fd
f5a6 a900       LDA #$00
f5a8 9d2a03     STA $032a, X
f5ab 9d2603     STA $0326, X
f5ae b1e4       LDA ($e4), Y
f5b0 c8         INY
f5b1 0a         ASL
f5b2 aa         LDX
f5b3 bd0ff9     LDA $f90f, X
f5b6 48         PHA
f5b7 e8         INX
f5b8 bd0ff9     LDA $f90f, X
f5bb a6e2       LDX $e2
f5bd 9d3703     STA $0337, X
f5c0 68         PLA
f5c1 9d3603     STA $0336, X
f5c4 4cfdf4     JMP $f4fd
f5c7 b1e4       LDA ($e4), Y
f5c9 c8         INY
f5ca 9d1e03     STA $031e, X
f5cd bd3e03     LDA $033e, X
f5d0 0920       ORA #$20
f5d2 9d3e03     STA $033e, X
f5d5 b1e4       LDA ($e4), Y
f5d7 c8         INY
f5d8 4c37f5     JMP $f537
f5db b1e4       LDA ($e4), Y
f5dd c8         INY
f5de 29c0       AND #$c0
f5e0 85e6       STA $e6
f5e2 bd3e03     LDA $033e, X
f5e5 293f       AND #$3f
f5e7 05e6       ORA $e6
f5e9 9d3e03     STA $033e, X
f5ec 4cfdf4     JMP $f4fd
f5ef b1e4       LDA ($e4), Y
f5f1 c8         INY
f5f2 9d1a03     STA $031a, X
f5f5 4cfdf4     JMP $f4fd
f5f8 b1e4       LDA ($e4), Y
f5fa c8         INY
f5fb 9d4603     STA $0346, X
f5fe 4cfdf4     JMP $f4fd
f601 b1e4       LDA ($e4), Y
f603 c8         INY
f604 9d1603     STA $0316, X
f607 20         JSR
f608 85f6       STA $f6
f60a a6e2       LDX $e2
f60c a5e4       LDA $e4
f60e 9d0203     STA $0302, X
f611 a5e5       LDA $e5
f613 9d0303     STA $0303, X
f616 4cfdf4     JMP $f4fd
f619 b1e4       LDA ($e4), Y
f61b c8         INY
f61c 48         PHA
f61d b1e4       LDA ($e4), Y
f61f c8         INY
f620 85e5       STA $e5
f622 68         PLA
f623 85e4       STA $e4
f625 a000       LDY #$00
f627 4cfdf4     JMP $f4fd
f62a b1e4       LDA ($e4), Y
f62c c8         INY
f62d 48         PHA
f62e b1e4       LDA ($e4), Y
f630 c8         INY
f631 48         PHA
f632 20         JSR
f633 85f6       STA $f6
f635 a6e2       LDX $e2
f637 a5e4       LDA $e4
f639 9d0a03     STA $030a, X
f63c a5e5       LDA $e5
f63e 9d0b03     STA $030b, X
f641 68         PLA
f642 85e5       STA $e5
f644 68         PLA
f645 85e4       STA $e4
f647 4cfdf4     JMP $f4fd
f64a bd1603     LDA $0316, X
f64d f016       BEQ f665
f64f de1603     DEC $0316, X
f652 f00e       BEQ f662
f654 a6e2       LDX $e2
f656 bd0203     LDA $0302, X
f659 85e4       STA $e4
f65b bd0303     LDA $0303, X
f65e 85e5       STA $e5
f660 a000       LDY #$00
f662 4cfdf4     JMP $f4fd
f665 a6e2       LDX $e2
f667 bd0b03     LDA $030b, X
f66a f010       BEQ f67c
f66c 85e5       STA $e5
f66e bd0a03     LDA $030a, X
f671 85e4       STA $e4
f673 a900       LDA #$00
f675 9d0b03     STA $030b, X
f678 a8         TAY
f679 4cfdf4     JMP $f4fd
f67c a6e3       LDX $e3
f67e a5e1       LDA $e1
f680 45ea       EOR $ea
f682 85e1       STA $e1
f684 60         RTS
f685 98         TYA
f686 18         CLC
f687 65e4       ADC $e4
f689 85e4       STA $e4
f68b 9002       BCC f68f
f68d e6e5       INC $e5
f68f a000       LDY #$00
f691 60         RTS
f692 a900       LDA #$00
f694 85ef       STA $ef
f696 85f1       STA $f1
f698 a901       LDA #$01
f69a 85ea       STA $ea
f69c a5ea       LDA $ea
f69e 2d0103     AND $0301
f6a1 d003       BNE f6a6
f6a3 4c6ef7     JMP $f76e
f6a6 a6ef       LDX $ef
f6a8 a5ea       LDA $ea
f6aa c904       CMP #$04
f6ac f007       BEQ f6b5
f6ae bd3e03     LDA $033e, X
f6b1 2920       AND #$20
f6b3 d00c       BNE f6c1
f6b5 a078       LDY #$78
f6b7 bd4a03     LDA $034a, X
f6ba c97c       CMP #$7c
f6bc d006       BNE f6c4
f6be 4c6ef7     JMP $f76e
f6c1 bc1e03     LDY $031e, X
f6c4 84ec       STY $ec
f6c6 20         JSR
f6c7 84f7       STY $f7
f6c9 9033       BCC f6fe
f6cb a5ea       LDA $ea
f6cd c904       CMP #$04
f6cf d00c       BNE f6dd
f6d1 b1e6       LDA ($e6), Y
f6d3 85eb       STA $eb
f6d5 a9ff       LDA #$ff
f6d7 9d2203     STA $0322, X
f6da 4cfef6     JMP $f6fe
f6dd b1e6       LDA ($e6), Y
f6df 38         SEC
f6e0 fd1a03     SBC $031a, X
f6e3 b002       BCS f6e7
f6e5 a900       LDA #$00
f6e7 290f       AND #$0f
f6e9 0910       ORA #$10
f6eb 85e8       STA $e8
f6ed bd3e03     LDA $033e, X
f6f0 29f0       AND #$f0
f6f2 05e8       ORA $e8
f6f4 9d3e03     STA $033e, X
f6f7 0920       ORA #$20
f6f9 a4f1       LDY $f1
f6fb 990040     STA $4000, Y
f6fe a5ea       LDA $ea
f700 c904       CMP #$04
f702 f022       BEQ f726
f704 bd3e03     LDA $033e, X
f707 0920       ORA #$20
f709 85eb       STA $eb
f70b a5ea       LDA $ea
f70d c908       CMP #$08
f70f d00b       BNE f71c
f711 bd4a03     LDA $034a, X
f714 290f       AND #$0f
f716 85ed       STA $ed
f718 a918       LDA #$18
f71a d018       BNE f734
f71c bd4a03     LDA $034a, X
f71f c97f       CMP #$7f
f721 d003       BNE f726
f723 4c59f7     JMP $f759
f726 20         JSR
f727 b8         CLV
f728 db f7
f729 b9fbf7     LDA $f7fb, Y
f72c 85ed       STA $ed
f72e c8         INY
f72f b9fbf7     LDA $f7fb, Y
f732 0908       ORA #$08
f734 85ee       STA $ee
f736 bd2203     LDA $0322, X
f739 1010       BPL f74b
f73b a6f1       LDX $f1
f73d a000       LDY #$00
f73f b9eb00     LDA $00eb, Y
f742 9d0040     STA $4000, X
f745 e8         INX
f746 c8         INY
f747 c004       CPY #$04
f749 d0f4       BNE f73f
f74b a6ef       LDX $ef
f74d bd3e03     LDA $033e, X
f750 2920       AND #$20
f752 f005       BEQ f759
f754 a97f       LDA #$7f
f756 9d4a03     STA $034a, X
f759 a5f1       LDA $f1
f75b 18         CLC
f75c 6904       ADC #$04
f75e 85f1       STA $f1
f760 e6ef       INC $ef
f762 06ea       ASL $ea
f764 a5ea       LDA $ea
f766 c910       CMP #$10
f768 f003       BEQ f76d
f76a 4c9cf6     JMP $f69c
f76d 60         RTS
f76e a5ea       LDA $ea
f770 c904       CMP #$04
f772 d007       BNE f77b
f774 a980       LDA #$80
f776 8d0840     STA $4008
f779 d0de       BNE f759
f77b a4f1       LDY $f1
f77d a9f0       LDA #$f0
f77f 990040     STA $4000, Y
f782 d0d5       BNE f759
f784 bd2603     LDA $0326, X
f787 f005       BEQ f78e
f789 de2603     DEC $0326, X
f78c 18         CLC
f78d 60         RTS
f78e 8a         STX
f78f 0a         ASL
f790 aa         LDX
f791 bd3603     LDA $0336, X
f794 85e6       STA $e6
f796 bd3703     LDA $0337, X
f799 85e7       STA $e7
f79b a6ef       LDX $ef
f79d bc2a03     LDY $032a, X
f7a0 b1e6       LDA ($e6), Y
f7a2 d004       BNE f7a8
f7a4 9d2a03     STA $032a, X
f7a7 a8         TAY
f7a8 fe2a03     INC $032a, X
f7ab fe2a03     INC $032a, X
f7ae b1e6       LDA ($e6), Y
f7b0 9d2603     STA $0326, X
f7b3 c8         INY
f7b4 b1e6       LDA ($e6), Y
f7b6 38         SEC
f7b7 60         RTS
f7b8 bd4a03     LDA $034a, X
f7bb 4a         LSR
f7bc 4a         LSR
f7bd 4a         LSR
f7be 4a         LSR
f7bf 290f       AND #$0f
f7c1 a8         TAY
f7c2 b9f3f7     LDA $f7f3, Y
f7c5 85e0       STA $e0
f7c7 bd4a03     LDA $034a, X
f7ca 290f       AND #$0f
f7cc 0a         ASL
f7cd 65e0       ADC $e0
f7cf a8         TAY
f7d0 60         RTS
f7d1 db d3
f7d2 db f7
f7d3 a6f5       LDX $f5
f7d5 db c7
f7d6 f5db       SBC $db, X
f7d8 f5ef       SBC $ef, X
f7da f5f8       SBC $f8, X
f7dc f54a       SBC $4a, X
f7de f64a       INC $4a, X
f7e0 f64a       INC $4a, X
f7e2 f601       INC $01, X
f7e4 f619       INC $19, X
f7e6 f62a       INC $2a, X
f7e8 f64a       INC $4a, X
f7ea f64a       INC $4a, X
f7ec f64a       INC $4a, X
f7ee f64a       INC $4a, X
f7f0 f64a       INC $4a, X
f7f2 f600       INC $00, X
f7f4 18         CLC
f7f5 3048       BMI f83f
f7f7 60         RTS
f7f8 78         SEI
f7f9 90a8       BCC f7a3
f7fb ae064e     LDX $4e06
f7fe 06f4       ASL $f4
f800 059e       ORA $9e
f802 054d       ORA $4d
f804 0501       ORA $01
f806 05b9       ORA $b9
f808 db 04
f809 7504       ADC $04, X
f80b 3504       AND $04, X
f80d f903c0     SBC $c003, Y
f810 db 03
f811 8a         STX
f812 db 03
f813 db 57
f814 db 03
f815 db 27
f816 db 03
f817 db fa
f818 02cf       ASL #$cf
f81a 02a7       ASL #$a7
f81c 0281       ASL #$81
f81e 025d       ASL #$5d
f820 023b       ASL #$3b
f822 021b       ASL #$1b
f824 02fc       ASL #$fc
f826 01e0       ORA ($e0, X)
f828 01c5       ORA ($c5, X)
f82a 01ac       ORA ($ac, X)
f82c 0194       ORA ($94, X)
f82e 017d       ORA ($7d, X)
f830 0168       ORA ($68, X)
f832 0153       ORA ($53, X)
f834 0140       ORA ($40, X)
f836 012e       ORA ($2e, X)
f838 011d       ORA ($1d, X)
f83a 010d       ORA ($0d, X)
f83c 01fe       ORA ($fe, X)
f83e 00         BRK
f83f f000       BEQ f841
f841 e200       INC #$00
f843 d600       DEC $00, X
f845 ca         DEC
f846 00         BRK
f847 be00b4     LDX $b400, X
f84a 00         BRK
f84b aa         LDX
f84c 00         BRK
f84d a000       LDY #$00
f84f db 97
f850 00         BRK
f851 db 8f
f852 00         BRK
f853 db 87
f854 00         BRK
f855 db 7f
f856 00         BRK
f857 78         SEI
f858 00         BRK
f859 7100       ADC ($00), Y
f85b db 6b
f85c 00         BRK
f85d 6500       ADC $00
f85f db 5f
f860 00         BRK
f861 db 5a
f862 00         BRK
f863 5500       EOR $00, X
f865 5000       BVC f867
f867 4c0047     JMP $4700
f86a 00         BRK
f86b db 43
f86c 00         BRK
f86d 40         RTI
f86e 00         BRK
f86f 3c0039     BIT $3900, X
f872 00         BRK
f873 3500       AND $00, X
f875 db 32
f876 00         BRK
f877 3000       BMI f879
f879 2d002a     AND $2a00 ; PPU Control Register 1
f87c 00         BRK
f87d 28         PLP
f87e 00         BRK
f87f 2600       ROL $00
f881 2400       BIT $00
f883 2200       ROL #$00
f885 20         JSR
f886 00         BRK
f887 1e001c     ASL $1c00, X
f88a 00         BRK
f88b db 1b
f88c 00         BRK
f88d 190018     ORA $1800, Y
f890 00         BRK
f891 1600       ASL $00, X
f893 1500       ORA $00, X
f895 db 14
f896 00         BRK
f897 db 13
f898 00         BRK
f899 db 12
f89a 00         BRK
f89b 1100       ORA ($00), Y
f89d 1000       BPL f89f
f89f db 0f
f8a0 00         BRK
f8a1 0e0001     ASL $0100
f8a4 0204       ASL #$04
f8a6 08         PHP
f8a7 1020       BPL f8c9
f8a9 40         RTI
f8aa 8001       STY #$01
f8ac 0203       ASL #$03
f8ae db 04
f8af 0609       ASL $09
f8b1 db 0c
f8b2 db 12
f8b3 18         CLC
f8b4 2430       BIT $30
f8b6 48         PHA
f8b7 60         RTS
f8b8 90c0       BCC f87a
f8ba db 14
f8bb db 07
f8bc 0200       ASL #$00
f8be db 03
f8bf 0500       ORA $00
f8c1 0a         ASL
f8c2 db 0f
f8c3 db 14
f8c4 1e283c     ASL $3c28, X
f8c7 5078       BVC f941
f8c9 a000       LDY #$00
f8cb 00         BRK
f8cc 0204       ASL #$04
f8ce 0608       ASL $08
f8d0 db 0c
f8d1 1018       BPL f8eb
f8d3 20         JSR
f8d4 3040       BMI f916
f8d6 60         RTS
f8d7 80c0       STY #$c0
f8d9 f000       BEQ f8db
f8db db 1c
f8dc 00         BRK
f8dd 00         BRK
f8de 00         BRK
f8df 0900       ORA #$00
f8e1 db 12
f8e2 db 1b
f8e3 2436       BIT $36
f8e5 48         PHA
f8e6 6c90d8     JMP (ABS) $d890
f8e9 00         BRK
f8ea 00         BRK
f8eb db 13
f8ec db fa
f8ed 20         JSR
f8ee db fa
f8ef 2dfa3a     AND $3afa ; PPU Status Register
f8f2 db fa
f8f3 db 47
f8f4 db fa
f8f5 54fa       JMP $fa, X
f8f7 db 92
f8f8 db fa
f8f9 ecfa99     CPX $99fa
f8fc db fb
f8fd db bf
f8fe db fb
f8ff db d3
f900 db fb
f901 f9fb15     SBC $15fb, Y
f904 fc8dfc     CPX $fc8d, X
f907 e5fc       SBC $fc
f909 0a         ASL
f90a fd35fd     SBC $fd35, X
f90d cefd25     DEC $25fd ; Background Scroll
f910 f927f9     SBC $f927, Y
f913 29f9       AND #$f9
f915 59f983     EOR $83f9, Y
f918 f9a3f9     SBC $f9a3, Y
f91b db bb
f91c f9bff9     SBC $f9bf, Y
f91f ddf9ef     CMP $eff9, X
f922 f9f3f9     SBC $f9f3, Y
f925 db ff
f926 db 0f
f927 db ff
f928 db ff
f929 010f       ORA ($0f, X)
f92b 0100       ORA ($00, X)
f92d 010d       ORA ($0d, X)
f92f 0100       ORA ($00, X)
f931 010b       ORA ($0b, X)
f933 0100       ORA ($00, X)
f935 0109       ORA ($09, X)
f937 0100       ORA ($00, X)
f939 0107       ORA ($07, X)
f93b 0100       ORA ($00, X)
f93d 0106       ORA ($06, X)
f93f 0100       ORA ($00, X)
f941 0105       ORA ($05, X)
f943 0100       ORA ($00, X)
f945 0104       ORA ($04, X)
f947 0100       ORA ($00, X)
f949 0103       ORA ($03, X)
f94b 0100       ORA ($00, X)
f94d 0102       ORA ($02, X)
f94f 0100       ORA ($00, X)
f951 0101       ORA ($01, X)
f953 0100       ORA ($00, X)
f955 0101       ORA ($01, X)
f957 db ff
f958 00         BRK
f959 010c       ORA ($0c, X)
f95b db 03
f95c db 0f
f95d 010d       ORA ($0d, X)
f95f 010b       ORA ($0b, X)
f961 0109       ORA ($09, X)
f963 0107       ORA ($07, X)
f965 0105       ORA ($05, X)
f967 0103       ORA ($03, X)
f969 0101       ORA ($01, X)
f96b 0108       ORA ($08, X)
f96d 020a       ASL #$0a
f96f 0109       ORA ($09, X)
f971 0108       ORA ($08, X)
f973 0107       ORA ($07, X)
f975 0106       ORA ($06, X)
f977 0205       ASL #$05
f979 0204       ASL #$04
f97b 0203       ASL #$03
f97d 0202       ASL #$02
f97f 0201       ASL #$01
f981 db ff
f982 00         BRK
f983 020f       ASL #$0f
f985 010e       ORA ($0e, X)
f987 010d       ORA ($0d, X)
f989 010c       ORA ($0c, X)
f98b 020b       ASL #$0b
f98d 020a       ASL #$0a
f98f 0209       ASL #$09
f991 0208       ASL #$08
f993 db 03
f994 db 07
f995 db 03
f996 0603       ASL $03
f998 0503       ORA $03
f99a db 04
f99b db 03
f99c db 03
f99d db 03
f99e 0203       ASL #$03
f9a0 01ff       ORA ($ff, X)
f9a2 00         BRK
f9a3 db 03
f9a4 db 0f
f9a5 db 07
f9a6 00         BRK
f9a7 0106       ORA ($06, X)
f9a9 0208       ASL #$08
f9ab 0107       ORA ($07, X)
f9ad 0106       ORA ($06, X)
f9af 0105       ORA ($05, X)
f9b1 0204       ASL #$04
f9b3 0203       ASL #$03
f9b5 0202       ASL #$02
f9b7 0201       ASL #$01
f9b9 db ff
f9ba 00         BRK
f9bb 010c       ORA ($0c, X)
f9bd db ff
f9be db 0f
f9bf 010c       ORA ($0c, X)
f9c1 020f       ASL #$0f
f9c3 010d       ORA ($0d, X)
f9c5 010b       ORA ($0b, X)
f9c7 010a       ORA ($0a, X)
f9c9 0109       ORA ($09, X)
f9cb 0108       ORA ($08, X)
f9cd 0107       ORA ($07, X)
f9cf 0106       ORA ($06, X)
f9d1 0105       ORA ($05, X)
f9d3 0104       ORA ($04, X)
f9d5 0103       ORA ($03, X)
f9d7 0102       ORA ($02, X)
f9d9 0101       ORA ($01, X)
f9db db ff
f9dc 00         BRK
f9dd 010f       ORA ($0f, X)
f9df 010d       ORA ($0d, X)
f9e1 010b       ORA ($0b, X)
f9e3 0109       ORA ($09, X)
f9e5 0107       ORA ($07, X)
f9e7 0105       ORA ($05, X)
f9e9 0103       ORA ($03, X)
f9eb 0101       ORA ($01, X)
f9ed db ff
f9ee 00         BRK
f9ef 010f       ORA ($0f, X)
f9f1 db ff
f9f2 00         BRK
f9f3 08         PHP
f9f4 db 0f
f9f5 08         PHP
f9f6 0e080d     ASL $0d08
f9f9 08         PHP
f9fa db 0c
f9fb 08         PHP
f9fc db 0b
f9fd 08         PHP
f9fe 0a         ASL
f9ff 08         PHP
fa00 0908       ORA #$08
fa02 08         PHP
fa03 08         PHP
fa04 db 07
fa05 08         PHP
fa06 0608       ASL $08
fa08 0508       ORA $08
fa0a db 04
fa0b 08         PHP
fa0c db 03
fa0d 08         PHP
fa0e 0208       ASL #$08
fa10 01ff       ORA ($ff, X)
fa12 00         BRK
fa13 00         BRK
fa14 db 1f
fa15 db fa
fa16 011f       ORA ($1f, X)
fa18 db fa
fa19 021f       ASL #$1f
fa1b db fa
fa1c db 03
fa1d db 1f
fa1e db fa
fa1f db ff
fa20 00         BRK
fa21 24fa       BIT $fa
fa23 db ff
fa24 f002       BEQ fa28
fa26 db f2
fa27 80f3       STY #$f3
fa29 00         BRK
fa2a 308a       BMI f9b6
fa2c db ff
fa2d 00         BRK
fa2e 31fa       AND ($fa), Y
fa30 db ff
fa31 f002       BEQ fa35
fa33 db f2
fa34 80f3       STY #$f3
fa36 00         BRK
fa37 db 37
fa38 8a         STX
fa39 db ff
fa3a 00         BRK
fa3b 3efaff     ROL $fffa, X
fa3e f002       BEQ fa42
fa40 db f2
fa41 80f3       STY #$f3
fa43 00         BRK
fa44 508a       BVC f9d0
fa46 db ff
fa47 00         BRK
fa48 db 4b
fa49 db fa
fa4a db ff
fa4b f000       BEQ fa4d
fa4d db f2
fa4e 80f3       STY #$f3
fa50 00         BRK
fa51 3081       BMI f9d4
fa53 db ff
fa54 00         BRK
fa55 5efa01     LSR $01fa, X
fa58 8dfa02     STA $02fa
fa5b db 1f
fa5c db fa
fa5d db ff
fa5e f000       BEQ fa60
fa60 db f2
fa61 80f3       STY #$f3
fa63 00         BRK
fa64 db fa
fa65 86fa       STX $fa
fa67 db f3
fa68 db 04
fa69 db fa
fa6a 86fa       STX $fa
fa6c db f3
fa6d 06fa       ASL $fa
fa6f 86fa       STX $fa
fa71 db f3
fa72 08         PHP
fa73 db fa
fa74 86fa       STX $fa
fa76 db f3
fa77 0a         ASL
fa78 db fa
fa79 86fa       STX $fa
fa7b db f3
fa7c db 0c
fa7d db fa
fa7e 86fa       STX $fa
fa80 db f3
fa81 0efa86     ASL $86fa
fa84 db fa
fa85 db ff
fa86 f182       SBC ($82), Y
fa88 28         PLP
fa89 907c       BCC fb07
fa8b 81ff       STA ($ff, X)
fa8d f401       CPX $01, X
fa8f f95efa     SBC $fa5e, Y
fa92 00         BRK
fa93 99fa01     STA $01fa, Y
fa96 db 9b
fa97 db fa
fa98 db ff
fa99 f4fb       CPX $fb, X
fa9b f000       BEQ fa9d
fa9d db f2
fa9e 40         RTI
fa9f db f3
faa0 00         BRK
faa1 f18f       SBC ($8f), Y
faa3 5081       BVC fa26
faa5 db f3
faa6 01f1       ORA ($f1, X)
faa8 db 87
faa9 51f3       EOR ($f3), Y
faab 02f1       ASL #$f1
faad db 8f
faae 50f3       BVC faa3
fab0 db 03
fab1 f187       SBC ($87), Y
fab3 51f3       EOR ($f3), Y
fab5 db 04
fab6 f18f       SBC ($8f), Y
fab8 50f3       BVC faad
faba 05f1       ORA $f1
fabc db 87
fabd 51f3       EOR ($f3), Y
fabf 06f1       ASL $f1
fac1 db 8f
fac2 50f3       BVC fab7
fac4 db 07
fac5 f187       SBC ($87), Y
fac7 51f3       EOR ($f3), Y
fac9 08         PHP
faca f18f       SBC ($8f), Y
facc 50f3       BVC fac1
face 09f1       ORA #$f1
fad0 db 87
fad1 51f3       EOR ($f3), Y
fad3 0a         ASL
fad4 f18f       SBC ($8f), Y
fad6 50f3       BVC facb
fad8 db 0b
fad9 f187       SBC ($87), Y
fadb 51f3       EOR ($f3), Y
fadd db 0c
fade f18f       SBC ($8f), Y
fae0 50f3       BVC fad5
fae2 0df187     ORA $87f1
fae5 51f3       EOR ($f3), Y
fae7 0ef18f     ASL $8ff1
faea 50ff       BVC faeb
faec 00         BRK
faed db f3
faee db fa
faef 01f5       ORA ($f5, X)
faf1 db fa
faf2 db ff
faf3 f4fb       CPX $fb, X
faf5 f000       BEQ faf7
faf7 db f2
faf8 40         RTI
faf9 db f3
fafa 0efa8b     ASL $8bfa
fafd db fb
fafe db f3
faff 0dfa8b     ORA $8bfa
fb02 db fb
fb03 db f3
fb04 db 0c
fb05 db fa
fb06 db 8b
fb07 db fb
fb08 db f3
fb09 db 0b
fb0a db fa
fb0b db 8b
fb0c db fb
fb0d db f3
fb0e 0a         ASL
fb0f db fa
fb10 db 8b
fb11 db fb
fb12 db f3
fb13 09fa       ORA #$fa
fb15 db 8b
fb16 db fb
fb17 db f3
fb18 08         PHP
fb19 db fa
fb1a db 8b
fb1b db fb
fb1c db f3
fb1d db 07
fb1e db fa
fb1f db 8b
fb20 db fb
fb21 db f3
fb22 06fa       ASL $fa
fb24 db 8b
fb25 db fb
fb26 db f3
fb27 05fa       ORA $fa
fb29 db 8b
fb2a db fb
fb2b db f3
fb2c db 04
fb2d db fa
fb2e db 8b
fb2f db fb
fb30 db f3
fb31 db 03
fb32 db fa
fb33 db 8b
fb34 db fb
fb35 db f3
fb36 02fa       ASL #$fa
fb38 db 8b
fb39 db fb
fb3a db f3
fb3b 01fa       ORA ($fa, X)
fb3d db 8b
fb3e db fb
fb3f db f3
fb40 00         BRK
fb41 db fa
fb42 db 8b
fb43 db fb
fb44 db f3
fb45 01fa       ORA ($fa, X)
fb47 db 8b
fb48 db fb
fb49 db f3
fb4a 02fa       ASL #$fa
fb4c db 8b
fb4d db fb
fb4e db f3
fb4f db 03
fb50 db fa
fb51 db 8b
fb52 db fb
fb53 db f3
fb54 db 04
fb55 db fa
fb56 db 8b
fb57 db fb
fb58 db f3
fb59 05fa       ORA $fa
fb5b db 8b
fb5c db fb
fb5d db f3
fb5e 06fa       ASL $fa
fb60 db 8b
fb61 db fb
fb62 db f3
fb63 db 07
fb64 db fa
fb65 db 8b
fb66 db fb
fb67 db f3
fb68 08         PHP
fb69 db fa
fb6a db 8b
fb6b db fb
fb6c db f3
fb6d 09fa       ORA #$fa
fb6f db 8b
fb70 db fb
fb71 db f3
fb72 0a         ASL
fb73 db fa
fb74 db 8b
fb75 db fb
fb76 db f3
fb77 db 0b
fb78 db fa
fb79 db 8b
fb7a db fb
fb7b db f3
fb7c db 0c
fb7d db fa
fb7e db 8b
fb7f db fb
fb80 db f3
fb81 0dfa8b     ORA $8bfa
fb84 db fb
fb85 db f3
fb86 0efa8b     ASL $8bfa
fb89 db fb
fb8a db ff
fb8b f18f       SBC ($8f), Y
fb8d 5081       BVC fb10
fb8f f187       SBC ($87), Y
fb91 51f1       EOR ($f1), Y
fb93 db 8f
fb94 50f1       BVC fb87
fb96 db 87
fb97 51ff       EOR ($ff), Y
fb99 02a0       ASL #$a0
fb9b db fb
fb9c 01b4       ORA ($b4, X)
fb9e db fb
fb9f db ff
fba0 f001       BEQ fba3
fba2 f400       CPX $00, X
fba4 1081       BPL fb27
fba6 1112       ORA ($12), Y
fba8 db 13
fba9 db 14
fbaa 1516       ORA $16, X
fbac db 17
fbad 191a1b     ORA $1b1a, Y
fbb0 20         JSR
fbb1 2122       AND ($22, X)
fbb3 db ff
fbb4 f000       BEQ fbb6
fbb6 db f2
fbb7 80f3       STY #$f3
fbb9 08         PHP
fbba f18f       SBC ($8f), Y
fbbc 00         BRK
fbbd b0ff       BCS fbbe
fbbf 00         BRK
fbc0 c6fb       DEC $fb
fbc2 01c8       ORA ($c8, X)
fbc4 db fb
fbc5 db ff
fbc6 f401       CPX $01, X
fbc8 f00a       BEQ fbd4
fbca db f2
fbcb 80f3       STY #$f3
fbcd 00         BRK
fbce f183       SBC ($83), Y
fbd0 2286       ROL #$86
fbd2 db ff
fbd3 00         BRK
fbd4 db da
fbd5 db fb
fbd6 01dc       ORA ($dc, X)
fbd8 db fb
fbd9 db ff
fbda f401       CPX $01, X
fbdc f000       BEQ fbde
fbde db f2
fbdf 80f3       STY #$f3
fbe1 00         BRK
fbe2 f183       SBC ($83), Y
fbe4 3083       BMI fb69
fbe6 7c81f3     JMP (ABS) $f381, X
fbe9 06f1       ASL $f1
fbeb db 83
fbec 3083       BMI fb71
fbee 7c81f3     JMP (ABS) $f381, X
fbf1 0a         ASL
fbf2 f183       SBC ($83), Y
fbf4 3083       BMI fb79
fbf6 7c81ff     JMP (ABS) $ff81, X
fbf9 00         BRK
fbfa 00         BRK
fbfb fc0102     CPX $0201, X
fbfe fcfff4     CPX $f4ff, X
fc01 db fb
fc02 f000       BEQ fc04
fc04 db f2
fc05 80f3       STY #$f3
fc07 00         BRK
fc08 f186       SBC ($86), Y
fc0a 248b       BIT $8b
fc0c f00a       BEQ fc18
fc0e db f3
fc0f 08         PHP
fc10 f18f       SBC ($8f), Y
fc12 05ae       ORA $ae
fc14 db ff
fc15 00         BRK
fc16 db 1f
fc17 fc0146     CPX $4601, X
fc1a fc026d     CPX $6d02, X
fc1d fcfff0     CPX $f0ff, X
fc20 db 03
fc21 db f2
fc22 80f3       STY #$f3
fc24 06f4       ASL $f4
fc26 00         BRK
fc27 20         JSR
fc28 867c       STX $7c
fc2a 8120       STA ($20, X)
fc2c 8427       STY $27
fc2e db 9a
fc2f 2690       ROL $90
fc31 db 27
fc32 2984       AND #$84
fc34 db 27
fc35 9c2086     STY $8620, X
fc38 7c8120     JMP (ABS) $2081, X
fc3b 8427       STY $27
fc3d db 9a
fc3e 2994       AND #$94
fc40 db 27
fc41 2629       ROL $29
fc43 db 27
fc44 9cfff0     STY $f0ff, X
fc47 db 03
fc48 db f2
fc49 80f3       STY #$f3
fc4b 06f4       ASL $f4
fc4d 00         BRK
fc4e db 17
fc4f 867c       STX $7c
fc51 8117       STA ($17, X)
fc53 8420       STY $20
fc55 db 9a
fc56 db 23
fc57 9024       BCC fc7d
fc59 2584       AND $84
fc5b 249c       BIT $9c
fc5d db 17
fc5e 867c       STX $7c
fc60 8117       STA ($17, X)
fc62 8420       STY $20
fc64 db 9a
fc65 2594       AND $94
fc67 2423       BIT $23
fc69 2524       AND $24
fc6b 9cfff0     STY $f0ff, X
fc6e 01f4       ORA ($f4, X)
fc70 00         BRK
fc71 f8         SED
fc72 db 03
fc73 20         JSR
fc74 967c       STX $7c, X
fc76 db 17
fc77 7cff20     JMP (ABS) $20ff, X
fc7a 947c       STY $7c, X
fc7c db 17
fc7d 7c197c     JMP (ABS) $7c19, X
fc80 db 1b
fc81 7c2096     JMP (ABS) $9620, X
fc84 7c177c     JMP (ABS) $7c17, X
fc87 20         JSR
fc88 7c177c     JMP (ABS) $7c17, X
fc8b 20         JSR
fc8c db ff
fc8d 00         BRK
fc8e db 97
fc8f fc01ad     CPX $ad01, X
fc92 fc02c3     CPX $c302, X
fc95 fcfff0     CPX $f0ff, X
fc98 db 03
fc99 db f2
fc9a 80f3       STY #$f3
fc9c 0627       ASL $27
fc9e 867c       STX $7c
fca0 8127       STA ($27, X)
fca2 842a       STY $2a
fca4 db 9a
fca5 2996       AND #$96
fca7 db 27
fca8 2529       AND $29
fcaa db 27
fcab db 9b
fcac db ff
fcad f003       BEQ fcb2
fcaf db f2
fcb0 80f3       STY #$f3
fcb2 0620       ASL $20
fcb4 867c       STX $7c
fcb6 8120       STA ($20, X)
fcb8 8427       STY $27
fcba db 9a
fcbb 2596       AND $96
fcbd 2220       ROL #$20
fcbf 2520       AND $20
fcc1 db 9b
fcc2 db ff
fcc3 7c98f0     JMP (ABS) $f098, X
fcc6 0124       ORA ($24, X)
fcc8 847c       STY $7c
fcca 8024       STY #$24
fccc 847c       STY $7c
fcce 8024       STY #$24
fcd0 947c       STY $7c, X
fcd2 8024       STY #$24
fcd4 967c       STX $7c, X
fcd6 257c       AND $7c
fcd8 297c       AND #$7c
fcda 3094       BMI fc70
fcdc 7c277c     JMP (ABS) $7c27, X
fcdf 307c       BMI fd5d
fce1 db 27
fce2 7c30ff     JMP (ABS) $ff30, X
fce5 00         BRK
fce6 db ef
fce7 fc0100     CPX $0001, X
fcea fd0209     SBC $0902, X
fced fdff7c     SBC $7cff, X
fcf0 94f0       STY $f0, X
fcf2 db 03
fcf3 db f2
fcf4 80f3       STY #$f3
fcf6 0627       ASL $27
fcf8 9031       BCC fd2b
fcfa db 32
fcfb 3637       ROL $37, X
fcfd db 3b
fcfe 42ff       LSR #$ff
fd00 f000       BEQ fd02
fd02 db f2
fd03 80f3       STY #$f3
fd05 02f9       ASL #$f9
fd07 db f7
fd08 fcff00     CPX $00ff, X
fd0b db 14
fd0c fd011d     SBC $1d01, X
fd0f fd021f     SBC $1f02, X
fd12 db fa
fd13 db ff
fd14 7ca4f2     JMP (ABS) $f2a4, X
fd17 80f3       STY #$f3
fd19 06f9       ASL $f9
fd1b db 23
fd1c fdf000     SBC $00f0, X
fd1f db f2
fd20 80f3       STY #$f3
fd22 022a       ASL #$2a
fd24 a426       LDY $26
fd26 db 27
fd27 2225       ROL #$25
fd29 2122       AND ($22, X)
fd2b db 1a
fd2c db 17
fd2d a27c       LDX #$7c
fd2f db 17
fd30 7c177c     JMP (ABS) $7c17, X
fd33 db 17
fd34 db ff
fd35 00         BRK
fd36 db 3f
fd37 fd0175     SBC $7501, X
fd3a fd02b4     SBC $b402, X
fd3d fdfff0     SBC $f0ff, X
fd40 db 04
fd41 db f2
fd42 40         RTI
fd43 db f3
fd44 0627       ASL $27
fd46 9626       STX $26, X
fd48 db 23
fd49 2598       AND $98
fd4b 2696       ROL $96
fd4d db 27
fd4e 98         TYA
fd4f 2696       ROL $96
fd51 2698       ROL $98
fd53 2696       ROL $96
fd55 2698       ROL $98
fd57 2696       ROL $96
fd59 2698       ROL $98
fd5b db f2
fd5c 8036       STY #$36
fd5e 9433       STY $33, X
fd60 3029       BMI fd8b
fd62 2623       ROL $23
fd64 20         JSR
fd65 191619     ORA $1916, Y
fd68 20         JSR
fd69 db 23
fd6a 2629       ROL $29
fd6c 3033       BMI fda1
fd6e db f2
fd6f 40         RTI
fd70 2694       ROL $94
fd72 269a       ROL $9a
fd74 db ff
fd75 f004       BEQ fd7b
fd77 db f2
fd78 40         RTI
fd79 db f3
fd7a 061b       ASL $1b
fd7c 961b       STX $1b, X
fd7e db 1b
fd7f db 1b
fd80 98         TYA
fd81 db 1b
fd82 961b       STX $1b, X
fd84 98         TYA
fd85 db 1b
fd86 961b       STX $1b, X
fd88 98         TYA
fd89 db 1b
fd8a 961b       STX $1b, X
fd8c 98         TYA
fd8d db 1b
fd8e 961b       STX $1b, X
fd90 98         TYA
fd91 f003       BEQ fd96
fd93 db f2
fd94 80f3       STY #$f3
fd96 0a         ASL
fd97 7c9436     JMP (ABS) $3694, X
fd9a 9433       STY $33, X
fd9c 3029       BMI fdc7
fd9e 2623       ROL $23
fda0 20         JSR
fda1 191619     ORA $1916, Y
fda4 20         JSR
fda5 db 23
fda6 2629       ROL $29
fda8 30f0       BMI fd9a
fdaa db 04
fdab db f2
fdac 40         RTI
fdad db f3
fdae 061b       ASL $1b
fdb0 941b       STY $1b, X
fdb2 db 9a
fdb3 db ff
fdb4 f001       BEQ fdb7
fdb6 f8         SED
fdb7 db 04
fdb8 20         JSR
fdb9 947c       STY $7c, X
fdbb 307c       BMI fe39
fdbd db ff
fdbe f8         SED
fdbf db 04
fdc0 db 17
fdc1 7c277c     JMP (ABS) $7c27, X
fdc4 db ff
fdc5 7c9c7c     JMP (ABS) $7c9c, X
fdc8 9617       STX $17, X
fdca 817c       STA ($7c, X)
fdcc db 17
fdcd db ff
fdce 00         BRK
fdcf d8         CLD
fdd0 fd017c     SBC $7c01, X
fdd3 fe0222     INC $2202, X
fdd6 db ff
fdd7 db ff
fdd8 db f2
fdd9 80f3       STY #$f3
fddb 06f4       ASL $f4
fddd 02fa       ASL #$fa
fddf 69fe       ADC #$fe
fde1 29a6       AND #$a6
fde3 db 2b
fde4 a430       LDY $30
fde6 f007       BEQ fdef
fde8 db 2b
fde9 a629       LDX $29
fdeb 2928       AND #$28
fded f006       BEQ fdf5
fdef 29a6       AND #$a6
fdf1 db 2b
fdf2 db fa
fdf3 69fe       ADC #$fe
fdf5 30a6       BMI fd9d
fdf7 db 32
fdf8 a434       LDY $34
fdfa f007       BEQ fe03
fdfc db 32
fdfd a630       LDX $30
fdff db 32
fe00 db 37
fe01 f006       BEQ fe09
fe03 db 32
fe04 a8         TAY
fe05 f8         SED
fe06 02f0       ASL #$f0
fe08 08         PHP
fe09 db f2
fe0a 40         RTI
fe0b db 3b
fe0c a43b       LDY $3b
fe0e 7c7c3b     JMP (ABS) $3b7c, X
fe11 db 3b
fe12 7c7c3b     JMP (ABS) $3b7c, X
fe15 db 3b
fe16 7c7c3b     JMP (ABS) $3b7c, X
fe19 f006       BEQ fe21
fe1b db f2
fe1c 8039       STY #$39
fe1e db 37
fe1f db 32
fe20 34ac       BIT $ac, X
fe22 db ff
fe23 db fa
fe24 69fe       ADC #$fe
fe26 29a6       AND #$a6
fe28 db 2b
fe29 a430       LDY $30
fe2b f007       BEQ fe34
fe2d db 2b
fe2e a629       LDX $29
fe30 2928       AND #$28
fe32 f006       BEQ fe3a
fe34 29a6       AND #$a6
fe36 db 2b
fe37 db fa
fe38 69fe       ADC #$fe
fe3a 30a6       BMI fde2
fe3c db 32
fe3d a434       LDY $34
fe3f f007       BEQ fe48
fe41 db 32
fe42 a630       LDX $30
fe44 db 32
fe45 db 37
fe46 f006       BEQ fe4e
fe48 db 32
fe49 a8         TAY
fe4a f8         SED
fe4b 02f0       ASL #$f0
fe4d 08         PHP
fe4e db f2
fe4f 40         RTI
fe50 db 3b
fe51 a43b       LDY $3b
fe53 7c7c3b     JMP (ABS) $3b7c, X
fe56 db 3b
fe57 7c7c3b     JMP (ABS) $3b7c, X
fe5a db 3b
fe5b 7c7c3b     JMP (ABS) $3b7c, X
fe5e f006       BEQ fe66
fe60 db f2
fe61 8039       STY #$39
fe63 db 37
fe64 db 32
fe65 34ac       BIT $ac, X
fe67 db ff
fe68 db ff
fe69 f006       BEQ fe71
fe6b 29a6       AND #$a6
fe6d db 2b
fe6e a430       LDY $30
fe70 f007       BEQ fe79
fe72 db 2b
fe73 a629       LDX $29
fe75 db 2b
fe76 34f0       BIT $f0, X
fe78 062b       ASL $2b
fe7a a8         TAY
fe7b db ff
fe7c db f2
fe7d 80f3       STY #$f3
fe7f 08         PHP
fe80 f402       CPX $02, X
fe82 db fa
fe83 db 0f
fe84 db ff
fe85 25a6       AND $a6
fe87 db 27
fe88 a429       LDY $29
fe8a f007       BEQ fe93
fe8c db 27
fe8d a625       LDX $25
fe8f 2424       BIT $24
fe91 f006       BEQ fe99
fe93 24a6       BIT $a6
fe95 db 27
fe96 db fa
fe97 db 0f
fe98 db ff
fe99 29a6       AND #$a6
fe9b db 2b
fe9c a430       LDY $30
fe9e f007       BEQ fea7
fea0 db 2b
fea1 a629       LDX $29
fea3 db 2b
fea4 db 32
fea5 f006       BEQ fead
fea7 db 2b
fea8 a8         TAY
fea9 f8         SED
feaa 02f0       ASL #$f0
feac 09f2       ORA #$f2
feae 40         RTI
feaf db 3b
feb0 a43b       LDY $3b
feb2 7c7c3b     JMP (ABS) $3b7c, X
feb5 db 3b
feb6 7c7c3b     JMP (ABS) $3b7c, X
feb9 db 3b
feba 7c7c3b     JMP (ABS) $3b7c, X
febd f006       BEQ fec5
febf db f2
fec0 8034       STY #$34
fec2 db 32
fec3 db 2b
fec4 30aa       BMI fe70
fec6 db 2b
fec7 db ff
fec8 db fa
fec9 db 0f
feca db ff
fecb 25a6       AND $a6
fecd db 27
fece a429       LDY $29
fed0 f007       BEQ fed9
fed2 db 27
fed3 a625       LDX $25
fed5 2424       BIT $24
fed7 f006       BEQ fedf
fed9 24a6       BIT $a6
fedb db 27
fedc db fa
fedd db 0f
fede db ff
fedf 29a6       AND #$a6
fee1 db 2b
fee2 a430       LDY $30
fee4 f007       BEQ feed
fee6 db 2b
fee7 a629       LDX $29
fee9 db 2b
feea db 32
feeb f006       BEQ fef3
feed db 2b
feee a8         TAY
feef f8         SED
fef0 02f0       ASL #$f0
fef2 09f2       ORA #$f2
fef4 40         RTI
fef5 db 3b
fef6 a43b       LDY $3b
fef8 7c7c3b     JMP (ABS) $3b7c, X
fefb db 3b
fefc 7c7c3b     JMP (ABS) $3b7c, X
feff db 3b
ff00 7c7c3b     JMP (ABS) $3b7c, X
ff03 f006       BEQ ff0b
ff05 db f2
ff06 8034       STY #$34
ff08 db 32
ff09 db 2b
ff0a 30aa       BMI feb6
ff0c db 2b
ff0d db ff
ff0e db ff
ff0f f006       BEQ ff17
ff11 24a6       BIT $a6
ff13 db 27
ff14 a429       LDY $29
ff16 f007       BEQ ff1f
ff18 db 27
ff19 a624       LDX $24
ff1b db 27
ff1c db 2b
ff1d f006       BEQ ff25
ff1f db 27
ff20 a8         TAY
ff21 db ff
ff22 f001       BEQ ff25
ff24 f402       CPX $02, X
ff26 db fa
ff27 db 57
ff28 db ff
ff29 db fa
ff2a 89ff       STA #$ff
ff2c db fa
ff2d db 57
ff2e db ff
ff2f db fa
ff30 db 9a
ff31 db ff
ff32 db fa
ff33 db 57
ff34 db ff
ff35 db fa
ff36 89ff       STA #$ff
ff38 db fa
ff39 db 57
ff3a db ff
ff3b db fa
ff3c 89ff       STA #$ff
ff3e db fa
ff3f db 57
ff40 db ff
ff41 db fa
ff42 89ff       STA #$ff
ff44 db fa
ff45 db 57
ff46 db ff
ff47 db fa
ff48 db 9a
ff49 db ff
ff4a db fa
ff4b db 57
ff4c db ff
ff4d db fa
ff4e 89ff       STA #$ff
ff50 db fa
ff51 db 57
ff52 db ff
ff53 db fa
ff54 89ff       STA #$ff
ff56 db ff
ff57 19a27c     ORA $7ca2, Y
ff5a 197c29     ORA $297c, Y
ff5d 7c297c     JMP (ABS) $7c29, X
ff60 197c19     ORA $197c, Y
ff63 7c297c     JMP (ABS) $7c29, X
ff66 297c       AND #$7c
ff68 db 17
ff69 7c177c     JMP (ABS) $7c17, X
ff6c db 27
ff6d 7c277c     JMP (ABS) $7c27, X
ff70 db 17
ff71 7c177c     JMP (ABS) $7c17, X
ff74 db 27
ff75 7c277c     JMP (ABS) $7c27, X
ff78 157c       ORA $7c, X
ff7a 157c       ORA $7c, X
ff7c 257c       AND $7c
ff7e 257c       AND $7c
ff80 157c       ORA $7c, X
ff82 157c       ORA $7c, X
ff84 257c       AND $7c
ff86 257c       AND $7c
ff88 db ff
ff89 db 14
ff8a 7c147c     JMP (ABS) $7c14, X
ff8d 247c       BIT $7c
ff8f 247c       BIT $7c
ff91 db 14
ff92 7c147c     JMP (ABS) $7c14, X
ff95 247c       BIT $7c
ff97 247c       BIT $7c
ff99 db ff
ff9a db 17
ff9b 7c177c     JMP (ABS) $7c17, X
ff9e db 27
ff9f 7c277c     JMP (ABS) $7c27, X
ffa2 db 17
ffa3 7c177c     JMP (ABS) $7c17, X
ffa6 db 27
ffa7 7c277c     JMP (ABS) $7c27, X
ffaa db ff
ffab db ff
ffac db ff
ffad db ff
ffae db ff
ffaf db ff
ffb0 db ff
ffb1 db ff
ffb2 db ff
ffb3 db ff
ffb4 db ff
ffb5 db ff
ffb6 db ff
ffb7 db ff
ffb8 db ff
ffb9 db ff
ffba db ff
ffbb db ff
ffbc db ff
ffbd db ff
ffbe db ff
ffbf db ff
ffc0 db ff
ffc1 db ff
ffc2 db ff
ffc3 db ff
ffc4 db ff
ffc5 db ff
ffc6 db ff
ffc7 db ff
ffc8 db ff
ffc9 db ff
ffca db ff
ffcb db ff
ffcc db ff
ffcd db ff
ffce db ff
ffcf db ff
ffd0 db ff
ffd1 db ff
ffd2 db ff
ffd3 db ff
ffd4 db ff
ffd5 db ff
ffd6 db ff
ffd7 db ff
ffd8 db ff
ffd9 db ff
ffda db ff
ffdb db ff
ffdc db ff
ffdd db ff
ffde db ff
ffdf db ff
ffe0 db ff
ffe1 db ff
ffe2 db ff
ffe3 db ff
ffe4 db ff
ffe5 db ff
ffe6 db ff
ffe7 db ff
ffe8 db ff
ffe9 db ff
ffea db ff
ffeb db ff
ffec db ff
ffed db ff
ffee db ff
ffef db ff
fff0 db ff
fff1 db ff
fff2 db ff
fff3 db ff
fff4 db ff
fff5 db ff
fff6 db ff
fff7 db ff
fff8 db ff
fff9 db ff
