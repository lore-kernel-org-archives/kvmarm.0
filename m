From: Wei Huang <wei@redhat.com>
Subject: [PATCH V1 4/5] kvm: arm64: Implement ACPI probing code for GICv2
Date: Thu, 28 May 2015 01:34:33 -0400
Message-ID: <1432791274-15242-5-git-send-email-wei@redhat.com>
References: <1432791274-15242-1-git-send-email-wei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87398521D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2015 01:24:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4Cnw1J-n7Bk3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 May 2015 01:24:55 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AAD2252294
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 May 2015 01:24:55 -0400 (EDT)
In-Reply-To: <1432791274-15242-1-git-send-email-wei@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, hanjun.guo@linaro.org, a.spyridakis@virtualopensystems.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This patches enables ACPI support for KVM virtual GICv2. KVM parses
ACPI table for virt GIC related information and initializes resources.

Signed-off-by: Alexander Spyridaki <a.spyridakis@virtualopensystems.com>
Signed-off-by: Wei Huang <wei@redhat.com>
---
 virt/kvm/arm/vgic-v2.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
index 711de82..01ce8a3 100644
--- a/virt/kvm/arm/vgic-v2.c
+++ b/virt/kvm/arm/vgic-v2.c
@@ -264,6 +264,53 @@ int vgic_v2_acpi_probe(struct acpi_madt_generic_interrupt *vgic_acpi,
 		       const struct vgic_ops **ops,
 		       const struct vgic_params **params)
 {
-	return -EINVAL;
+	struct vgic_params *vgic = &vgic_v2_params;
+	int irq_mode, ret;
+
+	/* IRQ trigger mode */
+	irq_mode = (vgic_acpi->flags & ACPI_MADT_VGIC_IRQ_MODE) ?
+		ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
+	vgic->maint_irq = acpi_register_gsi(NULL, vgic_acpi->vgic_interrupt,
+					    irq_mode, ACPI_ACTIVE_HIGH);
+	if (!vgic->maint_irq) {
+		kvm_err("Cannot register VGIC ACPI maintenance irq\n");
+		ret = -ENXIO;
+		goto out;
+	}
+
+	/* GICH resource */
+	vgic->vctrl_base = ioremap(vgic_acpi->gich_base_address, SZ_8K);
+	if (!vgic->vctrl_base) {
+		kvm_err("cannot ioremap GICH memory\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	vgic->nr_lr = readl_relaxed(vgic->vctrl_base + GICH_VTR);
+	vgic->nr_lr = (vgic->nr_lr & 0x3f) + 1;
+
+	ret = create_hyp_io_mappings(vgic->vctrl_base,
+				     vgic->vctrl_base + SZ_8K,
+				     vgic_acpi->gich_base_address);
+	if (ret) {
+		kvm_err("Cannot map GICH into hyp\n");
+		goto out;
+	}
+
+	vgic->vcpu_base = vgic_acpi->gicv_base_address;
+	vgic->can_emulate_gicv2 = true;
+	kvm_register_device_ops(&kvm_arm_vgic_v2_ops, KVM_DEV_TYPE_ARM_VGIC_V2);
+
+	kvm_info("GICH base=0x%llx, GICV base=0x%llx, IRQ=%d\n",
+		 (unsigned long long)vgic_acpi->gich_base_address,
+		 (unsigned long long)vgic_acpi->gicv_base_address,
+		 vgic->maint_irq);
+
+	vgic->type = VGIC_V2;
+	*ops = &vgic_v2_ops;
+	*params = vgic;
+
+out:
+	return ret;
 }
 #endif /* CONFIG_ACPI */
-- 
1.8.3.1
