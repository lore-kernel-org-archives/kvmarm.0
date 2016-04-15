From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 12/45] KVM: arm/arm64: vgic-new: Add MMIO handling framework
Date: Fri, 15 Apr 2016 18:11:23 +0100
Message-ID: <1460740316-8755-13-git-send-email-andre.przywara@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F72849C0D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AW6x8M5gIuKR for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2016 13:10:20 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D38BB49C3B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:19 -0400 (EDT)
In-Reply-To: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

We register a kvm_io_bus device for the distributor and dispatch
the calls to the actual register handler at runtime.
Ideally we would register each register group directly with the
kvm_io_bus framework, but currently we run into the limit of 1000
devices pretty quickly (with GICv3), so we use this approach here, at
least for the time being.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Eric Auger <eric.auger@linaro.org>

Changelog RFC..v1:
- rework MMIO dispatching to use only one kvm_io_bus device
- document purpose of register region macros
- rename "this" parameter to "dev"
- change IGROUPR to be RAO (returning 1 => Group1 IRQs)
---
 include/kvm/vgic/vgic.h       |   9 ++
 virt/kvm/arm/vgic/vgic_mmio.c | 226 ++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic_mmio.h |  53 ++++++++++
 3 files changed, 288 insertions(+)
 create mode 100644 virt/kvm/arm/vgic/vgic_mmio.c
 create mode 100644 virt/kvm/arm/vgic/vgic_mmio.h

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 664004f..f331469 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -106,6 +106,12 @@ struct vgic_irq {
 	enum vgic_irq_config config;	/* Level or edge */
 };
 
