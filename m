From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [RFC PATCH 5/7] KVM: arm/arm64: Move timer save/restore out of hyp
 code where possible
Date: Sat, 10 Dec 2016 21:47:10 +0100
Message-ID: <20161210204712.21830-6-christoffer.dall@linaro.org>
References: <20161210204712.21830-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF8F640296
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 15:46:09 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Sd+bZsJvdFve for <kvmarm@lists.cs.columbia.edu>;
 Sat, 10 Dec 2016 15:46:08 -0500 (EST)
Received: from mail-lf0-f46.google.com (mail-lf0-f46.google.com
 [209.85.215.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C8D79405A2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 15:46:07 -0500 (EST)
Received: by mail-lf0-f46.google.com with SMTP id b14so21783233lfg.2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 10 Dec 2016 12:47:11 -0800 (PST)
In-Reply-To: <20161210204712.21830-1-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We can access the virtual timer registers from EL1 so there's no need to
do this from the hyp path.  This gives us some advantages in being able to
optimize our handling of timer registers.

We don't adjust the cntvoff during vcpu execution so we add a hyp hook
to be able to call into hyp mode for setting the cntvoff whenever we
load/put the timer, but we don't have to touch this register on every
entry/exit to the VM.

On VHE systems we also don't need to enable and disable physical counter
access traps on every trip to the VM, we can just do that when we load a
VCPU and put a VCPU.

Therefore we factor out the trap configuration from the save/restore of
the virtual timer state, which is moved to the main arch timer file and
use static keys to avoid touching the trap configuration registers on
VHE systems.

We can now leave the timer running on exiting the guest, and handle
interrupts from the vtimer directly and inject the interrupt as a
virtual interrupt to the GIC directly from the ISR.  An added benefit is
that we no longer have to actively write the active state to the
physical distributor, because we set the affinity of the vtimer
interrupt when loading the timer state, so that the interrupt
automatically stays active after firing.

Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/include/asm/kvm_asm.h   |   2 +
 arch/arm/include/asm/kvm_hyp.h   |   4 +-
 arch/arm/kvm/arm.c               |  12 ++-
 arch/arm/kvm/hyp/switch.c        |   5 +-
 arch/arm64/include/asm/kvm_asm.h |   2 +
 arch/arm64/include/asm/kvm_hyp.h |   4 +-
 arch/arm64/kvm/hyp/switch.c      |   4 +-
 include/kvm/arm_arch_timer.h     |   7 +-
 virt/kvm/arm/arch_timer.c        | 190 +++++++++++++++++++++++++--------------
 virt/kvm/arm/hyp/timer-sr.c      |  32 ++-----
 10 files changed, 156 insertions(+), 106 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 8ef0538..1eabfe2 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -68,6 +68,8 @@ extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
 extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
 
+extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
+
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
 extern void __init_stage2_translation(void);
diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index 5850890..92db213 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -98,8 +98,8 @@
 #define cntvoff_el2			CNTVOFF
 #define cnthctl_el2			CNTHCTL
 
-void __timer_save_state(struct kvm_vcpu *vcpu);
-void __timer_restore_state(struct kvm_vcpu *vcpu);
+void __timer_enable_traps(struct kvm_vcpu *vcpu);
+void __timer_disable_traps(struct kvm_vcpu *vcpu);
 
 void __vgic_v2_save_state(struct kvm_vcpu *vcpu);
 void __vgic_v2_restore_state(struct kvm_vcpu *vcpu);
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 6591af7..582e2f7 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -347,10 +347,13 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	vcpu->arch.host_cpu_context = this_cpu_ptr(kvm_host_cpu_state);
 
 	kvm_arm_set_running_vcpu(vcpu);
+	kvm_timer_vcpu_load(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
+	kvm_timer_vcpu_put(vcpu);
+
 	/*
 	 * The arch-generic KVM code expects the cpu field of a vcpu to be -1
 	 * if the vcpu is no longer assigned to a cpu.  This is used for the
@@ -359,7 +362,6 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	vcpu->cpu = -1;
 
 	kvm_arm_set_running_vcpu(NULL);
-	kvm_timer_vcpu_put(vcpu);
 }
 
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
@@ -645,7 +647,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			vcpu->arch.power_off || vcpu->arch.pause) {
 			local_irq_enable();
 			kvm_pmu_sync_hwstate(vcpu);
-			kvm_timer_sync_hwstate(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
 			preempt_enable();
 			continue;
@@ -671,6 +672,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		kvm_arm_clear_debug(vcpu);
 
 		/*
+		 * Sync timer state before enabling interrupts as the sync
+		 * must not collide with a timer interrupt.
+		 */
+		kvm_timer_sync_hwstate(vcpu);
+
+		/*
 		 * We may have taken a host interrupt in HYP mode (ie
 		 * while executing the guest). This interrupt is still
 		 * pending, as we haven't serviced it yet!
@@ -699,7 +706,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * interrupt line.
 		 */
 		kvm_pmu_sync_hwstate(vcpu);
-		kvm_timer_sync_hwstate(vcpu);
 
 		kvm_vgic_sync_hwstate(vcpu);
 
diff --git a/arch/arm/kvm/hyp/switch.c b/arch/arm/kvm/hyp/switch.c
index 92678b7..f4f3ebf 100644
--- a/arch/arm/kvm/hyp/switch.c
+++ b/arch/arm/kvm/hyp/switch.c
@@ -172,7 +172,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__activate_vm(vcpu);
 
 	__vgic_restore_state(vcpu);
-	__timer_restore_state(vcpu);
+	__timer_enable_traps(vcpu);
 
 	__sysreg_restore_state(guest_ctxt);
 	__banked_restore_state(guest_ctxt);
@@ -189,7 +189,8 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__banked_save_state(guest_ctxt);
 	__sysreg_save_state(guest_ctxt);
-	__timer_save_state(vcpu);
+	__timer_disable_traps(vcpu);
+
 	__vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index ec3553eb..5daf476 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -56,6 +56,8 @@ extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
 extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
 extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
 
+extern void __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high);
+
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
 extern u64 __vgic_v3_get_ich_vtr_el2(void);
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index b18e852..7bbc717 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -128,8 +128,8 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu);
 void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
 void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
 
-void __timer_save_state(struct kvm_vcpu *vcpu);
-void __timer_restore_state(struct kvm_vcpu *vcpu);
+void __timer_enable_traps(struct kvm_vcpu *vcpu);
+void __timer_disable_traps(struct kvm_vcpu *vcpu);
 
 void __sysreg_save_host_state(struct kvm_cpu_context *ctxt);
 void __sysreg_restore_host_state(struct kvm_cpu_context *ctxt);
diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 8bcae7b..db920a34 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -281,7 +281,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__activate_vm(vcpu);
 
 	__vgic_restore_state(vcpu);
-	__timer_restore_state(vcpu);
+	__timer_enable_traps(vcpu);
 
 	/*
 	 * We must restore the 32-bit state before the sysregs, thanks
@@ -337,7 +337,7 @@ int __hyp_text __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_save_guest_state(guest_ctxt);
 	__sysreg32_save_state(vcpu);
-	__timer_save_state(vcpu);
+	__timer_disable_traps(vcpu);
 	__vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 2d54903..3e518a6 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -50,11 +50,12 @@ struct arch_timer_cpu {
 	/* Timer IRQ */
 	struct kvm_irq_level		irq;
 
-	/* Active IRQ state caching */
-	bool				active_cleared_last;
 
 	/* Is the timer enabled */
 	bool			enabled;
+
+	/* Is the timer state loaded on the hardware timer */
+	bool			loaded;
 };
 
 int kvm_timer_hyp_init(void);
