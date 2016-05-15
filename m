From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PULL 00/29] KVM/ARM Changes for v4.7
Date: Sun, 15 May 2016 13:19:54 +0200
Message-ID: <CAMJs5B_Csdt=BPFc36WtjqVwOdn_4+O6MOKCshEHrmepiEgpxA@mail.gmail.com>
References: <e368c757-f5a8-d3be-8b67-8270c756bd2b@riken.jp>
 <CAMJs5B-dGpg++5__cu2WOp40M0xwQjrPFfGhVhiLvnc6AkGiug@mail.gmail.com>
 <7292cb91-39d9-b859-b219-722db5c5dca4@riken.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3341730558366990863=="
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 870EC49B34
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2016 07:16:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MWdm2GyUGNbL for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 May 2016 07:16:46 -0400 (EDT)
Received: from mail-yw0-f176.google.com (mail-yw0-f176.google.com
 [209.85.161.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B28FA412C2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2016 07:16:46 -0400 (EDT)
Received: by mail-yw0-f176.google.com with SMTP id x194so4929148ywd.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2016 04:19:55 -0700 (PDT)
In-Reply-To: <7292cb91-39d9-b859-b219-722db5c5dca4@riken.jp>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Itaru Kitayama <itaru.kitayama@riken.jp>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

--===============3341730558366990863==
Content-Type: multipart/alternative; boundary=94eb2c0bad1af592be0532dfafaf

--94eb2c0bad1af592be0532dfafaf
Content-Type: text/plain; charset=UTF-8

On Sunday, May 15, 2016, Itaru Kitayama <itaru.kitayama@riken.jp> wrote:
>
> Below is the boot (with UEFI) log. I'm attaching the .config I'm using.
> I've been trying to test Julien's ACPI support patch set recently merged
in the kvmarm tree on Mustang.


I don't run anything with ACPI, so haven't tested that particular aspect.

This doesn't immediately look like it's related to the kvmarm patches.

Perhaps you could try with Linux-next as well to see if this was already
fixed?

Julien, did you test mustang with your ACPI patches?


>
>
> EFI stub: Booting Linux Kernel...
> EFI stub: Using DTB from configuration table
> EFI stub: Exiting boot services and installing virtual address map...
> L3C: 8MB
> [    0.000000] Booting Linux on physical CPU 0x0
> [    0.000000] Linux version 4.6.0-rc1 (itaru.kitayama@r2-a11) (gcc
version 5.3.1 20160406 (Red Hat 5.3.1-6) (GCC) ) #8 SMP PREEMPT Sat May 14
09:04:47 CDT 2016
> [    0.000000] Boot CPU: AArch64 Processor [500f0000]
> [    0.000000] earlycon: uart0 at MMIO32 0x000000001c020000 (options '')
> [    0.000000] bootconsole [uart0] enabled
> [    0.000000] efi: Getting EFI parameters from FDT:
> [    0.000000] EFI v2.40 by X-Gene Mustang Board EFI Jan 27 2016 18:27:58
> [    0.000000] efi:  ACPI=0x43fa859000  ACPI 2.0=0x43fa859014  SMBIOS
3.0=0x43fa857000
> [    0.000000] cma: Reserved 512 MiB at 0x00000040e0000000
> [    0.000000] ACPI: Early table checksum verification enabled
> [    0.000000] ACPI: RSDP 0x00000043FA859014 000024 (v02 APM   )
> [    0.000000] ACPI: XSDT 0x00000043FA8580E8 00007C (v01 APM    XGENE
00000003      01000013)
> [    0.000000] ACPI: FACP 0x00000043FA850000 00010C (v05 APM    XGENE
00000003 INTL 20140724)
> [    0.000000] ACPI: DSDT 0x00000043FA851000 003A00 (v05 APM    APM88xxx
00000001 INTL 20140724)
> [    0.000000] ACPI: DBG2 0x00000043FA855000 0000AA (v00 APMC0D XGENEDBG
00000000 INTL 20140724)
> [    0.000000] ACPI: GTDT 0x00000043FA84E000 0000E0 (v02 APM    XGENE
00000001 INTL 20140724)
> [    0.000000] ACPI: MCFG 0x00000043FA84D000 00003C (v01 APM    XGENE
00000002 INTL 20140724)
> [    0.000000] ACPI: SPCR 0x00000043FA84C000 000050 (v02 APMC0D XGENESPC
00000000 INTL 20140724)
> [    0.000000] ACPI: SSDT 0x00000043FA84B000 00002D (v02 APM    XGENE
00000001 INTL 20140724)
> [    0.000000] ACPI: BERT 0x00000043FA84A000 000030 (v01 APM    XGENE
00000002 INTL 20140724)
> [    0.000000] ACPI: HEST 0x00000043FA849000 0002A8 (v01 APM    XGENE
00000002 INTL 20140724)
> [    0.000000] ACPI: APIC 0x00000043FA848000 0002A4 (v03 APM    XGENE
00000003      01000013)
> [    0.000000] ACPI: SSDT 0x00000043FA847000 000063 (v02 REDHAT MACADDRS
00000001      01000013)
> [    0.000000] ACPI: SSDT 0x00000043FA846000 000032 (v02 REDHAT UARTCLKS
00000001      01000013)
> [    0.000000] On node 0 totalpages: 262144
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 0 pages reserved
> [    0.000000]   DMA zone: 65536 pages, LIFO batch:1
> [    0.000000]   Normal zone: 192 pages used for memmap
> [    0.000000]   Normal zone: 196608 pages, LIFO batch:1
> [    0.000000] psci: is not implemented in ACPI.
> [    0.000000] percpu: Embedded 3 pages/cpu @ffff8003ffde0000 s110464
r8192 d77952 u196608
> [    0.000000] pcpu-alloc: s110464 r8192 d77952 u196608 alloc=3*65536
> [    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7
> [    0.000000] Detected PIPT I-cache on CPU0
> [    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 261888
> [    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-4.6.0-rc1
root=UUID=ac9f9264-7572-48c3-97d2-042ea95f7640 ro acpi=force
acpi_force_table_verification earlycon=uart,mmio32,0x1c020000
console=ttyS0,115200 loglevel=8 LANG=en_US.UTF-8
> [    0.000000] log_buf_len individual max cpu contribution: 4096 bytes
> [    0.000000] log_buf_len total cpu_extra contributions: 28672 bytes
> [    0.000000] log_buf_len min size: 16384 bytes
> [    0.000000] log_buf_len: 65536 bytes
> [    0.000000] early log buf free: 13100(79%)
> [    0.000000] PID hash table entries: 4096 (order: -1, 32768 bytes)
> [    0.000000] Dentry cache hash table entries: 2097152 (order: 8,
16777216 bytes)
> [    0.000000] Inode-cache hash table entries: 1048576 (order: 7, 8388608
bytes)
> [    0.000000] software IO TLB [mem 0x40dbff0000-0x40dfff0000] (64MB)
mapped at [ffff8000dbff0000-ffff8000dffeffff]
> [    0.000000] Memory: 16070528K/16777216K available (22848K kernel code,
8676K rwdata, 7552K rodata, 1856K init, 16521K bss, 182400K reserved,
524288K cma-reserved)
> [    0.000000] Virtual kernel memory layout:
> [    0.000000]     modules : 0xffff000000000000 - 0xffff000008000000   (
  128 MB)
> [    0.000000]     vmalloc : 0xffff000008000000 - 0xffff77ffffff0000
(122879 GB)
> [    0.000000]       .text : 0xffff000008080000 - 0xffff0000096d0000   (
22848 KB)
> [    0.000000]     .rodata : 0xffff0000096d0000 - 0xffff000009e40000   (
 7616 KB)
> [    0.000000]       .init : 0xffff000009e40000 - 0xffff00000a010000   (
 1856 KB)
> [    0.000000]       .data : 0xffff00000a010000 - 0xffff00000a889000   (
 8676 KB)
> [    0.000000]     vmemmap : 0xffff780000000000 - 0xffff7c0000000000   (
 4096 GB maximum)
> [    0.000000]               0xffff780000000000 - 0xffff780001000000   (
   16 MB actual)
> [    0.000000]     fixed   : 0xffff7ffffe7d0000 - 0xffff7ffffec00000   (
 4288 KB)
> [    0.000000]     PCI I/O : 0xffff7ffffee00000 - 0xffff7fffffe00000   (
   16 MB)
> [    0.000000]     memory  : 0xffff800000000000 - 0xffff800400000000   (
16384 MB)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
> [    0.000000] Preemptible hierarchical RCU implementation.
> [    0.000000]  Build-time adjustment of leaf fanout to 64.
> [    0.000000]  RCU restricting CPUs from NR_CPUS=64 to nr_cpu_ids=8.
> [    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64,
nr_cpu_ids=8
> [    0.000000] NR_IRQS:64 nr_irqs:64 0
> [    0.000000] GIC: Using split EOI/Deactivate mode
> [    0.000000] GICv3: No distributor detected at @ffff000008060000,
giving up
> [    0.000000] Architected cp15 timer(s) running at 50.00MHz (phys).
> [    0.000000] clocksource: arch_sys_counter: mask: 0xffffffffffffff
max_cycles: 0xb8812736b, max_idle_ns: 440795202655 ns
> [    0.000005] sched_clock: 56 bits at 50MHz, resolution 20ns, wraps
every 4398046511100ns
> [    0.008526] Console: colour dummy device 80x25
> [    0.013156] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
> [    0.021178] ... MAX_LOCKDEP_SUBCLASSES:  8
> [    0.025455] ... MAX_LOCK_DEPTH:          48
> [    0.029791] ... MAX_LOCKDEP_KEYS:        8191
> [    0.034352] ... CLASSHASH_SIZE:          4096
> [    0.038913] ... MAX_LOCKDEP_ENTRIES:     32768
> [    0.043517] ... MAX_LOCKDEP_CHAINS:      65536
> [    0.048121] ... CHAINHASH_SIZE:          32768
> [    0.052708]  memory used by lock dependency info: 8127 kB
> [    0.058340]  per task-struct memory footprint: 1920 bytes
> [    0.063902] Calibrating delay loop (skipped), value calculated using
timer frequency.. 100.00 BogoMIPS (lpj=200000)
> [    0.074799] pid_max: default: 32768 minimum: 301
> [    0.079632] ACPI: Core revision 20160108
> [    0.111734] ACPI: 4 ACPI AML tables successfully acquired and loaded
> [    0.118405]
> [    0.120114] Security Framework initialized
> [    0.124409] Mount-cache hash table entries: 32768 (order: 2, 262144
bytes)
> [    0.131569] Mountpoint-cache hash table entries: 32768 (order: 2,
262144 bytes)
> [    0.140440] ftrace: allocating 29344 entries in 8 pages
> [    0.234935] ASID allocator initialised with 65536 entries
> [    0.242853] Remapping and enabling EFI services.
> [    0.247783]   EFI remap 0x0000000010510000 => 0000000020000000
> [    0.253870]   EFI remap 0x0000000010548000 => 0000000020018000
> [    0.259941]   EFI remap 0x0000000017000000 => 0000000020020000
> [    0.266027]   EFI remap 0x000000001c025000 => 0000000020035000
> [    0.272086]   EFI remap 0x000000007c0c0000 => 0000000020040000
> [    0.278187]   EFI remap 0x000000007c1c0000 => 0000000020050000
> [    0.284228]   EFI remap 0x000000007c2c0000 => 0000000020060000
> [    0.290303]   EFI remap 0x000000007c3c0000 => 0000000020070000
> [    0.296440]   EFI remap 0x000000007c4c0000 => 0000000020080000
> [    0.302514]   EFI remap 0x000000007c5c0000 => 0000000020090000
> [    0.308607]   EFI remap 0x000000007c6c0000 => 00000000200a0000
> [    0.314605]   EFI remap 0x000000007c7c0000 => 00000000200b0000
> [    0.320656]   EFI remap 0x00000043fa813000 => 00000000200c3000
> [    0.326707]   EFI remap 0x00000043fa85a000 => 00000000200da000
> [    0.332800]   EFI remap 0x00000043ffa02000 => 00000000202c2000
> [    0.338833]   EFI remap 0x00000043ffa16000 => 00000000202d6000
> [    0.346722] Detected PIPT I-cache on CPU1
> [    0.346777] CPU1: Booted secondary processor [500f0000]
> [    0.348055] Detected PIPT I-cache on CPU2
> [    0.348101] CPU2: Booted secondary processor [500f0000]
> [    0.349445] Detected PIPT I-cache on CPU3
> [    0.349487] CPU3: Booted secondary processor [500f0000]
> [    0.350755] Detected PIPT I-cache on CPU4
> [    0.350804] CPU4: Booted secondary processor [500f0000]
> [    0.352092] Detected PIPT I-cache on CPU5
> [    0.352139] CPU5: Booted secondary processor [500f0000]
> [    0.353453] Detected PIPT I-cache on CPU6
> [    0.353503] CPU6: Booted secondary processor [500f0000]
> [    0.354760] Detected PIPT I-cache on CPU7
> [    0.354805] CPU7: Booted secondary processor [500f0000]
> [    0.355016] Brought up 8 CPUs
> [    0.424443] SMP: Total of 8 processors activated.
> [    0.429596] CPU: All CPU(s) started at EL2
> [    0.435912] devtmpfs: initialized
> [    0.440366] gcov: version magic: 0x35303352
> [    0.446684] SMBIOS 3.0.0 present.
> [    0.451123] clocksource: jiffies: mask: 0xffffffff max_cycles:
0xffffffff, max_idle_ns: 7645041785100000 ns
> [    0.462909] pinctrl core: initialized pinctrl subsystem
> [    0.472249] NET: Registered protocol family 16
> [    0.480839] PCCT header not found.
> [    0.484751] vdso: 2 pages (1 code @ ffff0000096f0000, 1 data @
ffff00000a020000)
> [    0.492673] hw-breakpoint: found 4 breakpoint and 4 watchpoint
registers.
> [    0.514667] DMA: preallocated 256 KiB pool for atomic allocations
> [    0.521478] ACPI: bus type PCI registered
> [    0.526136] Serial: AMBA PL011 UART driver
> [    0.588382] HugeTLB registered 512 MB page size, pre-allocated 0 pages
> [    0.598785] ACPI: Added _OSI(Module Device)
> [    0.603442] ACPI: Added _OSI(Processor Device)
> [    0.607997] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.612881] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.666107] ACPI: Interpreter enabled
> [    0.670015] ACPI: Using GIC for interrupt routing
> [    0.702600] ACPI: Power Resource [SCVR] (off)
> [    0.769224] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
> [    0.775864] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI]
> [    0.786707] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME
AER PCIeCapability]
> [    0.794901] acpi PNP0A08:00: Bus 0000:00 not present in PCI namespace
> [    0.808595] vgaarb: loaded
> [    0.811960] SCSI subsystem initialized
> [    0.816527] libata version 3.00 loaded.
> [    0.821579] ACPI: bus type USB registered
> [    0.826051] usbcore: registered new interface driver usbfs
> [    0.831972] usbcore: registered new interface driver hub
> [    0.838079] usbcore: registered new device driver usb
> [    0.843666] pps_core: LinuxPPS API ver. 1 registered
> [    0.848778] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
Rodolfo Giometti <giometti@linux.it>
> [    0.858139] PTP clock support registered
> [    0.863697] Advanced Linux Sound Architecture Driver Initialized.
> [    0.872329] clocksource: Switched to clocksource arch_sys_counter
> [    0.891969] Warning: could not register all branches stats
> [    0.897857] Warning: could not register annotated branches stats
> [    1.014772] VFS: Disk quotas dquot_6.6.0
> [    1.018869] VFS: Dquot-cache hash table entries: 8192 (order 0, 65536
bytes)
> [    1.026998] pnp: PnP ACPI init
> [    1.034494] pnp: PnP ACPI: found 0 devices
> [    1.076859] NET: Registered protocol family 2
> [    1.082304] TCP established hash table entries: 131072 (order: 4,
1048576 bytes)
> [    1.090249] TCP bind hash table entries: 65536 (order: 6, 4194304
bytes)
> [    1.102699] TCP: Hash tables configured (established 131072 bind 65536)
> [    1.109673] UDP hash table entries: 8192 (order: 4, 1310720 bytes)
> [    1.117621] UDP-Lite hash table entries: 8192 (order: 4, 1310720 bytes)
> [    1.126338] NET: Registered protocol family 1
> [    1.131621] RPC: Registered named UNIX socket transport module.
> [    1.137591] RPC: Registered udp transport module.
> [    1.142513] RPC: Registered tcp transport module.
> [    1.147396] RPC: Registered tcp NFSv4.1 backchannel transport module.
> [    1.154556] PCI: CLS 0 bytes, default 128
> [    1.159531] Unpacking initramfs...
> [    1.163011] Unable to handle kernel paging request at virtual address
ffff8003f9a7f000
> [    1.171709] pgd = ffff00000b8e0000
> [    1.175160] [ffff8003f9a7f000] *pgd=00000043fffc0003,
*pud=00000043fffc0003, *pmd=00000043fffa0003, *pte=0000000000000000
> [    1.186396] Internal error: Oops: 96000007 [#1] PREEMPT SMP
> [    1.192489] Modules linked in:
> [    1.195821] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.6.0-rc1 #8
> [    1.201970] Hardware name: AppliedMicro Mustang/Mustang, BIOS
3.05.05-beta_rc Jan 27 2016
> [    1.210125] task: ffff8003c0360000 ti: ffff8003c0400000 task.ti:
ffff8003c0400000
> [    1.218309] PC is at unpack_to_rootfs+0x1fc/0x664
> [    1.223448] LR is at unpack_to_rootfs+0xa8/0x664
> [    1.228492] pc : [<ffff000009e43e90>] lr : [<ffff000009e43d3c>]
pstate: 60000045
> [    1.236567] sp : ffff8003c0403ca0
> [    1.239864] x29: ffff8003c0403ca0 x28: ffff000009fc3708
> [    1.245179] x27: ffff000009ce4e18 x26: ffff00000a3fa148
> [    1.250977] x25: ffff00000b3c5998 x24: 0000000000a381dd
> [    1.256757] x23: ffff8003f9a7f000 x22: ffff00000a3f9f90
> [    1.262253] x21: ffff000009f1d000 x20: ffff00000a8c1000
> [    1.267869] x19: ffff00000a8c1548 x18: 0000000005f5e0ff
> [    1.273174] x17: ffff000008abf468 x16: 0000000000000000
> [    1.278669] x15: ffff00000a447ce0 x14: 00000000000000b0
> [    1.284294] x13: 00000000000000b4 x12: 00000000000000b4
> [    1.290084] x11: 0000000000000001 x10: ffff8003c0400000
> [    1.295389] x9 : 00000000000487d1 x8 : 0000000000000003
> [    1.300702] x7 : 0000000000000000 x6 : ffff00000a032000
> [    1.306327] x5 : ffff00000b385a28 x4 : 0000000000000002
> [    1.311641] x3 : ffff000009f1dc10 x2 : 0000000000000002
> [    1.316955] x1 : 0000000000000001 x0 : ffff00000a8c1548
> [    1.322588]
> [    1.324072] Process swapper/0 (pid: 1, stack limit =
0xffff8003c0400020)
> [    1.331379] Stack: (0xffff8003c0403ca0 to 0xffff8003c0404000)
> [    1.337660] 3ca0: ffff8003c0403d20 ffff000009e456ec ffff00000a8c1aa8
ffff00000a8c1000
> [    1.345452] 3cc0: ffff00000a3f9000 ffff00000a8c1000 ffff00000a8c1000
ffff00000a3fa788
> [    1.354012] 3ce0: ffff00000a8c1000 ffff00000a03a1a0 ffff00000a8c0a38
ffff000009fc3708
> [    1.362564] 3d00: 0000000000877237 ffff00000b385a28 ffff00000a032000
0000000000000000
> [    1.371107] 3d20: ffff8003c0403d70 ffff00000809256c ffff00000a8c07d8
ffff8003c1a44b80
> [    1.379668] 3d40: ffff00000a8c0000 ffff00000a03a1a0 ffff000009f1dbc0
ffff00000a8c0878
> [    1.388228] 3d60: ffff000009f1db50 ffff00000a39e000 ffff8003c0403e30
ffff000009e41d24
> [    1.396789] 3d80: ffff00000a8c0000 00000000000000fb ffff00000a8c0000
0000000000000005
> [    1.404589] 3da0: ffff000009f1dbc0 ffff000009e25660 ffff000009f1db50
ffff000009e402e0
> [    1.412380] 3dc0: ffff00000a8c0a38 ffff000009fc3708 ffff00000a42c350
ffff000009d14e90
> [    1.420182] 3de0: ffff000009e455d0 000000000a9043f0 0000000100000000
0000000000000000
> [    1.428743] 3e00: 0000000100000001 ffff00000a42c3c8 0000000000000038
0000000000000040
> [    1.436534] 3e20: 0000000100000000 0000000000000608 ffff8003c0403e90
ffff000009693ea4
> [    1.445094] 3e40: ffff00000a8c0000 ffff00000a3f8000 ffff00000a8c0000
0000000000000000
> [    1.453646] 3e60: ffff00000a8c0b30 0000000000000000 0000000000000000
0000000000000000
> [    1.462206] 3e80: 0000000000000000 0000000000000000 0000000000000000
ffff000008097e10
> [    1.470007] 3ea0: ffff000009693e68 0000000000000000 0000000000000000
0000000000000000
> [    1.478567] 3ec0: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.486358] 3ee0: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.494910] 3f00: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.502701] 3f20: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.510492] 3f40: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.519052] 3f60: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.527612] 3f80: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.536163] 3fa0: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.544715] 3fc0: 0000000000000000 0000000000000000 0000000000000000
0000000000000005
> [    1.553276] 3fe0: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.561065] Call trace:
> [    1.563501] Exception stack(0xffff8003c0403ad0 to 0xffff8003c0403bf0)
> [    1.570522] 3ac0:                                   ffff00000a8c1548
ffff00000a8c1000
> [    1.578349] 3ae0: ffff8003c0403ca0 ffff000009e43e90 0000000060000045
ffff000008241108
> [    1.586909] 3b00: ffff00000b2db218 ffff00000a449590 0000000000000000
ffff00000a0867d8
> [    1.595469] 3b20: ffff00000a0867e0 0000000000000040 ffff8003c0403bb0
ffff0000081b604c
> [    1.604030] 3b40: ffff00000a909000 ffff00000a90a770 ffff00000853cfa8
ffff00000a42ff98
> [    1.612590] 3b60: 0000000000000001 ffff00000b2d5000 ffff00000a37f000
ffff8003c0400000
> [    1.620381] 3b80: ffff00000a8c1548 0000000000000001 0000000000000002
ffff000009f1dc10
> [    1.628941] 3ba0: 0000000000000002 ffff00000b385a28 ffff00000a032000
0000000000000000
> [    1.636732] 3bc0: 0000000000000003 00000000000487d1 ffff8003c0400000
0000000000000001
> [    1.644522] 3be0: 00000000000000b4 00000000000000b4
> [    1.649844] [<ffff000009e43e90>] unpack_to_rootfs+0x1fc/0x664
> [    1.656125] [<ffff000009e456ec>] populate_rootfs+0x11c/0x22c
> [    1.661758] [<ffff00000809256c>] do_one_initcall+0x1d4/0x520
> [    1.667399] [<ffff000009e41d24>] kernel_init_freeable+0x2b4/0x4b0
> [    1.674061] [<ffff000009693ea4>] kernel_init+0x3c/0x368
> [    1.679486] [<ffff000008097e10>] ret_from_fork+0x10/0x40
> [    1.684774] Code: 91000421 f900a401 b4fffe18 f940a801 (394002e2)
> [    1.690902] ---[ end trace 13152abe1ac10cde ]---
> [    1.696013] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b
> [    1.696013]
> [    1.705870] CPU6: stopping
> [    1.708700] CPU: 6 PID: 0 Comm: swapper/6 Tainted: G      D 4.6.0-rc1
#8
> [    1.716398] Hardware name: AppliedMicro Mustang/Mustang, BIOS
3.05.05-beta_rc Jan 27 2016
> [    1.724871] Call trace:
> [    1.727399] [<ffff0000080a4ad0>] dump_backtrace+0x0/0x4b0
> [    1.733017] [<ffff0000080a4fbc>] show_stack+0x3c/0x60
> [    1.738246] [<ffff000008aa172c>] dump_stack+0x1dc/0x2c8
> [    1.743656] [<ffff0000080b2120>] handle_IPI+0xa08/0xa40
> [    1.749065] [<ffff000008090cfc>] gic_handle_irq+0x164/0x260
> [    1.754836] Exception stack(0xffff8003fff03fa0 to 0xffff8003fff040c0)
> [    1.761497] 3fa0: ffff8003c0443da0 ffff00000a8c29e0 ffff8003c0443ec0
ffff000008099964
> [    1.769601] 3fc0: 0000000060000045 ffff00000a030000 ffff8003fff00020
ffff8003fff04010
> [    1.777740] 3fe0: 0000000000000001 ffff8003c0440000 ffff00000800f000
ffff8003c0443da0
> [    1.785852] 4000: ffff8003c0443ec0 ffff8003c0443da0 0000000000000000
0000000000000000
> [    1.793982] 4020: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.802095] 4040: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.810225] 4060: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.818329] 4080: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.826416] 40a0: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.834520] [<ffff000008097724>] el1_irq+0xa4/0x114
> [    1.839619] [<ffff000008099964>] arch_cpu_idle+0x94/0x508
> [    1.845177] [<ffff000008209598>] default_idle_call+0xd0/0xf8
> [    1.851010] [<ffff000008209e04>] cpu_startup_entry+0x844/0xa30
> [    1.857024] [<ffff0000080b0c6c>] secondary_start_kernel+0x3dc/0x468
> [    1.863522] [<00000040002921fc>] 0x40002921fc
> [    1.868054] CPU5: stopping
> [    1.870880] CPU: 5 PID: 0 Comm: swapper/5 Tainted: G      D 4.6.0-rc1
#8
> [    1.878585] Hardware name: AppliedMicro Mustang/Mustang, BIOS
3.05.05-beta_rc Jan 27 2016
> [    1.887085] Call trace:
> [    1.889672] [<ffff0000080a4ad0>] dump_backtrace+0x0/0x4b0
> [    1.895264] [<ffff0000080a4fbc>] show_stack+0x3c/0x60
> [    1.900492] [<ffff000008aa172c>] dump_stack+0x1dc/0x2c8
> [    1.905892] [<ffff0000080b2120>] handle_IPI+0xa08/0xa40
> [    1.911336] [<ffff000008090cfc>] gic_handle_irq+0x164/0x260
> [    1.917072] Exception stack(0xffff8003ffed3fa0 to 0xffff8003ffed40c0)
> [    1.923742] 3fa0: ffff8003c043fda0 ffff00000a8c29e0 ffff8003c043fec0
ffff000008099964
> [    1.931873] 3fc0: 0000000060000045 ffff00000a030000 ffff8003ffed0020
ffff8003ffed4010
> [    1.939994] 3fe0: 0000000000000001 ffff8003c043c000 ffff00000800f000
ffff8003c043fda0
> [    1.948133] 4000: ffff8003c043fec0 ffff8003c043fda0 0000000000000000
0000000000000000
> [    1.956202] 4020: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.964375] 4040: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.972462] 4060: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.980644] 4080: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.988782] 40a0: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    1.996843] [<ffff000008097724>] el1_irq+0xa4/0x114
> [    2.001899] [<ffff000008099964>] arch_cpu_idle+0x94/0x508
> [    2.007473] [<ffff000008209598>] default_idle_call+0xd0/0xf8
> [    2.013358] [<ffff000008209e04>] cpu_startup_entry+0x844/0xa30
> [    2.019415] [<ffff0000080b0c6c>] secondary_start_kernel+0x3dc/0x468
> [    2.025877] [<00000040002921fc>] 0x40002921fc
> [    2.030417] CPU3: stopping
> [    2.033243] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G      D 4.6.0-rc1
#8
> [    2.040862] Hardware name: AppliedMicro Mustang/Mustang, BIOS
3.05.05-beta_rc Jan 27 2016
> [    2.049354] Call trace:
> [    2.051890] [<ffff0000080a4ad0>] dump_backtrace+0x0/0x4b0
> [    2.057507] [<ffff0000080a4fbc>] show_stack+0x3c/0x60
> [    2.062752] [<ffff000008aa172c>] dump_stack+0x1dc/0x2c8
> [    2.068144] [<ffff0000080b2120>] handle_IPI+0xa08/0xa40
> [    2.073544] [<ffff000008090cfc>] gic_handle_irq+0x164/0x260
> [    2.079315] Exception stack(0xffff8003ffe73fa0 to 0xffff8003ffe740c0)
> [    2.085968] 3fa0: ffff8003c0437da0 ffff00000a8c29e0 ffff8003c0437ec0
ffff000008099964
> [    2.094064] 3fc0: 0000000060000045 ffff00000a030000 ffff8003ffe70020
ffff8003ffe74010
> [    2.102212] 3fe0: 0000000000000001 ffff8003c0434000 ffff00000800f000
ffff8003c0437da0
> [    2.110272] 4000: ffff8003c0437ec0 ffff8003c0437da0 0000000000000000
0000000000000000
> [    2.118359] 4020: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.126480] 4040: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.134636] 4060: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.142731] 4080: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.150818] 40a0: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.158905] [<ffff000008097724>] el1_irq+0xa4/0x114
> [    2.163951] [<ffff000008099964>] arch_cpu_idle+0x94/0x508
> [    2.169534] [<ffff000008209598>] default_idle_call+0xd0/0xf8
> [    2.175392] [<ffff000008209e04>] cpu_startup_entry+0x844/0xa30
> [    2.181424] [<ffff0000080b0c6c>] secondary_start_kernel+0x3dc/0x468
> [    2.187946] [<00000040002921fc>] 0x40002921fc
> [    2.192458] CPU0: stopping
> [    2.195280] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G      D 4.6.0-rc1
#8
> [    2.202968] Hardware name: AppliedMicro Mustang/Mustang, BIOS
3.05.05-beta_rc Jan 27 2016
> [    2.211441] Call trace:
> [    2.213992] [<ffff0000080a4ad0>] dump_backtrace+0x0/0x4b0
> [    2.219558] [<ffff0000080a4fbc>] show_stack+0x3c/0x60
> [    2.224785] [<ffff000008aa172c>] dump_stack+0x1dc/0x2c8
> [    2.230210] [<ffff0000080b2120>] handle_IPI+0xa08/0xa40
> [    2.235645] [<ffff000008090cfc>] gic_handle_irq+0x164/0x260
> [    2.241398] Exception stack(0xffff8003ffde3fa0 to 0xffff8003ffde40c0)
> [    2.248085] 3fa0: ffff00000a013d70 ffff00000a8c29e0 ffff00000a013e90
ffff000008099964
> [    2.256188] 3fc0: 0000000060000045 ffff00000a030000 ffff8003ffde0020
ffff8003ffde4010
> [    2.264309] 3fe0: 0000000000000001 ffff00000a010000 ffff00000800f000
ffff00000a013d70
> [    2.272386] 4000: ffff00000a013e90 ffff00000a013d70 0000000000000000
0000000000000000
> [    2.280481] 4020: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.288584] 4040: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.296704] 4060: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.304746] 4080: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.312814] 40a0: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.320840] [<ffff000008097724>] el1_irq+0xa4/0x114
> [    2.325842] [<ffff000008099964>] arch_cpu_idle+0x94/0x508
> [    2.331468] [<ffff000008209598>] default_idle_call+0xd0/0xf8
> [    2.337274] [<ffff000008209e04>] cpu_startup_entry+0x844/0xa30
> [    2.343279] [<ffff000009693e48>] rest_init+0x168/0x188
> [    2.348644] [<ffff000009e41a4c>] start_kernel+0xb70/0xb94
> [    2.354250] [<ffff0000080811c8>] 0xffff0000080811c8
> [    2.359279] CPU2: stopping
> [    2.362048] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G      D 4.6.0-rc1
#8
> [    2.369745] Hardware name: AppliedMicro Mustang/Mustang, BIOS
3.05.05-beta_rc Jan 27 2016
> [    2.378261] Call trace:
> [    2.380811] [<ffff0000080a4ad0>] dump_backtrace+0x0/0x4b0
> [    2.386298] [<ffff0000080a4fbc>] show_stack+0x3c/0x60
> [    2.391550] [<ffff000008aa172c>] dump_stack+0x1dc/0x2c8
> [    2.396846] [<ffff0000080b2120>] handle_IPI+0xa08/0xa40
> [    2.402237] [<ffff000008090cfc>] gic_handle_irq+0x164/0x260
> [    2.408058] Exception stack(0xffff8003ffe43fa0 to 0xffff8003ffe440c0)
> [    2.414598] 3fa0: ffff8003c0433da0 ffff00000a8c29e0 ffff8003c0433ec0
ffff000008099964
> [    2.422813] 3fc0: 0000000060000045 ffff00000a030000 ffff8003ffe40020
ffff8003ffe44010
> [    2.430968] 3fe0: 0000000000000001 ffff8003c0430000 ffff00000800f000
ffff8003c0433da0
> [    2.439028] 4000: ffff8003c0433ec0 ffff8003c0433da0 0000000000000000
0000000000000000
> [    2.447096] 4020: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.455199] 4040: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.463138] 4060: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.471309] 4080: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.479455] 40a0: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.487550] [<ffff000008097724>] el1_irq+0xa4/0x114
> [    2.492655] [<ffff000008099964>] arch_cpu_idle+0x94/0x508
> [    2.498271] [<ffff000008209598>] default_idle_call+0xd0/0xf8
> [    2.504103] [<ffff000008209e04>] cpu_startup_entry+0x844/0xa30
> [    2.510288] [<ffff0000080b0c6c>] secondary_start_kernel+0x3dc/0x468
> [    2.516870] [<00000040002921fc>] 0x40002921fc
> [    2.521329] CPU4: stopping
> [    2.524132] CPU: 4 PID: 0 Comm: swapper/4 Tainted: G      D 4.6.0-rc1
#8
> [    2.532010] Hardware name: AppliedMicro Mustang/Mustang, BIOS
3.05.05-beta_rc Jan 27 2016
> [    2.540301] Call trace:
> [    2.542816] [<ffff0000080a4ad0>] dump_backtrace+0x0/0x4b0
> [    2.548441] [<ffff0000080a4fbc>] show_stack+0x3c/0x60
> [    2.553719] [<ffff000008aa172c>] dump_stack+0x1dc/0x2c8
> [    2.559195] [<ffff0000080b2120>] handle_IPI+0xa08/0xa40
> [    2.564655] [<ffff000008090cfc>] gic_handle_irq+0x164/0x260
> [    2.570433] Exception stack(0xffff8003ffea3fa0 to 0xffff8003ffea40c0)
> [    2.576998] 3fa0: ffff8003c043bda0 ffff00000a8c29e0 ffff8003c043bec0
ffff000008099964
> [    2.584989] 3fc0: 0000000060000045 ffff00000a030000 ffff8003ffea0020
ffff8003ffea4010
> [    2.593049] 3fe0: 0000000000000001 ffff8003c0438000 ffff00000800f000
ffff8003c043bda0
> [    2.601057] 4000: ffff8003c043bec0 ffff8003c043bda0 0000000000000000
0000000000000000
> [    2.609099] 4020: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.617479] 4040: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.625581] 4060: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.633529] 4080: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.641683] 40a0: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.649821] [<ffff000008097724>] el1_irq+0xa4/0x114
> [    2.654797] [<ffff000008099964>] arch_cpu_idle+0x94/0x508
> [    2.660300] [<ffff000008209598>] default_idle_call+0xd0/0xf8
> [    2.666149] [<ffff000008209e04>] cpu_startup_entry+0x844/0xa30
> [    2.672144] [<ffff0000080b0c6c>] secondary_start_kernel+0x3dc/0x468
> [    2.678562] [<00000040002921fc>] 0x40002921fc
> [    2.683011] CPU7: stopping
> [    2.685710] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G      D 4.6.0-rc1
#8
> [    2.693069] Hardware name: AppliedMicro Mustang/Mustang, BIOS
3.05.05-beta_rc Jan 27 2016
> [    2.701395] Call trace:
> [    2.703858] [<ffff0000080a4ad0>] dump_backtrace+0x0/0x4b0
> [    2.709231] [<ffff0000080a4fbc>] show_stack+0x3c/0x60
> [    2.714267] [<ffff000008aa172c>] dump_stack+0x1dc/0x2c8
> [    2.719700] [<ffff0000080b2120>] handle_IPI+0xa08/0xa40
> [    2.724900] [<ffff000008090cfc>] gic_handle_irq+0x164/0x260
> [    2.730782] Exception stack(0xffff8003fff33fa0 to 0xffff8003fff340c0)
> [    2.737261] 3fa0: ffff8003c0447da0 ffff00000a8c29e0 ffff8003c0447ec0
ffff000008099964
> [    2.745061] 3fc0: 0000000060000045 ffff00000a030000 ffff8003fff30020
ffff8003fff34010
> [    2.752922] 3fe0: 0000000000000001 ffff8003c0444000 ffff00000800f000
ffff8003c0447da0
> [    2.760731] 4000: ffff8003c0447ec0 ffff8003c0447da0 0000000000000000
0000000000000000
> [    2.768756] 4020: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.777143] 4040: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.785298] 4060: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.793366] 4080: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.801217] 40a0: 0000000000000000 0000000000000000 0000000000000000
0000000000000000
> [    2.809406] [<ffff000008097724>] el1_irq+0xa4/0x114
> [    2.814486] [<ffff000008099964>] arch_cpu_idle+0x94/0x508
> [    2.819859] [<ffff000008209598>] default_idle_call+0xd0/0xf8
> [    2.825500] [<ffff000008209e04>] cpu_startup_entry+0x844/0xa30
> [    2.831556] [<ffff0000080b0c6c>] secondary_start_kernel+0x3dc/0x468
> [    2.837792] [<00000040002921fc>] 0x40002921fc
> [    2.842501] ---[ end Kernel panic - not syncing: Attempted to kill
init! exitcode=0x0000000b
> [    2.842501]
>
> On 5/15/16 4:08 PM, Christoffer Dall wrote:
>>
>> Yes, I test this for every release.
>>
>> What's your config? What are the symptoms?
>>
>> Are you booting with UEFI or u-boot on your mustang?
>>
>> Thanks,
>> -Christoffer
>>
>> On Saturday, May 14, 2016, Itaru Kitayama <itaru.kitayama@riken.jp
>> <mailto:itaru.kitayama@riken.jp>> wrote:
>>
>>     Hi,
>>
>>     The tag kvm-arm-for-4.7 fails to boot on Mustang. Has anyone
>>     verified this tag on Mustang? The F/W I'm using is 3.05.05-beta_rc.
>>     _______________________________________________
>>     kvmarm mailing list
>>     kvmarm@lists.cs.columbia.edu
>>     https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--94eb2c0bad1af592be0532dfafaf
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">On Sunday, May 15, 2016, Itaru Kitayama &lt;<a href=3D"mai=
lto:itaru.kitayama@riken.jp">itaru.kitayama@riken.jp</a>&gt; wrote:<br>&gt;=
<br>&gt; Below is the boot (with UEFI) log. I&#39;m attaching the .config I=
&#39;m using.<br>&gt; I&#39;ve been trying to test Julien&#39;s ACPI suppor=
t patch set recently merged in the kvmarm tree on Mustang.<br><br><br>I don=
&#39;t run anything with ACPI, so haven&#39;t tested that particular aspect=
. <br><br>This doesn&#39;t immediately look like it&#39;s related to the kv=
marm patches. <br><br>Perhaps you could try with Linux-next as well to see =
if this was already fixed?<br><br>Julien, did you test mustang with your AC=
PI patches?<br><br>=C2=A0<br>&gt;<br>&gt;<br>&gt; EFI stub: Booting Linux K=
ernel...<br>&gt; EFI stub: Using DTB from configuration table<br>&gt; EFI s=
tub: Exiting boot services and installing virtual address map...<br>&gt; L3=
C: 8MB<br>&gt; [ =C2=A0 =C2=A00.000000] Booting Linux on physical CPU 0x0<b=
r>&gt; [ =C2=A0 =C2=A00.000000] Linux version 4.6.0-rc1 (itaru.kitayama@r2-=
a11) (gcc version 5.3.1 20160406 (Red Hat 5.3.1-6) (GCC) ) #8 SMP PREEMPT S=
at May 14 09:04:47 CDT 2016<br>&gt; [ =C2=A0 =C2=A00.000000] Boot CPU: AArc=
h64 Processor [500f0000]<br>&gt; [ =C2=A0 =C2=A00.000000] earlycon: uart0 a=
t MMIO32 0x000000001c020000 (options &#39;&#39;)<br>&gt; [ =C2=A0 =C2=A00.0=
00000] bootconsole [uart0] enabled<br>&gt; [ =C2=A0 =C2=A00.000000] efi: Ge=
tting EFI parameters from FDT:<br>&gt; [ =C2=A0 =C2=A00.000000] EFI v2.40 b=
y X-Gene Mustang Board EFI Jan 27 2016 18:27:58<br>&gt; [ =C2=A0 =C2=A00.00=
0000] efi: =C2=A0ACPI=3D0x43fa859000 =C2=A0ACPI 2.0=3D0x43fa859014 =C2=A0SM=
BIOS 3.0=3D0x43fa857000<br>&gt; [ =C2=A0 =C2=A00.000000] cma: Reserved 512 =
MiB at 0x00000040e0000000<br>&gt; [ =C2=A0 =C2=A00.000000] ACPI: Early tabl=
e checksum verification enabled<br>&gt; [ =C2=A0 =C2=A00.000000] ACPI: RSDP=
 0x00000043FA859014 000024 (v02 APM =C2=A0 )<br>&gt; [ =C2=A0 =C2=A00.00000=
0] ACPI: XSDT 0x00000043FA8580E8 00007C (v01 APM =C2=A0 =C2=A0XGENE 0000000=
3 =C2=A0 =C2=A0 =C2=A001000013)<br>&gt; [ =C2=A0 =C2=A00.000000] ACPI: FACP=
 0x00000043FA850000 00010C (v05 APM =C2=A0 =C2=A0XGENE 00000003 INTL 201407=
24)<br>&gt; [ =C2=A0 =C2=A00.000000] ACPI: DSDT 0x00000043FA851000 003A00 (=
v05 APM =C2=A0 =C2=A0APM88xxx 00000001 INTL 20140724)<br>&gt; [ =C2=A0 =C2=
=A00.000000] ACPI: DBG2 0x00000043FA855000 0000AA (v00 APMC0D XGENEDBG 0000=
0000 INTL 20140724)<br>&gt; [ =C2=A0 =C2=A00.000000] ACPI: GTDT 0x00000043F=
A84E000 0000E0 (v02 APM =C2=A0 =C2=A0XGENE 00000001 INTL 20140724)<br>&gt; =
[ =C2=A0 =C2=A00.000000] ACPI: MCFG 0x00000043FA84D000 00003C (v01 APM =C2=
=A0 =C2=A0XGENE 00000002 INTL 20140724)<br>&gt; [ =C2=A0 =C2=A00.000000] AC=
PI: SPCR 0x00000043FA84C000 000050 (v02 APMC0D XGENESPC 00000000 INTL 20140=
724)<br>&gt; [ =C2=A0 =C2=A00.000000] ACPI: SSDT 0x00000043FA84B000 00002D =
(v02 APM =C2=A0 =C2=A0XGENE 00000001 INTL 20140724)<br>&gt; [ =C2=A0 =C2=A0=
0.000000] ACPI: BERT 0x00000043FA84A000 000030 (v01 APM =C2=A0 =C2=A0XGENE =
00000002 INTL 20140724)<br>&gt; [ =C2=A0 =C2=A00.000000] ACPI: HEST 0x00000=
043FA849000 0002A8 (v01 APM =C2=A0 =C2=A0XGENE 00000002 INTL 20140724)<br>&=
gt; [ =C2=A0 =C2=A00.000000] ACPI: APIC 0x00000043FA848000 0002A4 (v03 APM =
=C2=A0 =C2=A0XGENE 00000003 =C2=A0 =C2=A0 =C2=A001000013)<br>&gt; [ =C2=A0 =
=C2=A00.000000] ACPI: SSDT 0x00000043FA847000 000063 (v02 REDHAT MACADDRS 0=
0000001 =C2=A0 =C2=A0 =C2=A001000013)<br>&gt; [ =C2=A0 =C2=A00.000000] ACPI=
: SSDT 0x00000043FA846000 000032 (v02 REDHAT UARTCLKS 00000001 =C2=A0 =C2=
=A0 =C2=A001000013)<br>&gt; [ =C2=A0 =C2=A00.000000] On node 0 totalpages: =
262144<br>&gt; [ =C2=A0 =C2=A00.000000] =C2=A0 DMA zone: 64 pages used for =
memmap<br>&gt; [ =C2=A0 =C2=A00.000000] =C2=A0 DMA zone: 0 pages reserved<b=
r>&gt; [ =C2=A0 =C2=A00.000000] =C2=A0 DMA zone: 65536 pages, LIFO batch:1<=
br>&gt; [ =C2=A0 =C2=A00.000000] =C2=A0 Normal zone: 192 pages used for mem=
map<br>&gt; [ =C2=A0 =C2=A00.000000] =C2=A0 Normal zone: 196608 pages, LIFO=
 batch:1<br>&gt; [ =C2=A0 =C2=A00.000000] psci: is not implemented in ACPI.=
<br>&gt; [ =C2=A0 =C2=A00.000000] percpu: Embedded 3 pages/cpu @ffff8003ffd=
e0000 s110464 r8192 d77952 u196608<br>&gt; [ =C2=A0 =C2=A00.000000] pcpu-al=
loc: s110464 r8192 d77952 u196608 alloc=3D3*65536<br>&gt; [ =C2=A0 =C2=A00.=
000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7<br>&gt;=
 [ =C2=A0 =C2=A00.000000] Detected PIPT I-cache on CPU0<br>&gt; [ =C2=A0 =
=C2=A00.000000] Built 1 zonelists in Zone order, mobility grouping on. Tota=
l pages: 261888<br>&gt; [ =C2=A0 =C2=A00.000000] Kernel command line: BOOT_=
IMAGE=3D/vmlinuz-4.6.0-rc1 root=3DUUID=3Dac9f9264-7572-48c3-97d2-042ea95f76=
40 ro acpi=3Dforce acpi_force_table_verification earlycon=3Duart,mmio32,0x1=
c020000 console=3DttyS0,115200 loglevel=3D8 LANG=3Den_US.UTF-8<br>&gt; [ =
=C2=A0 =C2=A00.000000] log_buf_len individual max cpu contribution: 4096 by=
tes<br>&gt; [ =C2=A0 =C2=A00.000000] log_buf_len total cpu_extra contributi=
ons: 28672 bytes<br>&gt; [ =C2=A0 =C2=A00.000000] log_buf_len min size: 163=
84 bytes<br>&gt; [ =C2=A0 =C2=A00.000000] log_buf_len: 65536 bytes<br>&gt; =
[ =C2=A0 =C2=A00.000000] early log buf free: 13100(79%)<br>&gt; [ =C2=A0 =
=C2=A00.000000] PID hash table entries: 4096 (order: -1, 32768 bytes)<br>&g=
t; [ =C2=A0 =C2=A00.000000] Dentry cache hash table entries: 2097152 (order=
: 8, 16777216 bytes)<br>&gt; [ =C2=A0 =C2=A00.000000] Inode-cache hash tabl=
e entries: 1048576 (order: 7, 8388608 bytes)<br>&gt; [ =C2=A0 =C2=A00.00000=
0] software IO TLB [mem 0x40dbff0000-0x40dfff0000] (64MB) mapped at [ffff80=
00dbff0000-ffff8000dffeffff]<br>&gt; [ =C2=A0 =C2=A00.000000] Memory: 16070=
528K/16777216K available (22848K kernel code, 8676K rwdata, 7552K rodata, 1=
856K init, 16521K bss, 182400K reserved, 524288K cma-reserved)<br>&gt; [ =
=C2=A0 =C2=A00.000000] Virtual kernel memory layout:<br>&gt; [ =C2=A0 =C2=
=A00.000000] =C2=A0 =C2=A0 modules : 0xffff000000000000 - 0xffff00000800000=
0 =C2=A0 ( =C2=A0 128 MB)<br>&gt; [ =C2=A0 =C2=A00.000000] =C2=A0 =C2=A0 vm=
alloc : 0xffff000008000000 - 0xffff77ffffff0000 (122879 GB)<br>&gt; [ =C2=
=A0 =C2=A00.000000] =C2=A0 =C2=A0 =C2=A0 .text : 0xffff000008080000 - 0xfff=
f0000096d0000 =C2=A0 ( 22848 KB)<br>&gt; [ =C2=A0 =C2=A00.000000] =C2=A0 =
=C2=A0 .rodata : 0xffff0000096d0000 - 0xffff000009e40000 =C2=A0 ( =C2=A0761=
6 KB)<br>&gt; [ =C2=A0 =C2=A00.000000] =C2=A0 =C2=A0 =C2=A0 .init : 0xffff0=
00009e40000 - 0xffff00000a010000 =C2=A0 ( =C2=A01856 KB)<br>&gt; [ =C2=A0 =
=C2=A00.000000] =C2=A0 =C2=A0 =C2=A0 .data : 0xffff00000a010000 - 0xffff000=
00a889000 =C2=A0 ( =C2=A08676 KB)<br>&gt; [ =C2=A0 =C2=A00.000000] =C2=A0 =
=C2=A0 vmemmap : 0xffff780000000000 - 0xffff7c0000000000 =C2=A0 ( =C2=A0409=
6 GB maximum)<br>&gt; [ =C2=A0 =C2=A00.000000] =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 0xffff780000000000 - 0xffff780001000000 =C2=A0 ( =C2=
=A0 =C2=A016 MB actual)<br>&gt; [ =C2=A0 =C2=A00.000000] =C2=A0 =C2=A0 fixe=
d =C2=A0 : 0xffff7ffffe7d0000 - 0xffff7ffffec00000 =C2=A0 ( =C2=A04288 KB)<=
br>&gt; [ =C2=A0 =C2=A00.000000] =C2=A0 =C2=A0 PCI I/O : 0xffff7ffffee00000=
 - 0xffff7fffffe00000 =C2=A0 ( =C2=A0 =C2=A016 MB)<br>&gt; [ =C2=A0 =C2=A00=
.000000] =C2=A0 =C2=A0 memory =C2=A0: 0xffff800000000000 - 0xffff8004000000=
00 =C2=A0 ( 16384 MB)<br>&gt; [ =C2=A0 =C2=A00.000000] SLUB: HWalign=3D64, =
Order=3D0-3, MinObjects=3D0, CPUs=3D8, Nodes=3D1<br>&gt; [ =C2=A0 =C2=A00.0=
00000] Preemptible hierarchical RCU implementation.<br>&gt; [ =C2=A0 =C2=A0=
0.000000] =C2=A0Build-time adjustment of leaf fanout to 64.<br>&gt; [ =C2=
=A0 =C2=A00.000000] =C2=A0RCU restricting CPUs from NR_CPUS=3D64 to nr_cpu_=
ids=3D8.<br>&gt; [ =C2=A0 =C2=A00.000000] RCU: Adjusting geometry for rcu_f=
anout_leaf=3D64, nr_cpu_ids=3D8<br>&gt; [ =C2=A0 =C2=A00.000000] NR_IRQS:64=
 nr_irqs:64 0<br>&gt; [ =C2=A0 =C2=A00.000000] GIC: Using split EOI/Deactiv=
ate mode<br>&gt; [ =C2=A0 =C2=A00.000000] GICv3: No distributor detected at=
 @ffff000008060000, giving up<br>&gt; [ =C2=A0 =C2=A00.000000] Architected =
cp15 timer(s) running at 50.00MHz (phys).<br>&gt; [ =C2=A0 =C2=A00.000000] =
clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles: 0xb881273=
6b, max_idle_ns: 440795202655 ns<br>&gt; [ =C2=A0 =C2=A00.000005] sched_clo=
ck: 56 bits at 50MHz, resolution 20ns, wraps every 4398046511100ns<br>&gt; =
[ =C2=A0 =C2=A00.008526] Console: colour dummy device 80x25<br>&gt; [ =C2=
=A0 =C2=A00.013156] Lock dependency validator: Copyright (c) 2006 Red Hat, =
Inc., Ingo Molnar<br>&gt; [ =C2=A0 =C2=A00.021178] ... MAX_LOCKDEP_SUBCLASS=
ES: =C2=A08<br>&gt; [ =C2=A0 =C2=A00.025455] ... MAX_LOCK_DEPTH: =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A048<br>&gt; [ =C2=A0 =C2=A00.029791] ... MAX_LOCKDEP=
_KEYS: =C2=A0 =C2=A0 =C2=A0 =C2=A08191<br>&gt; [ =C2=A0 =C2=A00.034352] ...=
 CLASSHASH_SIZE: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A04096<br>&gt; [ =C2=A0 =
=C2=A00.038913] ... MAX_LOCKDEP_ENTRIES: =C2=A0 =C2=A0 32768<br>&gt; [ =C2=
=A0 =C2=A00.043517] ... MAX_LOCKDEP_CHAINS: =C2=A0 =C2=A0 =C2=A065536<br>&g=
t; [ =C2=A0 =C2=A00.048121] ... CHAINHASH_SIZE: =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A032768<br>&gt; [ =C2=A0 =C2=A00.052708] =C2=A0memory used by lock dep=
endency info: 8127 kB<br>&gt; [ =C2=A0 =C2=A00.058340] =C2=A0per task-struc=
t memory footprint: 1920 bytes<br>&gt; [ =C2=A0 =C2=A00.063902] Calibrating=
 delay loop (skipped), value calculated using timer frequency.. 100.00 Bogo=
MIPS (lpj=3D200000)<br>&gt; [ =C2=A0 =C2=A00.074799] pid_max: default: 3276=
8 minimum: 301<br>&gt; [ =C2=A0 =C2=A00.079632] ACPI: Core revision 2016010=
8<br>&gt; [ =C2=A0 =C2=A00.111734] ACPI: 4 ACPI AML tables successfully acq=
uired and loaded<br>&gt; [ =C2=A0 =C2=A00.118405]<br>&gt; [ =C2=A0 =C2=A00.=
120114] Security Framework initialized<br>&gt; [ =C2=A0 =C2=A00.124409] Mou=
nt-cache hash table entries: 32768 (order: 2, 262144 bytes)<br>&gt; [ =C2=
=A0 =C2=A00.131569] Mountpoint-cache hash table entries: 32768 (order: 2, 2=
62144 bytes)<br>&gt; [ =C2=A0 =C2=A00.140440] ftrace: allocating 29344 entr=
ies in 8 pages<br>&gt; [ =C2=A0 =C2=A00.234935] ASID allocator initialised =
with 65536 entries<br>&gt; [ =C2=A0 =C2=A00.242853] Remapping and enabling =
EFI services.<br>&gt; [ =C2=A0 =C2=A00.247783] =C2=A0 EFI remap 0x000000001=
0510000 =3D&gt; 0000000020000000<br>&gt; [ =C2=A0 =C2=A00.253870] =C2=A0 EF=
I remap 0x0000000010548000 =3D&gt; 0000000020018000<br>&gt; [ =C2=A0 =C2=A0=
0.259941] =C2=A0 EFI remap 0x0000000017000000 =3D&gt; 0000000020020000<br>&=
gt; [ =C2=A0 =C2=A00.266027] =C2=A0 EFI remap 0x000000001c025000 =3D&gt; 00=
00000020035000<br>&gt; [ =C2=A0 =C2=A00.272086] =C2=A0 EFI remap 0x00000000=
7c0c0000 =3D&gt; 0000000020040000<br>&gt; [ =C2=A0 =C2=A00.278187] =C2=A0 E=
FI remap 0x000000007c1c0000 =3D&gt; 0000000020050000<br>&gt; [ =C2=A0 =C2=
=A00.284228] =C2=A0 EFI remap 0x000000007c2c0000 =3D&gt; 0000000020060000<b=
r>&gt; [ =C2=A0 =C2=A00.290303] =C2=A0 EFI remap 0x000000007c3c0000 =3D&gt;=
 0000000020070000<br>&gt; [ =C2=A0 =C2=A00.296440] =C2=A0 EFI remap 0x00000=
0007c4c0000 =3D&gt; 0000000020080000<br>&gt; [ =C2=A0 =C2=A00.302514] =C2=
=A0 EFI remap 0x000000007c5c0000 =3D&gt; 0000000020090000<br>&gt; [ =C2=A0 =
=C2=A00.308607] =C2=A0 EFI remap 0x000000007c6c0000 =3D&gt; 00000000200a000=
0<br>&gt; [ =C2=A0 =C2=A00.314605] =C2=A0 EFI remap 0x000000007c7c0000 =3D&=
gt; 00000000200b0000<br>&gt; [ =C2=A0 =C2=A00.320656] =C2=A0 EFI remap 0x00=
000043fa813000 =3D&gt; 00000000200c3000<br>&gt; [ =C2=A0 =C2=A00.326707] =
=C2=A0 EFI remap 0x00000043fa85a000 =3D&gt; 00000000200da000<br>&gt; [ =C2=
=A0 =C2=A00.332800] =C2=A0 EFI remap 0x00000043ffa02000 =3D&gt; 00000000202=
c2000<br>&gt; [ =C2=A0 =C2=A00.338833] =C2=A0 EFI remap 0x00000043ffa16000 =
=3D&gt; 00000000202d6000<br>&gt; [ =C2=A0 =C2=A00.346722] Detected PIPT I-c=
ache on CPU1<br>&gt; [ =C2=A0 =C2=A00.346777] CPU1: Booted secondary proces=
sor [500f0000]<br>&gt; [ =C2=A0 =C2=A00.348055] Detected PIPT I-cache on CP=
U2<br>&gt; [ =C2=A0 =C2=A00.348101] CPU2: Booted secondary processor [500f0=
000]<br>&gt; [ =C2=A0 =C2=A00.349445] Detected PIPT I-cache on CPU3<br>&gt;=
 [ =C2=A0 =C2=A00.349487] CPU3: Booted secondary processor [500f0000]<br>&g=
t; [ =C2=A0 =C2=A00.350755] Detected PIPT I-cache on CPU4<br>&gt; [ =C2=A0 =
=C2=A00.350804] CPU4: Booted secondary processor [500f0000]<br>&gt; [ =C2=
=A0 =C2=A00.352092] Detected PIPT I-cache on CPU5<br>&gt; [ =C2=A0 =C2=A00.=
352139] CPU5: Booted secondary processor [500f0000]<br>&gt; [ =C2=A0 =C2=A0=
0.353453] Detected PIPT I-cache on CPU6<br>&gt; [ =C2=A0 =C2=A00.353503] CP=
U6: Booted secondary processor [500f0000]<br>&gt; [ =C2=A0 =C2=A00.354760] =
Detected PIPT I-cache on CPU7<br>&gt; [ =C2=A0 =C2=A00.354805] CPU7: Booted=
 secondary processor [500f0000]<br>&gt; [ =C2=A0 =C2=A00.355016] Brought up=
 8 CPUs<br>&gt; [ =C2=A0 =C2=A00.424443] SMP: Total of 8 processors activat=
ed.<br>&gt; [ =C2=A0 =C2=A00.429596] CPU: All CPU(s) started at EL2<br>&gt;=
 [ =C2=A0 =C2=A00.435912] devtmpfs: initialized<br>&gt; [ =C2=A0 =C2=A00.44=
0366] gcov: version magic: 0x35303352<br>&gt; [ =C2=A0 =C2=A00.446684] SMBI=
OS 3.0.0 present.<br>&gt; [ =C2=A0 =C2=A00.451123] clocksource: jiffies: ma=
sk: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns<br>=
&gt; [ =C2=A0 =C2=A00.462909] pinctrl core: initialized pinctrl subsystem<b=
r>&gt; [ =C2=A0 =C2=A00.472249] NET: Registered protocol family 16<br>&gt; =
[ =C2=A0 =C2=A00.480839] PCCT header not found.<br>&gt; [ =C2=A0 =C2=A00.48=
4751] vdso: 2 pages (1 code @ ffff0000096f0000, 1 data @ ffff00000a020000)<=
br>&gt; [ =C2=A0 =C2=A00.492673] hw-breakpoint: found 4 breakpoint and 4 wa=
tchpoint registers.<br>&gt; [ =C2=A0 =C2=A00.514667] DMA: preallocated 256 =
KiB pool for atomic allocations<br>&gt; [ =C2=A0 =C2=A00.521478] ACPI: bus =
type PCI registered<br>&gt; [ =C2=A0 =C2=A00.526136] Serial: AMBA PL011 UAR=
T driver<br>&gt; [ =C2=A0 =C2=A00.588382] HugeTLB registered 512 MB page si=
ze, pre-allocated 0 pages<br>&gt; [ =C2=A0 =C2=A00.598785] ACPI: Added _OSI=
(Module Device)<br>&gt; [ =C2=A0 =C2=A00.603442] ACPI: Added _OSI(Processor=
 Device)<br>&gt; [ =C2=A0 =C2=A00.607997] ACPI: Added _OSI(3.0 _SCP Extensi=
ons)<br>&gt; [ =C2=A0 =C2=A00.612881] ACPI: Added _OSI(Processor Aggregator=
 Device)<br>&gt; [ =C2=A0 =C2=A00.666107] ACPI: Interpreter enabled<br>&gt;=
 [ =C2=A0 =C2=A00.670015] ACPI: Using GIC for interrupt routing<br>&gt; [ =
=C2=A0 =C2=A00.702600] ACPI: Power Resource [SCVR] (off)<br>&gt; [ =C2=A0 =
=C2=A00.769224] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])<br>&=
gt; [ =C2=A0 =C2=A00.775864] acpi PNP0A08:00: _OSC: OS supports [ExtendedCo=
nfig ASPM ClockPM Segments MSI]<br>&gt; [ =C2=A0 =C2=A00.786707] acpi PNP0A=
08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]<br>&gt; [=
 =C2=A0 =C2=A00.794901] acpi PNP0A08:00: Bus 0000:00 not present in PCI nam=
