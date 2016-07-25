From: Stefan Agner <stefan@agner.ch>
Subject: Re: KVM on ARM crashes with new VGIC v4.7-rc7
Date: Sun, 24 Jul 2016 23:28:45 -0700
Message-ID: <2fca0542c80485b25afec9e2772c4715@agner.ch>
References: <e2f7196ca6c70c55463a45b490f6731a@agner.ch>
 <8b70c7e1-2e80-4366-97f6-505c0dc7cd64@arm.com>
 <20160722143551.llypjpouhxdvkonq@kamzik.localdomain>
 <57923E5F.30709@arm.com>
 <20160722173823.dcen33yyqqixmwkm@kamzik.localdomain>
 <57925CA0.7050904@arm.com> <762a6ad33268025f10b2198891e56d4d@agner.ch>
 <579261D0.9090800@arm.com> <2513ea4845a2ace74ea1645f2624ed2f@agner.ch>
 <20160723112044.4e69408b@arm.com>
 <789c5fd39f47b6a222d639384f55fc1c@agner.ch>
 <20160724103020.1266c839@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82E8B4113E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jul 2016 02:27:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wPE8x-73BWLg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 25 Jul 2016 02:27:03 -0400 (EDT)
Received: from mail.kmu-office.ch (mail.kmu-office.ch [178.209.48.109])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AFF2A40B40
 for <kvmarm@lists.cs.columbia.edu>; Mon, 25 Jul 2016 02:27:03 -0400 (EDT)
