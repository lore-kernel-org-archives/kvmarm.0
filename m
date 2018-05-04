From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 1/4] KVM: arm/arm64: vgic: Fix source vcpu issues for GICv2 SGI
Date: Fri,  4 May 2018 17:15:56 +0100
Message-ID: <20180504161559.22852-2-marc.zyngier@arm.com>
References: <20180504161559.22852-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 036C1400D4
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 May 2018 12:07:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id axEvTFKnj9k8 for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 May 2018 12:06:41 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A75E649F87
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 May 2018 12:06:41 -0400 (EDT)
In-Reply-To: <20180504161559.22852-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Valentin Schneider <valentin.schneider@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Now that we make sure we don't inject multiple instances of the
same GICv2 SGI at the same time, we've made another bug more
obvious:

If we exit with an active SGI, we completely lose track of which
vcpu it came from. On the next entry, we restore it with 0 as a
source, and if that wasn't the right one, too bad. While this
doesn't seem to trouble GIC-400, the architectural model gets
offended and doesn't deactivate the interrupt on EOI.

Another connected issue is that we will happilly make pending
an interrupt from another vcpu, overriding the above zero with
something that is just as inconsistent. Don't do that.

The final issue is that we signal a maintenance interrupt when
no pending interrupts are present in the LR. Assuming we've fixed
the two issues above, we end-up in a situation where we keep
exiting as soon as we've reached the active state, and not be
able to inject the following pending.

The fix comes in 3 parts:
- GICv2 SGIs have their source vcpu saved if they are active on
  exit, and restored on entry
- Multi-SGIs cannot go via the Pending+Active state, as this would
  corrupt the source field
- Multi-SGIs are converted to using MI on EOI instead of NPIE

Fixes: 16ca6a607d84bef0 ("KVM: arm/arm64: vgic: Don't populate multiple LRs with the same vintid")
Reported-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h        |  1 +
 virt/kvm/arm/vgic/vgic-mmio.c | 10 +++++++--
 virt/kvm/arm/vgic/vgic-v2.c   | 38 +++++++++++++++++++--------------
 virt/kvm/arm/vgic/vgic-v3.c   | 49 +++++++++++++++++++++++++------------------
 virt/kvm/arm/vgic/vgic.c      | 30 +++++++-------------------
 virt/kvm/arm/vgic/vgic.h      | 14 +++++++++++++
 6 files changed, 81 insertions(+), 61 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 24f03941ada8..e7efe12a81bd 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -131,6 +131,7 @@ struct vgic_irq {
 		u32 mpidr;			/* GICv3 target VCPU */
 	};
 	u8 source;			/* GICv2 SGIs only */
+	u8 active_source;		/* GICv2 SGIs only */
 	u8 priority;
 	enum vgic_irq_config config;	/* Level or edge */
 
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index dbe99d635c80..ff9655cfeb2f 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -289,10 +289,16 @@ static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
 	       irq->vcpu->cpu != -1) /* VCPU thread is running */
 		cond_resched_lock(&irq->irq_lock);
 
-	if (irq->hw)
+	if (irq->hw) {
 		vgic_hw_irq_change_active(vcpu, irq, active, !requester_vcpu);
-	else
+	} else {
+		u32 model = vcpu->kvm->arch.vgic.vgic_model;
+
 		irq->active = active;
+		if (model == KVM_DEV_TYPE_ARM_VGIC_V2 &&
+		    active && vgic_irq_is_sgi(irq->intid))
+			irq->active_source = requester_vcpu->vcpu_id;
+	}
 
 	if (irq->active)
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 45aa433f018f..a5f2e44f1c33 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -37,13 +37,6 @@ void vgic_v2_init_lrs(void)
 		vgic_v2_write_lr(i, 0);
 }
 
