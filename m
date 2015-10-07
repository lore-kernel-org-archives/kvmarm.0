From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 09/16] KVM: arm64: introduce ITS emulation file with stub functions
Date: Wed,  7 Oct 2015 15:55:19 +0100
Message-ID: <1444229726-31559-10-git-send-email-andre.przywara@arm.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: eric.auger@linaro.org, p.fedin@samsung.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The ARM GICv3 ITS emulation code goes into a separate file, but
needs to be connected to the GICv3 emulation, of which it is an
option.
Introduce the skeleton with function stubs to be filled later.
Introduce the basic ITS data structure and initialize it, but don't
return any success yet, as we are not yet ready for the show.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
---
Changelog v2..v3:
- drop ITS check before doing GICR_CTLR access

 arch/arm64/kvm/Makefile            |   1 +
 include/kvm/arm_vgic.h             |   6 ++
 include/linux/irqchip/arm-gic-v3.h |   1 +
 virt/kvm/arm/its-emul.c            | 125 +++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/its-emul.h            |  35 +++++++++++
 virt/kvm/arm/vgic-v3-emul.c        |  20 +++++-
 6 files changed, 185 insertions(+), 3 deletions(-)
 create mode 100644 virt/kvm/arm/its-emul.c
 create mode 100644 virt/kvm/arm/its-emul.h

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 1949fe5..75069a9 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -25,5 +25,6 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2-emul.o
 kvm-$(CONFIG_KVM_ARM_HOST) += vgic-v2-switch.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3-emul.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/its-emul.o
 kvm-$(CONFIG_KVM_ARM_HOST) += vgic-v3-switch.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 06c33bc..c8c48e3 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -168,6 +168,11 @@ struct irq_phys_map_entry {
 	struct irq_phys_map	map;
 };
 
