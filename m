From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 49/57] KVM: arm/arm64: vgic-new: Add userland GIC CPU interface access
Date: Thu, 19 May 2016 19:08:28 +0100
Message-ID: <1463681316-23039-50-git-send-email-andre.przywara@arm.com>
References: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

To allow userland access to the GIC CPU interface state, we use handler
functions similar to what we use for the distributor and connect those
to the VMCR accessors on one side and our userland access framework on
the other side.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Changelog v2 .. v3:
- total rework, moving into vgic-mmio-v2.c
- move vmcr accessor wrapper functions into this file
- use the register description table for CPU i/f registers as well
- add RAZ/WI handling for the active priority registers
- streamline MMIO handler functions

Changelog v3 .. v4:
- advertise CPU interface registers to userland
- specify accessor width
- replace call to extract_bytes() with a simple return

 virt/kvm/arm/vgic/vgic-kvm-device.c |   2 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c    | 114 +++++++++++++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic.h            |   2 +
 3 files changed, 116 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 9ee27cb..0130c4b 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -274,7 +274,7 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		ret = -EINVAL;
+		ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, reg);
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 		ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, reg);
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index a255122..a213936 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -204,6 +204,84 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
 	}
 }
 
+static void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
+{
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_set_vmcr(vcpu, vmcr);
+	else
+		vgic_v3_set_vmcr(vcpu, vmcr);
+}
+
+static void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
+{
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_get_vmcr(vcpu, vmcr);
+	else
+		vgic_v3_get_vmcr(vcpu, vmcr);
+}
+
+#define GICC_ARCH_VERSION_V2	0x2
+
+/* These are for userland accesses only, there is no guest-facing emulation. */
+static unsigned long vgic_mmio_read_vcpuif(struct kvm_vcpu *vcpu,
+					   gpa_t addr, unsigned int len)
+{
+	struct vgic_vmcr vmcr;
+	u32 val;
+
+	vgic_get_vmcr(vcpu, &vmcr);
+
+	switch (addr & 0xff) {
+	case GIC_CPU_CTRL:
+		val = vmcr.ctlr;
+		break;
+	case GIC_CPU_PRIMASK:
+		val = vmcr.pmr;
+		break;
+	case GIC_CPU_BINPOINT:
+		val = vmcr.bpr;
+		break;
+	case GIC_CPU_ALIAS_BINPOINT:
+		val = vmcr.abpr;
+		break;
+	case GIC_CPU_IDENT:
+		val = ((PRODUCT_ID_KVM << 20) |
+		       (GICC_ARCH_VERSION_V2 << 16) |
+		       IMPLEMENTER_ARM);
+		break;
+	default:
+		return 0;
+	}
+
+	return val;
+}
+
+static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
+				   gpa_t addr, unsigned int len,
+				   unsigned long val)
+{
+	struct vgic_vmcr vmcr;
+
+	vgic_get_vmcr(vcpu, &vmcr);
+
+	switch (addr & 0xff) {
+	case GIC_CPU_CTRL:
+		vmcr.ctlr = val;
+		break;
+	case GIC_CPU_PRIMASK:
+		vmcr.pmr = val;
+		break;
+	case GIC_CPU_BINPOINT:
+		vmcr.bpr = val;
+		break;
+	case GIC_CPU_ALIAS_BINPOINT:
+		vmcr.abpr = val;
+		break;
+	}
+
+	vgic_set_vmcr(vcpu, &vmcr);
+}
+
 static const struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
@@ -249,6 +327,27 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
 };
 
+static const struct vgic_register_region vgic_v2_cpu_registers[] = {
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_CTRL,
+		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_PRIMASK,
+		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_BINPOINT,
+		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_ALIAS_BINPOINT,
+		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_ACTIVEPRIO,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 16,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_IDENT,
+		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
+		VGIC_ACCESS_32bit),
+};
+
 unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev)
 {
 	dev->regions = vgic_v2_dist_registers;
@@ -274,7 +373,9 @@ int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 		nr_regions = ARRAY_SIZE(vgic_v2_dist_registers);
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		return -ENXIO;		/* TODO: describe CPU i/f regs also */
+		regions = vgic_v2_cpu_registers;
+		nr_regions = ARRAY_SIZE(vgic_v2_cpu_registers);
+		break;
 	default:
 		return -ENXIO;
 	}
@@ -322,6 +423,17 @@ static int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
 	return ret;
 }
 
+int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+			  int offset, u32 *val)
+{
+	struct vgic_io_device dev = {
+		.regions = vgic_v2_cpu_registers,
+		.nr_regions = ARRAY_SIZE(vgic_v2_cpu_registers),
+	};
+
+	return vgic_uaccess(vcpu, &dev, is_write, offset, val);
+}
+
 int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val)
 {
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index d2c1fd5..de9dc71 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -47,6 +47,8 @@ void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
+int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+			  int offset, u32 *val);
 void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
-- 
2.8.2

