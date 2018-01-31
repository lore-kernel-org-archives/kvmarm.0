From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH v2] KVM: arm/arm64: Fix arch timers with userspace irqchips
Date: Wed, 31 Jan 2018 13:14:25 +0100
Message-ID: <20180131121425.7252-1-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Alexander Graf <agraf@suse.de>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When introducing support for irqchip in userspace we needed a way to
mask the timer signal to prevent the guest continuously exiting due to a
screaming timer.

We did this by disabling the corresponding percpu interrupt on the
host interrupt controller, because we cannot rely on the host system
having a GIC, and therefore cannot make any assumptions about having an
active state to hide the timer signal.

Unfortunately, when introducing this feature, it became entirely
possible that a VCPU which belongs to a VM that has a userspace irqchip
can disable the vtimer irq on the host on some physical CPU, and then go
away without ever enabling the vtimer irq on that physical CPU again.

This means that using irqchips in userspace on a system that also
supports running VMs with an in-kernel GIC can prevent forward progress
from in-kernel GIC VMs.

Later on, when we started taking virtual timer interrupts in the arch
timer code, we would also leave this timer state active for userspace
irqchip VMs, because we leave it up to a VGIC-enabled guest to
deactivate the hardware IRQ using the HW bit in the LR.

Both issues are solved by only using the enable/disable trick on systems
that do not have a host GIC which supports the active state, because all
VMs on such systems must use irqchips in userspace.  Systems that have a
working GIC with support for an active state use the active state to
mask the timer signal for both userspace and in-kernel irqchips.

Cc: Alexander Graf <agraf@suse.de>
Cc: <stable@vger.kernel.org> # v4.12+
Fixes: d9e139778376 ("KVM: arm/arm64: Support arch timers with a userspace gic")
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
This conflicts horribly with everything when applied to either
kvmarm/queue or kvmarm/master.  Therefore, this patch is written for
(and applies to) v4.15 with kvmarm/queue merged and should therefore
apply cleanly after v4.16-rc1.  An example with this patch applied can
be found on kvmarm/temp-for-v4.16-rc2.  I plan on sending this along
with any other potential fixes post v4.16-rc1.

Changes since v1:
 - Added userspace_irqchip() wrapper to simplify logic
 - Changed has_gic_active_state to a static key
 - Fixed typos in commentary and commit message
 - Clear the active state on sync for userspace irqchips on systems
   with a working GIC.
 - Get rid of __timer_snapshot_state() in unmaks_vtimer_irq_user()
   because kvm_timer_should_fire() has already been reworked in other
   patches to look at the timer state when it's loaded onto the
   hardware.  As a result, we don't need the
   __timer_snapshot_state() indirection anymore and this logic is
   now inlined in vtimer_save_state().

 virt/kvm/arm/arch_timer.c | 116 +++++++++++++++++++++++++---------------------
 1 file changed, 64 insertions(+), 52 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 70268c0bec79..70f4c30918eb 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -36,6 +36,8 @@ static struct timecounter *timecounter;
 static unsigned int host_vtimer_irq;
 static u32 host_vtimer_irq_flags;
 
+static DEFINE_STATIC_KEY_FALSE(has_gic_active_state);
+
 static const struct kvm_irq_level default_ptimer_irq = {
 	.irq	= 30,
 	.level	= 1,
@@ -56,6 +58,12 @@ u64 kvm_phys_timer_read(void)
 	return timecounter->cc->read(timecounter->cc);
 }
 
+static inline bool userspace_irqchip(struct kvm *kvm)
+{
+	return static_branch_unlikely(&userspace_irqchip_in_use) &&
+		unlikely(!irqchip_in_kernel(kvm));
+}
+
 static void soft_timer_start(struct hrtimer *hrt, u64 ns)
 {
 	hrtimer_start(hrt, ktime_add_ns(ktime_get(), ns),
@@ -69,25 +77,6 @@ static void soft_timer_cancel(struct hrtimer *hrt, struct work_struct *work)
 		cancel_work_sync(work);
 }
 
-static void kvm_vtimer_update_mask_user(struct kvm_vcpu *vcpu)
-{
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-
-	/*
-	 * When using a userspace irqchip with the architected timers, we must
-	 * prevent continuously exiting from the guest, and therefore mask the
-	 * physical interrupt by disabling it on the host interrupt controller
-	 * when the virtual level is high, such that the guest can make
-	 * forward progress.  Once we detect the output level being
-	 * de-asserted, we unmask the interrupt again so that we exit from the
-	 * guest when the timer fires.
-	 */
-	if (vtimer->irq.level)
-		disable_percpu_irq(host_vtimer_irq);
-	else
-		enable_percpu_irq(host_vtimer_irq, 0);
-}
-
 static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
 {
 	struct kvm_vcpu *vcpu = *(struct kvm_vcpu **)dev_id;
@@ -106,9 +95,9 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
 	if (kvm_timer_should_fire(vtimer))
 		kvm_timer_update_irq(vcpu, true, vtimer);
 
-	if (static_branch_unlikely(&userspace_irqchip_in_use) &&
-	    unlikely(!irqchip_in_kernel(vcpu->kvm)))
-		kvm_vtimer_update_mask_user(vcpu);
+	if (userspace_irqchip(vcpu->kvm) &&
+	    !static_branch_unlikely(&has_gic_active_state))
+		disable_percpu_irq(host_vtimer_irq);
 
 	return IRQ_HANDLED;
 }
@@ -290,8 +279,7 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_ctx->irq.irq,
 				   timer_ctx->irq.level);
 
