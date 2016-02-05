From: Wei Huang <wei@redhat.com>
Subject: [PATCH V1 1/7] KVM: GIC: Move GIC DT probing code to GICv2 and GICv3 files
Date: Fri,  5 Feb 2016 12:07:28 -0500
Message-ID: <1454692054-8984-2-git-send-email-wei@redhat.com>
References: <1454692054-8984-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1454692054-8984-1-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, christoffer.dall@linaro.org, kvm@vger.kernel.org, hanjun.guo@linaro.org, fu.wei@linaro.org, drjones@redhat.com, wei@redhat.com, al.stone@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch moves GIC DT probing code from vgic.c to GICv2 & GICv3
sub-files. The probing will start from GICv2. If the probing fails,
KVM will try to probe GICv3 then.

Signed-off-by: Wei Huang <wei@redhat.com>
---
 include/kvm/arm_vgic.h |  6 ++----
 virt/kvm/arm/vgic-v2.c | 17 ++++++++++++++---
 virt/kvm/arm/vgic-v3.c | 15 ++++++++++++---
 virt/kvm/arm/vgic.c    | 22 ++--------------------
 4 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 13a3d53..59428d4 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -357,12 +357,10 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
 #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
 #define vgic_ready(k)		((k)->arch.vgic.ready)
 
-int vgic_v2_probe(struct device_node *vgic_node,
-		  const struct vgic_ops **ops,
+int vgic_v2_probe(const struct vgic_ops **ops,
 		  const struct vgic_params **params);
 #ifdef CONFIG_KVM_ARM_VGIC_V3
-int vgic_v3_probe(struct device_node *vgic_node,
-		  const struct vgic_ops **ops,
+int vgic_v3_probe(const struct vgic_ops **ops,
 		  const struct vgic_params **params);
 #else
 static inline int vgic_v3_probe(struct device_node *vgic_node,
diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
index ff02f08..dc9ceab 100644
--- a/virt/kvm/arm/vgic-v2.c
+++ b/virt/kvm/arm/vgic-v2.c
@@ -175,10 +175,15 @@ static const struct vgic_ops vgic_v2_ops = {
 };
 
 static struct vgic_params vgic_v2_params;
+static const struct of_device_id vgic_v2_ids[] = {
+	{ .compatible = "arm,cortex-a15-gic" },
+	{ .compatible = "arm,cortex-a7-gic" },
+	{ .compatible = "arm,gic-400" },
+	{},
+};
 
 /**
  * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
- * @node:	pointer to the DT node
  * @ops: 	address of a pointer to the GICv2 operations
  * @params:	address of a pointer to HW-specific parameters
  *
@@ -186,15 +191,21 @@ static struct vgic_params vgic_v2_params;
  * in *ops and the HW parameters in *params. Returns an error code
  * otherwise.
  */
-int vgic_v2_probe(struct device_node *vgic_node,
-		  const struct vgic_ops **ops,
+int vgic_v2_probe(const struct vgic_ops **ops,
 		  const struct vgic_params **params)
 {
 	int ret;
 	struct resource vctrl_res;
 	struct resource vcpu_res;
+	struct device_node *vgic_node;
 	struct vgic_params *vgic = &vgic_v2_params;
 
+	vgic_node = of_find_matching_node(NULL, vgic_v2_ids);
+	if (!vgic_node) {
+		ret = -ENODEV;
+		goto out;
+	}
+
 	vgic->maint_irq = irq_of_parse_and_map(vgic_node, 0);
 	if (!vgic->maint_irq) {
 		kvm_err("error getting vgic maintenance irq from DT\n");
diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index 453eafd..5fa5fa7 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -215,10 +215,13 @@ static const struct vgic_ops vgic_v3_ops = {
 };
 
 static struct vgic_params vgic_v3_params;
+static const struct of_device_id vgic_v3_ids[] = {
+	{ .compatible = "arm,gic-v3" },
+	{},
+};
 
 /**
  * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
- * @node:	pointer to the DT node
  * @ops: 	address of a pointer to the GICv3 operations
  * @params:	address of a pointer to HW-specific parameters
  *
@@ -226,15 +229,21 @@ static struct vgic_params vgic_v3_params;
  * in *ops and the HW parameters in *params. Returns an error code
  * otherwise.
  */
-int vgic_v3_probe(struct device_node *vgic_node,
-		  const struct vgic_ops **ops,
+int vgic_v3_probe(const struct vgic_ops **ops,
 		  const struct vgic_params **params)
 {
 	int ret = 0;
 	u32 gicv_idx;
 	struct resource vcpu_res;
+	struct device_node *vgic_node;
 	struct vgic_params *vgic = &vgic_v3_params;
 
+	vgic_node = of_find_matching_node(NULL, vgic_v3_ids);
+	if (!vgic_node) {
+		ret = -ENODEV;
+		goto out;
+	}
+
 	vgic->maint_irq = irq_of_parse_and_map(vgic_node, 0);
 	if (!vgic->maint_irq) {
 		kvm_err("error getting vgic maintenance irq from DT\n");
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 043032c..0d3d6b7 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2389,34 +2389,16 @@ static struct notifier_block vgic_cpu_nb = {
 	.notifier_call = vgic_cpu_notify,
 };
 
-static const struct of_device_id vgic_ids[] = {
-	{ .compatible = "arm,cortex-a15-gic",	.data = vgic_v2_probe, },
-	{ .compatible = "arm,cortex-a7-gic",	.data = vgic_v2_probe, },
-	{ .compatible = "arm,gic-400",		.data = vgic_v2_probe, },
-	{ .compatible = "arm,gic-v3",		.data = vgic_v3_probe, },
-	{},
-};
-
 int kvm_vgic_hyp_init(void)
 {
-	const struct of_device_id *matched_id;
-	const int (*vgic_probe)(struct device_node *,const struct vgic_ops **,
-				const struct vgic_params **);
-	struct device_node *vgic_node;
 	int ret;
 
-	vgic_node = of_find_matching_node_and_match(NULL,
-						    vgic_ids, &matched_id);
-	if (!vgic_node) {
+	/* try GICv2 probing first, then GICv3 probing */
+	if (vgic_v2_probe(&vgic_ops, &vgic) || vgic_v3_probe(&vgic_ops, &vgic)) {
 		kvm_err("error: no compatible GIC node found\n");
 		return -ENODEV;
 	}
 
-	vgic_probe = matched_id->data;
-	ret = vgic_probe(vgic_node, &vgic_ops, &vgic);
-	if (ret)
-		return ret;
-
 	ret = request_percpu_irq(vgic->maint_irq, vgic_maintenance_handler,
 				 "vgic", kvm_get_running_vcpus());
 	if (ret) {
-- 
1.8.3.1

