From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 01/27] KVM: arm/arm64: register irq bypass consumer on ARM/ARM64
Date: Mon, 13 Nov 2017 10:17:26 +0100
Message-ID: <20171113091752.10663-2-christoffer.dall@linaro.org>
References: <20171113091752.10663-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2530049D4B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:15:46 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EqubJRQMwLdU for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Nov 2017 04:15:45 -0500 (EST)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DF4D49D95
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 04:15:45 -0500 (EST)
Received: by mail-wm0-f66.google.com with SMTP id r68so13643872wmr.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Nov 2017 01:17:55 -0800 (PST)
In-Reply-To: <20171113091752.10663-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
[maz: dropped the DEOI stuff for the time being in order to
      reduce the dependency chain, amended commit message]
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
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
index bc126fb99a3d..79f8ddd604c1 100644
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
 
@@ -1458,6 +1460,44 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
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
2.14.2
