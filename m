From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: 4.15-rc1 crash on Midway in teardown_hyp_mode()
Date: Wed, 6 Dec 2017 14:17:57 +0000
Message-ID: <10746458-42bd-c50f-3075-49811018099a@arm.com>
References: <45e72322-52dd-4fdb-2e51-176524fb56a8@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35F5D40651
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 09:14:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CjUfiVlyDcyT for <kvmarm@lists.cs.columbia.edu>;
 Wed,  6 Dec 2017 09:14:44 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E19649D66
 for <kvmarm@lists.cs.columbia.edu>; Wed,  6 Dec 2017 09:14:44 -0500 (EST)
In-Reply-To: <45e72322-52dd-4fdb-2e51-176524fb56a8@arm.com>
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
To: Marc Zyngier <Marc.Zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Rob Herring <robh@kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 06/12/17 14:11, Andre Przywara wrote:
> Hi,
> 
> while trying to boot 4.15-rc1 on my Calxeda Midway I observed a crash
> (see below). I can't look further into this today, but wanted to report
> this anyway.
> 
> Digging around a bit this is due to the VGIC not initializing properly
> due to GICC being advertised as just 4K, not 8K.
> This can be worked around by adjusting the DT or using
> irqchip.gicv2_force_probe. However this still raises some questions:
> 1) Even if the VGIC fails to register, we should certainly not crash.
> The chain of events seems to be:
> virt/kvm/arm/arm.c:init_subsystems():
>   - kvm_vgic_hyp_init() returns -ENODEV, this leads to vgic_present
>     being set to false, but "err" being reset to 0 (meaning: carry on).
>     However this seems now to miss some initialization.
>   - kvm_timer_hyp_init() now fails on calling irq_set_vcpu_affinity(),
>     because this returns -ENOSYS. This leads to it returning this error,
>     init_subsystems() failing and subsequently tearing down KVM.
>   - This seems to have some bug and leads to the kernel crash.
> 
> Even with the VGIC not being usable, we should be able to cleanly tear
> down KVM (or HYP?).

Just checked: If I let kvm_timer_hyp_init() deliberately fail in 4.14, I
get the same splat (4.14 works fine, otherwise). So this particular
issue existed already before. You should be able to reproduce it on any
box by forcing "err = -ENOSYS;" after the call to kvm_timer_hyp_init()
in virt/kvm/arm/arm.c:init_subsystems().

Cheers,
Andre

