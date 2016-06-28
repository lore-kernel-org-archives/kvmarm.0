From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v7 09/17] KVM: arm64: introduce ITS emulation file with MMIO
 framework
Date: Tue, 28 Jun 2016 13:32:22 +0100
Message-ID: <20160628123230.26255-10-andre.przywara@arm.com>
References: <20160628123230.26255-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C396449B7A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 08:26:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QfQetuNc3sJl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jun 2016 08:26:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41AB949B63
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 08:26:55 -0400 (EDT)
In-Reply-To: <20160628123230.26255-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The ARM GICv3 ITS emulation code goes into a separate file, but needs
to be connected to the GICv3 emulation, of which it is an option.
The ITS MMIO handlers require the respective ITS pointer to be passed in,
so we amend the existing VGIC MMIO framework to let it cope with that.
Also we introduce the basic ITS data structure and initialize it, but
don't return any success yet, as we are not yet ready for the show.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm64/kvm/Makefile          |   1 +
 include/kvm/vgic/vgic.h          |  14 +++++-
 virt/kvm/arm/vgic/vgic-its.c     | 100 +++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  40 +++++++--------
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 104 ++++++++++++++++++++++++++-------------
 virt/kvm/arm/vgic/vgic-mmio.c    |  36 +++++++++++---
 virt/kvm/arm/vgic/vgic-mmio.h    |  31 +++++++++---
 virt/kvm/arm/vgic/vgic.h         |   7 +++
 8 files changed, 266 insertions(+), 67 deletions(-)
 create mode 100644 virt/kvm/arm/vgic/vgic-its.c

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index a7a958c..2755d17 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -30,6 +30,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v2.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
 else
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2.o
diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index c56331c..949a0e1 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -108,15 +108,27 @@ struct vgic_irq {
 };
 
 struct vgic_register_region;
+struct vgic_its;
 
 struct vgic_io_device {
 	gpa_t base_addr;
-	struct kvm_vcpu *redist_vcpu;
+	union {
+		struct kvm_vcpu *redist_vcpu;
+		struct vgic_its *its;
+	};
 	const struct vgic_register_region *regions;
 	int nr_regions;
 	struct kvm_io_device dev;
 };
 
