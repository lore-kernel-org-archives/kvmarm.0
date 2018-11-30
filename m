From: Andrew Murray <andrew.murray@arm.com>
Subject: Re: Instruction/Cycle Counting in Guest Using the Kvm PMU
Date: Fri, 30 Nov 2018 00:23:30 +0000
Message-ID: <20181130002327.GB16311@e119886-lin.cambridge.arm.com>
References: <93B846538060DA46A9945E98A2E521E9A87A9C@DE02WEMBXB.internal.synopsys.com>
 <0e9adc4e-20e3-5648-3ef6-64c9e16f780d@arm.com>
 <20181123132704.GN42987@e119886-lin.cambridge.arm.com>
 <93B846538060DA46A9945E98A2E521E9A87BEA@DE02WEMBXB.internal.synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1C7B4A33F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Nov 2018 19:23:36 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fifv0zyv5t0d for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Nov 2018 19:23:33 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC7A14A33E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Nov 2018 19:23:32 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <93B846538060DA46A9945E98A2E521E9A87BEA@DE02WEMBXB.internal.synopsys.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jan Bolke <jan.bolke@synopsys.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 29, 2018 at 11:30:55AM +0000, Jan Bolke wrote:
> Hi,
> And thanks for the fast replies.
> 
> >The PMU emulation works by creating a perf event in the host, however it is pinned to the KVM process, so the the real PMU counters are stopped and started as the KVM process is >scheduled in and out. This means that it will include any CPU time associated with that process of which your guest is only a subset of.
> 
> Thanks for the clarification.
> As this is the case, the counted cycles from the host should deliver a larger number than the executed instructions inside the guest.

Indeed.


> 
> >The patchset that James refers to will ensure that the underlying real PMU counters underlying the guest only events will only be enabled upon entering the guest (and disabled on >leaving). Thus you will need to apply this (to your host) for more accurate counting. (You could also then use the perf modifiers in the host to counter guest cycles, e.g. perf -e >instructions:G).
> 
> So I applied your patch to a 4.19.5 kernel and also your other Patchseries for the perf events in the host [0].
> So what I do now is running :
> perf stat -e instructions:G -- ./run_loop_in_kvm.
> 
> Run_loop_in_kvm is a small c program who starts a vm and executes a little loop in the guest and then exits.
> I get a output from perf like the following:
> 	159732   instructions:Gu
>      ....
> My Problem is, I am still not sure how to interpret these values as my bare metal code runs a loop for 1048577 times 
> which executes 3 instructions in every run.

I notice you are using :Gu. The 'u' will record only EL0, are you confident
that your code runs at this level? Perhaps drop the 'u'.

Also are you compiling with compiler optimisations turned off - or have you
inspected an objdump of the binary to verify it is as you expect?


> 
> My question is how comes this discrepancy of the counted values.
> The perf counting from the host delivers a value significantly smaller than the number of instructions in the guest.
> 
> I am struggling to interpret the perf counter values as an indication how many instructions my guest performed.
> What am I missing?

Your expectations are correct. For my own sanity I attempted something similar:

# cat startup.s
ENTRY(_start)
SECTIONS
{
        . = 0x80080000;
        .startup . : { startup.o(.text) }
        .text : { *(.text) }
        .data : { *(.data) }
        .bss : { *(.bss COMMON) }
        . = ALIGN(16);
        . = . + 0x1000;
        stack_top = .;
}

# cat test.c
void main() {
        int x=0;
        for (x=0;x<20000000;x++)
                ;
}

# cat script.ld

ENTRY(_start)
SECTIONS
{
        . = 0x80080000;
        .startup . : { startup.o(.text) }
        .text : { *(.text) }
        .data : { *(.data) }
        .bss : { *(.bss COMMON) }
        . = ALIGN(16);
        . = . + 0x1000;
        stack_top = .;
}

And then:

# aarch64-linux-gnu-gcc -c test.c -o test.o                                                             
# aarch64-linux-gnu-as startup.s -o startup.o                                                           
# aarch64-linux-gnu-ld -T script.ld test.o startup.o -o out                                             
# aarch64-linux-gnu-objcopy -O binary -S out  

On the host:

# perf stat -e instructions:G /lkvm-static run -k /out  -m 1024 -c 1 --console serial --pmu

...

# KVM session ended normally.

 Performance counter stats for '/lkvm-static run -k /out -m 1024 -c 1 --console serial --pmu':

         160000016      instructions:G                                              


This matches exactly with what I would expect from the disassembly:

Disassembly of section .startup:

0000000080080000 <_start>:
    80080000:   580000de        ldr     x30, 80080018 <_start+0x18>
    80080004:   910003df        mov     sp, x30
    80080008:   94000006        bl      80080020 <main>
    8008000c:   d503207f        wfi
    80080010:   17ffffff        b       8008000c <_start+0xc>
    80080014:   00000000        .inst   0x00000000 ; undefined
    80080018:   80081060        .word   0x80081060
    8008001c:   00000000        .word   0x00000000

Disassembly of section .text:

0000000080080020 <main>:
    80080020:   d10043ff        sub     sp, sp, #0x10
    80080024:   b9000fff        str     wzr, [sp, #12]
    80080028:   b9000fff        str     wzr, [sp, #12]
    8008002c:   14000004        b       8008003c <main+0x1c>
    80080030:   b9400fe0        ldr     w0, [sp, #12]
    80080034:   11000400        add     w0, w0, #0x1
    80080038:   b9000fe0        str     w0, [sp, #12]
    8008003c:   b9400fe1        ldr     w1, [sp, #12]
    80080040:   52859fe0        mov     w0, #0x2cff                     // #11519
    80080044:   72a02620        movk    w0, #0x131, lsl #16
    80080048:   6b00003f        cmp     w1, w0
    8008004c:   54ffff2d        b.le    80080030 <main+0x10>
    80080050:   d503201f        nop
    80080054:   910043ff        add     sp, sp, #0x10
    80080058:   d65f03c0        ret



> 
> Also I get the following output for perf stat -e cycles:G ls: 647284 cyles:Gu.

> Is this a indicator that my guest/host modifiers do not work or am I misunderstanding the whole concept here?
> Sorry for the silly question and thanks in advance!

For 'perf stat -e cycles:G ls' I would expect 0. I'm not quite sure why it's
showing data for the 'u' modifier. It smells a little like the patch hasn't
applied or the userspace perf tool is falling back to not using exclude_guest
and recording just EL0 (which would explain all your figures assuming your
bare metal code actually runs at EL1).

Try running 'perf stat -vv -e instructions:G ls' Make sure that the last
'exclude_host    1' you see on the screen is set to 1.

Thanks,

Andrew Murray

> 
> >Also you may want to refer to kvm-unit-tests are there are test cases that demonstrate bare metal code for PMU enabling.
> Thanks for the hint, these tests are very useful examples!
> 
> [0]: http://lists.infradead.org/pipermail/linux-arm-kernel/2018-November/614985.html
> 
> 