> 
> 2) Is it intended that an unusable VGIC now denies KVM entirely? I
> believe in the past we could live with that (no arch timer
> virtualization, no in-kernel GIC emulation) and rely on userland
> emulation (for instance in QEMU). This seemed to have changed now?
> 3) Wouldn't it be smarter to fix up the GICC range by default, if we
> have enough evidence that the GICC is actually 8K? Shouldn't this be
> true for every architecture compliant GICv2, actually? So whenever we
> see "arm,cortex-a15-gic", for instance, we force GICC to 8K?
> Or do we know of GICs which have only 4K, but advertise themselves
> wrongly? Otherwise this could just go as some firmware quirk, based on a
> compatible string, for instance, or some ID registers.
> 
> The reason I am asking is that the Midway loads the DT from firmware
> flash, and this one hasn't changed in years (for obvious reasons). So
> while *I* am able to update the DT in the SPI flash, I guess many users
> just won't do so, so they are left with a crashing kernel (or loosing
> KVM), starting from 4.15. All the previous kernels booted and ran KVM
> guests fine in the past with the existing DT.
> 
> Cheers,
> Andre.
> 
> ----------------
> Booting Linux on physical CPU 0x0
> Linux version 4.15.0-rc2-00174-g328b4ed93b69-dirty
> (andprz01@e104803-lin) (gcc version 5.3.0 (GCC)) #614 SMP Wed Dec 6
> 12:19:02 GMT 2017
> CPU: ARMv7 Processor [413fc0f2] revision 2 (ARMv7), cr=30c5387d
> CPU: div instructions available: patching division code
> CPU: PIPT / VIPT nonaliasing data cache, PIPT instruction cache
> OF: fdt: Machine model: Calxeda ECX-2000
> Memory policy: Data cache writealloc
> efi: Getting EFI parameters from FDT:
> efi: UEFI not found.
> cma: Reserved 64 MiB at 0x00000000fb800000
> psci: probing for conduit method from DT.
> psci: Using PSCI v0.1 Function IDs from DT
> percpu: Embedded 18 pages/cpu @(ptrval) s42240 r8192 d23296 u73728
> Built 1 zonelists, mobility grouping on.  Total pages: 2093568
> Kernel command line: console=ttyAMA0,115200n8 ro root=/dev/sda7
> Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
> Memory: 8225660K/8380416K available (12288K kernel code, 1565K rwdata,
> 4052K rodata, 2048K init, 564K bss, 89220K reserved, 65536K
> cma-reserved, 7528448K highmem)
> Virtual kernel memory layout:
>     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
>     fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
>     vmalloc : 0xf0800000 - 0xff800000   ( 240 MB)
>     lowmem  : 0xc0000000 - 0xf0000000   ( 768 MB)
>     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
>     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
>       .text : 0x(ptrval) - 0x(ptrval)   (14304 kB)
>       .init : 0x(ptrval) - 0x(ptrval)   (2048 kB)
>       .data : 0x(ptrval) - 0x(ptrval)   (1566 kB)
>        .bss : 0x(ptrval) - 0x(ptrval)   ( 565 kB)
> SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> ftrace: allocating 46629 entries in 137 pages
> Hierarchical RCU implementation.
>         RCU restricting CPUs from NR_CPUS=16 to nr_cpu_ids=4.
> RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
> NR_IRQS: 16, nr_irqs: 16, preallocated irqs: 16
> GIC: GICv2 detected, but range too small and irqchip.gicv2_force_probe
> not set
> arch_timer: cp15 timer(s) running at 150.00MHz (phys).
> clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles:
> 0x2298375bd0, max_idle_ns: 440795208267 ns
> sched_clock: 56 bits at 150MHz, resolution 6ns, wraps every 2199023255551ns
> Switching to timer-based delay loop, resolution 6ns
> clocksource: arm,sp804: mask: 0xffffffff max_cycles: 0xffffffff,
> max_idle_ns: 12741736309 ns
> sched_clock: 32 bits at 150MHz, resolution 6ns, wraps every 14316557820ns
> Console: colour dummy device 80x30
> Calibrating delay loop (skipped), value calculated using timer
> frequency.. 300.00 BogoMIPS (lpj=1500000)
> pid_max: default: 32768 minimum: 301
> Mount-cache hash table entries: 2048 (order: 1, 8192 bytes)
> Mountpoint-cache hash table entries: 2048 (order: 1, 8192 bytes)
> CPU: Testing write buffer coherency: ok
> /cpus/cpu@0 missing clock-frequency property
> /cpus/cpu@1 missing clock-frequency property
> /cpus/cpu@2 missing clock-frequency property
> /cpus/cpu@3 missing clock-frequency property
> CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
> Setting up static identity map for 0x400000 - 0x400178
> Hierarchical SRCU implementation.
> EFI services will not be available.
> smp: Bringing up secondary CPUs ...
> CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
> CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
> CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
> smp: Brought up 1 node, 4 CPUs
> SMP: Total of 4 processors activated (1200.00 BogoMIPS).
> CPU: All CPU(s) started in HYP mode.
> CPU: Virtualization extensions available.
> devtmpfs: initialized
> random: get_random_u32 called from bucket_table_alloc+0xf8/0x24c with
> crng_init=0
> VFP support v0.3: implementor 41 architecture 4 part 30 variant f rev 0
> clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff,
> max_idle_ns: 19112604462750000 ns
> futex hash table entries: 1024 (order: 5, 131072 bytes)
> pinctrl core: initialized pinctrl subsystem
> DMI not present or invalid.
> NET: Registered protocol family 16
> DMA: preallocated 256 KiB pool for atomic coherent allocations
> cpuidle: using governor ladder
> cpuidle: using governor menu
> hw-breakpoint: found 5 (+1 reserved) breakpoint and 4 watchpoint registers.
> hw-breakpoint: maximum watchpoint size is 8 bytes.
> Serial: AMBA PL011 UART driver
> fff36000.serial: ttyAMA0 at MMIO 0xfff36000 (irq = 31, base_baud = 0) is
> a PL011 rev3
> console [ttyAMA0] enabled
> AT91: Could not find identification node
> vgaarb: loaded
> SCSI subsystem initialized
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> pps_core: LinuxPPS API ver. 1 registered
> pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti
> <giometti@linux.it>
> PTP clock support registered
> EDAC MC: Ver: 3.0.0
> dmi: Firmware registration failed.
> clocksource: Switched to clocksource arch_sys_counter
> NET: Registered protocol family 2
> TCP established hash table entries: 8192 (order: 3, 32768 bytes)
> TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
> TCP: Hash tables configured (established 8192 bind 8192)
> UDP hash table entries: 512 (order: 2, 16384 bytes)
> UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
> NET: Registered protocol family 1
> RPC: Registered named UNIX socket transport module.
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> RPC: Registered tcp NFSv4.1 backchannel transport module.
> kvm [1]: 8-bit VMID
> kvm [1]: IDMAP page: 401000
> kvm [1]: HYP VA range: c0000000:ffffffff
> kvm_vgic_hyp_init() returns 0, vgic_present: 0
> kvm [1]: == kvm_timer_hyp_init: host_vtimer_irq: 19
> kvm [1]: == kvm_timer_hyp_init: host_vtimer_irq_flags: 8
> kvm [1]: == kvm_timer_hyp_init: request_percpu_irq() returned 0
> kvm [1]: kvm_arch_timer: error setting vcpu affinity: -38
> disabling KVM arch hardware on each CPU
>  ... done that.
> Unable to handle kernel paging request at virtual address 40000000
> pgd = (ptrval)
> [40000000] *pgd=80000000205003, *pmd=00000000
> Internal error: Oops: 206 [#1] SMP ARM
> Modules linked in:
> CPU: 1 PID: 1 Comm: swapper/0 Not tainted
> 4.15.0-rc2-00174-g328b4ed93b69-dirty #614
> Hardware name: Highbank
> PC is at unmap_hyp_range+0x15c/0x3f8
> LR is at free_hyp_pgds+0x168/0x1a0
> pc : [<c041a3a8>]    lr : [<c041bda8>]    psr: 80000013
> sp : ed11fda0  ip : ed11fe10  fp : ed11fe0c
> r10: 40000000  r9 : 00000000  r8 : 00000000
> r7 : c19ba980  r6 : 00200000  r5 : 00000000  r4 : 3fffffff
> r3 : 40000000  r2 : c19ba980  r1 : 00000000  r0 : 001fffff
> Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
> Control: 30c5387d  Table: 00203000  DAC: 55555555
> Process swapper/0 (pid: 1, stack limit = 0x(ptrval))
> Stack: (0xed11fda0 to 0xed120000)
> fda0: 00000000 c19ba980 c13a5054 40000000 30800000 00000001 307fffff
> 00000001
> fdc0: 40000000 00000000 ed1b7b40 ed1b3000 3fffffff 00000000 40000000
> 00000000
> fde0: c19881f8 40000000 00000000 c19881f8 c19ba990 30800000 00000000
> ffffffda
> fe00: ed11fe3c ed11fe10 c041bda8 c041a258 40000000 00000000 c18053d0
> c177c08c
> fe20: 000053d0 0000585c c180585c c180585c ed11fe5c ed11fe40 c0417e4c
> c041bc4c
> fe40: c18053d0 00000010 c1988e48 c19881e8 ed11fe94 ed11fe60 c0419ee8
> c0417e30
> fe60: ed11febc 00000000 c1602568 c1987800 c0417e9c 00000000 00000000
> 00000ee8
> fe80: c1987800 00000153 ed11fecc ed11fe98 c040c94c c0419c0c c1987800
> c1987840
> fea0: ed11febc ed11feb0 c1987800 c0417e9c c1600640 c16dc83c 00000000
> c1987800
> fec0: ed11fedc ed11fed0 c0417ec4 c040c930 ed11ff4c ed11fee0 c0402470
> c0417ea8
> fee0: c1600664 c0f5f9c8 c13f4f50 00000153 ed11ff4c ed11ff00 c0489724
> c160064c
> ff00: c129317c 00000006 00000006 00000000 c13f34d4 c136a0d8 efffca9c
> efffcaa1
> ff20: 00000000 c1987800 c16dc830 c1987800 c16dc834 c1600640 c16dc83c
> 00000006
> ff40: ed11ff94 ed11ff50 c1600f74 c040242c 00000006 00000006 00000000
> c1600640
> ff60: 00000001 c177a164 00000000 00000000 c0f65544 00000000 00000000
> 00000000
> ff80: 00000000 00000000 ed11ffac ed11ff98 c0f6555c c1600e2c 00000000
> c0f65544
> ffa0: 00000000 ed11ffb0 c042be58 c0f65550 00000000 00000000 00000000
> 00000000
> ffc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> 00000000
> ffe0: 00000000 00000000 00000000 00000000 00000013 00000000 ed11fff4
> 00000000
> [<c041a3a8>] (unmap_hyp_range) from [<c041bda8>] (free_hyp_pgds+0x168/0x1a0)
> [<c041bda8>] (free_hyp_pgds) from [<c0417e4c>] (teardown_hyp_mode+0x28/0x78)
> [<c0417e4c>] (teardown_hyp_mode) from [<c0419ee8>]
> (kvm_arch_init+0x2e8/0x51c)
> [<c0419ee8>] (kvm_arch_init) from [<c040c94c>] (kvm_init+0x28/0x2bc)
> [<c040c94c>] (kvm_init) from [<c0417ec4>] (arm_init+0x28/0x2c)
> [<c0417ec4>] (arm_init) from [<c0402470>] (do_one_initcall+0x50/0x17c)
> [<c0402470>] (do_one_initcall) from [<c1600f74>]
> (kernel_init_freeable+0x154/0x1f4)
> [<c1600f74>] (kernel_init_freeable) from [<c0f6555c>]
> (kernel_init+0x18/0x124)
> [<c0f6555c>] (kernel_init) from [<c042be58>] (ret_from_fork+0x14/0x3c)
> Code: e1510005 e1a06a86 e2460001 01500004 (e1c300d0)
> ---[ end trace affbac93bd070906 ]---
> Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> 
> CPU3: stopping
> CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D
> 4.15.0-rc2-00174-g328b4ed93b69-dirty #614
> Hardware name: Highbank
> [<c043644c>] (unwind_backtrace) from [<c04304ec>] (show_stack+0x20/0x24)
> [<c04304ec>] (show_stack) from [<c0f4f034>] (dump_stack+0x98/0xac)
> [<c0f4f034>] (dump_stack) from [<c0433f84>] (handle_IPI+0x2d0/0x350)
> [<c0433f84>] (handle_IPI) from [<c0401954>] (gic_handle_irq+0xa8/0xac)
> [<c0401954>] (gic_handle_irq) from [<c04310b8>] (__irq_svc+0x58/0x74)
> Exception stack(0xed155f28 to 0xed155f70)
> 5f20:                   00000001 00000000 00000000 c0440ba0 c18052cc
> ed154000
> 5f40: c1805338 00000008 c17847b8 00000000 00000000 ed155f84 ed155f88
> ed155f78
> 5f60: c042c954 c042c958 60000013 ffffffff
> [<c04310b8>] (__irq_svc) from [<c042c958>] (arch_cpu_idle+0x48/0x4c)
> [<c042c958>] (arch_cpu_idle) from [<c0f6c7f8>] (default_idle_call+0x30/0x3c)
> [<c0f6c7f8>] (default_idle_call) from [<c04aa33c>] (do_idle+0x194/0x228)
> [<c04aa33c>] (do_idle) from [<c04aa67c>] (cpu_startup_entry+0x28/0x2c)
> [<c04aa67c>] (cpu_startup_entry) from [<c0433a68>]
> (secondary_start_kernel+0x160/0x16c)
> [<c0433a68>] (secondary_start_kernel) from [<004021ec>] (0x4021ec)
> CPU2: stopping
> CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D
> 4.15.0-rc2-00174-g328b4ed93b69-dirty #614
> Hardware name: Highbank
> [<c043644c>] (unwind_backtrace) from [<c04304ec>] (show_stack+0x20/0x24)
> [<c04304ec>] (show_stack) from [<c0f4f034>] (dump_stack+0x98/0xac)
> [<c0f4f034>] (dump_stack) from [<c0433f84>] (handle_IPI+0x2d0/0x350)
> [<c0433f84>] (handle_IPI) from [<c0401954>] (gic_handle_irq+0xa8/0xac)
> [<c0401954>] (gic_handle_irq) from [<c04310b8>] (__irq_svc+0x58/0x74)
> Exception stack(0xed153f28 to 0xed153f70)
> 3f20:                   00000001 00000000 00000000 c0440ba0 c18052cc
> ed152000
> 3f40: c1805338 00000004 c17847b8 00000000 00000000 ed153f84 ed153f88
> ed153f78
> 3f60: c042c954 c042c958 60000013 ffffffff
> [<c04310b8>] (__irq_svc) from [<c042c958>] (arch_cpu_idle+0x48/0x4c)
> [<c042c958>] (arch_cpu_idle) from [<c0f6c7f8>] (default_idle_call+0x30/0x3c)
> [<c0f6c7f8>] (default_idle_call) from [<c04aa33c>] (do_idle+0x194/0x228)
> [<c04aa33c>] (do_idle) from [<c04aa67c>] (cpu_startup_entry+0x28/0x2c)
> [<c04aa67c>] (cpu_startup_entry) from [<c0433a68>]
> (secondary_start_kernel+0x160/0x16c)
> [<c0433a68>] (secondary_start_kernel) from [<004021ec>] (0x4021ec)
> CPU0: stopping
> CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D
> 4.15.0-rc2-00174-g328b4ed93b69-dirty #614
> Hardware name: Highbank
> [<c043644c>] (unwind_backtrace) from [<c04304ec>] (show_stack+0x20/0x24)
> [<c04304ec>] (show_stack) from [<c0f4f034>] (dump_stack+0x98/0xac)
> [<c0f4f034>] (dump_stack) from [<c0433f84>] (handle_IPI+0x2d0/0x350)
> [<c0433f84>] (handle_IPI) from [<c0401954>] (gic_handle_irq+0xa8/0xac)
> [<c0401954>] (gic_handle_irq) from [<c04310b8>] (__irq_svc+0x58/0x74)
> Exception stack(0xc1801ed8 to 0xc1801f20)
> 1ec0:                                                       00000001
> 00000000
> 1ee0: 00000000 c0440ba0 c18052cc c1800000 c1805338 00000001 c17847b8
> 00000000
> 1f00: 00000000 c1801f34 c1801f38 c1801f28 c042c954 c042c958 60000013
> ffffffff
> [<c04310b8>] (__irq_svc) from [<c042c958>] (arch_cpu_idle+0x48/0x4c)
> [<c042c958>] (arch_cpu_idle) from [<c0f6c7f8>] (default_idle_call+0x30/0x3c)
> [<c0f6c7f8>] (default_idle_call) from [<c04aa33c>] (do_idle+0x194/0x228)
> [<c04aa33c>] (do_idle) from [<c04aa67c>] (cpu_startup_entry+0x28/0x2c)
> [<c04aa67c>] (cpu_startup_entry) from [<c0f65540>] (rest_init+0xbc/0xc0)
> [<c0f65540>] (rest_init) from [<c1600e14>] (start_kernel+0x3d4/0x3e0)
> [<c1600e14>] (start_kernel) from [<00000000>] (  (null))
> ---[ end Kernel panic - not syncing: Attempted to kill init!
> exitcode=0x0000000b
> 
