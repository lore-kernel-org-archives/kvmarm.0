From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v8 0/9] Handle forwarded level-triggered interrupts
Date: Wed, 13 Dec 2017 11:45:53 +0100
Message-ID: <20171213104602.16383-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0283B49D46
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 05:43:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KBw+F9463GqW for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Dec 2017 05:43:04 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A429B40795
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 05:43:04 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id n138so4066719wmg.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Dec 2017 02:46:36 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This series is an alternative approach to Eric Auger's direct EOI setup
patches [1] in terms of the KVM VGIC support.

The idea is to maintain existing semantics for the VGIC for mapped
level-triggered IRQs and also support the timer using mapped IRQs with
the same VGIC support as VFIO interrupts.

Based on v4.15-rc1.

Also available at:
git://git.kernel.org/pub/scm/linux/kernel/git/cdall/linux.git level-mapped-v8

Changes since v7:
 - Cleanup stale commentary
 - Updated documentation (patch 9/9 is new in this version)
 - Added Eric's reviewed-by tags

Changes since v6:
 - Removed double semi-colon
 - Changed another confusing conditional in patch 6
 - Fixed typos in commit message and comments

Changes since v5:
 - Rebased on v4.15-rc1
 - Changed comment on preemption code as suggested by Andre
 - Fixed white space and confusing conditionals as suggested by Drew

Changes since v4:
 - Rebased on the timer optimization series merged in the v4.15 merge
   window, which caused a fair amount of modifications to patch 3.
 - Added a static key to disable the sync operations when no VMs are
   using userspace irqchips to further optimize the performance
 - Fixed extra semicolon in vgic-mmio.c
 - Added commentary as requested during review
 - Dropped what was patch 4, because it was merged as part of GICv4
   support.
 - Factored out the VGIC input level function change as separate patch
   (helps bisect and debugging), before providing a function for the
   timer.

Changes since v3:
 - Added a number of patches and moved patches around a bit.
 - Check for uaccesses in the mmio handler functions
 - Fixed bugs in the mmio handler functions

Changes since v2:
 - Removed patch 5 from v2 and integrating the changes in what's now
   patch 5 to make it easier to reuse code when adding VFIO integration.
 - Changed the virtual distributor MMIO handling to use the
   pending_latch and more closely match the semantics of SPENDR and
   CPENDR for both level and edge mapped interrupts.

Changes since v1:
 - Added necessary changes to the timer (Patch 1)
 - Added handling of guest MMIO accesses to the virtual distributor
   (Patch 4)
 - Addressed Marc's comments from the initial RFC (mostly renames)

Thanks,
-Christoffer

[1]: https://lists.cs.columbia.edu/pipermail/kvmarm/2017-June/026072.html

Christoffer Dall (9):
  KVM: arm/arm64: Remove redundant preemptible checks
  KVM: arm/arm64: Factor out functionality to get vgic mmio
    requester_vcpu
  KVM: arm/arm64: Don't cache the timer IRQ level
  KVM: arm/arm64: vgic: Support level-triggered mapped interrupts
  KVM: arm/arm64: Support a vgic interrupt line level sample function
  KVM: arm/arm64: Support VGIC dist pend/active changes for mapped IRQs
  KVM: arm/arm64: Provide a get_input_level for the arch timer
  KVM: arm/arm64: Avoid work when userspace iqchips are not used
  KVM: arm/arm64: Update timer and forwarded irq documentation

 Documentation/virtual/kvm/arm/vgic-mapped-irqs.txt |  50 +++++----
 include/kvm/arm_arch_timer.h                       |   2 +
 include/kvm/arm_vgic.h                             |  13 ++-
 virt/kvm/arm/arch_timer.c                          | 112 ++++++++++----------
 virt/kvm/arm/arm.c                                 |   2 -
 virt/kvm/arm/vgic/vgic-mmio.c                      | 115 +++++++++++++++++----
 virt/kvm/arm/vgic/vgic-v2.c                        |  29 ++++++
 virt/kvm/arm/vgic/vgic-v3.c                        |  29 ++++++
 virt/kvm/arm/vgic/vgic.c                           |  41 +++++++-
 virt/kvm/arm/vgic/vgic.h                           |   8 ++
 10 files changed, 292 insertions(+), 109 deletions(-)

-- 
2.14.2
