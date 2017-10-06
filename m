From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 01/26] KVM: arm/arm64: register irq bypass consumer on ARM/ARM64
Date: Fri,  6 Oct 2017 16:33:36 +0100
Message-ID: <20171006153401.5481-2-marc.zyngier@arm.com>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171006153401.5481-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Shanker Donthineni <shankerd@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>, Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

This patch selects IRQ_BYPASS_MANAGER and HAVE_KVM_IRQ_BYPASS
configs for ARM/ARM64.

kvm_arch_has_irq_bypass() now is implemented and returns true.
As a consequence the irq bypass consumer will be registered for
ARM/ARM64 with the forwarding callbacks:

- stop/start: halt/resume guest execution
- add/del_producer: set/unset forwarding at vgic/irqchip level

We don't have any actual support yet, so nothing gets actually
forwarded.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
[maz: dropped the DEOI stuff for the time being in order to
      reduce the dependency chain, amended commit message]
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/Kconfig   |  3 +++
 arch/arm64/kvm/Kconfig |  3 +++
 virt/kvm/arm/arm.c     | 40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 90d0176fb30d..4e2b192a030a 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -3,6 +3,7 @@
 #
 
 source "virt/kvm/Kconfig"
+source "virt/lib/Kconfig"
 
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
@@ -35,6 +36,8 @@ config KVM
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
 	select HAVE_KVM_MSI
+	select IRQ_BYPASS_MANAGER
+	select HAVE_KVM_IRQ_BYPASS
 	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
 	---help---
 	  Support hosting virtualized guest machines.
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 52cb7ad9b2fd..7e0d6e63cc71 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -3,6 +3,7 @@
 #
 
 source "virt/kvm/Kconfig"
+source "virt/lib/Kconfig"
 
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
@@ -35,6 +36,8 @@ config KVM
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
+	select IRQ_BYPASS_MANAGER
+	select HAVE_KVM_IRQ_BYPASS
 	---help---
 	  Support hosting virtualized guest machines.
 	  We don't support KVM with 16K page tables yet, due to the multiple
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index b9f68e4add71..7ac4ecba9ebd 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -27,6 +27,8 @@
 #include <linux/mman.h>
 #include <linux/sched.h>
 #include <linux/kvm.h>
+#include <linux/kvm_irqfd.h>
+#include <linux/irqbypass.h>
 #include <trace/events/kvm.h>
 #include <kvm/arm_pmu.h>
 
@@ -1449,6 +1451,44 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
 	return NULL;
 }
 
+bool kvm_arch_has_irq_bypass(void)
+{
+	return true;
+}
+
+int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
+				      struct irq_bypass_producer *prod)
+{
+	struct kvm_kernel_irqfd *irqfd =
+		container_of(cons, struct kvm_kernel_irqfd, consumer);
+
+	return 0;
+}
+void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
+				      struct irq_bypass_producer *prod)
+{
+	struct kvm_kernel_irqfd *irqfd =
+		container_of(cons, struct kvm_kernel_irqfd, consumer);
+
+	return;
+}
+
+void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *cons)
+{
+	struct kvm_kernel_irqfd *irqfd =
+		container_of(cons, struct kvm_kernel_irqfd, consumer);
+
+	kvm_arm_halt_guest(irqfd->kvm);
+}
+
+void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *cons)
+{
+	struct kvm_kernel_irqfd *irqfd =
+		container_of(cons, struct kvm_kernel_irqfd, consumer);
+
+	kvm_arm_resume_guest(irqfd->kvm);
+}
+
 /**
  * Initialize Hyp-mode and memory mappings on all CPUs.
  */
-- 
2.14.1
