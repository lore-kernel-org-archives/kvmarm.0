From: James Morse <james.morse@arm.com>
Subject: Re: Instruction/Cycle Counting in Guest Using the Kvm PMU
Date: Fri, 23 Nov 2018 12:29:08 +0000
Message-ID: <0e9adc4e-20e3-5648-3ef6-64c9e16f780d@arm.com>
References: <93B846538060DA46A9945E98A2E521E9A87A9C@DE02WEMBXB.internal.synopsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 286C44A1F2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Nov 2018 07:29:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mUf6glpUYOqg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 23 Nov 2018 07:29:12 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B73A4A1E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 23 Nov 2018 07:29:12 -0500 (EST)
In-Reply-To: <93B846538060DA46A9945E98A2E521E9A87A9C@DE02WEMBXB.internal.synopsys.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Jan Bolke <jan.bolke@synopsys.com>, Andrew Murray <andrew.murray@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jan,

(CC: +Andrew)

On 23/11/2018 09:36, Jan Bolke wrote:
> I am not sure if this question is well-placed here, so sorry if it misses=
 the
> purpose of this mailing list.

arm64? kvm? Sounds like you've come to the right place!


> I am using the Kvm Api and try to integrate it as an instruction set simu=
lator
> in a SystemC environment.


> I need some mechanism to count executed instructions in the guest (or cyc=
les).
> =

> Currently I am trying to use the emulated PMU cycle counter in the guest =
to get
> the number of executed cycles in the guest.
> =

> I am working on Arm64 and use Linux Kernel 4.14.33.
> =

> I create the PMU device without creating a in-kernel vgic.

> I configure the counter, then start the counter, execute 3 or 4 dummy
> instructions and read the counter again and then exit the guest with an e=
xit_mmio.
> =

> I assumed the value should be a very small number, as the guest only exec=
uted a
> few instructions.

(some of which are system register writes, which can take a long time)


> The thing is as I read the counter, the value is something like 2970 or 0
> (changes in each run).

You are missing some barriers in your assembly snippet. 0 is a good indicat=
ion
that the code you wanted to measure escaped the measurement-window!


> So to me it looks like the counter is also counting the cycles for instru=
ction
> emulation in the host, am I right?

I'd assume not, but I don't know anything about the PMU.
Andrew Murray posted a series[0] that did some stuff with starting/stopping=
 the
the counters around the guest, but I think that was just for the host making
measurements of itself, or the guest.


KVM emulates parts of the PMU, so your measurements may be too noisy for su=
ch
small windows of code.

It might be easier to count instructions from outside the guest using perf.=
 I
think Andrew's series is making that more reliable.


> Is it possible to just count the cycles in the guest from the guests=92s =
point of
> view?
> =

> I read the kvm-api.txt Documentation and the other documents a few times =
and
> tried different approaches, so this mailing list is my last resort.


> APPENDIX:
> =

> // we are in el1
> =

> // init system registers
> LDR X1, =3D0x30C50838
> MSR SCTLR_EL1, X1

isb

If the next instructions depend on any of the bits you set in sctrl, you ne=
ed to
make sure the cpu has synchronised this state-change before the next instru=
ction
is executed. Otherwise (depending on the CPU) the intended side-effects only
come into effect some number of instructions later.


> // enable access to pmu counters from el0
> mov x0, 0xff
> mrs x1, currentel

> mrs x7, pmuserenr_el0
> orr x7, x7, #0b1111
> msr pmuserenr_el0, x7

Why do you need to do this? Running from EL1 the values in this register sh=
ould
have no effect.


> // set pmcr register (control register)
> =

> //enable long counter, count every cycle and enable counters
> mrs x5, pmcr_el0
> orr x5, x5, #0b1
> orr x5, x5, #(1<<6)
> eor x5, x5, #(1<<3)

> eor x5, x5, #(1<<5)

(looks like this bit has no effect on the 'normal world')

> msr pmcr_el0, x5


> // read mvccfiltr register (only enable counting of el1)
> =

> mrs x6, pmccfiltr_el0
> =

> mov x6, #(1<<30)

This bit only effects EL0.

> msr pmccfiltr_el0, x6



> // get interrupt configuration and clear overflow bit
> =

> mrs x9, pmintenset_el1

You never use x9 after this. What did you want to do with this register?
(I assume its debug)


> mov x8, #(1<<31)
> msr pmovsclr_el0, x8


> // write counter
> mov x0, #0x0
> msr pmccntr_el0, x0 // write counter

> // enable cycle counter
> mov x1, #(1<<31)
> msr pmcntenset_el0, x1
> mov x0, #0x2 */


> // dummy instruction and provoke mmio-exit
> mov x1, #0x3
> add x2, x0, x1
> mov x2, 0x5000

> //read counter
> mrs x1, pmccntr_el0

At this point all the system register writes since the last 'isb' may not h=
ave
'finished', their side effects may not be visible.
You need to synchronise the changes that enable the counter, before you run=
 your
measured instructions, and you want to make sure your measured instructions=
 have
'finished' before you re-read the counter.

The sequence would be something like:
| isb	// for the config writes that enable the counter
| mrs x2, pmccntr_el0
| isb

[measured instructions]

| isb
| mrs x3, pmccntr_el0


> // read overflow
> mrs x8, pmovsclr_el0

> // provoke mmio exit (0x500 is not mapped)
> ldr x3, [x2]


Hope this helps!

James


[0] https://www.mail-archive.com/kvmarm@lists.cs.columbia.edu/msg19778.html