espace<br>&gt; [ =C2=A0 =C2=A00.808595] vgaarb: loaded<br>&gt; [ =C2=A0 =C2=
=A00.811960] SCSI subsystem initialized<br>&gt; [ =C2=A0 =C2=A00.816527] li=
bata version 3.00 loaded.<br>&gt; [ =C2=A0 =C2=A00.821579] ACPI: bus type U=
SB registered<br>&gt; [ =C2=A0 =C2=A00.826051] usbcore: registered new inte=
rface driver usbfs<br>&gt; [ =C2=A0 =C2=A00.831972] usbcore: registered new=
 interface driver hub<br>&gt; [ =C2=A0 =C2=A00.838079] usbcore: registered =
new device driver usb<br>&gt; [ =C2=A0 =C2=A00.843666] pps_core: LinuxPPS A=
PI ver. 1 registered<br>&gt; [ =C2=A0 =C2=A00.848778] pps_core: Software ve=
r. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti &lt;<a href=3D"mailto:giome=
tti@linux.it">giometti@linux.it</a>&gt;<br>&gt; [ =C2=A0 =C2=A00.858139] PT=
P clock support registered<br>&gt; [ =C2=A0 =C2=A00.863697] Advanced Linux =
Sound Architecture Driver Initialized.<br>&gt; [ =C2=A0 =C2=A00.872329] clo=
cksource: Switched to clocksource arch_sys_counter<br>&gt; [ =C2=A0 =C2=A00=
.891969] Warning: could not register all branches stats<br>&gt; [ =C2=A0 =
=C2=A00.897857] Warning: could not register annotated branches stats<br>&gt=
; [ =C2=A0 =C2=A01.014772] VFS: Disk quotas dquot_6.6.0<br>&gt; [ =C2=A0 =
=C2=A01.018869] VFS: Dquot-cache hash table entries: 8192 (order 0, 65536 b=
ytes)<br>&gt; [ =C2=A0 =C2=A01.026998] pnp: PnP ACPI init<br>&gt; [ =C2=A0 =
=C2=A01.034494] pnp: PnP ACPI: found 0 devices<br>&gt; [ =C2=A0 =C2=A01.076=
859] NET: Registered protocol family 2<br>&gt; [ =C2=A0 =C2=A01.082304] TCP=
 established hash table entries: 131072 (order: 4, 1048576 bytes)<br>&gt; [=
 =C2=A0 =C2=A01.090249] TCP bind hash table entries: 65536 (order: 6, 41943=
04 bytes)<br>&gt; [ =C2=A0 =C2=A01.102699] TCP: Hash tables configured (est=
ablished 131072 bind 65536)<br>&gt; [ =C2=A0 =C2=A01.109673] UDP hash table=
 entries: 8192 (order: 4, 1310720 bytes)<br>&gt; [ =C2=A0 =C2=A01.117621] U=
