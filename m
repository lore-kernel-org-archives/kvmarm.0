From: Wei Huang <wei@redhat.com>
Subject: [PATCH V1 5/7] KVM: GICv2: Add ACPI probing function
Date: Fri,  5 Feb 2016 12:07:32 -0500
Message-ID: <1454692054-8984-6-git-send-email-wei@redhat.com>
References: <1454692054-8984-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 063624992F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2016 12:02:15 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FdUrTLtpHn12 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  5 Feb 2016 12:02:11 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A5F4498A4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  5 Feb 2016 12:02:10 -0500 (EST)
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

This patch implements ACPI probing for GICv2.

Signed-off-by: Wei Huang <wei@redhat.com>
---
 virt/kvm/arm/vgic-v2.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
index b60e73a..7de2a1f 100644
--- a/virt/kvm/arm/vgic-v2.c
+++ b/virt/kvm/arm/vgic-v2.c
@@ -23,6 +23,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/acpi.h>
 
 #include <linux/irqchip/arm-gic.h>
 
@@ -226,6 +227,71 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_ACPI
+static struct acpi_madt_generic_interrupt *vgic_acpi;
+static void gic_get_acpi_header(struct acpi_subtable_header *header)
+{
+	vgic_acpi = (struct acpi_madt_generic_interrupt *)header;
+}
+
+static struct acpi_madt_generic_distributor *dist_acpi;
+static void gic_get_dist_header(struct acpi_subtable_header *header)
+{
+	dist_acpi = (struct acpi_madt_generic_distributor *)header;
+}
+
+static int vgic_v2_acpi_probe(struct vgic_params *vgic)
+{
+	int irq_mode, ret = 0;
+
+	ret = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
+			(acpi_tbl_entry_handler)gic_get_acpi_header, 0);
+	if (!ret) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	ret = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
+			(acpi_tbl_entry_handler)gic_get_dist_header, 0);
+	if (!ret) {
+		kvm_err("Cannot get distributor entry from ACPI\n");
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (dist_acpi->version >= ACPI_MADT_GIC_VERSION_V3) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	irq_mode = (vgic_acpi->flags & ACPI_MADT_VGIC_IRQ_MODE) ?
+		ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
+	/* According to GIC-400 manual, PPIs are active-LOW, level-sensative.
+	 * We register IRQ as active-low.
+	 */
+	vgic->maint_irq = acpi_register_gsi(NULL, vgic_acpi->vgic_interrupt,
+					    irq_mode, ACPI_ACTIVE_LOW);
+	if (!vgic->maint_irq) {
+		kvm_err("Cannot register vgic maintenance irq from ACPI\n");
+		ret = -ENXIO;
+		goto out;
+	}
+
+	vgic->vctrl_phys_base = vgic_acpi->gich_base_address;
+	vgic->vctrl_size = SZ_8K;
+
+	vgic->vcpu_phys_base = vgic_acpi->gicv_base_address;
+	vgic->vcpu_size = 0; /* unavailable in ACPI, set to 0 */
+out:
+	return ret;
+}
+#else
+static inline int vgic_v2_acpi_probe(struct vgic_params *vgic)
+{
+	return -ENODEV;
+}
+#endif /* CONFIG_ACPI */
+
 /**
  * vgic_v2_probe - probe for a GICv2 compatible interrupt controller
  * @ops:	address of a pointer to the GICv2 operations
@@ -242,6 +308,8 @@ int vgic_v2_probe(const struct vgic_ops **ops,
 	struct vgic_params *vgic = &vgic_v2_params;
 
 	ret = vgic_v2_dt_probe(vgic);
+	if (ret && !acpi_disabled)
+		ret = vgic_v2_acpi_probe(vgic);
 	if (ret)
 		goto err_out;
 
-- 
1.8.3.1