+struct vgic_its {
+	/* The base address of the ITS control register frame */
+	gpa_t			vgic_its_base;
+
+	bool			enabled;
+	struct vgic_io_device	iodev;
+};
+
 struct vgic_dist {
 	bool			in_kernel;
 	bool			ready;
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
new file mode 100644
index 0000000..ab8d244
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -0,0 +1,100 @@
+/*
+ * GICv3 ITS emulation
+ *
+ * Copyright (C) 2015,2016 ARM Ltd.
+ * Author: Andre Przywara <andre.przywara@arm.com>
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
+
+#include <linux/cpu.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/interrupt.h>
+
+#include <linux/irqchip/arm-gic-v3.h>
+
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_arm.h>
+#include <asm/kvm_mmu.h>
+
+#include "vgic.h"
+#include "vgic-mmio.h"
+
+#define REGISTER_ITS_DESC(off, rd, wr, length, acc)		\
+{								\
+	.reg_offset = off,					\
+	.len = length,						\
+	.access_flags = acc,					\
+	.iodev_type = IODEV_ITS,				\
+	.its_read = rd,						\
+	.its_write = wr,					\
+}
+
+static unsigned long its_mmio_read_raz(struct kvm *kvm, struct vgic_its *its,
+				       gpa_t addr, unsigned int len)
+{
+	return 0;
+}
+
+static void its_mmio_write_wi(struct kvm *kvm, struct vgic_its *its,
+			      gpa_t addr, unsigned int len, unsigned long val)
+{
+	/* Ignore */
+}
+
+static struct vgic_register_region its_registers[] = {
+	REGISTER_ITS_DESC(GITS_CTLR,
+		its_mmio_read_raz, its_mmio_write_wi, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_ITS_DESC(GITS_IIDR,
+		its_mmio_read_raz, its_mmio_write_wi, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_ITS_DESC(GITS_TYPER,
+		its_mmio_read_raz, its_mmio_write_wi, 8,
+		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_ITS_DESC(GITS_CBASER,
+		its_mmio_read_raz, its_mmio_write_wi, 8,
+		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_ITS_DESC(GITS_CWRITER,
+		its_mmio_read_raz, its_mmio_write_wi, 8,
+		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_ITS_DESC(GITS_CREADR,
+		its_mmio_read_raz, its_mmio_write_wi, 8,
+		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_ITS_DESC(GITS_BASER,
+		its_mmio_read_raz, its_mmio_write_wi, 0x40,
+		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_ITS_DESC(GITS_IDREGS_BASE,
+		its_mmio_read_raz, its_mmio_write_wi, 0x30,
+		VGIC_ACCESS_32bit),
+};
+
+int vits_register(struct kvm *kvm, struct vgic_its *its)
+{
+	struct vgic_io_device *iodev = &its->iodev;
+	int ret;
+
+	iodev->regions = its_registers;
+	iodev->nr_regions = ARRAY_SIZE(its_registers);
+	kvm_iodevice_init(&iodev->dev, &kvm_io_gic_ops);
+
+	iodev->base_addr = its->vgic_its_base;
+	iodev->its = its;
+	mutex_lock(&kvm->slots_lock);
+	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, iodev->base_addr,
+				      SZ_64K, &iodev->dev);
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 4152348..bca5bf7 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -291,67 +291,67 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
 }
 
 static const struct vgic_register_region vgic_v2_dist_registers[] = {
-	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
+	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL, IODEV_DIST,
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP, IODEV_DIST,
 		vgic_mmio_read_rao, vgic_mmio_write_wi, 1,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET, IODEV_DIST,
 		vgic_mmio_read_enable, vgic_mmio_write_senable, 1,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_CLEAR,
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_CLEAR, IODEV_DIST,
 		vgic_mmio_read_enable, vgic_mmio_write_cenable, 1,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET, IODEV_DIST,
 		vgic_mmio_read_pending, vgic_mmio_write_spending, 1,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR, IODEV_DIST,
 		vgic_mmio_read_pending, vgic_mmio_write_cpending, 1,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET, IODEV_DIST,
 		vgic_mmio_read_active, vgic_mmio_write_sactive, 1,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR, IODEV_DIST,
 		vgic_mmio_read_active, vgic_mmio_write_cactive, 1,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI, IODEV_DIST,
 		vgic_mmio_read_priority, vgic_mmio_write_priority, 8,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET, IODEV_DIST,
 		vgic_mmio_read_target, vgic_mmio_write_target, 8,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
+	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG, IODEV_DIST,
 		vgic_mmio_read_config, vgic_mmio_write_config, 2,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
+	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT, IODEV_DIST,
 		vgic_mmio_read_raz, vgic_mmio_write_sgir, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_CLEAR,
+	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_CLEAR, IODEV_DIST,
 		vgic_mmio_read_sgipend, vgic_mmio_write_sgipendc, 16,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
-	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_SET,
+	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_SET, IODEV_DIST,
 		vgic_mmio_read_sgipend, vgic_mmio_write_sgipends, 16,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
 };
 
 static const struct vgic_register_region vgic_v2_cpu_registers[] = {
-	REGISTER_DESC_WITH_LENGTH(GIC_CPU_CTRL,
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_CTRL, IODEV_CPUIF,
 		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GIC_CPU_PRIMASK,
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_PRIMASK, IODEV_CPUIF,
 		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GIC_CPU_BINPOINT,
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_BINPOINT, IODEV_CPUIF,
 		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GIC_CPU_ALIAS_BINPOINT,
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_ALIAS_BINPOINT, IODEV_CPUIF,
 		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GIC_CPU_ACTIVEPRIO,
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_ACTIVEPRIO, IODEV_CPUIF,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 16,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GIC_CPU_IDENT,
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_IDENT, IODEV_CPUIF,
 		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4,
 		VGIC_ACCESS_32bit),
 };
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 7268c61..5fcc33a 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -42,6 +42,16 @@ static u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
 	return reg | ((u64)val << lower);
 }
 
+bool vgic_has_its(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+
+	if (dist->vgic_model != KVM_DEV_TYPE_ARM_VGIC_V3)
+		return false;
+
+	return false;
+}
+
 static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 					    gpa_t addr, unsigned int len)
 {
@@ -130,6 +140,32 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
 	vgic_put_irq(vcpu->kvm, irq);
 }
 
+static unsigned long vgic_mmio_read_v3r_ctlr(struct kvm_vcpu *vcpu,
+					     gpa_t addr, unsigned int len)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+	return vgic_cpu->lpis_enabled ? GICR_CTLR_ENABLE_LPIS : 0;
+}
+
+
+static void vgic_mmio_write_v3r_ctlr(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len,
+				     unsigned long val)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+	bool was_enabled = vgic_cpu->lpis_enabled;
+
+	if (!vgic_has_its(vcpu->kvm))
+		return;
+
+	vgic_cpu->lpis_enabled = val & GICR_CTLR_ENABLE_LPIS;
+
+	if (!was_enabled && vgic_cpu->lpis_enabled) {
+		/* Eventually do something */
+	}
+}
+
 static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
 					      gpa_t addr, unsigned int len)
 {
@@ -296,12 +332,13 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
  * We take some special care here to fix the calculation of the register
  * offset.
  */
-#define REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(off, rd, wr, bpi, acc)	\
+#define REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(off, type, rd, wr, bpi, acc) \
 	{								\
 		.reg_offset = off,					\
 		.bits_per_irq = bpi,					\
 		.len = (bpi * VGIC_NR_PRIVATE_IRQS) / 8,		\
 		.access_flags = acc,					\
+		.iodev_type = type,					\
 		.read = vgic_mmio_read_raz,				\
 		.write = vgic_mmio_write_wi,				\
 	}, {								\
@@ -309,108 +346,109 @@ static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
 		.bits_per_irq = bpi,					\
 		.len = (bpi * (1024 - VGIC_NR_PRIVATE_IRQS)) / 8,	\
 		.access_flags = acc,					\
+		.iodev_type = type,					\
 		.read = rd,						\
 		.write = wr,						\
 	}
 
 static const struct vgic_register_region vgic_v3_dist_registers[] = {
-	REGISTER_DESC_WITH_LENGTH(GICD_CTLR,
+	REGISTER_DESC_WITH_LENGTH(GICD_CTLR, IODEV_DIST,
 		vgic_mmio_read_v3_misc, vgic_mmio_write_v3_misc, 16,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR,
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR, IODEV_DIST,
 		vgic_mmio_read_rao, vgic_mmio_write_wi, 1,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISENABLER,
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISENABLER, IODEV_DIST,
 		vgic_mmio_read_enable, vgic_mmio_write_senable, 1,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICENABLER,
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICENABLER, IODEV_DIST,
 		vgic_mmio_read_enable, vgic_mmio_write_cenable, 1,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISPENDR,
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISPENDR, IODEV_DIST,
 		vgic_mmio_read_pending, vgic_mmio_write_spending, 1,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICPENDR,
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICPENDR, IODEV_DIST,
 		vgic_mmio_read_pending, vgic_mmio_write_cpending, 1,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER,
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISACTIVER, IODEV_DIST,
 		vgic_mmio_read_active, vgic_mmio_write_sactive, 1,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICACTIVER,
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICACTIVER, IODEV_DIST,
 		vgic_mmio_read_active, vgic_mmio_write_cactive, 1,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IPRIORITYR,
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IPRIORITYR, IODEV_DIST,
 		vgic_mmio_read_priority, vgic_mmio_write_priority, 8,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ITARGETSR,
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ITARGETSR, IODEV_DIST,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICFGR,
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ICFGR, IODEV_DIST,
 		vgic_mmio_read_config, vgic_mmio_write_config, 2,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGRPMODR,
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGRPMODR, IODEV_DIST,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 1,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IROUTER,
+	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IROUTER, IODEV_DIST,
 		vgic_mmio_read_irouter, vgic_mmio_write_irouter, 64,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICD_IDREGS,
+	REGISTER_DESC_WITH_LENGTH(GICD_IDREGS, IODEV_DIST,
 		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48,
 		VGIC_ACCESS_32bit),
 };
 
 static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
-	REGISTER_DESC_WITH_LENGTH(GICR_CTLR,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
+	REGISTER_DESC_WITH_LENGTH(GICR_CTLR, IODEV_REDIST,
+		vgic_mmio_read_v3r_ctlr, vgic_mmio_write_v3r_ctlr, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
+	REGISTER_DESC_WITH_LENGTH(GICR_IIDR, IODEV_REDIST,
 		vgic_mmio_read_v3r_iidr, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_TYPER,
+	REGISTER_DESC_WITH_LENGTH(GICR_TYPER, IODEV_REDIST,
 		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_PROPBASER,
+	REGISTER_DESC_WITH_LENGTH(GICR_PROPBASER, IODEV_REDIST,
 		vgic_mmio_read_propbase, vgic_mmio_write_propbase, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_PENDBASER,
+	REGISTER_DESC_WITH_LENGTH(GICR_PENDBASER, IODEV_REDIST,
 		vgic_mmio_read_pendbase, vgic_mmio_write_pendbase, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_IDREGS,
+	REGISTER_DESC_WITH_LENGTH(GICR_IDREGS, IODEV_REDIST,
 		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48,
 		VGIC_ACCESS_32bit),
 };
 
 static const struct vgic_register_region vgic_v3_sgibase_registers[] = {
-	REGISTER_DESC_WITH_LENGTH(GICR_IGROUPR0,
+	REGISTER_DESC_WITH_LENGTH(GICR_IGROUPR0, IODEV_REDIST,
 		vgic_mmio_read_rao, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_ISENABLER0,
+	REGISTER_DESC_WITH_LENGTH(GICR_ISENABLER0, IODEV_REDIST,
 		vgic_mmio_read_enable, vgic_mmio_write_senable, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_ICENABLER0,
+	REGISTER_DESC_WITH_LENGTH(GICR_ICENABLER0, IODEV_REDIST,
 		vgic_mmio_read_enable, vgic_mmio_write_cenable, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_ISPENDR0,
+	REGISTER_DESC_WITH_LENGTH(GICR_ISPENDR0, IODEV_REDIST,
 		vgic_mmio_read_pending, vgic_mmio_write_spending, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_ICPENDR0,
+	REGISTER_DESC_WITH_LENGTH(GICR_ICPENDR0, IODEV_REDIST,
 		vgic_mmio_read_pending, vgic_mmio_write_cpending, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_ISACTIVER0,
+	REGISTER_DESC_WITH_LENGTH(GICR_ISACTIVER0, IODEV_REDIST,
 		vgic_mmio_read_active, vgic_mmio_write_sactive, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_ICACTIVER0,
+	REGISTER_DESC_WITH_LENGTH(GICR_ICACTIVER0, IODEV_REDIST,
 		vgic_mmio_read_active, vgic_mmio_write_cactive, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_IPRIORITYR0,
+	REGISTER_DESC_WITH_LENGTH(GICR_IPRIORITYR0, IODEV_REDIST,
 		vgic_mmio_read_priority, vgic_mmio_write_priority, 32,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_ICFGR0,
+	REGISTER_DESC_WITH_LENGTH(GICR_ICFGR0, IODEV_REDIST,
 		vgic_mmio_read_config, vgic_mmio_write_config, 8,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_IGRPMODR0,
+	REGISTER_DESC_WITH_LENGTH(GICR_IGRPMODR0, IODEV_REDIST,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_NSACR,
+	REGISTER_DESC_WITH_LENGTH(GICR_NSACR, IODEV_REDIST,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
 };
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 630d1c3..6e5f941 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -472,8 +472,7 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 {
 	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
 	const struct vgic_register_region *region;
-	struct kvm_vcpu *r_vcpu;
-	unsigned long data;
+	unsigned long data = 0;
 
 	region = vgic_find_mmio_region(iodev->regions, iodev->nr_regions,
 				       addr - iodev->base_addr);
@@ -482,8 +481,20 @@ static int dispatch_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 		return 0;
 	}
 
-	r_vcpu = iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
-	data = region->read(r_vcpu, addr, len);
+	switch (region->iodev_type) {
+	case IODEV_CPUIF:
+		return 1;
+	case IODEV_DIST:
+		data = region->read(vcpu, addr, len);
+		break;
+	case IODEV_REDIST:
+		data = region->read(iodev->redist_vcpu, addr, len);
+		break;
+	case IODEV_ITS:
+		data = region->its_read(vcpu->kvm, iodev->its, addr, len);
+		break;
+	}
+
 	vgic_data_host_to_mmio_bus(val, len, data);
 	return 0;
 }
@@ -493,7 +504,6 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 {
 	struct vgic_io_device *iodev = kvm_to_vgic_iodev(dev);
 	const struct vgic_register_region *region;
-	struct kvm_vcpu *r_vcpu;
 	unsigned long data = vgic_data_mmio_bus_to_host(val, len);
 
 	region = vgic_find_mmio_region(iodev->regions, iodev->nr_regions,
@@ -504,8 +514,20 @@ static int dispatch_mmio_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
 	if (!check_region(region, addr, len))
 		return 0;
 
-	r_vcpu = iodev->redist_vcpu ? iodev->redist_vcpu : vcpu;
-	region->write(r_vcpu, addr, len, data);
+	switch (region->iodev_type) {
+	case IODEV_CPUIF:
+		break;
+	case IODEV_DIST:
+		region->write(vcpu, addr, len, data);
+		break;
+	case IODEV_REDIST:
+		region->write(iodev->redist_vcpu, addr, len, data);
+		break;
+	case IODEV_ITS:
+		region->its_write(vcpu->kvm, iodev->its, addr, len, data);
+		break;
+	}
+
 	return 0;
 }
 
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index e863ccc..23e97a7 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -16,15 +16,32 @@
 #ifndef __KVM_ARM_VGIC_MMIO_H__
 #define __KVM_ARM_VGIC_MMIO_H__
 
+enum iodev_type {
+	IODEV_CPUIF,
+	IODEV_DIST,
+	IODEV_REDIST,
+	IODEV_ITS
+};
+
 struct vgic_register_region {
 	unsigned int reg_offset;
 	unsigned int len;
 	unsigned int bits_per_irq;
 	unsigned int access_flags;
-	unsigned long (*read)(struct kvm_vcpu *vcpu, gpa_t addr,
-			      unsigned int len);
-	void (*write)(struct kvm_vcpu *vcpu, gpa_t addr, unsigned int len,
-		      unsigned long val);
+	enum iodev_type iodev_type;
+	union {
+		unsigned long (*read)(struct kvm_vcpu *vcpu, gpa_t addr,
+				      unsigned int len);
+		unsigned long (*its_read)(struct kvm *kvm, struct vgic_its *its,
+					  gpa_t addr, unsigned int len);
+	};
+	union {
+		void (*write)(struct kvm_vcpu *vcpu, gpa_t addr,
+			      unsigned int len, unsigned long val);
+		void (*its_write)(struct kvm *kvm, struct vgic_its *its,
+				  gpa_t addr, unsigned int len,
+				  unsigned long val);
+	};
 };
 
 extern struct kvm_io_device_ops kvm_io_gic_ops;
@@ -57,22 +74,24 @@ extern struct kvm_io_device_ops kvm_io_gic_ops;
  * The _WITH_LENGTH version instantiates registers with a fixed length
  * and is mutually exclusive with the _PER_IRQ version.
  */
-#define REGISTER_DESC_WITH_BITS_PER_IRQ(off, rd, wr, bpi, acc)		\
+#define REGISTER_DESC_WITH_BITS_PER_IRQ(off, type, rd, wr, bpi, acc)	\
 	{								\
 		.reg_offset = off,					\
 		.bits_per_irq = bpi,					\
 		.len = bpi * 1024 / 8,					\
 		.access_flags = acc,					\
+		.iodev_type = type,					\
 		.read = rd,						\
 		.write = wr,						\
 	}
 
-#define REGISTER_DESC_WITH_LENGTH(off, rd, wr, length, acc)		\
+#define REGISTER_DESC_WITH_LENGTH(off, type, rd, wr, length, acc)	\
 	{								\
 		.reg_offset = off,					\
 		.bits_per_irq = 0,					\
 		.len = length,						\
 		.access_flags = acc,					\
+		.iodev_type = type,					\
 		.read = rd,						\
 		.write = wr,						\
 	}
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 5b79c34..31807c1 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -72,6 +72,7 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu);
 int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
+bool vgic_has_its(struct kvm *kvm);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -123,6 +124,12 @@ static inline int vgic_register_redist_iodevs(struct kvm *kvm,
 {
 	return -ENODEV;
 }
+
+static inline bool vgic_has_its(struct kvm *kvm)
+{
+	return false;
+}
+
 #endif
 
 int kvm_register_vgic_device(unsigned long type);
-- 
2.9.0
