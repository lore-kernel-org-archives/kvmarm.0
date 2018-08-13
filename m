From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 34/37] KVM: arm/arm64: vgic: Do not use
 spin_lock_irqsave/restore with irq disabled
Date: Mon, 13 Aug 2018 15:57:52 +0100
Message-ID: <20180813145755.16566-35-marc.zyngier@arm.com>
References: <20180813145755.16566-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C8E34A1DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 11:00:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x0psMSg4ifhd for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Aug 2018 11:00:39 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E30724A1D5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Aug 2018 11:00:38 -0400 (EDT)
In-Reply-To: <20180813145755.16566-1-marc.zyngier@arm.com>
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
Cc: Kees Cook <keescook@chromium.org>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Andre Przywara <andre.przywara@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, Jia He <jia.he@hxt-semitech.com>, Catalin Marinas <catalin.marinas@arm.com>, Jia He <hejianet@gmail.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Jia He <hejianet@gmail.com>

kvm_vgic_sync_hwstate is only called with IRQ being disabled.
There is thus no need to call spin_lock_irqsave/restore in
vgic_fold_lr_state and vgic_prune_ap_list.

This patch replace them with the non irq-safe version.

Signed-off-by: Jia He <jia.he@hxt-semitech.com>
Acked-by: Christoffer Dall <christoffer.dall@arm.com>
[maz: commit message tidy-up]
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v2.c |  7 ++++---
 virt/kvm/arm/vgic/vgic-v3.c |  7 ++++---
 virt/kvm/arm/vgic/vgic.c    | 13 +++++++------
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index df5e6a6e3186..69b892abd7dc 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -62,7 +62,8 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_v2_cpu_if *cpuif = &vgic_cpu->vgic_v2;
 	int lr;
-	unsigned long flags;
+
+	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
 	cpuif->vgic_hcr &= ~GICH_HCR_UIE;
 
@@ -83,7 +84,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 
 		irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
 
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		spin_lock(&irq->irq_lock);
 
 		/* Always preserve the active bit */
 		irq->active = !!(val & GICH_LR_ACTIVE_BIT);
@@ -126,7 +127,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 				vgic_irq_set_phys_active(irq, false);
 		}
 
-		spin_unlock_irqrestore(&irq->irq_lock, flags);
+		spin_unlock(&irq->irq_lock);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 530b8491c892..9c0dd234ebe8 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -46,7 +46,8 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 	struct vgic_v3_cpu_if *cpuif = &vgic_cpu->vgic_v3;
 	u32 model = vcpu->kvm->arch.vgic.vgic_model;
 	int lr;
-	unsigned long flags;
+
+	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
 	cpuif->vgic_hcr &= ~ICH_HCR_UIE;
 
@@ -75,7 +76,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 		if (!irq)	/* An LPI could have been unmapped. */
 			continue;
 
-		spin_lock_irqsave(&irq->irq_lock, flags);
+		spin_lock(&irq->irq_lock);
 
 		/* Always preserve the active bit */
 		irq->active = !!(val & ICH_LR_ACTIVE_BIT);
@@ -118,7 +119,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 				vgic_irq_set_phys_active(irq, false);
 		}
 
-		spin_unlock_irqrestore(&irq->irq_lock, flags);
+		spin_unlock(&irq->irq_lock);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
 
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index c22cea678a66..7cfdfbc910e0 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -593,10 +593,11 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 {
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_irq *irq, *tmp;
-	unsigned long flags;
+
+	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
 
 retry:
-	spin_lock_irqsave(&vgic_cpu->ap_list_lock, flags);
+	spin_lock(&vgic_cpu->ap_list_lock);
 
 	list_for_each_entry_safe(irq, tmp, &vgic_cpu->ap_list_head, ap_list) {
 		struct kvm_vcpu *target_vcpu, *vcpuA, *vcpuB;
@@ -637,7 +638,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		/* This interrupt looks like it has to be migrated. */
 
 		spin_unlock(&irq->irq_lock);
-		spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);
+		spin_unlock(&vgic_cpu->ap_list_lock);
 
 		/*
 		 * Ensure locking order by always locking the smallest
@@ -651,7 +652,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 			vcpuB = vcpu;
 		}
 
-		spin_lock_irqsave(&vcpuA->arch.vgic_cpu.ap_list_lock, flags);
+		spin_lock(&vcpuA->arch.vgic_cpu.ap_list_lock);
 		spin_lock_nested(&vcpuB->arch.vgic_cpu.ap_list_lock,
 				 SINGLE_DEPTH_NESTING);
 		spin_lock(&irq->irq_lock);
@@ -676,7 +677,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 
 		spin_unlock(&irq->irq_lock);
 		spin_unlock(&vcpuB->arch.vgic_cpu.ap_list_lock);
-		spin_unlock_irqrestore(&vcpuA->arch.vgic_cpu.ap_list_lock, flags);
+		spin_unlock(&vcpuA->arch.vgic_cpu.ap_list_lock);
 
 		if (target_vcpu_needs_kick) {
 			kvm_make_request(KVM_REQ_IRQ_PENDING, target_vcpu);
@@ -686,7 +687,7 @@ static void vgic_prune_ap_list(struct kvm_vcpu *vcpu)
 		goto retry;
 	}
 
-	spin_unlock_irqrestore(&vgic_cpu->ap_list_lock, flags);
+	spin_unlock(&vgic_cpu->ap_list_lock);
 }
 
 static inline void vgic_fold_lr_state(struct kvm_vcpu *vcpu)
-- 
2.18.0
