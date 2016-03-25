From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 37/45] KVM: arm/arm64: vgic-new: Add userland GIC CPU
 interface access
Date: Fri, 25 Mar 2016 02:05:00 +0000
Message-ID: <1458871508-17279-38-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E578412D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q9EmHskE4SXn for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2016 22:05:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C32B49B7C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:20 -0400 (EDT)
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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
