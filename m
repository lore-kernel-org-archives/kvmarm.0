From: Alexander Graf <agraf@suse.de>
Subject: [PATCH v6] KVM: arm/arm64: Route vtimer events to user space
Date: Fri, 23 Sep 2016 13:07:34 +0200
Message-ID: <1474628854-69945-1-git-send-email-agraf@suse.de>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, drjones@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

We have 2 modes for dealing with interrupts in the ARM world. We can either
handle them all using hardware acceleration through the vgic or we can emulate
a gic in user space and only drive CPU IRQ pins from there.

Unfortunately, when driving IRQs from user space, we never tell user space
about timer events that may result in interrupt line state changes, so we
lose out on timer events if we run with user space gic emulation.

This patch fixes that by exposing kvm's view of the vtimer irq line to user
space and giving it a chance to sync that when it changes.

With this patch I can successfully run edk2 and Linux with user space gic
emulation.

Signed-off-by: Alexander Graf <agraf@suse.de>

---

v1 -> v2:

  - Add back curly brace that got lost

v2 -> v3:

  - Split into patch set

v3 -> v4:

  - Improve documentation

v4 -> v5:

  - Rewrite to use pending state sync in sregs (marc)
  - Remove redundant checks of vgic_initialized()

v5 -> v6:

  - s/pending/asserted/
  - split kvm_timer_flush_hwstate function
  - remove user_timer_asserted
  - rename kernel_timer_asserted to timer_irq_level
  - exit only once per level change
  - qemu tree to try this out: https://github.com/agraf/qemu.git no-kvm-irqchip-for-v6
---
 Documentation/virtual/kvm/api.txt |  27 ++++++++
 arch/arm/include/uapi/asm/kvm.h   |   2 +
 arch/arm/kvm/arm.c                |  26 ++++----
 arch/arm64/include/uapi/asm/kvm.h |   2 +
 include/kvm/arm_arch_timer.h      |   4 +-
 include/uapi/linux/kvm.h          |   6 ++
 virt/kvm/arm/arch_timer.c         | 133 +++++++++++++++++++++++++++++++-------
 7 files changed, 164 insertions(+), 36 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 739db9a..20ab558 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -3928,3 +3928,30 @@ In order to use SynIC, it has to be activated by setting this
 capability via KVM_ENABLE_CAP ioctl on the vcpu fd. Note that this
 will disable the use of APIC hardware virtualization even if supported
 by the CPU, as it's incompatible with SynIC auto-EOI behavior.
