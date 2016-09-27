From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 3/3] KVM: arm/arm64: Support arch timers with a userspace gic
Date: Tue, 27 Sep 2016 21:08:06 +0200
Message-ID: <20160927190806.22988-4-christoffer.dall@linaro.org>
References: <20160927190806.22988-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC06549B30
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 14:58:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ulNUf7oQoYxF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2016 14:58:36 -0400 (EDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2FC844998D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 14:58:34 -0400 (EDT)
Received: by mail-wm0-f43.google.com with SMTP id l132so193841288wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2016 12:07:58 -0700 (PDT)
In-Reply-To: <20160927190806.22988-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alexander Graf <agraf@suse.de>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Alexander Graf <agraf@suse.de>

If you're running with a userspace gic or other interrupt constroller
(that is no vgic in the kernel), then you have so far not been able to
use the architected timers, because the output of the architected
timers, which are driven inside the kernel, was a kernel-only construct
between the arch timer code and the vgic.

This patch implements the new KVM_CAP_ARM_TIMER feature, where we use a
side channel on the kvm_run structure, run->s.regs.timer_irq_level, to
always notify userspace of the timer output level when using a userspace
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

Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Alexander Graf <agraf@suse.de>
---
 arch/arm/kvm/arm.c           |  19 ++++----
 include/kvm/arm_arch_timer.h |   2 +
 virt/kvm/arm/arch_timer.c    | 105 +++++++++++++++++++++++++++++++++++--------
 3 files changed, 98 insertions(+), 28 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 85a3f90..712695d 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -187,6 +187,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PSCI_0_2:
 	case KVM_CAP_READONLY_MEM:
 	case KVM_CAP_MP_STATE:
+	case KVM_CAP_ARM_TIMER:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -474,13 +475,7 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
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
@@ -594,9 +589,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
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
@@ -668,6 +666,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		ret = handle_exit(vcpu, run, ret);
 	}
 
+	/* Tell userspace about the arch timer output level */
+	kvm_timer_update_run(vcpu);
+
 	if (vcpu->sigset_active)
 		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
 	return ret;
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index dda39d8..7157e73 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -65,6 +65,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu);
+bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu);
+void kvm_timer_update_run(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu);
 
 u64 kvm_arm_timer_get_reg(struct kvm_vcpu *, u64 regid);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 824ed26..c645b7d 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -166,6 +166,22 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
 	return cval <= now;
 }
 
+/*
+ * Reflect the timer output level into the kvm_run structure
+ */
+void kvm_timer_update_run(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sync_regs *regs = &vcpu->run->s.regs;
+
+	if (likely(irqchip_in_kernel(vcpu->kvm)))
+		return;
+
+	/* Populate the timer bitmap for user space */
+	regs->timer_irq_level &= ~KVM_ARM_TIMER_VTIMER;
+	if (vcpu->arch.timer_cpu.irq.level)
+		regs->timer_irq_level |= KVM_ARM_TIMER_VTIMER;
+}
+
 static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
 {
 	int ret;
@@ -173,12 +189,17 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
 
 	timer->active_cleared_last = false;
 	timer->irq.level = new_level;
-	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->irq.irq,
+	trace_kvm_timer_update_irq(vcpu->vcpu_id, host_vtimer_irq,
 				   timer->irq.level);
-	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
-					 timer->irq.irq,
-					 timer->irq.level);
-	WARN_ON(ret);
+
+	if (likely(irqchip_in_kernel(vcpu->kvm))) {
+		/* Fire the timer in the VGIC */
+		ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
+						 timer->irq.irq,
+						 timer->irq.level);
+
+		WARN_ON(ret);
+	}
 }
 
 /*
@@ -195,7 +216,7 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	 * because the guest would never see the interrupt.  Instead wait
 	 * until we call this function from kvm_timer_flush_hwstate.
 	 */
-	if (!timer->enabled)
+	if (unlikely(!timer->enabled))
 		return;
 
 	if (kvm_timer_should_fire(vcpu) != timer->irq.level)
@@ -238,24 +259,12 @@ void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
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
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	bool phys_active;
 	int ret;
 
-	if (unlikely(!timer->enabled))
-		return;
-
-	kvm_timer_update_state(vcpu);
-
 	/*
 	* If we enter the guest with the virtual input level to the VGIC
 	* asserted, then we have already told the VGIC what we need to, and
@@ -307,6 +316,56 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	timer->active_cleared_last = !phys_active;
 }
 
+bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	bool run_level = vcpu->run->s.regs.timer_irq_level & KVM_ARM_TIMER_VTIMER;
+
+	if (likely(irqchip_in_kernel(vcpu->kvm)))
+		return false;
+
+	return timer->irq.level != run_level;
+}
+
+static void kvm_timer_flush_hwstate_user(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+
+	/*
+	 * To prevent continuously exiting from the guest, we mask the
+	 * physical interrupt such that the guest can make forward progress.
+	 * Once we detect the output level being deasserted, we unmask the
+	 * interrupt again so that we exit from the guest when the timer
+	 * fires.
+	*/
+	if (timer->irq.level)
+		disable_percpu_irq(host_vtimer_irq);
+	else
+		enable_percpu_irq(host_vtimer_irq, 0);
+}
+
+/**
+ * kvm_timer_flush_hwstate - prepare to move the virt timer to the cpu
+ * @vcpu: The vcpu pointer
+ *
+ * Check if the virtual timer has expired while we were running in the host,
+ * and inject an interrupt if that was the case.
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
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
+		kvm_timer_flush_hwstate_user(vcpu);
+	else
+		kvm_timer_flush_hwstate_vgic(vcpu);
+}
+
 /**
  * kvm_timer_sync_hwstate - sync timer state from cpu
  * @vcpu: The vcpu pointer
@@ -473,6 +532,13 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
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
@@ -496,6 +562,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
+no_vgic:
 
 	/*
 	 * There is a potential race here between VCPUs starting for the first
-- 
2.9.0
