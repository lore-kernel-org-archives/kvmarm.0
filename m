From: Wei Huang <wei@redhat.com>
Subject: [PATCH V1 5/5] kvm: arm64: Implement ACPI probing code for GICv3
Date: Thu, 28 May 2015 01:34:34 -0400
Message-ID: <1432791274-15242-6-git-send-email-wei@redhat.com>
References: <1432791274-15242-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1432791274-15242-1-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, hanjun.guo@linaro.org, a.spyridakis@virtualopensystems.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This patches enables ACPI support for KVM virtual GICv3. KVM parses
ACPI table for virt GIC related information and initializes resources.

Signed-off-by: Wei Huang <wei@redhat.com>
---
 virt/kvm/arm/vgic-v3.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index 99d0f9f..2e4df78 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -292,6 +292,44 @@ int vgic_v3_acpi_probe(struct acpi_madt_generic_interrupt *vgic_acpi,
 		       const struct vgic_ops **ops,
 		       const struct vgic_params **params)
 {
-	return -EINVAL;
+	int ret = 0;
+	struct vgic_params *vgic = &vgic_v3_params;
+	int irq_mode;
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
+	ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
+	vgic->nr_lr = (ich_vtr_el2 & 0xf) + 1;
+	vgic->can_emulate_gicv2 = false;
+
+	vgic->vcpu_base = vgic_acpi->gicv_base_address;
+
+	if (vgic->vcpu_base == 0)
+		kvm_info("disabling GICv2 emulation\n");
+	else {
+		vgic->can_emulate_gicv2 = true;
+		kvm_register_device_ops(&kvm_arm_vgic_v2_ops,
+					KVM_DEV_TYPE_ARM_VGIC_V2);
+	}
+
+	kvm_register_device_ops(&kvm_arm_vgic_v3_ops, KVM_DEV_TYPE_ARM_VGIC_V3);
+
+	vgic->vctrl_base = NULL;
+	vgic->type = VGIC_V3;
+	vgic->max_gic_vcpus = KVM_MAX_VCPUS;
+
+	*ops = &vgic_v3_ops;
+	*params = vgic;
+out:
+	return ret;
 }
 #endif /* CONFIG_ACPI */
-- 
1.8.3.1