In-Reply-To: <20160724103020.1266c839@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 2016-07-24 02:30, Marc Zyngier wrote:
> On Sat, 23 Jul 2016 09:33:54 -0700
> Stefan Agner <stefan@agner.ch> wrote:
> 
>> On 2016-07-23 03:20, Marc Zyngier wrote:
>> > On Sat, 23 Jul 2016 00:45:50 -0700
>> > Stefan Agner <stefan@agner.ch> wrote:
>> >
>> >> On 2016-07-22 11:11, Marc Zyngier wrote:
>> >> > On 22/07/16 18:56, Stefan Agner wrote:
>> >> >> On 2016-07-22 10:49, Marc Zyngier wrote:
>> >> >>> On 22/07/16 18:38, Andrew Jones wrote:
>> >> >>>> On Fri, Jul 22, 2016 at 04:40:15PM +0100, Marc Zyngier wrote:
>> >> >>>>> On 22/07/16 15:35, Andrew Jones wrote:
>> >> >>>>>> On Fri, Jul 22, 2016 at 11:42:02AM +0100, Andre Przywara wrote:
>> >> >>>>>>> Hi Stefan,
>> >> >>>>>>>
>> >> >>>>>>> On 22/07/16 06:57, Stefan Agner wrote:
>> >> >>>>>>>> Hi,
>> >> >>>>>>>>
>> >> >>>>>>>> I tried KVM on a Cortex-A7 platform (i.MX 7Dual SoC) and encountered
>> >> >>>>>>>> this stack trace immediately after invoking qemu-system-arm:
>> >> >>>>>>>>
>> >> >>>>>>>> Unable to handle kernel paging request at virtual address ffffffe4
>> >> >>>>>>>> pgd = 8ca52740
>> >> >>>>>>>> [ffffffe4] *pgd=80000080007003, *pmd=8ff7e003, *pte=00000000
>> >> >>>>>>>> Internal error: Oops: 207 [#1] SMP ARM
>> >> >>>>>>>> Modules linked in:
>> >> >>>>>>>> CPU: 0 PID: 329 Comm: qemu-system-arm Tainted: G        W
>> >> >>>>>>>> 4.7.0-rc7-00094-gea3ed2c #109
>> >> >>>>>>>> Hardware name: Freescale i.MX7 Dual (Device Tree)
>> >> >>>>>>>> task: 8ca3ee40 ti: 8d2b0000 task.ti: 8d2b0000
>> >> >>>>>>>> PC is at do_raw_spin_lock+0x8/0x1dc
>> >> >>>>>>>> LR is at kvm_vgic_flush_hwstate+0x8c/0x224
>> >> >>>>>>>> pc : [<8027c87c>]    lr : [<802172d4>]    psr: 60070013
>> >> >>>>>>>> sp : 8d2b1e38  ip : 8d2b0000  fp : 00000001
>> >> >>>>>>>> r10: 8d2b0000  r9 : 00010000  r8 : 8d2b8e54
>> >> >>>>>>>> fec 30be0000.ethernet eth0: MDIO read timeout
>> >> >>>>>>>> r7 : 8d2b8000  r6 : 8d2b8e74  r5 : 00000000  r4 : ffffffe0
>> >> >>>>>>>> r3 : 00004ead  r2 : 00000000  r1 : 00000000  r0 : ffffffe0
>> >> >>>>>>>> Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
>> >> >>>>>>>> Control: 30c5387d  Table: 8ca52740  DAC: fffffffd
>> >> >>>>>>>> Process qemu-system-arm (pid: 329, stack limit = 0x8d2b0210)
>> >> >>>>>>>> Stack: (0x8d2b1e38 to 0x8d2b2000)
>> >> >>>>>>>> 1e20:                                                       ffffffe0
>> >> >>>>>>>> 00000000
>> >> >>>>>>>> 1e40: 8d2b8e74 8d2b8000 8d2b8e54 00010000 8d2b0000 802172d4 8d2b8000
>> >> >>>>>>>> 810074f8
>> >> >>>>>>>> 1e60: 81007508 8ca5f800 8d284000 00010000 8d2b0000 8020fbd4 8ce9a000
>> >> >>>>>>>> 8ca5f800
>> >> >>>>>>>> 1e80: 00000000 00010000 00000000 00ff0000 8d284000 00000000 00000000
>> >> >>>>>>>> 7ffbfeff
>> >> >>>>>>>> 1ea0: fffffffe 00000000 8d28b780 00000000 755fec6c 00000000 00000000
>> >> >>>>>>>> ffffe000
>> >> >>>>>>>> 1ec0: 8d2b8000 00000000 8d28b780 00000000 755fec6c 8020af90 00000000
>> >> >>>>>>>> 8023f248
>> >> >>>>>>>> 1ee0: 0000000a 755fe98c 8d2b1f08 00000008 8021aa84 ffffe000 00000000
>> >> >>>>>>>> 00000000
>> >> >>>>>>>> 1f00: 8a00d860 8d28b780 80334f94 00000000 8d2b0000 80334748 00000000
>> >> >>>>>>>> 00000000
>> >> >>>>>>>> 1f20: 00000000 8d28b780 00004000 00000009 8d28b500 00000024 8104ebee
>> >> >>>>>>>> 80bc2ec4
>> >> >>>>>>>> 1f40: 80bafa24 8034138c 00000000 00000000 80341248 00000000 755fec6c
>> >> >>>>>>>> 007c1e70
>> >> >>>>>>>> 1f60: 00000009 00004258 0000ae80 8d28b781 00000009 8d28b780 0000ae80
>> >> >>>>>>>> 00000000
>> >> >>>>>>>> 1f80: 8d2b0000 00000000 755fec6c 80334f94 007c1e70 322a7400 00004258
>> >> >>>>>>>> 00000036
>> >> >>>>>>>> 1fa0: 8021aa84 8021a900 007c1e70 322a7400 00000009 0000ae80 00000000
>> >> >>>>>>>> 755feac0
>> >> >>>>>>>> 1fc0: 007c1e70 322a7400 00004258 00000036 7e9aff58 01151da4 76f8b4c0
>> >> >>>>>>>> 755fec6c
>> >> >>>>>>>> 1fe0: 0038192c 755fea9c 00048ae7 7697d66c 60070010 00000009 00000000
>> >> >>>>>>>> 00000000
>> >> >>>>>>>> [<8027c87c>] (do_raw_spin_lock) from [<802172d4>]
>> >> >>>>>>>> (kvm_vgic_flush_hwstate+0x8c/0x224)
>> >> >>>>>>>> [<802172d4>] (kvm_vgic_flush_hwstate) from [<8020fbd4>]
>> >> >>>>>>>> (kvm_arch_vcpu_ioctl_run+0x110/0x478)
>> >> >>>>>>>> [<8020fbd4>] (kvm_arch_vcpu_ioctl_run) from [<8020af90>]
>> >> >>>>>>>> (kvm_vcpu_ioctl+0x2e0/0x6d4)
>> >> >>>>>>>> [<8020af90>] (kvm_vcpu_ioctl) from [<80334748>]
>> >> >>>>>>>> (do_vfs_ioctl+0xa0/0x8b8)
>> >> >>>>>>>> [<80334748>] (do_vfs_ioctl) from [<80334f94>] (SyS_ioctl+0x34/0x5c)
>> >> >>>>>>>> [<80334f94>] (SyS_ioctl) from [<8021a900>] (ret_fast_syscall+0x0/0x1c)
>> >> >>>>>>>> Code: e49de004 ea09ea24 e92d47f0 e3043ead (e5902004)
>> >> >>>>>>>> ---[ end trace cb88537fdc8fa206 ]---
>> >> >>>>>>>>
>> >> >>>>>>>> I use CONFIG_KVM_NEW_VGIC=y. This happens to me with a rather minimal
>> >> >>>>>>>> qemu invocation (qemu-system-arm -enable-kvm -M virt -cpu host
>> >> >>>>>>>> -nographic -serial stdio -kernel zImage).
>> >> >>>>>>>>
>> >> >>>>>>>> Using a bit older Qemu version 2.4.0.
>> >> >>>>>>>
>> >> >>>>>>> I just tried with a self compiled QEMU 2.4.0 and the Ubuntu 14.04
>> >> >>>>>>> provided 2.0.0, it worked fine with Linus' current HEAD as a host kernel
>> >> >>>>>>> on a Midway (Cortex-A15).
>> >> >>>>>>
>> >> >>>>>> I can reproduce the issue with a latest QEMU build on AMD Seattle
>> >> >>>>>> (I haven't tried anywhere else yet)
>> >> >>>>>>
>> >> >>>>>>>
>> >> >>>>>>> Can you try to disable the new VGIC, just to see if that's a regression?
>> >> >>>>>>
>> >> >>>>>> Disabling NEW_VGIC "fixes" guest boots.
>> >> >>>>>>
>> >> >>>>>> I'm not using defconfig for my host kernel. I'll do a couple more
>> >> >>>>>> tests and provide a comparison of my config vs. a defconfig in
>> >> >>>>>> a few minutes.
>> >> >>>>>
>> >> >>>>> Damn. It is not failing for me, so it has to be a kernel config thing...
>> >> >>>>> If you can narrow it down to the difference with defconfig, that'd be
>> >> >>>>> tremendously helpful.
>> >> >>>>
>> >> >>>> It's PAGE_SIZE; 64K doesn't work, 4K does, regardless of VA_BITS
>> >> >>>> selection.
>> >> >>>
>> >> >>> That definitely doesn't match Stefan's report (32bit only has 4k). I'll
>> >> >>
>> >> >> Hehe, was just plowing through code and came to that conclusion, glad I
>> >> >> got that right :-)
>> >> >>
>> >> >> What defconfig do you use? I could reproduce the issue also with
>> >> >> multi_v7_defconfig + ARM_LPAE + KVM.
>> >> >
>> >> > I have my own config file with the crap I need to make things work on
>> >> > the various platforms I have around. If multi_v7_defconfig works on the
>> >> > cubietruck, I'll give it a spin tomorrow. I need a beer now.
>> >> >
>> >> >> Btw, I am not exactly on vanilla 4.7-rc7, I merged Shawns for-next +
>> >> >> clock next to get to the bits and pieces required for my board...
>> >> >>
>> >> >> That said, it works fine otherwise, and the stacktrace looks rather
>> >> >> platform independent...
>> >> >
>> >> > Yeah, and that's the worrying part.
>> >>
>> >>
>> >> FWIW, I tried here with Qemu 2.6.0, same stack trace...
>> >
>> > I don't think this is userspace related, specially given that Andrew
>> > managed to trigger it on arm64 as well. I guess we're looking at
>> > something that changes the layout of memory (page size in Drew's case),
>> > and exposes another latent bug. I'll try to get multi_v7_defconfig
>> > running on my CT later today, and hopefully the thing will explode.
>> > Fingers crossed.
>> >
>>
>> I hit another issue, this time in the guest. At times, it seemed as if
>> qemu-system-arm freezed (no console output). I then enabled earlyprintk
>> for PL01X UART, and got this:
>>
>> Architected timer frequency not available
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 0 at kernel/time/clockevents.c:44
>> cev_delta2ns+0x114/0x128
>> Modules linked in:
>> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 4.7.0-rc7 #5
>> Hardware name: Generic DT based system
>> [<8010e2a0>] (unwind_backtrace) from [<8010b270>] (show_stack+0x10/0x14)
>> [<8010b270>] (show_stack) from [<8030e734>] (dump_stack+0x84/0x98)
>> [<8030e734>] (dump_stack) from [<8011a718>] (__warn+0xe8/0x100)
>> [<8011a718>] (__warn) from [<8011a7e0>] (warn_slowpath_null+0x20/0x28)
>> [<8011a7e0>] (warn_slowpath_null) from [<8017503c>]
>> (cev_delta2ns+0x114/0x128)
>> [<8017503c>] (cev_delta2ns) from [<8017548c>]
>> (clockevents_config.part.2+0x4c/0x6c)
>> [<8017548c>] (clockevents_config.part.2) from [<801754cc>]
>> (clockevents_config_and_register+0x20/0x2c)
>> [<801754cc>] (clockevents_config_and_register) from [<80435d9c>]
>> (arch_timer_setup+0xd8/0x1b4)
>> [<80435d9c>] (arch_timer_setup) from [<8081c118>]
>> (arch_timer_of_init+0x2a0/0x2c8)
>> [<8081c118>] (arch_timer_of_init) from [<8081bb14>]
>> (clocksource_probe+0x54/0x90)
>> [<8081bb14>] (clocksource_probe) from [<80800b30>]
>> (start_kernel+0x240/0x378)
>> [<80800b30>] (start_kernel) from [<4000807c>] (0x4000807c)
>> ---[ end trace cb88537fdc8fa200 ]---
>> Architected cp15 timer(s) running at 0.00MHz (virt).
>> Division by zero in kernel.
>> CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W       4.7.0-rc7 #5
>> Hardware name: Generic DT based system
>> [<8010e2a0>] (unwind_backtrace) from [<8010b270>] (show_stack+0x10/0x14)
>> [<8010b270>] (show_stack) from [<8030e734>] (dump_stack+0x84/0x98)
>> [<8030e734>] (dump_stack) from [<8030c764>] (Ldiv0_64+0x8/0x18)
>> [<8030c764>] (Ldiv0_64) from [<80172360>]
>> (clocks_calc_max_nsecs+0x24/0x78)
>> [<80172360>] (clocks_calc_max_nsecs) from [<801725d8>]
>> (__clocksource_update_freq_scale+0x224/0x2fc)
>> [<801725d8>] (__clocksource_update_freq_scale) from [<801726c4>]
>> (__clocksource_register_scale+0x14/0xa8)
>> [<801726c4>] (__clocksource_register_scale) from [<8081be20>]
>> (arch_timer_common_init+0x1d8/0x230)
>> [<8081be20>] (arch_timer_common_init) from [<8081c0dc>]
>> (arch_timer_of_init+0x264/0x2c8)
>> [<8081c0dc>] (arch_timer_of_init) from [<8081bb14>]
>> (clocksource_probe+0x54/0x90)
>> [<8081bb14>] (clocksource_probe) from [<80800b30>]
>> (start_kernel+0x240/0x378)
>> [<80800b30>] (start_kernel) from [<4000807c>] (0x4000807c)
>> clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0x0,
>> max_idle_ns: 0 ns
>> Division by zero in kernel.
>> CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W       4.7.0-rc7 #5
>> Hardware name: Generic DT based system
>> [<8010e2a0>] (unwind_backtrace) from [<8010b270>] (show_stack+0x10/0x14)
>> [<8010b270>] (show_stack) from [<8030e734>] (dump_stack+0x84/0x98)
>> [<8030e734>] (dump_stack) from [<8030c764>] (Ldiv0_64+0x8/0x18)
>> [<8030c764>] (Ldiv0_64) from [<80172288>]
>> (clocks_calc_mult_shift+0x11c/0x13c)
>> [<80172288>] (clocks_calc_mult_shift) from [<8080a388>]
>> (sched_clock_register+0x64/0x1d8)
>> [<8080a388>] (sched_clock_register) from [<8081be54>]
>> (arch_timer_common_init+0x20c/0x230)
>> [<8081be54>] (arch_timer_common_init) from [<8081c0dc>]
>> (arch_timer_of_init+0x264/0x2c8)
>> [<8081c0dc>] (arch_timer_of_init) from [<8081bb14>]
>> (clocksource_probe+0x54/0x90)
>> [<8081bb14>] (clocksource_probe) from [<80800b30>]
>> (start_kernel+0x240/0x378)
>> [<80800b30>] (start_kernel) from [<4000807c>] (0x4000807c)
>> Division by zero in kernel.
>> CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W       4.7.0-rc7 #5
>> Hardware name: Generic DT based system
>> [<8010e2a0>] (unwind_backtrace) from [<8010b270>] (show_stack+0x10/0x14)
>> [<8010b270>] (show_stack) from [<8030e734>] (dump_stack+0x84/0x98)
>> [<8030e734>] (dump_stack) from [<8030c764>] (Ldiv0_64+0x8/0x18)
>> [<8030c764>] (Ldiv0_64) from [<80172360>]
>> (clocks_calc_max_nsecs+0x24/0x78)
>> [<80172360>] (clocks_calc_max_nsecs) from [<8080a3cc>]
>> (sched_clock_register+0xa8/0x1d8)
>> [<8080a3cc>] (sched_clock_register) from [<8081be54>]
>> (arch_timer_common_init+0x20c/0x230)
>> [<8081be54>] (arch_timer_common_init) from [<8081c0dc>]
>> (arch_timer_of_init+0x264/0x2c8)
>> [<8081c0dc>] (arch_timer_of_init) from [<8081bb14>]
>> (clocksource_probe+0x54/0x90)
>> [<8081bb14>] (clocksource_probe) from [<80800b30>]
>> (start_kernel+0x240/0x378)
>> [<80800b30>] (start_kernel) from [<4000807c>] (0x4000807c)
>> sched_clock: 56 bits at 0 Hz, resolution 0ns, wraps every 0ns
>> Console: colour dummy device 80x30
>> Calibrating delay loop...
>>
>>
>> When it works (which tends to be around every 5. try), then the clock of
>> the Architected timer seems to be correctly identified:
>> Architected cp15 timer(s) running at 8.00MHz (virt).
>>
>> Host looks good:
>> # dmesg | grep Architected
>> [    0.000000] Architected cp15 timer(s) running at 8.00MHz (phys).
>>
>> Afaict, U-Boot correctly initializes the timers frequency in
>> arch/arm/imx-common/syscounter.c.
> 
> It certainly does, but probably only on the boot CPU, whereas it should
> be set on all CPUs (this is a per-CPU register). If your guest boots on
> a secondary CPU, it will find zero as its CNTFRQ, and barf.
> 

Oh I see, that totally explains the behavior I am seeing...

>>
>> The guest is using a vanilla v4.7-rc7 kernel.
>>
>> The host is running without CONFIG_KVM_NEW_VGIC.
>>
>> Looks like some kind of race during initialization...? Related to the
>> new VGIC issue?
> 
> Completely unrelated. Clearly, u-boot is bogus on your system. This bit
> of code:
> 
> http://git.denx.de/?p=u-boot.git;a=blob;f=arch/arm/cpu/armv7/nonsec_virt.S;h=95ce9387b83e972414b6de2d5711a9f40fe097df;hb=HEAD#l185
> 
> is what should be doing the job. It must be called on each CPU, before
> switching to non-secure mode.

... and yes, after defining CONFIG_TIMER_CLK_FREQ it works always! Will
send a patch to the U-Boot ML, thanks!

--
Stefan
