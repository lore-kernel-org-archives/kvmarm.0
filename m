From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 21/55] KVM: arm/arm64: vgic-new: Add MMIO handling framework
Date: Fri,  6 May 2016 11:45:34 +0100
Message-ID: <1462531568-9799-22-git-send-email-andre.przywara@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9521E49BF8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:43:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id puBsXAwRP34m for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2016 06:43:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 662C449C13
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:43:31 -0400 (EDT)
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

From: Marc Zyngier <marc.zyngier@arm.com>

Add an MMIO handling framework to the VGIC emulation:
Each register is described by its offset, size (or number of bits per
IRQ, if applicable) and the read/write handler functions. We provide
initialization macros to describe each GIC register later easily.

Separate dispatch functions for read and write accesses are connected
to the kvm_io_bus framework and binary-search for the responsible
register handler based on the offset address within the region.
We convert the incoming data (referenced by a pointer) to the host's
endianess and use pass-by-value to hand the data over to the actual
handler functions.

The register handler prototype and the endianess conversion are
courtesy of Christoffer Dall.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog RFC..v1:
- rework MMIO dispatching to use only one kvm_io_bus device
- document purpose of register region macros
- rename "this" parameter to "dev"
- change IGROUPR to be RAO (returning 1 => Group1 IRQs)

Changelog v1 .. v2:
* MASSIVE rework:
- store register_region pointer in kvm_io_bus linked struct
- replace write_mask_xxx functions with extract_bytes() implementation
- change handler functions' prototypes to take and return unsigned long
- use binary search to find matching register handler
- convert endianess of input data in dispatch_mmio_xxx functions
- improve readability of register initializer macros
- remove any GICv2/GICv3 specific functions from vgic-mmio.c
- rename file from vgic_mmio.c to vgic-mmio.c

Changelog v2 .. v3:
- replace inclusion of vgic/vgic.h with arm_vgic.h

 include/kvm/vgic/vgic.h       |  13 ++++
 virt/kvm/arm/vgic/vgic-mmio.c | 171 ++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h |  77 +++++++++++++++++++
 3 files changed, 261 insertions(+)
 create mode 100644 virt/kvm/arm/vgic/vgic-mmio.c
 create mode 100644 virt/kvm/arm/vgic/vgic-mmio.h

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 2615205..4ec1270 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -106,6 +106,16 @@ struct vgic_irq {
 	enum vgic_irq_config config;	/* Level or edge */
 };
 