DP-Lite hash table entries: 8192 (order: 4, 1310720 bytes)<br>&gt; [ =C2=A0=
 =C2=A01.126338] NET: Registered protocol family 1<br>&gt; [ =C2=A0 =C2=A01=
.131621] RPC: Registered named UNIX socket transport module.<br>&gt; [ =C2=
=A0 =C2=A01.137591] RPC: Registered udp transport module.<br>&gt; [ =C2=A0 =
=C2=A01.142513] RPC: Registered tcp transport module.<br>&gt; [ =C2=A0 =C2=
=A01.147396] RPC: Registered tcp NFSv4.1 backchannel transport module.<br>&=
gt; [ =C2=A0 =C2=A01.154556] PCI: CLS 0 bytes, default 128<br>&gt; [ =C2=A0=
 =C2=A01.159531] Unpacking initramfs...<br>&gt; [ =C2=A0 =C2=A01.163011] Un=
able to handle kernel paging request at virtual address ffff8003f9a7f000<br=
>&gt; [ =C2=A0 =C2=A01.171709] pgd =3D ffff00000b8e0000<br>&gt; [ =C2=A0 =
=C2=A01.175160] [ffff8003f9a7f000] *pgd=3D00000043fffc0003, *pud=3D00000043=
fffc0003, *pmd=3D00000043fffa0003, *pte=3D0000000000000000<br>&gt; [ =C2=A0=
 =C2=A01.186396] Internal error: Oops: 96000007 [#1] PREEMPT SMP<br>&gt; [ =
=C2=A0 =C2=A01.192489] Modules linked in:<br>&gt; [ =C2=A0 =C2=A01.195821] =
CPU: 1 PID: 1 Comm: swapper/0 Not tainted 4.6.0-rc1 #8<br>&gt; [ =C2=A0 =C2=
=A01.201970] Hardware name: AppliedMicro Mustang/Mustang, BIOS 3.05.05-beta=
_rc Jan 27 2016<br>&gt; [ =C2=A0 =C2=A01.210125] task: ffff8003c0360000 ti:=
 ffff8003c0400000 task.ti: ffff8003c0400000<br>&gt; [ =C2=A0 =C2=A01.218309=
] PC is at unpack_to_rootfs+0x1fc/0x664<br>&gt; [ =C2=A0 =C2=A01.223448] LR=
 is at unpack_to_rootfs+0xa8/0x664<br>&gt; [ =C2=A0 =C2=A01.228492] pc : [&=
lt;ffff000009e43e90&gt;] lr : [&lt;ffff000009e43d3c&gt;] pstate: 60000045<b=
r>&gt; [ =C2=A0 =C2=A01.236567] sp : ffff8003c0403ca0<br>&gt; [ =C2=A0 =C2=
=A01.239864] x29: ffff8003c0403ca0 x28: ffff000009fc3708<br>&gt; [ =C2=A0 =
=C2=A01.245179] x27: ffff000009ce4e18 x26: ffff00000a3fa148<br>&gt; [ =C2=
=A0 =C2=A01.250977] x25: ffff00000b3c5998 x24: 0000000000a381dd<br>&gt; [ =
=C2=A0 =C2=A01.256757] x23: ffff8003f9a7f000 x22: ffff00000a3f9f90<br>&gt; =
[ =C2=A0 =C2=A01.262253] x21: ffff000009f1d000 x20: ffff00000a8c1000<br>&gt=
; [ =C2=A0 =C2=A01.267869] x19: ffff00000a8c1548 x18: 0000000005f5e0ff<br>&=
gt; [ =C2=A0 =C2=A01.273174] x17: ffff000008abf468 x16: 0000000000000000<br=
>&gt; [ =C2=A0 =C2=A01.278669] x15: ffff00000a447ce0 x14: 00000000000000b0<=
br>&gt; [ =C2=A0 =C2=A01.284294] x13: 00000000000000b4 x12: 00000000000000b=
4<br>&gt; [ =C2=A0 =C2=A01.290084] x11: 0000000000000001 x10: ffff8003c0400=
000<br>&gt; [ =C2=A0 =C2=A01.295389] x9 : 00000000000487d1 x8 : 00000000000=
00003<br>&gt; [ =C2=A0 =C2=A01.300702] x7 : 0000000000000000 x6 : ffff00000=
a032000<br>&gt; [ =C2=A0 =C2=A01.306327] x5 : ffff00000b385a28 x4 : 0000000=
000000002<br>&gt; [ =C2=A0 =C2=A01.311641] x3 : ffff000009f1dc10 x2 : 00000=
00000000002<br>&gt; [ =C2=A0 =C2=A01.316955] x1 : 0000000000000001 x0 : fff=
f00000a8c1548<br>&gt; [ =C2=A0 =C2=A01.322588]<br>&gt; [ =C2=A0 =C2=A01.324=
072] Process swapper/0 (pid: 1, stack limit =3D 0xffff8003c0400020)<br>&gt;=
 [ =C2=A0 =C2=A01.331379] Stack: (0xffff8003c0403ca0 to 0xffff8003c0404000)=
