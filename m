From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v2 0/3] KVM: arm/arm64: Clean up some obsolete code
Date: Fri, 23 Oct 2015 15:48:37 +0300
Message-ID: <cover.1445603900.git.p.fedin@samsung.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Current KVM code has lots of old redundancies, which can be cleaned up.
This patchset is actually a better alternative to
http://www.spinics.net/lists/arm-kernel/msg430726.html, which allows to
keep piggy-backed LRs. The idea is based on the fact that our code also
maintains LR state in elrsr, and this information is enough to track LR
usage.

In case of problems this series can be applied partially, each patch is
a complete refactoring step on its own.

Thanks to Andre Przywara for pinpointing some 4.3+ specifics.

This version has been tested on SMDK5410 development board
(Exynos5410 SoC).

v1 => v2:
- Rebased to kvmarm/next of 23.10.2015.
- Do not use vgic_retire_lr() for initializing ELRSR bitmask, because now
  it also handles pushback of PENDING state, use direct initialization
  instead (copied from Andre's patchset).
- Took more care about vgic_retire_lr(), which has deserved own patch.

Pavel Fedin (3):
  KVM: arm/arm64: Optimize away redundant LR tracking
  KVM: arm/arm64: Merge vgic_set_lr() and vgic_sync_lr_elrsr()
  KVM: arm/arm64: Refactor vgic_retire_lr()

 include/kvm/arm_vgic.h |   7 ----
 virt/kvm/arm/vgic-v2.c |   6 +--
 virt/kvm/arm/vgic-v3.c |   6 +--
 virt/kvm/arm/vgic.c    | 106 ++++++++++++++-----------------------------------
 4 files changed, 31 insertions(+), 94 deletions(-)

-- 
2.4.4

