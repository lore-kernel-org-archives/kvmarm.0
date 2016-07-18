From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v7 5/7] KVM: arm/arm64: enable irqchip routing
Date: Mon, 18 Jul 2016 13:25:55 +0000
Message-ID: <1468848357-2331-6-git-send-email-eric.auger@redhat.com>
References: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E1C3049B40
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 09:20:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L1VVqEOhI1C9 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2016 09:20:12 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 743E549B3F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 09:20:12 -0400 (EDT)
In-Reply-To: <1468848357-2331-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@redhat.com, eric.auger.pro@gmail.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, andre.przywara@arm.com
Cc: pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds compilation and link against irqchip.

Main motivation behind using irqchip code is to enable MSI
routing code. In the future irqchip routing may also be useful
when targeting multiple irqchips.

Routing standard callbacks now are implemented in vgic-irqfd:
- kvm_set_routing_entry
- kvm_set_irq
- kvm_set_msi

They only are supported with new_vgic code.

Both HAVE_KVM_IRQCHIP and HAVE_KVM_IRQ_ROUTING are defined.
KVM_CAP_IRQ_ROUTING is advertised and KVM_SET_GSI_ROUTING is allowed.

So from now on IRQCHIP routing is enabled and a routing table entry
must exist for irqfd injection to succeed for a given SPI. This patch
builds a default flat irqchip routing table (gsi=irqchip.pin) covering
all the VGIC SPI indexes. This routing table is overwritten by the
first first user-space call to KVM_SET_GSI_ROUTING ioctl.

MSI routing setup is not yet allowed.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v6 -> v7:
- re-introduce irq.h
- use kvm_kernel_irq_routing_entry renamed fields: msi_flags, msi_devid
- moved kvm_vgic_setup_default_irq_routing declaration in arm_vgic.h and
  definition in vgic-irqfd.c