<br>&gt; [ =C2=A0 =C2=A01.337660] 3ca0: ffff8003c0403d20 ffff000009e456ec f=
fff00000a8c1aa8 ffff00000a8c1000<br>&gt; [ =C2=A0 =C2=A01.345452] 3cc0: fff=
f00000a3f9000 ffff00000a8c1000 ffff00000a8c1000 ffff00000a3fa788<br>&gt; [ =
=C2=A0 =C2=A01.354012] 3ce0: ffff00000a8c1000 ffff00000a03a1a0 ffff00000a8c=
0a38 ffff000009fc3708<br>&gt; [ =C2=A0 =C2=A01.362564] 3d00: 00000000008772=
37 ffff00000b385a28 ffff00000a032000 0000000000000000<br>&gt; [ =C2=A0 =C2=
=A01.371107] 3d20: ffff8003c0403d70 ffff00000809256c ffff00000a8c07d8 ffff8=
003c1a44b80<br>&gt; [ =C2=A0 =C2=A01.379668] 3d40: ffff00000a8c0000 ffff000=
00a03a1a0 ffff000009f1dbc0 ffff00000a8c0878<br>&gt; [ =C2=A0 =C2=A01.388228=
] 3d60: ffff000009f1db50 ffff00000a39e000 ffff8003c0403e30 ffff000009e41d24=
<br>&gt; [ =C2=A0 =C2=A01.396789] 3d80: ffff00000a8c0000 00000000000000fb f=
fff00000a8c0000 0000000000000005<br>&gt; [ =C2=A0 =C2=A01.404589] 3da0: fff=
f000009f1dbc0 ffff000009e25660 ffff000009f1db50 ffff000009e402e0<br>&gt; [ =
=C2=A0 =C2=A01.412380] 3dc0: ffff00000a8c0a38 ffff000009fc3708 ffff00000a42=
c350 ffff000009d14e90<br>&gt; [ =C2=A0 =C2=A01.420182] 3de0: ffff000009e455=
d0 000000000a9043f0 0000000100000000 0000000000000000<br>&gt; [ =C2=A0 =C2=
=A01.428743] 3e00: 0000000100000001 ffff00000a42c3c8 0000000000000038 00000=
00000000040<br>&gt; [ =C2=A0 =C2=A01.436534] 3e20: 0000000100000000 0000000=
000000608 ffff8003c0403e90 ffff000009693ea4<br>&gt; [ =C2=A0 =C2=A01.445094=
] 3e40: ffff00000a8c0000 ffff00000a3f8000 ffff00000a8c0000 0000000000000000=
<br>&gt; [ =C2=A0 =C2=A01.453646] 3e60: ffff00000a8c0b30 0000000000000000 0=
000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A01.462206] 3e80: 000=
0000000000000 0000000000000000 0000000000000000 ffff000008097e10<br>&gt; [ =
=C2=A0 =C2=A01.470007] 3ea0: ffff000009693e68 0000000000000000 000000000000=
0000 0000000000000000<br>&gt; [ =C2=A0 =C2=A01.478567] 3ec0: 00000000000000=
00 0000000000000000 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=
=A01.486358] 3ee0: 0000000000000000 0000000000000000 0000000000000000 00000=
00000000000<br>&gt; [ =C2=A0 =C2=A01.494910] 3f00: 0000000000000000 0000000=
000000000 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A01.502701=
] 3f20: 0000000000000000 0000000000000000 0000000000000000 0000000000000000=
<br>&gt; [ =C2=A0 =C2=A01.510492] 3f40: 0000000000000000 0000000000000000 0=
000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A01.519052] 3f60: 000=
0000000000000 0000000000000000 0000000000000000 0000000000000000<br>&gt; [ =
=C2=A0 =C2=A01.527612] 3f80: 0000000000000000 0000000000000000 000000000000=
0000 0000000000000000<br>&gt; [ =C2=A0 =C2=A01.536163] 3fa0: 00000000000000=
00 0000000000000000 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=
=A01.544715] 3fc0: 0000000000000000 0000000000000000 0000000000000000 00000=
00000000005<br>&gt; [ =C2=A0 =C2=A01.553276] 3fe0: 0000000000000000 0000000=
000000000 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A01.561065=
] Call trace:<br>&gt; [ =C2=A0 =C2=A01.563501] Exception stack(0xffff8003c0=
403ad0 to 0xffff8003c0403bf0)<br>&gt; [ =C2=A0 =C2=A01.570522] 3ac0: =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ffff00000a8c1548 ffff00000a8c1000<br=
>&gt; [ =C2=A0 =C2=A01.578349] 3ae0: ffff8003c0403ca0 ffff000009e43e90 0000=
000060000045 ffff000008241108<br>&gt; [ =C2=A0 =C2=A01.586909] 3b00: ffff00=
000b2db218 ffff00000a449590 0000000000000000 ffff00000a0867d8<br>&gt; [ =C2=
=A0 =C2=A01.595469] 3b20: ffff00000a0867e0 0000000000000040 ffff8003c0403bb=
0 ffff0000081b604c<br>&gt; [ =C2=A0 =C2=A01.604030] 3b40: ffff00000a909000 =
ffff00000a90a770 ffff00000853cfa8 ffff00000a42ff98<br>&gt; [ =C2=A0 =C2=A01=
.612590] 3b60: 0000000000000001 ffff00000b2d5000 ffff00000a37f000 ffff8003c=
0400000<br>&gt; [ =C2=A0 =C2=A01.620381] 3b80: ffff00000a8c1548 00000000000=
00001 0000000000000002 ffff000009f1dc10<br>&gt; [ =C2=A0 =C2=A01.628941] 3b=
a0: 0000000000000002 ffff00000b385a28 ffff00000a032000 0000000000000000<br>=
&gt; [ =C2=A0 =C2=A01.636732] 3bc0: 0000000000000003 00000000000487d1 ffff8=
003c0400000 0000000000000001<br>&gt; [ =C2=A0 =C2=A01.644522] 3be0: 0000000=
0000000b4 00000000000000b4<br>&gt; [ =C2=A0 =C2=A01.649844] [&lt;ffff000009=
e43e90&gt;] unpack_to_rootfs+0x1fc/0x664<br>&gt; [ =C2=A0 =C2=A01.656125] [=
&lt;ffff000009e456ec&gt;] populate_rootfs+0x11c/0x22c<br>&gt; [ =C2=A0 =C2=
=A01.661758] [&lt;ffff00000809256c&gt;] do_one_initcall+0x1d4/0x520<br>&gt;=
 [ =C2=A0 =C2=A01.667399] [&lt;ffff000009e41d24&gt;] kernel_init_freeable+0=
