From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 0/3] Support userspace irqchip with arch timers
Date: Tue, 27 Sep 2016 21:08:03 +0200
Message-ID: <20160927190806.22988-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF93C41390
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 14:58:33 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J533y91wnzn5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 14:58:32 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F25EE41267
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 14:58:31 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id b130so30169622wmc.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 12:07:55 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,

Marc and I have been looking at this during Linaro connect and have
slightly reworked your patch into this small series.

It would be good if you could have a look at it and test it out.

I've tested it with your QEMU, and it works for UP, but secondary CPUs
fail to come up, and it looks like the kernel never gets an IPI for
those CPUs from userspace.  Any chance you're willing to take a look at
that?

Also, let me know if the split of your patch with preserving your
authorship is ok with you.

Thanks,
-Christoffer

---

This series slightly reworks the patches to support architected timers
with a userspace irqchip sent by Alexander Graf [1].

We first cleanup some of the timer code to make it easier to understand
what is being done in the later patches, and then split up the
implementation into two separate patches (maintaining original
authorship).

Several changes have been made compared to v7 of the original single
patch, including:
 - Rewording ABI documentation to be more in line with the ARM
   architecture
 - Add an explicit check for needing to notify userspace of a level
   change instead of propagating the value
 - Changes to commenting throughout to more accurately describe the
   architecture concepts we try to maintain
 - Reword of functions, for example from sync to update when the date
   only flows one direction

These patches are based on two fixes necessary to test them which deal
with running kernel code without an in-kernl irqchip, and they are both
in kvmarm/next[2].

[1]: https://lists.cs.columbia.edu/pipermail/kvmarm/2016-September/021867.html
[2]: git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next

Alexander Graf (2):
  KVM: arm/arm64: Add ARM arch timer interrupts ABI
  KVM: arm/arm64: Support arch timers with a userspace gic

Christoffer Dall (1):
  KVM: arm/arm64: Cleanup the arch timer code's irqchip checking

 Documentation/virtual/kvm/api.txt |  29 ++++++++++
 arch/arm/include/uapi/asm/kvm.h   |   2 +
 arch/arm/kvm/arm.c                |  19 +++----
 arch/arm64/include/uapi/asm/kvm.h |   2 +
 include/kvm/arm_arch_timer.h      |   2 +
 include/uapi/linux/kvm.h          |   6 +++
 virt/kvm/arm/arch_timer.c         | 111 ++++++++++++++++++++++++++++++--------
 7 files changed, 139 insertions(+), 32 deletions(-)

-- 
2.9.0
