From: Diana Craciun <diana.craciun@freescale.com>
Subject: "info cpus" issue
Date: Mon, 16 Mar 2015 16:35:49 +0200
Message-ID: <5506EA45.1060407@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D876C48E6B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2015 10:29:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RnKiSkKbSb4v for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Mar 2015 10:29:40 -0400 (EDT)
Received: from na01-bn1-obe.outbound.protection.outlook.com
 (mail-bn1bbn0108.outbound.protection.outlook.com [157.56.111.108])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5063848E56
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2015 10:29:39 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

I have played the last couple of days with info CPUs command in qemu and 
discovered two issues with it:

1. One core is displayed as halted, but the core is actually running ok.

(qemu) info cpus
* CPU #0: thread_id=400
   CPU #1: (halted) thread_id=401

Looking a little bit into the qemu code, it seems to be relatively 
benign. qemu displays "halted" on info cpus command depending on the 
value of the halted variable, but this variable does not seem to be 
updated in case of qemu + KVM.

2. When issuing "info cpus" while the guest is booting bad things 
happen. I saw 3 different behaviours:
- the guest just freezes during boot
- the guest crashes (see bellow the crash log)
- the host/qemu is displaying this message and the guest freezes:

(qemu) [16777.503115] kvm [400]: load/store instruction decoding not 
implementd
error: kvm run failed Function not implemented

I did not get the chance to dig into it, but wanted to let you know 
about this, perhaps is an already known issue?

I saw this on 2 different platforms: on a Freescale platform (but with a 
3.12 kernel) and on a cubieboard2 ( Linux version 4.0.0-rc3-00148-gc202baf )

Guest crash:
-----------

