From: Wei Huang <wei@redhat.com>
Subject: [PATCH V1 4/7] KVM: GICv2: Extract the common code from DT
Date: Fri,  5 Feb 2016 12:07:31 -0500
Message-ID: <1454692054-8984-5-git-send-email-wei@redhat.com>
References: <1454692054-8984-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1454692054-8984-1-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, christoffer.dall@linaro.org, kvm@vger.kernel.org, hanjun.guo@linaro.org, fu.wei@linaro.org, drjones@redhat.com, wei@redhat.com, al.stone@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch extracts the common code from the DT probe function. With
this patch the DT function only fills out the following info in *vgic.
  - maint_irq (mapped)
  - GICH resource
  - GICV resource
Note that vgic->vctrl_base io-remapping is now moved to vgic_v2_probe().

Signed-off-by: Wei Huang <wei@redhat.com>
---
 virt/kvm/arm/vgic-v2.c | 92 ++++++++++++++++++++++++--------------------------
 1 file changed, 44 insertions(+), 48 deletions(-)

diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
index 7dd5fb3..b60e73a 100644
--- a/virt/kvm/arm/vgic-v2.c
+++ b/virt/kvm/arm/vgic-v2.c
@@ -188,7 +188,7 @@ static const struct of_device_id vgic_v2_ids[] = {
  */
 static int vgic_v2_dt_probe(struct vgic_params *vgic)
 {
-	int ret;
+	int ret = 0;
 	struct resource vctrl_res;
 	struct resource vcpu_res;
 	struct device_node *vgic_node;
@@ -201,24 +201,55 @@ static int vgic_v2_dt_probe(struct vgic_params *vgic)
 
 	vgic->maint_irq = irq_of_parse_and_map(vgic_node, 0);
 	if (!vgic->maint_irq) {
-		kvm_err("error getting vgic maintenance irq from DT\n");
+		kvm_err("Cannot get vgic maintenance irq from DT\n");
 		ret = -ENXIO;
 		goto out;
 	}
 
 	ret = of_address_to_resource(vgic_node, 2, &vctrl_res);
 	if (ret) {
-		kvm_err("Cannot obtain GICH resource\n");
+		kvm_err("Cannot obtain GICH resource from DT\n");
 		goto out;
 	}
 	vgic->vctrl_phys_base = vctrl_res.start;
 	vgic->vctrl_size = resource_size(&vctrl_res);
 
-	vgic->vctrl_base = of_iomap(vgic_node, 2);
+	if (of_address_to_resource(vgic_node, 3, &vcpu_res)) {
+		kvm_err("Cannot obtain GICV resource\n");
+		ret = -ENXIO;
+		goto out;
+	}
+	vgic->vcpu_phys_base = vcpu_res.start;
+	vgic->vcpu_size = resource_size(&vcpu_res);
+out:
+	of_node_put(vgic_node);
+	return ret;
+}
+
+/**
+ * vgic_v2_probe - probe for a GICv2 compatible interrupt controller
+ * @ops:	address of a pointer to the GICv2 operations
+ * @params:	address of a pointer to HW-specific parameters
+ *
+ * Returns 0 if a GICv2 has been found, with the low level operations
+ * in *ops and the HW parameters in *params. Returns an error code
+ * otherwise.
+ */
+int vgic_v2_probe(const struct vgic_ops **ops,
+		  const struct vgic_params **params)
+{
+	int ret;
+	struct vgic_params *vgic = &vgic_v2_params;
+
+	ret = vgic_v2_dt_probe(vgic);
+	if (ret)
+		goto err_out;
+
+	vgic->vctrl_base = ioremap(vgic->vctrl_phys_base, vgic->vctrl_size);
 	if (!vgic->vctrl_base) {
 		kvm_err("Cannot ioremap GICH\n");
 		ret = -ENOMEM;
-		goto out;
+		goto err_out;
 	}
 
 	vgic->nr_lr = readl_relaxed(vgic->vctrl_base + GICH_VTR);
@@ -229,71 +260,36 @@ static int vgic_v2_dt_probe(struct vgic_params *vgic)
 				     vgic->vctrl_phys_base);
 	if (ret) {
 		kvm_err("Cannot map VCTRL into hyp\n");
-		goto out_unmap;
-	}
-
-	if (of_address_to_resource(vgic_node, 3, &vcpu_res)) {
-		kvm_err("Cannot obtain GICV resource\n");
-		ret = -ENXIO;
-		goto out_unmap;
+		goto err_out;
 	}
-	vgic->vcpu_phys_base = vcpu_res.start;
-	vgic->vcpu_size = resource_size(&vcpu_res);
 
 	if (!PAGE_ALIGNED(vgic->vcpu_phys_base)) {
 		kvm_err("GICV physical address 0x%llx not page aligned\n",
-			(unsigned long long)vcpu_res.start);
+			(unsigned long long)vgic->vcpu_phys_base);
 		ret = -ENXIO;
-		goto out_unmap;
+		goto err_out;
 	}
 
 	if (!PAGE_ALIGNED(vgic->vcpu_size)) {
 		kvm_err("GICV size 0x%llx not a multiple of page size 0x%lx\n",
 			(unsigned long long)vgic->vcpu_size, PAGE_SIZE);
 		ret = -ENXIO;
-		goto out_unmap;
+		goto err_out;
 	}
 
-	vgic->can_emulate_gicv2 = true;
 	kvm_register_device_ops(&kvm_arm_vgic_v2_ops, KVM_DEV_TYPE_ARM_VGIC_V2);
-
-	kvm_info("%s@%llx IRQ%d\n", vgic_node->name,
-		 vgic->vctrl_phys_base, vgic->maint_irq);
-
+	vgic->can_emulate_gicv2 = true;
 	vgic->type = VGIC_V2;
 	vgic->max_gic_vcpus = VGIC_V2_MAX_CPUS;
-	goto out;
 
-out_unmap:
-	iounmap(vgic->vctrl_base);
-out:
-	of_node_put(vgic_node);
-	return ret;
-}
-
-/**
- * vgic_v2_probe - probe for a GICv2 compatible interrupt controller
- * @ops:	address of a pointer to the GICv2 operations
- * @params:	address of a pointer to HW-specific parameters
- *
- * Returns 0 if a GICv2 has been found, with the low level operations
- * in *ops and the HW parameters in *params. Returns an error code
- * otherwise.
- */
-int vgic_v2_probe(const struct vgic_ops **ops,
-		  const struct vgic_params **params)
-{
-	int ret;
-	struct vgic_params *vgic = &vgic_v2_params;
-
-	ret = vgic_v2_dt_probe(vgic);
-	if (ret)
-		goto err_out;
+	kvm_info("GICv2@%llx IRQ%d\n", vgic->vctrl_phys_base, vgic->maint_irq);
 
 	*ops = &vgic_v2_ops;
 	*params = vgic;
 
 	return 0;
 err_out:
+	if (vgic->vctrl_base)
+		iounmap(vgic->vctrl_base);
 	return ret;
 }
-- 
1.8.3.1

