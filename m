From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 50/55] KVM: arm/arm64: vgic-new: vgic_init: implement vgic_init
Date: Fri,  6 May 2016 11:46:03 +0100
Message-ID: <1462531568-9799-51-git-send-email-andre.przywara@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

This patch allocates and initializes the data structures used
to model the vgic distributor and virtual cpu interfaces. At that
stage the number of IRQs and number of virtual CPUs is frozen.

The following early_init functions are kept since they are called from
arm.c. However they may disappear in subsequent patches since
they are void.

vgic_[v2|v3]_enable still is stubbed at this stage.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog RFC..v1:
- initialize v2/v3 default CPU affinities explicitly

Changelog v1 .. v2:
- move lazy_init() into vgic_update_irq_pending()

 include/kvm/vgic/vgic.h       |   7 +-
 virt/kvm/arm/vgic/vgic-init.c | 213 ++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v2.c   |   5 +
 virt/kvm/arm/vgic/vgic-v3.c   |   5 +
 virt/kvm/arm/vgic/vgic.c      |   4 +
 virt/kvm/arm/vgic/vgic.h      |   8 ++
 6 files changed, 241 insertions(+), 1 deletion(-)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 899b7b7..538078a 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -119,6 +119,7 @@ struct vgic_io_device {
 struct vgic_dist {
 	bool			in_kernel;
 	bool			ready;
+	bool			initialized;
 
 	/* vGIC model the kernel emulates for the guest (GICv2 or GICv3) */
 	u32			vgic_model;
@@ -202,7 +203,11 @@ struct vgic_cpu {
 };
 
 int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
+void kvm_vgic_early_init(struct kvm *kvm);
 int kvm_vgic_create(struct kvm *kvm, u32 type);
+void kvm_vgic_destroy(struct kvm *kvm);
+void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu);
+void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vgic_hyp_init(void);
 
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
@@ -211,7 +216,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
 
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
-#define vgic_initialized(k)	(false)
+#define vgic_initialized(k)	((k)->arch.vgic.initialized)
 #define vgic_ready(k)		((k)->arch.vgic.ready)
 #define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
 			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index a150363..3f9c137 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
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
@@ -108,6 +144,183 @@ out:
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
+	struct kvm_vcpu *vcpu0 = kvm_get_vcpu(kvm, 0);
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
+		irq->target_vcpu = vcpu0;
+		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
+			irq->targets = 0;
+		else
+			irq->mpidr = 0;
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
+		if (vgic_irq_is_sgi(i)) {
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
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 91b69a4..48aa877 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -211,6 +211,11 @@ void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 			GICH_VMCR_PRIMASK_SHIFT;
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
index 48b0bb7..7cab5b9 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -195,6 +195,11 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
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
index 5355de6..068389a 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -255,6 +255,10 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 
 	trace_vgic_update_irq_pending(cpuid, intid, level);
 
+	ret = vgic_lazy_init(kvm);
+	if (ret)
+		return ret;
+
 	vcpu = kvm_get_vcpu(kvm, cpuid);
 	if (!vcpu && intid < VGIC_NR_PRIVATE_IRQS)
 		return -EINVAL;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index e49b1df..cad04eb 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -43,6 +43,7 @@ int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			  int offset, u32 *val);
 void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v2_enable(struct kvm_vcpu *vcpu);
 int vgic_v2_probe(struct device_node *vgic_node);
 int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 			     enum vgic_type);
@@ -55,6 +56,7 @@ void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v3_enable(struct kvm_vcpu *vcpu);
 int vgic_v3_probe(struct device_node *vgic_node);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 #else
@@ -89,6 +91,10 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
 }
 
+static inline void vgic_v3_enable(struct kvm_vcpu *vcpu)
+{
+}
+
 static inline int vgic_v3_probe(struct device_node *vgic_node)
 {
 	return -ENODEV;
@@ -102,5 +108,7 @@ static inline int vgic_register_redist_iodevs(struct kvm *kvm,
 #endif
 
 void kvm_register_vgic_device(unsigned long type);
+int vgic_lazy_init(struct kvm *kvm);
+int vgic_init(struct kvm *kvm);
 
 #endif
-- 
2.7.3

