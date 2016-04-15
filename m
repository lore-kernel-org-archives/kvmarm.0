From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 37/45] KVM: arm/arm64: vgic-new: Add userland GIC CPU interface access
Date: Fri, 15 Apr 2016 18:11:48 +0100
Message-ID: <1460740316-8755-38-git-send-email-andre.przywara@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic_kvm_device.c | 72 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 71 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic_kvm_device.c b/virt/kvm/arm/vgic/vgic_kvm_device.c
index 2e2f8b6..7f78a16 100644
--- a/virt/kvm/arm/vgic/vgic_kvm_device.c
+++ b/virt/kvm/arm/vgic/vgic_kvm_device.c
@@ -17,8 +17,11 @@
 #include <kvm/vgic/vgic.h>
 #include <linux/uaccess.h>
 #include <asm/kvm_mmu.h>
+#include <linux/irqchip/arm-gic.h>
 #include "vgic.h"
 
+#define GICC_ARCH_VERSION_V2		0x2
+
 /* common helpers */
 
 static int vgic_ioaddr_overlap(struct kvm *kvm)
@@ -252,6 +255,69 @@ void kvm_register_vgic_device(unsigned long type)
 	}
 }
 
+static u32 vgic_read_vcpuif(struct kvm_vcpu *vcpu, int offset)
+{
+	struct vgic_vmcr vmcr;
+	u32 *field;
+
+	switch (offset) {
+	case GIC_CPU_CTRL:
+		field = &vmcr.ctlr;
+		break;
+	case GIC_CPU_PRIMASK:
+		field = &vmcr.pmr;
+		break;
+	case GIC_CPU_BINPOINT:
+		field = &vmcr.bpr;
+		break;
+	case GIC_CPU_ALIAS_BINPOINT:
+		field = &vmcr.abpr;
+		break;
+	case GIC_CPU_IDENT:
+		return (PRODUCT_ID_KVM << 20) |
+		       (GICC_ARCH_VERSION_V2 << 16) |
+		       (IMPLEMENTER_ARM << 0);
+	default:
+		return 0;
+	}
+
+	vgic_get_vmcr(vcpu, &vmcr);
+
+	return *field;
+}
+
+static bool vgic_write_vcpuif(struct kvm_vcpu *vcpu, int offset, u32 value)
+{
+	struct vgic_vmcr vmcr;
+	u32 *field;
+
+	switch (offset) {
+	case GIC_CPU_CTRL:
+		field = &vmcr.ctlr;
+		break;
+	case GIC_CPU_PRIMASK:
+		field = &vmcr.pmr;
+		break;
+	case GIC_CPU_BINPOINT:
+		field = &vmcr.bpr;
+		break;
+	case GIC_CPU_ALIAS_BINPOINT:
+		field = &vmcr.abpr;
+		break;
+	default:
+		return false;
+	}
+
+	vgic_get_vmcr(vcpu, &vmcr);
+	if (*field == value)
+		return false;
+
+	*field = value;
+	vgic_set_vmcr(vcpu, &vmcr);
+
+	return true;
+}
+
 /** vgic_attr_regs_access: allows user space to read/write VGIC registers
  *
  * @dev: kvm device handle
@@ -300,7 +366,11 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		ret = -EINVAL;
+		ret = 0;
+		if (is_write)
+			vgic_write_vcpuif(vcpu, addr, *reg);
+		else
+			*reg = vgic_read_vcpuif(vcpu, addr);
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 		ret = vgic_v2_dist_access(vcpu, is_write, addr, 4, reg);
-- 
2.7.3

