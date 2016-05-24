From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 25/59] KVM: arm/arm64: vgic-new: Add GICv2 MMIO handling
 framework
Date: Tue, 24 May 2016 11:09:19 +0200
Message-ID: <1464080993-10884-26-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4369B49B82
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id avOBCppyPeS4 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:06:50 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7010F49B43
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:48 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id n129so118546926wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:10:21 -0700 (PDT)
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

Create vgic-mmio-v2.c to describe GICv2 emulation specific handlers
using the initializer macros provided by the VGIC MMIO framework.
Provide a function to register the GICv2 distributor registers to
the kvm_io_bus framework.
The actual handler functions are still stubs in this patch.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c | 76 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.c    | 26 ++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h    |  2 ++
 virt/kvm/arm/vgic/vgic.h         |  2 ++
 4 files changed, 106 insertions(+)
 create mode 100644 virt/kvm/arm/vgic/vgic-mmio-v2.c

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
new file mode 100644
index 0000000..a3e31a9
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -0,0 +1,76 @@
+/*
+ * VGICv2 MMIO handling functions
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/irqchip/arm-gic.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <kvm/iodev.h>
+#include <kvm/arm_vgic.h>
+
+#include "vgic.h"
+#include "vgic-mmio.h"
+
+static const struct vgic_register_region vgic_v2_dist_registers[] = {
+	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 12,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
+		vgic_mmio_read_rao, vgic_mmio_write_wi, 1,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_CLEAR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 2,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_CLEAR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 16,
+		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
+	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_SET,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 16,
+		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
+};
+
+unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev)
+{
+	dev->regions = vgic_v2_dist_registers;
+	dev->nr_regions = ARRAY_SIZE(vgic_v2_dist_registers);
+
+	kvm_iodevice_init(&dev->dev, &kvm_io_gic_ops);
+
+	return SZ_4K;
+}
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 012b82b..1a97765 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -182,3 +182,29 @@ struct kvm_io_device_ops kvm_io_gic_ops = {
 	.read = dispatch_mmio_read,
 	.write = dispatch_mmio_write,
 };
+
+int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
+			     enum vgic_type type)
+{
+	struct vgic_io_device *io_device = &kvm->arch.vgic.dist_iodev;
+	int ret = 0;
+	unsigned int len;
+
+	switch (type) {
+	case VGIC_V2:
+		len = vgic_v2_init_dist_iodev(io_device);
+		break;
+	default:
+		BUG_ON(1);
+	}
+
+	io_device->base_addr = dist_base_address;
+	io_device->redist_vcpu = NULL;
+
+	mutex_lock(&kvm->slots_lock);
+	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, dist_base_address,
+				      len, &io_device->dev);
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 3023ecf..5b928d4 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -96,4 +96,6 @@ unsigned long vgic_mmio_read_rao(struct kvm_vcpu *vcpu,
 void vgic_mmio_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
 			unsigned int len, unsigned long val);
 
+unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
+
 #endif
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 81b1a20..fd9acaa 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -27,6 +27,8 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
+int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
+			     enum vgic_type);
 
 #ifdef CONFIG_KVM_ARM_VGIC_V3
 void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu);
-- 
2.1.2.330.g565301e.dirty
