From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/5] KVM: arm/arm64: vgic-v2: Do not use Active+Pending state
 for a HW interrupt
Date: Tue,  2 May 2017 14:30:39 +0100
Message-ID: <20170502133041.10980-4-marc.zyngier@arm.com>
References: <20170502133041.10980-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0540440A66
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 May 2017 09:27:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4slDQ4U3IEXS for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 May 2017 09:27:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 058CB40C32
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 May 2017 09:27:54 -0400 (EDT)
In-Reply-To: <20170502133041.10980-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When an interrupt is injected with the HW bit set (indicating that
deactivation should be propagated to the physical distributor),
special care must be taken so that we never mark the corresponding
LR with the Active+Pending state (as the pending state is kept in
the physycal distributor).

Cc: stable@vger.kernel.org
Fixes: 140b086dd197 ("KVM: arm/arm64: vgic-new: Add GICv2 world switch backend")
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index a65757aab6d3..504b4bd0d651 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -149,6 +149,13 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 	if (irq->hw) {
 		val |= GICH_LR_HW;
 		val |= irq->hwintid << GICH_LR_PHYSID_CPUID_SHIFT;
+		/*
+		 * Never set pending+active on a HW interrupt, as the
+		 * pending state is kept at the physical distributor
+		 * level.
+		 */
+		if (irq->active && irq_is_pending(irq))
+			val &= ~GICH_LR_PENDING_BIT;
 	} else {
 		if (irq->config == VGIC_CONFIG_LEVEL)
 			val |= GICH_LR_EOI;
-- 
2.11.0
