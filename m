From: Itaru Kitayama <itaru.kitayama@riken.jp>
Subject: Re: [PULL 00/29] KVM/ARM Changes for v4.7
Date: Sun, 15 May 2016 22:30:40 +0900
Message-ID: <424fb79c-bf73-ba4d-7a66-f7ce72dee897@riken.jp>
References: <e368c757-f5a8-d3be-8b67-8270c756bd2b@riken.jp>
 <CAMJs5B-dGpg++5__cu2WOp40M0xwQjrPFfGhVhiLvnc6AkGiug@mail.gmail.com>
 <7292cb91-39d9-b859-b219-722db5c5dca4@riken.jp>
 <CAMJs5B_Csdt=BPFc36WtjqVwOdn_4+O6MOKCshEHrmepiEgpxA@mail.gmail.com>
 <90cab3e7-7eb3-cb76-5312-af68ee5af7eb@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E5C549B1A
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2016 09:27:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Gou2al0ljwAc for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 May 2016 09:27:35 -0400 (EDT)
Received: from postman.riken.jp (postman2.riken.jp [134.160.33.84])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BA13412DD
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2016 09:27:34 -0400 (EDT)
In-Reply-To: <90cab3e7-7eb3-cb76-5312-af68ee5af7eb@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Julien, Christoffer,

Below is the boot log of linux-next.


EFI stub: Booting Linux Kernel...
EFI stub: Using DTB from configuration table
EFI stub: Exiting boot services and installing virtual address map...
L3C: 8MB
Booting Linux on physical CPU 0x0
Linux version 4.6.0-rc7-next-20160513 (itaru.kitayama@r2-a11) (gcc 
version 5.3.1 20160406 (Red Hat 5.3.1-6) (GCC) ) #6 SMP PREEMPT Sun May 
15 08:21:01 CDT 2016
Boot CPU: AArch64 Processor [500f0000]
earlycon: uart0 at MMIO32 0x000000001c020000 (options '')
bootconsole [uart0] enabled
efi: Getting EFI parameters from FDT:
efi: EFI v2.40 by X-Gene Mustang Board EFI Jan 27 2016 18:27:58
efi:  ACPI=0x43fa859000  ACPI 2.0=0x43fa859014  SMBIOS 3.0=0x43fa857000
cma: Reserved 512 MiB at 0x00000040e0000000
ACPI: Early table checksum verification enabled
ACPI: RSDP 0x00000043FA859014 000024 (v02 APM   )
ACPI: XSDT 0x00000043FA8580E8 00007C (v01 APM    XGENE    00000003 
01000013)
ACPI: FACP 0x00000043FA850000 00010C (v05 APM    XGENE    00000003 INTL 
20140724)
ACPI: DSDT 0x00000043FA851000 003A00 (v05 APM    APM88xxx 00000001 INTL 
20140724)
ACPI: DBG2 0x00000043FA855000 0000AA (v00 APMC0D XGENEDBG 00000000 INTL 
20140724)
ACPI: GTDT 0x00000043FA84E000 0000E0 (v02 APM    XGENE    00000001 INTL 
20140724)
ACPI: MCFG 0x00000043FA84D000 00003C (v01 APM    XGENE    00000002 INTL 
20140724)
ACPI: SPCR 0x00000043FA84C000 000050 (v02 APMC0D XGENESPC 00000000 INTL 
20140724)
ACPI: SSDT 0x00000043FA84B000 00002D (v02 APM    XGENE    00000001 INTL 
20140724)
ACPI: BERT 0x00000043FA84A000 000030 (v01 APM    XGENE    00000002 INTL 
20140724)
ACPI: HEST 0x00000043FA849000 0002A8 (v01 APM    XGENE    00000002 INTL 
20140724)
ACPI: APIC 0x00000043FA848000 0002A4 (v03 APM    XGENE    00000003 
01000013)
ACPI: SSDT 0x00000043FA847000 000063 (v02 REDHAT MACADDRS 00000001 
01000013)
ACPI: SSDT 0x00000043FA846000 000032 (v02 REDHAT UARTCLKS 00000001 
01000013)
On node 0 totalpages: 262144
   DMA zone: 64 pages used for memmap
   DMA zone: 0 pages reserved
   DMA zone: 65536 pages, LIFO batch:1
   Normal zone: 192 pages used for memmap
   Normal zone: 196608 pages, LIFO batch:1
