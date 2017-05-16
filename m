From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 8/9] KVM: arm/arm64: Disallow userspace control of
 in-kernel IRQ lines
Date: Tue, 16 May 2017 20:45:55 +0200
Message-ID: <20170516184556.26785-9-cdall@linaro.org>
References: <20170516184556.26785-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A0FA540C25
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 14:42:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jv+dIVcV1Biy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 May 2017 14:42:58 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 87A3F40C35
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 14:42:56 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id d127so129521963wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 11:46:24 -0700 (PDT)
In-Reply-To: <20170516184556.26785-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When injecting an IRQ to the VGIC, you now have to present an owner
token for that IRQ line to show that you are the owner of that line.

IRQ lines driven from userspace or via an irqfd do not have an owner and
will simply pass a NULL pointer.

Also get rid of the unused kvm_vgic_inject_mapped_irq prototype.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 include/kvm/arm_vgic.h         |  4 +---
 virt/kvm/arm/arch_timer.c      |  3 ++-
 virt/kvm/arm/arm.c             |  4 ++--
 virt/kvm/arm/pmu.c             |  3 ++-
 virt/kvm/arm/vgic/vgic-irqfd.c |  2 +-
 virt/kvm/arm/vgic/vgic.c       | 15 +++++++++++----
 6 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 5d5b345..131668f 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -300,9 +300,7 @@ int kvm_vgic_hyp_init(void);
 void kvm_vgic_init_cpu_hardware(void);
 
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
-			bool level);
-int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid, unsigned int intid,
-			       bool level);
+			bool level, void *owner);
 int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq);
 int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 528acf0..becd8e7 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -226,7 +226,8 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 	if (likely(irqchip_in_kernel(vcpu->kvm))) {
 		ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
 					  timer_ctx->irq.irq,
-					  timer_ctx->irq.level);
+					  timer_ctx->irq.level,
+					  timer_ctx);
 		WARN_ON(ret);
 	}
 }
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 3417e18..42cb9e8 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -806,7 +806,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 		if (irq_num < VGIC_NR_SGIS || irq_num >= VGIC_NR_PRIVATE_IRQS)
 			return -EINVAL;
 
-		return kvm_vgic_inject_irq(kvm, vcpu->vcpu_id, irq_num, level);
+		return kvm_vgic_inject_irq(kvm, vcpu->vcpu_id, irq_num, level, NULL);
 	case KVM_ARM_IRQ_TYPE_SPI:
 		if (!irqchip_in_kernel(kvm))
 			return -ENXIO;
@@ -814,7 +814,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 		if (irq_num < VGIC_NR_PRIVATE_IRQS)
 			return -EINVAL;
 
-		return kvm_vgic_inject_irq(kvm, 0, irq_num, level);
+		return kvm_vgic_inject_irq(kvm, 0, irq_num, level, NULL);
 	}
 
 	return -EINVAL;
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index c354bd5..006a033 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -238,7 +238,8 @@ static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
 	if (likely(irqchip_in_kernel(vcpu->kvm))) {
 		int ret;
 		ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
-					  pmu->irq_num, overflow);
+					  pmu->irq_num, overflow,
+					  &vcpu->arch.pmu);
 		WARN_ON(ret);
 	}
 }
diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
index f138ed2..b7baf58 100644
--- a/virt/kvm/arm/vgic/vgic-irqfd.c
+++ b/virt/kvm/arm/vgic/vgic-irqfd.c
@@ -34,7 +34,7 @@ static int vgic_irqfd_set_irq(struct kvm_kernel_irq_routing_entry *e,
 
 	if (!vgic_valid_spi(kvm, spi_id))
 		return -EINVAL;
-	return kvm_vgic_inject_irq(kvm, 0, spi_id, level);
+	return kvm_vgic_inject_irq(kvm, 0, spi_id, level, NULL);
 }
 
 /**
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index e9e46f1..01dc4cd 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -234,10 +234,14 @@ static void vgic_sort_ap_list(struct kvm_vcpu *vcpu)
 
 /*
  * Only valid injection if changing level for level-triggered IRQs or for a
- * rising edge.
+ * rising edge, and in-kernel connected IRQ lines can only be controlled by
+ * their owner.
  */
-static bool vgic_validate_injection(struct vgic_irq *irq, bool level)
+static bool vgic_validate_injection(struct vgic_irq *irq, bool level, void *owner)
 {
+	if (irq->owner != owner)
+		return false;
+
 	switch (irq->config) {
 	case VGIC_CONFIG_LEVEL:
 		return irq->line_level != level;
@@ -346,13 +350,16 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
  *			      false: to ignore the call
  *	     Level-sensitive  true:  raise the input signal
  *			      false: lower the input signal
+ * @owner:   The opaque pointer to the owner of the IRQ being raised to verify
+ *           that the caller is allowed to inject this IRQ.  Userspace
+ *           injections will have owner == NULL.
  *
  * The VGIC is not concerned with devices being active-LOW or active-HIGH for
  * level-sensitive interrupts.  You can think of the level parameter as 1
  * being HIGH and 0 being LOW and all devices being active-HIGH.
  */
 int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
-			bool level)
+			bool level, void *owner)
 {
 	struct kvm_vcpu *vcpu;
 	struct vgic_irq *irq;
@@ -374,7 +381,7 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 
 	spin_lock(&irq->irq_lock);
 
-	if (!vgic_validate_injection(irq, level)) {
+	if (!vgic_validate_injection(irq, level, owner)) {
 		/* Nothing to see here, move along... */
 		spin_unlock(&irq->irq_lock);
 		vgic_put_irq(kvm, irq);
-- 
2.9.0
