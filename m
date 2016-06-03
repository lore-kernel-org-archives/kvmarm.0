From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 06/13] KVM: arm64: introduce ITS emulation file with stub functions
Date: Fri,  3 Jun 2016 15:02:45 +0100
Message-ID: <1464962572-3925-7-git-send-email-andre.przywara@arm.com>
References: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The ARM GICv3 ITS emulation code goes into a separate file, but
needs to be connected to the GICv3 emulation, of which it is an
option.
Introduce the skeleton with function stubs to be filled later.
Introduce the basic ITS data structure and initialize it, but don't
return any success yet, as we are not yet ready for the show.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arch/arm64/kvm/Makefile            |  1 +
 include/kvm/vgic/vgic.h            |  9 ++++
 include/linux/irqchip/arm-gic-v3.h |  1 +
 virt/kvm/arm/vgic/vgic-its.c       | 84 ++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio-v3.c   | 38 ++++++++++++++++-
 virt/kvm/arm/vgic/vgic.h           | 17 ++++++++
 6 files changed, 149 insertions(+), 1 deletion(-)
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
index 896175b..6a7f5e4 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -116,6 +116,15 @@ struct vgic_io_device {
 	struct kvm_io_device dev;
 };
 
+struct vgic_its {
+	/* The base address of the ITS control register frame */
+	gpa_t			vgic_its_base;
+
+	bool			enabled;
+	struct vgic_io_device	iodev;
+	spinlock_t		lock;
+};
+
 struct vgic_dist {
 	bool			in_kernel;
 	bool			ready;
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index bfbd707..f210dd3 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -175,6 +175,7 @@
 #define GITS_CWRITER			0x0088
 #define GITS_CREADR			0x0090
 #define GITS_BASER			0x0100
+#define GITS_IDREGS_BASE		0xffd0
 #define GITS_PIDR2			GICR_PIDR2
 
 #define GITS_TRANSLATER			0x10040
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
new file mode 100644
index 0000000..61f3b8e
--- /dev/null
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -0,0 +1,84 @@
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
+struct vgic_register_region its_registers[] = {
+	REGISTER_DESC_WITH_LENGTH(GITS_CTLR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GITS_IIDR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
+		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GITS_TYPER,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GITS_CBASER,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GITS_CWRITER,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GITS_CREADR,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GITS_BASER,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 0x40,
+		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH(GITS_IDREGS_BASE,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 0x30,
+		VGIC_ACCESS_32bit),
+};
+
+int vits_init(struct kvm *kvm, struct vgic_its *its)
+{
+	struct vgic_io_device *iodev = &its->iodev;
+	int ret;
+
+	iodev->regions = its_registers;
+	iodev->nr_regions = ARRAY_SIZE(its_registers);
+	kvm_iodevice_init(&iodev->dev, &kvm_io_gic_ops);
+
+	iodev->base_addr = its->vgic_its_base;
+	iodev->redist_vcpu = NULL;
+	mutex_lock(&kvm->slots_lock);
+	ret = kvm_io_bus_register_dev(kvm, KVM_MMIO_BUS, iodev->base_addr,
+				      SZ_64K, &iodev->dev);
+	mutex_unlock(&kvm->slots_lock);
+
+	return ret;
+}
+
+void vits_destroy(struct kvm *kvm, struct vgic_its *its)
+{
+
+	its->enabled = false;
+}
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 6293b36..2eb9f0e 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -39,6 +39,16 @@ static u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
 	return reg | ((u64)val << (offset * 8));
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
@@ -124,6 +134,32 @@ static void vgic_mmio_write_irouter(struct kvm_vcpu *vcpu,
 	spin_unlock(&irq->irq_lock);
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
@@ -272,7 +308,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
 
 static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GICR_CTLR,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
+		vgic_mmio_read_v3r_ctlr, vgic_mmio_write_v3r_ctlr, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
 		vgic_mmio_read_v3r_iidr, vgic_mmio_write_wi, 4,
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index c752152..0baad03 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -71,6 +71,9 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu);
 int vgic_v3_probe(const struct gic_kvm_info *info);
 int vgic_v3_map_resources(struct kvm *kvm);
 int vgic_register_redist_iodevs(struct kvm *kvm, gpa_t dist_base_address);
+bool vgic_has_its(struct kvm *kvm);
+int vits_init(struct kvm *kvm, struct vgic_its *its);
+void vits_destroy(struct kvm *kvm, struct vgic_its *its);
 #else
 static inline void vgic_v3_process_maintenance(struct kvm_vcpu *vcpu)
 {
@@ -122,6 +125,20 @@ static inline int vgic_register_redist_iodevs(struct kvm *kvm,
 {
 	return -ENODEV;
 }
+
+static bool vgic_has_its(struct kvm *kvm)
+{
+	return false;
+}
+
+static int vits_init(struct kvm *kvm, struct vgic_its *its)
+{
+	return -ENODEV;
+}
+
+static inline void vits_destroy(struct kvm *kvm, struct vgic_its *its)
+{
+}
 #endif
 
 int kvm_register_vgic_device(unsigned long type);
-- 
2.8.2