psci: is not implemented in ACPI.
percpu: Embedded 3 pages/cpu @ffff8003ffde0000 s110208 r8192 d78208 u196608
pcpu-alloc: s110208 r8192 d78208 u196608 alloc=3*65536
pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7
Detected PIPT I-cache on CPU0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 261888
Kernel command line: BOOT_IMAGE=/vmlinuz-4.6.0-rc7-next-20160513 
root=UUID=ac9f9264-7572-48c3-97d2-042ea95f7640 ro acpi=force 
acpi_force_table_verification earlycon=uart,mmio32,0x1c020000 
console=ttyS0,115200 loglevel=8 LANG=en_US.UTF-8
log_buf_len individual max cpu contribution: 4096 bytes
log_buf_len total cpu_extra contributions: 28672 bytes
log_buf_len min size: 16384 bytes
log_buf_len: 65536 bytes
early log buf free: 13072(79%)
PID hash table entries: 4096 (order: -1, 32768 bytes)
Dentry cache hash table entries: 2097152 (order: 8, 16777216 bytes)
Inode-cache hash table entries: 1048576 (order: 7, 8388608 bytes)
software IO TLB [mem 0x40dbff0000-0x40dfff0000] (64MB) mapped at 
[ffff8000dbff0000-ffff8000dffeffff]
Memory: 16070272K/16777216K available (22780K kernel code, 8781K rwdata, 
7680K rodata, 1920K init, 16628K bss, 182656K reserved, 524288K 
cma-reserved)
Virtual kernel memory layout:
     modules : 0xffff000000000000 - 0xffff000008000000   (   128 MB)
     vmalloc : 0xffff000008000000 - 0xffff7bdfffff0000   (126847 GB)
       .text : 0xffff000008080000 - 0xffff0000096b0000   ( 22720 KB)
     .rodata : 0xffff0000096b0000 - 0xffff000009e40000   (  7744 KB)
       .init : 0xffff000009e40000 - 0xffff00000a020000   (  1920 KB)
       .data : 0xffff00000a020000 - 0xffff00000a8b3600   (  8782 KB)
        .bss : 0xffff00000a8b3600 - 0xffff00000b8f0760   ( 16629 KB)
     fixed   : 0xffff7fdffe7d0000 - 0xffff7fdffec00000   (  4288 KB)
     PCI I/O : 0xffff7fdffee00000 - 0xffff7fdfffe00000   (    16 MB)
     vmemmap : 0xffff7fe000000000 - 0xffff800000000000   (   128 GB maximum)
               0xffff7fe000000000 - 0xffff7fe001000000   (    16 MB actual)
     memory  : 0xffff800000000000 - 0xffff800400000000   ( 16384 MB)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Preemptible hierarchical RCU implementation.
	Build-time adjustment of leaf fanout to 64.
NR_IRQS:64 nr_irqs:64 0
GIC: Using split EOI/Deactivate mode
GICv3: No distributor detected at @ffff000008060000, giving up
Architected cp15 timer(s) running at 50.00MHz (phys).
clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 
0xb8812736b, max_idle_ns: 440795202655 ns
sched_clock: 56 bits at 50MHz, resolution 20ns, wraps every 4398046511100ns
Console: colour dummy device 80x25
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8191
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     32768
... MAX_LOCKDEP_CHAINS:      65536
... CHAINHASH_SIZE:          32768
  memory used by lock dependency info: 8127 kB
  per task-struct memory footprint: 1920 bytes
