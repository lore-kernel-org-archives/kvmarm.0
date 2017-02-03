From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 3/5] KVM: arm/arm64: Support arch timers with a userspace
 gic
Date: Fri,  3 Feb 2017 15:56:53 +0100
Message-ID: <20170203145655.15007-4-cdall@linaro.org>
References: <20170203145655.15007-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8862C40A6A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Feb 2017 09:56:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H8O5Jka3dVPu for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Feb 2017 09:56:41 -0500 (EST)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2224C40A86
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Feb 2017 09:56:39 -0500 (EST)
Received: by mail-wm0-f41.google.com with SMTP id r141so31152264wmg.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 03 Feb 2017 06:57:04 -0800 (PST)
In-Reply-To: <20170203145655.15007-1-cdall@linaro.org>
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
Cc: kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Pekka Enberg <penberg@iki.fi>
List-Id: kvmarm@lists.cs.columbia.edu

If you're running with a userspace gic or other interrupt constroller
(that is no vgic in the kernel), then you have so far not been able to
use the architected timers, because the output of the architected
timers, which are driven inside the kernel, was a kernel-only construct
between the arch timer code and the vgic.

This patch implements the new KVM_CAP_ARM_USER_IRQ feature, where we use a
side channel on the kvm_run structure, run->s.regs.device_irq_level, to
always notify userspace of the timer output levels when using a userspace
irqchip.

This works by ensureing that before we enter the guest, if the timer
output level has changed compared to what we last told userspace, we
don't enter the guest, but instead return to userspace to notify it of
the new level.  If we are exiting, because of an MMIO for example, and
the level changed at the same time, the value is also updated and
userspace can sample the line as it needs.  This is nicely achieved
simply always updating the timer_irq_level field after the main run
loop.

Note that the kvm_timer_update_irq trace event is changed to show the
host IRQ number for the timer instead of the guest IRQ number, because
the kernel no longer know which IRQ userspace wires up the timer signal
to.

Also note that this patch implements all required functionality but does
not yet advertise the capability.

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c           |  18 +++----
 include/kvm/arm_arch_timer.h |   2 +
 virt/kvm/arm/arch_timer.c    | 121 +++++++++++++++++++++++++++++++++++--------
 3 files changed, 110 insertions(+), 31 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 21c493a..505f928 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -513,13 +513,7 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
-	/*
-	 * Enable the arch timers only if we have an in-kernel VGIC
-	 * and it has been properly initialized, since we cannot handle
-	 * interrupts from the virtual timer with a userspace gic.
-	 */
-	if (irqchip_in_kernel(kvm) && vgic_initialized(kvm))
-		ret = kvm_timer_enable(vcpu);
+	ret = kvm_timer_enable(vcpu);
 
 	return ret;
 }
@@ -633,9 +627,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		local_irq_disable();
 
 		/*
-		 * Re-check atomic conditions
+		 * If we have a singal pending, or need to notify a userspace
+		 * irqchip about timer level changes, then we exit (and update
+		 * the timer level state in kvm_timer_update_run below).
 		 */
-		if (signal_pending(current)) {
+		if (signal_pending(current) ||
+		    kvm_timer_should_notify_user(vcpu)) {
 			ret = -EINTR;
 			run->exit_reason = KVM_EXIT_INTR;
 		}
@@ -707,6 +704,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		ret = handle_exit(vcpu, run, ret);
 	}
 
+	/* Tell userspace about in-kernel device output levels */
+	kvm_timer_update_run(vcpu);
+
 	if (vcpu->sigset_active)
 		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 	return ret;
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index fe797d6..295584f 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -63,6 +63,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu);
+bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu);
+void kvm_timer_update_run(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu);
 
 u64 kvm_arm_timer_get_reg(struct kvm_vcpu *, u64 regid);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 5099b30..5dc2167 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -184,6 +184,27 @@ bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 	return cval <= now;
 }
 
+/*
+ * Reflect the timer output level into the kvm_run structure
+ */
+void kvm_timer_update_run(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+	struct kvm_sync_regs *regs = &vcpu->run->s.regs;
+
+	if (likely(irqchip_in_kernel(vcpu->kvm)))
+		return;
+
+	/* Populate the device bitmap with the timer states */
+	regs->device_irq_level &= ~(KVM_ARM_DEV_EL1_VTIMER |
+				    KVM_ARM_DEV_EL1_PTIMER);
+	if (vtimer->irq.level)
+		regs->device_irq_level |= KVM_ARM_DEV_EL1_VTIMER;
+	if (ptimer->irq.level)
+		regs->device_irq_level |= KVM_ARM_DEV_EL1_PTIMER;
+}
+
 static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 				 struct arch_timer_context *timer_ctx)
 {
@@ -194,9 +215,12 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_ctx->irq.irq,
 				   timer_ctx->irq.level);
 
