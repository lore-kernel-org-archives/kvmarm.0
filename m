From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 10/10] KVM: arm/arm64: implement IRQ bypass consumer
 functions
Date: Mon, 10 Aug 2015 15:21:04 +0200
Message-ID: <1439212864-12954-11-git-send-email-eric.auger@linaro.org>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DEBA5A6B5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:09:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eayk2wJ1Tq1y for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Aug 2015 09:09:08 -0400 (EDT)
Received: from mail-wi0-f174.google.com (mail-wi0-f174.google.com
 [209.85.212.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E7BD5A6DC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 09:09:08 -0400 (EDT)
Received: by wicja10 with SMTP id ja10so25464008wic.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Aug 2015 06:22:08 -0700 (PDT)
In-Reply-To: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, alex.williamson@redhat.com, feng.wu@intel.com
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
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
 arch/arm/kvm/arm.c     | 35 +++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/Kconfig |  1 +
 3 files changed, 37 insertions(+)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 3c565b9..655d277 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -33,6 +33,7 @@ config KVM
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
 	select IRQ_BYPASS_MANAGER
+	select HAVE_KVM_IRQ_BYPASS
 	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
 	---help---
 	  Support hosting virtualized guest machines.
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 0529b38..7cfc5dc 100644
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
@@ -1149,6 +1151,39 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
 	return NULL;
 }
 
+int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
+				      struct irq_bypass_producer *prod)
+{
+	struct kvm_kernel_irqfd *irqfd =
+		container_of(cons, struct kvm_kernel_irqfd, consumer);
+
+	return kvm_vgic_set_forward(irqfd->kvm, prod->irq, irqfd->gsi);
+}
+void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
+				      struct irq_bypass_producer *prod)
+{
+	struct kvm_kernel_irqfd *irqfd =
+		container_of(cons, struct kvm_kernel_irqfd, consumer);
+
+	kvm_vgic_unset_forward(irqfd->kvm, prod->irq, irqfd->gsi);
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
index 2509539..6f6e7a5 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -33,6 +33,7 @@ config KVM
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
 	select IRQ_BYPASS_MANAGER
+	select HAVE_KVM_IRQ_BYPASS
 	---help---
 	  Support hosting virtualized guest machines.
 
-- 
1.9.1