x2b4/0x4b0<br>&gt; [ =C2=A0 =C2=A01.674061] [&lt;ffff000009693ea4&gt;] kern=
el_init+0x3c/0x368<br>&gt; [ =C2=A0 =C2=A01.679486] [&lt;ffff000008097e10&g=
t;] ret_from_fork+0x10/0x40<br>&gt; [ =C2=A0 =C2=A01.684774] Code: 91000421=
 f900a401 b4fffe18 f940a801 (394002e2)<br>&gt; [ =C2=A0 =C2=A01.690902] ---=
[ end trace 13152abe1ac10cde ]---<br>&gt; [ =C2=A0 =C2=A01.696013] Kernel p=
anic - not syncing: Attempted to kill init! exitcode=3D0x0000000b<br>&gt; [=
 =C2=A0 =C2=A01.696013]<br>&gt; [ =C2=A0 =C2=A01.705870] CPU6: stopping<br>=
&gt; [ =C2=A0 =C2=A01.708700] CPU: 6 PID: 0 Comm: swapper/6 Tainted: G =C2=
=A0 =C2=A0 =C2=A0D 4.6.0-rc1 #8<br>&gt; [ =C2=A0 =C2=A01.716398] Hardware n=
ame: AppliedMicro Mustang/Mustang, BIOS 3.05.05-beta_rc Jan 27 2016<br>&gt;=
 [ =C2=A0 =C2=A01.724871] Call trace:<br>&gt; [ =C2=A0 =C2=A01.727399] [&lt=
;ffff0000080a4ad0&gt;] dump_backtrace+0x0/0x4b0<br>&gt; [ =C2=A0 =C2=A01.73=
3017] [&lt;ffff0000080a4fbc&gt;] show_stack+0x3c/0x60<br>&gt; [ =C2=A0 =C2=
=A01.738246] [&lt;ffff000008aa172c&gt;] dump_stack+0x1dc/0x2c8<br>&gt; [ =
=C2=A0 =C2=A01.743656] [&lt;ffff0000080b2120&gt;] handle_IPI+0xa08/0xa40<br=
>&gt; [ =C2=A0 =C2=A01.749065] [&lt;ffff000008090cfc&gt;] gic_handle_irq+0x=
164/0x260<br>&gt; [ =C2=A0 =C2=A01.754836] Exception stack(0xffff8003fff03f=
a0 to 0xffff8003fff040c0)<br>&gt; [ =C2=A0 =C2=A01.761497] 3fa0: ffff8003c0=
443da0 ffff00000a8c29e0 ffff8003c0443ec0 ffff000008099964<br>&gt; [ =C2=A0 =
=C2=A01.769601] 3fc0: 0000000060000045 ffff00000a030000 ffff8003fff00020 ff=
ff8003fff04010<br>&gt; [ =C2=A0 =C2=A01.777740] 3fe0: 0000000000000001 ffff=
8003c0440000 ffff00000800f000 ffff8003c0443da0<br>&gt; [ =C2=A0 =C2=A01.785=
852] 4000: ffff8003c0443ec0 ffff8003c0443da0 0000000000000000 0000000000000=
000<br>&gt; [ =C2=A0 =C2=A01.793982] 4020: 0000000000000000 000000000000000=
0 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A01.802095] 4040: =
0000000000000000 0000000000000000 0000000000000000 0000000000000000<br>&gt;=
 [ =C2=A0 =C2=A01.810225] 4060: 0000000000000000 0000000000000000 000000000=