+
+8.3 KVM_CAP_ARM_TIMER
+
+Architectures: arm, arm64
+This capability, if KVM_CHECK_EXTENSION indicates that it is available and no
+in-kernel interrupt controller is in use, means that that the kernel populates
+the vcpu's run->s.regs.timer_irq_level field with timers that are currently
+considered asserted by kvm.
+
+If active, kvm guarantees at least one exit happens after it detects an
+assertion change. This exit could either be a KVM_EXIT_INTR or any other exit
+event, like KVM_EXIT_MMIO. This way kvm gives user space a chance to update its
+own interrupt asserted status. This usually involves triggering an interrupt
+line on a user space emulated interrupt controller, so user space should always
+check the state of run->s.regs.timer_irq_level on every kvm exit.
+
+The field run->s.regs.timer_irq_level is available independent of
+run->kvm_valid_regs or run->kvm_dirty_regs bits. If no in-kernel interrupt
+controller is used and the capability exists, it will always be available and
+populated.
+
+Currently the following bits are defined for the timer_irq_level bitmap:
+
+    KVM_ARM_TIMER_VTIMER  -  virtual timer
+
+Future versions of kvm may implement additional timer events. These will get
+indicated by additional KVM_CAP extensions.
diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
index a2b3eb3..ad61b4f 100644
--- a/arch/arm/include/uapi/asm/kvm.h
+++ b/arch/arm/include/uapi/asm/kvm.h
@@ -105,6 +105,8 @@ struct kvm_debug_exit_arch {
 };
 
 struct kvm_sync_regs {
+	/* Used with KVM_CAP_ARM_TIMER */
+	u8 timer_irq_level;
 };
 
 struct kvm_arch_memory_slot {
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 75f130e..4bb1a22 100644
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
@@ -549,7 +544,7 @@ static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
  */
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 {
-	int ret;
+	int ret, timer_ret;
 	sigset_t sigsaved;
 
 	if (unlikely(!kvm_vcpu_initialized(vcpu)))
@@ -588,7 +583,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 */
 		preempt_disable();
 		kvm_pmu_flush_hwstate(vcpu);
-		kvm_timer_flush_hwstate(vcpu);
+		timer_ret = kvm_timer_flush_hwstate(vcpu);
 		kvm_vgic_flush_hwstate(vcpu);
 
 		local_irq_disable();
@@ -596,7 +591,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		/*
 		 * Re-check atomic conditions
 		 */
-		if (signal_pending(current)) {
+		if (timer_ret || signal_pending(current)) {
 			ret = -EINTR;
 			run->exit_reason = KVM_EXIT_INTR;
 		}
@@ -659,13 +654,22 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		 * interrupt line.
 		 */
 		kvm_pmu_sync_hwstate(vcpu);
-		kvm_timer_sync_hwstate(vcpu);
+		timer_ret = kvm_timer_sync_hwstate(vcpu);
 
 		kvm_vgic_sync_hwstate(vcpu);
 
 		preempt_enable();
 
 		ret = handle_exit(vcpu, run, ret);
+
+		if ((ret == 1) && timer_ret) {
+			/*
+			 * We have to exit straight away to ensure that we only
+			 * ever notify user space once about a level change
+			 */
+			ret = -EINTR;
+			run->exit_reason = KVM_EXIT_INTR;
+		}
 	}
 
 	if (vcpu->sigset_active)
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 3051f86..411d62a 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -143,6 +143,8 @@ struct kvm_debug_exit_arch {
 #define KVM_GUESTDBG_USE_HW		(1 << 17)
 
 struct kvm_sync_regs {
+	/* Used with KVM_CAP_ARM_TIMER */
+	u8 timer_irq_level;
 };
 
 struct kvm_arch_memory_slot {
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index dda39d8..dd0d649 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -63,8 +63,8 @@ void kvm_timer_init(struct kvm *kvm);
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 			 const struct kvm_irq_level *irq);
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu);
-void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu);
-void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu);
+int kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu);
+int kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu);
 
 u64 kvm_arm_timer_get_reg(struct kvm_vcpu *, u64 regid);
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 300ef25..10d63c5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -870,6 +870,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_S390_USER_INSTR0 130
 #define KVM_CAP_MSI_DEVID 131
 #define KVM_CAP_PPC_HTM 132
+#define KVM_CAP_ARM_TIMER 133
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1327,4 +1328,9 @@ struct kvm_assigned_msix_entry {
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
+/* Available with KVM_CAP_ARM_TIMER */
+
+/* Bits for run->s.regs.{user,kernel}_timer_asserted */
+#define KVM_ARM_TIMER_VTIMER		(1 << 0)
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 4309b60..3612fa0 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -166,26 +166,57 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
 	return cval <= now;
 }
 
