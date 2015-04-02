From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 08/27] KVM: arm/arm64: add irqfd support
Date: Thu,  2 Apr 2015 11:05:12 +0100
Message-ID: <1427969131-8445-9-git-send-email-marc.zyngier@arm.com>
References: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 088FA4AD70
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2015 05:58:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cC2mqFDjHnpH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2015 05:58:00 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE1184AD69
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2015 05:57:59 -0400 (EDT)
In-Reply-To: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

This patch enables irqfd on arm/arm64.

Both irqfd and resamplefd are supported. Injection is implemented
in vgic.c without routing.

This patch enables CONFIG_HAVE_KVM_EVENTFD and CONFIG_HAVE_KVM_IRQFD.

KVM_CAP_IRQFD is now advertised. KVM_CAP_IRQFD_RESAMPLE capability
automatically is advertised as soon as CONFIG_HAVE_KVM_IRQFD is set.

Irqfd injection is restricted to SPI. The rationale behind not
supporting PPI irqfd injection is that any device using a PPI would
be a private-to-the-CPU device (timer for instance), so its state
would have to be context-switched along with the VCPU and would
require in-kernel wiring anyhow. It is not a relevant use case for
irqfds.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 Documentation/virtual/kvm/api.txt |  6 ++++-
 arch/arm/include/uapi/asm/kvm.h   |  3 +++
 arch/arm/kvm/Kconfig              |  2 ++
 arch/arm/kvm/Makefile             |  2 +-
 arch/arm/kvm/arm.c                |  1 +
 arch/arm64/include/uapi/asm/kvm.h |  3 +++
 arch/arm64/kvm/Kconfig            |  2 ++
 arch/arm64/kvm/Makefile           |  2 +-
 virt/kvm/arm/vgic.c               | 48 +++++++++++++++++++++++++++++++++++++++
 9 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index b112efc..b265d8e 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2234,7 +2234,7 @@ into the hash PTE second double word).
 4.75 KVM_IRQFD
 
 Capability: KVM_CAP_IRQFD
-Architectures: x86 s390
+Architectures: x86 s390 arm arm64
 Type: vm ioctl
 Parameters: struct kvm_irqfd (in)
 Returns: 0 on success, -1 on error
@@ -2260,6 +2260,10 @@ Note that closing the resamplefd is not sufficient to disable the
 irqfd.  The KVM_IRQFD_FLAG_RESAMPLE is only necessary on assignment
 and need not be specified with KVM_IRQFD_FLAG_DEASSIGN.
 
