From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v4 13/13] KVM: arm/arm64: implement IRQ bypass consumer
 functions
Date: Thu, 19 Nov 2015 14:54:03 +0000
Message-ID: <1447944843-17731-14-git-send-email-eric.auger@linaro.org>
References: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EB48499D2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NkC5acbgYwT6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2015 09:53:54 -0500 (EST)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2704C49731
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:53:52 -0500 (EST)
Received: by wmec201 with SMTP id c201so29576021wme.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 06:54:32 -0800 (PST)
In-Reply-To: <1447944843-17731-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Implement IRQ bypass callbacks for arm/arm64 IRQ forwarding:
- kvm_arch_irq_bypass_add_producer: perform VGIC/irqchip
  settings for forwarding
- kvm_arch_irq_bypass_del_producer: same for inverse operation
- kvm_arch_irq_bypass_stop: halt guest execution
- kvm_arch_irq_bypass_start: resume guest execution

and set CONFIG_HAVE_KVM_IRQ_BYPASS for arm/arm64.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---
v3 -> v4:
- kvm_set/unset_forward now takes the virtual IRQ ID as a parameter

v2 -> v3:
- kvm_arch_irq_bypass_resume renamed into kvm_arch_irq_bypass_start
- kvm_vgic_unset_forward does not take the active bool param anymore
- kvm_arch_irq_bypass_add_producer now returns an error value
- remove kvm_arch_irq_bypass_update

v1 -> v2:
- struct kvm_kernel_irqfd is retrieved with container_of
- function names changed
---
 arch/arm/kvm/Kconfig   |  1 +
 arch/arm/kvm/arm.c     | 37 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/Kconfig |  1 +
 3 files changed, 39 insertions(+)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 73d7201..4c9a95e 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -34,6 +34,7 @@ config KVM
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
 	select IRQ_BYPASS_MANAGER
+	select HAVE_KVM_IRQ_BYPASS
 	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
 	---help---
 	  Support hosting virtualized guest machines.
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index eab83b2..99517bd 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -27,6 +27,8 @@
 #include <linux/mman.h>
 #include <linux/sched.h>
 #include <linux/kvm.h>
+#include <linux/kvm_irqfd.h>
+#include <linux/irqbypass.h>
 #include <trace/events/kvm.h>
 
 #define CREATE_TRACE_POINTS
@@ -1165,6 +1167,41 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
 	return NULL;
 }
 
+int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
+				      struct irq_bypass_producer *prod)
+{
+	struct kvm_kernel_irqfd *irqfd =
+		container_of(cons, struct kvm_kernel_irqfd, consumer);
+
+	return kvm_vgic_set_forward(irqfd->kvm, prod->irq,
+				    irqfd->gsi + VGIC_NR_PRIVATE_IRQS);
+}
+void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
+				      struct irq_bypass_producer *prod)
+{
+	struct kvm_kernel_irqfd *irqfd =
+		container_of(cons, struct kvm_kernel_irqfd, consumer);
+
+	kvm_vgic_unset_forward(irqfd->kvm, prod->irq,
+			       irqfd->gsi + VGIC_NR_PRIVATE_IRQS);
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
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 64f460d..f6829af 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -38,6 +38,7 @@ config KVM
 	select HAVE_KVM_IRQFD
 	select KVM_ARM_VGIC_V3
 	select IRQ_BYPASS_MANAGER
+	select HAVE_KVM_IRQ_BYPASS
 	---help---
 	  Support hosting virtualized guest machines.
 	  We don't support KVM with 16K page tables yet, due to the multiple
-- 
1.9.1
