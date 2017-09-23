From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v3 19/20] KVM: arm/arm64: Get rid of kvm_timer_flush_hwstate
Date: Sat, 23 Sep 2017 02:42:06 +0200
Message-ID: <20170923004207.22356-20-cdall@linaro.org>
References: <20170923004207.22356-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BB4649C9F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Sep 2017 20:42:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zznaE5P+AtnJ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Sep 2017 20:42:22 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94C8B49C8D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Sep 2017 20:42:22 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id r136so7640192wmf.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Sep 2017 17:42:34 -0700 (PDT)
In-Reply-To: <20170923004207.22356-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Now when both the vtimer and the ptimer when using both the in-kernel
vgic emulation and a userspace IRQ chip are driven by the timer signals
and at the vcpu load/put boundaries, instead of recomputing the timer
state at every entry/exit to/from the guest, we can get entirely rid of
the flush hwstate function.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 include/kvm/arm_arch_timer.h |  1 -
 virt/kvm/arm/arch_timer.c    | 24 ------------------------
 virt/kvm/arm/arm.c           |  1 -
 3 files changed, 26 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 8e5ed54..af29563 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -61,7 +61,6 @@ int kvm_timer_hyp_init(void);
 int kvm_timer_enable(struct kvm_vcpu *vcpu);
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
-void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu);
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu);
 void kvm_timer_update_run(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index aa18a5d..f92459a 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -302,12 +302,6 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
-	/*
-	 * If userspace modified the timer registers via SET_ONE_REG before
-	 * the vgic was initialized, we mustn't set the vtimer->irq.level value
-	 * because the guest would never see the interrupt.  Instead wait
-	 * until we call this function from kvm_timer_flush_hwstate.
-	 */
 	if (unlikely(!timer->enabled))
 		return;
 
@@ -493,24 +487,6 @@ bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
 	       ptimer->irq.level != plevel;
 }
 
-/**
- * kvm_timer_flush_hwstate - prepare timers before running the vcpu
- * @vcpu: The vcpu pointer
- *
- * Check if the virtual timer has expired while we were running in the host,
- * and inject an interrupt if that was the case, making sure the timer is
- * masked or disabled on the host so that we keep executing.  Also schedule a
- * software timer for the physical timer if it is enabled.
- */
-void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
-{
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
-
-	if (unlikely(!timer->enabled))
-		return;
-}
-
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 132d39a..14c50d1 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -656,7 +656,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		local_irq_disable();
 
-		kvm_timer_flush_hwstate(vcpu);
 		kvm_vgic_flush_hwstate(vcpu);
 
 		/*
-- 
2.9.0
