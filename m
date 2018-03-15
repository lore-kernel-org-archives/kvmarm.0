From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 1/6] KVM: arm/arm64: vgic: Add missing irq_lock to
 vgic_mmio_read_pending
Date: Thu, 15 Mar 2018 17:16:43 +0000
Message-ID: <20180315171648.19501-2-marc.zyngier@arm.com>
References: <20180315171648.19501-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C73AE49FB4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 13:09:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jv6dvWJNsieO for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Mar 2018 13:09:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E8E949F81
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Mar 2018 13:09:32 -0400 (EDT)
In-Reply-To: <20180315171648.19501-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

Our irq_is_pending() helper function accesses multiple members of the
vgic_irq struct, so we need to hold the lock when calling it.
Add that requirement as a comment to the definition and take the lock
around the call in vgic_mmio_read_pending(), where we were missing it
before.

Fixes: 96b298000db4 ("KVM: arm/arm64: vgic-new: Add PENDING registers handlers")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 3 +++
 virt/kvm/arm/vgic/vgic.h      | 1 +
 2 files changed, 4 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 83d82bd7dc4e..dbe99d635c80 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -113,9 +113,12 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 	/* Loop over all IRQs affected by this read */
 	for (i = 0; i < len * 8; i++) {
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		unsigned long flags;
 
+		spin_lock_irqsave(&irq->irq_lock, flags);
 		if (irq_is_pending(irq))
 			value |= (1U << i);
+		spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 		vgic_put_irq(vcpu->kvm, irq);
 	}
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 12c37b89f7a3..5b11859a1a1e 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -96,6 +96,7 @@
 /* we only support 64 kB translation table page size */
 #define KVM_ITS_L1E_ADDR_MASK		GENMASK_ULL(51, 16)
 
+/* Requires the irq_lock to be held by the caller. */
 static inline bool irq_is_pending(struct vgic_irq *irq)
 {
 	if (irq->config == VGIC_CONFIG_EDGE)
-- 
2.14.2
