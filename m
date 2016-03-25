From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 40/45] KVM: arm/arm64: vgic-new: vgic_init: implement
 vgic_init
Date: Fri, 25 Mar 2016 02:05:03 +0000
Message-ID: <1458871508-17279-41-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78E3D49B45
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AUZSPbMlCV+9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2016 22:05:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 080E849B70
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:25 -0400 (EDT)
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

This patch allocates and initializes the data structures used
to model the vgic distributor and virtual cpu interfaces. At that
stage the number of IRQs and number of virtual CPUs is frozen.

The following realy_init functions are kept since they are called from
arm.c. However they may disappear in subsequent patches since
they are void.

vgic_[v2|v3]_enable still is stubbed at this stage.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/vgic/vgic.h       |   7 +-
 virt/kvm/arm/vgic/vgic-v2.c   |   5 +
 virt/kvm/arm/vgic/vgic-v3.c   |   5 +
 virt/kvm/arm/vgic/vgic.c      |   5 +
 virt/kvm/arm/vgic/vgic.h      |   8 ++
 virt/kvm/arm/vgic/vgic_init.c | 214 ++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 243 insertions(+), 1 deletion(-)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 536582b..4a51582 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -115,6 +115,7 @@ struct vgic_io_device {
 struct vgic_dist {
 	bool			in_kernel;
 	bool			ready;
+	bool			initialized;
 
 	/* vGIC model the kernel emulates for the guest (GICv2 or GICv3) */
 	u32			vgic_model;
@@ -195,7 +196,11 @@ struct vgic_cpu {
 };
 
 int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
+void kvm_vgic_early_init(struct kvm *kvm);
 int kvm_vgic_create(struct kvm *kvm, u32 type);
+void kvm_vgic_destroy(struct kvm *kvm);
+void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu);
+void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vgic_hyp_init(void);
 
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
@@ -204,7 +209,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
-#define vgic_initialized(k)	(false)
+#define vgic_initialized(k)	((k)->arch.vgic.initialized)
 #define vgic_ready(k)		((k)->arch.vgic.ready)
 #define vgic_valid_spi(k,i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
 			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 0cb5c4f..c48dbd4 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -234,6 +234,11 @@ void vgic_v2_irq_change_affinity(struct kvm *kvm, u32 intid, u8 new_targets)
 	spin_unlock(&irq->irq_lock);
 }
 