- correct double / in Makefile
- remove BUG_ON(!vgic_initialized(kvm) in vgic_irqfd_set_irq since
  in any case we have a lazy_init in update_irq_pending
- move KVM_IRQCHIP_NUM_PINS in arm_vgic.h
- use VGIC_MAX_SPI

v5 -> v6:
- rebase on top of Andre's v8 + removal of old vgic

v4 -> v5:
- vgic_irqfd.c was renamed into vgic-irqfd.c by Andre
- minor comment changes
- remove trace_kvm_set_irq since it is called in irqchip
- remove CONFIG_HAVE_KVM_MSI setting (done in KVM section)
- despite Christoffer's question, in kvm_set_msi, I kept the copy from
  the input "struct kvm_kernel_irq_routing_entry *e" imposed by the
  irqchip callback API into the struct kvm_msi * passed to
  vits_inject_msi. Since vits_inject_msi is directly called by
  kvm_send_userspace_msi which takes a struct kvm_msi*, makes sense
  to me to keep the copy.
- squash former [PATCH v4 5/7] KVM: arm/arm64: build a default routing
  table into that patch
- handle default routing table alloc failure

v3 -> v4:
- provide support only for new-vgic
- code previously in vgic.c now in vgic_irqfd.c

v2 -> v3:
- unconditionally set devid and KVM_MSI_VALID_DEVID flag as suggested
  by Andre (KVM_IRQ_ROUTING_EXTENDED_MSI type not used anymore)
- vgic_irqfd_set_irq now is static
- propagate flags
- add comments

v1 -> v2:
- fix bug reported by Andre related to msi.flags and msi.devid setting
  in kvm_send_userspace_msi
- avoid injecting reserved IRQ numbers in vgic_irqfd_set_irq

RFC -> PATCH
- reword api.txt:
  x move MSI routing comments in a subsequent patch,
  x clearly state GSI routing does not apply to KVM_IRQ_LINE
---
 Documentation/virtual/kvm/api.txt |  12 +++--
 arch/arm/kvm/Kconfig              |   2 +
 arch/arm/kvm/Makefile             |   1 +
 arch/arm/kvm/irq.h                |  19 +++++++
 arch/arm64/kvm/Kconfig            |   2 +
 arch/arm64/kvm/Makefile           |   1 +
 arch/arm64/kvm/irq.h              |  19 +++++++
 include/kvm/arm_vgic.h            |   7 +++
 virt/kvm/arm/vgic/vgic-init.c     |   4 ++
 virt/kvm/arm/vgic/vgic-irqfd.c    | 101 +++++++++++++++++++++++++++++++-------
 virt/kvm/arm/vgic/vgic.c          |   7 ---
 11 files changed, 146 insertions(+), 29 deletions(-)
 create mode 100644 arch/arm/kvm/irq.h
 create mode 100644 arch/arm64/kvm/irq.h

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 0065c8e..3bb60d3 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1433,13 +1433,16 @@ KVM_ASSIGN_DEV_IRQ. Partial deassignment of host or guest IRQ is allowed.
 4.52 KVM_SET_GSI_ROUTING
 
 Capability: KVM_CAP_IRQ_ROUTING
-Architectures: x86 s390
+Architectures: x86 s390 arm arm64
 Type: vm ioctl
 Parameters: struct kvm_irq_routing (in)
 Returns: 0 on success, -1 on error
 
 Sets the GSI routing table entries, overwriting any previously set entries.
 
+On arm/arm64, GSI routing has the following limitation:
+- GSI routing does not apply to KVM_IRQ_LINE but only to KVM_IRQFD.
+
 struct kvm_irq_routing {
 	__u32 nr;
 	__u32 flags;
@@ -2368,9 +2371,10 @@ Note that closing the resamplefd is not sufficient to disable the
 irqfd.  The KVM_IRQFD_FLAG_RESAMPLE is only necessary on assignment
 and need not be specified with KVM_IRQFD_FLAG_DEASSIGN.
 
-On ARM/ARM64, the gsi field in the kvm_irqfd struct specifies the Shared
-Peripheral Interrupt (SPI) index, such that the GIC interrupt ID is
-given by gsi + 32.
+On arm/arm64, gsi routing being supported, the following can happen:
+- in case no routing entry is associated to this gsi, injection fails
+- in case the gsi is associated to an irqchip routing entry,
+  irqchip.pin + 32 corresponds to the injected SPI ID.
 
 4.76 KVM_PPC_ALLOCATE_HTAB
 
diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 95a0005..3e1cd04 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -32,6 +32,8 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
+	select HAVE_KVM_IRQCHIP
+	select HAVE_KVM_IRQ_ROUTING
 	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
 	---help---
 	  Support hosting virtualized guest machines.
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index 5e28df8..10d77a6 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -29,4 +29,5 @@ obj-y += $(KVM)/arm/vgic/vgic-v2.o
 obj-y += $(KVM)/arm/vgic/vgic-mmio.o
 obj-y += $(KVM)/arm/vgic/vgic-mmio-v2.o
 obj-y += $(KVM)/arm/vgic/vgic-kvm-device.o
+obj-y += $(KVM)/irqchip.o
 obj-y += $(KVM)/arm/arch_timer.o
diff --git a/arch/arm/kvm/irq.h b/arch/arm/kvm/irq.h
new file mode 100644
index 0000000..b74099b
--- /dev/null
+++ b/arch/arm/kvm/irq.h
@@ -0,0 +1,19 @@
+/*
+ * irq.h: in kernel interrupt controller related definitions
+ * Copyright (c) 2016 Red Hat, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This header is included by irqchip.c. However, on ARM, interrupt
+ * controller declarations are located in include/kvm/arm_vgic.h since
+ * they are mostly shared between arm and arm64.
+ */
+
+#ifndef __IRQ_H
+#define __IRQ_H
+
+#include <kvm/arm_vgic.h>
+
+#endif
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 9d2eff0..9c9edc9 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -37,6 +37,8 @@ config KVM
 	select KVM_ARM_VGIC_V3
 	select KVM_ARM_PMU if HW_PERF_EVENTS
 	select HAVE_KVM_MSI
+	select HAVE_KVM_IRQCHIP
+	select HAVE_KVM_IRQ_ROUTING
 	---help---
 	  Support hosting virtualized guest machines.
 	  We don't support KVM with 16K page tables yet, due to the multiple
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index a5b9664..695eb3c 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -30,5 +30,6 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v2.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-mmio-v3.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-kvm-device.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-its.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
 kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
diff --git a/arch/arm64/kvm/irq.h b/arch/arm64/kvm/irq.h
new file mode 100644
index 0000000..b74099b
--- /dev/null
+++ b/arch/arm64/kvm/irq.h
@@ -0,0 +1,19 @@
+/*
+ * irq.h: in kernel interrupt controller related definitions
+ * Copyright (c) 2016 Red Hat, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This header is included by irqchip.c. However, on ARM, interrupt
+ * controller declarations are located in include/kvm/arm_vgic.h since
+ * they are mostly shared between arm and arm64.
+ */
+
+#ifndef __IRQ_H
+#define __IRQ_H
+
+#include <kvm/arm_vgic.h>
+
+#endif
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4e63a07..260c8e9 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -34,6 +34,7 @@
 #define VGIC_MAX_SPI		1019
 #define VGIC_MAX_RESERVED	1023
 #define VGIC_MIN_LPI		8192
+#define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
 
 enum vgic_type {
 	VGIC_V2,		/* Good ol' GICv2 */
@@ -313,4 +314,10 @@ static inline int kvm_vgic_get_max_vcpus(void)
 
 int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
 
+/**
+ * kvm_vgic_setup_default_irq_routing:
+ * Setup a default flat gsi routing table mapping all SPIs
+ */
+int kvm_vgic_setup_default_irq_routing(struct kvm *kvm);
+
 #endif /* __KVM_ARM_VGIC_H */
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 01a60dc..1aba785 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -264,6 +264,10 @@ int vgic_init(struct kvm *kvm)
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_vgic_vcpu_init(vcpu);
 
+	ret = kvm_vgic_setup_default_irq_routing(kvm);
+	if (ret)
+		goto out;
+
 	dist->initialized = true;
 out:
 	return ret;
diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
index c675513..c4750b7 100644
--- a/virt/kvm/arm/vgic/vgic-irqfd.c
+++ b/virt/kvm/arm/vgic/vgic-irqfd.c
@@ -17,36 +17,101 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <trace/events/kvm.h>
+#include <kvm/arm_vgic.h>
+#include "vgic.h"
 
-int kvm_irq_map_gsi(struct kvm *kvm,
-		    struct kvm_kernel_irq_routing_entry *entries,
-		    int gsi)
+/**
+ * vgic_irqfd_set_irq: inject the IRQ corresponding to the
+ * irqchip routing entry
+ *
+ * This is the entry point for irqfd IRQ injection
+ */
+static int vgic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
+			struct kvm *kvm, int irq_source_id,
+			int level, bool line_status)
 {
-	return 0;
+	unsigned int spi_id = e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
+	struct vgic_dist *dist = &kvm->arch.vgic;
+
+	if (spi_id > min(dist->nr_spis, VGIC_MAX_SPI))
+		return -EINVAL;
+	return kvm_vgic_inject_irq(kvm, 0, spi_id, level);
 }
 
-int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned int irqchip,
-			 unsigned int pin)
+/**
+ * kvm_set_routing_entry: populate a kvm routing entry
+ * from a user routing entry
+ *
+ * @e: kvm kernel routing entry handle
+ * @ue: user api routing entry handle
+ * return 0 on success, -EINVAL on errors.
+ */
+int kvm_set_routing_entry(struct kvm_kernel_irq_routing_entry *e,
+			  const struct kvm_irq_routing_entry *ue)
 {
-	return pin;
+	int r = -EINVAL;
+
+	switch (ue->type) {
+	case KVM_IRQ_ROUTING_IRQCHIP:
+		e->set = vgic_irqfd_set_irq;
+		e->irqchip.irqchip = ue->u.irqchip.irqchip;
+		e->irqchip.pin = ue->u.irqchip.pin;
+		if ((e->irqchip.pin >= KVM_IRQCHIP_NUM_PINS) ||
+		    (e->irqchip.irqchip >= KVM_NR_IRQCHIPS))
+			goto out;
+		break;
+	default:
+		goto out;
+	}
+	r = 0;
+out:
+	return r;
 }
 
-int kvm_set_irq(struct kvm *kvm, int irq_source_id,
-		u32 irq, int level, bool line_status)
+/**
+ * kvm_set_msi: inject the MSI corresponding to the
+ * MSI routing entry
+ *
+ * This is the entry point for irqfd MSI injection
+ * and userspace MSI injection.
+ */
+int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
+		struct kvm *kvm, int irq_source_id,
+		int level, bool line_status)
 {
-	unsigned int spi = irq + VGIC_NR_PRIVATE_IRQS;
+	struct kvm_msi msi;
 
-	trace_kvm_set_irq(irq, level, irq_source_id);
+	msi.address_lo = e->msi.address_lo;
+	msi.address_hi = e->msi.address_hi;
+	msi.data = e->msi.data;
+	msi.flags = e->msi_flags;
+	msi.devid = e->msi_devid;
 
-	BUG_ON(!vgic_initialized(kvm));
+	if (!vgic_has_its(kvm))
+		return -ENODEV;
 
-	return kvm_vgic_inject_irq(kvm, 0, spi, level);
+	return vgic_its_inject_msi(kvm, &msi);
 }
 
-/* MSI not implemented yet */
-int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
-		struct kvm *kvm, int irq_source_id,
-		int level, bool line_status)
+int kvm_vgic_setup_default_irq_routing(struct kvm *kvm)
 {
-	return 0;
+	struct kvm_irq_routing_entry *entries;
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	u32 nr = dist->nr_spis;
+	int i, ret;
+
+	entries = kcalloc(nr, sizeof(struct kvm_kernel_irq_routing_entry),
+			  GFP_KERNEL);
+	if (!entries)
+		return -ENOMEM;
+
+	for (i = 0; i < nr; i++) {
+		entries[i].gsi = i;
+		entries[i].type = KVM_IRQ_ROUTING_IRQCHIP;
+		entries[i].u.irqchip.irqchip = 0;
+		entries[i].u.irqchip.pin = i;
+	}
+	ret = kvm_set_irq_routing(kvm, entries, nr, 0);
+	kfree(entries);
+	return ret;
 }
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 424cb9c..1b3e2cd 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -719,10 +719,3 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq)
 	return map_is_active;
 }
 
-int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
-{
-	if (vgic_has_its(kvm))
-		return vgic_its_inject_msi(kvm, msi);
-	else
-		return -ENODEV;
-}
-- 
1.9.1
