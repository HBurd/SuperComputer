HelloWorld: equ  0x0400
Display:    equ  0x1000

        org 0x040E
            loadimm.upper HelloWorld.hi
            loadimm.lower HelloWorld.lo
            mov r6 r7
            mov r5 r7

            loadimm.lower 0x02
            loadimm.upper 0x00
            mov r2 r7
            
            loadimm.lower 72
            loadimm.upper 101
            store r6 r7
            add r6 r6 r2

            loadimm.lower 108
            loadimm.upper 108
            store r6 r7
            add r6 r6 r2

            loadimm.lower 111
            loadimm.upper 32
            store r6 r7
            add r6 r6 r2

            loadimm.lower 87
            loadimm.upper 111
            store r6 r7
            add r6 r6 r2

            loadimm.lower 114
            loadimm.upper 108
            store r6 r7
            add r6 r6 r2

            loadimm.lower 100
            loadimm.upper 0
            store r6 r7
            add r6 r6 r2

            loadimm.upper Display.hi
            loadimm.lower Display.lo

PrintChar:  load r0 r5
            test r0
            brr.z Done
            store r7 r0
            add r5 r5 r2
            add r7 r7 r2
            brr PrintChar


Done:       brr Done
