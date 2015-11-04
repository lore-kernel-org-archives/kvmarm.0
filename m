From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 21/21] KVM: arm/arm64: Merge vgic_set_lr() and vgic_sync_lr_elrsr()
Date: Wed,  4 Nov 2015 15:50:00 +0100
Message-ID: <1446648600-27297-22-git-send-email-christoffer.dall@linaro.org>
References: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Pavel Fedin <p.fedin@samsung.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Pavel Fedin <p.fedin@samsung.com>

Now we see that vgic_set_lr() and vgic_sync_lr_elrsr() are always used
together. Merge them into one function, saving from second vgic_ops
dereferencing every time.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/arm_vgic.h |  1 -
 virt/kvm/arm/vgic-v2.c |  5 -----
 virt/kvm/arm/vgic-v3.c |  5 -----
 virt/kvm/arm/vgic.c    | 14 ++------------
 4 files changed, 2 insertions(+), 23 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 3936bf8..f62addc 100644
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
index c0f5d7f..ff02f08 100644
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
@@ -167,7 +163,6 @@ static void vgic_v2_enable(struct kvm_vcpu *vcpu)
 static const struct vgic_ops vgic_v2_ops = {
 	.get_lr			= vgic_v2_get_lr,
 	.set_lr			= vgic_v2_set_lr,
-	.sync_lr_elrsr		= vgic_v2_sync_lr_elrsr,
 	.get_elrsr		= vgic_v2_get_elrsr,
 	.get_eisr		= vgic_v2_get_eisr,
 	.clear_eisr		= vgic_v2_clear_eisr,
diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index 92003cb..487d635 100644
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
@@ -212,7 +208,6 @@ static void vgic_v3_enable(struct kvm_vcpu *vcpu)
 static const struct vgic_ops vgic_v3_ops = {
 	.get_lr			= vgic_v3_get_lr,
 	.set_lr			= vgic_v3_set_lr,
-	.sync_lr_elrsr		= vgic_v3_sync_lr_elrsr,
 	.get_elrsr		= vgic_v3_get_elrsr,
 	.get_eisr		= vgic_v3_get_eisr,
 	.clear_eisr		= vgic_v3_clear_eisr,
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 96e45f3..fe451d4 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1032,12 +1032,6 @@ static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr,
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
@@ -1100,7 +1094,6 @@ static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu)
 
 	vlr.state = 0;
 	vgic_set_lr(vcpu, lr_nr, vlr);
-	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
 }
 
 /*
@@ -1162,7 +1155,6 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
 	}
 
 	vgic_set_lr(vcpu, lr_nr, vlr);
-	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
 }
 
 /*
@@ -1340,8 +1332,6 @@ static int process_queued_irq(struct kvm_vcpu *vcpu,
 	vlr.hwirq = 0;
 	vgic_set_lr(vcpu, lr, vlr);
 
-	vgic_sync_lr_elrsr(vcpu, lr, vlr);
-
 	return pending;
 }
 
@@ -1442,8 +1432,6 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	bool level_pending;
 
 	level_pending = vgic_process_maintenance(vcpu);
-	elrsr = vgic_get_elrsr(vcpu);
-	elrsr_ptr = u64_to_bitmask(&elrsr);
 
 	/* Deal with HW interrupts, and clear mappings for empty LRs */
 	for (lr = 0; lr < vgic->nr_lr; lr++) {
@@ -1454,6 +1442,8 @@ static void __kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 	}
 
 	/* Check if we still have something up our sleeve... */
+	elrsr = vgic_get_elrsr(vcpu);
+	elrsr_ptr = u64_to_bitmask(&elrsr);
 	pending = find_first_zero_bit(elrsr_ptr, vgic->nr_lr);
 	if (level_pending || pending < vgic->nr_lr)
 		set_bit(vcpu->vcpu_id, dist->irq_pending_on_cpu);
-- 
2.1.2.330.g565301e.dirty

