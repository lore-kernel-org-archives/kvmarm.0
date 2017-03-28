From: Prakash B <bjsprakash.linux@gmail.com>
Subject: Aarch64: Qemu master or 2.9.0-rc1 breaks compatibility with 4.10
 kernel.
Date: Tue, 28 Mar 2017 16:52:51 +0530
Message-ID: <CACJhumejPG6s_dewyHH=e5=QLcOUCzvzhakA7oSqm2Ms5cQvRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51FBF40B3E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 07:20:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jjxdLBVHazOJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Mar 2017 07:20:53 -0400 (EDT)
Received: from mail-qt0-f195.google.com (mail-qt0-f195.google.com
 [209.85.216.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 612F640AE8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 07:20:53 -0400 (EDT)
Received: by mail-qt0-f195.google.com with SMTP id n37so11557211qtb.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Mar 2017 04:22:52 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel@nongnu.org, qemu-arm@nongnu.org, peter.maydell@linaro.org, Eric Auger <eric.auger@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, kvmarm@lists.cs.columbia.edu, Vijaya.Kumar@cavium.com
Cc: bprakash@caviumnetworks.com, sgoutham@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi ,

Qemu master or v2.9.0-rc1 doesn't launch guest  when host kernel
version 4.10 or  lower on Aarch64 (cavium ThunderX), its failing with
abort  "qemu-system-aarch64: KVM_GET_DEVICE_ATTR failed: No such
device or address"

"GICv3 live migration support"  patch breaks the  compatibility b/w
kernel and qemu.

Is this expected behaviour,  can we provide a fix without  breaking
compatibility b/w kernel and qemu .

For  more information  below is gdb back trace .
-------------------------------------------------------------------

Thread 1 "qemu-system-aar" received signal SIGABRT, Aborted.
0x0000ffffa4bd7528 in __GI_raise (sig=sig@entry=6) at
../sysdeps/unix/sysv/linux/raise.c:54
54    ../sysdeps/unix/sysv/linux/raise.c: No such file or directory.
(gdb) bt
#0  0x0000ffffa4bd7528 in __GI_raise (sig=sig@entry=6) at
../sysdeps/unix/sysv/linux/raise.c:54
#1  0x0000ffffa4bd89e0 in __GI_abort () at abort.c:89
#2  0x0000000000479d3c in kvm_device_access (fd=23, group=6, attr=50788,
val=0x15c80d8, write=false)
    at /home/ubuntu/workarea/sources/qemu-stable/qemu-2.9/kvm-all.c:2225
#3  0x00000000004ed948 in arm_gicv3_icc_reset (env=0x13a8ff8, ri=0x1629ed0) at
/home/ubuntu/workarea/sources/qemu-stable/qemu-2.9/hw/intc/arm_gicv3_kvm.c:618
#4  0x0000000000610414 in cp_reg_reset (key=0x1629cf0, value=0x1629ed0,
opaque=0x13a0cf0) at
/home/ubuntu/workarea/sources/qemu-stable/qemu-2.9/target/arm/cpu.c:75
#5  0x0000ffffa4fb0878 in g_hash_table_foreach () from
/lib/aarch64-linux-gnu/libglib-2.0.so.0
Backtrace stopped: previous frame identical to this frame (corrupt stack?)



Verified guest  booting on host 4.10 kernel by reverting "GICv3:
support state save/restore" patches  and  guest booted without issues.

Regards,
Prakash B
