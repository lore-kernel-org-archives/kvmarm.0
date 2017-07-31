From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 41/59] KVM: arm/arm64: GICv4: Wire mapping/unmapping of
 VLPIs in VFIO irq bypass
Date: Mon, 31 Jul 2017 18:26:19 +0100
Message-ID: <20170731172637.29355-42-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 625CE49C34
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:27:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LumihKfIhBRG for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:27:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF26749C67
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:27:02 -0400 (EDT)
In-Reply-To: <20170731172637.29355-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

Let's use the irq bypass mechanism introduced for platform device
interrupts to intercept the virtual PCIe endpoint configuration
and establish our LPI->VLPI mapping.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h      |   8 ++++
 virt/kvm/arm/arm.c          |  27 ++++++++----
 virt/kvm/arm/vgic/vgic-v4.c | 103 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 130 insertions(+), 8 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 359eeffe9857..050f78d4fb42 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -367,4 +367,12 @@ int kvm_vgic_set_forwarding(struct kvm *kvm, unsigned int host_irq,
 void kvm_vgic_unset_forwarding(struct kvm *kvm, unsigned int host_irq,
 			       unsigned int vintid);
 
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
index ebab6c29e3be..6803ea27c47d 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1457,11 +1457,16 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
 
-	if (prod->type != IRQ_BYPASS_VFIO_PLATFORM)
+	switch (prod->type) {
+	case IRQ_BYPASS_VFIO_PLATFORM:
+		return kvm_vgic_set_forwarding(irqfd->kvm, prod->irq,
+					       irqfd->gsi + VGIC_NR_PRIVATE_IRQS);
+	case IRQ_BYPASS_VFIO_PCI_MSI:
+		return kvm_vgic_v4_set_forwarding(irqfd->kvm, prod->irq,
+						  &irqfd->irq_entry);
+	default:
 		return 0;
-
-	return kvm_vgic_set_forwarding(irqfd->kvm, prod->irq,
-				       irqfd->gsi + VGIC_NR_PRIVATE_IRQS);
+	}
 }
 void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 				      struct irq_bypass_producer *prod)
@@ -1469,11 +1474,17 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	struct kvm_kernel_irqfd *irqfd =
 		container_of(cons, struct kvm_kernel_irqfd, consumer);
 
-	if (prod->type != IRQ_BYPASS_VFIO_PLATFORM)
-		return;
+	switch (prod->type) {
+	case IRQ_BYPASS_VFIO_PLATFORM:
+		kvm_vgic_unset_forwarding(irqfd->kvm, prod->irq,
+					  irqfd->gsi + VGIC_NR_PRIVATE_IRQS);
+		break;
 
-	kvm_vgic_unset_forwarding(irqfd->kvm, prod->irq,
-				  irqfd->gsi + VGIC_NR_PRIVATE_IRQS);
+	case IRQ_BYPASS_VFIO_PCI_MSI:
+		kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq,
+					     &irqfd->irq_entry);
+		break;
+	}
 }
 
 void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *cons)
diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 207e1fda0dcd..338c86c5159f 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -72,3 +72,106 @@ void vgic_v4_teardown(struct kvm *kvm)
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
+	if (!vgic_is_v4_capable(kvm))
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
+		.vintid		= irq->intid,
+		.db_enabled	= true,
+		.vpe_idx	= irq->target_vcpu->vcpu_id,
+	};
+
+	if (its_map_vlpi(virq, &map))
+		goto out;
+
+	irq->hw		= true;
+	irq->host_irq	= virq;
+
+out:
+	mutex_unlock(&its->its_lock);
+	return 0;
+}
+
+int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
+				 struct kvm_kernel_irq_routing_entry *irq_entry)
+{
+	struct vgic_its *its;
+	struct vgic_irq *irq;
+	int ret;
+
+	if (!vgic_is_v4_capable(kvm))
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
