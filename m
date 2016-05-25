From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: The VM can not start
Date: Wed, 25 May 2016 13:49:31 +0100
Message-ID: <57459F5B.8040509@arm.com>
References: <7cf68d7e.b48b.154e7c60d2e.Coremail.zm290293817@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CBBDD49B3F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2016 08:45:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id emrY52JBrPEr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 May 2016 08:45:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DFA049B3B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2016 08:45:57 -0400 (EDT)
In-Reply-To: <7cf68d7e.b48b.154e7c60d2e.Coremail.zm290293817@163.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: zhumin <zm290293817@163.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

[Please do NOT send HTML emails to this mailing list]

On 25/05/16 12:56, zhumin wrote:
> *Hello everyone:*
> *I try to put some function of hyp.S(in the EL2) to the EL3, and I
> implement it in Linux kernel 3.18.*

What function? Why?

> *But when I start the VM using the lkvm tool, the VM cannot start normally.*
> *The output message like these:*
> terminal_0: Listening for serial connection on port 5000
> terminal_1: Listening for serial connection on port 5001
> terminal_2: Listening for serial connection on port 5002
> terminal_3: Listening for serial connection on port 5003
> Visualization web server started on port 2001
> Simulation is started
> Initializing cgroup subsys cpu
> Linux version 3.14.43 (zm@centospc) (gcc version 4.9.1 20140529
> (prerelease) (crosstool-NG linaro-1.13.1-4.9-2014.07 - Linaro GCC
> 4.9-2014.06) ) #1 SMP PREEMPT Sat Jun 13 17:19:23 CST 2015
> CPU: AArch64 Processor [410fd000] revision 0
> bootconsole [earlycon0] enabled
> cma: CMA: reserved 16 MiB at 9f000000
> psci: probing function IDs from device-tree
> PERCPU: Embedded 10 pages/cpu @ffffffc01efeb000 s11328 r8192 d21440 u40960
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 129280
> Kernel command line: pci=firmware earlyprintk=smh console=hvc0
> root=/dev/vda init=/bin/sh
> PID hash table entries: 2048 (order: 2, 16384 bytes)
> Dentry cache hash table entries: 65536 (order: 7, 524288 bytes)
> Inode-cache hash table entries: 32768 (order: 6, 262144 bytes)
> software IO TLB [mem 0x9a000000-0x9e000000] (64MB) mapped at
> [ffffffc01a000000-ffffffc01dffffff]
> Memory: 420452K/524288K available (4120K kernel code, 288K rwdata, 1504K
> rodata, 191K init, 165K bss, 103836K reserved)
> Virtual kernel memory layout:
>     vmalloc : 0xffffff8000000000 - 0xffffffbbffff0000   (245759 MB)
>     vmemmap : 0xffffffbc01c00000 - 0xffffffbc02300000   (     7 MB)
>     modules : 0xffffffbffc000000 - 0xffffffc000000000   (    64 MB)
>     memory  : 0xffffffc000000000 - 0xffffffc020000000   (   512 MB)
>       .init : 0xffffffc000600000 - 0xffffffc00062fc40   (   192 kB)
>       .text : 0xffffffc000080000 - 0xffffffc0005ff1d4   (  5629 kB)
>       .data : 0xffffffc000630000 - 0xffffffc0006782a0   (   289 kB)
> SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> Preemptible hierarchical RCU implementation.
>     RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=1.
> RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=1
> NR_IRQS:64 nr_irqs:64 0
> Architected cp15 timer(s) running at 100.00MHz (virt).
> sched_clock: 56 bits at 100MHz, resolution 10ns, wraps every 2748779069440ns
> Console: colour dummy device 80x25
> Calibrating delay loop (skipped), value calculated using timer
> frequency.. 200.00 BogoMIPS (lpj=1000000)
> pid_max: default: 32768 minimum: 301
> Mount-cache hash table entries: 1024 (order: 1, 8192 bytes)
> Mountpoint-cache hash table entries: 1024 (order: 1, 8192 bytes)
> hw perfevents: enabled with arm/armv8-pmuv3 PMU driver, 1 counters available
> *Then the system is stopped there.*
> *While in the normal execution, the system should continue as follows: *
> Brought up 1 CPUs
> SMP: Total of 1 processors activated.
> devtmpfs: initialized
> atomic64 test passed
> regulator-dummy: no parameters
> NET: Registered protocol family 16
> vdso: 2 pages (1 code, 1 data) at base ffffffc000635000
> hw-breakpoint: found 16 breakpoint and 16 watchpoint registers.
> Serial: AMBA PL011 UART driver
> bio: create slab <bio-0> at 0
> SCSI subsystem initialized
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> Switched to clocksource arch_sys_counter
> NET: Registered protocol family 2
> TCP established hash table entries: 4096 (order: 3, 32768 bytes)
> TCP bind hash table entries: 4096 (order: 4, 65536 bytes)
> TCP: Hash tables configured (established 4096 bind 4096)
> TCP: reno registered
> UDP hash table entries: 256 (order: 1, 8192 bytes)
> UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
> NET: Registered protocol family 1
> RPC: Registered named UNIX socket transport module.
> RPC: Registered udp transport module.
> RPC: Registered tcp transport module.
> RPC: Registered tcp NFSv4.1 backchannel transport module.
> kvm [1]: HYP mode not available
> futex hash table entries: 256 (order: 2, 16384 bytes)
> fuse init (API version 7.22)
> 9p: Installing v9fs 9p2000 file system support
> msgmni has been set to 853
> io scheduler noop registered
> io scheduler cfq registered (default)
> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
> 3f8.U6_16550A: ttyS0 at MMIO 0x3f8 (irq = 32, base_baud = 115200) is a
> 16550A
> 2f8.U6_16550A: ttyS1 at MMIO 0x2f8 (irq = 33, base_baud = 115200) is a
> 16550A
> 3e8.U6_16550A: ttyS2 at MMIO 0x3e8 (irq = 34, base_baud = 115200) is a
> 16550A
> 2e8.U6_16550A: ttyS3 at MMIO 0x2e8 (irq = 35, base_baud = 115200) is a
> 16550A
> console [hvc0] enabled
> bootconsole [earlycon0] disabled
> So, what's the problem is?

I bet you don't have any interrupts delivered to your guest.

> Can someone give me some advice or feedback?

Not really, unless you try to explain what you're trying to achieve.
Using EL3 to do the job of EL2 is at best weird, and feels like a school
project gone horribly wrong...

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