-	ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id, timer_ctx->irq.irq,
-				  timer_ctx->irq.level);
-	WARN_ON(ret);
+	if (likely(irqchip_in_kernel(vcpu->kvm))) {
+		ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
+					  timer_ctx->irq.irq,
+					  timer_ctx->irq.level);
+		WARN_ON(ret);
+	}
 }
 
 /*
@@ -215,7 +239,7 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	 * because the guest would never see the interrupt.  Instead wait
 	 * until we call this function from kvm_timer_flush_hwstate.
 	 */
-	if (!timer->enabled)
+	if (unlikely(!timer->enabled))
 		return;
 
 	if (kvm_timer_should_fire(vtimer) != vtimer->irq.level)
@@ -282,27 +306,12 @@ void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
 	timer_disarm(timer);
 }
 
-/**
- * kvm_timer_flush_hwstate - prepare to move the virt timer to the cpu
- * @vcpu: The vcpu pointer
- *
- * Check if the virtual timer has expired while we were running in the host,
- * and inject an interrupt if that was the case.
- */
-void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
+static void kvm_timer_flush_hwstate_vgic(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	bool phys_active;
 	int ret;
 
-	if (unlikely(!timer->enabled))
-		return;
-
-	kvm_timer_update_state(vcpu);
-
-	/* Set the background timer for the physical timer emulation. */
-	kvm_timer_emulate(vcpu, vcpu_ptimer(vcpu));
-
 	/*
 	* If we enter the guest with the virtual input level to the VGIC
 	* asserted, then we have already told the VGIC what we need to, and
@@ -354,11 +363,72 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	vtimer->active_cleared_last = !phys_active;
 }
 
+bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+	struct kvm_sync_regs *sregs = &vcpu->run->s.regs;
+	bool vlevel, plevel;
+
+	if (likely(irqchip_in_kernel(vcpu->kvm)))
+		return false;
+
+	vlevel = sregs->device_irq_level & KVM_ARM_DEV_EL1_VTIMER;
+	plevel = sregs->device_irq_level & KVM_ARM_DEV_EL1_PTIMER;
+
+	return vtimer->irq.level != vlevel ||
+	       ptimer->irq.level != plevel;
+}
+
+static void kvm_timer_flush_hwstate_user(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+
+	/*
+	 * To prevent continuously exiting from the guest, we mask the
+	 * physical interrupt such that the guest can make forward progress.
+	 * Once we detect the output level being deasserted, we unmask the
+	 * interrupt again so that we exit from the guest when the timer
+	 * fires.
+	*/
+	if (vtimer->irq.level)
+		disable_percpu_irq(host_vtimer_irq);
+	else
+		enable_percpu_irq(host_vtimer_irq, 0);
+}
+
+/**
+ * kvm_timer_flush_hwstate - prepare timers before running the vcpu
+ * @vcpu: The vcpu pointer
+ *
+ * Check if the virtual timer has expired while we were running in the host,
+ * and inject an interrupt if that was the case, making sure the timer is
+ * masked or disabled on the host so that we keep executing.  Also schedule a
+ * software timer for the physical timer if it is enabled.
+ */
+void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+
+	if (unlikely(!timer->enabled))
+		return;
+
+	kvm_timer_update_state(vcpu);
+
+	/* Set the background timer for the physical timer emulation. */
+	kvm_timer_emulate(vcpu, vcpu_ptimer(vcpu));
+
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
+		kvm_timer_flush_hwstate_user(vcpu);
+	else
+		kvm_timer_flush_hwstate_vgic(vcpu);
+}
+
 /**
  * kvm_timer_sync_hwstate - sync timer state from cpu
  * @vcpu: The vcpu pointer
  *
- * Check if the virtual timer has expired while we were running in the guest,
+ * Check if any of the timers have expired while we were running in the guest,
  * and inject an interrupt if that was the case.
  */
 void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
@@ -558,6 +628,13 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	if (timer->enabled)
 		return 0;
 
+	/* Without a VGIC we do not map virtual IRQs to physical IRQs */
+	if (!irqchip_in_kernel(vcpu->kvm))
+		goto no_vgic;
+
+	if (!vgic_initialized(vcpu->kvm))
+		return -ENODEV;
+
 	/*
 	 * Find the physical IRQ number corresponding to the host_vtimer_irq
 	 */
@@ -581,8 +658,8 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
+no_vgic:
 	timer->enabled = 1;
-
 	return 0;
 }
 
-- 
2.9.0