Calibrating delay loop (skipped), value calculated using timer 
frequency.. 100.00 BogoMIPS (lpj=200000)
pid_max: default: 32768 minimum: 301
ACPI: Core revision 20160422
Security Framework initialized
Mount-cache hash table entries: 32768 (order: 2, 262144 bytes)
Mountpoint-cache hash table entries: 32768 (order: 2, 262144 bytes)
ftrace: allocating 29581 entries in 8 pages
ASID allocator initialised with 65536 entries
Remapping and enabling EFI services.
   EFI remap 0x0000000010510000 => 0000000020000000
   EFI remap 0x0000000010548000 => 0000000020018000
   EFI remap 0x0000000017000000 => 0000000020020000
   EFI remap 0x000000001c025000 => 0000000020035000
   EFI remap 0x000000007c0c0000 => 0000000020040000
   EFI remap 0x000000007c1c0000 => 0000000020050000
   EFI remap 0x000000007c2c0000 => 0000000020060000
   EFI remap 0x000000007c3c0000 => 0000000020070000
   EFI remap 0x000000007c4c0000 => 0000000020080000
   EFI remap 0x000000007c5c0000 => 0000000020090000
   EFI remap 0x000000007c6c0000 => 00000000200a0000
   EFI remap 0x000000007c7c0000 => 00000000200b0000
UEFI Runtime regions are not aligned to 64 KB -- buggy firmware?
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at arch/arm64/kernel/efi.c:34 
efi_create_mapping+0x1a0/0x3b8
Modules linked in:

CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.6.0-rc7-next-20160513 #6
Hardware name: APM X-Gene Mustang board (DT)
task: ffff8003c0340000 ti: ffff8003c0400000 task.ti: ffff8003c0400000
PC is at efi_create_mapping+0x1a0/0x3b8
LR is at efi_create_mapping+0x194/0x3b8
pc : [<ffff000009e4a5a8>] lr : [<ffff000009e4a59c>] pstate: 60000245
sp : ffff8003c0403cb0
x29: ffff8003c0403cb0 x28: ffff00000a390000
x27: ffff8003f9a77468 x26: 0000000000003000
x25: 800000000000000f x24: ffff00000a2de390
x23: 0000000000000005 x22: 0000000000000001
x21: ffff00000a41d000 x20: ffff00000a8fc000
x19: ffff00000a8fc198 x18: ffff0000097fe000
x17: 0000000000000001 x16: 0000000000000000
x15: 0000000000000056 x14: 3f657261776d7269
x13: ffff00000a464f28 x12: ffff00000a465b30
x11: 0000000000000001 x10: ffff8003c0400000
x9 : 00000000000085f1 x8 : 0000000000000003
x7 : 0000000000000000 x6 : ffff00000a042000
x5 : ffff00000b3b4c58 x4 : 00000000001c115c
x3 : ffff8003c0340000 x2 : 0000000000000132
x1 : 0000000000000099 x0 : 0000000000000001

---[ end trace a2cb2e24ff35d5f8 ]---
Call trace:
Exception stack(0xffff8003c0403ac0 to 0xffff8003c0403be0)
3ac0: ffff00000a8fc198 ffff00000a8fc000 ffff8003c0403cb0 ffff000009e4a5a8
3ae0: 0000000060000245 000000000000003d 800000000000000f 0000000000003000
3b00: ffff8003f9a77468 0000000000000001 0000000000000005 ffff00000a2de390
3b20: 800000000000000f 0000000000003000 ffff8003f9a77468 ffff00000a390000
3b40: ffff00000a465ab8 0000000000000000 ffff8003c0403bd0 ffff000009cdcf70
3b60: 000000000b3071a8 0000000000000000 ffff000000000000 00000000ffffffff
3b80: ffff8003c0403cb0 ffff8003c0403cb0 0000000000000001 0000000000000099
3ba0: 0000000000000132 ffff8003c0340000 00000000001c115c ffff00000b3b4c58
3bc0: ffff00000a042000 0000000000000000 0000000000000003 00000000000085f1
[<ffff000009e4a5a8>] efi_create_mapping+0x1a0/0x3b8
[<ffff000009ee82b0>] arm_enable_runtime_services+0x26c/0x57c
[<ffff00000808366c>] do_one_initcall+0xac/0x360
[<ffff000009e41d10>] kernel_init_freeable+0xd4/0x4a8
[<ffff0000096772bc>] kernel_init+0x3c/0x368
[<ffff000008088e10>] ret_from_fork+0x10/0x40
   EFI remap 0x00000043fa813000 => 00000000200c3000
   EFI remap 0x00000043fa85a000 => 00000000200da000
   EFI remap 0x00000043ffa02000 => 00000000202c2000
   EFI remap 0x00000043ffa16000 => 00000000202d6000
