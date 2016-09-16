From: Alexander Graf <agraf@suse.de>
Subject: [PATCH v2] KVM: arm/arm64: Route vtimer events to user space
Date: Fri, 16 Sep 2016 07:09:13 +0200
Message-ID: <1474002553-30079-1-git-send-email-agraf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8923540FA6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 01:01:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hPt7wPZiW2kI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2016 01:01:16 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1479040F9B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 01:01:16 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

We have 2 modes for dealing with interrupts in the ARM world. We can either
handle them all using hardware acceleration through the vgic or we can emulate
a gic in user space and only drive CPU IRQ pins from there.

Unfortunately, when driving IRQs from user space, we never tell user space
about timer events that may result in interrupt line state changes, so we
lose out on timer events if we run with user space gic emulation.

This patch set fixes that by routing vtimer expiration events to user space.
With this patch I can successfully run edk2 and Linux with user space gic
emulation.

Signed-off-by: Alexander Graf <agraf@suse.de>

---

A branch with WIP QEMU code can be found here:

  https://github.com/agraf/qemu.git no-kvm-irqchip

v1 -> v2:

  - Add back curly brace that got lost (and is very stubborn, sorry for
    the resubmit to actually add it back for real)
---
 Documentation/virtual/kvm/api.txt |  28 ++++++++-
 arch/arm/include/asm/kvm_host.h   |   3 +
 arch/arm/kvm/arm.c                |  47 +++++++++++---
 arch/arm64/include/asm/kvm_host.h |   3 +
 include/uapi/linux/kvm.h          |  14 +++++
 virt/kvm/arm/arch_timer.c         | 126 ++++++++++++++++++++++++++++----------
 6 files changed, 178 insertions(+), 43 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 739db9a..6a64c53 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -997,7 +997,9 @@ documentation when it pops into existence).
 
 Capability: KVM_CAP_ENABLE_CAP, KVM_CAP_ENABLE_CAP_VM
 Architectures: x86 (only KVM_CAP_ENABLE_CAP_VM),
-	       mips (only KVM_CAP_ENABLE_CAP), ppc, s390
+	       mips (only KVM_CAP_ENABLE_CAP), ppc, s390,
+	       arm (only KVM_CAP_ENABLE_CAP),
+	       arm64 (only only KVM_CAP_ENABLE_CAP)
 Type: vcpu ioctl, vm ioctl (with KVM_CAP_ENABLE_CAP_VM)
 Parameters: struct kvm_enable_cap (in)
 Returns: 0 on success; -1 on error
