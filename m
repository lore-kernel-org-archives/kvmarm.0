From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 24/56] KVM: arm/arm64: vgic-new: Add CTLR,
 TYPER and IIDR handlers
Date: Mon, 16 May 2016 10:54:09 +0100
Message-ID: <1463392481-26583-82-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7727C49C48
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:53:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lFR4qBLwVj0P for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2016 05:53:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05F2449C28
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:53:08 -0400 (EDT)
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

From: Marc Zyngier <marc.zyngier@arm.com>

Those three registers are v2 emulation specific, so their implementation
lives entirely in vgic-mmio-v2.c. Also they are handled in one function,
as their implementation is pretty simple.
When the guest enables the distributor, we kick all VCPUs to get
potentially pending interrupts serviced.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog RFC..v1:
- kick VCPUs is the distributor gets enabled
- improve comment

Changelog v1 .. v2:
- adapt to new MMIO framework
- use switch() statements to improve readability

Changelog v2 .. v3:
- add vgic_kick_vcpus() implementation

Changelog v3 .. v4;
- specify accessor width
- simplify CTLR write access
- replace extract_bytes() with simple return

 include/linux/irqchip/arm-gic.h  |  1 +
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 46 +++++++++++++++++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic.c         | 15 +++++++++++++
 virt/kvm/arm/vgic/vgic.h         |  4 ++++
 4 files changed, 65 insertions(+), 1 deletion(-)

diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index be0d26f..fd05185 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -33,6 +33,7 @@
 
 #define GIC_DIST_CTRL			0x000
 #define GIC_DIST_CTR			0x004
+#define GIC_DIST_IIDR			0x008
 #define GIC_DIST_IGROUP			0x080
 #define GIC_DIST_ENABLE_SET		0x100
 #define GIC_DIST_ENABLE_CLEAR		0x180
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index a3e31a9..d812c93 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -20,9 +20,53 @@
 #include "vgic.h"
 #include "vgic-mmio.h"
 
+static unsigned long vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
+					    gpa_t addr, unsigned int len)
+{
+	u32 value;
+
+	switch (addr & 0x0c) {
+	case GIC_DIST_CTRL:
+		value = vcpu->kvm->arch.vgic.enabled ? GICD_ENABLE : 0;
+		break;
+	case GIC_DIST_CTR:
+		value = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
+		value = (value >> 5) - 1;
+		value |= (atomic_read(&vcpu->kvm->online_vcpus) - 1) << 5;
+		break;
+	case GIC_DIST_IIDR:
+		value = (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
+		break;
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_mmio_write_v2_misc(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len,
+				    unsigned long val)
+{
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	bool was_enabled = dist->enabled;
+
+	switch (addr & 0x0c) {
+	case GIC_DIST_CTRL:
+		dist->enabled = val & GICD_ENABLE;
+		if (!was_enabled && dist->enabled)
+			vgic_kick_vcpus(vcpu->kvm);
+		break;
+	case GIC_DIST_CTR:
+	case GIC_DIST_IIDR:
+		/* Nothing to do */
+		return;
+	}
+}
+
 static const struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 12,
+		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
 		vgic_mmio_read_rao, vgic_mmio_write_wi, 1,
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index bea8d3b..2a41028 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -544,3 +544,18 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 
 	return pending;
 }
+
+void vgic_kick_vcpus(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	int c;
+
+	/*
+	 * We've injected an interrupt, time to find out who deserves
+	 * a good kick...
+	 */
+	kvm_for_each_vcpu(c, vcpu, kvm) {
+		if (kvm_vgic_vcpu_pending_irq(vcpu))
+			kvm_vcpu_kick(vcpu);
+	}
+}
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index fd9acaa..cf62015 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -16,11 +16,15 @@
 #ifndef __KVM_ARM_VGIC_NEW_H__
 #define __KVM_ARM_VGIC_NEW_H__
 
+#define PRODUCT_ID_KVM		0x4b	/* ASCII code K */
+#define IMPLEMENTER_ARM		0x43b
+
 #define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
 
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
 			      u32 intid);
 bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq);
+void vgic_kick_vcpus(struct kvm *kvm);
 
 void vgic_v2_process_maintenance(struct kvm_vcpu *vcpu);
 void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
-- 
2.8.2
