From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 2/2] KVM: arm/arm64: Merge vgic_set_lr() and
 vgic_sync_lr_elrsr()
Date: Fri, 02 Oct 2015 17:44:29 +0300
Message-ID: <4d9fb027da0d71c9b62bc3ffef1dcd037882ed02.1443796321.git.p.fedin@samsung.com>
References: <cover.1443796321.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F61E43E7A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 10:43:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yZu+nsC54EXe for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Oct 2015 10:42:53 -0400 (EDT)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BFDCC41172
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Oct 2015 10:42:53 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NVL00JIXKYBRI50@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Fri, 02 Oct 2015 15:44:35 +0100 (BST)
In-reply-to: <cover.1443796321.git.p.fedin@samsung.com>
In-reply-to: <cover.1443796321.git.p.fedin@samsung.com>
References: <cover.1443796321.git.p.fedin@samsung.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Now we see that vgic_set_lr() and vgic_sync_lr_elrsr() are always used
together. Merge them into one function, saving from second vgic_ops
dereferencing every time.

Additionally, remove unnecessary vgic_set_lr() in vgic_unqueue_irqs(),
because the following vgic_retire_lr() will reset lr.state to zero
anyway.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 include/kvm/arm_vgic.h |  1 -
 virt/kvm/arm/vgic-v2.c |  5 -----
 virt/kvm/arm/vgic-v3.c |  5 -----
 virt/kvm/arm/vgic.c    | 30 ++++--------------------------
 4 files changed, 4 insertions(+), 37 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index d908028..ab5d242 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -112,7 +112,6 @@ struct vgic_vmcr {
 struct vgic_ops {
 	struct vgic_lr	(*get_lr)(const struct kvm_vcpu *, int);
 	void	(*set_lr)(struct kvm_vcpu *, int, struct vgic_lr);
-	void	(*sync_lr_elrsr)(struct kvm_vcpu *, int, struct vgic_lr);
 	u64	(*get_elrsr)(const struct kvm_vcpu *vcpu);
 	u64	(*get_eisr)(const struct kvm_vcpu *vcpu);
 	void	(*clear_eisr)(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
index 8d7b04d..f9d8da5 100644
--- a/virt/kvm/arm/vgic-v2.c
+++ b/virt/kvm/arm/vgic-v2.c
@@ -79,11 +79,7 @@ static void vgic_v2_set_lr(struct kvm_vcpu *vcpu, int lr,
 		lr_val |= (lr_desc.source << GICH_LR_PHYSID_CPUID_SHIFT);
 
 	vcpu->arch.vgic_cpu.vgic_v2.vgic_lr[lr] = lr_val;
-}
 
-static void vgic_v2_sync_lr_elrsr(struct kvm_vcpu *vcpu, int lr,
-				  struct vgic_lr lr_desc)
-{
 	if (!(lr_desc.state & LR_STATE_MASK))
 		vcpu->arch.vgic_cpu.vgic_v2.vgic_elrsr |= (1ULL << lr);
 	else
@@ -166,7 +162,6 @@ static void vgic_v2_enable(struct kvm_vcpu *vcpu)
 static const struct vgic_ops vgic_v2_ops = {
 	.get_lr			= vgic_v2_get_lr,
 	.set_lr			= vgic_v2_set_lr,
-	.sync_lr_elrsr		= vgic_v2_sync_lr_elrsr,
 	.get_elrsr		= vgic_v2_get_elrsr,
 	.get_eisr		= vgic_v2_get_eisr,
 	.clear_eisr		= vgic_v2_clear_eisr,
diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index 7dd5d62..75f6d91 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -112,11 +112,7 @@ static void vgic_v3_set_lr(struct kvm_vcpu *vcpu, int lr,
 	}
 
 	vcpu->arch.vgic_cpu.vgic_v3.vgic_lr[LR_INDEX(lr)] = lr_val;
-}
 
-static void vgic_v3_sync_lr_elrsr(struct kvm_vcpu *vcpu, int lr,
-				  struct vgic_lr lr_desc)
-{
 	if (!(lr_desc.state & LR_STATE_MASK))
 		vcpu->arch.vgic_cpu.vgic_v3.vgic_elrsr |= (1U << lr);
 	else
@@ -211,7 +207,6 @@ static void vgic_v3_enable(struct kvm_vcpu *vcpu)
 static const struct vgic_ops vgic_v3_ops = {
 	.get_lr			= vgic_v3_get_lr,
 	.set_lr			= vgic_v3_set_lr,
-	.sync_lr_elrsr		= vgic_v3_sync_lr_elrsr,
 	.get_elrsr		= vgic_v3_get_elrsr,
 	.get_eisr		= vgic_v3_get_eisr,
 	.clear_eisr		= vgic_v3_clear_eisr,
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 2f4d25a..7e164eb 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -709,10 +709,8 @@ void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
 		 * interrupt then move the active state to the
 		 * distributor tracking bit.
 		 */
-		if (lr.state & LR_STATE_ACTIVE) {
+		if (lr.state & LR_STATE_ACTIVE)
 			vgic_irq_set_active(vcpu, lr.irq);
-			lr.state &= ~LR_STATE_ACTIVE;
-		}
 
 		/*
 		 * Reestablish the pending state on the distributor and the
@@ -720,17 +718,12 @@ void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
 		 * is fine, then we are only setting a few bits that were
 		 * already set.
 		 */
-		if (lr.state & LR_STATE_PENDING) {
+		if (lr.state & LR_STATE_PENDING)
 			vgic_dist_irq_set_pending(vcpu, lr.irq);
-			lr.state &= ~LR_STATE_PENDING;
-		}
-
-		vgic_set_lr(vcpu, i, lr);
 
 		/*
 		 * Mark the LR as free for other use.
 		 */
-		BUG_ON(lr.state & LR_STATE_MASK);
 		vgic_retire_lr(i, vcpu);
 		vgic_irq_clear_queued(vcpu, lr.irq);
 
@@ -1039,12 +1032,6 @@ static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr,
 	vgic_ops->set_lr(vcpu, lr, vlr);
 }
 
-static void vgic_sync_lr_elrsr(struct kvm_vcpu *vcpu, int lr,
-			       struct vgic_lr vlr)
-{
-	vgic_ops->sync_lr_elrsr(vcpu, lr, vlr);
-}
-
 static inline u64 vgic_get_elrsr(struct kvm_vcpu *vcpu)
 {
 	return vgic_ops->get_elrsr(vcpu);
@@ -1096,7 +1083,6 @@ static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu)
 
 	vlr.state = 0;
 	vgic_set_lr(vcpu, lr_nr, vlr);
-	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
 }
 
 /*
@@ -1160,7 +1146,6 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
 	}
 
 	vgic_set_lr(vcpu, lr_nr, vlr);
-	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
 }
 
 /*
@@ -1380,12 +1365,6 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
 			}
 
 			spin_unlock(&dist->lock);
-
-			/*
-			 * Despite being EOIed, the LR may not have
-			 * been marked as empty.
-			 */
-			vgic_sync_lr_elrsr(vcpu, lr, vlr);
 		}
 	}
 
@@ -1446,8 +1425,6 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	bool level_pending;
 
 	level_pending = vgic_process_maintenance(vcpu);
-	elrsr = vgic_get_elrsr(vcpu);
-	elrsr_ptr = u64_to_bitmask(&elrsr);
 
 	/* Deal with HW interrupts, and clear mappings for empty LRs */
 	for (lr = 0; lr < vgic->nr_lr; lr++) {
@@ -1463,11 +1440,12 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 			vlr.hwirq = 0;
 			vgic_set_lr(vcpu, lr, vlr);
 			vgic_irq_clear_queued(vcpu, vlr.irq);
-			set_bit(lr, elrsr_ptr);
 		}
 	}
 
 	/* Check if we still have something up our sleeve... */
+	elrsr = vgic_get_elrsr(vcpu);
+	elrsr_ptr = u64_to_bitmask(&elrsr);
 	pending = find_first_zero_bit(elrsr_ptr, vgic->nr_lr);
 	if (level_pending || pending < vgic->nr_lr)
 		set_bit(vcpu->vcpu_id, dist->irq_pending_on_cpu);
-- 
2.4.4