+struct vgic_its {
+	bool			enabled;
+	spinlock_t		lock;
+};
+
 struct vgic_dist {
 	spinlock_t		lock;
 	bool			in_kernel;
@@ -280,6 +285,7 @@ struct vgic_dist {
 	u64			*pendbaser;
 
 	bool			lpis_enabled;
+	struct vgic_its		its;
 };
 
 struct vgic_v2_cpu_if {
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 9eeeb95..70e9539 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -179,6 +179,7 @@
 #define GITS_CWRITER			0x0088
 #define GITS_CREADR			0x0090
 #define GITS_BASER			0x0100
+#define GITS_IDREGS_BASE		0xffd0
 #define GITS_PIDR2			GICR_PIDR2
 
 #define GITS_TRANSLATER			0x10040
diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
new file mode 100644
index 0000000..659dd39
--- /dev/null
+++ b/virt/kvm/arm/its-emul.c
@@ -0,0 +1,125 @@
+/*
+ * GICv3 ITS emulation
+ *
+ * Copyright (C) 2015 ARM Ltd.
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
+#include <kvm/arm_vgic.h>
+
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_arm.h>
+#include <asm/kvm_mmu.h>
+
+#include "vgic.h"
+#include "its-emul.h"
+
+static bool handle_mmio_misc_gits(struct kvm_vcpu *vcpu,
+				  struct kvm_exit_mmio *mmio,
+				  phys_addr_t offset)
+{
+	return false;
+}
+
+static bool handle_mmio_gits_idregs(struct kvm_vcpu *vcpu,
+				    struct kvm_exit_mmio *mmio,
+				    phys_addr_t offset)
+{
+	return false;
+}
+
+static bool handle_mmio_gits_cbaser(struct kvm_vcpu *vcpu,
+				    struct kvm_exit_mmio *mmio,
+				    phys_addr_t offset)
+{
+	return false;
+}
+
+static bool handle_mmio_gits_cwriter(struct kvm_vcpu *vcpu,
+				     struct kvm_exit_mmio *mmio,
+				     phys_addr_t offset)
+{
+	return false;
+}
+
+static bool handle_mmio_gits_creadr(struct kvm_vcpu *vcpu,
+				    struct kvm_exit_mmio *mmio,
+				    phys_addr_t offset)
+{
+	return false;
+}
+
+static const struct vgic_io_range vgicv3_its_ranges[] = {
+	{
+		.base		= GITS_CTLR,
+		.len		= 0x10,
+		.bits_per_irq	= 0,
+		.handle_mmio	= handle_mmio_misc_gits,
+	},
+	{
+		.base		= GITS_CBASER,
+		.len		= 0x08,
+		.bits_per_irq	= 0,
+		.handle_mmio	= handle_mmio_gits_cbaser,
+	},
+	{
+		.base		= GITS_CWRITER,
+		.len		= 0x08,
+		.bits_per_irq	= 0,
+		.handle_mmio	= handle_mmio_gits_cwriter,
+	},
+	{
+		.base		= GITS_CREADR,
+		.len		= 0x08,
+		.bits_per_irq	= 0,
+		.handle_mmio	= handle_mmio_gits_creadr,
+	},
+	{
+		/* We don't need any memory from the guest. */
+		.base		= GITS_BASER,
+		.len		= 0x40,
+		.bits_per_irq	= 0,
+		.handle_mmio	= handle_mmio_raz_wi,
+	},
+	{
+		.base		= GITS_IDREGS_BASE,
+		.len		= 0x30,
+		.bits_per_irq	= 0,
+		.handle_mmio	= handle_mmio_gits_idregs,
+	},
+};
+
+/* This is called on setting the LPI enable bit in the redistributor. */
+void vgic_enable_lpis(struct kvm_vcpu *vcpu)
+{
+}
+
+int vits_init(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_its *its = &dist->its;
+
+	spin_lock_init(&its->lock);
+
+	its->enabled = false;
+
+	return -ENXIO;
+}
diff --git a/virt/kvm/arm/its-emul.h b/virt/kvm/arm/its-emul.h
new file mode 100644
index 0000000..5dc8e2f
--- /dev/null
+++ b/virt/kvm/arm/its-emul.h
@@ -0,0 +1,35 @@
+/*
+ * GICv3 ITS emulation definitions
+ *
+ * Copyright (C) 2015 ARM Ltd.
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
+#ifndef __KVM_ITS_EMUL_H__
+#define __KVM_ITS_EMUL_H__
+
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_arm.h>
+#include <asm/kvm_mmu.h>
+
+#include "vgic.h"
+
+void vgic_enable_lpis(struct kvm_vcpu *vcpu);
+int vits_init(struct kvm *kvm);
+
+#endif
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index 6939f7c..a7b60bdb 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -48,6 +48,7 @@
 #include <asm/kvm_mmu.h>
 
 #include "vgic.h"
+#include "its-emul.h"
 
 static bool handle_mmio_rao_wi(struct kvm_vcpu *vcpu,
 			       struct kvm_exit_mmio *mmio, phys_addr_t offset)
@@ -530,9 +531,16 @@ static bool handle_mmio_ctlr_redist(struct kvm_vcpu *vcpu,
 				    struct kvm_exit_mmio *mmio,
 				    phys_addr_t offset)
 {
-	/* since we don't support LPIs, this register is zero for now */
-	vgic_reg_access(mmio, NULL, offset,
-			ACCESS_READ_RAZ | ACCESS_WRITE_IGNORED);
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	u32 reg;
+
+	reg = dist->lpis_enabled ? GICR_CTLR_ENABLE_LPIS : 0;
+	vgic_reg_access(mmio, &reg, offset,
+			ACCESS_READ_VALUE | ACCESS_WRITE_VALUE);
+	if (vgic_has_its(vcpu->kvm) && !dist->lpis_enabled &&
+	    (reg & GICR_CTLR_ENABLE_LPIS)) {
+		/* Eventually do something */
+	}
 	return false;
 }
 
@@ -861,6 +869,12 @@ static int vgic_v3_map_resources(struct kvm *kvm,
 		rdbase += GIC_V3_REDIST_SIZE;
 	}
 
+	if (vgic_has_its(kvm)) {
+		ret = vits_init(kvm);
+		if (ret)
+			goto out_unregister;
+	}
+
 	dist->redist_iodevs = iodevs;
 	dist->ready = true;
 	goto out;
-- 
2.5.1