+struct vgic_io_device {
+	gpa_t base_addr;
+	struct kvm_vcpu *redist_vcpu;
+	struct kvm_io_device dev;
+};
+
 struct vgic_dist {
 	bool			in_kernel;
 	bool			ready;
@@ -132,6 +138,9 @@ struct vgic_dist {
 	u32			enabled;
 
 	struct vgic_irq		*spis;
+
+	struct vgic_io_device	dist_iodev;
+	struct vgic_io_device	*redist_iodevs;
 };
 
 struct vgic_v2_cpu_if {
diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
new file mode 100644
index 0000000..b70a274
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -0,0 +1,226 @@
+/*
+ * VGIC MMIO handling functions
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
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <kvm/iodev.h>
+#include <kvm/vgic/vgic.h>
+#include <linux/bitops.h>
+#include <linux/irqchip/arm-gic.h>
+
+#include "vgic.h"
+#include "vgic_mmio.h"
+
+void write_mask32(u32 value, int offset, int len, void *val)
+{
+	value = cpu_to_le32(value) >> (offset * 8);
+	memcpy(val, &value, len);
+}
+
+u32 mask32(u32 origvalue, int offset, int len, const void *val)
+{
+	origvalue &= ~((BIT_ULL(len) - 1) << (offset * 8));
+	memcpy((char *)&origvalue + (offset * 8), val, len);
+	return origvalue;
+}
+
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+void write_mask64(u64 value, int offset, int len, void *val)
+{
+	value = cpu_to_le64(value) >> (offset * 8);
+	memcpy(val, &value, len);
+}
+
+/* FIXME: I am clearly misguided here, there must be some saner way ... */
+u64 mask64(u64 origvalue, int offset, int len, const void *val)
+{
+	origvalue &= ~((BIT_ULL(len) - 1) << (offset * 8));
+	memcpy((char *)&origvalue + (offset * 8), val, len);
+	return origvalue;
+}
+#endif
+
+int vgic_mmio_read_raz(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+		       gpa_t addr, int len, void *val)
+{
+	memset(val, 0, len);
+
+	return 0;
+}
+
+int vgic_mmio_read_rao(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+		       gpa_t addr, int len, void *val)
+{
+	memset(val, 0xff, len);
+
+	return 0;
+}
+
+int vgic_mmio_write_wi(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+		       gpa_t addr, int len, const void *val)
+{
+	return 0;
+}
+
+static int vgic_mmio_read_nyi(struct kvm_vcpu *vcpu,
+			      struct kvm_io_device *dev,
+			      gpa_t addr, int len, void *val)
+{
+	pr_warn("KVM: handling unimplemented VGIC MMIO read: VCPU %d, address: 0x%llx\n",
+		vcpu->vcpu_id, (unsigned long long)addr);
+	return 0;
+}
+
+static int vgic_mmio_write_nyi(struct kvm_vcpu *vcpu,
+			       struct kvm_io_device *dev,
+			       gpa_t addr, int len, const void *val)
+{
+	pr_warn("KVM: handling unimplemented VGIC MMIO write: VCPU %d, address: 0x%llx\n",
+		vcpu->vcpu_id, (unsigned long long)addr);
+	return 0;
+}
+
+struct vgic_register_region vgic_v2_dist_registers[] = {
+	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
+		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 12),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
+		vgic_mmio_read_rao, vgic_mmio_write_wi, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
+		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_CLEAR,
+		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
+		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
+		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
+		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
+		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
+		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 8),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
+		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 8),
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
+		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 8),
+	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
+		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 4),
+	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_CLEAR,
+		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 16),
+	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_SET,
+		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 16),
+};
+
+/* Find the proper register handler entry given a certain address offset. */
+static struct vgic_register_region *
+vgic_find_mmio_region(struct vgic_register_region *region, int nr_regions,
+		      int offset)
+{
+	int i;
+
+	for (i = 0; i < nr_regions; i++) {
+		int reg_size = region[i].len;
+
+		if (!reg_size)
+			reg_size = (region[i].bits_per_irq * 1024) / 8;
+
+		if ((offset < region[i].reg_offset) ||
+		    (offset >= region[i].reg_offset + reg_size))
+			continue;
+
+		return region + i;
+	}
+
+	return NULL;
+}
+
+static int dispatch_mmio_read(struct kvm_vcpu *vcpu,
+			      struct vgic_register_region *regions,
+			      int nr_regions, struct kvm_io_device *dev,
+			      gpa_t addr, int len, void *val)
+{
+	struct vgic_io_device *iodev = container_of(dev,
+						    struct vgic_io_device, dev);
+	struct vgic_register_region *region;
+
+	region = vgic_find_mmio_region(regions, nr_regions,
+				       addr - iodev->base_addr);
+	if (!region)
+		return -EOPNOTSUPP;
+
+	return region->ops.read(vcpu, dev, addr, len, val);
+}
+
+static int dispatch_mmio_write(struct kvm_vcpu *vcpu,
+			       struct vgic_register_region *regions,
+			       int nr_regions, struct kvm_io_device *dev,
+			       gpa_t addr, int len, const void *val)
+{
+	struct vgic_io_device *iodev = container_of(dev,
+						    struct vgic_io_device, dev);
+	struct vgic_register_region *region;
+
+	region = vgic_find_mmio_region(regions, nr_regions,
+				       addr - iodev->base_addr);
+	if (!region)
+		return -EOPNOTSUPP;
+
+	return region->ops.write(vcpu, dev, addr, len, val);
+}
+
+int vgic_mmio_read_v2dist(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+			  gpa_t addr, int len, void *val)
+{
+	return dispatch_mmio_read(vcpu, vgic_v2_dist_registers,
+				  ARRAY_SIZE(vgic_v2_dist_registers), dev,
+				  addr, len, val);
+}
+
+int vgic_mmio_write_v2dist(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+			   gpa_t addr, int len, const void *val)
+{
+	return dispatch_mmio_write(vcpu, vgic_v2_dist_registers,
+				   ARRAY_SIZE(vgic_v2_dist_registers), dev,
+				   addr, len, val);
+}
+
+struct kvm_io_device_ops kvm_io_v2dist_ops = {
+	.read = vgic_mmio_read_v2dist,
+	.write = vgic_mmio_write_v2dist,
+};
+
+int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
+			     enum vgic_type type)
+{
+	struct vgic_io_device *io_device = &kvm->arch.vgic.dist_iodev;
+	int ret = 0;
+	int len;
+
+	switch (type) {
+	case VGIC_V2:
+		kvm_iodevice_init(&io_device->dev, &kvm_io_v2dist_ops);
+		len = SZ_4K;
+		break;
+	default:
+		BUG_ON(1);
+	}
+
+	io_device->base_addr = dist_base_address;
+
+	mutex_lock(&kvm->slots_lock);
+	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, dist_base_address,
+				      len, &io_device->dev);
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
diff --git a/virt/kvm/arm/vgic/vgic_mmio.h b/virt/kvm/arm/vgic/vgic_mmio.h
new file mode 100644
index 0000000..9b17e1b
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic_mmio.h
@@ -0,0 +1,53 @@
+/*
+ * Copyright (C) 2015, 2016 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __KVM_ARM_VGIC_MMIO_H__
+#define __KVM_ARM_VGIC_MMIO_H__
+
+struct vgic_register_region {
+	int reg_offset;
+	int len;
+	int bits_per_irq;
+	struct kvm_io_device_ops ops;
+};
+
+/*
+ * Some VGIC registers store per-IRQ information, with a different number
+ * of bits per IRQ. For those registers this macro is used.
+ * The _WITH_LENGTH version instantiates registers with a fixed length
+ * and is mutually exclusive with the _PER_IRQ version.
+ */
+#define REGISTER_DESC_WITH_BITS_PER_IRQ(name, read_ops, write_ops, bpi) \
+	{.reg_offset = name, .bits_per_irq = bpi, .len = 0, \
+	 .ops.read = read_ops, .ops.write = write_ops}
+#define REGISTER_DESC_WITH_LENGTH(name, read_ops, write_ops, length) \
+	{.reg_offset = name, .bits_per_irq = 0, .len = length, \
+	 .ops.read = read_ops, .ops.write = write_ops}
+
+int vgic_mmio_read_raz(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
+		       gpa_t addr, int len, void *val);
+int vgic_mmio_write_wi(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
+		       gpa_t addr, int len, const void *val);
+int kvm_vgic_register_mmio_region(struct kvm *kvm, struct kvm_vcpu *vcpu,
+				  struct vgic_register_region *reg_desc,
+				  struct vgic_io_device *region,
+				  int nr_irqs, bool offset_private);
+
+void write_mask32(u32 value, int offset, int len, void *val);
+void write_mask64(u64 value, int offset, int len, void *val);
+u32 mask32(u32 origvalue, int offset, int len, const void *val);
+u64 mask64(u64 origvalue, int offset, int len, const void *val);
+
+#endif
-- 
2.7.3