Detected PIPT I-cache on CPU1
CPU1: Booted secondary processor [500f0000]
Detected PIPT I-cache on CPU2
CPU2: Booted secondary processor [500f0000]
Detected PIPT I-cache on CPU3
CPU3: Booted secondary processor [500f0000]
Detected PIPT I-cache on CPU4
CPU4: Booted secondary processor [500f0000]
Detected PIPT I-cache on CPU5
CPU5: Booted secondary processor [500f0000]
Detected PIPT I-cache on CPU6
CPU6: Booted secondary processor [500f0000]
Detected PIPT I-cache on CPU7
CPU7: Booted secondary processor [500f0000]
Brought up 8 CPUs
SMP: Total of 8 processors activated.
CPU features: detected feature: 32-bit EL0 Support
CPU: All CPU(s) started at EL2
devtmpfs: initialized
gcov: version magic: 0x35303352
SMBIOS 3.0.0 present.
clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, 
max_idle_ns: 7645041785100000 ns
pinctrl core: initialized pinctrl subsystem
NET: Registered protocol family 16
PCCT header not found.
vdso: 2 pages (1 code @ ffff0000096d0000, 1 data @ ffff00000a030000)
hw-breakpoint: found 4 breakpoint and 4 watchpoint registers.
DMA: preallocated 256 KiB pool for atomic allocations
ACPI: bus type PCI registered
Serial: AMBA PL011 UART driver
HugeTLB registered 512 MB page size, pre-allocated 0 pages
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: 4 ACPI AML tables successfully acquired and loaded

