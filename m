From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] KVM: arm/arm64: vgic-new: Switch to firmware-independent probing
Date: Tue,  3 May 2016 15:17:04 +0100
Message-ID: <1462285024-3801-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: christoffer.dall@linaro.org, andre.przywara@arm.com, eric.auger@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

As we did for the legacy code, switch the new VGIC implementation
the firmware-independent probing, giving us ACPI support for free.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
This patch of course relies on Julien's previous series.
I've tested it on Mustang (v2) and LS2080 (v3).

 virt/kvm/arm/vgic/vgic-init.c | 37 ++++++++++----------
 virt/kvm/arm/vgic/vgic-v2.c   | 79 +++++++++++++++----------------------------
 virt/kvm/arm/vgic/vgic-v3.c   | 38 +++++----------------
 virt/kvm/arm/vgic/vgic.h      |  6 ++--
 4 files changed, 61 insertions(+), 99 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 27b21c4..4c8e448 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -387,14 +387,6 @@ static irqreturn_t vgic_maintenance_handler(int irq, void *data)
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
@@ -403,23 +395,33 @@ static const struct of_device_id vgic_ids[] = {
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
@@ -437,6 +439,7 @@ int kvm_vgic_hyp_init(void)
 
 	on_each_cpu(vgic_init_maintenance_interrupt, NULL, 1);
 
+	kvm_info("vgic interrupt IRQ%d\n", kvm_vgic_global_state.maint_irq);
 	return 0;
 
 out_free_irq:
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index b8bfece..5f09c90 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -278,81 +278,58 @@ out:
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
index e975a33..014a14f 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -274,19 +274,8 @@ out:
  *
  * Returns 0 if a GICv3 has been found, returns an error code otherwise
  */
-int vgic_v3_probe(struct device_node *vgic_node)
+int vgic_v3_probe(const struct gic_kvm_info *info)
 {
-	int ret = 0;
-	u32 gicv_idx;
-	struct resource vcpu_res;
-
-	kvm_vgic_global_state.maint_irq = irq_of_parse_and_map(vgic_node, 0);
-	if (!kvm_vgic_global_state.maint_irq) {
-		kvm_err("error getting vgic maintenance irq from DT\n");
-		ret = -ENXIO;
-		goto out;
-	}
-
 	ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
 
 	/*
@@ -296,27 +285,23 @@ int vgic_v3_probe(struct device_node *vgic_node)
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
@@ -326,10 +311,5 @@ int vgic_v3_probe(struct device_node *vgic_node)
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
index f970e3e..6d2cede 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -16,6 +16,8 @@
 #ifndef __KVM_ARM_VGIC_NEW_H__
 #define __KVM_ARM_VGIC_NEW_H__
 
+#include <linux/irqchip/arm-gic-common.h>
+
 #define PRODUCT_ID_KVM		0x4b	/* ASCII code K */
 #define IMPLEMENTER_ARM		0x43b
 
@@ -42,7 +44,7 @@ int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_enable(struct kvm_vcpu *vcpu);
-int vgic_v2_probe(struct device_node *vgic_node);
+int vgic_v2_probe(const struct gic_kvm_info *info);
 int vgic_v2_map_resources(struct kvm *kvm);
 int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 			     enum vgic_type);
@@ -56,7 +58,7 @@ void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_enable(struct kvm_vcpu *vcpu);
-int vgic_v3_probe(struct device_node *vgic_node);
+int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 #else
-- 
2.1.4

