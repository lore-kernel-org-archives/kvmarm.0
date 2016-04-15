From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 41/45] KVM: arm/arm64: vgic-new: vgic_init: implement
 map_resources
Date: Fri, 15 Apr 2016 18:11:52 +0100
Message-ID: <1460740316-8755-42-git-send-email-andre.przywara@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FCDB49C74
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:11:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LiKTVgES2UBg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2016 13:11:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C91449C96
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:11:03 -0400 (EDT)
In-Reply-To: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

map_resources is the last initialization step. It is executed on
1st VCPU run. At that stage the code checks the userspace has provided
the base addresses for the relevant VGIC regions, which depend on
the type of VGIC that is exposed to the guest.

The function also forces the vgic_init if it has not been executed yet
(only allowed for VGIC v2).

for GICv2, The VGIC CPU interface is mapped onto the GIC virtual CPU
interface.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/vgic/vgic.h       |  1 +
 virt/kvm/arm/vgic/vgic-v2.c   | 47 +++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-v3.c   | 44 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h      | 16 +++++++++++++++
 virt/kvm/arm/vgic/vgic_init.c | 27 +++++++++++++++++++++++++
 5 files changed, 135 insertions(+)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 3566393..6e5e6d7 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -204,6 +204,7 @@ int kvm_vgic_create(struct kvm *kvm, u32 type);
 void kvm_vgic_destroy(struct kvm *kvm);
 void kvm_vgic_vcpu_early_init(struct kvm_vcpu *vcpu);
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu);
+int kvm_vgic_map_resources(struct kvm *kvm);
 int kvm_vgic_hyp_init(void);
 
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 47875a2..ad2b3be 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -213,6 +213,53 @@ void vgic_v2_enable(struct kvm_vcpu *vcpu)
 {
 }
 
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
index 97cf901..bd868e2 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -201,6 +201,50 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 {
 }
 
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
index fbfc7b9..8fbbe10 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -43,6 +43,9 @@ void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_enable(struct kvm_vcpu *vcpu);
 int vgic_v2_probe(struct device_node *vgic_node);
+int vgic_v2_map_resources(struct kvm *kvm);
+int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
+			     enum vgic_type);
 
 #ifdef CONFIG_KVM_ARM_VGIC_V3
 void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu);
@@ -58,6 +61,8 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_enable(struct kvm_vcpu *vcpu);
 int vgic_v3_probe(struct device_node *vgic_node);
+int vgic_v3_map_resources(struct kvm *kvm);
+int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -110,6 +115,17 @@ static inline int vgic_v3_probe(struct device_node *vgic_node)
 {
 	return -ENODEV;
 }
+
+static inline int vgic_v3_map_resources(struct kvm *kvm)
+{
+	return -ENODEV;
+}
+
+static inline int vgic_register_redist_iodevs(struct kvm *kvm,
+					      gpa_t dist_base_address)
+{
+	return -ENODEV;
+}
 #endif
 
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
diff --git a/virt/kvm/arm/vgic/vgic_init.c b/virt/kvm/arm/vgic/vgic_init.c
index ecc1f6c..27b21c4 100644
--- a/virt/kvm/arm/vgic/vgic_init.c
+++ b/virt/kvm/arm/vgic/vgic_init.c
@@ -321,6 +321,33 @@ int vgic_lazy_init(struct kvm *kvm)
 	return ret;
 }
 
+/* RESOURCE MAPPING */
+
+/**
+ * Map the MMIO regions depending on the VGIC model exposed to the guest
+ * called on the first VCPU run.
+ * Also map the virtual CPU interface into the VM.
+ * v2/v3 derivatives call vgic_init if not already done.
+ * Completion can be tested by vgic_ready
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
-- 
2.7.3
