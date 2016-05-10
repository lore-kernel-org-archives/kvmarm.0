From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2] KVM: arm/arm64: vgic-new: Switch to firmware-independent
 probing
Date: Tue, 10 May 2016 09:46:23 +0100
Message-ID: <1462869983-5410-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 333B549BB1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2016 04:43:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L66NgHH+bkjD for <kvmarm@lists.cs.columbia.edu>;
 Tue, 10 May 2016 04:43:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EAD849BA6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 10 May 2016 04:43:42 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, andre.przywara@arm.com, eric.auger@linaro.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

As we did for the legacy code, switch the new VGIC implementation
the firmware-independent probing, giving us ACPI support for free.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
- From v1: Some additional cleanups, rebased on the lastest drop.

 virt/kvm/arm/vgic/vgic-init.c | 39 ++++++++++----------
 virt/kvm/arm/vgic/vgic-v2.c   | 82 +++++++++++++++----------------------------
 virt/kvm/arm/vgic/vgic-v3.c   | 44 ++++++-----------------
 virt/kvm/arm/vgic/vgic.h      |  8 +++--
 4 files changed, 63 insertions(+), 110 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 7fefb12..0c2c504 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -17,8 +17,6 @@
 #include <linux/uaccess.h>
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
 #include <asm/kvm_mmu.h>