+On ARM/ARM64, the gsi field in the kvm_irqfd struct specifies the Shared
+Peripheral Interrupt (SPI) index, such that the GIC interrupt ID is
+given by gsi + 32.
+
 4.76 KVM_PPC_ALLOCATE_HTAB
 
 Capability: KVM_CAP_PPC_ALLOC_HTAB
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index 0db25bc..2499867 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -198,6 +198,9 @@ struct kvm_arch_memory_slot {
 /* Highest supported SPI, from VGIC_NR_IRQS */
 #define KVM_ARM_IRQ_GIC_MAX		127
 
+/* One single KVM irqchip, ie. the VGIC */
+#define KVM_NR_IRQCHIPS          1
+
 /* PSCI interface */
 #define KVM_PSCI_FN_BASE		0x95c1ba5e
 #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 83a448e..f1f79d1 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -28,6 +28,8 @@ config KVM
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select SRCU
 	select MMU_NOTIFIER
+	select HAVE_KVM_EVENTFD
+	select HAVE_KVM_IRQFD
 	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
 	---help---
 	  Support hosting virtualized guest machines.
diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
index 60be7be..a093bf1 100644
--- a/arch/arm/kvm/Makefile
+++ b/arch/arm/kvm/Makefile
@@ -15,7 +15,7 @@ AFLAGS_init.o := -Wa,-march=armv7-a$(plus_virt)
 AFLAGS_interrupts.o := -Wa,-march=armv7-a$(plus_virt)
 
 KVM := ../../../virt/kvm
-kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
+kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
 
 obj-y += kvm-arm.o init.o interrupts.o
 obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 5e893eb..cc96619 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -171,6 +171,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	int r;
 	switch (ext) {
 	case KVM_CAP_IRQCHIP:
+	case KVM_CAP_IRQFD:
 	case KVM_CAP_DEVICE_CTRL:
 	case KVM_CAP_USER_MEMORY:
 	case KVM_CAP_SYNC_MMU:
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 3ef77a4..c154c0b 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -191,6 +191,9 @@ struct kvm_arch_memory_slot {
 /* Highest supported SPI, from VGIC_NR_IRQS */
 #define KVM_ARM_IRQ_GIC_MAX		127
 
+/* One single KVM irqchip, ie. the VGIC */
+#define KVM_NR_IRQCHIPS          1
+
 /* PSCI interface */
 #define KVM_PSCI_FN_BASE		0x95c1ba5e
 #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 05f56ce..5105e29 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -28,6 +28,8 @@ config KVM
 	select KVM_ARM_HOST
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
 	select SRCU
+	select HAVE_KVM_EVENTFD
+	select HAVE_KVM_IRQFD
 	---help---
 	  Support hosting virtualized guest machines.
 
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index c92b26a..b22c636 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -11,7 +11,7 @@ ARM=../../../arch/arm/kvm
 
 obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
 
-kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
+kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/arm.o $(ARM)/mmu.o $(ARM)/mmio.o
 kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
 
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 897c849..c000e97 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -31,6 +31,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
+#include <trace/events/kvm.h>
 
 /*
  * How the whole thing works (courtesy of Christoffer Dall):
@@ -1083,6 +1084,7 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 	u32 status = vgic_get_interrupt_status(vcpu);
 	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
 	bool level_pending = false;
+	struct kvm *kvm = vcpu->kvm;
 
 	kvm_debug("STATUS = %08x\n", status);
 
@@ -1118,6 +1120,17 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 			 */
 			vgic_dist_irq_clear_soft_pend(vcpu, vlr.irq);
 
+			/*
+			 * kvm_notify_acked_irq calls kvm_set_irq()
+			 * to reset the IRQ level. Need to release the
+			 * lock for kvm_set_irq to grab it.
+			 */
+			spin_unlock(&dist->lock);
+
+			kvm_notify_acked_irq(kvm, 0,
+					     vlr.irq - VGIC_NR_PRIVATE_IRQS);
+			spin_lock(&dist->lock);
+
 			/* Any additional pending interrupt? */
 			if (vgic_dist_irq_get_level(vcpu, vlr.irq)) {
 				vgic_cpu_irq_set(vcpu, vlr.irq);
@@ -1913,3 +1926,38 @@ out_free_irq:
 	free_percpu_irq(vgic->maint_irq, kvm_get_running_vcpus());
 	return ret;
 }
+
+int kvm_irq_map_gsi(struct kvm *kvm,
+		    struct kvm_kernel_irq_routing_entry *entries,
+		    int gsi)
+{
+	return gsi;
+}
+
+int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
+{
+	return pin;
+}
+
+int kvm_set_irq(struct kvm *kvm, int irq_source_id,
+		u32 irq, int level, bool line_status)
+{
+	unsigned int spi = irq + VGIC_NR_PRIVATE_IRQS;
+
+	trace_kvm_set_irq(irq, level, irq_source_id);
+
+	BUG_ON(!vgic_initialized(kvm));
+
+	if (spi > kvm->arch.vgic.nr_irqs)
+		return -EINVAL;
+	return kvm_vgic_inject_irq(kvm, 0, spi, level);
+
+}
+
+/* MSI not implemented yet */
+int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
+		struct kvm *kvm, int irq_source_id,
+		int level, bool line_status)
+{
+	return 0;
+}
-- 
2.1.4