Populating dev cache
[    2.635462] Unable to handle kernel paging request at virtual address 
0009c778
[    2.640037] pgd = de50e400
[    2.641707] [0009c778] *pgd=5e500003, *pmd=5e501003, *pte=00000000
[    2.645077] Internal error: Oops: 8000020f [#1] SMP ARM
[    2.647782] CPU: 0 PID: 51 Comm: udevd Not tainted 
4.0.0-rc3-00148-gc202baf #4
[    2.651470] Hardware name: Generic DT based system
[    2.653874] task: de4a6400 ti: de48c000 task.ti: de48c000
[    2.656715] PC is at 0x9c778
[    2.658243] LR is at __wake_up_common+0x4c/0x80
[    2.660552] pc : [<0009c778>]    lr : [<c005d870>] psr: 20030193
[    2.660552] sp : de48dcd8  ip : de48df68  fp : 0009c778
[    2.666224] r10: 00000008  r9 : 00000001  r8 : 00000003
[    2.668964] r7 : 00000000  r6 : 00000000  r5 : ded05e20  r4 : 0000003b
[    2.672256] r3 : 00000000  r2 : 00000000  r1 : 00000003  r0 : de48df68
[    2.674996] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM 
Segment user
[    2.678305] Control: 30c5387d  Table: 5e46a3c0  DAC: fffffffd
[    2.680954] Process udevd (pid: 51, stack limit = 0xde48c210)
[    2.683507] Stack: (0xde48dcd8 to 0xde48e000)
[    2.685648] 
dcc0:                                                       00000000 
ded05e00
[    2.689566] dce0: ded05a00 00000000 40030193 00000003 00000001 
ded22480 c01191b4 c005dac8
[    2.693564] dd00: 00000000 c004e76c de4a4d80 c0119258 00000000 
00000000 ded2248c 00000000
[    2.697693] dd20: 00000000 c005d870 00000000 ded22488 80030193 
00000000 00000001 00000003
[    2.701786] dd40: de4a67b0 00000000 0000000a c005daa0 00000000 
00000000 de4a6400 de48dde0
[    2.705873] dd60: 0000000b de51e000 00000000 c003b740 de51cd80 
00000000 40070093 de48dde0
[    2.709905] dd80: de4a6400 0000000b 60030113 de48dde0 00000000 
de50857c 00000054 c003b780
[    2.713928] dda0: 00000000 00000000 decf6c04 000000c3 00000001 
de4a6400 0000000b ded22048
[    2.718036] ddc0: 60030113 c003c07c 00030002 de508540 00000207 
de4a6400 b6f82328 c0029aa0
[    2.721944] dde0: 0000000b 00000000 00030002 b6f82328 de48f200 
df061300 00000008 c032c0f8
[    2.725968] de00: 00007b35 c052a100 c052a614 c052a614 dfbec180 
c0526180 00000001 dfbec1c0
[    2.730073] de20: c052a614 c0058ec4 00000001 c0524218 00000000 
dfbec1c0 00000000 00000107
[    2.734061] de40: c052a100 c0526180 c00097b8 c00b4350 b6f82328 
c00c210c 00000000 de48df50
[    2.738136] de60: de48df50 c0029f00 00030002 c0049c28 00000000 
00000000 00020000 c0022a9c
[    2.742233] de80: 00000000 00000000 00000000 00000207 c0029c14 
c052e24c b6f82328 de48df50
[    2.745372] dea0: 00000014 b6faa960 be9f7a3c c0008510 ded05e34 
00000000 de48decc c03e7b7c
[    2.749418] dec0: 00000001 de48c000 00000000 c03ea634 beada220 
ded05e34 00000000 00000019
[    2.753284] dee0: 00000001 c01188ac ded05e00 ded05e34 de48df08 
de48df60 00000000 00000000
[    2.757444] df00: ded05e00 c0119110 de48df08 de48df08 00000000 
de4a3240 00000004 de48c000
[    2.761479] df20: 00000000 beada298 de4a3240 ded05e00 ded05e34 
c011a358 b6f9ccd4 00030010
[    2.765605] df40: ffffffff 30c5387d 30c5387d c002279c 0009c778 
b6f82328 00000004 00000034
[    2.769646] df60: 0000955c 0000b3d8 0000003b 000091ac 0009c778 
00000014 b6faa960 be9f7a3c
[    2.773707] df80: 0009c778 be9f7978 b6f8efe0 b6f9ccd4 00030010 
ffffffff de48c000 00000000
[    2.777134] dfa0: ffffe598 c001e820 00033220 00033008 00000004 
beada298 00000004 ffffffff
[    2.780579] dfc0: 00033220 00033008 000323dc 000000fc ffffec00 
beada220 00032420 ffffe598
[    2.783951] dfe0: 00000000 beada1a4 0000dc04 b6f027ec 60070010 
00000004 00000000 00000000
[    2.787839] [<c005d870>] (__wake_up_common) from [<c005dac8>] 
(__wake_up_locked+0x14/0x1c)
[    2.792037] [<c005dac8>] (__wake_up_locked) from [<c0119258>] 
(ep_poll_callback+0xa4/0x13c)
[    2.796327] [<c0119258>] (ep_poll_callback) from [<c005d870>] 
(__wake_up_common+0x4c/0x80)
[    2.800399] [<c005d870>] (__wake_up_common) from [<c005daa0>] 
(__wake_up+0x38/0x4c)
[    2.804319] [<c005daa0>] (__wake_up) from [<c003b740>] 
(__send_signal+0x2e4/0x2ec)
[    2.808110] [<c003b740>] (__send_signal) from [<c003b780>] 
(send_signal+0x38/0x88)
[    2.811663] [<c003b780>] (send_signal) from [<c003c07c>] 
(force_sig_info+0xc0/0xe0)
[    2.815536] [<c003c07c>] (force_sig_info) from [<c0029aa0>] 
(__do_user_fault.isra.7+0x44/0x4c)
[    2.819440] [<c0029aa0>] (__do_user_fault.isra.7) from [<c0029f00>] 
(do_page_fault+0x2ec/0x344)
[    2.823452] [<c0029f00>] (do_page_fault) from [<c0008510>] 
(do_DataAbort+0x30/0x90)
[    2.826712] [<c0008510>] (do_DataAbort) from [<c002279c>] 
(__dabt_usr+0x3c/0x40)
[    2.829789] Exception stack(0xde48df50 to 0xde48df98)
[    2.830934] df40:                                     0009c778 
b6f82328 00000004 00000034
[    2.834235] df60: 0000955c 0000b3d8 0000003b 000091ac 0009c778 
00000014 b6faa960 be9f7a3c
[    2.837981] df80: 0009c778 be9f7978 b6f8efe0 b6f9ccd4 00030010 ffffffff
[    2.841182] Code: 00000000 b6f7fb58 00000001 00000000 (00000000)
[    2.844367] ---[ end trace 9ed69020210a081b ]---


Host messages:
-----------
(qemu) info cpus
* CPU #0: thread_id=383
(qemu) [16371.225508] kvm [383]: load/store instruction decoding not 
implementd
error: kvm run failed Function not implemented
R00=c0555d0c R01=00000207 R02=10070193 R03=e0830000
R04=e0831120 R05=c0029c14 R06=00000207 R07=e083000c
R08=e083000c R09=b6f70960 R10=00000000 R11=be90544c
R12=e0831038 R13=e082ffec R14=c0008510 R15=c00224ac
PSR=50070193 -Z-V A svc32

Thanks,

Diana
