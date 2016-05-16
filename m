From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 52/56] KVM: arm/arm64: vgic-new: vgic_init: implement map_resources
Date: Mon, 16 May 2016 10:54:37 +0100
Message-ID: <1463392481-26583-110-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

map_resources is the last initialization step. It is executed on
first VCPU run. At that stage the code checks that userspace has provided
the base addresses for the relevant VGIC regions, which depend on the
type of VGIC that is exposed to the guest.  Also we check if the two
regions overlap.
If the checks succeeded, we register the respective register frames with
the kvm_io_bus framework.

If we emulate a GICv2, the function also forces vgic_init execution if
it has not been executed yet. Also we map the virtual GIC CPU interface
onto the guest's CPU interface.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Changelog v3 .. v4:
- add overlap check (moved from kvm_vgic_addr())
- reword commit message
- improve comment

 include/kvm/vgic/vgic.h       |  1 +
 virt/kvm/arm/vgic/vgic-init.c | 28 +++++++++++++++++
 virt/kvm/arm/vgic/vgic-v2.c   | 69 +++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c   | 71 +++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h      |  7 +++++
 5 files changed, 176 insertions(+)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index e7ae36b..17b2a73 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -201,6 +201,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type);
 void kvm_vgic_destroy(struct kvm *kvm);
 void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu);
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu);
+int kvm_vgic_map_resources(struct kvm *kvm);
 int kvm_vgic_hyp_init(void);
 
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index bed3240..a1442f7 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -323,6 +323,34 @@ int vgic_lazy_init(struct kvm *kvm)
 	return ret;
 }
 
+/* RESOURCE MAPPING */
+
+/**
+ * Map the MMIO regions depending on the VGIC model exposed to the guest
+ * called on the first VCPU run.
+ * Also map the virtual CPU interface into the VM.
+ * v2/v3 derivatives call vgic_init if not already done.
+ * vgic_ready() returns true if this function has succeeded.
+ * @kvm: kvm struct pointer
+ */
+int kvm_vgic_map_resources(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	int ret = 0;
+
+	mutex_lock(&kvm->lock);
+	if (!irqchip_in_kernel(kvm))
+		goto out;
+
+	if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V2)
+		ret = vgic_v2_map_resources(kvm);
+	else
+		ret = vgic_v3_map_resources(kvm);
+out:
+	mutex_unlock(&kvm->lock);
+	return ret;
+}
+
 /* GENERIC PROBE */
 
 static void vgic_init_maintenance_interrupt(void *info)
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index fcbfa38..1fe031b 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -211,6 +211,75 @@ void vgic_v2_enable(struct kvm_vcpu *vcpu)
 {
 }
 
