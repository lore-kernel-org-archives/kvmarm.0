From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 52/57] KVM: arm/arm64: vgic-new: vgic_init: implement vgic_init
Date: Thu, 19 May 2016 19:08:31 +0100
Message-ID: <1463681316-23039-53-git-send-email-andre.przywara@arm.com>
References: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

This patch allocates and initializes the data structures used
to model the vgic distributor and virtual cpu interfaces. At that
stage the number of IRQs and number of virtual CPUs is frozen.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Changelog RFC..v1:
- initialize v2/v3 default CPU affinities explicitly

Changelog v1 .. v2:
- move lazy_init() into vgic_update_irq_pending()

Changelog v3 .. v4:
- fix comments
- make local functions static
- adapt to new firmware independent probing

 include/kvm/vgic/vgic.h       |   7 +-
 virt/kvm/arm/vgic/vgic-init.c | 217 ++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v2.c   |   5 +
 virt/kvm/arm/vgic/vgic-v3.c   |   5 +
 virt/kvm/arm/vgic/vgic.c      |   4 +
 virt/kvm/arm/vgic/vgic.h      |   8 ++
 6 files changed, 245 insertions(+), 1 deletion(-)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 0634d89..e7ae36b 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -119,6 +119,7 @@ struct vgic_io_device {
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
 #define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
 			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 15d5428..bed3240 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -22,6 +22,42 @@
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
@@ -29,6 +65,8 @@
  * user space, either through the legacy KVM_CREATE_IRQCHIP ioctl (v2 only)
  * or through the generic KVM_CREATE_DEVICE API ioctl.
  * irqchip_in_kernel() tells you if this function succeeded or not.
+ * @kvm: kvm struct pointer
+ * @type: KVM_DEV_TYPE_ARM_VGIC_V[23]
  */
 int kvm_vgic_create(struct kvm *kvm, u32 type)
 {
@@ -106,6 +144,185 @@ out:
 	return ret;
 }
 
+/* INIT/DESTROY */
+
+/**
+ * kvm_vgic_dist_init: initialize the dist data structures
+ * @kvm: kvm struct pointer
+ * @nr_spis: number of spis, frozen by caller
+ */
+static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
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
+	 * In the following code we do not take the irq struct lock since
+	 * no other action on irq structs can happen while the VGIC is
+	 * not initialized yet:
+	 * If someone wants to inject an interrupt or does a MMIO access, we
+	 * require prior initialization in case of a virtual GICv3 or trigger
+	 * initialization when using a virtual GICv2.
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
+ * @vcpu: the VCPU which's VGIC should be initialized
+ */
+static void kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
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
+ * vgic_initialized() returns true when this function has succeeded.
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
+ * vgic_lazy_init: Lazy init is only allowed if the GIC exposed to the guest
+ * is a GICv2. A GICv3 must be explicitly initialized by the guest using the
+ * KVM_DEV_ARM_VGIC_GRP_CTRL KVM_DEVICE group.
+ * @kvm: kvm struct pointer
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
index 09777c8..fcbfa38 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -206,6 +206,11 @@ void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
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
index de0e8e0..d1c0285 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -186,6 +186,11 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
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
index 067c56e..6b892a4 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -257,6 +257,10 @@ static int vgic_update_irq_pending(struct kvm *kvm, int cpuid,
 
 	trace_vgic_update_irq_pending(cpuid, intid, level);
 
+	ret = vgic_lazy_init(kvm);
+	if (ret)
+		return ret;
+
 	vcpu = kvm_get_vcpu(kvm, cpuid);
 	if (!vcpu && intid < VGIC_NR_PRIVATE_IRQS)
 		return -EINVAL;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index f4244b6..5951551 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -53,6 +53,7 @@ int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			  int offset, u32 *val);
 void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v2_enable(struct kvm_vcpu *vcpu);
 int vgic_v2_probe(const struct gic_kvm_info *info);
 int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 			     enum vgic_type);
@@ -65,6 +66,7 @@ void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
+void vgic_v3_enable(struct kvm_vcpu *vcpu);
 int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 #else
@@ -99,6 +101,10 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
 {
 }
 
+static inline void vgic_v3_enable(struct kvm_vcpu *vcpu)
+{
+}
+
 static inline int vgic_v3_probe(const struct gic_kvm_info *info)
 {
 	return -ENODEV;
@@ -112,5 +118,7 @@ static inline int vgic_register_redist_iodevs(struct kvm *kvm,
 #endif
 
 void kvm_register_vgic_device(unsigned long type);
+int vgic_lazy_init(struct kvm *kvm);
+int vgic_init(struct kvm *kvm);
 
 #endif
-- 
2.8.2

