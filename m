From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 33/56] KVM: arm/arm64: vgic-new: Add GICv3 MMIO handling
 framework
Date: Mon, 16 May 2016 10:54:18 +0100
Message-ID: <1463392481-26583-91-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A04C349BE2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:53:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EXwrSS3+aHQB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2016 05:53:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6976F49C79
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:53:21 -0400 (EDT)
In-Reply-To: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
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

Create a new file called vgic-mmio-v3.c and describe the GICv3
distributor and redistributor registers there.
This adds a special macro to deal with the split of SGI/PPI in the
redistributor and SPIs in the distributor, which allows us to reuse
the existing GICv2 handlers for those registers which are compatible.
Also we provide a function to deal with the registration of the two
separate redistributor frames per VCPU.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
---
Changelog RFC..v1:
- adapt to new MMIO registration approach:
  register one device for the distributor and two for each VCPU
- implement special handling for private interrupts
- remove empty stub functions
- make IGROUPR return RAO

Changelog v1 .. v2:
- adapt to new framework, introduce vgic-mmio-v3.c
- remove userland register access functions (for now)
- precompute .len when describing a VGIC register
- add missed pointer incrementation on registering redist regions
- replace _nyi stub functions with raz/wi versions

Changelog v2 .. v3:
- replace inclusion of kvm/vgic/vgic.h with kvm/arm_vgic.h
- add prototype and stub code for vgic_register_redist_iodevs
- rename register struct variables _rdbase_ and _sgibase_