-static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
+/*
+ * Synchronize the timer IRQ state with the interrupt controller.
+ *
+ * Returns:
+ *
+ *    0  - success
+ *    1  - need exit to user space
+ */
+static int kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
 {
 	int ret;
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
-	BUG_ON(!vgic_initialized(vcpu->kvm));
-
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
+	if (irqchip_in_kernel(vcpu->kvm)) {
+		BUG_ON(!vgic_initialized(vcpu->kvm));
+
+		/* Fire the timer in the VGIC */
+		ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
+						 timer->irq.irq,
+						 timer->irq.level);
+
+		WARN_ON(ret);
+	} else {
+		struct kvm_sync_regs *regs = &vcpu->run->s.regs;
+
+		/* Populate the timer bitmap for user space */
+		regs->timer_irq_level &= ~KVM_ARM_TIMER_VTIMER;
+		if (new_level)
+			regs->timer_irq_level |= KVM_ARM_TIMER_VTIMER;
+
+		/* Exit to user space to notify it about the line change */
+		return 1;
+	}
+
+	return 0;
 }
 
 /*
  * Check if there was a change in the timer state (should we raise or lower
  * the line level to the GIC).
+ *
+ * Returns:
+ *
+ *   <0  - error
+ *    0  - success
+ *    1  - need exit to user space
  */
 static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 {
@@ -197,11 +228,12 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	 * because the guest would never see the interrupt.  Instead wait
 	 * until we call this function from kvm_timer_flush_hwstate.
 	 */
-	if (!vgic_initialized(vcpu->kvm) || !timer->enabled)
+	if ((irqchip_in_kernel(vcpu->kvm) && !vgic_initialized(vcpu->kvm)) ||
+	    !timer->enabled)
 		return -ENODEV;
 
 	if (kvm_timer_should_fire(vcpu) != timer->irq.level)
-		kvm_timer_update_irq(vcpu, !timer->irq.level);
+		return kvm_timer_update_irq(vcpu, !timer->irq.level);
 
 	return 0;
 }
@@ -242,22 +274,12 @@ void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
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
 
-	if (kvm_timer_update_state(vcpu))
-		return;
-
 	/*
 	* If we enter the guest with the virtual input level to the VGIC
 	* asserted, then we have already told the VGIC what we need to, and
@@ -309,14 +331,69 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	timer->active_cleared_last = !phys_active;
 }
 
+static void kvm_timer_flush_hwstate_user(struct kvm_vcpu *vcpu)
+{
+	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+
+	/*
+	 * As long as the timer is asserted, we do not need to get new host
+	 * timer events to know whether the line is still up. Since the GIC
+	 * is handled in user space, we will get an exit on EOI, so we can
+	 * resynchronize the status there.
+	 */
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
+ *
+ * Returns:
+ *
+ *    0  - success
+ *    1  - need exit to user space
+ */
+int kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
+{
+	switch (kvm_timer_update_state(vcpu)) {
+	case 0:
+		/* All is good, we can sync */
+		break;
+	case 1:
+		/* We need to exit to user space */
+		return 1;
+	default:
+		/* An error occured, skip the sync */
+		return 0;
+	}
+
+	if (irqchip_in_kernel(vcpu->kvm))
+		kvm_timer_flush_hwstate_vgic(vcpu);
+	else
+		kvm_timer_flush_hwstate_user(vcpu);
+
+	return 0;
+}
+
 /**
  * kvm_timer_sync_hwstate - sync timer state from cpu
  * @vcpu: The vcpu pointer
  *
  * Check if the virtual timer has expired while we were running in the guest,
  * and inject an interrupt if that was the case.
+ *
+ * Returns:
+ *
+ *    0  - success
+ *    1  - need exit to user space
  */
-void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
+int kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 
@@ -326,7 +403,12 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 	 * The guest could have modified the timer registers or the timer
 	 * could have expired, update the timer state.
 	 */
-	kvm_timer_update_state(vcpu);
+	if (kvm_timer_update_state(vcpu) == 1) {
+		/* We should go back to user space */
+		return 1;
+	}
+
+	return 0;
 }
 
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
@@ -479,6 +561,10 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	if (timer->enabled)
 		return 0;
 
+	/* No need to route physical IRQs when we don't use the vgic */
+	if (!irqchip_in_kernel(vcpu->kvm))
+		goto no_vgic;
+
 	/*
 	 * Find the physical IRQ number corresponding to the host_vtimer_irq
 	 */
@@ -502,6 +588,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
+no_vgic:
 
 	/*
 	 * There is a potential race here between VCPUs starting for the first
-- 
1.8.5.6