+/* not yet implemented */
+void vgic_v2_enable(struct kvm_vcpu *vcpu)
+{
+}
+
 /**
  * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
  * @node:	pointer to the DT node
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 1a53141..3155680 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -220,6 +220,11 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
 }
 
+/* not yet implemented */
+void vgic_v3_enable(struct kvm_vcpu *vcpu)
+{
+}
+
 /**
  * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
  * @node:	pointer to the DT node
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 8c19379..4ade7c0 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -268,6 +268,11 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 			bool level)
 {
 	struct kvm_vcpu *vcpu;
+	int ret;
+
+	ret = vgic_lazy_init(kvm);
+	if (ret)
+		return ret;
 
 	vcpu = kvm_get_vcpu(kvm, cpuid);
 	vgic_update_irq_pending(kvm, vcpu, intid, level);
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 31c9299a..4b2e1b0 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -38,6 +38,7 @@ int vgic_v2_dist_access(struct kvm_vcpu *vcpu, bool is_write,
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v2_enable(struct kvm_vcpu *vcpu);
 int vgic_v2_probe(struct device_node *vgic_node);
 
 #ifdef CONFIG_KVM_ARM_VGIC_V3
@@ -52,6 +53,7 @@ int vgic_v3_redist_access(struct kvm_vcpu *vcpu, bool is_write,
 			  int offset, int len, void *val);
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v3_enable(struct kvm_vcpu *vcpu);
 int vgic_v3_probe(struct device_node *vgic_node);
 #else
 static inline void vgic_v3_irq_change_affinity(struct kvm *kvm, u32 intid,
@@ -98,6 +100,10 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
 }
 
+static inline void vgic_v3_enable(struct kvm_vcpu *vcpu)
+{
+}
+
 static inline int vgic_v3_probe(struct device_node *vgic_node)
 {
 	return -ENODEV;
@@ -107,6 +113,8 @@ static inline int vgic_v3_probe(struct device_node *vgic_node)
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 
+int vgic_lazy_init(struct kvm *kvm);
+int vgic_init(struct kvm *kvm);
 void kvm_register_vgic_device(unsigned long type);
 
 #endif
diff --git a/virt/kvm/arm/vgic/vgic_init.c b/virt/kvm/arm/vgic/vgic_init.c
index 80bf283..f7a6a11 100644
--- a/virt/kvm/arm/vgic/vgic_init.c
+++ b/virt/kvm/arm/vgic/vgic_init.c
@@ -24,6 +24,42 @@
 #include <asm/kvm_mmu.h>
 #include "vgic.h"
 
+/*
+ * Initialization rules: there are multiple stages to the vgic
+ * initialization, both for the distributor and the CPU interfaces.
+ *
+ * Distributor:
+ *
+ * - kvm_vgic_early_init(): initialization of static data that doesn't
+ *   depend on any sizing information or emulation type. No allocation
+ *   is allowed there.
+ *
+ * - vgic_init(): allocation and initialization of the generic data
+ *   structures that depend on sizing information (number of CPUs,
+ *   number of interrupts). Also initializes the vcpu specific data
+ *   structures. Can be executed lazily for GICv2.
+ *
+ * CPU Interface:
+ *
+ * - kvm_vgic_cpu_early_init(): initialization of static data that
+ *   doesn't depend on any sizing information or emulation type. No
+ *   allocation is allowed there.
+ */
+
+/* EARLY INIT */
+
+/*
+ * Those 2 functions should not be needed anymore but they
+ * still are called from arm.c
+ */
+void kvm_vgic_early_init(struct kvm *kvm)
+{
+}
+
+void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu)
+{
+}
+
 /* CREATION */
 
 /**
@@ -108,6 +144,184 @@ out:
 	return ret;
 }
 
+/* INIT/DESTROY */
+
+/**
+ * kvm_vgic_dist_init: initialize the dist data structures
+ * @kvm: kvm struct pointer
+ * @nr_spis: number of spis, frozen by caller
+ */
+int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	int i;
+
+	dist->spis = kcalloc(nr_spis, sizeof(struct vgic_irq), GFP_KERNEL);
+	if (!dist->spis)
+		return  -ENOMEM;
+
+	/*
+	 * In following code we do not take the irq struct lock since
+	 * no other action on irq structs can happen while the VGIC is
+	 * not initialized yet:
+	 * injection requires (VGICV3) or does (VGIC2) initialization.
+	 * MMIO access triggers init.
+	 */
+	for (i = 0; i < nr_spis; i++) {
+		struct vgic_irq *irq = &dist->spis[i];
+
+		irq->intid = i + VGIC_NR_PRIVATE_IRQS;
+		INIT_LIST_HEAD(&irq->ap_list);
+		spin_lock_init(&irq->irq_lock);
+		irq->vcpu = NULL;
+		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
+			vgic_v2_irq_change_affinity(kvm, irq->intid, 0);
+		else
+			vgic_v3_irq_change_affinity(kvm, irq->intid, 0);
+	}
+	return 0;
+}
+
+/**
+ * kvm_vgic_vcpu_init: initialize the vcpu data structures and
+ * enable the VCPU interface
+ * @kvm: kvm struct pointer
+ */
+void kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	int i;
+
+	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
+	spin_lock_init(&vgic_cpu->ap_list_lock);
+	vgic_cpu->nr_lr = kvm_vgic_global_state.nr_lr;
+
+	/*
+	 * Enable and configure all SGIs to be edge-triggered and
+	 * configure all PPIs as level-triggered.
+	 */
+	for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
+		struct vgic_irq *irq = &vgic_cpu->private_irqs[i];
+
+		INIT_LIST_HEAD(&irq->ap_list);
+		spin_lock_init(&irq->irq_lock);
+		irq->intid = i;
+		irq->vcpu = NULL;
+		irq->target_vcpu = vcpu;
+		irq->targets = 1U << vcpu->vcpu_id;
+		if (i < VGIC_NR_SGIS) {
+			/* SGIs */
+			irq->enabled = 1;
+			irq->config = VGIC_CONFIG_EDGE;
+		} else {
+			/* PPIs */
+			irq->config = VGIC_CONFIG_LEVEL;
+		}
+	}
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_enable(vcpu);
+	else
+		vgic_v3_enable(vcpu);
+}
+
+/*
+ * vgic_init: allocates and initializes dist and vcpu data structures
+ * depending on two dimensioning parameters:
+ * - the number of spis
+ * - the number of vcpus
+ * The function is generally called when nr_spis has been explicitly set
+ * by the guest through the KVM DEVICE API. If not nr_spis is set to 256.
+ * Completion can be tested by vgic_initialized
+ * Must be called with kvm->lock held!
+ */
+int vgic_init(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct kvm_vcpu *vcpu;
+	int ret = 0, i;
+
+	if (vgic_initialized(kvm))
+		return 0;
+
+	/* freeze the number of spis */
+	if (!dist->nr_spis)
+		dist->nr_spis = VGIC_NR_IRQS_LEGACY - VGIC_NR_PRIVATE_IRQS;
+
+	ret = kvm_vgic_dist_init(kvm, dist->nr_spis);
+	if (ret)
+		goto out;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_vgic_vcpu_init(vcpu);
+
+	dist->initialized = true;
+out:
+	return ret;
+}
+
+static void kvm_vgic_dist_destroy(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+
+	mutex_lock(&kvm->lock);
+
+	dist->ready = false;
+	dist->initialized = false;
+
+	kfree(dist->spis);
+	kfree(dist->dist_iodevs);
+	kfree(dist->redist_iodevs);
+	dist->nr_spis = 0;
+
+	mutex_unlock(&kvm->lock);
+}
+
+void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
+	vgic_cpu->nr_lr = 0;
+}
+
+void kvm_vgic_destroy(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	kvm_vgic_dist_destroy(kvm);
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_vgic_vcpu_destroy(vcpu);
+}
+
+/**
+ * Lazy init only is allowed if the GIC exposed to the guest is a GICV2.
+ * GICV3 must be explicitly initialized by the guest using the
+ * KVM_DEV_ARM_VGIC_GRP_CTRL KVM_DEVICE group
+ */
+int vgic_lazy_init(struct kvm *kvm)
+{
+	int ret = 0;
+
+	if (unlikely(!vgic_initialized(kvm))) {
+		/*
+		 * We only provide the automatic initialization of the VGIC
+		 * for the legacy case of a GICv2. Any other type must
+		 * be explicitly initialized once setup with the respective
+		 * KVM device call.
+		 */
+		if (kvm->arch.vgic.vgic_model != KVM_DEV_TYPE_ARM_VGIC_V2)
+			return -EBUSY;
+
+		mutex_lock(&kvm->lock);
+		ret = vgic_init(kvm);
+		mutex_unlock(&kvm->lock);
+	}
+
+	return ret;
+}
+
 /* GENERIC PROBE */
 
 static void vgic_init_maintenance_interrupt(void *info)
-- 
2.7.3
