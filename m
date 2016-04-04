From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 4/7] KVM: arm/arm64: enable irqchip routing
Date: Mon,  4 Apr 2016 10:47:34 +0200
Message-ID: <1459759657-7402-5-git-send-email-eric.auger@linaro.org>
References: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1459759657-7402-1-git-send-email-eric.auger@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: patches@linaro.org, pbonzini@redhat.com, p.fedin@samsung.com, Manish.Jaggi@caviumnetworks.com
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds compilation and link against irqchip.

On ARM, irqchip routing is not really useful since there is
a single irqchip. However main motivation behind using irqchip
code is to enable MSI routing code.

Routing standard callbacks now are implemented in vgic_irqfd:
- kvm_set_routing_entry
- kvm_set_irq
- kvm_set_msi

They only are supported with new_vgic code.

Both HAVE_KVM_IRQCHIP and HAVE_KVM_IRQ_ROUTING are defined.
KVM_CAP_IRQ_ROUTING is advertised and KVM_SET_GSI_ROUTING is allowed.

MSI routing setup is not yet allowed.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
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

Conflicts:
	arch/arm/include/asm/kvm_host.h
	arch/arm/kvm/Kconfig
	arch/arm64/include/asm/kvm_host.h
	arch/arm64/kvm/Kconfig
---
 Documentation/virtual/kvm/api.txt | 12 ++++--
 arch/arm/include/asm/kvm_host.h   |  2 +
 arch/arm/kvm/Kconfig              |  2 +
 arch/arm/kvm/Makefile             |  1 +
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/Kconfig            |  3 ++
 arch/arm64/kvm/Makefile           |  1 +
 include/kvm/vgic/vgic.h           |  2 -
 virt/kvm/arm/vgic/vgic.c          |  7 ----
 virt/kvm/arm/vgic/vgic_irqfd.c    | 83 ++++++++++++++++++++++++++++++---------
 virt/kvm/irqchip.c                |  2 +
 11 files changed, 85 insertions(+), 31 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index c436bb6..61f8f27 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1427,13 +1427,16 @@ KVM_ASSIGN_DEV_IRQ. Partial deassignment of host or guest IRQ is allowed.
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
@@ -2361,9 +2364,10 @@ Note that closing the resamplefd is not sufficient to disable the
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
index 494b004..67dc11d 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -37,6 +37,8 @@
 
 #define KVM_VCPU_MAX_FEATURES 2
 
+#define KVM_IRQCHIP_NUM_PINS 988 /* 1020 - 32 is the number of SPI */
+
 #include <kvm/arm_vgic.h>
 
 #define KVM_MAX_VCPUS VGIC_V2_MAX_CPUS
diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 02abfff..92c3aec 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -50,6 +50,8 @@ config KVM_NEW_VGIC
 	bool "New VGIC implementation"
 	depends on KVM
 	default y
+	select HAVE_KVM_IRQCHIP
+	select HAVE_KVM_IRQ_ROUTING
 	---help---
 	  uses the new VGIC implementation
 
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index aa7d724..b8aa5ef 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -29,6 +29,7 @@ obj-y += $(KVM)/arm/vgic/vgic_irqfd.o
 obj-y += $(KVM)/arm/vgic/vgic-v2.o
 obj-y += $(KVM)/arm/vgic/vgic_mmio.o
 obj-y += $(KVM)/arm/vgic/vgic_kvm_device.o
+obj-y += $(KVM)//irqchip.o
 else
 obj-y += $(KVM)/arm/vgic.o
 obj-y += $(KVM)/arm/vgic-v2.o
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2cdd7ae..95e1779 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -35,6 +35,7 @@
 #define KVM_PRIVATE_MEM_SLOTS 4
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 #define KVM_HALT_POLL_NS_DEFAULT 500000
+#define KVM_IRQCHIP_NUM_PINS 988 /* 1020 - 32 is the number of SPI */
 
 #include <kvm/arm_vgic.h>
 #include <kvm/arm_arch_timer.h>
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 71c9ebc..bd597dc9 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -60,6 +60,9 @@ config KVM_NEW_VGIC
 	bool "New VGIC implementation"
 	depends on KVM
 	default y
