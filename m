From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 0/4] KVM: arm/arm64: Fix locking issues
Date: Fri, 11 May 2018 15:20:11 +0100
Message-ID: <20180511142015.21953-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9B9E49F94
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 May 2018 10:10:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tcbKC4iXmqO5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 May 2018 10:10:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C2BE40192
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 May 2018 10:10:30 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Jan recently reported lockdep complaints regarding various locks in our
VGIC emulation [1][2].
This boiled down to two separate issues:
- When promoting the vgic_irq->irq_lock to require IRQs being disabled,
  we forgot to amend some instances of this lock on the way. Also this
  needs to be applied to dependent locks as well. The first two patches
  fix that. The patch split is designed to simplify backporting.
  Those patches have been posted before, I am resending them as part
  of this series.
- Calling kvm_read_guest() requires us to be inside an SRCU critical
  section. On some architectures we are always in it when handling VCPU
  exits, but on ARM we need to lock it individually. Patches 3 and 4
  fix that, the split is again made to ease backporting.
  Each of the hunks fix an indiviual commit, but I refrained from
  splitting this down into eight patches just to put proper Fixes: tags
  on it. Eventually those commits are part of one out of two series, I put
  the respective kernel release version as a tag to the Cc: stable line.

I couldn't reproduce the full lockdep splat on my setup, but at least
could show one instance and prove that these patches fixes that.

Thanks to Jan for reporting.

Cheers,
Andre.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-May/575718.html
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-May/575833.html

Andre Przywara (4):
  KVM: ARM: Properly protect VGIC locks from IRQs
  KVM: ARM: VGIC/ITS: Promote irq_lock() in update_affinity
  KVM: arm/arm64: VGIC/ITS: protect kvm_read_guest() calls with SRCU lock
  KVM: arm/arm64: VGIC/ITS save/restore: protect kvm_read_guest() calls

 arch/arm/include/asm/kvm_mmu.h   | 16 ++++++++++++++++
 arch/arm64/include/asm/kvm_mmu.h | 16 ++++++++++++++++
 virt/kvm/arm/vgic/vgic-debug.c   |  5 +++--
 virt/kvm/arm/vgic/vgic-its.c     | 34 +++++++++++++++++++---------------
 virt/kvm/arm/vgic/vgic-v3.c      |  4 ++--
 virt/kvm/arm/vgic/vgic.c         | 22 ++++++++++++++--------
 6 files changed, 70 insertions(+), 27 deletions(-)

-- 
2.14.1
