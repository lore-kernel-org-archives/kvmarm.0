From: Christoffer Dall <cdall@linaro.org>
Subject: [RFC PATCH 0/4] Handle forwarded level-triggered interrupts
Date: Tue, 29 Aug 2017 11:38:58 +0200
Message-ID: <20170829093902.15379-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB34049C2B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Aug 2017 05:36:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xRSOZV8B12Qm for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Aug 2017 05:36:58 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7EE6640C5A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Aug 2017 05:36:58 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id b82so17043874wmd.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Aug 2017 02:39:08 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, Eric Auger <eric.auger@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This series illustrates an alternative approach to Eric Auger's direct EOI
setup patches [1] in terms of the KVM VGIC support.

The idea is to maintain existing semantics for the VGIC for mapped
level-triggered IRQs and think support for the timer into it.

Patch 1 is stolen from Eric's series and is necessary for these patches
to compile as well.  Patch 2 includes the core support for mapped
level-triggered interrupts.  Patch 3 moves some code around for patch 4.
Patch 4 implements an optimization for the timer.  The last two patches
could be deferred until the timer optimization series.

This series is untested (hence the RFC tag) and I'm looking for
feedback from the VGIC guys (you know who you are) on the approach and
whether we know up-front that this breaks for some reason.

I'll be happy to test and debug further if we agree on the overall
approach.

Based on v4.13-rc7.

Thanks,
-Christoffer

[1]: https://lists.cs.columbia.edu/pipermail/kvmarm/2017-June/026072.html

Christoffer Dall (3):
  KVM: arm/arm64: vgic: Support level-triggered mapped interrupts
  KVM: arm/arm64: Rearrange kvm_vgic_[un]map_phys code in vgic.c
  KVM: arm/arm64: Provide a vgic interrupt line level sample function

Eric Auger (1):
  KVM: arm/arm64: vgic: restructure kvm_vgic_(un)map_phys_irq

 include/kvm/arm_vgic.h      | 19 +++++++++++--
 virt/kvm/arm/arch_timer.c   | 38 ++++++++++---------------
 virt/kvm/arm/vgic/vgic-v2.c | 29 +++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c | 29 +++++++++++++++++++
 virt/kvm/arm/vgic/vgic.c    | 68 +++++++++++++++++++++++++++++++++++++--------
 virt/kvm/arm/vgic/vgic.h    |  7 +++++
 6 files changed, 153 insertions(+), 37 deletions(-)

-- 
2.9.0