-void vgic_v2_set_npie(struct kvm_vcpu *vcpu)
-{
-	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
-
-	cpuif->vgic_hcr |= GICH_HCR_NPIE;
-}
-
 void vgic_v2_set_underflow(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
@@ -71,13 +64,18 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 	int lr;
 	unsigned long flags;
 
-	cpuif->vgic_hcr &= ~(GICH_HCR_UIE | GICH_HCR_NPIE);
+	cpuif->vgic_hcr &= ~GICH_HCR_UIE;
 
 	for (lr = 0; lr < vgic_cpu->used_lrs; lr++) {
 		u32 val = cpuif->vgic_lr[lr];
-		u32 intid = val & GICH_LR_VIRTUALID;
+		u32 cpuid, intid = val & GICH_LR_VIRTUALID;
 		struct vgic_irq *irq;
 
+		/* Extract the source vCPU id from the LR */
+		cpuid = val & GICH_LR_PHYSID_CPUID;
+		cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
+		cpuid &= 7;
+
 		/* Notify fds when the guest EOI'ed a level-triggered SPI */
 		if (lr_signals_eoi_mi(val) && vgic_valid_spi(vcpu->kvm, intid))
 			kvm_notify_acked_irq(vcpu->kvm, 0,
@@ -90,17 +88,16 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 		/* Always preserve the active bit */
 		irq->active = !!(val & GICH_LR_ACTIVE_BIT);
 
+		if (irq->active && vgic_irq_is_sgi(intid))
+			irq->active_source = cpuid;
+
 		/* Edge is the only case where we preserve the pending bit */
 		if (irq->config == VGIC_CONFIG_EDGE &&
 		    (val & GICH_LR_PENDING_BIT)) {
 			irq->pending_latch = true;
 
-			if (vgic_irq_is_sgi(intid)) {
-				u32 cpuid = val & GICH_LR_PHYSID_CPUID;
-
-				cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
+			if (vgic_irq_is_sgi(intid))
 				irq->source |= (1 << cpuid);
-			}
 		}
 
 		/*
@@ -152,8 +149,15 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 	u32 val = irq->intid;
 	bool allow_pending = true;
 
-	if (irq->active)
+	if (irq->active) {
 		val |= GICH_LR_ACTIVE_BIT;
+		if (vgic_irq_is_sgi(irq->intid))
+			val |= irq->active_source << GICH_LR_PHYSID_CPUID_SHIFT;
+		if (vgic_irq_is_multi_sgi(irq)) {
+			allow_pending = false;
+			val |= GICH_LR_EOI;
+		}
+	}
 
 	if (irq->hw) {
 		val |= GICH_LR_HW;
@@ -190,8 +194,10 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 			BUG_ON(!src);
 			val |= (src - 1) << GICH_LR_PHYSID_CPUID_SHIFT;
 			irq->source &= ~(1 << (src - 1));
-			if (irq->source)
+			if (irq->source) {
 				irq->pending_latch = true;
+				val |= GICH_LR_EOI;
+			}
 		}
 	}
 
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 8195f52ae6f0..c7423f3768e5 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -27,13 +27,6 @@ static bool group1_trap;
 static bool common_trap;
 static bool gicv4_enable;
 
-void vgic_v3_set_npie(struct kvm_vcpu *vcpu)
-{
-	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
-
-	cpuif->vgic_hcr |= ICH_HCR_NPIE;
-}
-
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
@@ -55,17 +48,23 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 	int lr;
 	unsigned long flags;
 
-	cpuif->vgic_hcr &= ~(ICH_HCR_UIE | ICH_HCR_NPIE);
+	cpuif->vgic_hcr &= ~ICH_HCR_UIE;
 
 	for (lr = 0; lr < vgic_cpu->used_lrs; lr++) {
 		u64 val = cpuif->vgic_lr[lr];
-		u32 intid;
+		u32 intid, cpuid;
 		struct vgic_irq *irq;
+		bool is_v2_sgi = false;
 
-		if (model == KVM_DEV_TYPE_ARM_VGIC_V3)
+		cpuid = val & GICH_LR_PHYSID_CPUID;
+		cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
+
+		if (model == KVM_DEV_TYPE_ARM_VGIC_V3) {
 			intid = val & ICH_LR_VIRTUAL_ID_MASK;
-		else
+		} else {
 			intid = val & GICH_LR_VIRTUALID;
+			is_v2_sgi = vgic_irq_is_sgi(intid);
+		}
 
 		/* Notify fds when the guest EOI'ed a level-triggered IRQ */
 		if (lr_signals_eoi_mi(val) && vgic_valid_spi(vcpu->kvm, intid))
@@ -81,18 +80,16 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		/* Always preserve the active bit */
 		irq->active = !!(val & ICH_LR_ACTIVE_BIT);
 
+		if (irq->active && is_v2_sgi)
+			irq->active_source = cpuid;
+
 		/* Edge is the only case where we preserve the pending bit */
 		if (irq->config == VGIC_CONFIG_EDGE &&
 		    (val & ICH_LR_PENDING_BIT)) {
 			irq->pending_latch = true;
 
-			if (vgic_irq_is_sgi(intid) &&
-			    model == KVM_DEV_TYPE_ARM_VGIC_V2) {
-				u32 cpuid = val & GICH_LR_PHYSID_CPUID;
-
-				cpuid >>= GICH_LR_PHYSID_CPUID_SHIFT;
+			if (is_v2_sgi)
 				irq->source |= (1 << cpuid);
-			}
 		}
 
 		/*
@@ -133,10 +130,20 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 {
 	u32 model = vcpu->kvm->arch.vgic.vgic_model;
 	u64 val = irq->intid;
-	bool allow_pending = true;
+	bool allow_pending = true, is_v2_sgi;
 
-	if (irq->active)
+	is_v2_sgi = (vgic_irq_is_sgi(irq->intid) &&
+		     model == KVM_DEV_TYPE_ARM_VGIC_V2);
+
+	if (irq->active) {
 		val |= ICH_LR_ACTIVE_BIT;
+		if (is_v2_sgi)
+			val |= irq->active_source << GICH_LR_PHYSID_CPUID_SHIFT;
+		if (vgic_irq_is_multi_sgi(irq)) {
+			allow_pending = false;
+			val |= ICH_LR_EOI;
+		}
+	}
 
 	if (irq->hw) {
 		val |= ICH_LR_HW;
@@ -174,8 +181,10 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
 			BUG_ON(!src);
 			val |= (src - 1) << GICH_LR_PHYSID_CPUID_SHIFT;
 			irq->source &= ~(1 << (src - 1));
-			if (irq->source)
+			if (irq->source) {
 				irq->pending_latch = true;
+				val |= ICH_LR_EOI;
+			}
 		}
 	}
 
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 4b6d72939c42..568c65f852e1 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -719,14 +719,6 @@ static inline void vgic_set_underflow(struct kvm_vcpu *vcpu)
 		vgic_v3_set_underflow(vcpu);
 }
 
-static inline void vgic_set_npie(struct kvm_vcpu *vcpu)
-{
-	if (kvm_vgic_global_state.type == VGIC_V2)
-		vgic_v2_set_npie(vcpu);
-	else
-		vgic_v3_set_npie(vcpu);
-}
-
 /* Requires the ap_list_lock to be held. */
 static int compute_ap_list_depth(struct kvm_vcpu *vcpu,
 				 bool *multi_sgi)
@@ -740,17 +732,15 @@ static int compute_ap_list_depth(struct kvm_vcpu *vcpu,
 	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vgic_cpu->ap_list_lock));
 
 	list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
+		int w;
+
 		spin_lock(&irq->irq_lock);
 		/* GICv2 SGIs can count for more than one... */
-		if (vgic_irq_is_sgi(irq->intid) && irq->source) {
-			int w = hweight8(irq->source);
-
-			count += w;
-			*multi_sgi |= (w > 1);
-		} else {
-			count++;
-		}
+		w = vgic_irq_get_lr_count(irq);
 		spin_unlock(&irq->irq_lock);
+
+		count += w;
+		*multi_sgi |= (w > 1);
 	}
 	return count;
 }
