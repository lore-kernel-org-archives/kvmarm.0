From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 47/55] KVM: arm/arm64: vgic-new: Add userland GIC CPU
 interface access
Date: Fri,  6 May 2016 11:46:00 +0100
Message-ID: <1462531568-9799-48-git-send-email-andre.przywara@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D2D4F49CCC
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:44:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5MM-XJ+RN3SM for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2016 06:44:10 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C80B849BDA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:44:10 -0400 (EDT)
In-Reply-To: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Using the VMCR accessors we provide access to GIC CPU interface state
to userland by wiring it up to the existing userland interface.
[Marc: move and make VMCR accessors static, streamline MMIO handlers]

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
Changelog v2 .. v3:
- total rework, moving into vgic-mmio-v2.c
- move vmcr accessor wrapper functions into this file
- use the register description table for CPU i/f registers as well
- add RAZ/WI handling for the active priority registers
- streamline MMIO handler functions

 virt/kvm/arm/vgic/vgic-kvm-device.c |   2 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c    | 104 ++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic.h            |   2 +
 3 files changed, 107 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index bb33af8..2122ff2 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -300,7 +300,7 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		ret = -EINVAL;
+		ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, reg);
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 		ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, reg);
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index c453e6f..0060539 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -206,6 +206,84 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
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
+	return extract_bytes(val, addr & 3, len);
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
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12),
@@ -237,6 +315,21 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		vgic_mmio_read_sgipend, vgic_mmio_write_sgipends, 16),
 };
 
+static const struct vgic_register_region vgic_v2_cpu_registers[] = {
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_CTRL,
+		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4),
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_PRIMASK,
+		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4),
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_BINPOINT,
+		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4),
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_ALIAS_BINPOINT,
+		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4),
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_ACTIVEPRIO,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 16),
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_IDENT,
+		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4),
+};
+
 unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev)
 {
 	dev->regions = vgic_v2_dist_registers;
@@ -306,6 +399,17 @@ static int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
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
index 5260d23..7a69955 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -39,6 +39,8 @@ void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
+int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+			  int offset, u32 *val);
 void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
-- 
2.7.3
