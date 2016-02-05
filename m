From: Wei Huang <wei@redhat.com>
Subject: [PATCH V1 2/7] KVM: GIC: Add extra fields to store GICH and GICV resource info
Date: Fri,  5 Feb 2016 12:07:29 -0500
Message-ID: <1454692054-8984-3-git-send-email-wei@redhat.com>
References: <1454692054-8984-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1454692054-8984-1-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, christoffer.dall@linaro.org, kvm@vger.kernel.org, hanjun.guo@linaro.org, fu.wei@linaro.org, drjones@redhat.com, wei@redhat.com, al.stone@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds new fields in the struct vgic_params to store the
resource info (base and size) of GICH & GICV interfaces. These new
fields will be used by the DT and ACPI probing code later.

Signed-off-by: Wei Huang <wei@redhat.com>
---
 include/kvm/arm_vgic.h      |  8 +++++++-
 virt/kvm/arm/vgic-v2-emul.c |  4 ++--
 virt/kvm/arm/vgic-v2.c      | 19 ++++++++++---------
 virt/kvm/arm/vgic-v3.c      | 10 +++++-----
 4 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 59428d4..8003ca8 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -127,11 +127,17 @@ struct vgic_params {
 	/* vgic type */
 	enum vgic_type	type;
 	/* Physical address of vgic virtual cpu interface */
-	phys_addr_t	vcpu_base;
+	phys_addr_t	vcpu_phys_base;
+	/* Size of vgic virtual cpu interface */
+	phys_addr_t	vcpu_size;
 	/* Number of list registers */
 	u32		nr_lr;
 	/* Interrupt number */
 	unsigned int	maint_irq;
+	/* Virtual control interface physical address */
+	phys_addr_t	vctrl_phys_base;
+	/* Size of virtual control interface */
+	phys_addr_t	vctrl_size;
 	/* Virtual control interface base address */
 	void __iomem	*vctrl_base;
 	int		max_gic_vcpus;
diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
index 1390797..e244afe 100644
--- a/virt/kvm/arm/vgic-v2-emul.c
+++ b/virt/kvm/arm/vgic-v2-emul.c
@@ -521,8 +521,8 @@ static int vgic_v2_map_resources(struct kvm *kvm,
 	}
 
 	ret = kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
-				    params->vcpu_base, KVM_VGIC_V2_CPU_SIZE,
-				    true);
+				    params->vcpu_phys_base,
+				    KVM_VGIC_V2_CPU_SIZE, true);
 	if (ret) {
 		kvm_err("Unable to remap VGIC CPU to VCPU\n");
 		goto out_unregister;
diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
index dc9ceab..6540a6d 100644
--- a/virt/kvm/arm/vgic-v2.c
+++ b/virt/kvm/arm/vgic-v2.c
@@ -218,6 +218,8 @@ int vgic_v2_probe(const struct vgic_ops **ops,
 		kvm_err("Cannot obtain GICH resource\n");
 		goto out;
 	}
+	vgic->vctrl_phys_base = vctrl_res.start;
+	vgic->vctrl_size = resource_size(&vctrl_res);
 
 	vgic->vctrl_base = of_iomap(vgic_node, 2);
 	if (!vgic->vctrl_base) {
@@ -230,8 +232,8 @@ int vgic_v2_probe(const struct vgic_ops **ops,
 	vgic->nr_lr = (vgic->nr_lr & 0x3f) + 1;
 
 	ret = create_hyp_io_mappings(vgic->vctrl_base,
-				     vgic->vctrl_base + resource_size(&vctrl_res),
-				     vctrl_res.start);
+				     vgic->vctrl_base + vgic->vctrl_size,
+				     vgic->vctrl_phys_base);
 	if (ret) {
 		kvm_err("Cannot map VCTRL into hyp\n");
 		goto out_unmap;
@@ -242,18 +244,19 @@ int vgic_v2_probe(const struct vgic_ops **ops,
 		ret = -ENXIO;
 		goto out_unmap;
 	}
+	vgic->vcpu_phys_base = vcpu_res.start;
+	vgic->vcpu_size = resource_size(&vcpu_res);
 
-	if (!PAGE_ALIGNED(vcpu_res.start)) {
+	if (!PAGE_ALIGNED(vgic->vcpu_phys_base)) {
 		kvm_err("GICV physical address 0x%llx not page aligned\n",
 			(unsigned long long)vcpu_res.start);
 		ret = -ENXIO;
 		goto out_unmap;
 	}
 
-	if (!PAGE_ALIGNED(resource_size(&vcpu_res))) {
+	if (!PAGE_ALIGNED(vgic->vcpu_size)) {
 		kvm_err("GICV size 0x%llx not a multiple of page size 0x%lx\n",
-			(unsigned long long)resource_size(&vcpu_res),
-			PAGE_SIZE);
+			(unsigned long long)vgic->vcpu_size, PAGE_SIZE);
 		ret = -ENXIO;
 		goto out_unmap;
 	}
@@ -261,10 +264,8 @@ int vgic_v2_probe(const struct vgic_ops **ops,
 	vgic->can_emulate_gicv2 = true;
 	kvm_register_device_ops(&kvm_arm_vgic_v2_ops, KVM_DEV_TYPE_ARM_VGIC_V2);
 
-	vgic->vcpu_base = vcpu_res.start;
-
 	kvm_info("%s@%llx IRQ%d\n", vgic_node->name,
-		 vctrl_res.start, vgic->maint_irq);
+		 vgic->vctrl_phys_base, vgic->maint_irq);
 
 	vgic->type = VGIC_V2;
 	vgic->max_gic_vcpus = VGIC_V2_MAX_CPUS;
diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index 5fa5fa7..33a5fdf 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -266,23 +266,23 @@ int vgic_v3_probe(const struct vgic_ops **ops,
 	gicv_idx += 3; /* Also skip GICD, GICC, GICH */
 	if (of_address_to_resource(vgic_node, gicv_idx, &vcpu_res)) {
 		kvm_info("GICv3: no GICV resource entry\n");
-		vgic->vcpu_base = 0;
+		vgic->vcpu_phys_base = 0;
 	} else if (!PAGE_ALIGNED(vcpu_res.start)) {
 		pr_warn("GICV physical address 0x%llx not page aligned\n",
 			(unsigned long long)vcpu_res.start);
-		vgic->vcpu_base = 0;
+		vgic->vcpu_phys_base = 0;
 	} else if (!PAGE_ALIGNED(resource_size(&vcpu_res))) {
 		pr_warn("GICV size 0x%llx not a multiple of page size 0x%lx\n",
 			(unsigned long long)resource_size(&vcpu_res),
 			PAGE_SIZE);
-		vgic->vcpu_base = 0;
+		vgic->vcpu_phys_base = 0;
 	} else {
-		vgic->vcpu_base = vcpu_res.start;
+		vgic->vcpu_phys_base = vcpu_res.start;
 		vgic->can_emulate_gicv2 = true;
 		kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
 					KVM_DEV_TYPE_ARM_VGIC_V2);
 	}
-	if (vgic->vcpu_base == 0)
+	if (vgic->vcpu_phys_base == 0)
 		kvm_info("disabling GICv2 emulation\n");
 	kvm_register_device_ops(&kvm_arm_vgic_v3_ops, KVM_DEV_TYPE_ARM_VGIC_V3);
 
-- 
1.8.3.1