0000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A01.818329] 4080: 00000000000=
00000 0000000000000000 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =
=C2=A01.826416] 40a0: 0000000000000000 0000000000000000 0000000000000000 00=
00000000000000<br>&gt; [ =C2=A0 =C2=A01.834520] [&lt;ffff000008097724&gt;] =
el1_irq+0xa4/0x114<br>&gt; [ =C2=A0 =C2=A01.839619] [&lt;ffff000008099964&g=
t;] arch_cpu_idle+0x94/0x508<br>&gt; [ =C2=A0 =C2=A01.845177] [&lt;ffff0000=
08209598&gt;] default_idle_call+0xd0/0xf8<br>&gt; [ =C2=A0 =C2=A01.851010] =
[&lt;ffff000008209e04&gt;] cpu_startup_entry+0x844/0xa30<br>&gt; [ =C2=A0 =
=C2=A01.857024] [&lt;ffff0000080b0c6c&gt;] secondary_start_kernel+0x3dc/0x4=
68<br>&gt; [ =C2=A0 =C2=A01.863522] [&lt;00000040002921fc&gt;] 0x40002921fc=
<br>&gt; [ =C2=A0 =C2=A01.868054] CPU5: stopping<br>&gt; [ =C2=A0 =C2=A01.8=
70880] CPU: 5 PID: 0 Comm: swapper/5 Tainted: G =C2=A0 =C2=A0 =C2=A0D 4.6.0=
-rc1 #8<br>&gt; [ =C2=A0 =C2=A01.878585] Hardware name: AppliedMicro Mustan=
g/Mustang, BIOS 3.05.05-beta_rc Jan 27 2016<br>&gt; [ =C2=A0 =C2=A01.887085=
] Call trace:<br>&gt; [ =C2=A0 =C2=A01.889672] [&lt;ffff0000080a4ad0&gt;] d=
ump_backtrace+0x0/0x4b0<br>&gt; [ =C2=A0 =C2=A01.895264] [&lt;ffff0000080a4=
fbc&gt;] show_stack+0x3c/0x60<br>&gt; [ =C2=A0 =C2=A01.900492] [&lt;ffff000=
008aa172c&gt;] dump_stack+0x1dc/0x2c8<br>&gt; [ =C2=A0 =C2=A01.905892] [&lt=
;ffff0000080b2120&gt;] handle_IPI+0xa08/0xa40<br>&gt; [ =C2=A0 =C2=A01.9113=
36] [&lt;ffff000008090cfc&gt;] gic_handle_irq+0x164/0x260<br>&gt; [ =C2=A0 =
=C2=A01.917072] Exception stack(0xffff8003ffed3fa0 to 0xffff8003ffed40c0)<b=
r>&gt; [ =C2=A0 =C2=A01.923742] 3fa0: ffff8003c043fda0 ffff00000a8c29e0 fff=
f8003c043fec0 ffff000008099964<br>&gt; [ =C2=A0 =C2=A01.931873] 3fc0: 00000=
00060000045 ffff00000a030000 ffff8003ffed0020 ffff8003ffed4010<br>&gt; [ =
=C2=A0 =C2=A01.939994] 3fe0: 0000000000000001 ffff8003c043c000 ffff00000800=
f000 ffff8003c043fda0<br>&gt; [ =C2=A0 =C2=A01.948133] 4000: ffff8003c043fe=
c0 ffff8003c043fda0 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=
=A01.956202] 4020: 0000000000000000 0000000000000000 0000000000000000 00000=
00000000000<br>&gt; [ =C2=A0 =C2=A01.964375] 4040: 0000000000000000 0000000=
000000000 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A01.972462=
] 4060: 0000000000000000 0000000000000000 0000000000000000 0000000000000000=
<br>&gt; [ =C2=A0 =C2=A01.980644] 4080: 0000000000000000 0000000000000000 0=
000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A01.988782] 40a0: 000=
0000000000000 0000000000000000 0000000000000000 0000000000000000<br>&gt; [ =
=C2=A0 =C2=A01.996843] [&lt;ffff000008097724&gt;] el1_irq+0xa4/0x114<br>&gt=
; [ =C2=A0 =C2=A02.001899] [&lt;ffff000008099964&gt;] arch_cpu_idle+0x94/0x=
508<br>&gt; [ =C2=A0 =C2=A02.007473] [&lt;ffff000008209598&gt;] default_idl=
e_call+0xd0/0xf8<br>&gt; [ =C2=A0 =C2=A02.013358] [&lt;ffff000008209e04&gt;=
] cpu_startup_entry+0x844/0xa30<br>&gt; [ =C2=A0 =C2=A02.019415] [&lt;ffff0=
000080b0c6c&gt;] secondary_start_kernel+0x3dc/0x468<br>&gt; [ =C2=A0 =C2=A0=
2.025877] [&lt;00000040002921fc&gt;] 0x40002921fc<br>&gt; [ =C2=A0 =C2=A02.=
030417] CPU3: stopping<br>&gt; [ =C2=A0 =C2=A02.033243] CPU: 3 PID: 0 Comm:=
 swapper/3 Tainted: G =C2=A0 =C2=A0 =C2=A0D 4.6.0-rc1 #8<br>&gt; [ =C2=A0 =
