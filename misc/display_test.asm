        org 0x0000

        loadimm.lower 65
        loadimm.upper 66
        mov r0 r7
        loadimm.lower 0x00
        loadimm.upper 0x10
        mov r1 r7
        loadimm.lower 0x02
        loadimm.upper 0x00
        mov r2 r7

Loop:   store r1 r0
        add r1 r1 r2
        brr Loop