+/* check for overlapping regions and for regions crossing the end of memory */
+static bool vgic_v2_check_base(gpa_t dist_base, gpa_t cpu_base)
+{
+	if (dist_base + KVM_VGIC_V2_DIST_SIZE < dist_base)
+		return false;
+	if (cpu_base + KVM_VGIC_V2_CPU_SIZE < cpu_base)
+		return false;
+
+	if (dist_base + KVM_VGIC_V2_DIST_SIZE <= cpu_base)
+		return true;
+	if (cpu_base + KVM_VGIC_V2_CPU_SIZE <= dist_base)
+		return true;
+
+	return false;
+}
+
+int vgic_v2_map_resources(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	int ret = 0;
+
+	if (vgic_ready(kvm))
+		goto out;
+
+	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base) ||
+	    IS_VGIC_ADDR_UNDEF(dist->vgic_cpu_base)) {
+		kvm_err("Need to set vgic cpu and dist addresses first\n");
+		ret = -ENXIO;
+		goto out;
+	}
+
+	if (!vgic_v2_check_base(dist->vgic_dist_base, dist->vgic_cpu_base)) {
+		kvm_err("VGIC CPU and dist frames overlap\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Initialize the vgic if this hasn't already been done on demand by
+	 * accessing the vgic state from userspace.
+	 */
+	ret = vgic_init(kvm);
+	if (ret) {
+		kvm_err("Unable to initialize VGIC dynamic data structures\n");
+		goto out;
+	}
+
+	ret = vgic_register_dist_iodev(kvm, dist->vgic_dist_base, VGIC_V2);
+	if (ret) {
+		kvm_err("Unable to register VGIC MMIO regions\n");
+		goto out;
+	}
+
+	ret = kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
+				    kvm_vgic_global_state.vcpu_base,
+				    KVM_VGIC_V2_CPU_SIZE, true);
+	if (ret) {
+		kvm_err("Unable to remap VGIC CPU to VCPU\n");
+		goto out;
+	}
+
+	dist->ready = true;
+
+out:
+	if (ret)
+		kvm_vgic_destroy(kvm);
+	return ret;
+}
+
 /**
  * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
  * @node:	pointer to the DT node
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index d1c0285..637ff2b 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -191,6 +191,77 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 {
 }
 
+/* check for overlapping regions and for regions crossing the end of memory */
+static bool vgic_v3_check_base(struct kvm *kvm)
+{
+	struct vgic_dist *d = &kvm->arch.vgic;
+	gpa_t redist_size = KVM_VGIC_V3_REDIST_SIZE;
+
+	redist_size *= atomic_read(&kvm->online_vcpus);
+
+	if (d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE < d->vgic_dist_base)
+		return false;
+	if (d->vgic_redist_base + redist_size < d->vgic_redist_base)
+		return false;
+
+	if (d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE <= d->vgic_redist_base)
+		return true;
+	if (d->vgic_redist_base + redist_size <= d->vgic_dist_base)
+		return true;
+
+	return false;
+}
+
+int vgic_v3_map_resources(struct kvm *kvm)
+{
+	int ret = 0;
+	struct vgic_dist *dist = &kvm->arch.vgic;
+
+	if (vgic_ready(kvm))
+		goto out;
+
+	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base) ||
+	    IS_VGIC_ADDR_UNDEF(dist->vgic_redist_base)) {
+		kvm_err("Need to set vgic distributor addresses first\n");
+		ret = -ENXIO;
+		goto out;
+	}
+
+	if (!vgic_v3_check_base(kvm)) {
+		kvm_err("VGIC redist and dist frames overlap\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * For a VGICv3 we require the userland to explicitly initialize
+	 * the VGIC before we need to use it.
+	 */
+	if (!vgic_initialized(kvm)) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	ret = vgic_register_dist_iodev(kvm, dist->vgic_dist_base, VGIC_V3);
+	if (ret) {
+		kvm_err("Unable to register VGICv3 dist MMIO regions\n");
+		goto out;
+	}
+
+	ret = vgic_register_redist_iodevs(kvm, dist->vgic_redist_base);
+	if (ret) {
+		kvm_err("Unable to register VGICv3 redist MMIO regions\n");
+		goto out;
+	}
+
+	dist->ready = true;
+
+out:
+	if (ret)
+		kvm_vgic_destroy(kvm);
+	return ret;
+}
+
 /**
  * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
  * @node:	pointer to the DT node
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 5951551..7b300ca 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -55,6 +55,7 @@ void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_enable(struct kvm_vcpu *vcpu);
 int vgic_v2_probe(const struct gic_kvm_info *info);
+int vgic_v2_map_resources(struct kvm *kvm);
 int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 			     enum vgic_type);
 
@@ -68,6 +69,7 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_enable(struct kvm_vcpu *vcpu);
 int vgic_v3_probe(const struct gic_kvm_info *info);
+int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
@@ -110,6 +112,11 @@ static inline int vgic_v3_probe(const struct gic_kvm_info *info)
 	return -ENODEV;
 }
 
+static inline int vgic_v3_map_resources(struct kvm *kvm)
+{
+	return -ENODEV;
+}
+
 static inline int vgic_register_redist_iodevs(struct kvm *kvm,
 					      gpa_t dist_base_address)
 {
-- 
2.8.2