=C2=A02.040862] Hardware name: AppliedMicro Mustang/Mustang, BIOS 3.05.05-b=
eta_rc Jan 27 2016<br>&gt; [ =C2=A0 =C2=A02.049354] Call trace:<br>&gt; [ =
=C2=A0 =C2=A02.051890] [&lt;ffff0000080a4ad0&gt;] dump_backtrace+0x0/0x4b0<=
br>&gt; [ =C2=A0 =C2=A02.057507] [&lt;ffff0000080a4fbc&gt;] show_stack+0x3c=
/0x60<br>&gt; [ =C2=A0 =C2=A02.062752] [&lt;ffff000008aa172c&gt;] dump_stac=
k+0x1dc/0x2c8<br>&gt; [ =C2=A0 =C2=A02.068144] [&lt;ffff0000080b2120&gt;] h=
andle_IPI+0xa08/0xa40<br>&gt; [ =C2=A0 =C2=A02.073544] [&lt;ffff000008090cf=
c&gt;] gic_handle_irq+0x164/0x260<br>&gt; [ =C2=A0 =C2=A02.079315] Exceptio=
n stack(0xffff8003ffe73fa0 to 0xffff8003ffe740c0)<br>&gt; [ =C2=A0 =C2=A02.=
085968] 3fa0: ffff8003c0437da0 ffff00000a8c29e0 ffff8003c0437ec0 ffff000008=
099964<br>&gt; [ =C2=A0 =C2=A02.094064] 3fc0: 0000000060000045 ffff00000a03=
0000 ffff8003ffe70020 ffff8003ffe74010<br>&gt; [ =C2=A0 =C2=A02.102212] 3fe=
0: 0000000000000001 ffff8003c0434000 ffff00000800f000 ffff8003c0437da0<br>&=
gt; [ =C2=A0 =C2=A02.110272] 4000: ffff8003c0437ec0 ffff8003c0437da0 000000=
0000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A02.118359] 4020: 00000000=
00000000 0000000000000000 0000000000000000 0000000000000000<br>&gt; [ =C2=
=A0 =C2=A02.126480] 4040: 0000000000000000 0000000000000000 000000000000000=
0 0000000000000000<br>&gt; [ =C2=A0 =C2=A02.134636] 4060: 0000000000000000 =
0000000000000000 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A02=
.142731] 4080: 0000000000000000 0000000000000000 0000000000000000 000000000=
0000000<br>&gt; [ =C2=A0 =C2=A02.150818] 40a0: 0000000000000000 00000000000=
00000 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A02.158905] [&=
lt;ffff000008097724&gt;] el1_irq+0xa4/0x114<br>&gt; [ =C2=A0 =C2=A02.163951=
] [&lt;ffff000008099964&gt;] arch_cpu_idle+0x94/0x508<br>&gt; [ =C2=A0 =C2=
=A02.169534] [&lt;ffff000008209598&gt;] default_idle_call+0xd0/0xf8<br>&gt;=
 [ =C2=A0 =C2=A02.175392] [&lt;ffff000008209e04&gt;] cpu_startup_entry+0x84=
4/0xa30<br>&gt; [ =C2=A0 =C2=A02.181424] [&lt;ffff0000080b0c6c&gt;] seconda=
ry_start_kernel+0x3dc/0x468<br>&gt; [ =C2=A0 =C2=A02.187946] [&lt;000000400=
02921fc&gt;] 0x40002921fc<br>&gt; [ =C2=A0 =C2=A02.192458] CPU0: stopping<b=
r>&gt; [ =C2=A0 =C2=A02.195280] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G =
=C2=A0 =C2=A0 =C2=A0D 4.6.0-rc1 #8<br>&gt; [ =C2=A0 =C2=A02.202968] Hardwar=
e name: AppliedMicro Mustang/Mustang, BIOS 3.05.05-beta_rc Jan 27 2016<br>&=
gt; [ =C2=A0 =C2=A02.211441] Call trace:<br>&gt; [ =C2=A0 =C2=A02.213992] [=
&lt;ffff0000080a4ad0&gt;] dump_backtrace+0x0/0x4b0<br>&gt; [ =C2=A0 =C2=A02=
.219558] [&lt;ffff0000080a4fbc&gt;] show_stack+0x3c/0x60<br>&gt; [ =C2=A0 =
=C2=A02.224785] [&lt;ffff000008aa172c&gt;] dump_stack+0x1dc/0x2c8<br>&gt; [=
 =C2=A0 =C2=A02.230210] [&lt;ffff0000080b2120&gt;] handle_IPI+0xa08/0xa40<b=
r>&gt; [ =C2=A0 =C2=A02.235645] [&lt;ffff000008090cfc&gt;] gic_handle_irq+0=
x164/0x260<br>&gt; [ =C2=A0 =C2=A02.241398] Exception stack(0xffff8003ffde3=
fa0 to 0xffff8003ffde40c0)<br>&gt; [ =C2=A0 =C2=A02.248085] 3fa0: ffff00000=
a013d70 ffff00000a8c29e0 ffff00000a013e90 ffff000008099964<br>&gt; [ =C2=A0=
 =C2=A02.256188] 3fc0: 0000000060000045 ffff00000a030000 ffff8003ffde0020 f=
fff8003ffde4010<br>&gt; [ =C2=A0 =C2=A02.264309] 3fe0: 0000000000000001 fff=
f00000a010000 ffff00000800f000 ffff00000a013d70<br>&gt; [ =C2=A0 =C2=A02.27=
2386] 4000: ffff00000a013e90 ffff00000a013d70 0000000000000000 000000000000=
0000<br>&gt; [ =C2=A0 =C2=A02.280481] 4020: 0000000000000000 00000000000000=
00 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A02.288584] 4040:=
 0000000000000000 0000000000000000 0000000000000000 0000000000000000<br>&gt=
