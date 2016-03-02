From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: Intermittent guest kernel crashes with v4.5-rc6.
Date: Wed, 2 Mar 2016 07:56:35 -0600
Message-ID: <56D6F113.9020605@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E893440B58
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2016 08:49:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l-65tZseHfOM for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Mar 2016 08:49:28 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D955540B40
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Mar 2016 08:49:27 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu


For some reason v4.5-rc6 kernel is not stable for guest machines on 
Qualcomm server platforms.
We are getting IABT translation faults while booting the guest kernel. 
The problem disappears with
the following code snippet (insert "dsb ish" instruction just before 
switching to EL1 guest). I am
using v4.5-rc6 kernel for both host and guest machines.

Please let me know if you have any thoughts or ideas for tracing this 
problem.

--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -88,6 +88,7 @@ ENTRY(__guest_enter)
         ldp     x0, x1, [sp], #16

         // Do not touch any register after this!
+       dsb ish
         eret
  ENDPROC(__guest_enter)


Using below QEMU command for launching guest machine:

qemu-system-aarch64 -machine type=virt,accel=kvm,gic-version=3  \
-cpu "host" -smp cpus=1,maxcpus=1 -m 256M -serial stdio \
-kernel /boot/Image -initrd /boot/rootfs.cpio.gz \
-append 'earlycon=earlycon=pl011,0x09000000  \
console=ttyAMA0,115200 root=/dev/ram'


Guest machine crash log messages:

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Boot CPU: AArch64 Processor [510f2811]
[    0.000000] Bad mode in Synchronous Abort handler detected, code 
0x8600000f -- IABT (current EL)
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 4.5.rc6+
[    0.000000] task: ffffffc000d52200 ti: ffffffc000d44000 task.ti: 
ffffffc000d44000
[    0.000000] PC is at early_init_dt_scan_root+0x28/0x94
[    0.000000] LR is at of_scan_flat_dt+0x9c/0xd0
[    0.000000] pc : [<ffffffc000cb32e8>] lr : [<ffffffc000cb3248>] 
pstate: 800003c5
[    0.000000] sp : ffffffc000d47e80
[    0.000000] x29: ffffffc000d47e80 x28: 0000000000000000

-- 
Shanker Donthineni
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