@@ -74,7 +75,9 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu);
 void kvm_timer_schedule(struct kvm_vcpu *vcpu);
 void kvm_timer_unschedule(struct kvm_vcpu *vcpu);
 
+void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
 
 void kvm_timer_init_vhe(void);
+
 #endif
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index f27a086..beede1b 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -35,10 +35,8 @@ static struct timecounter *timecounter;
 static unsigned int host_vtimer_irq;
 static u32 host_vtimer_irq_flags;
 
-void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.timer_cpu.active_cleared_last = false;
-}
+static bool kvm_timer_irq_can_fire(struct kvm_vcpu *vcpu);
+static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level);
 
 static cycle_t kvm_phys_timer_read(void)
 {
@@ -70,14 +68,14 @@ static void timer_disarm(struct arch_timer_cpu *timer)
 static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
 {
 	struct kvm_vcpu *vcpu = *(struct kvm_vcpu **)dev_id;
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+
+	if (!timer->irq.level) {
+		timer->cntv_ctl = read_sysreg_el0(cntv_ctl);
+		if (kvm_timer_irq_can_fire(vcpu))
+			kvm_timer_update_irq(vcpu, true);
+	}
 
-	/*
-	 * We disable the timer in the world switch and let it be
-	 * handled by kvm_timer_sync_hwstate(). Getting a timer
-	 * interrupt at this point is a sure sign of some major
-	 * breakage.
-	 */
-	pr_warn("Unexpected interrupt %d on vcpu %p\n", irq, vcpu);
 	return IRQ_HANDLED;
 }
 
@@ -158,6 +156,16 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	cycle_t cval, now;
 
+	/*
+	 * If somebody is asking if the timer should fire, but the timer state
+	 * is maintained in hardware, we need to take a snapshot of the
+	 * current hardware state first.
+	 */
+	if (timer->loaded) {
+		timer->cntv_ctl = read_sysreg_el0(cntv_ctl);
+		timer->cntv_cval = read_sysreg_el0(cntv_cval);
+	}
+
 	if (!kvm_timer_irq_can_fire(vcpu))
 		return false;
 
@@ -174,7 +182,6 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
 
 	BUG_ON(!vgic_initialized(vcpu->kvm));
 
-	timer->active_cleared_last = false;
 	timer->irq.level = new_level;
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->irq.irq,
 				   timer->irq.level);