; [ =C2=A0 =C2=A02.296704] 4060: 0000000000000000 0000000000000000 00000000=
00000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A02.304746] 4080: 0000000000=
000000 0000000000000000 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =
=C2=A02.312814] 40a0: 0000000000000000 0000000000000000 0000000000000000 00=
00000000000000<br>&gt; [ =C2=A0 =C2=A02.320840] [&lt;ffff000008097724&gt;] =
el1_irq+0xa4/0x114<br>&gt; [ =C2=A0 =C2=A02.325842] [&lt;ffff000008099964&g=
t;] arch_cpu_idle+0x94/0x508<br>&gt; [ =C2=A0 =C2=A02.331468] [&lt;ffff0000=
08209598&gt;] default_idle_call+0xd0/0xf8<br>&gt; [ =C2=A0 =C2=A02.337274] =
[&lt;ffff000008209e04&gt;] cpu_startup_entry+0x844/0xa30<br>&gt; [ =C2=A0 =
=C2=A02.343279] [&lt;ffff000009693e48&gt;] rest_init+0x168/0x188<br>&gt; [ =
=C2=A0 =C2=A02.348644] [&lt;ffff000009e41a4c&gt;] start_kernel+0xb70/0xb94<=
br>&gt; [ =C2=A0 =C2=A02.354250] [&lt;ffff0000080811c8&gt;] 0xffff000008081=
1c8<br>&gt; [ =C2=A0 =C2=A02.359279] CPU2: stopping<br>&gt; [ =C2=A0 =C2=A0=
2.362048] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G =C2=A0 =C2=A0 =C2=A0D 4.=
6.0-rc1 #8<br>&gt; [ =C2=A0 =C2=A02.369745] Hardware name: AppliedMicro Mus=
tang/Mustang, BIOS 3.05.05-beta_rc Jan 27 2016<br>&gt; [ =C2=A0 =C2=A02.378=
261] Call trace:<br>&gt; [ =C2=A0 =C2=A02.380811] [&lt;ffff0000080a4ad0&gt;=
] dump_backtrace+0x0/0x4b0<br>&gt; [ =C2=A0 =C2=A02.386298] [&lt;ffff000008=
0a4fbc&gt;] show_stack+0x3c/0x60<br>&gt; [ =C2=A0 =C2=A02.391550] [&lt;ffff=
000008aa172c&gt;] dump_stack+0x1dc/0x2c8<br>&gt; [ =C2=A0 =C2=A02.396846] [=
&lt;ffff0000080b2120&gt;] handle_IPI+0xa08/0xa40<br>&gt; [ =C2=A0 =C2=A02.4=
02237] [&lt;ffff000008090cfc&gt;] gic_handle_irq+0x164/0x260<br>&gt; [ =C2=
=A0 =C2=A02.408058] Exception stack(0xffff8003ffe43fa0 to 0xffff8003ffe440c=
0)<br>&gt; [ =C2=A0 =C2=A02.414598] 3fa0: ffff8003c0433da0 ffff00000a8c29e0=
 ffff8003c0433ec0 ffff000008099964<br>&gt; [ =C2=A0 =C2=A02.422813] 3fc0: 0=
000000060000045 ffff00000a030000 ffff8003ffe40020 ffff8003ffe44010<br>&gt; =
[ =C2=A0 =C2=A02.430968] 3fe0: 0000000000000001 ffff8003c0430000 ffff000008=
00f000 ffff8003c0433da0<br>&gt; [ =C2=A0 =C2=A02.439028] 4000: ffff8003c043=
3ec0 ffff8003c0433da0 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =
=C2=A02.447096] 4020: 0000000000000000 0000000000000000 0000000000000000 00=
00000000000000<br>&gt; [ =C2=A0 =C2=A02.455199] 4040: 0000000000000000 0000=
000000000000 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A02.463=
138] 4060: 0000000000000000 0000000000000000 0000000000000000 0000000000000=
000<br>&gt; [ =C2=A0 =C2=A02.471309] 4080: 0000000000000000 000000000000000=
0 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A02.479455] 40a0: =
0000000000000000 0000000000000000 0000000000000000 0000000000000000<br>&gt;=
 [ =C2=A0 =C2=A02.487550] [&lt;ffff000008097724&gt;] el1_irq+0xa4/0x114<br>=
&gt; [ =C2=A0 =C2=A02.492655] [&lt;ffff000008099964&gt;] arch_cpu_idle+0x94=
/0x508<br>&gt; [ =C2=A0 =C2=A02.498271] [&lt;ffff000008209598&gt;] default_=
idle_call+0xd0/0xf8<br>&gt; [ =C2=A0 =C2=A02.504103] [&lt;ffff000008209e04&=
gt;] cpu_startup_entry+0x844/0xa30<br>&gt; [ =C2=A0 =C2=A02.510288] [&lt;ff=
ff0000080b0c6c&gt;] secondary_start_kernel+0x3dc/0x468<br>&gt; [ =C2=A0 =C2=
=A02.516870] [&lt;00000040002921fc&gt;] 0x40002921fc<br>&gt; [ =C2=A0 =C2=
=A02.521329] CPU4: stopping<br>&gt; [ =C2=A0 =C2=A02.524132] CPU: 4 PID: 0 =
Comm: swapper/4 Tainted: G =C2=A0 =C2=A0 =C2=A0D 4.6.0-rc1 #8<br>&gt; [ =C2=
=A0 =C2=A02.532010] Hardware name: AppliedMicro Mustang/Mustang, BIOS 3.05.=
05-beta_rc Jan 27 2016<br>&gt; [ =C2=A0 =C2=A02.540301] Call trace:<br>&gt;=
 [ =C2=A0 =C2=A02.542816] [&lt;ffff0000080a4ad0&gt;] dump_backtrace+0x0/0x4=
b0<br>&gt; [ =C2=A0 =C2=A02.548441] [&lt;ffff0000080a4fbc&gt;] show_stack+0=
x3c/0x60<br>&gt; [ =C2=A0 =C2=A02.553719] [&lt;ffff000008aa172c&gt;] dump_s=
tack+0x1dc/0x2c8<br>&gt; [ =C2=A0 =C2=A02.559195] [&lt;ffff0000080b2120&gt;=
] handle_IPI+0xa08/0xa40<br>&gt; [ =C2=A0 =C2=A02.564655] [&lt;ffff00000809=
0cfc&gt;] gic_handle_irq+0x164/0x260<br>&gt; [ =C2=A0 =C2=A02.570433] Excep=
tion stack(0xffff8003ffea3fa0 to 0xffff8003ffea40c0)<br>&gt; [ =C2=A0 =C2=
=A02.576998] 3fa0: ffff8003c043bda0 ffff00000a8c29e0 ffff8003c043bec0 ffff0=
00008099964<br>&gt; [ =C2=A0 =C2=A02.584989] 3fc0: 0000000060000045 ffff000=
00a030000 ffff8003ffea0020 ffff8003ffea4010<br>&gt; [ =C2=A0 =C2=A02.593049=
] 3fe0: 0000000000000001 ffff8003c0438000 ffff00000800f000 ffff8003c043bda0=
<br>&gt; [ =C2=A0 =C2=A02.601057] 4000: ffff8003c043bec0 ffff8003c043bda0 0=
000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A02.609099] 4020: 000=
0000000000000 0000000000000000 0000000000000000 0000000000000000<br>&gt; [ =
=C2=A0 =C2=A02.617479] 4040: 0000000000000000 0000000000000000 000000000000=
0000 0000000000000000<br>&gt; [ =C2=A0 =C2=A02.625581] 4060: 00000000000000=
00 0000000000000000 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=
=A02.633529] 4080: 0000000000000000 0000000000000000 0000000000000000 00000=
00000000000<br>&gt; [ =C2=A0 =C2=A02.641683] 40a0: 0000000000000000 0000000=
000000000 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A02.649821=
] [&lt;ffff000008097724&gt;] el1_irq+0xa4/0x114<br>&gt; [ =C2=A0 =C2=A02.65=
4797] [&lt;ffff000008099964&gt;] arch_cpu_idle+0x94/0x508<br>&gt; [ =C2=A0 =
=C2=A02.660300] [&lt;ffff000008209598&gt;] default_idle_call+0xd0/0xf8<br>&=
gt; [ =C2=A0 =C2=A02.666149] [&lt;ffff000008209e04&gt;] cpu_startup_entry+0=
x844/0xa30<br>&gt; [ =C2=A0 =C2=A02.672144] [&lt;ffff0000080b0c6c&gt;] seco=
ndary_start_kernel+0x3dc/0x468<br>&gt; [ =C2=A0 =C2=A02.678562] [&lt;000000=
40002921fc&gt;] 0x40002921fc<br>&gt; [ =C2=A0 =C2=A02.683011] CPU7: stoppin=
g<br>&gt; [ =C2=A0 =C2=A02.685710] CPU: 7 PID: 0 Comm: swapper/7 Tainted: G=
 =C2=A0 =C2=A0 =C2=A0D 4.6.0-rc1 #8<br>&gt; [ =C2=A0 =C2=A02.693069] Hardwa=
re name: AppliedMicro Mustang/Mustang, BIOS 3.05.05-beta_rc Jan 27 2016<br>=
&gt; [ =C2=A0 =C2=A02.701395] Call trace:<br>&gt; [ =C2=A0 =C2=A02.703858] =
[&lt;ffff0000080a4ad0&gt;] dump_backtrace+0x0/0x4b0<br>&gt; [ =C2=A0 =C2=A0=
2.709231] [&lt;ffff0000080a4fbc&gt;] show_stack+0x3c/0x60<br>&gt; [ =C2=A0 =
=C2=A02.714267] [&lt;ffff000008aa172c&gt;] dump_stack+0x1dc/0x2c8<br>&gt; [=
 =C2=A0 =C2=A02.719700] [&lt;ffff0000080b2120&gt;] handle_IPI+0xa08/0xa40<b=
r>&gt; [ =C2=A0 =C2=A02.724900] [&lt;ffff000008090cfc&gt;] gic_handle_irq+0=
x164/0x260<br>&gt; [ =C2=A0 =C2=A02.730782] Exception stack(0xffff8003fff33=
fa0 to 0xffff8003fff340c0)<br>&gt; [ =C2=A0 =C2=A02.737261] 3fa0: ffff8003c=
0447da0 ffff00000a8c29e0 ffff8003c0447ec0 ffff000008099964<br>&gt; [ =C2=A0=
 =C2=A02.745061] 3fc0: 0000000060000045 ffff00000a030000 ffff8003fff30020 f=
fff8003fff34010<br>&gt; [ =C2=A0 =C2=A02.752922] 3fe0: 0000000000000001 fff=
f8003c0444000 ffff00000800f000 ffff8003c0447da0<br>&gt; [ =C2=A0 =C2=A02.76=
0731] 4000: ffff8003c0447ec0 ffff8003c0447da0 0000000000000000 000000000000=
0000<br>&gt; [ =C2=A0 =C2=A02.768756] 4020: 0000000000000000 00000000000000=
00 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A02.777143] 4040:=
 0000000000000000 0000000000000000 0000000000000000 0000000000000000<br>&gt=
; [ =C2=A0 =C2=A02.785298] 4060: 0000000000000000 0000000000000000 00000000=
00000000 0000000000000000<br>&gt; [ =C2=A0 =C2=A02.793366] 4080: 0000000000=
000000 0000000000000000 0000000000000000 0000000000000000<br>&gt; [ =C2=A0 =
=C2=A02.801217] 40a0: 0000000000000000 0000000000000000 0000000000000000 00=
00000000000000<br>&gt; [ =C2=A0 =C2=A02.809406] [&lt;ffff000008097724&gt;] =
el1_irq+0xa4/0x114<br>&gt; [ =C2=A0 =C2=A02.814486] [&lt;ffff000008099964&g=
t;] arch_cpu_idle+0x94/0x508<br>&gt; [ =C2=A0 =C2=A02.819859] [&lt;ffff0000=
08209598&gt;] default_idle_call+0xd0/0xf8<br>&gt; [ =C2=A0 =C2=A02.825500] =
[&lt;ffff000008209e04&gt;] cpu_startup_entry+0x844/0xa30<br>&gt; [ =C2=A0 =
=C2=A02.831556] [&lt;ffff0000080b0c6c&gt;] secondary_start_kernel+0x3dc/0x4=
68<br>&gt; [ =C2=A0 =C2=A02.837792] [&lt;00000040002921fc&gt;] 0x40002921fc=
<br>&gt; [ =C2=A0 =C2=A02.842501] ---[ end Kernel panic - not syncing: Atte=
mpted to kill init! exitcode=3D0x0000000b<br>&gt; [ =C2=A0 =C2=A02.842501]<=
br>&gt;<br>&gt; On 5/15/16 4:08 PM, Christoffer Dall wrote:<br>&gt;&gt;<br>=
&gt;&gt; Yes, I test this for every release.<br>&gt;&gt;<br>&gt;&gt; What&#=
39;s your config? What are the symptoms?<br>&gt;&gt;<br>&gt;&gt; Are you bo=
oting with UEFI or u-boot on your mustang?<br>&gt;&gt;<br>&gt;&gt; Thanks,<=
br>&gt;&gt; -Christoffer<br>&gt;&gt;<br>&gt;&gt; On Saturday, May 14, 2016,=
 Itaru Kitayama &lt;<a href=3D"mailto:itaru.kitayama@riken.jp">itaru.kitaya=
ma@riken.jp</a><br>&gt;&gt; &lt;mailto:<a href=3D"mailto:itaru.kitayama@rik=
en.jp">itaru.kitayama@riken.jp</a>&gt;&gt; wrote:<br>&gt;&gt;<br>&gt;&gt; =
=C2=A0 =C2=A0 Hi,<br>&gt;&gt;<br>&gt;&gt; =C2=A0 =C2=A0 The tag kvm-arm-for=
-4.7 fails to boot on Mustang. Has anyone<br>&gt;&gt; =C2=A0 =C2=A0 verifie=
d this tag on Mustang? The F/W I&#39;m using is 3.05.05-beta_rc.<br>&gt;&gt=
; =C2=A0 =C2=A0 _______________________________________________<br>&gt;&gt;=
 =C2=A0 =C2=A0 kvmarm mailing list<br>&gt;&gt; =C2=A0 =C2=A0 <a href=3D"mai=
lto:kvmarm@lists.cs.columbia.edu">kvmarm@lists.cs.columbia.edu</a><br>&gt;&=
gt; =C2=A0 =C2=A0 <a href=3D"https://lists.cs.columbia.edu/mailman/listinfo=
/kvmarm">https://lists.cs.columbia.edu/mailman/listinfo/kvmarm</a>
</div>

--94eb2c0bad1af592be0532dfafaf--

--===============3341730558366990863==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm

--===============3341730558366990863==--
