From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v5 0/4] KVM: arm/arm64: Clean up some obsolete code
Date: Tue, 03 Nov 2015 11:34:04 +0300
Message-ID: <cover.1446539212.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6594149785
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 03:31:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8J8PKYRu1X1A for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 Nov 2015 03:31:09 -0500 (EST)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2EA45496F5
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 Nov 2015 03:31:08 -0500 (EST)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NX800EHVD543VA0@mailout1.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 03 Nov 2015 08:34:16 +0000 (GMT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
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

v4 => v5:
- Split up the first patch into two, for simpler bisection.

v3 => v4:
- Reordered changes for purpose of better understanding and bisection. All
  changes related to vgic_retire_lr() are gathered in one patch now.

v2 => v3:
- Removed two unused variables in __kvm_vgic_flush_hwstate(), overlooked
  leftover from v1.

v1 => v2:
- Rebased to kvmarm/next of 23.10.2015.
- Do not use vgic_retire_lr() for initializing ELRSR bitmask, because now
  it also handles pushback of PENDING state, use direct initialization
  instead (copied from Andre's patchset).
- Took more care about vgic_retire_lr(), which has deserved own patch.

Pavel Fedin (4):
  KVM: arm/arm64: Remove vgic_irq_lr_map
  KVM: arm/arm64: Replace lr_used with elrsr
  KVM: arm/arm64: Clean up vgic_retire_lr() and surroundings
  KVM: arm/arm64: Merge vgic_set_lr() and vgic_sync_lr_elrsr()

 include/kvm/arm_vgic.h |   7 ----
 virt/kvm/arm/vgic-v2.c |   6 +--
 virt/kvm/arm/vgic-v3.c |   6 +--
 virt/kvm/arm/vgic.c    | 104 +++++++++++++------------------------------------
 4 files changed, 29 insertions(+), 94 deletions(-)

-- 
2.4.4
