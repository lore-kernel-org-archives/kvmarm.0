From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH] KVM: arm/arm64: vgic: leave the LR active state on
 GICD_ICENABLERn access
Date: Thu, 19 Nov 2015 14:52:27 +0000
Message-ID: <1447944747-17689-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27213498D9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:51:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ec4EDsaIGU1F for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Nov 2015 09:51:58 -0500 (EST)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED78B498C9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 09:51:57 -0500 (EST)
Received: by wmww144 with SMTP id w144so241760428wmw.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Nov 2015 06:52:37 -0800 (PST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently on clear-enable MMIO we retire the corresponding LR whatever
its state. More precisely we do not sync ACTIVE state but we erase the LR
state.

In case of a forwarded IRQ, the physical IRQ source is also erased meaning
the physical IRQ will never be deactivated. In case of a non forwarded
IRQ, the LR can be reused (since the state was reset) and the guest can
deactivate an IRQ that is not marked in the LR anymore.

This patch adds a parameter to vgic_retire_lr that makes possible to select
the type of the LR that must be retired.  unqueue will retire/sync all LR's
while disable will leave the active LR's.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
---
 virt/kvm/arm/vgic.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 5335383..bc30d93 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -105,7 +105,7 @@
 #include "vgic.h"
 
 static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu);
-static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu);
+static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu, unsigned state);
 static struct vgic_lr vgic_get_lr(const struct kvm_vcpu *vcpu, int lr);
 static void vgic_set_lr(struct kvm_vcpu *vcpu, int lr, struct vgic_lr lr_desc);
 static u64 vgic_get_elrsr(struct kvm_vcpu *vcpu);
@@ -713,18 +713,10 @@ void vgic_unqueue_irqs(struct kvm_vcpu *vcpu)
 			add_sgi_source(vcpu, lr.irq, lr.source);
 
 		/*
-		 * If the LR holds an active (10) or a pending and active (11)
-		 * interrupt then move the active state to the
-		 * distributor tracking bit.
+		 * retire pending, active, active and pending LR's and
+		 * sync their state back to the distributor
 		 */
-		if (lr.state & LR_STATE_ACTIVE)
-			vgic_irq_set_active(vcpu, lr.irq);
-
-		/*
-		 * Reestablish the pending state on the distributor and the
-		 * CPU interface and mark the LR as free for other use.
-		 */
-		vgic_retire_lr(i, vcpu);
+		vgic_retire_lr(i, vcpu, LR_STATE_ACTIVE | LR_STATE_PENDING);
 
 		/* Finally update the VGIC state. */
 		vgic_update_state(vcpu->kvm);
@@ -1077,22 +1069,25 @@ static inline void vgic_enable(struct kvm_vcpu *vcpu)
 	vgic_ops->enable(vcpu);
 }
 
-static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu)
+static void vgic_retire_lr(int lr_nr, struct kvm_vcpu *vcpu, unsigned state)
 {
 	struct vgic_lr vlr = vgic_get_lr(vcpu, lr_nr);
 
-	vgic_irq_clear_queued(vcpu, vlr.irq);
+	if (vlr.state & LR_STATE_ACTIVE & state) {
+		vgic_irq_set_active(vcpu, vlr.irq);
+		vlr.state &= ~LR_STATE_ACTIVE;
+	}
 
-	/*
-	 * We must transfer the pending state back to the distributor before
-	 * retiring the LR, otherwise we may loose edge-triggered interrupts.
-	 */
-	if (vlr.state & LR_STATE_PENDING) {
+	if (vlr.state & LR_STATE_PENDING & state) {
 		vgic_dist_irq_set_pending(vcpu, vlr.irq);
-		vlr.hwirq = 0;
+		vlr.state &= ~LR_STATE_PENDING;
 	}
 
-	vlr.state = 0;
+	if (!(vlr.state & LR_STATE_MASK)) {
+		vlr.hwirq = 0;
+		vlr.state = 0;
+		vgic_irq_clear_queued(vcpu, vlr.irq);
+	}
 	vgic_set_lr(vcpu, lr_nr, vlr);
 }
 
@@ -1114,8 +1109,14 @@ static void vgic_retire_disabled_irqs(struct kvm_vcpu *vcpu)
 	for_each_clear_bit(lr, elrsr_ptr, vgic->nr_lr) {
 		struct vgic_lr vlr = vgic_get_lr(vcpu, lr);
 
+		/*
+		 * retire pending only LR's and sync their state
+		 * back to the distributor. Active LR's cannot be
+		 * retired since the guest will attempt to deactivate
+		 * the IRQ.
+		 */
 		if (!vgic_irq_is_enabled(vcpu, vlr.irq))
-			vgic_retire_lr(lr, vcpu);
+			vgic_retire_lr(lr, vcpu, LR_STATE_PENDING);
 	}
 }
 
-- 
1.9.1
