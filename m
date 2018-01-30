From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 1/3] KVM: arm/arm64: Fix incorrect timer_is_pending logic
Date: Tue, 30 Jan 2018 13:42:04 +0100
Message-ID: <20180130124206.12262-2-christoffer.dall@linaro.org>
References: <20180130124206.12262-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180130124206.12262-1-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

After the recently introduced support for level-triggered mapped
interrupt, I accidentally left the VCPU thread busily going back and
forward between the guest and the hypervisor whenever the guest was
blocking, because I would always incorrectly report that a timer
interrupt was pending.

This is because the timer->irq.level field is not valid for mapped
interrupts, where we offload the level state to the hardware, and as a
result this field is always true.

Luckily the problem can be relatively easily solved by not checking the
cached signal state of either timer in kvm_timer_should_fire() but
instead compute the timer state on the fly, which we do already if the
cached signal state wasn't high.  In fact, the only reason for checking
the cached signal state was a tiny optimization which would only be
potentially faster when the polling loop detects a pending timer
interrupt, which is quite unlikely.

Instead of duplicating the logic from kvm_arch_timer_handler(), we
enlighten kvm_timer_should_fire() to report something valid when the
timer state is loaded onto the hardware.  We can then call this from
kvm_arch_timer_handler() as well and avoid the call to
__timer_snapshot_state() in kvm_arch_timer_get_input_level().

Reported-by: Tomasz Nowicki <tn@semihalf.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/arch_timer.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index cfcd0323deab..63cf828f3c4f 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -97,10 +97,9 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
 		pr_warn_once("Spurious arch timer IRQ on non-VCPU thread\n");
 		return IRQ_NONE;
 	}
-	vtimer = vcpu_vtimer(vcpu);
 
-	vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
-	if (kvm_timer_irq_can_fire(vtimer))
+	vtimer = vcpu_vtimer(vcpu);
+	if (kvm_timer_should_fire(vtimer))
 		kvm_timer_update_irq(vcpu, true, vtimer);
 
 	if (static_branch_unlikely(&userspace_irqchip_in_use) &&
@@ -230,6 +229,16 @@ static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 {
 	u64 cval, now;
 
+	if (timer_ctx->loaded) {
+		u32 cnt_ctl;
+
+		/* Only the virtual timer can be loaded so far */
+		cnt_ctl = read_sysreg_el0(cntv_ctl);
+		return  (cnt_ctl & ARCH_TIMER_CTRL_ENABLE) &&
+		        (cnt_ctl & ARCH_TIMER_CTRL_IT_STAT) &&
+		       !(cnt_ctl & ARCH_TIMER_CTRL_IT_MASK);
+	}
+
 	if (!kvm_timer_irq_can_fire(timer_ctx))
 		return false;
 
@@ -244,15 +253,7 @@ bool kvm_timer_is_pending(struct kvm_vcpu *vcpu)
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
-	if (vtimer->irq.level || ptimer->irq.level)
-		return true;
-
-	/*
-	 * When this is called from withing the wait loop of kvm_vcpu_block(),
-	 * the software view of the timer state is up to date (timer->loaded
-	 * is false), and so we can simply check if the timer should fire now.
-	 */
-	if (!vtimer->loaded && kvm_timer_should_fire(vtimer))
+	if (kvm_timer_should_fire(vtimer))
 		return true;
 
 	return kvm_timer_should_fire(ptimer);
@@ -270,9 +271,9 @@ void kvm_timer_update_run(struct kvm_vcpu *vcpu)
 	/* Populate the device bitmap with the timer states */
 	regs->device_irq_level &= ~(KVM_ARM_DEV_EL1_VTIMER |
 				    KVM_ARM_DEV_EL1_PTIMER);
-	if (vtimer->irq.level)
+	if (kvm_timer_should_fire(vtimer))
 		regs->device_irq_level |= KVM_ARM_DEV_EL1_VTIMER;
-	if (ptimer->irq.level)
+	if (kvm_timer_should_fire(ptimer))
 		regs->device_irq_level |= KVM_ARM_DEV_EL1_PTIMER;
 }
 
@@ -507,8 +508,8 @@ bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
 	vlevel = sregs->device_irq_level & KVM_ARM_DEV_EL1_VTIMER;
 	plevel = sregs->device_irq_level & KVM_ARM_DEV_EL1_PTIMER;
 
-	return vtimer->irq.level != vlevel ||
-	       ptimer->irq.level != plevel;
+	return kvm_timer_should_fire(vtimer) != vlevel ||
+	       kvm_timer_should_fire(ptimer) != plevel;
 }
 
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
@@ -801,9 +802,6 @@ bool kvm_arch_timer_get_input_level(int vintid)
 	else
 		BUG(); /* We only map the vtimer so far */
 
-	if (timer->loaded)
-		__timer_snapshot_state(timer);
-
 	return kvm_timer_should_fire(timer);
 }
 
-- 
2.14.2