@@ -761,7 +751,6 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_irq *irq;
 	int count;
-	bool npie = false;
 	bool multi_sgi;
 	u8 prio = 0xff;
 
@@ -791,10 +780,8 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 		if (likely(vgic_target_oracle(irq) == vcpu)) {
 			vgic_populate_lr(vcpu, irq, count++);
 
-			if (irq->source) {
-				npie = true;
+			if (irq->source)
 				prio = irq->priority;
-			}
 		}
 
 		spin_unlock(&irq->irq_lock);
@@ -807,9 +794,6 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	if (npie)
-		vgic_set_npie(vcpu);
-
 	vcpu->arch.vgic_cpu.used_lrs = count;
 
 	/* Nuke remaining LRs */
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 830e815748a0..32c25d42c93f 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -110,6 +110,20 @@ static inline bool vgic_irq_is_mapped_level(struct vgic_irq *irq)
 	return irq->config == VGIC_CONFIG_LEVEL && irq->hw;
 }
 
+static inline int vgic_irq_get_lr_count(struct vgic_irq *irq)
+{
+	/* Account for the active state as an interrupt */
+	if (vgic_irq_is_sgi(irq->intid) && irq->source)
+		return hweight8(irq->source) + irq->active;
+
+	return irq_is_pending(irq) || irq->active;
+}
+
+static inline bool vgic_irq_is_multi_sgi(struct vgic_irq *irq)
+{
+	return vgic_irq_get_lr_count(irq) > 1;
+}
+
 /*
  * This struct provides an intermediate representation of the fields contained
  * in the GICH_VMCR and ICH_VMCR registers, such that code exporting the GIC
-- 
2.14.2
