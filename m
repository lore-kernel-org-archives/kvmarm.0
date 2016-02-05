From: Wei Huang <wei@redhat.com>
Subject: [PATCH V1 3/7] KVM: GIC: Create a common probe function for GIC
Date: Fri,  5 Feb 2016 12:07:30 -0500
Message-ID: <1454692054-8984-4-git-send-email-wei@redhat.com>
References: <1454692054-8984-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73A48497F4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2016 12:02:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TU3QMaWU1slD for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2016 12:02:08 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1D68D4972F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2016 12:02:08 -0500 (EST)
In-Reply-To: <1454692054-8984-1-git-send-email-wei@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, fu.wei@linaro.org, hanjun.guo@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch creates common functions for both GICv2 and GICv3. The
existing functions are renamed to new names specifically for DT.

Signed-off-by: Wei Huang <wei@redhat.com>
---
 virt/kvm/arm/vgic-v2.c | 44 +++++++++++++++++++++++++++++++-------------
 virt/kvm/arm/vgic-v3.c | 37 ++++++++++++++++++++++++-------------
 2 files changed, 55 insertions(+), 26 deletions(-)

diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
index 6540a6d..7dd5fb3 100644
--- a/virt/kvm/arm/vgic-v2.c
+++ b/virt/kvm/arm/vgic-v2.c
@@ -182,23 +182,16 @@ static const struct of_device_id vgic_v2_ids[] = {
 	{},
 };
 
-/**
- * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
- * @ops: 	address of a pointer to the GICv2 operations
- * @params:	address of a pointer to HW-specific parameters
- *
- * Returns 0 if a GICv2 has been found, with the low level operations
- * in *ops and the HW parameters in *params. Returns an error code
- * otherwise.
+/*
+ * Returns 0 if a GICv2 can be found in DT and the details of GICv2
+ * configuration are stored in *vgic. Otherwise returns an error code.
  */
-int vgic_v2_probe(const struct vgic_ops **ops,
-		  const struct vgic_params **params)
+static int vgic_v2_dt_probe(struct vgic_params *vgic)
 {
 	int ret;
 	struct resource vctrl_res;
 	struct resource vcpu_res;
 	struct device_node *vgic_node;
-	struct vgic_params *vgic = &vgic_v2_params;
 
 	vgic_node = of_find_matching_node(NULL, vgic_v2_ids);
 	if (!vgic_node) {
@@ -269,8 +262,6 @@ int vgic_v2_probe(const struct vgic_ops **ops,
 
 	vgic->type = VGIC_V2;
 	vgic->max_gic_vcpus = VGIC_V2_MAX_CPUS;
-	*ops = &vgic_v2_ops;
-	*params = vgic;
 	goto out;
 
 out_unmap:
@@ -279,3 +270,30 @@ out:
 	of_node_put(vgic_node);
 	return ret;
 }
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
+	*ops = &vgic_v2_ops;
+	*params = vgic;
+
+	return 0;
+err_out:
+	return ret;
+}
diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index 33a5fdf..b036134 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -220,23 +220,16 @@ static const struct of_device_id vgic_v3_ids[] = {
 	{},
 };
 
-/**
- * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
- * @ops: 	address of a pointer to the GICv3 operations
- * @params:	address of a pointer to HW-specific parameters
- *
- * Returns 0 if a GICv3 has been found, with the low level operations
- * in *ops and the HW parameters in *params. Returns an error code
- * otherwise.
+/*
+ * Returns 0 if a GICv3 can be found in DT and the details of GICv3
+ * configuration are stored in *vgic. Otherwise returns an error code.
  */
-int vgic_v3_probe(const struct vgic_ops **ops,
-		  const struct vgic_params **params)
+static int vgic_v3_dt_probe(struct vgic_params *vgic)
 {
 	int ret = 0;
 	u32 gicv_idx;
 	struct resource vcpu_res;
 	struct device_node *vgic_node;
-	struct vgic_params *vgic = &vgic_v3_params;
 
 	vgic_node = of_find_matching_node(NULL, vgic_v3_ids);
 	if (!vgic_node) {
@@ -292,11 +285,29 @@ int vgic_v3_probe(const struct vgic_ops **ops,
 
 	kvm_info("%s@%llx IRQ%d\n", vgic_node->name,
 		 vcpu_res.start, vgic->maint_irq);
+out:
+	of_node_put(vgic_node);
+	return ret;
+}
+/**
+ * vgic_v3_probe - probe for a GICv3 compatible interrupt controller
+ * @ops:	address of a pointer to the GICv3 operations
+ * @params:	address of a pointer to HW-specific parameters
+ *
+ * Returns 0 if a GICv3 has been found, with the low level operations
+ * in *ops and the HW parameters in *params. Returns an error code
+ * otherwise.
+ */
+int vgic_v3_probe(const struct vgic_ops **ops,
+		  const struct vgic_params **params)
+{
+	int ret = 0;
+	struct vgic_params *vgic = &vgic_v3_params;
+
+	ret = vgic_v3_dt_probe(vgic);
 
 	*ops = &vgic_v3_ops;
 	*params = vgic;
 
-out:
-	of_node_put(vgic_node);
 	return ret;
 }
-- 
1.8.3.1
