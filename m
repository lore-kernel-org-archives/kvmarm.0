From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 31/56] KVM: arm/arm64: vgic-new: Add SGIR register handler
Date: Mon, 16 May 2016 10:54:16 +0100
Message-ID: <1463392481-26583-89-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 90EE649C1F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:53:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u47NoCMuY3rf for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2016 05:53:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DBF549C66
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:53:18 -0400 (EDT)
In-Reply-To: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Triggering an IPI via this register is v2 specific, so the
implementation lives entirely in vgic-mmio-v2.c.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Changelog RFC..v1:
- silently return on illegal TargetListFilter value (=3)

Changelog v1 .. v2:
- adapt to new MMIO framework

Changelog v3 .. v4:
- specify accessor width

 virt/kvm/arm/vgic/vgic-mmio-v2.c | 43 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 52389ff..c884e9b 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -64,6 +64,47 @@ static void vgic_mmio_write_v2_misc(struct kvm_vcpu *vcpu,
 	}
 }
 
+static void vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
+				 gpa_t addr, unsigned int len,
+				 unsigned long val)
+{
+	int nr_vcpus = atomic_read(&source_vcpu->kvm->online_vcpus);
+	int intid = val & 0xf;
+	int targets = (val >> 16) & 0xff;
+	int mode = (val >> 24) & 0x03;
+	int c;
+	struct kvm_vcpu *vcpu;
+
+	switch (mode) {
+	case 0x0:		/* as specified by targets */
+		break;
+	case 0x1:
+		targets = (1U << nr_vcpus) - 1;			/* all, ... */
+		targets &= ~(1U << source_vcpu->vcpu_id);	/* but self */
+		break;
+	case 0x2:		/* this very vCPU only */
+		targets = (1U << source_vcpu->vcpu_id);
+		break;
+	case 0x3:		/* reserved */
+		return;
+	}
+
+	kvm_for_each_vcpu(c, vcpu, source_vcpu->kvm) {
+		struct vgic_irq *irq;
+
+		if (!(targets & (1U << c)))
+			continue;
+
+		irq = vgic_get_irq(source_vcpu->kvm, vcpu, intid);
+
+		spin_lock(&irq->irq_lock);
+		irq->pending = true;
+		irq->source |= 1U << source_vcpu->vcpu_id;
+
+		vgic_queue_irq_unlock(source_vcpu->kvm, irq);
+	}
+}
+
 static unsigned long vgic_mmio_read_target(struct kvm_vcpu *vcpu,
 					   gpa_t addr, unsigned int len)
 {
@@ -140,7 +181,7 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		vgic_mmio_read_config, vgic_mmio_write_config, 2,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
+		vgic_mmio_read_raz, vgic_mmio_write_sgir, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_CLEAR,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 16,
-- 
2.8.2
