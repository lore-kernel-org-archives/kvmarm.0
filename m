From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: KVM arm realtime performance optimization
Date: Tue, 11 Dec 2018 11:55:19 +0100
Message-ID: <20181211105519.GX30263@e113682-lin.lund.arm.com>
References: <DB7PR08MB360939B98F8943EF9BE9FF40F0A90@DB7PR08MB3609.eurprd08.prod.outlook.com>
 <DB7PR08MB36090AADD259F89702C3AEF1F0A50@DB7PR08MB3609.eurprd08.prod.outlook.com>
 <20181210131834.GQ30263@e113682-lin.lund.arm.com>
 <DB7PR08MB360928EBAE24907442277603F0A60@DB7PR08MB3609.eurprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 781594A2E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 05:55:23 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NmrjgDY79wHH for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Dec 2018 05:55:22 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4B384A1DF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Dec 2018 05:55:21 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <DB7PR08MB360928EBAE24907442277603F0A60@DB7PR08MB3609.eurprd08.prod.outlook.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "Steven Miao (Arm Technology China)" <Steven.Miao@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Dec 11, 2018 at 10:00:35AM +0100, Steven Miao (Arm Technology China) wrote:
> Hi Christopher,
> 
> > -----Original Message-----
> > From: Christoffer Dall <christoffer.dall@arm.com>
> > Sent: Monday, December 10, 2018 9:19 PM
> > To: Steven Miao (Arm Technology China) <Steven.Miao@arm.com>
> > Cc: kvmarm@lists.cs.columbia.edu
> > Subject: Re: KVM arm realtime performance optimization
> > 
> > On Mon, Dec 10, 2018 at 05:36:09AM +0000, Steven Miao (Arm Technology
> > China) wrote:
> > >
> > > From: kvmarm-bounces@lists.cs.columbia.edu
> > > <kvmarm-bounces@lists.cs.columbia.edu> On Behalf Of Steven Miao (Arm
> > > Technology China)
> > > Sent: Thursday, December 6, 2018 3:05 PM
> > > To: kvmarm@lists.cs.columbia.edu
> > > Subject: KVM arm realtime performance optimization
> > >
> > > Hi Everyone,
> > >
> > > I' currently testing KVM arm realtime performance on a hikey960 board.
> > My test benchmark is cyclictest to measure thread wake up latency both on
> > Host linux OS and KVM Guest linux OS.
> > >
> > > Host OS:
> > >
> > > hikey960:/mnt/debian/usr/src/linux#  cyclictest -p 99 -t 4 -m -n -a
> > > 0-3 -l 100000 # /dev/cpu_dma_latency set to 0us
> > > WARN: Running on unknown kernel version...YMMV
> > > policy: fifo: loadavg: 0.00 0.00 0.00 1/165 3270
> > >
> > > T: 0 ( 3266) P:99 I:1000 C: 100000 Min:      4 Act:   15 Avg:   15 Max:     139
> > > T: 1 ( 3267) P:99 I:1500 C:  66736 Min:      4 Act:   15 Avg:   15 Max:     239
> > > T: 2 ( 3268) P:99 I:2000 C:  50051 Min:      4 Act:   19 Avg:   15 Max:      43
> > > T: 3 ( 3269) P:99 I:2500 C:  40039 Min:      5 Act:   15 Avg:   16 Max:      74
> > >
> > > Guest OS:
> > > root@genericarmv8:~# cyclictest -p 99 -t 4 -m -n -a 0-3 -l 100000 #
> > > /dev/cpu_dma_latency set to 0us
> > > WARN: Running on unknown kernel version...YMMV
> > > policy: fifo: loadavg: 0.13 0.05 0.01 1/70 293
> > >
> > > T: 0 (  290) P:99 I:1000 C: 100000 Min:      7 Act:   44 Avg:   85 Max:   16111
> > > T: 1 (  291) P:99 I:1500 C:  66665 Min:      7 Act:   81 Avg:   90 Max:   15306
> > > T: 2 (  292) P:99 I:2000 C:  49995 Min:      7 Act:   88 Avg:   87 Max:   16703
> > > T: 3 (  293) P:99 I:2500 C:  39992 Min:      8 Act:   72 Avg:   97 Max:   14976
> > >
> > >
> > > RT performance on KVM guest OS is poor compared to that on host OS. The
> > average wake up latency is about 6 - 7 times on Guest OS vs on Host OS.
> > > I've tried some configurations to improve RT in KVM, like:
> > > 1 Can be combined with CPU isolation
> > > 2 Host OS and Guest OS use RT preempt kernel
> > > 3 Host CPU avoid frequency change
> > > 4 Configure NO_HZ_FULL for Guest OS
> > >
> > > There could be a little improvement after apply above configuration, but
> > the RT performance is still very poor.
> > >
> > > 5 Guest OS use idle poll instead of WFI to avoid trap and switch out
> > >
> > > diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> > > index 2dc0f84..53aef78 100644
> > > --- a/arch/arm64/kernel/process.c
> > > +++ b/arch/arm64/kernel/process.c
> > > @@ -83,7 +83,7 @@ void arch_cpu_idle(void)
> > >          * tricks
> > >          */
> > >         trace_cpu_idle_rcuidle(1, smp_processor_id());
> > > -       cpu_do_idle();
> > > +       cpu_relax();
> > >         local_irq_enable();
> > >         trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());  }
> > >
> > > root@genericarmv8:~# cyclictest -p 99 -t 4 -m -n  -l 100000 #
> > > /dev/cpu_dma_latency set to 0us
> > > WARN: Running on unknown kernel version...YMMV
> > > policy: fifo: loadavg: 0.07 0.03 0.00 1/99 328
> > >
> > > T: 0 (  325) P:99 I:1000 C: 100000 Min:      3 Act:    6 Avg:   13 Max:    4999
> > > T: 1 (  326) P:99 I:1500 C:  66659 Min:      5 Act:    7 Avg:   14 Max:    3449
> > > T: 2 (  327) P:99 I:2000 C:  49989 Min:      4 Act:    7 Avg:    9 Max:   11471
> > > T: 3 (  328) P:99 I:2500 C:  39986 Min:      4 Act:   14 Avg:   14 Max:   11253
> > >
> > > The method 5 can improve Guest OS RT performance a lot, the average
> > thread wake up latency on Guest OS is almost same as its on Host OS, but the
> > Max wake up latency is still very poor.
> > >
> > > Anyone has any idea to improve RT performance on KVM Guest OS?
> > Although method 5 can improve RT performance on Guest OS a lot, I think it
> > is not good idea.
> > >
> > This is a known problem and there have been presentations about similar
> > problems on x86 in past KVM Forums.
> > 
> > The first thing to do is analyze the critical path that adds latency to a wakeup.
> > One way to do that is to instrument the path by adding time counter reads to
> > the path and figuring out what takes time.
> > 
> > One thing you can look at is having a configurable grace period in KVM's
> > block function before the process actually goes to sleep (and calls
> > kvm_vcpu_put) and the host scheduler, and see if that helps anything.
> Thanks for your suggestion. I will do some further investigation on it, some arm server partner reported KVM Guest RT latency is a little too big than on x86.
> 
> > 
> > At the end of the day, virtualization is going to add a lot of latency when you
> > have to switch the entire state of your CPU, and in terms of virtual RT, you
> > end up with a very high minimal latency.
> Got it. Hope some new hardware features like VHE and direct inject VIRQ can improve the latency.

Just FYI: Those features are not going to help you for wake-up time
latency, at all.

Also, I warn against optimizing specifically for cyclictest.  Most
likely you're using cyclictest as some measure for latency for a
particular workload, and you must take that into consideration.  For
example, if you care about interrupt latency from a device using a
directly injected LPI, that is going to look very different from going
to sleep and getting a timer interrupt (PPI) waking you up.


Thanks,

    Christoffer