ACPI: Interpreter enabled
ACPI: Using GIC for interrupt routing
ACPI: Power Resource [SCVR] (off)
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments 
MSI]
acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
acpi PNP0A08:00: Bus 0000:00 not present in PCI namespace
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
ACPI: bus type USB registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti 
<giometti@linux.it>
PTP clock support registered
Advanced Linux Sound Architecture Driver Initialized.
clocksource: Switched to clocksource arch_sys_counter
Warning: could not register all branches stats
Warning: could not register annotated branches stats
VFS: Disk quotas dquot_6.6.0
VFS: Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
pnp: PnP ACPI init
pnp: PnP ACPI: found 0 devices
NET: Registered protocol family 2
TCP established hash table entries: 131072 (order: 4, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 4194304 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
UDP hash table entries: 8192 (order: 4, 1310720 bytes)
UDP-Lite hash table entries: 8192 (order: 4, 1310720 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
PCI: CLS 0 bytes, default 128
Unpacking initramfs...
Freeing initrd memory: 10432K (ffff8003f9a80000 - ffff8003fa4b0000)
kvm [1]: 8-bit VMID
kvm [1]: Hyp mode initialized successfully
INFO: rcu_preempt detected stalls on CPUs/tasks:
	0-...: (113 GPs behind) idle=1f9/1/0 softirq=86/86 fqs=0
	2-...: (107 GPs behind) idle=559/1/0 softirq=120/120 fqs=0
	4-...: (107 GPs behind) idle=33b/1/0 softirq=106/106 fqs=0
	5-...: (108 GPs behind) idle=333/1/0 softirq=130/130 fqs=0
	6-...: (105 GPs behind) idle=2f7/1/0 softirq=120/120 fqs=0
	7-...: (105 GPs behind) idle=327/1/0 softirq=131/131 fqs=0
	(detected by 1, t=5252 jiffies, g=-135, c=-136, q=8)
Task dump for CPU 0:
swapper/0       R  running task        0     0      0 0x00000000
Call trace:
[<ffff00000808ba20>] __switch_to+0x1c8/0x240
[<ffff00000a6276b8>] ______f.8076+0x10/0x28
Task dump for CPU 2:
swapper/2       R  running task        0     0      1 0x00000000
Call trace:
[<ffff00000808ba20>] __switch_to+0x1c8/0x240
[<000000000006a42a>] 0x6a42a
Task dump for CPU 4:
swapper/4       R  running task        0     0      1 0x00000000
Call trace:
[<ffff00000808ba20>] __switch_to+0x1c8/0x240
[<0000000000048555>] 0x48555
Task dump for CPU 5:
swapper/5       R  running task        0     0      1 0x00000000
Call trace:
[<ffff00000808ba20>] __switch_to+0x1c8/0x240
[<0000000000048554>] 0x48554
Task dump for CPU 6:
swapper/6       R  running task        0     0      1 0x00000000
Call trace:
[<ffff00000808ba20>] __switch_to+0x1c8/0x240
[<000000000004855b>] 0x4855b
Task dump for CPU 7:
swapper/7       R  running task        0     0      1 0x00000000
Call trace:
[<ffff00000808ba20>] __switch_to+0x1c8/0x240
[<000000000004855a>] 0x4855a
rcu_preempt kthread starved for 5252 jiffies! g18446744073709551481 
c18446744073709551480 f0x0 RCU_GP_WAIT_FQS(3) ->state=0x1
rcu_preempt     S ffff00000808ba20     0     7      2 0x00000000
Call trace:
[<ffff00000808ba20>] __switch_to+0x1c8/0x240
[<ffff00000967cfa8>] __schedule+0xb68/0x2558
[<ffff00000967f57c>] schedule+0xc4/0x230
[<ffff00000968d130>] schedule_timeout+0x430/0x858
[<ffff00000825dd50>] rcu_gp_kthread+0x1138/0x1ed0
[<ffff000008190744>] kthread+0x1cc/0x1e0
[<ffff000008088e10>] ret_from_fork+0x10/0x40
NMI watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [swapper/0:1]
Modules linked in:

CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W 
4.6.0-rc7-next-20160513 #6
Hardware name: AppliedMicro Mustang/Mustang, BIOS 3.05.05-beta_rc Jan 27 
2016
task: ffff8003c0340000 ti: ffff8003c0400000 task.ti: ffff8003c0400000
PC is at smp_call_function_many+0x780/0x7b0
LR is at smp_call_function_many+0x73c/0x7b0
pc : [<ffff0000082b6390>] lr : [<ffff0000082b634c>] pstate: 80000045
sp : ffff8003c0403b50
x29: ffff8003c0403b50 x28: ffff00000a482540
x27: ffff00000a482550 x26: ffff000009ffa000
x25: ffff00000b34e7c0 x24: ffff00000a041dd0
x23: ffff00000b34e7c0 x22: ffff8003ffe2aa08
x21: ffff00000b34e7c0 x20: ffff8003ffe2aa00
x19: ffff00000b34e240 x18: 0000000005f5e0ff
x17: 0000000000000000 x16: 0000000000000000
x15: 00000000000000c4 x14: ffff8003fff79500
x13: ffff00000a464f28 x12: ffff00000b59cd10
x11: 0000000000000000 x10: ffff00000a62eef8
x9 : ffff00000b59ccd0 x8 : ffff8003c0400000
x7 : 0000000000000000 x6 : ffff00000b59ccd0
x5 : ffffffffffffffff x4 : 0000000000000000
x3 : ffff8003ffdfdc18 x2 : 0000000000000000
x1 : ffff00000a043548 x0 : 0000000000000003

Kernel panic - not syncing: softlockup: hung tasks
CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W    L 
4.6.0-rc7-next-20160513 #6
Hardware name: AppliedMicro Mustang/Mustang, BIOS 3.05.05-beta_rc Jan 27 
2016
Call trace:
[<ffff000008095bb0>] dump_backtrace+0x0/0x4b0
[<ffff00000809609c>] show_stack+0x3c/0x60
[<ffff000008a8f05c>] dump_stack+0x1dc/0x2c8
[<ffff0000083fd494>] panic+0x264/0x5fc
[<ffff00000831b914>] watchdog_timer_fn+0x804/0x840
[<ffff000008274044>] __hrtimer_run_queues+0x4b4/0xf50
[<ffff000008276864>] hrtimer_interrupt+0x174/0x478
[<ffff000009289e94>] arch_timer_handler_phys+0xac/0xc8
[<ffff00000823e4c4>] handle_percpu_devid_irq+0x214/0x8b0
[<ffff00000822f6a4>] generic_handle_irq+0x8c/0xb0
[<ffff00000822ff20>] __handle_domain_irq+0x178/0x288
[<ffff000008081e40>] gic_handle_irq+0x1e8/0x270
Exception stack(0xffff8003ffe13fa0 to 0xffff8003ffe140c0)
3fa0: ffff8003c0403a30 ffff8003ffe2aa00 ffff8003c0403b50 ffff0000082b6390
3fc0: 0000000080000045 ffff00000a041dd0 ffff8003ffe10020 ffff8003ffe14010
3fe0: ffff00000a482550 ffff8003c0400000 ffff00000800f000 ffff8003c0403a30
4000: ffff8003c0403b50 ffff8003c0403a30 0000000000000000 0000000000000000
4020: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
4040: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
4060: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
4080: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
40a0: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
[<ffff000008088724>] el1_irq+0xa4/0x114
[<ffff0000082b6390>] smp_call_function_many+0x780/0x7b0
[<ffff0000082b6714>] smp_call_function+0x7c/0x1c8
[<ffff0000082b693c>] on_each_cpu+0x74/0x280
[<ffff0000080e9528>] kvm_arch_init+0x8c0/0xe60
[<ffff0000080ccb60>] kvm_init+0x58/0x740
[<ffff0000080e3e48>] arm_init+0x40/0x58
[<ffff00000808366c>] do_one_initcall+0xac/0x360
[<ffff000009e41ee8>] kernel_init_freeable+0x2ac/0x4a8
[<ffff0000096772bc>] kernel_init+0x3c/0x368
[<ffff000008088e10>] ret_from_fork+0x10/0x40
SMP: stopping secondary CPUs
SMP: failed to stop secondary CPUs 0-7
Kernel Offset: disabled
Memory Limit: none
---[ end Kernel panic - not syncing: softlockup: hung tasks

On 5/15/16 8:42 PM, Julien Grall wrote:
> Hello,
>
> On 15/05/2016 12:19, Christoffer Dall wrote:
>> On Sunday, May 15, 2016, Itaru Kitayama <itaru.kitayama@riken.jp
>> <mailto:itaru.kitayama@riken.jp>> wrote:
>>>
>>> Below is the boot (with UEFI) log. I'm attaching the .config I'm using.
>>> I've been trying to test Julien's ACPI support patch set recently
>> merged in the kvmarm tree on Mustang.
>>
>>
>> I don't run anything with ACPI, so haven't tested that particular aspect.
>>
>> This doesn't immediately look like it's related to the kvmarm patches.
>>
>> Perhaps you could try with Linux-next as well to see if this was already
>> fixed?
>>
>> Julien, did you test mustang with your ACPI patches?
>
> No, the patch has been tested on Juno-r2 and Seattle.
>
> However, the logs looks very similar to a bug that Steve Capper was
> hunting in Linux 4.6.0-rc3. I believe this has been fixed in a later RC.
>
> kvm-arm-for-4.7 seems to be based on Linux 4.6-rc1 so I would recommend
> you to try Linux-next.
>
> Regards,
>