@@ -207,6 +214,29 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static void timer_save_state(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	if (!timer->loaded)
+		goto out;
+
+	if (timer->enabled) {
+		timer->cntv_ctl = read_sysreg_el0(cntv_ctl);
+		timer->cntv_cval = read_sysreg_el0(cntv_cval);
+	}
+
+	/* Disable the virtual timer */
+	write_sysreg_el0(0, cntv_ctl);
+
+	timer->loaded = false;
+out:
+	local_irq_restore(flags);
+}
+
 /*
  * Schedule the background timer before calling kvm_vcpu_block, so that this
  * thread is removed from its waitqueue and made runnable when there's a timer
@@ -218,6 +248,8 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
 
 	BUG_ON(timer_is_armed(timer));
 
+	timer_save_state(vcpu);
+
 	/*
 	 * No need to schedule a background timer if the guest timer has
 	 * already expired, because kvm_vcpu_block will return before putting
@@ -237,77 +269,91 @@ void kvm_timer_schedule(struct kvm_vcpu *vcpu)
 	timer_arm(timer, kvm_timer_compute_delta(vcpu));
 }
 
+static void timer_restore_state(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	if (timer->loaded)
+		goto out;
+
+	if (timer->enabled) {
+		write_sysreg_el0(timer->cntv_cval, cntv_cval);
+		isb();
+		write_sysreg_el0(timer->cntv_ctl, cntv_ctl);
+	}
+
+	timer->loaded = true;
+out:
+	local_irq_restore(flags);
+}
+
 void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	timer_disarm(timer);
+
+	timer_restore_state(vcpu);
 }
 
-/**
- * kvm_timer_flush_hwstate - prepare to move the virt timer to the cpu
- * @vcpu: The vcpu pointer
- *
- * Check if the virtual timer has expired while we were running in the host,
- * and inject an interrupt if that was the case.
- */
-void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
+static void set_cntvoff(u64 cntvoff)
+{
+	u32 low = cntvoff & GENMASK(31, 0);
+	u32 high = (cntvoff >> 32) & GENMASK(31, 0);
+	kvm_call_hyp(__kvm_timer_set_cntvoff, low, high);
+}
+
+void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	bool phys_active;
 	int ret;
 
-	if (kvm_timer_update_state(vcpu))
-		return;
-
-	/*
-	* If we enter the guest with the virtual input level to the VGIC
-	* asserted, then we have already told the VGIC what we need to, and
-	* we don't need to exit from the guest until the guest deactivates
-	* the already injected interrupt, so therefore we should set the
-	* hardware active state to prevent unnecessary exits from the guest.
-	*
-	* Also, if we enter the guest with the virtual timer interrupt active,
-	* then it must be active on the physical distributor, because we set
-	* the HW bit and the guest must be able to deactivate the virtual and
-	* physical interrupt at the same time.
-	*
-	* Conversely, if the virtual input level is deasserted and the virtual
-	* interrupt is not active, then always clear the hardware active state
-	* to ensure that hardware interrupts from the timer triggers a guest
-	* exit.
-	*/
-	phys_active = timer->irq.level ||
-			kvm_vgic_map_is_active(vcpu, timer->irq.irq);
-
-	/*
-	 * We want to avoid hitting the (re)distributor as much as
-	 * possible, as this is a potentially expensive MMIO access
-	 * (not to mention locks in the irq layer), and a solution for
-	 * this is to cache the "active" state in memory.
-	 *
-	 * Things to consider: we cannot cache an "active set" state,
-	 * because the HW can change this behind our back (it becomes
-	 * "clear" in the HW). We must then restrict the caching to
-	 * the "clear" state.
-	 *
-	 * The cache is invalidated on:
-	 * - vcpu put, indicating that the HW cannot be trusted to be
-	 *   in a sane state on the next vcpu load,
-	 * - any change in the interrupt state
-	 *
-	 * Usage conditions:
-	 * - cached value is "active clear"
-	 * - value to be programmed is "active clear"
-	 */
-	if (timer->active_cleared_last && !phys_active)
-		return;
+	ret = irq_set_vcpu_affinity(host_vtimer_irq, vcpu);
+	WARN(ret, "irq_set_vcpu_affinity ret %d\n", ret);
 