+struct vgic_register_region;
+
+struct vgic_io_device {
+	gpa_t base_addr;
+	struct kvm_vcpu *redist_vcpu;
+	const struct vgic_register_region *regions;
+	int nr_regions;
+	struct kvm_io_device dev;
+};
+
 struct vgic_dist {
 	bool			in_kernel;
 	bool			ready;
@@ -132,6 +142,9 @@ struct vgic_dist {
 	bool			enabled;
 
 	struct vgic_irq		*spis;
+
+	struct vgic_io_device	dist_iodev;
+	struct vgic_io_device	*redist_iodevs;
 };
 
 struct vgic_v2_cpu_if {
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
new file mode 100644
index 0000000..f5628cb
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -0,0 +1,171 @@
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
+#include <linux/bitops.h>
+#include <linux/bsearch.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <kvm/iodev.h>
+#include <kvm/arm_vgic.h>
+
+#include "vgic.h"
+#include "vgic-mmio.h"
+
+/* extract @num bytes at @offset bytes offset in data */
+unsigned long extract_bytes(unsigned long data,
+			    unsigned int offset, unsigned int num)
+{
+	return (data >> (offset * 8)) & GENMASK_ULL(num * 8 - 1, 0);
+}
+
+unsigned long vgic_mmio_read_raz(struct kvm_vcpu *vcpu,
+				 gpa_t addr, unsigned int len)
+{
+	return 0;
+}
+
+unsigned long vgic_mmio_read_rao(struct kvm_vcpu *vcpu,
+				 gpa_t addr, unsigned int len)
+{
+	return -1UL;
+}
+
+void vgic_mmio_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
+			unsigned int len, unsigned long val)
+{
+	/* Ignore */
+}
+
+static int match_region(const void *key, const void *elt)
+{
+	const unsigned int offset = (unsigned long)key;
+	const struct vgic_register_region *region = elt;
+
+	if (offset < region->reg_offset)
+		return -1;
+
+	if (offset >= region->reg_offset + region->len)
+		return 1;
+
+	return 0;
+}
+
+/* Find the proper register handler entry given a certain address offset. */
+static const struct vgic_register_region *
+vgic_find_mmio_region(const struct vgic_register_region *region, int nr_regions,
+		      unsigned int offset)
+{
+	return bsearch((void *)(uintptr_t)offset, region, nr_regions,
+		       sizeof(region[0]), match_region);
+}
+
+/*
+ * kvm_mmio_read_buf() returns a value in a format where it can be converted
+ * to a byte array and be directly observed as the guest wanted it to appear
+ * in memory if it had done the store itself, which is LE for the GIC, as the
+ * guest knows the GIC is always LE.
+ *
+ * We convert this value to the CPUs native format to deal with it as a data
+ * value.
+ */
+unsigned long vgic_data_mmio_bus_to_host(const void *val, unsigned int len)
+{
+	unsigned long data = kvm_mmio_read_buf(val, len);
+
+	switch (len) {
+	case 1:
+		return data;
+	case 2:
+		return le16_to_cpu(data);
+	case 4:
+		return le32_to_cpu(data);
+	default:
+		return le64_to_cpu(data);
+	}
+}
+
+/*
+ * kvm_mmio_write_buf() expects a value in a format such that if converted to
+ * a byte array it is observed as the guest would see it if it could perform
+ * the load directly.  Since the GIC is LE, and the guest knows this, the
+ * guest expects a value in little endian format.
+ *
+ * We convert the data value from the CPUs native format to LE so that the
+ * value is returned in the proper format.
+ */
+void vgic_data_host_to_mmio_bus(void *buf, unsigned int len,
+				unsigned long data)
+{
+	switch (len) {
+	case 1:
+		break;
+	case 2:
+		data = cpu_to_le16(data);
+		break;
+	case 4:
+		data = cpu_to_le32(data);
+		break;
+	default:
+		data = cpu_to_le64(data);
+	}
+
+	kvm_mmio_write_buf(buf, len, data);
+}
+
+static
+struct vgic_io_device *kvm_to_vgic_iodev(const struct kvm_io_device *dev)
+{
+	return container_of(dev, struct vgic_io_device, dev);
+}
+
+static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+			      gpa_t addr, int len, void *val)
+{
+	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
+	const struct vgic_register_region *region;
+	struct kvm_vcpu *r_vcpu;
+	unsigned long data;
+
+	region = vgic_find_mmio_region(iodev->regions, iodev->nr_regions,
+				       addr - iodev->base_addr);
+	if (!region)
+		return -EOPNOTSUPP;
+
+	r_vcpu = iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
+	data = region->read(r_vcpu, addr, len);
+	vgic_data_host_to_mmio_bus(val, len, data);
+	return 0;
+}
+
+static int dispatch_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
+			       gpa_t addr, int len, const void *val)
+{
+	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
+	const struct vgic_register_region *region;
+	struct kvm_vcpu *r_vcpu;
+	unsigned long data = vgic_data_mmio_bus_to_host(val, len);
+
+	region = vgic_find_mmio_region(iodev->regions, iodev->nr_regions,
+				       addr - iodev->base_addr);
+	if (!region)
+		return -EOPNOTSUPP;
+
+	r_vcpu = iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
+	region->write(r_vcpu, addr, len, data);
+	return 0;
+}
+
+struct kvm_io_device_ops kvm_io_gic_ops = {
+	.read = dispatch_mmio_read,
+	.write = dispatch_mmio_write,
+};
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
new file mode 100644
index 0000000..18d3869
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -0,0 +1,77 @@
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
+	unsigned int reg_offset;
+	unsigned int len;
+	unsigned int bits_per_irq;
+	unsigned long (*read)(struct kvm_vcpu *vcpu, gpa_t addr,
+			      unsigned int len);
+	void (*write)(struct kvm_vcpu *vcpu, gpa_t addr, unsigned int len,
+		      unsigned long val);
+};
+
+extern struct kvm_io_device_ops kvm_io_gic_ops;
+
+/*
+ * Some VGIC registers store per-IRQ information, with a different number
+ * of bits per IRQ. For those registers this macro is used.
+ * The _WITH_LENGTH version instantiates registers with a fixed length
+ * and is mutually exclusive with the _PER_IRQ version.
+ */
+#define REGISTER_DESC_WITH_BITS_PER_IRQ(off, read_ops, write_ops, bpi)	\
+	{								\
+		.reg_offset = off,					\
+		.bits_per_irq = bpi,					\
+		.len = bpi * 1024 / 8,					\
+		.read = read_ops,					\
+		.write = write_ops,					\
+	}
+
+#define REGISTER_DESC_WITH_LENGTH(off, read_ops, write_ops, length)	\
+	{								\
+		.reg_offset = off,					\
+		.bits_per_irq = 0,					\
+		.len = length,						\
+		.read = read_ops,					\
+		.write = write_ops,					\
+	}
+
+int kvm_vgic_register_mmio_region(struct kvm *kvm, struct kvm_vcpu *vcpu,
+				  struct vgic_register_region *reg_desc,
+				  struct vgic_io_device *region,
+				  int nr_irqs, bool offset_private);
+
+unsigned long vgic_data_mmio_bus_to_host(const void *val, unsigned int len);
+
+void vgic_data_host_to_mmio_bus(void *buf, unsigned int len,
+				unsigned long data);
+
+unsigned long extract_bytes(unsigned long data,
+			    unsigned int offset, unsigned int num);
+
+unsigned long vgic_mmio_read_raz(struct kvm_vcpu *vcpu,
+				 gpa_t addr, unsigned int len);
+
+unsigned long vgic_mmio_read_rao(struct kvm_vcpu *vcpu,
+				 gpa_t addr, unsigned int len);
+
+void vgic_mmio_write_wi(struct kvm_vcpu *vcpu, gpa_t addr,
+			unsigned int len, unsigned long val);
+
+#endif
-- 
2.7.3