-	if (!static_branch_unlikely(&userspace_irqchip_in_use) ||
-	    likely(irqchip_in_kernel(vcpu->kvm))) {
+	if (!userspace_irqchip(vcpu->kvm)) {
 		ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu->vcpu_id,
 					  timer_ctx->irq.irq,
 					  timer_ctx->irq.level,
@@ -350,12 +338,6 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	phys_timer_emulate(vcpu);
 }
 
-static void __timer_snapshot_state(struct arch_timer_context *timer)
-{
-	timer->cnt_ctl = read_sysreg_el0(cntv_ctl);
-	timer->cnt_cval = read_sysreg_el0(cntv_cval);
-}
-
 static void vtimer_save_state(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
@@ -367,8 +349,10 @@ static void vtimer_save_state(struct kvm_vcpu *vcpu)
 	if (!vtimer->loaded)
 		goto out;
 
-	if (timer->enabled)
-		__timer_snapshot_state(vtimer);
+	if (timer->enabled) {
+		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
+		vtimer->cnt_cval = read_sysreg_el0(cntv_cval);
+	}
 
 	/* Disable the virtual timer */
 	write_sysreg_el0(0, cntv_ctl);
@@ -460,23 +444,43 @@ static void set_cntvoff(u64 cntvoff)
 	kvm_call_hyp(__kvm_timer_set_cntvoff, low, high);
 }
 
-static void kvm_timer_vcpu_load_vgic(struct kvm_vcpu *vcpu)
+static inline void set_vtimer_irq_phys_active(struct kvm_vcpu *vcpu, bool active)
+{
+	int r;
+	r = irq_set_irqchip_state(host_vtimer_irq, IRQCHIP_STATE_ACTIVE, active);
+	WARN_ON(r);
+}
+
+static void kvm_timer_vcpu_load_gic(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	bool phys_active;
-	int ret;
 
-	phys_active = kvm_vgic_map_is_active(vcpu, vtimer->irq.irq);
-
-	ret = irq_set_irqchip_state(host_vtimer_irq,
-				    IRQCHIP_STATE_ACTIVE,
-				    phys_active);
-	WARN_ON(ret);
+	if (irqchip_in_kernel(vcpu->kvm))
+		phys_active = kvm_vgic_map_is_active(vcpu, vtimer->irq.irq);
+	else
+		phys_active = vtimer->irq.level;
+	set_vtimer_irq_phys_active(vcpu, phys_active);
 }
 
-static void kvm_timer_vcpu_load_user(struct kvm_vcpu *vcpu)
+static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
 {
-	kvm_vtimer_update_mask_user(vcpu);
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+
+	/*
+	 * When using a userspace irqchip with the architected timers and a
+	 * host interrupt controller that doesn't support an active state, we
+	 * must still prevent continuously exiting from the guest, and
+	 * therefore mask the physical interrupt by disabling it on the host
+	 * interrupt controller when the virtual level is high, such that the
+	 * guest can make forward progress.  Once we detect the output level
+	 * being de-asserted, we unmask the interrupt again so that we exit
+	 * from the guest when the timer fires.
+	 */
+	if (vtimer->irq.level)
+		disable_percpu_irq(host_vtimer_irq);
+	else
+		enable_percpu_irq(host_vtimer_irq, host_vtimer_irq_flags);
 }
 
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
@@ -487,10 +491,10 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 	if (unlikely(!timer->enabled))
 		return;
 
-	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
-		kvm_timer_vcpu_load_user(vcpu);
+	if (static_branch_likely(&has_gic_active_state))
+		kvm_timer_vcpu_load_gic(vcpu);
 	else
-		kvm_timer_vcpu_load_vgic(vcpu);
+		kvm_timer_vcpu_load_nogic(vcpu);
 
 	set_cntvoff(vtimer->cntvoff);
 
@@ -555,18 +559,24 @@ static void unmask_vtimer_irq_user(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
-	if (unlikely(!irqchip_in_kernel(vcpu->kvm))) {
-		__timer_snapshot_state(vtimer);
-		if (!kvm_timer_should_fire(vtimer)) {
-			kvm_timer_update_irq(vcpu, false, vtimer);
-			kvm_vtimer_update_mask_user(vcpu);
-		}
+	if (!kvm_timer_should_fire(vtimer)) {
+		kvm_timer_update_irq(vcpu, false, vtimer);
+		if (static_branch_likely(&has_gic_active_state))
+			set_vtimer_irq_phys_active(vcpu, false);
+		else
+			enable_percpu_irq(host_vtimer_irq, host_vtimer_irq_flags);
 	}
 }
 
 void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	unmask_vtimer_irq_user(vcpu);
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+
+	if (unlikely(!timer->enabled))
+		return;
+
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
+		unmask_vtimer_irq_user(vcpu);
 }
 
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
@@ -753,6 +763,8 @@ int kvm_timer_hyp_init(bool has_gic)
 			kvm_err("kvm_arch_timer: error setting vcpu affinity\n");
 			goto out_free_irq;
 		}
+
+		static_branch_enable(&has_gic_active_state);
 	}
 
 	kvm_info("virtual timer IRQ%d\n", host_vtimer_irq);
-- 
2.14.2
