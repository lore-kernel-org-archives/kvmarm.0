From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 17/26] KVM: arm/arm64: Get rid of kvm_timer_flush_hwstate
Date: Tue,  7 Nov 2017 11:47:50 +0100
Message-ID: <20171107104800.30021-18-christoffer.dall@linaro.org>
References: <20171107104800.30021-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171107104800.30021-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

Now when both the vtimer and the ptimer when using both the in-kernel
vgic emulation and a userspace IRQ chip are driven by the timer signals
and at the vcpu load/put boundaries, instead of recomputing the timer
state at every entry/exit to/from the guest, we can get entirely rid of
the flush hwstate function.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_arch_timer.h |  1 -
 virt/kvm/arm/arch_timer.c    | 24 ------------------------
 virt/kvm/arm/arm.c           |  1 -
 3 files changed, 26 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index c538f707e1c1..2352f3a4e88b 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -66,7 +66,6 @@ int kvm_timer_hyp_init(void);
 int kvm_timer_enable(struct kvm_vcpu *vcpu);
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
-void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu);
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu);
 void kvm_timer_update_run(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 20e56c420632..53d9bd4a734f 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -305,12 +305,6 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
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
 
@@ -489,24 +483,6 @@ bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
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
index 132d39ae13d2..14c50d142c67 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -656,7 +656,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 		local_irq_disable();
 
-		kvm_timer_flush_hwstate(vcpu);
 		kvm_vgic_flush_hwstate(vcpu);
 
 		/*
-- 
2.14.2
