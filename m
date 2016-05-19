From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 15/57] KVM: arm/arm64: vgic-new: Add data structure
 definitions
Date: Thu, 19 May 2016 19:07:54 +0100
Message-ID: <1463681316-23039-16-git-send-email-andre.przywara@arm.com>
References: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B2CA249B8D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 14:05:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 49Bp5dn1lsS4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2016 14:05:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B69C49B5C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 14:05:16 -0400 (EDT)
In-Reply-To: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
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
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@linaro.org>

Add a new header file for the new and improved GIC implementation.
The big change is that we now have a struct vgic_irq per IRQ instead
of spreading all the information over various bitmaps.

We include this new header conditionally from within the old header
file for the time being to avoid touching all the users.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
Changelog RFC .. v1:
- adapt to 4.6-rc (adding live_lrs member)
- elaborate on ap_list usage

Changelog v1 .. v2:
- change data type of dist->enabled to bool

Changelog v3 .. v4:
- fix comment typos

 include/kvm/arm_vgic.h  |   5 ++
 include/kvm/vgic/vgic.h | 201 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 206 insertions(+)
 create mode 100644 include/kvm/vgic/vgic.h

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index ade7005..da0a5248 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -19,6 +19,10 @@
 #ifndef __ASM_ARM_KVM_VGIC_H
 #define __ASM_ARM_KVM_VGIC_H
 
+#ifdef CONFIG_KVM_NEW_VGIC
+#include <kvm/vgic/vgic.h>
+#else
+
 #include <linux/kernel.h>
 #include <linux/kvm.h>
 #include <linux/irqreturn.h>
@@ -367,4 +371,5 @@ static inline int vgic_v3_probe(const struct gic_kvm_info *gic_kvm_info,
 }
 #endif
 
+#endif	/* old VGIC include */
 #endif
diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
new file mode 100644
index 0000000..6ca0781
--- /dev/null
+++ b/include/kvm/vgic/vgic.h
@@ -0,0 +1,201 @@
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
+#ifndef __ASM_ARM_KVM_VGIC_VGIC_H
+#define __ASM_ARM_KVM_VGIC_VGIC_H
+
+#include <linux/kernel.h>
+#include <linux/kvm.h>
+#include <linux/irqreturn.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+#include <kvm/iodev.h>
+
+#define VGIC_V3_MAX_CPUS	255
+#define VGIC_V2_MAX_CPUS	8
+#define VGIC_NR_IRQS_LEGACY     256
+#define VGIC_NR_SGIS		16
+#define VGIC_NR_PPIS		16
+#define VGIC_NR_PRIVATE_IRQS	(VGIC_NR_SGIS + VGIC_NR_PPIS)
+#define VGIC_MAX_PRIVATE	(VGIC_NR_PRIVATE_IRQS - 1)
+#define VGIC_MAX_SPI		1019
+#define VGIC_MAX_RESERVED	1023
+#define VGIC_MIN_LPI		8192
+
+enum vgic_type {
+	VGIC_V2,		/* Good ol' GICv2 */
+	VGIC_V3,		/* New fancy GICv3 */
+};
+
+/* same for all guests, as depending only on the _host's_ GIC model */
+struct vgic_global {
+	/* type of the host GIC */
+	enum vgic_type		type;
+
+	/* Physical address of vgic virtual cpu interface */
+	phys_addr_t		vcpu_base;
+
+	/* virtual control interface mapping */
+	void __iomem		*vctrl_base;
+
+	/* Number of implemented list registers */
+	int			nr_lr;
+
+	/* Maintenance IRQ number */
+	unsigned int		maint_irq;
+
+	/* maximum number of VCPUs allowed (GICv2 limits us to 8) */
+	int			max_gic_vcpus;
+
+	/* Only needed for the legacy KVM_CREATE_IRQCHIP */
+	bool			can_emulate_gicv2;
+};
+
+extern struct vgic_global kvm_vgic_global_state;
+
+#define VGIC_V2_MAX_LRS		(1 << 6)
+#define VGIC_V3_MAX_LRS		16
+#define VGIC_V3_LR_INDEX(lr)	(VGIC_V3_MAX_LRS - 1 - lr)
+
+enum vgic_irq_config {
+	VGIC_CONFIG_EDGE = 0,
+	VGIC_CONFIG_LEVEL
+};
+
+struct vgic_irq {
+	spinlock_t irq_lock;		/* Protects the content of the struct */
+	struct list_head ap_list;
+
+	struct kvm_vcpu *vcpu;		/* SGIs and PPIs: The VCPU
+					 * SPIs and LPIs: The VCPU whose ap_list
+					 * this is queued on.
+					 */
+
+	struct kvm_vcpu *target_vcpu;	/* The VCPU that this interrupt should
+					 * be sent to, as a result of the
+					 * targets reg (v2) or the
+					 * affinity reg (v3).
+					 */
+
+	u32 intid;			/* Guest visible INTID */
+	bool pending;
+	bool line_level;		/* Level only */
+	bool soft_pending;		/* Level only */
+	bool active;			/* not used for LPIs */
+	bool enabled;
+	bool hw;			/* Tied to HW IRQ */
+	u32 hwintid;			/* HW INTID number */
+	union {
+		u8 targets;			/* GICv2 target VCPUs mask */
+		u32 mpidr;			/* GICv3 target VCPU */
+	};
+	u8 source;			/* GICv2 SGIs only */
+	u8 priority;
+	enum vgic_irq_config config;	/* Level or edge */
+};
+
+struct vgic_dist {
+	bool			in_kernel;
+	bool			ready;
+
+	/* vGIC model the kernel emulates for the guest (GICv2 or GICv3) */
+	u32			vgic_model;
+
+	int			nr_spis;
+
+	/* TODO: Consider moving to global state */
+	/* Virtual control interface mapping */
+	void __iomem		*vctrl_base;
+
+	/* base addresses in guest physical address space: */
+	gpa_t			vgic_dist_base;		/* distributor */
+	union {
+		/* either a GICv2 CPU interface */
+		gpa_t			vgic_cpu_base;
+		/* or a number of GICv3 redistributor regions */
+		gpa_t			vgic_redist_base;
+	};
+
+	/* distributor enabled */
+	bool			enabled;
+
+	struct vgic_irq		*spis;
+};
+
+struct vgic_v2_cpu_if {
+	u32		vgic_hcr;
+	u32		vgic_vmcr;
+	u32		vgic_misr;	/* Saved only */
+	u64		vgic_eisr;	/* Saved only */
+	u64		vgic_elrsr;	/* Saved only */
+	u32		vgic_apr;
+	u32		vgic_lr[VGIC_V2_MAX_LRS];
+};
+
+struct vgic_v3_cpu_if {
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+	u32		vgic_hcr;
+	u32		vgic_vmcr;
+	u32		vgic_sre;	/* Restored only, change ignored */
+	u32		vgic_misr;	/* Saved only */
+	u32		vgic_eisr;	/* Saved only */
+	u32		vgic_elrsr;	/* Saved only */
+	u32		vgic_ap0r[4];
+	u32		vgic_ap1r[4];
+	u64		vgic_lr[VGIC_V3_MAX_LRS];
+#endif
+};
+
+struct vgic_cpu {
+	/* CPU vif control registers for world switch */
+	union {
+		struct vgic_v2_cpu_if	vgic_v2;
+		struct vgic_v3_cpu_if	vgic_v3;
+	};
+
+	unsigned int used_lrs;
+	struct vgic_irq private_irqs[VGIC_NR_PRIVATE_IRQS];
+
+	spinlock_t ap_list_lock;	/* Protects the ap_list */
+
+	/*
+	 * List of IRQs that this VCPU should consider because they are either
+	 * Active or Pending (hence the name; AP list), or because they recently
+	 * were one of the two and need to be migrated off this list to another
+	 * VCPU.
+	 */
+	struct list_head ap_list_head;
+
+	u64 live_lrs;
+};
+
+#define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
+#define vgic_initialized(k)	(false)
+#define vgic_ready(k)		((k)->arch.vgic.ready)
+#define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
+			((i) < (k)->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS))
+
+/**
+ * kvm_vgic_get_max_vcpus - Get the maximum number of VCPUs allowed by HW
+ *
+ * The host's GIC naturally limits the maximum amount of VCPUs a guest
+ * can use.
+ */
+static inline int kvm_vgic_get_max_vcpus(void)
+{
+	return kvm_vgic_global_state.max_gic_vcpus;
+}
+
+#endif /* __ASM_ARM_KVM_VGIC_VGIC_H */
-- 
2.8.2
