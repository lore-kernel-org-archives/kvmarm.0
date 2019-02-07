From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 03/11] KVM: arm/arm64: vgic: Make vgic_cpu->ap_list_lock a
 raw_spinlock
Date: Thu,  7 Feb 2019 13:18:35 +0000
Message-ID: <20190207131843.157210-4-marc.zyngier@arm.com>
References: <20190207131843.157210-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E5874A44B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Feb 2019 08:19:10 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L2NWrgvCHsAa for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Feb 2019 08:19:09 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 423804A469
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Feb 2019 08:19:06 -0500 (EST)
In-Reply-To: <20190207131843.157210-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Richard Henderson <richard.henderson@linaro.org>, Masami Hiramatsu <mhiramat@kernel.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Julien Thierry <julien.thierry@arm.com>

vgic_cpu->ap_list_lock must always be taken with interrupts disabled as
it is used in interrupt context.

For configurations such as PREEMPT_RT_FULL, this means that it should
be a raw_spinlock since RT spinlocks are interruptible.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 include/kvm/arm_vgic.h        |  2 +-
 virt/kvm/arm/vgic/vgic-init.c |  2 +-
 virt/kvm/arm/vgic/vgic.c      | 37 ++++++++++++++++++-----------------
 3 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 32954e115796..c36c86f1ec9a 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -307,7 +307,7 @@ struct vgic_cpu {
 	unsigned int used_lrs;
 	struct vgic_irq private_irqs[VGIC_NR_PRIVATE_IRQS];
 
-	spinlock_t ap_list_lock;	/* Protects the ap_list */
+	raw_spinlock_t ap_list_lock;	/* Protects the ap_list */
 
 	/*
 	 * List of IRQs that this VCPU should consider because they are either
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 330c1ada7326..dfbfcb1fe933 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -206,7 +206,7 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
 	vgic_cpu->sgi_iodev.base_addr = VGIC_ADDR_UNDEF;
 
 	INIT_LIST_HEAD(&vgic_cpu->ap_list_head);
-	spin_lock_init(&vgic_cpu->ap_list_lock);
+	raw_spin_lock_init(&vgic_cpu->ap_list_lock);
 
 	/*
 	 * Enable and configure all SGIs to be edge-triggered and
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index ea54a1923c4f..abd9c7352677 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -54,11 +54,11 @@ struct vgic_global kvm_vgic_global_state __ro_after_init = {
  * When taking more than one ap_list_lock at the same time, always take the
  * lowest numbered VCPU's ap_list_lock first, so:
  *   vcpuX->vcpu_id < vcpuY->vcpu_id:
- *     spin_lock(vcpuX->arch.vgic_cpu.ap_list_lock);
- *     spin_lock(vcpuY->arch.vgic_cpu.ap_list_lock);
+ *     raw_spin_lock(vcpuX->arch.vgic_cpu.ap_list_lock);
+ *     raw_spin_lock(vcpuY->arch.vgic_cpu.ap_list_lock);
  *
  * Since the VGIC must support injecting virtual interrupts from ISRs, we have
- * to use the spin_lock_irqsave/spin_unlock_irqrestore versions of outer
+ * to use the raw_spin_lock_irqsave/raw_spin_unlock_irqrestore versions of outer
  * spinlocks for any lock that may be taken while injecting an interrupt.
  */
 
@@ -351,7 +351,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 
 	/* someone can do stuff here, which we re-check below */
 
-	spin_lock_irqsave(&vcpu->arch.vgic_cpu.ap_list_lock, flags);
+	raw_spin_lock_irqsave(&vcpu->arch.vgic_cpu.ap_list_lock, flags);
 	raw_spin_lock(&irq->irq_lock);
 
 	/*
@@ -368,7 +368,8 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 
 	if (unlikely(irq->vcpu || vcpu != vgic_target_oracle(irq))) {
 		raw_spin_unlock(&irq->irq_lock);
-		spin_unlock_irqrestore(&vcpu->arch.vgic_cpu.ap_list_lock, flags);
+		raw_spin_unlock_irqrestore(&vcpu->arch.vgic_cpu.ap_list_lock,
+					   flags);
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		goto retry;
@@ -383,7 +384,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 	irq->vcpu = vcpu;
 
 	raw_spin_unlock(&irq->irq_lock);
-	spin_unlock_irqrestore(&vcpu->arch.vgic_cpu.ap_list_lock, flags);
+	raw_spin_unlock_irqrestore(&vcpu->arch.vgic_cpu.ap_list_lock, flags);
 
 	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
 	kvm_vcpu_kick(vcpu);
@@ -597,7 +598,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
 retry:
-	spin_lock(&vgic_cpu->ap_list_lock);
+	raw_spin_lock(&vgic_cpu->ap_list_lock);
 
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
 		struct kvm_vcpu *target_vcpu, *vcpuA, *vcpuB;
@@ -638,7 +639,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		/* This interrupt looks like it has to be migrated. */
 
 		raw_spin_unlock(&irq->irq_lock);
-		spin_unlock(&vgic_cpu->ap_list_lock);
+		raw_spin_unlock(&vgic_cpu->ap_list_lock);
 
 		/*
 		 * Ensure locking order by always locking the smallest
@@ -652,9 +653,9 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 			vcpuB = vcpu;
 		}
 
-		spin_lock(&vcpuA->arch.vgic_cpu.ap_list_lock);
-		spin_lock_nested(&vcpuB->arch.vgic_cpu.ap_list_lock,
-				 SINGLE_DEPTH_NESTING);
+		raw_spin_lock(&vcpuA->arch.vgic_cpu.ap_list_lock);
+		raw_spin_lock_nested(&vcpuB->arch.vgic_cpu.ap_list_lock,
+				      SINGLE_DEPTH_NESTING);
 		raw_spin_lock(&irq->irq_lock);
 
 		/*
@@ -676,8 +677,8 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		}
 
 		raw_spin_unlock(&irq->irq_lock);
-		spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
-		spin_unlock(&vcpuA->arch.vgic_cpu.ap_list_lock);
+		raw_spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
+		raw_spin_unlock(&vcpuA->arch.vgic_cpu.ap_list_lock);
 
 		if (target_vcpu_needs_kick) {
 			kvm_make_request(KVM_REQ_IRQ_PENDING, target_vcpu);
@@ -687,7 +688,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		goto retry;
 	}
 
-	spin_unlock(&vgic_cpu->ap_list_lock);
+	raw_spin_unlock(&vgic_cpu->ap_list_lock);
 }
 
 static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
@@ -872,9 +873,9 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
-	spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
+	raw_spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
 	vgic_flush_lr_state(vcpu);
-	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
+	raw_spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
 
 	if (can_access_vgic_from_kernel())
 		vgic_restore_state(vcpu);
@@ -918,7 +919,7 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 
 	vgic_get_vmcr(vcpu, &vmcr);
 
-	spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
+	raw_spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
 
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
 		raw_spin_lock(&irq->irq_lock);
@@ -931,7 +932,7 @@ int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu)
 			break;
 	}
 
-	spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);
+	raw_spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);
 
 	return pending;
 }
-- 
2.20.1