@@ -3200,8 +3202,10 @@ struct kvm_run {
 	/* in */
 	__u8 request_interrupt_window;
 
-Request that KVM_RUN return when it becomes possible to inject external
+[x86] Request that KVM_RUN return when it becomes possible to inject external
 interrupts into the guest.  Useful in conjunction with KVM_INTERRUPT.
+[arm*] Bits set to 1 in here mask IRQ lines that would otherwise potentially
+trigger forever. Useful with KVM_CAP_ARM_TIMER.
 
 	__u8 padding1[7];
 
@@ -3517,6 +3521,16 @@ Hyper-V SynIC state change. Notification is used to remap SynIC
 event/message pages and to enable/disable SynIC messages/events processing
 in userspace.
 
+		/* KVM_EXIT_ARM_TIMER */
+		struct {
+			__u8 timesource;
+		} arm_timer;
+
+Indicates that a timer triggered that user space needs to handle and
+potentially mask with vcpu->run->request_interrupt_window to allow the
+guest to proceed. This only happens for timers that got enabled through
+KVM_CAP_ARM_TIMER.
+
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -3737,6 +3751,16 @@ Once this is done the KVM_REG_MIPS_VEC_* and KVM_REG_MIPS_MSA_* registers can be
 accessed, and the Config5.MSAEn bit is accessible via the KVM API and also from
 the guest.
 
+6.11 KVM_CAP_ARM_TIMER
+
+Architectures: arm, arm64
+Target: vcpu
+Parameters: args[0] contains a bitmap of timers to enable
+
+This capability allows to route per-core timers into user space. When it's
+enabled, the enabled timers trigger KVM_EXIT_ARM_TIMER guest exits when they
+are pending, unless masked by vcpu->run->request_interrupt_window.
+
 7. Capabilities that can be enabled on VMs
 ------------------------------------------
 
diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
index de338d9..77d1f73 100644
--- a/arch/arm/include/asm/kvm_host.h
+++ b/arch/arm/include/asm/kvm_host.h
@@ -180,6 +180,9 @@ struct kvm_vcpu_arch {
 
 	/* Detect first run of a vcpu */
 	bool has_run_once;
+
+	/* User space wants timer notifications */
+	bool user_space_arm_timers;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 75f130e..57bdb71 100644
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
@@ -601,6 +596,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 			run->exit_reason = KVM_EXIT_INTR;
 		}
 
+		if (kvm_check_request(KVM_REQ_PENDING_TIMER, vcpu)) {
+			/* Tell user space about the pending vtimer */
+			ret = 0;
+			run->exit_reason = KVM_EXIT_ARM_TIMER;
+			run->arm_timer.timesource = KVM_ARM_TIMER_VTIMER;
+		}
+
 		if (ret <= 0 || need_new_vmid_gen(vcpu->kvm) ||
 			vcpu->arch.power_off || vcpu->arch.pause) {
 			local_irq_enable();
@@ -878,6 +880,29 @@ static int kvm_arm_vcpu_has_attr(struct kvm_vcpu *vcpu,
 	return ret;
 }
 
+static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
+				     struct kvm_enable_cap *cap)
+{
+	int r;
+
+	if (cap->flags)
+		return -EINVAL;
+
+	switch (cap->cap) {
+	case KVM_CAP_ARM_TIMER:
+		r = 0;
+		if (cap->args[0] != KVM_ARM_TIMER_VTIMER)
+			return -EINVAL;
+		vcpu->arch.user_space_arm_timers = true;
+		break;
+	default:
+		r = -EINVAL;
+		break;
+	}
+
+	return r;
+}
+
 long kvm_arch_vcpu_ioctl(struct file *filp,
 			 unsigned int ioctl, unsigned long arg)
 {
@@ -941,6 +966,14 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 			return -EFAULT;
 		return kvm_arm_vcpu_has_attr(vcpu, &attr);
 	}
+	case KVM_ENABLE_CAP:
+	{
+		struct kvm_enable_cap cap;
+
+		if (copy_from_user(&cap, argp, sizeof(cap)))
+			return -EFAULT;
+		return kvm_vcpu_ioctl_enable_cap(vcpu, &cap);
+	}
 	default:
 		return -EINVAL;
 	}
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3eda975..3d01481 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -270,6 +270,9 @@ struct kvm_vcpu_arch {
 
 	/* Detect first run of a vcpu */
 	bool has_run_once;
+
+	/* User space wants timer notifications */
+	bool user_space_arm_timers;
 };
 
 #define vcpu_gp_regs(v)		(&(v)->arch.ctxt.gp_regs)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 300ef25..00f4948 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -205,6 +205,7 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
+#define KVM_EXIT_ARM_TIMER        28
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -361,6 +362,10 @@ struct kvm_run {
 		} eoi;
 		/* KVM_EXIT_HYPERV */
 		struct kvm_hyperv_exit hyperv;
+		/* KVM_EXIT_ARM_TIMER */
+		struct {
+			__u8 timesource;
+		} arm_timer;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -870,6 +875,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_S390_USER_INSTR0 130
 #define KVM_CAP_MSI_DEVID 131
 #define KVM_CAP_PPC_HTM 132
+#define KVM_CAP_ARM_TIMER 133
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1327,4 +1333,12 @@ struct kvm_assigned_msix_entry {
 #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
 #define KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK  (1ULL << 1)
 
+/* Available with KVM_CAP_ARM_TIMER */
+
+/* Bits for run->request_interrupt_window */
+#define KVM_IRQWINDOW_VTIMER		(1 << 0)
+
+/* Bits for run->arm_timer.timesource */
+#define KVM_ARM_TIMER_VTIMER		(1 << 0)
+
 #endif /* __LINUX_KVM_H */
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 4309b60..d0e999d 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -24,6 +24,7 @@
 
 #include <clocksource/arm_arch_timer.h>
 #include <asm/arch_timer.h>
+#include <asm/kvm_emulate.h>
 
 #include <kvm/arm_vgic.h>
 #include <kvm/arm_arch_timer.h>
@@ -170,16 +171,45 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
 {
 	int ret;
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct kvm_run *run = vcpu->run;
 
-	BUG_ON(!vgic_initialized(vcpu->kvm));
+	BUG_ON(irqchip_in_kernel(vcpu->kvm) && !vgic_initialized(vcpu->kvm));
 
 	timer->active_cleared_last = false;
 	timer->irq.level = new_level;
-	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->irq.irq,
+	trace_kvm_timer_update_irq(vcpu->vcpu_id, host_vtimer_irq,
 				   timer->irq.level);
-	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
-					 timer->irq.irq,
-					 timer->irq.level);
+
+	if (irqchip_in_kernel(vcpu->kvm) && vgic_initialized(vcpu->kvm)) {
+		/* Fire the timer in the VGIC */
+
+		ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
+						 timer->irq.irq,
+						 timer->irq.level);
+	} else if (!vcpu->arch.user_space_arm_timers) {
+		/* User space has not activated timer use */
+		ret = 0;
+	} else {
+		/*
+		 * Set PENDING_TIMER so that user space can handle the event if
+		 *
+		 *   1) Level is high
+		 *   2) The vtimer is not suppressed by user space
+		 *   3) We are not in the timer trigger exit path
+		 */
+		if (new_level &&
+		    !(run->request_interrupt_window & KVM_IRQWINDOW_VTIMER) &&
+		    (run->exit_reason != KVM_EXIT_ARM_TIMER)) {
+			/* KVM_REQ_PENDING_TIMER means vtimer triggered */
+			kvm_make_request(KVM_REQ_PENDING_TIMER, vcpu);
+		}
+
+		/* Force a new level high check on next entry */
+		timer->irq.level = 0;
+
+		ret = 0;
+	}
+
 	WARN_ON(ret);
 }
 
