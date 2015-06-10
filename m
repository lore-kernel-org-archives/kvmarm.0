From: Wei Huang <wei@redhat.com>
Subject: [PATCH V2 3/5] kvm: arm64: Detect GIC version for proper ACPI vGIC
 probing
Date: Wed, 10 Jun 2015 00:16:05 -0400
Message-ID: <1433909767-12189-4-git-send-email-wei@redhat.com>
References: <1433909767-12189-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F0205400E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2015 00:06:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5FWHR3of3kaB for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jun 2015 00:06:29 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7429D54074
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jun 2015 00:06:29 -0400 (EDT)
In-Reply-To: <1433909767-12189-1-git-send-email-wei@redhat.com>
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
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, hanjun.guo@linaro.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

There are two GICs (GICv2 and GICv3) supported by KVM. So it is necessary
to find out GIC version before calling ACPI probing functions defined
in vgic-v2.c and vgic-v3.c.

This patch detects GIC version by checking gic_version field of GIC
distributor, which was defined  since ACPI 6.0. In case of ACPI 5.1,
we use manual hardware discovery to find out GIC version.

NOTE: This patch is based on a recent patch by Hanjun Guo.

Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Wei Huang <wei@redhat.com>
---
 include/kvm/arm_vgic.h |  18 +++++++++
 virt/kvm/arm/vgic-v2.c |  10 +++++
 virt/kvm/arm/vgic-v3.c |  10 +++++
 virt/kvm/arm/vgic.c    | 100 ++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 137 insertions(+), 1 deletion(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 3ee732a..7a44b08 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -24,6 +24,7 @@
 #include <linux/irqreturn.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
+#include <linux/acpi.h>
 #include <kvm/iodev.h>
 
 #define VGIC_NR_IRQS_LEGACY	256
@@ -335,10 +336,18 @@ int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
 int vgic_v2_dt_probe(struct device_node *vgic_node,
 		     const struct vgic_ops **ops,
 		     const struct vgic_params **params);
+#ifdef CONFIG_ACPI
+int vgic_v2_acpi_probe(struct acpi_madt_generic_interrupt *,
+		       const struct vgic_ops **ops,
+		       const struct vgic_params **params);
+#endif /* CONFIG_ACPI */
 #ifdef CONFIG_ARM_GIC_V3
 int vgic_v3_dt_probe(struct device_node *vgic_node,
 		     const struct vgic_ops **ops,
 		     const struct vgic_params **params);
+int vgic_v3_acpi_probe(struct acpi_madt_generic_interrupt *,
+		       const struct vgic_ops **ops,
+		       const struct vgic_params **params);
 #else
 static inline int vgic_v3_dt_probe(struct device_node *vgic_node,
 				   const struct vgic_ops **ops,
@@ -346,6 +355,15 @@ static inline int vgic_v3_dt_probe(struct device_node *vgic_node,
 {
 	return -ENODEV;
 }
+
+#ifdef CONFIG_ACPI
+int vgic_v3_acpi_probe(struct acpi_madt_generic_interrupt *,
+		       const struct vgic_ops **ops,
+		       const struct vgic_params **params)
+{
+	return -ENODEV;
+}
+#endif /* CONFIG_ACPI */
 #endif
 
 #endif
diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
index 295996f..711de82 100644
--- a/virt/kvm/arm/vgic-v2.c
+++ b/virt/kvm/arm/vgic-v2.c
@@ -23,6 +23,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/acpi.h>
 
 #include <linux/irqchip/arm-gic.h>
 
@@ -257,3 +258,12 @@ out:
 	of_node_put(vgic_node);
 	return ret;
 }
+
+#ifdef CONFIG_ACPI
+int vgic_v2_acpi_probe(struct acpi_madt_generic_interrupt *vgic_acpi,
+		       const struct vgic_ops **ops,
+		       const struct vgic_params **params)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_ACPI */
diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index 91814e2..99d0f9f 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -23,6 +23,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/acpi.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
 
@@ -285,3 +286,12 @@ out:
 	of_node_put(vgic_node);
 	return ret;
 }
+
+#ifdef CONFIG_ACPI
+int vgic_v3_acpi_probe(struct acpi_madt_generic_interrupt *vgic_acpi,
+		       const struct vgic_ops **ops,
+		       const struct vgic_params **params)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_ACPI */
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index b4010f0..cd09877 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -28,6 +28,7 @@
 #include <linux/acpi.h>
 
 #include <linux/irqchip/arm-gic.h>
+#include <linux/irqchip/arm-gic-v3.h>
 
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_arm.h>
@@ -2114,9 +2115,106 @@ static int kvm_vgic_dt_probe(void)
 }
 
 #ifdef CONFIG_ACPI
