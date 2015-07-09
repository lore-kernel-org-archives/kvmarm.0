From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v2 4/7] KVM: arm/arm64: enable irqchip routing
Date: Thu,  9 Jul 2015 10:22:14 +0200
Message-ID: <1436430137-24205-5-git-send-email-eric.auger@linaro.org>
References: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25CDE582A0
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 04:11:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y4eAG8WT+osg for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Jul 2015 04:11:17 -0400 (EDT)
Received: from mail-wg0-f46.google.com (mail-wg0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C665C5828E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Jul 2015 04:11:16 -0400 (EDT)
Received: by wgjx7 with SMTP id x7so216374072wgj.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Jul 2015 01:22:51 -0700 (PDT)
In-Reply-To: <1436430137-24205-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com, patches@linaro.org
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
v1 -> v2:
- fix bug reported by Andre related to msi.flags and msi.devid setting
  in kvm_send_userspace_msi
- avoid injecting reserved IRQ numbers in vgic_irqfd_set_irq

RFC -> PATCH
- reword api.txt:
  x move MSI routing comments in a subsequent patch,
  x clearly state GSI routing does not apply to KVM_IRQ_LINE
---
 Documentation/virtual/kvm/api.txt | 12 ++++---
 arch/arm/include/asm/kvm_host.h   |  2 ++
 arch/arm/kvm/Kconfig              |  2 ++
 arch/arm/kvm/Makefile             |  2 +-
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/Kconfig            |  2 ++
 arch/arm64/kvm/Makefile           |  2 +-
 include/kvm/arm_vgic.h            |  9 -----
 virt/kvm/arm/vgic.c               | 71 +++++++++++++++++++++++++--------------
 virt/kvm/irqchip.c                |  2 ++
 10 files changed, 65 insertions(+), 40 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 3d920cd..9276dac 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1421,13 +1421,16 @@ KVM_ASSIGN_DEV_IRQ. Partial deassignment of host or guest IRQ is allowed.
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
@@ -2335,9 +2338,10 @@ Note that closing the resamplefd is not sufficient to disable the
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
 
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index e896d2c..9871441 100644
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
index 2709db2..f6201eb 100644
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
index 3630971..6c6c25e 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2215,44 +2215,65 @@ out_free_irq:
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
 
-	return kvm_vgic_inject_irq(kvm, 0, spi, level);
+	if (spi_id > min(kvm->arch.vgic.nr_irqs, 1020))
+		return -EINVAL;
+	return kvm_vgic_inject_irq(kvm, 0, spi_id, level);
+}
+
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
 }
 
-/* MSI not implemented yet */
 int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 		struct kvm *kvm, int irq_source_id,
 		int level, bool line_status)
 {
-	return 0;
-}
+	struct kvm_msi msi;
+
+	msi.address_lo = e->msi.address_lo;
+	msi.address_hi = e->msi.address_hi;
+	msi.data = e->msi.data;
+	if (e->type == KVM_IRQ_ROUTING_EXTENDED_MSI) {
+		msi.devid = e->devid;
+		msi.flags = KVM_MSI_VALID_DEVID;
+	}
 
-#ifdef CONFIG_HAVE_KVM_MSI
-int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
-{
 	if (kvm->arch.vgic.vm_ops.inject_msi)
-		return kvm->arch.vgic.vm_ops.inject_msi(kvm, msi);
+		return kvm->arch.vgic.vm_ops.inject_msi(kvm, &msi);
 	else
 		return -ENODEV;
 }
-#endif
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index e678f8a..f26cadd 100644
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