+	if (timer->irq.level || kvm_vgic_map_is_active(vcpu, timer->irq.irq))
+		phys_active = true;
+	else
+		phys_active = false;
 	ret = irq_set_irqchip_state(host_vtimer_irq,
 				    IRQCHIP_STATE_ACTIVE,
 				    phys_active);
 	WARN_ON(ret);
 
-	timer->active_cleared_last = !phys_active;
+	set_cntvoff(vcpu->kvm->arch.timer.cntvoff);
+	timer_restore_state(vcpu);
+
+	if (is_kernel_in_hyp_mode())
+		__timer_enable_traps(vcpu);
+}
+
+void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	if (is_kernel_in_hyp_mode())
+		__timer_disable_traps(vcpu);
+
+	timer_save_state(vcpu);
+
+	set_cntvoff(0);
+
+	ret = irq_set_vcpu_affinity(host_vtimer_irq, NULL);
+	WARN(ret, "irq_set_vcpu_affinity ret %d\n", ret);
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
 }
 
 /**
@@ -324,10 +370,16 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 	BUG_ON(timer_is_armed(timer));
 
 	/*
-	 * The guest could have modified the timer registers or the timer
-	 * could have expired, update the timer state.
+	 * If we entered the guest with the timer output asserted we have to
+	 * check if the guest has modified the timer so that we should lower
+	 * the line at this point.
 	 */
-	kvm_timer_update_state(vcpu);
+	if (timer->irq.level) {
+		timer->cntv_ctl = read_sysreg_el0(cntv_ctl);
+		timer->cntv_cval = read_sysreg_el0(cntv_cval);
+		if (!kvm_timer_should_fire(vcpu))
+			kvm_timer_update_irq(vcpu, false);
+	}
 }
 
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
index 63e28dd..3786ac65 100644
--- a/virt/kvm/arm/hyp/timer-sr.c
+++ b/virt/kvm/arm/hyp/timer-sr.c
@@ -21,19 +21,15 @@
 
 #include <asm/kvm_hyp.h>
 
-/* vcpu is already in the HYP VA space */
-void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
+void __hyp_text __kvm_timer_set_cntvoff(u32 cntvoff_low, u32 cntvoff_high)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
-	u64 val;
-
-	if (timer->enabled) {
-		timer->cntv_ctl = read_sysreg_el0(cntv_ctl);
-		timer->cntv_cval = read_sysreg_el0(cntv_cval);
-	}
+	u64 cntvoff = (u64)cntvoff_high << 32 | cntvoff_low;
+	write_sysreg(cntvoff, cntvoff_el2);
+}
 
-	/* Disable the virtual timer */
-	write_sysreg_el0(0, cntv_ctl);
+void __hyp_text __timer_disable_traps(struct kvm_vcpu *vcpu)
+{
+	u64 val;
 
 	/*
 	 * We don't need to do this for VHE since the host kernel runs in EL2
@@ -45,15 +41,10 @@ void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
 		val |= CNTHCTL_EL1PCTEN | CNTHCTL_EL1PCEN;
 		write_sysreg(val, cnthctl_el2);
 	}
-
-	/* Clear cntvoff for the host */
-	write_sysreg(0, cntvoff_el2);
 }
 
-void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
+void __hyp_text __timer_enable_traps(struct kvm_vcpu *vcpu)
 {
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	u64 val;
 
 	/* Those bits are already configured at boot on VHE-system */
@@ -67,11 +58,4 @@ void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
 		val |= CNTHCTL_EL1PCTEN;
 		write_sysreg(val, cnthctl_el2);
 	}
-
-	if (timer->enabled) {
-		write_sysreg(kvm->arch.timer.cntvoff, cntvoff_el2);
-		write_sysreg_el0(timer->cntv_cval, cntv_cval);
-		isb();
-		write_sysreg_el0(timer->cntv_ctl, cntv_ctl);
-	}
 }
-- 
2.9.0