+	select HAVE_KVM_MSI
+	select HAVE_KVM_IRQCHIP
+	select HAVE_KVM_IRQ_ROUTING
         ---help---
           uses the new VGIC implementation
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 3bec10e..37f2a47 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -29,6 +29,7 @@ kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v3.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic_mmio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic_kvm_device.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/its-emul.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/irqchip.o
 else
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2.o
diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index c50890f..625a777 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -284,6 +284,4 @@ static inline int kvm_vgic_get_max_vcpus(void)
 
 bool vgic_has_its(struct kvm *kvm);
 
-int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
-
 #endif /* __ASM_ARM_KVM_VGIC_VGIC_H */
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 82bfb33..a175d93 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -623,10 +623,3 @@ bool vgic_has_its(struct kvm *kvm)
 	return !IS_VGIC_ADDR_UNDEF(dist->vgic_its_base);
 }
 
-int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
-{
-	if (vgic_has_its(kvm))
-		return vits_inject_msi(kvm, msi);
-	else
-		return -ENODEV;
-}
diff --git a/virt/kvm/arm/vgic/vgic_irqfd.c b/virt/kvm/arm/vgic/vgic_irqfd.c
index 3eee1bd..a76994f 100644
--- a/virt/kvm/arm/vgic/vgic_irqfd.c
+++ b/virt/kvm/arm/vgic/vgic_irqfd.c
@@ -17,35 +17,82 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <trace/events/kvm.h>
+#include <kvm/vgic/vgic.h>
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
-}
+	unsigned int spi_id = e->irqchip.pin + VGIC_NR_PRIVATE_IRQS;
+	struct vgic_dist *dist = &kvm->arch.vgic;
 
-int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
-{
-	return pin;
-}
+	trace_kvm_set_irq(spi_id, level, irq_source_id);
 
-int kvm_set_irq(struct kvm *kvm, int irq_source_id,
-		u32 irq, int level, bool line_status)
-{
-	unsigned int spi = irq + VGIC_NR_PRIVATE_IRQS;
+	BUG_ON(!vgic_initialized(kvm));
 
-	trace_kvm_set_irq(irq, level, irq_source_id);
+	if (spi_id > min(dist->nr_spis, 1020))
+		return -EINVAL;
+	return kvm_vgic_inject_irq(kvm, 0, spi_id, level);
+}
 
-	BUG_ON(!vgic_initialized(kvm));
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
+{
+	int r = -EINVAL;
 
-	return kvm_vgic_inject_irq(kvm, 0, spi, level);
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
+/**
+ * kvm_set_msi: inject the MSI corresponding to the
+ * MSI routing entry
+ *
+ * This is the entry point for irqfd MSI injection
+ * and userspace MSI injection.
+ */
 int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 		struct kvm *kvm, int irq_source_id,
 		int level, bool line_status)
 {
-	return 0;
+	struct kvm_msi msi;
+
+	msi.address_lo = e->msi.address_lo;
+	msi.address_hi = e->msi.address_hi;
+	msi.data = e->msi.data;
+	msi.flags = e->flags;
+	msi.devid = e->devid;
+
+	if (!vgic_has_its(kvm))
+		return -ENODEV;
+
+	return vits_inject_msi(kvm, &msi);
 }
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 1c556cb..b4222d6 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -29,7 +29,9 @@
 #include <linux/srcu.h>
 #include <linux/export.h>
 #include <trace/events/kvm.h>
+#if !defined(CONFIG_ARM) && !defined(CONFIG_ARM64)
 #include "irq.h"
+#endif
 
 int kvm_irq_map_gsi(struct kvm *kvm,
 		    struct kvm_kernel_irq_routing_entry *entries, int gsi)
-- 
1.9.1

