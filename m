From: Vijay Kilari <vijay.kilari@gmail.com>
Subject: KVM Live migration with GICv3
Date: Tue, 11 Aug 2015 10:55:12 +0530
Message-ID: <CALicx6soU-pqs3XgkEHxtBVy9yR-7irSU4ZJvC3D6V2UmKHQqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61DEA5A81A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 01:12:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p2LH+r2t9L42 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Aug 2015 01:12:10 -0400 (EDT)
Received: from mail-vk0-f53.google.com (mail-vk0-f53.google.com
 [209.85.213.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52C015A816
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Aug 2015 01:12:10 -0400 (EDT)
Received: by vkbf67 with SMTP id f67so9459802vkb.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 22:25:12 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>, =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, p.fedin@samsung.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

   I have prototyped Live migration with GICv3.
For this I have made following changes

1) Save and Restore of GICv3 registers in QEMU.
    - For GICv2, QEMU is saving/restoring GICD, GICC  registers. For GICv3,
     we have to save/restore GICD, GICR and ICC registers.
     However ICC registers are system registers which cannot be
accessed @ EL0 level (SRE=1). So these ICC registers should be
accessed as mmio registers by QEMU, for this we have to add ioctl to
access ICC @ EL1 level similar to GICC registers of GICv2.

2) KVM ioctls in kernel provides only 32-bit register access to GIC
registers, where
   as some registers in GICD/GICR requires 64-bit register access. I
propose to use mmio.flag to specify 32/64 bit access.

3) KVM ioctls to access ICC registers for GICv3

Please provide your initial feedback. Let me know if some of this
issues are already fixed

I am attending KVM-forum next week @ Seattle. We can discuss there as well.

Regards
Vijay