Changelog v3 .. v4:
- specify accessor width

 virt/kvm/arm/vgic/vgic-mmio-v3.c | 224 +++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.c    |   5 +
 virt/kvm/arm/vgic/vgic-mmio.h    |   2 +
 virt/kvm/arm/vgic/vgic.h         |   7 ++
 4 files changed, 238 insertions(+)
 create mode 100644 virt/kvm/arm/vgic/vgic-mmio-v3.c

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
new file mode 100644
index 0000000..31f1a13
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -0,0 +1,224 @@
+/*
+ * VGICv3 MMIO handling functions
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
+#include <linux/irqchip/arm-gic-v3.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <kvm/iodev.h>
+#include <kvm/arm_vgic.h>
+
+#include <asm/kvm_emulate.h>
+
+#include "vgic.h"
+#include "vgic-mmio.h"
+
+/*
+ * The GICv3 per-IRQ registers are split to control PPIs and SGIs in the
+ * redistributors, while SPIs are covered by registers in the distributor
+ * block. Trying to set private IRQs in this block gets ignored.
+ * We take some special care here to fix the calculation of the register
+ * offset.
+ */
+#define REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(off, rd, wr, bpi, acc)	\
+	{								\
+		.reg_offset = off,					\
+		.bits_per_irq = bpi,					\
+		.len = (bpi * VGIC_NR_PRIVATE_IRQS) / 8,		\
+		.access_flags = acc,					\
+		.read = vgic_mmio_read_raz,				\
+		.write = vgic_mmio_write_wi,				\
+	}, {								\
+		.reg_offset = off + (bpi * VGIC_NR_PRIVATE_IRQS) / 8,	\
+		.bits_per_irq = bpi,					\
+		.len = (bpi * (1024 - VGIC_NR_PRIVATE_IRQS)) / 8,	\
+		.access_flags = acc,					\
+		.read = rd,						\
+		.write = wr,						\
+	}
+
+static const struct vgic_register_region vgic_v3_dist_registers[] = {
+	REGISTER_DESC_WITH_LENGTH(GICD_CTLR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 16,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR,
+		vgic_mmio_read_rao, vgic_mmio_write_wi, 1,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISENABLER,
+		vgic_mmio_read_enable, vgic_mmio_write_senable, 1,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICENABLER,
+		vgic_mmio_read_enable, vgic_mmio_write_cenable, 1,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISPENDR,
+		vgic_mmio_read_pending, vgic_mmio_write_spending, 1,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICPENDR,
+		vgic_mmio_read_pending, vgic_mmio_write_cpending, 1,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
+		vgic_mmio_read_active, vgic_mmio_write_sactive, 1,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICACTIVER,
+		vgic_mmio_read_active, vgic_mmio_write_cactive, 1,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IPRIORITYR,
+		vgic_mmio_read_priority, vgic_mmio_write_priority, 8,
+		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ITARGETSR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICFGR,
+		vgic_mmio_read_config, vgic_mmio_write_config, 2,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGRPMODR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IROUTER,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 64,
+		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICD_IDREGS,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 48,
+		VGIC_ACCESS_32bit),
+};
+
+static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
+	REGISTER_DESC_WITH_LENGTH(GICR_CTLR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_TYPER,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_PROPBASER,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_PENDBASER,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_IDREGS,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 48,
+		VGIC_ACCESS_32bit),
+};
+
+static const struct vgic_register_region vgic_v3_sgibase_registers[] = {
+	REGISTER_DESC_WITH_LENGTH(GICR_IGROUPR0,
+		vgic_mmio_read_rao, vgic_mmio_write_wi, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_ISENABLER0,
+		vgic_mmio_read_enable, vgic_mmio_write_senable, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_ICENABLER0,
+		vgic_mmio_read_enable, vgic_mmio_write_cenable, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_ISPENDR0,
+		vgic_mmio_read_pending, vgic_mmio_write_spending, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_ICPENDR0,
+		vgic_mmio_read_pending, vgic_mmio_write_cpending, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_ISACTIVER0,
+		vgic_mmio_read_active, vgic_mmio_write_sactive, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_ICACTIVER0,
+		vgic_mmio_read_active, vgic_mmio_write_cactive, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_IPRIORITYR0,
+		vgic_mmio_read_priority, vgic_mmio_write_priority, 32,
+		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_ICFGR0,
+		vgic_mmio_read_config, vgic_mmio_write_config, 8,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_IGRPMODR0,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GICR_NSACR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
+		VGIC_ACCESS_32bit),
+};
+
+unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev)
+{
+	dev->regions = vgic_v3_dist_registers;
+	dev->nr_regions = ARRAY_SIZE(vgic_v3_dist_registers);
+
+	kvm_iodevice_init(&dev->dev, &kvm_io_gic_ops);
+
+	return SZ_64K;
+}
+
+int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t redist_base_address)
+{
+	int nr_vcpus = atomic_read(&kvm->online_vcpus);
+	struct kvm_vcpu *vcpu;
+	struct vgic_io_device *devices;
+	int c, ret = 0;
+
+	devices = kmalloc(sizeof(struct vgic_io_device) * nr_vcpus * 2,
+			  GFP_KERNEL);
+	if (!devices)
+		return -ENOMEM;
+
+	kvm_for_each_vcpu(c, vcpu, kvm) {
+		gpa_t rd_base = redist_base_address + c * SZ_64K * 2;
+		gpa_t sgi_base = rd_base + SZ_64K;
+		struct vgic_io_device *rd_dev = &devices[c * 2];
+		struct vgic_io_device *sgi_dev = &devices[c * 2 + 1];
+
+		kvm_iodevice_init(&rd_dev->dev, &kvm_io_gic_ops);
+		rd_dev->base_addr = rd_base;
+		rd_dev->regions = vgic_v3_rdbase_registers;
+		rd_dev->nr_regions = ARRAY_SIZE(vgic_v3_rdbase_registers);
+		rd_dev->redist_vcpu = vcpu;
+
+		mutex_lock(&kvm->slots_lock);
+		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, rd_base,
+					      SZ_64K, &rd_dev->dev);
+		mutex_unlock(&kvm->slots_lock);
+
+		if (ret)
+			break;
+
+		kvm_iodevice_init(&sgi_dev->dev, &kvm_io_gic_ops);
+		sgi_dev->base_addr = sgi_base;
+		sgi_dev->regions = vgic_v3_sgibase_registers;
+		sgi_dev->nr_regions = ARRAY_SIZE(vgic_v3_sgibase_registers);
+		sgi_dev->redist_vcpu = vcpu;
+
+		mutex_lock(&kvm->slots_lock);
+		ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, sgi_base,
+					      SZ_64K, &sgi_dev->dev);
+		mutex_unlock(&kvm->slots_lock);
+		if (ret) {
+			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
+						  &devices[c * 2].dev);
+			break;
+		}
+	}
+
+	if (ret) {
+		/* The current c failed, so we start with the previous one. */
+		for (c--; c >= 0; c--) {
+			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
+						  &devices[c * 2].dev);
+			kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
+						  &devices[c * 2 + 1].dev);
+		}
+		kfree(devices);
+	} else {
+		kvm->arch.vgic.redist_iodevs = devices;
+	}
+
+	return ret;
+}
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 5fe6896..35f49f4 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -478,6 +478,11 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 	case VGIC_V2:
 		len = vgic_v2_init_dist_iodev(io_device);
 		break;
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+	case VGIC_V3:
+		len = vgic_v3_init_dist_iodev(io_device);
+		break;
+#endif
 	default:
 		BUG_ON(1);
 	}
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 0bd0ece..a59f95d 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -133,4 +133,6 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
 
 unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
 
+unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
+
 #endif
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index e57f8d5..6742b11 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -42,6 +42,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
+int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -63,6 +64,12 @@ static inline void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
 static inline void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
 {
 }
+
+static inline int vgic_register_redist_iodevs(struct kvm *kvm,
+					      gpa_t dist_base_address)
+{
+	return -ENODEV;
+}
 #endif
 
 #endif
-- 
2.8.2
