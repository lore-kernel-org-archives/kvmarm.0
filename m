From: Wei Huang <wei@redhat.com>
Subject: [PATCH V1 7/7] KVM: GICv3: Add ACPI probing function
Date: Fri,  5 Feb 2016 12:07:34 -0500
Message-ID: <1454692054-8984-8-git-send-email-wei@redhat.com>
References: <1454692054-8984-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1454692054-8984-1-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, christoffer.dall@linaro.org, kvm@vger.kernel.org, hanjun.guo@linaro.org, fu.wei@linaro.org, drjones@redhat.com, wei@redhat.com, al.stone@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch implements ACPI probing for GICv3.

Signed-off-by: Wei Huang <wei@redhat.com>
---
 virt/kvm/arm/vgic-v3.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 62 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index 5eca58a..5bfb9cb 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -23,6 +23,7 @@
 #include <linux/of.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
+#include <linux/acpi.h>
 
 #include <linux/irqchip/arm-gic-v3.h>
 
@@ -260,6 +261,62 @@ out:
 	return ret;
 }
 
+#ifdef CONFIG_ACPI
+static struct acpi_madt_generic_interrupt *vgic_acpi;
+static void gic_v3_get_acpi_header(struct acpi_subtable_header *header)
+{
+	vgic_acpi = (struct acpi_madt_generic_interrupt *)header;
+}
+
+static struct acpi_madt_generic_distributor *dist_acpi;
+static void gic_v3_get_dist_header(struct acpi_subtable_header *header)
+{
+	dist_acpi = (struct acpi_madt_generic_distributor *)header;
+}
+
+static int vgic_v3_acpi_probe(struct vgic_params *vgic)
+{
+	int irq_mode;
+	int count = 0;
+	int ret = 0;
+
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
+			(acpi_tbl_entry_handler)gic_v3_get_acpi_header, 0);
+	if (!count) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
+			(acpi_tbl_entry_handler)gic_v3_get_dist_header, 0);
+	if (!count || (dist_acpi->version != ACPI_MADT_GIC_VERSION_V3)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	/* IRQ trigger mode */
+	irq_mode = (vgic_acpi->flags & ACPI_MADT_VGIC_IRQ_MODE) ?
+		ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
+	vgic->maint_irq = acpi_register_gsi(NULL, vgic_acpi->vgic_interrupt,
+					    irq_mode, ACPI_ACTIVE_LOW);
+	if (!vgic->maint_irq) {
+		kvm_err("failed to get vgic maintenance irq from ACPI\n");
+		ret = -ENXIO;
+		goto out;
+	}
+
+	vgic->vcpu_phys_base = vgic_acpi->gicv_base_address;
+	vgic->vcpu_size = SZ_8K;
+out:
+	return ret;
+}
+#else
+static inline int vgic_v3_acpi_probe(struct vgic_params *vgic)
+{
+	return -ENODEV;
+}
+#endif /* CONFIG_ACPI */
+
 /**
  * vgic_v3_probe - probe for a GICv3 compatible interrupt controller
  * @ops:	address of a pointer to the GICv3 operations
@@ -277,8 +334,11 @@ int vgic_v3_probe(const struct vgic_ops **ops,
 
 	/* DT probing first, then try ACPI probing */
 	ret = vgic_v3_dt_probe(vgic);
-	if (ret)
-		goto out;
+	if (ret && !acpi_disabled) {
+		ret = vgic_v3_acpi_probe(vgic);
+		if (ret)
+			goto out;
+	}
 
 	ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
 
-- 
1.8.3.1

