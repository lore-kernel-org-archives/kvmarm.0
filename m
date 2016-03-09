From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 83/95] KVM: arm/arm64: timer: Add active state caching
Date: Wed,  9 Mar 2016 07:31:17 +0000
Message-ID: <1457508689-19672-84-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E361149B30
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q7cOcEdtvBbV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:35:42 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3BB649BBF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:41 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Programming the active state in the (re)distributor can be an
expensive operation so it makes some sense to try and reduce
the number of accesses as much as possible. So far, we
program the active state on each VM entry, but there is some
opportunity to do less.

An obvious solution is to cache the active state in memory,
and only program it in the HW when conditions change. But
because the HW can also change things under our feet (the active
state can transition from 1 to 0 when the guest does an EOI),
some precautions have to be taken, which amount to only caching
an "inactive" state, and always programing it otherwise.

With this in place, we observe a reduction of around 700 cycles
on a 2GHz GICv2 platform for a NULL hypercall.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/arm.c           |  1 +
 include/kvm/arm_arch_timer.h |  5 +++++
 virt/kvm/arm/arch_timer.c    | 31 +++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 75c7fed..9ca653e 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -322,6 +322,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	vcpu->cpu = -1;
 
 	kvm_arm_set_running_vcpu(NULL);
+	kvm_timer_vcpu_put(vcpu);
 }
 
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 1800227..b651aed 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -55,6 +55,9 @@ struct arch_timer_cpu {
 
 	/* VGIC mapping */
 	struct irq_phys_map		*map;
+
+	/* Active IRQ state caching */
+	bool				active_cleared_last;
 };
 
 int kvm_timer_hyp_init(void);
@@ -74,4 +77,6 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu);
 void kvm_timer_schedule(struct kvm_vcpu *vcpu);
 void kvm_timer_unschedule(struct kvm_vcpu *vcpu);
 
+void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
+
 #endif
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index ea60646..a9ad4fe 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -34,6 +34,11 @@ static struct timecounter *timecounter;
 static struct workqueue_struct *wqueue;
 static unsigned int host_vtimer_irq;
 
+void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.timer_cpu.active_cleared_last = false;
+}
+
 static cycle_t kvm_phys_timer_read(void)
 {
 	return timecounter->cc->read(timecounter->cc);
@@ -130,6 +135,7 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
 
 	BUG_ON(!vgic_initialized(vcpu->kvm));
 
+	timer->active_cleared_last = false;
 	timer->irq.level = new_level;
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->map->virt_irq,
 				   timer->irq.level);
@@ -245,10 +251,35 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	else
 		phys_active = false;
 
+	/*
+	 * We want to avoid hitting the (re)distributor as much as
+	 * possible, as this is a potentially expensive MMIO access
+	 * (not to mention locks in the irq layer), and a solution for
+	 * this is to cache the "active" state in memory.
+	 *
+	 * Things to consider: we cannot cache an "active set" state,
+	 * because the HW can change this behind our back (it becomes
+	 * "clear" in the HW). We must then restrict the caching to
+	 * the "clear" state.
+	 *
+	 * The cache is invalidated on:
+	 * - vcpu put, indicating that the HW cannot be trusted to be
+	 *   in a sane state on the next vcpu load,
+	 * - any change in the interrupt state
+	 *
+	 * Usage conditions:
+	 * - cached value is "active clear"
+	 * - value to be programmed is "active clear"
+	 */
+	if (timer->active_cleared_last && !phys_active)
+		return;
+
 	ret = irq_set_irqchip_state(timer->map->irq,
 				    IRQCHIP_STATE_ACTIVE,
 				    phys_active);
 	WARN_ON(ret);
+
+	timer->active_cleared_last = !phys_active;
 }
 
 /**
-- 
2.1.4
