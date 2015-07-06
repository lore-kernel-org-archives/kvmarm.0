From: Eric Auger <eric.auger@linaro.org>
Subject: [RFC v2 9/9] KVM: arm/arm64: implement IRQ bypass consumer functions
Date: Mon,  6 Jul 2015 15:24:43 +0200
Message-ID: <1436189083-32527-10-git-send-email-eric.auger@linaro.org>
References: <1436189083-32527-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFF0357B9E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 09:14:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OyQ6SYlvvzDp for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2015 09:14:00 -0400 (EDT)
Received: from mail-wg0-f44.google.com (mail-wg0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E2A9057C02
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2015 09:13:59 -0400 (EDT)
Received: by wguu7 with SMTP id u7so140471812wgu.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 06 Jul 2015 06:25:27 -0700 (PDT)
In-Reply-To: <1436189083-32527-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, avi.kivity@gmail.com, mtosatti@redhat.com, feng.wu@intel.com, joro@8bytes.org, b.reynal@virtualopensystems.com
Cc: pbonzini@redhat.com, alex.williamson@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Implement IRQ bypass callbacks for arm/arm64 IRQ forwarding:
- kvm_arch_irq_bypass_add_producer: perform VGIC/irqchip
  settings for forwarding
- kvm_arch_irq_bypass_del_producer: same for inverse operation
- kvm_arch_irq_bypass_stop: halt guest execution
- kvm_arch_irq_bypass_resume: resume guest execution
- void kvm_arch_irq_bypass_update

and set CONFIG_HAVE_KVM_IRQ_BYPASS for arm/arm64.

Signed-off-by: Eric Auger <eric.auger@linaro.org>

---

v1 -> v2:
- struct kvm_kernel_irqfd is retrieved with container_of
- function names changed
---
 arch/arm/kvm/Kconfig   |  1 +
 arch/arm/kvm/arm.c     | 40 ++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/Kconfig |  1 +
 3 files changed, 42 insertions(+)

diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
index 7d38d25..19114a1 100644
--- a/arch/arm/kvm/Kconfig
+++ b/arch/arm/kvm/Kconfig
@@ -32,6 +32,7 @@ config KVM
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
 	select IRQ_BYPASS_MANAGER
+	select HAVE_KVM_IRQ_BYPASS
 	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
 	---help---
 	  Support hosting virtualized guest machines.
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 46d4ef6..db8f040 100644
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
@@ -1149,6 +1151,44 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
 	return NULL;
 }
 
+void kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
+				      struct irq_bypass_producer *prod)
+{
+	struct kvm_kernel_irqfd *irqfd =
+		container_of(cons, struct kvm_kernel_irqfd, consumer);
+
+	kvm_vgic_set_forward(irqfd->kvm, prod->irq, irqfd->gsi);
+}
+void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
+				      struct irq_bypass_producer *prod)
+{
+	struct kvm_kernel_irqfd *irqfd =
+		container_of(cons, struct kvm_kernel_irqfd, consumer);
+
+	kvm_vgic_unset_forward(irqfd->kvm, prod->irq, irqfd->gsi,
+			       &prod->active);
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
+void kvm_arch_irq_bypass_resume(struct irq_bypass_consumer *cons)
+{
+	struct kvm_kernel_irqfd *irqfd =
+		container_of(cons, struct kvm_kernel_irqfd, consumer);
+
+	kvm_arm_resume_guest(irqfd->kvm);
+}
+
+void kvm_arch_irq_bypass_update(struct irq_bypass_consumer *cons)
+{
+}
+
 /**
  * Initialize Hyp-mode and memory mappings on all CPUs.
  */
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index dfaca85..822551c 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -32,6 +32,7 @@ config KVM
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
 	select IRQ_BYPASS_MANAGER
+	select HAVE_KVM_IRQ_BYPASS
 	---help---
 	  Support hosting virtualized guest machines.
 
-- 
1.9.1
