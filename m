From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 10/26] KVM: arm/arm64: GICv4: Wire mapping/unmapping of
 VLPIs in VFIO irq bypass
Date: Fri, 27 Oct 2017 15:28:39 +0100
Message-ID: <20171027142855.21584-11-marc.zyngier@arm.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E816949D15
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 10:28:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O7eGV4O0GizN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 10:28:11 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A19A049D46
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 10:28:11 -0400 (EDT)
In-Reply-To: <20171027142855.21584-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Let's use the irq bypass mechanism introduced for platform device
interrupts to intercept the virtual PCIe endpoint configuration
and establish our LPI->VLPI mapping.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h      |   8 ++++
 virt/kvm/arm/arm.c          |   6 ++-
 virt/kvm/arm/vgic/vgic-v4.c | 108 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 120 insertions(+), 2 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7eeb6c2a2f9c..2f750c770bf2 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -373,4 +373,12 @@ int kvm_vgic_setup_default_irq_routing(struct kvm *kvm);
 
 int kvm_vgic_set_owner(struct kvm_vcpu *vcpu, unsigned int intid, void *owner);
 
+struct kvm_kernel_irq_routing_entry;
+
+int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
+			       struct kvm_kernel_irq_routing_entry *irq_entry);
+
+int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
+				 struct kvm_kernel_irq_routing_entry *irq_entry);
+
 #endif /* __KVM_ARM_VGIC_H */
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 5d5218ecd547..8388c1cc23f6 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1462,7 +1462,8 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
 
-	return 0;
+	return kvm_vgic_v4_set_forwarding(irqfd->kvm, prod->irq,
+					  &irqfd->irq_entry);
 }
 void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 				      struct irq_bypass_producer *prod)
@@ -1470,7 +1471,8 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
 
-	return;
+	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq,
+				     &irqfd->irq_entry);
 }
 
 void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *cons)
diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index c794f0cef09e..01a2889b7b7c 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/irqdomain.h>
 #include <linux/kvm_host.h>
+#include <linux/irqchip/arm-gic-v3.h>
 
 #include "vgic.h"
 
@@ -81,3 +82,110 @@ void vgic_v4_teardown(struct kvm *kvm)
 	its_vm->nr_vpes = 0;
 	its_vm->vpes = NULL;
 }
+
+static struct vgic_its *vgic_get_its(struct kvm *kvm,
+				     struct kvm_kernel_irq_routing_entry *irq_entry)
+{
+	struct kvm_msi msi  = (struct kvm_msi) {
+		.address_lo	= irq_entry->msi.address_lo,
+		.address_hi	= irq_entry->msi.address_hi,
+		.data		= irq_entry->msi.data,
+		.flags		= irq_entry->msi.flags,
+		.devid		= irq_entry->msi.devid,
+	};
+
+	/*
+	 * Get a reference on the LPI. If NULL, this is not a valid
+	 * translation for any of our vITSs.
+	 */
+	return vgic_msi_to_its(kvm, &msi);
+}
+
+int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int virq,
+			       struct kvm_kernel_irq_routing_entry *irq_entry)
+{
+	struct vgic_its *its;
+	struct vgic_irq *irq;
+	struct its_vlpi_map map;
+	int ret;
+
+	if (!vgic_supports_direct_msis(kvm))
+		return 0;
+
+	/*
+	 * Get the ITS, and escape early on error (not a valid
+	 * doorbell for any of our vITSs).
+	 */
+	its = vgic_get_its(kvm, irq_entry);
+	if (IS_ERR(its))
+		return 0;
+
+	mutex_lock(&its->its_lock);
+
+	/* Perform then actual DevID/EventID -> LPI translation. */
+	ret = vgic_its_resolve_lpi(kvm, its, irq_entry->msi.devid,
+				   irq_entry->msi.data, &irq);
+	if (ret)
+		goto out;
+
+	/*
+	 * Emit the mapping request. If it fails, the ITS probably
+	 * isn't v4 compatible, so let's silently bail out. Holding
+	 * the ITS lock should ensure that nothing can modify the
+	 * target vcpu.
+	 */
+	map = (struct its_vlpi_map) {
+		.vm		= &kvm->arch.vgic.its_vm,
+		.vpe		= &irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe,
+		.vintid		= irq->intid,
+		.properties	= ((irq->priority & 0xfc) |
+				   (irq->enabled ? LPI_PROP_ENABLED : 0) |
+				   LPI_PROP_GROUP1),
+		.db_enabled	= true,
+	};
+
+	ret = its_map_vlpi(virq, &map);
+	if (ret)
+		goto out;
+
+	irq->hw		= true;
+	irq->host_irq	= virq;
+
+out:
+	mutex_unlock(&its->its_lock);
+	return ret;
+}
+
+int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
+				 struct kvm_kernel_irq_routing_entry *irq_entry)
+{
+	struct vgic_its *its;
+	struct vgic_irq *irq;
+	int ret;
+
+	if (!vgic_supports_direct_msis(kvm))
+		return 0;
+
+	/*
+	 * Get the ITS, and escape early on error (not a valid
+	 * doorbell for any of our vITSs).
+	 */
+	its = vgic_get_its(kvm, irq_entry);
+	if (IS_ERR(its))
+		return 0;
+
+	mutex_lock(&its->its_lock);
+
+	ret = vgic_its_resolve_lpi(kvm, its, irq_entry->msi.devid,
+				   irq_entry->msi.data, &irq);
+	if (ret)
+		goto out;
+
+	WARN_ON(!(irq->hw && irq->host_irq == virq));
+	irq->hw = false;
+	ret = its_unmap_vlpi(virq);
+
+out:
+	mutex_unlock(&its->its_lock);
+	return ret;
+}
-- 
2.11.0
