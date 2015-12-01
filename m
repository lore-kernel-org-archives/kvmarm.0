From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 3/3] KVM: arm/arm64: Decouple virtual timer from vGIC
Date: Tue, 01 Dec 2015 13:19:45 +0300
Message-ID: <341e7e63157bc677594fc92ac89cc365c37a3bc5.1448965024.git.p.fedin@samsung.com>
References: <cover.1448965024.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47A07498C9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 05:18:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zCxMJpI71t92 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Dec 2015 05:18:29 -0500 (EST)
Received: from mailout3.w1.samsung.com (mailout3.w1.samsung.com
 [210.118.77.13])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9101F49956
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Dec 2015 05:18:29 -0500 (EST)
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NYO00ARXCP40N50@mailout3.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 01 Dec 2015 10:19:52 +0000 (GMT)
In-reply-to: <cover.1448965024.git.p.fedin@samsung.com>
In-reply-to: <cover.1448965024.git.p.fedin@samsung.com>
References: <cover.1448965024.git.p.fedin@samsung.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Remove dependency on vgic_initialized() and use the newly introduced
infrastructure to send interrupts via the userspace if vGIC is not being
used.

Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
---
 arch/arm/kvm/arm.c        |  8 +-------
 virt/kvm/arm/arch_timer.c | 23 +++++++++++++----------
 2 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 6392a5b..e729068 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -468,13 +468,7 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
-	/*
-	 * Enable the arch timers only if we have an in-kernel VGIC
-	 * and it has been properly initialized, since we cannot handle
-	 * interrupts from the virtual timer with a userspace gic.
-	 */
-	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
-		kvm_timer_enable(kvm);
+	kvm_timer_enable(kvm);
 
 	return 0;
 }
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 69bca18..90c91b0 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -128,15 +128,17 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
 	int ret;
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
-	BUG_ON(!vgic_initialized(vcpu->kvm));
-
 	timer->irq.level = new_level;
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->map->virt_irq,
 				   timer->irq.level);
-	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
-					 timer->map,
-					 timer->irq.level);
-	WARN_ON(ret);
+	if (irqchip_in_kernel(vcpu->kvm)) {
+		ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
+						 timer->map,
+						 timer->irq.level);
+		WARN_ON(ret);
+	} else {
+		vcpu->irq = &timer->irq;
+	}
 }
 
 /*
@@ -149,12 +151,12 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 
 	/*
 	 * If userspace modified the timer registers via SET_ONE_REG before
-	 * the vgic was initialized, we mustn't set the timer->irq.level value
+	 * the timer was initialized, we mustn't set the timer->irq.level value
 	 * because the guest would never see the interrupt.  Instead wait
 	 * until we call this function from kvm_timer_flush_hwstate.
 	 */
-	if (!vgic_initialized(vcpu->kvm))
-	    return;
+	if (!vcpu->kvm->arch.timer.enabled)
+		return;
 
 	if (kvm_timer_should_fire(vcpu) != timer->irq.level)
 		kvm_timer_update_irq(vcpu, !timer->irq.level);
@@ -237,7 +239,8 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	* to ensure that hardware interrupts from the timer triggers a guest
 	* exit.
 	*/
-	if (timer->irq.level || kvm_vgic_map_is_active(vcpu, timer->map))
+	if (timer->irq.level || (irqchip_in_kernel(vcpu->kvm) &&
+				 kvm_vgic_map_is_active(vcpu, timer->map)))
 		phys_active = true;
 	else
 		phys_active = false;
-- 
2.4.4