@@ -387,14 +385,6 @@ static irqreturn_t vgic_maintenance_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static const struct of_device_id vgic_ids[] = {
-	{ .compatible = "arm,cortex-a15-gic",	.data = vgic_v2_probe, },
-	{ .compatible = "arm,cortex-a7-gic",	.data = vgic_v2_probe, },
-	{ .compatible = "arm,gic-400",		.data = vgic_v2_probe, },
-	{ .compatible = "arm,gic-v3",		.data = vgic_v3_probe, },
-	{},
-};
-
 /**
  * kvm_vgic_hyp_init: populates the kvm_vgic_global_state variable
  * according to the host GIC model. Accordingly calls either
@@ -403,23 +393,33 @@ static const struct of_device_id vgic_ids[] = {
  */
 int kvm_vgic_hyp_init(void)
 {
-	const struct of_device_id *matched_id;
-	const int (*vgic_probe)(struct device_node *);
-	struct device_node *vgic_node;
+	const struct gic_kvm_info *gic_kvm_info;
 	int ret;
 
-	vgic_node = of_find_matching_node_and_match(NULL,
-						    vgic_ids, &matched_id);
-	if (!vgic_node) {
-		kvm_err("error: no compatible GIC node found\n");
+	gic_kvm_info = gic_get_kvm_info();
+	if (!gic_kvm_info)
 		return -ENODEV;
+
+	if (!gic_kvm_info->maint_irq) {
+		kvm_err("No vgic maintenance irq\n");
+		return -ENXIO;
 	}
 
-	vgic_probe = matched_id->data;
-	ret = vgic_probe(vgic_node);
+	switch (gic_kvm_info->type) {
+	case GIC_V2:
+		ret = vgic_v2_probe(gic_kvm_info);
+		break;
+	case GIC_V3:
+		ret = vgic_v3_probe(gic_kvm_info);
+		break;
+	default:
+		ret = -ENODEV;
+	};
+
 	if (ret)
 		return ret;
 
+	kvm_vgic_global_state.maint_irq = gic_kvm_info->maint_irq;
 	ret = request_percpu_irq(kvm_vgic_global_state.maint_irq,
 				 vgic_maintenance_handler,
 				 "vgic", kvm_get_running_vcpus());
@@ -437,6 +437,7 @@ int kvm_vgic_hyp_init(void)
 
 	on_each_cpu(vgic_init_maintenance_interrupt, NULL, 1);
 
+	kvm_info("vgic interrupt IRQ%d\n", kvm_vgic_global_state.maint_irq);
 	return 0;
 
 out_free_irq:
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 4493593..e88b5aa 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -18,9 +18,6 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
 #include <asm/kvm_mmu.h>
 
 #include "vgic.h"
@@ -278,81 +275,58 @@ out:
  *
  * Returns 0 if a GICv2 has been found, returns an error code otherwise
  */
-int vgic_v2_probe(struct device_node *vgic_node)
+int vgic_v2_probe(const struct gic_kvm_info *info)
 {
 	int ret;
-	struct resource vctrl_res;
-	struct resource vcpu_res;
 
-	kvm_vgic_global_state.maint_irq = irq_of_parse_and_map(vgic_node, 0);
-	if (!kvm_vgic_global_state.maint_irq) {
-		kvm_err("error getting vgic maintenance irq from DT\n");
-		ret = -ENXIO;
-		goto out;
+	if (!info->vctrl.start) {
+		kvm_err("GICH not present in the firmware table\n");
+		return -ENXIO;
 	}
 
-	ret = of_address_to_resource(vgic_node, 2, &vctrl_res);
-	if (ret) {
-		kvm_err("Cannot obtain GICH resource\n");
-		goto out;
+	if (!PAGE_ALIGNED(info->vcpu.start)) {
+		kvm_err("GICV physical address 0x%llx not page aligned\n",
+			(unsigned long long)info->vcpu.start);
+		return -ENXIO;
+	}
+
+	if (!PAGE_ALIGNED(resource_size(&info->vcpu))) {
+		kvm_err("GICV size 0x%llx not a multiple of page size 0x%lx\n",
+			(unsigned long long)resource_size(&info->vcpu),
+			PAGE_SIZE);
+		return -ENXIO;
 	}
 
-	kvm_vgic_global_state.vctrl_base = of_iomap(vgic_node, 2);
+	kvm_vgic_global_state.vctrl_base = ioremap(info->vctrl.start,
+						   resource_size(&info->vctrl));
 	if (!kvm_vgic_global_state.vctrl_base) {
 		kvm_err("Cannot ioremap GICH\n");
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	kvm_vgic_global_state.nr_lr =
 		readl_relaxed(kvm_vgic_global_state.vctrl_base + GICH_VTR);
-	kvm_vgic_global_state.nr_lr = (kvm_vgic_global_state.nr_lr & 0x3f) + 1;
+	kvm_vgic_global_state.nr_lr &= 0x3f;
+	kvm_vgic_global_state.nr_lr += 1;
 
 	ret = create_hyp_io_mappings(kvm_vgic_global_state.vctrl_base,
 				     kvm_vgic_global_state.vctrl_base +
-					 resource_size(&vctrl_res),
-				     vctrl_res.start);
+					 resource_size(&info->vctrl),
+				     info->vctrl.start);
 	if (ret) {
 		kvm_err("Cannot map VCTRL into hyp\n");
-		goto out_unmap;
-	}
-
-	if (of_address_to_resource(vgic_node, 3, &vcpu_res)) {
-		kvm_err("Cannot obtain GICV resource\n");
-		ret = -ENXIO;
-		goto out_unmap;
-	}
-
-	if (!PAGE_ALIGNED(vcpu_res.start)) {
-		kvm_err("GICV physical address 0x%llx not page aligned\n",
-			(unsigned long long)vcpu_res.start);
-		ret = -ENXIO;
-		goto out_unmap;
-	}
-
-	if (!PAGE_ALIGNED(resource_size(&vcpu_res))) {
-		kvm_err("GICV size 0x%llx not a multiple of page size 0x%lx\n",
-			(unsigned long long)resource_size(&vcpu_res),
-			PAGE_SIZE);
-		ret = -ENXIO;
-		goto out_unmap;
+		iounmap(kvm_vgic_global_state.vctrl_base);
+		return ret;
 	}
 
 	kvm_vgic_global_state.can_emulate_gicv2 = true;
 	kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
 
-	kvm_vgic_global_state.vcpu_base = vcpu_res.start;
-
-	kvm_info("%s@%llx IRQ%d\n", vgic_node->name,
-		 vctrl_res.start, kvm_vgic_global_state.maint_irq);
-
+	kvm_vgic_global_state.vcpu_base = info->vcpu.start;
 	kvm_vgic_global_state.type = VGIC_V2;
 	kvm_vgic_global_state.max_gic_vcpus = VGIC_V2_MAX_CPUS;
-	goto out;
 
-out_unmap:
-	iounmap(kvm_vgic_global_state.vctrl_base);
-out:
-	of_node_put(vgic_node);
-	return ret;
+	kvm_info("vgic-v2@%llx\n", info->vctrl.start);
+
+	return 0;
 }
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 6d7422f..6073f5d 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -16,9 +16,6 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <kvm/arm_vgic.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_irq.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_asm.h>
 
@@ -271,21 +268,9 @@ out:
  *
  * Returns 0 if a GICv3 has been found, returns an error code otherwise
  */
-int vgic_v3_probe(struct device_node *vgic_node)
+int vgic_v3_probe(const struct gic_kvm_info *info)
 {
-	u32 ich_vtr_el2;
-	u32 gicv_idx;
-	int ret = 0;
-	struct resource vcpu_res;
-
-	kvm_vgic_global_state.maint_irq = irq_of_parse_and_map(vgic_node, 0);
-	if (!kvm_vgic_global_state.maint_irq) {
-		kvm_err("error getting vgic maintenance irq from DT\n");
-		ret = -ENXIO;
-		goto out;
-	}
-
-	ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
+	u32 ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
 
 	/*
 	 * The ListRegs field is 5 bits, but there is a architectural
@@ -294,27 +279,23 @@ int vgic_v3_probe(struct device_node *vgic_node)
 	kvm_vgic_global_state.nr_lr = (ich_vtr_el2 & 0xf) + 1;
 	kvm_vgic_global_state.can_emulate_gicv2 = false;
 
-	if (of_property_read_u32(vgic_node, "#redistributor-regions",
-				 &gicv_idx))
-		gicv_idx = 1;
-
-	gicv_idx += 3; /* Also skip GICD, GICC, GICH */
-	if (of_address_to_resource(vgic_node, gicv_idx, &vcpu_res)) {
+	if (!info->vcpu.start) {
 		kvm_info("GICv3: no GICV resource entry\n");
 		kvm_vgic_global_state.vcpu_base = 0;
-	} else if (!PAGE_ALIGNED(vcpu_res.start)) {
+	} else if (!PAGE_ALIGNED(info->vcpu.start)) {
 		pr_warn("GICV physical address 0x%llx not page aligned\n",
-			(unsigned long long)vcpu_res.start);
+			(unsigned long long)info->vcpu.start);
 		kvm_vgic_global_state.vcpu_base = 0;
-	} else if (!PAGE_ALIGNED(resource_size(&vcpu_res))) {
+	} else if (!PAGE_ALIGNED(resource_size(&info->vcpu))) {
 		pr_warn("GICV size 0x%llx not a multiple of page size 0x%lx\n",
-			(unsigned long long)resource_size(&vcpu_res),
+			(unsigned long long)resource_size(&info->vcpu),
 			PAGE_SIZE);
 		kvm_vgic_global_state.vcpu_base = 0;
 	} else {
-		kvm_vgic_global_state.vcpu_base = vcpu_res.start;
+		kvm_vgic_global_state.vcpu_base = info->vcpu.start;
 		kvm_vgic_global_state.can_emulate_gicv2 = true;
 		kvm_register_vgic_device(KVM_DEV_TYPE_ARM_VGIC_V2);
+		kvm_info("vgic-v2@%llx\n", info->vcpu.start);
 	}
 	if (kvm_vgic_global_state.vcpu_base == 0)
 		kvm_info("disabling GICv2 emulation\n");
@@ -324,10 +305,5 @@ int vgic_v3_probe(struct device_node *vgic_node)
 	kvm_vgic_global_state.type = VGIC_V3;
 	kvm_vgic_global_state.max_gic_vcpus = VGIC_V3_MAX_CPUS;
 
-	kvm_info("%s@%llx IRQ%d\n", vgic_node->name,
-		 vcpu_res.start, kvm_vgic_global_state.maint_irq);
-
-out:
-	of_node_put(vgic_node);
-	return ret;
+	return 0;
 }
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 5c7dc99..83d3c48 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -16,6 +16,8 @@
 #ifndef __KVM_ARM_VGIC_NEW_H__
 #define __KVM_ARM_VGIC_NEW_H__
 
+#include <linux/irqchip/arm-gic-common.h>
+
 #define PRODUCT_ID_KVM		0x4b	/* ASCII code K */
 #define IMPLEMENTER_ARM		0x43b
 
@@ -44,7 +46,7 @@ int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_enable(struct kvm_vcpu *vcpu);
-int vgic_v2_probe(struct device_node *vgic_node);
+int vgic_v2_probe(const struct gic_kvm_info *info);
 int vgic_v2_map_resources(struct kvm *kvm);
 int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 			     enum vgic_type);
@@ -58,7 +60,7 @@ void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_enable(struct kvm_vcpu *vcpu);
-int vgic_v3_probe(struct device_node *vgic_node);
+int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 #else
@@ -97,7 +99,7 @@ static inline void vgic_v3_enable(struct kvm_vcpu *vcpu)
 {
 }
 
-static inline int vgic_v3_probe(struct device_node *vgic_node)
+static inline int vgic_v3_probe(const struct gic_kvm_info *info)
 {
 	return -ENODEV;
 }
-- 
2.1.4
