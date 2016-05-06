From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 22/55] KVM: arm/arm64: vgic-new: Add GICv2 MMIO handling framework
Date: Fri,  6 May 2016 11:45:35 +0100
Message-ID: <1462531568-9799-23-git-send-email-andre.przywara@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Create vgic-mmio-v2.c to describe GICv2 emulation specific handlers
using the initializer macros provided by the VGIC MMIO framework.
Provide a function to register the GICv2 distributor registers to
the kvm_io_bus framework.
The actual handler functions are still stubs in this patch.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
Changelog v1 .. v2:
- new patch, split out from the generic MMIO framework patch
- use a separate file to hold GICv2 emulation specific handlers
- replace _nyi stub functions with raz/wi versions

Changelog v2 .. v3:
- replace kvm/vgic/vgic.h with kvm/arm_vgic.h
- add vgic_register_dist_iodev() prototype

 virt/kvm/arm/vgic/vgic-mmio-v2.c | 62 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.c    | 26 +++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h    |  2 ++
 virt/kvm/arm/vgic/vgic.h         |  2 ++
 4 files changed, 92 insertions(+)
 create mode 100644 virt/kvm/arm/vgic/vgic-mmio-v2.c

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
new file mode 100644
index 0000000..2729a22
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -0,0 +1,62 @@
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
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 12),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
+		vgic_mmio_read_rao, vgic_mmio_write_wi, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_CLEAR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 2),
+	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
+	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_CLEAR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 16),
+	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_SET,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 16),
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
index f5628cb..41cf4f4 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -169,3 +169,29 @@ struct kvm_io_device_ops kvm_io_gic_ops = {
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
index 18d3869..4f4dd2b 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -74,4 +74,6 @@ unsigned long vgic_mmio_read_rao(struct kvm_vcpu *vcpu,
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
2.7.3

