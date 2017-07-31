From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 52/59] KVM: arm/arm64: GICv4: Use the doorbell interrupt as
 an unblocking source
Date: Mon, 31 Jul 2017 18:26:30 +0100
Message-ID: <20170731172637.29355-53-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 46A6149C4F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:27:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3Fmntk0a4Gpg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:27:28 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E2CD49C5D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:27:28 -0400 (EDT)
In-Reply-To: <20170731172637.29355-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

The doorbell interrupt is only useful if the vcpu is blocked on WFI.
In all other cases, recieving a doorbell interrupt is just a waste
of cycles.

So let's only enable the doorbell if a vcpu is getting blocked,
and disable it when it is unblocked. This is very similar to
what we're doing for the background timer.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h      |  3 +++
 virt/kvm/arm/arm.c          |  2 ++
 virt/kvm/arm/vgic/vgic-v4.c | 32 +++++++++++++++++++++++++++++++-
 3 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 050f78d4fb42..7b1cc7ff5b42 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -375,4 +375,7 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int irq,
 int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int irq,
 				 struct kvm_kernel_irq_routing_entry *irq_entry);
 
+void kvm_vgic_v4_enable_doorbell(struct kvm_vcpu *vcpu);
+void kvm_vgic_v4_disable_doorbell(struct kvm_vcpu *vcpu);
+
 #endif /* __KVM_ARM_VGIC_H */
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 6803ea27c47d..5dbc8dc8fbf4 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -316,11 +316,13 @@ int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 	kvm_timer_schedule(vcpu);
+	kvm_vgic_v4_enable_doorbell(vcpu);
 }
 
 void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 {
 	kvm_timer_unschedule(vcpu);
+	kvm_vgic_v4_disable_doorbell(vcpu);
 }
 
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 6af3cde6d7d4..50721c4e3da5 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -16,6 +16,7 @@
  */
 
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/irqdomain.h>
 #include <linux/kvm_host.h>
 
@@ -73,6 +74,14 @@ int vgic_v4_init(struct kvm *kvm)
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		int irq = dist->its_vm.vpes[i]->irq;
 
+		/*
+		 * Don't automatically enable the doorbell, as we're
+		 * flipping it back and forth when the vcpu gets
+		 * blocked. Also disable the lazy disabling, as the
+		 * doorbell could kick us out of the guest too
+		 * early...
+		 */
+		irq_set_status_flags(irq, IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY);
 		ret = request_irq(irq, vgic_v4_doorbell_handler,
 				  0, "vcpu", vcpu);
 		if (ret) {
@@ -98,7 +107,10 @@ void vgic_v4_teardown(struct kvm *kvm)
 
 	for (i = 0; i < its_vm->nr_vpes; i++) {
 		struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, i);
-		free_irq(its_vm->vpes[i]->irq, vcpu);
+		int irq = its_vm->vpes[i]->irq;
+
+		irq_clear_status_flags(irq, IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY);
+		free_irq(irq, vcpu);
 	}
 
 	its_free_vcpu_irqs(its_vm);
@@ -211,3 +223,21 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int virq,
 	mutex_unlock(&its->its_lock);
 	return ret;
 }
+
+void kvm_vgic_v4_enable_doorbell(struct kvm_vcpu *vcpu)
+{
+	if (vgic_is_v4_capable(vcpu->kvm)) {
+		int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
+		if (irq)
+			enable_irq(irq);
+	}
+}
+
+void kvm_vgic_v4_disable_doorbell(struct kvm_vcpu *vcpu)
+{
+	if (vgic_is_v4_capable(vcpu->kvm)) {
+		int irq = vcpu->arch.vgic_cpu.vgic_v3.its_vpe.irq;
+		if (irq)
+			disable_irq(irq);
+	}
+}
-- 
2.11.0