@@ -197,7 +227,8 @@ static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 	 * because the guest would never see the interrupt.  Instead wait
 	 * until we call this function from kvm_timer_flush_hwstate.
 	 */
-	if (!vgic_initialized(vcpu->kvm) || !timer->enabled)
+	if ((irqchip_in_kernel(vcpu->kvm) && !vgic_initialized(vcpu->kvm)) ||
+	    !timer->enabled)
 		return -ENODEV;
 
 	if (kvm_timer_should_fire(vcpu) != timer->irq.level)
@@ -275,35 +306,57 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	* to ensure that hardware interrupts from the timer triggers a guest
 	* exit.
 	*/
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
+	if (irqchip_in_kernel(vcpu->kvm) && vgic_initialized(vcpu->kvm)) {
+		phys_active = timer->irq.level ||
+				kvm_vgic_map_is_active(vcpu, timer->irq.irq);
+
+		/*
+		 * We want to avoid hitting the (re)distributor as much as
+		 * possible, as this is a potentially expensive MMIO access
+		 * (not to mention locks in the irq layer), and a solution for
+		 * this is to cache the "active" state in memory.
+		 *
+		 * Things to consider: we cannot cache an "active set" state,
+		 * because the HW can change this behind our back (it becomes
+		 * "clear" in the HW). We must then restrict the caching to
+		 * the "clear" state.
+		 *
+		 * The cache is invalidated on:
+		 * - vcpu put, indicating that the HW cannot be trusted to be
+		 *   in a sane state on the next vcpu load,
+		 * - any change in the interrupt state
+		 *
+		 * Usage conditions:
+		 * - cached value is "active clear"
+		 * - value to be programmed is "active clear"
+		 */
+		if (timer->active_cleared_last && !phys_active)
+			return;
+
+		ret = irq_set_irqchip_state(host_vtimer_irq,
+					    IRQCHIP_STATE_ACTIVE,
+					    phys_active);
+	} else {
+		/* User space tells us whether the timer is in active mode */
+		phys_active = vcpu->run->request_interrupt_window &
+			      KVM_IRQWINDOW_VTIMER;
+
+		/* However if the line is high, we exit anyway, so we want
+		 * to keep the IRQ masked */
+		phys_active = phys_active || timer->irq.level;
+
+		/*
+		 * So we can just explicitly mask or unmask the IRQ, gaining
+		 * more compatibility with oddball irq controllers.
+		 */
+		if (phys_active)
+			disable_percpu_irq(host_vtimer_irq);
+		else
+			enable_percpu_irq(host_vtimer_irq, 0);
+
+		ret = 0;
+	}
 
-	ret = irq_set_irqchip_state(host_vtimer_irq,
-				    IRQCHIP_STATE_ACTIVE,
-				    phys_active);
 	WARN_ON(ret);
 
 	timer->active_cleared_last = !phys_active;
@@ -479,6 +532,10 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	if (timer->enabled)
 		return 0;
 
+	/* No need to route physical IRQs when we don't use the vgic */
+	if (!irqchip_in_kernel(vcpu->kvm))
+		goto no_vgic;
+
 	/*
 	 * Find the physical IRQ number corresponding to the host_vtimer_irq
 	 */
@@ -502,6 +559,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
+no_vgic:
 
 	/*
 	 * There is a potential race here between VCPUs starting for the first
-- 
2.6.6
