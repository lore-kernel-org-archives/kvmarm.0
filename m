From: Wei Huang <wei@redhat.com>
Subject: [PATCH V1 6/7] KVM: GICv3: Extract the common code from DT
Date: Fri,  5 Feb 2016 12:07:33 -0500
Message-ID: <1454692054-8984-7-git-send-email-wei@redhat.com>
References: <1454692054-8984-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1454692054-8984-1-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, christoffer.dall@linaro.org, kvm@vger.kernel.org, hanjun.guo@linaro.org, fu.wei@linaro.org, drjones@redhat.com, wei@redhat.com, al.stone@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

In preparation for ACPI probing, this patch extracts the DT-neutral
code into vgic_v3_probe(). DT function nows fills out the following
info in *vgic:
  - maint_irq (mapped)
  - GICv resources

Signed-off-by: Wei Huang <wei@redhat.com>
---
 virt/kvm/arm/vgic-v3.c | 75 ++++++++++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 33 deletions(-)

diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index b036134..5eca58a 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -239,20 +239,11 @@ static int vgic_v3_dt_probe(struct vgic_params *vgic)
 
 	vgic->maint_irq = irq_of_parse_and_map(vgic_node, 0);
 	if (!vgic->maint_irq) {
-		kvm_err("error getting vgic maintenance irq from DT\n");
+		kvm_err("Cannot getting vgic maintenance irq from DT\n");
 		ret = -ENXIO;
 		goto out;
 	}
 
-	ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
-
-	/*
-	 * The ListRegs field is 5 bits, but there is a architectural
-	 * maximum of 16 list registers. Just ignore bit 4...
-	 */
-	vgic->nr_lr = (ich_vtr_el2 & 0xf) + 1;
-	vgic->can_emulate_gicv2 = false;
-
 	if (of_property_read_u32(vgic_node, "#redistributor-regions", &gicv_idx))
 		gicv_idx = 1;
 
@@ -260,35 +251,15 @@ static int vgic_v3_dt_probe(struct vgic_params *vgic)
 	if (of_address_to_resource(vgic_node, gicv_idx, &vcpu_res)) {
 		kvm_info("GICv3: no GICV resource entry\n");
 		vgic->vcpu_phys_base = 0;
-	} else if (!PAGE_ALIGNED(vcpu_res.start)) {
-		pr_warn("GICV physical address 0x%llx not page aligned\n",
-			(unsigned long long)vcpu_res.start);
-		vgic->vcpu_phys_base = 0;
-	} else if (!PAGE_ALIGNED(resource_size(&vcpu_res))) {
-		pr_warn("GICV size 0x%llx not a multiple of page size 0x%lx\n",
-			(unsigned long long)resource_size(&vcpu_res),
-			PAGE_SIZE);
-		vgic->vcpu_phys_base = 0;
 	} else {
 		vgic->vcpu_phys_base = vcpu_res.start;
-		vgic->can_emulate_gicv2 = true;
-		kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
-					KVM_DEV_TYPE_ARM_VGIC_V2);
+		vgic->vcpu_size = resource_size(&vcpu_res);
 	}
-	if (vgic->vcpu_phys_base == 0)
-		kvm_info("disabling GICv2 emulation\n");
-	kvm_register_device_ops(&kvm_arm_vgic_v3_ops, KVM_DEV_TYPE_ARM_VGIC_V3);
-
-	vgic->vctrl_base = NULL;
-	vgic->type = VGIC_V3;
-	vgic->max_gic_vcpus = VGIC_V3_MAX_CPUS;
-
-	kvm_info("%s@%llx IRQ%d\n", vgic_node->name,
-		 vcpu_res.start, vgic->maint_irq);
 out:
 	of_node_put(vgic_node);
 	return ret;
 }
+
 /**
  * vgic_v3_probe - probe for a GICv3 compatible interrupt controller
  * @ops:	address of a pointer to the GICv3 operations
@@ -304,10 +275,48 @@ int vgic_v3_probe(const struct vgic_ops **ops,
 	int ret = 0;
 	struct vgic_params *vgic = &vgic_v3_params;
 
+	/* DT probing first, then try ACPI probing */
 	ret = vgic_v3_dt_probe(vgic);
+	if (ret)
+		goto out;
+
+	ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
+
+	/*
+	 * The ListRegs field is 5 bits, but there is a architectural
+	 * maximum of 16 list registers. Just ignore bit 4...
+	 */
+	vgic->nr_lr = (ich_vtr_el2 & 0xf) + 1;
+
+	if (!PAGE_ALIGNED(vgic->vcpu_phys_base)) {
+		pr_warn("GICV physical address 0x%llx not page aligned\n",
+			(unsigned long long)vgic->vcpu_phys_base);
+		vgic->vcpu_phys_base = 0;
+	} else if (!PAGE_ALIGNED(vgic->vcpu_size)) {
+		pr_warn("GICV size 0x%llx not a multiple of page size 0x%lx\n",
+			(unsigned long long)vgic->vcpu_size, PAGE_SIZE);
+		vgic->vcpu_phys_base = 0;
+	};
+
+	if (vgic->vcpu_phys_base != 0) {
+		vgic->can_emulate_gicv2 = true;
+		kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
+					KVM_DEV_TYPE_ARM_VGIC_V2);
+	} else {
+		vgic->can_emulate_gicv2 = false;
+		kvm_info("disabling GICv2 emulation\n");
+	}
+
+	kvm_register_device_ops(&kvm_arm_vgic_v3_ops, KVM_DEV_TYPE_ARM_VGIC_V3);
+
+	vgic->vctrl_base = NULL;
+	vgic->type = VGIC_V3;
+	vgic->max_gic_vcpus = VGIC_V3_MAX_CPUS;
+
+	kvm_info("GICv3@%llx IRQ%d\n", vgic->vcpu_phys_base, vgic->maint_irq);
 
 	*ops = &vgic_v3_ops;
 	*params = vgic;
-
+out:
 	return ret;
 }
-- 
1.8.3.1