+u8 gic_version = ACPI_MADT_GIC_VER_UNKNOWN;
+phys_addr_t dist_phy_base;
+static struct acpi_madt_generic_interrupt *vgic_acpi;
+
+static void gic_get_acpi_header(struct acpi_subtable_header *header)
+{
+	vgic_acpi = (struct acpi_madt_generic_interrupt *)header;
+}
+
+static int gic_parse_distributor(struct acpi_subtable_header *header,
+				 const unsigned long end)
+{
+	struct acpi_madt_generic_distributor *dist;
+
+	dist = (struct acpi_madt_generic_distributor *)header;
+
+	if (BAD_MADT_ENTRY(dist, end))
+		return -EINVAL;
+
+	gic_version = dist->gic_version;
+	dist_phy_base = dist->base_address;
+
+	return 0;
+}
+
+static int gic_match_redist(struct acpi_subtable_header *header,
+			    const unsigned long end)
+{
+	return 0;
+}
+
+static bool gic_redist_is_present(void)
+{
+	int count;
+
+	/* scan MADT table to find if we have redistributor entries */
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_REDISTRIBUTOR,
+				      gic_match_redist, 0);
+
+	return (count > 0) ? true : false;
+}
+
 static int kvm_vgic_acpi_probe(void)
 {
-	return -EINVAL;
+	u32 reg;
+	int count;
+	void __iomem *dist_base;
+	int ret;
+
+	/* MADT table */
+	ret = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
+			(acpi_tbl_entry_handler)gic_get_acpi_header, 0);
+	if (!ret) {
+		pr_err("Failed to get MADT VGIC CPU entry\n");
+		return -ENODEV;
+	}
+
+	/* detect GIC version */
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
+				      gic_parse_distributor, 0);
+	if (count <= 0) {
+		pr_err("No valid GIC distributor entry exists\n");
+		return -ENODEV;
+	}
+	if (gic_version >= ACPI_MADT_GIC_VER_RESERVED) {
+		pr_err("Invalid GIC version %d in MADT\n", gic_version);
+		return -EINVAL;
+	}
+
+	/* falls back to manual hardware discovery under ACPI 5.1 */
+	if (gic_version == ACPI_MADT_GIC_VER_UNKNOWN) {
+		if (gic_redist_is_present()) {
+			dist_base = ioremap(dist_phy_base, SZ_64K);
+			if (!dist_base)
+				return -ENOMEM;
+
+			reg = readl_relaxed(dist_base + GICD_PIDR2) & GIC_PIDR2_ARCH_MASK;
+			if (reg == GIC_PIDR2_ARCH_GICv3)
+				gic_version = ACPI_MADT_GIC_VER_V3;
+			else
+				gic_version = ACPI_MADT_GIC_VER_V4;
+
+			iounmap(dist_base);
+		} else {
+			gic_version = ACPI_MADT_GIC_VER_V2;
+		}
+	}
+
+	switch (gic_version) {
+	case ACPI_MADT_GIC_VER_V2:
+		ret = vgic_v2_acpi_probe(vgic_acpi, &vgic_ops, &vgic);
+		break;
+	case ACPI_MADT_GIC_VER_V3:
+		ret = vgic_v3_acpi_probe(vgic_acpi, &vgic_ops, &vgic);
+		break;
+	default:
+		ret = -ENODEV;
+	}
+
+	return ret;
 }
 #endif /* CONFIG_ACPI */
 
-- 
1.8.3.1
