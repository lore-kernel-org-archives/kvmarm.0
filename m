From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC 4/6] KVM: arm/arm64: enable irqchip routing
Date: Thu, 18 Jun 2015 19:40:56 +0200
Message-ID: <1434649258-27065-5-git-send-email-eric.auger@linaro.org>
References: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2217256009
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 13:30:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0C6tqdm5D1-4 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2015 13:30:46 -0400 (EDT)
Received: from mail-wi0-f171.google.com (mail-wi0-f171.google.com
 [209.85.212.171])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2D3C5600D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 13:30:45 -0400 (EDT)
Received: by wicnd19 with SMTP id nd19so29824411wic.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2015 10:41:26 -0700 (PDT)
In-Reply-To: <1434649258-27065-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, p.fedin@samsung.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds compilation and link against irqchip.

On ARM, irqchip routing is not really useful since there is
a single irqchip. However main motivation behind using irqchip
code is to enable MSI routing code. With the support of in-kernel
GICv3 ITS emulation, it now seems to be a MUST HAVE requirement.

Functions previously implemented in vgic.c and substitute
to more complex irqchip implementation are removed:

- kvm_send_userspace_msi
- kvm_irq_map_chip_pin
- kvm_set_irq
- kvm_irq_map_gsi.

They implemented a kernel default identity GSI routing. This is now
replaced by user-side provided routing.

Routing standard hooks are now implemented in vgic:
- kvm_set_routing_entry
- kvm_set_irq
- kvm_set_msi

Both HAVE_KVM_IRQCHIP and HAVE_KVM_IRQ_ROUTING are defined.
KVM_CAP_IRQ_ROUTING is advertised and KVM_SET_GSI_ROUTING is allowed.

MSI routing is not yet allowed.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 Documentation/virtual/kvm/api.txt | 11 ++++--
 arch/arm/include/asm/kvm_host.h   |  2 +
 arch/arm/kvm/Kconfig              |  2 +
 arch/arm/kvm/Makefile             |  2 +-
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/Kconfig            |  2 +
 arch/arm64/kvm/Makefile           |  2 +-
 include/kvm/arm_vgic.h            |  9 -----
 virt/kvm/arm/vgic.c               | 78 ++++++++++++++++++++++++---------------
 virt/kvm/irqchip.c                |  2 +
 10 files changed, 67 insertions(+), 44 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index bcec91e..2bc96e1 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1395,7 +1395,7 @@ KVM_ASSIGN_DEV_IRQ. Partial deassignment of host or guest IRQ is allowed.
 4.52 KVM_SET_GSI_ROUTING
 
 Capability: KVM_CAP_IRQ_ROUTING
-Architectures: x86 s390
+Architectures: x86 s390 arm arm64
 Type: vm ioctl
 Parameters: struct kvm_irq_routing (in)
 Returns: 0 on success, -1 on error
@@ -2310,9 +2310,12 @@ Note that closing the resamplefd is not sufficient to disable the
 irqfd.  The KVM_IRQFD_FLAG_RESAMPLE is only necessary on assignment
 and need not be specified with KVM_IRQFD_FLAG_DEASSIGN.
 
-On ARM/ARM64, the gsi field in the kvm_irqfd struct specifies the Shared
-Peripheral Interrupt (SPI) index, such that the GIC interrupt ID is
-given by gsi + 32.
+On ARM/ARM64, when GSI routing is not used, the gsi field in the
+kvm_irqfd struct specifies the Shared Peripheral Interrupt (SPI) index,
+such that the GIC interrupt ID is given by gsi + 32. When GSI routing is
+setup:
+- if irqchip routing: irqchip.pin + 32 is the SPI ID that is injected
+- if MSI routing: the MSI data is used as interrupt ID (SPI or LPI).
 
 4.76 KVM_PPC_ALLOCATE_HTAB
 
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index d71607c..452697e 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -42,6 +42,8 @@
 
 #define KVM_VCPU_MAX_FEATURES 2
 
+#define KVM_IRQCHIP_NUM_PINS 988 /* 1020 -32 is the number of SPI */
+
 #include <kvm/arm_vgic.h>
 
 u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index bfb915d..151e710 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -31,6 +31,8 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
+	select HAVE_KVM_IRQCHIP
+	select HAVE_KVM_IRQ_ROUTING
 	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
 	---help---
 	  Support hosting virtualized guest machines.
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index c5eef02c..1a8f48a 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -15,7 +15,7 @@ AFLAGS_init.o := -Wa,-march=armv7-a$(plus_virt)
 AFLAGS_interrupts.o := -Wa,-march=armv7-a$(plus_virt)
 
 KVM := ../../../virt/kvm
-kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
+kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o $(KVM)/irqchip.o
 
 obj-y += kvm-arm.o init.o interrupts.o
 obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f0f58c9..751210a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -44,6 +44,7 @@
 #include <kvm/arm_arch_timer.h>
 
 #define KVM_VCPU_MAX_FEATURES 3
+#define KVM_IRQCHIP_NUM_PINS 988 /* 1020 -32 is the number of SPI */
 
 int __attribute_const__ kvm_target_cpu(void);
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index ff9722f..1a9900d 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -32,6 +32,8 @@ config KVM
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
 	select HAVE_KVM_MSI
+	select HAVE_KVM_IRQCHIP
+	select HAVE_KVM_IRQ_ROUTING
 	---help---
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 9803307..90a08457 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -11,7 +11,7 @@ ARM=../../../arch/arm/kvm
 
 obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
 
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o $(KVM)/vfio.o $(KVM)/irqchip.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/arm.o $(ARM)/mmu.o $(ARM)/mmio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 8f1be6a..10dc596 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -366,13 +366,4 @@ static inline int vgic_v3_probe(struct device_node *vgic_node,
 }
 #endif
 
-#ifdef CONFIG_HAVE_KVM_MSI
-int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
-#else
-static inline int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
-{
-	return -ENODEV;
-}
-#endif
-
 #endif
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 09b1f46..212a5ff 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2220,47 +2220,67 @@ out_free_irq:
 	return ret;
 }
 
-int kvm_irq_map_gsi(struct kvm *kvm,
-		    struct kvm_kernel_irq_routing_entry *entries,
-		    int gsi)
+int vgic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
+			struct kvm *kvm, int irq_source_id,
+			int level, bool line_status)
 {
-	return 0;
-}
-
-int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
-{
-	return pin;
-}
-
-int kvm_set_irq(struct kvm *kvm, int irq_source_id,
-		u32 irq, int level, bool line_status)
-{
-	unsigned int spi = irq + VGIC_NR_PRIVATE_IRQS;
+	unsigned int spi_id = e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
 
-	trace_kvm_set_irq(irq, level, irq_source_id);
+	trace_kvm_set_irq(spi_id, level, irq_source_id);
 
 	BUG_ON(!vgic_initialized(kvm));
 
-	if (spi > kvm->arch.vgic.nr_irqs)
+	if (spi_id > kvm->arch.vgic.nr_irqs)
 		return -EINVAL;
-	return kvm_vgic_inject_irq(kvm, 0, spi, level);
+	return kvm_vgic_inject_irq(kvm, 0, spi_id, level);
 
 }
 
-/* MSI not implemented yet */
+/**
+ * Populates a kvm routing entry from a user routing entry
+ * @e: kvm internal formatted entry
+ * @ue: user api formatted entry
+ * return 0 on success, -EINVAL on errors.
+ */
+int kvm_set_routing_entry(struct kvm_kernel_irq_routing_entry *e,
+			  const struct kvm_irq_routing_entry *ue)
+{
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
+}
+
 int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 		struct kvm *kvm, int irq_source_id,
 		int level, bool line_status)
 {
-	return 0;
-}
+	struct kvm_msi msi;
 
-#ifdef CONFIG_HAVE_KVM_MSI
-int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
-{
-	if (kvm->arch.vgic.vm_ops.inject_msi)
-		return kvm->arch.vgic.vm_ops.inject_msi(kvm, msi);
-	else
-		return -ENODEV;
+	switch (e->type) {
+	case KVM_IRQ_ROUTING_EXTENDED_MSI:
+		msi.address_lo = e->ext_msi.address_lo;
+		msi.address_hi = e->ext_msi.address_hi;
+		msi.data = e->ext_msi.data;
+		msi.flags = e->ext_msi.devid;
+		if (kvm->arch.vgic.vm_ops.inject_msi)
+			return kvm->arch.vgic.vm_ops.inject_msi(kvm, &msi);
+		else
+			return -ENODEV;
+	default:
+		return -EINVAL;
+	}
 }
-#endif
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index e76c7d2..924a29d 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -29,7 +29,9 @@
 #include <linux/srcu.h>
 #include <linux/export.h>
 #include <trace/events/kvm.h>
+#if !defined(CONFIG_ARM) && !defined(CONFIG_ARM64)
 #include "irq.h"
+#endif
 
 struct kvm_irq_routing_table {
 	int chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
-- 
1.9.1
