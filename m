From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC 1/8] KVM: arm/arm64: Abstract virtual timer context into
 separate structure
Date: Mon, 26 Dec 2016 12:11:59 -0500
Message-ID: <1482772326-29110-2-git-send-email-jintack@cs.columbia.edu>
References: <1482772326-29110-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ED1A405D2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:22:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xeNQ23YKO7sB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Dec 2016 12:22:53 -0500 (EST)
Received: from outprodmail02.cc.columbia.edu (outprodmail02.cc.columbia.edu
 [128.59.72.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52EF340423
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:22:53 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail02.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uBQHK6l7032175
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:24:17 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id E5EE083
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:24:17 -0500 (EST)
Received: from sendprodmail03.cc.columbia.edu (sendprodmail03.cc.columbia.edu
 [128.59.72.15]) by hazelnut (Postfix) with ESMTP id AC17282
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:24:17 -0500 (EST)
Received: from mail-qk0-f200.google.com (mail-qk0-f200.google.com
 [209.85.220.200])
 by sendprodmail03.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id uBQHOH37047544
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 12:24:17 -0500
Received: by mail-qk0-f200.google.com with SMTP id q128so144241088qkd.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Dec 2016 09:24:17 -0800 (PST)
In-Reply-To: <1482772326-29110-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvm@vger.kernel.org, andre.przywara@arm.com, will.deacon@arm.com, linux@armlinux.org.uk, linux-kernel@vger.kernel.org, catalin.marinas@arm.com, pbonzini@redhat.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Abstract virtual timer context into a separate structure and change all
callers referring to timer registers, irq state and so on. No change in
functionality.

This is about to become very handy when adding the EL1 physical timer.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/arm_arch_timer.h | 32 +++++++++---------
 virt/kvm/arm/arch_timer.c    | 77 ++++++++++++++++++++++----------------------
 virt/kvm/arm/hyp/timer-sr.c  | 16 ++++-----
 3 files changed, 63 insertions(+), 62 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index dda39d8..7dabe56 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -28,15 +28,23 @@ struct arch_timer_kvm {
 	cycle_t			cntvoff;
 };
 
-struct arch_timer_cpu {
+struct arch_timer_context {
 	/* Registers: control register, timer value */
-	u32				cntv_ctl;	/* Saved/restored */
-	cycle_t				cntv_cval;	/* Saved/restored */
+	u32				cnt_ctl;
+	cycle_t				cnt_cval;
+
+	/* Timer IRQ */
+	struct kvm_irq_level		irq;
 
-	/*
-	 * Anything that is not used directly from assembly code goes
-	 * here.
-	 */
+	/* Active IRQ state caching */
+	bool				active_cleared_last;
+
+	/* Is the timer enabled */
+	bool			enabled;
+};
+
+struct arch_timer_cpu {
+	struct arch_timer_context	vtimer;
 
 	/* Background timer used when the guest is not running */
 	struct hrtimer			timer;
@@ -46,15 +54,6 @@ struct arch_timer_cpu {
 
 	/* Background timer active */
 	bool				armed;
-
-	/* Timer IRQ */
-	struct kvm_irq_level		irq;
-
-	/* Active IRQ state caching */
-	bool				active_cleared_last;
-
-	/* Is the timer enabled */
-	bool			enabled;
 };
 
 int kvm_timer_hyp_init(void);
@@ -76,4 +75,5 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
 
+#define vcpu_vtimer(v)	(&(v)->arch.timer_cpu.vtimer)
 #endif
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 27a1f63..30a64df 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -36,7 +36,7 @@
 
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.timer_cpu.active_cleared_last = false;
+	vcpu_vtimer(vcpu)->active_cleared_last = false;
 }
 
 static cycle_t kvm_phys_timer_read(void)
@@ -104,7 +104,7 @@ static u64 kvm_timer_compute_delta(struct kvm_vcpu *vcpu)
 {
 	cycle_t cval, now;
 
-	cval = vcpu->arch.timer_cpu.cntv_cval;
+	cval = vcpu_vtimer(vcpu)->cnt_cval;
 	now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
 
 	if (now < cval) {
@@ -146,21 +146,21 @@ static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
 
 static bool kvm_timer_irq_can_fire(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
-	return !(timer->cntv_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
-		(timer->cntv_ctl & ARCH_TIMER_CTRL_ENABLE);
+	return !(vtimer->cnt_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
+		(vtimer->cnt_ctl & ARCH_TIMER_CTRL_ENABLE);
 }
 
 bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	cycle_t cval, now;
 
 	if (!kvm_timer_irq_can_fire(vcpu))
 		return false;
 
-	cval = timer->cntv_cval;
+	cval = vtimer->cnt_cval;
 	now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
 
 	return cval <= now;
@@ -169,17 +169,17 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
 static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
 {
 	int ret;
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
 	BUG_ON(!vgic_initialized(vcpu->kvm));
 
-	timer->active_cleared_last = false;
-	timer->irq.level = new_level;
-	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->irq.irq,
-				   timer->irq.level);
+	vtimer->active_cleared_last = false;
+	vtimer->irq.level = new_level;
+	trace_kvm_timer_update_irq(vcpu->vcpu_id, vtimer->irq.irq,
+				   vtimer->irq.level);
 	ret = kvm_vgic_inject_mapped_irq(vcpu->kvm, vcpu->vcpu_id,
-					 timer->irq.irq,
-					 timer->irq.level);
+					 vtimer->irq.irq,
+					 vtimer->irq.level);
 	WARN_ON(ret);
 }
 
@@ -189,19 +189,19 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
  */
 static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
 	/*
 	 * If userspace modified the timer registers via SET_ONE_REG before
-	 * the vgic was initialized, we mustn't set the timer->irq.level value
+	 * the vgic was initialized, we mustn't set the vtimer->irq.level value
 	 * because the guest would never see the interrupt.  Instead wait
 	 * until we call this function from kvm_timer_flush_hwstate.
 	 */
-	if (!vgic_initialized(vcpu->kvm) || !timer->enabled)
+	if (!vgic_initialized(vcpu->kvm) || !vtimer->enabled)
 		return -ENODEV;
 
-	if (kvm_timer_should_fire(vcpu) != timer->irq.level)
-		kvm_timer_update_irq(vcpu, !timer->irq.level);
+	if (kvm_timer_should_fire(vcpu) != vtimer->irq.level)
+		kvm_timer_update_irq(vcpu, !vtimer->irq.level);
 
 	return 0;
 }
@@ -251,7 +251,7 @@ void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
  */
 void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	bool phys_active;
 	int ret;
 
@@ -275,8 +275,8 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	* to ensure that hardware interrupts from the timer triggers a guest
 	* exit.
 	*/
-	phys_active = timer->irq.level ||
-			kvm_vgic_map_is_active(vcpu, timer->irq.irq);
+	phys_active = vtimer->irq.level ||
+			kvm_vgic_map_is_active(vcpu, vtimer->irq.irq);
 
 	/*
 	 * We want to avoid hitting the (re)distributor as much as
@@ -298,7 +298,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	 * - cached value is "active clear"
 	 * - value to be programmed is "active clear"
 	 */
-	if (timer->active_cleared_last && !phys_active)
+	if (vtimer->active_cleared_last && !phys_active)
 		return;
 
 	ret = irq_set_irqchip_state(host_vtimer_irq,
@@ -306,7 +306,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 				    phys_active);
 	WARN_ON(ret);
 
-	timer->active_cleared_last = !phys_active;
+	vtimer->active_cleared_last = !phys_active;
 }
 
 /**
@@ -332,7 +332,7 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 			 const struct kvm_irq_level *irq)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
 	/*
 	 * The vcpu timer irq number cannot be determined in
@@ -340,7 +340,7 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	 * kvm_vcpu_set_target(). To handle this, we determine
 	 * vcpu timer irq number when the vcpu is reset.
 	 */
-	timer->irq.irq = irq->irq;
+	vtimer->irq.irq = irq->irq;
 
 	/*
 	 * The bits in CNTV_CTL are architecturally reset to UNKNOWN for ARMv8
@@ -348,7 +348,7 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	 * resets the timer to be disabled and unmasked and is compliant with
 	 * the ARMv7 architecture.
 	 */
-	timer->cntv_ctl = 0;
+	vtimer->cnt_ctl = 0;
 	kvm_timer_update_state(vcpu);
 
 	return 0;
@@ -370,17 +370,17 @@ static void kvm_timer_init_interrupt(void *info)
 
 int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
 	switch (regid) {
 	case KVM_REG_ARM_TIMER_CTL:
-		timer->cntv_ctl = value;
+		vtimer->cnt_ctl = value;
 		break;
 	case KVM_REG_ARM_TIMER_CNT:
 		vcpu->kvm->arch.timer.cntvoff = kvm_phys_timer_read() - value;
 		break;
 	case KVM_REG_ARM_TIMER_CVAL:
-		timer->cntv_cval = value;
+		vtimer->cnt_cval = value;
 		break;
 	default:
 		return -1;
@@ -392,15 +392,15 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 
 u64 kvm_arm_timer_get_reg(struct kvm_vcpu *vcpu, u64 regid)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
 	switch (regid) {
 	case KVM_REG_ARM_TIMER_CTL:
-		return timer->cntv_ctl;
+		return vtimer->cnt_ctl;
 	case KVM_REG_ARM_TIMER_CNT:
 		return kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
 	case KVM_REG_ARM_TIMER_CVAL:
-		return timer->cntv_cval;
+		return vtimer->cnt_cval;
 	}
 	return (u64)-1;
 }
@@ -459,20 +459,21 @@ int kvm_timer_hyp_init(void)
 void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
 	timer_disarm(timer);
-	kvm_vgic_unmap_phys_irq(vcpu, timer->irq.irq);
+	kvm_vgic_unmap_phys_irq(vcpu, vtimer->irq.irq);
 }
 
 int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct irq_desc *desc;
 	struct irq_data *data;
 	int phys_irq;
 	int ret;
 
-	if (timer->enabled)
+	if (vtimer->enabled)
 		return 0;
 
 	/*
@@ -494,7 +495,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	 * Tell the VGIC that the virtual interrupt is tied to a
 	 * physical interrupt. We do that once per VCPU.
 	 */
-	ret = kvm_vgic_map_phys_irq(vcpu, timer->irq.irq, phys_irq);
+	ret = kvm_vgic_map_phys_irq(vcpu, vtimer->irq.irq, phys_irq);
 	if (ret)
 		return ret;
 
@@ -508,7 +509,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	 * the arch timers are enabled.
 	 */
 	if (timecounter)
-		timer->enabled = 1;
+		vtimer->enabled = 1;
 
 	return 0;
 }
diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
index 798866a..4bbd36c 100644
--- a/virt/kvm/arm/hyp/timer-sr.c
+++ b/virt/kvm/arm/hyp/timer-sr.c
@@ -24,12 +24,12 @@
 /* vcpu is already in the HYP VA space */
 void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	u64 val;
 
-	if (timer->enabled) {
-		timer->cntv_ctl = read_sysreg_el0(cntv_ctl);
-		timer->cntv_cval = read_sysreg_el0(cntv_cval);
+	if (vtimer->enabled) {
+		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
+		vtimer->cnt_cval = read_sysreg_el0(cntv_cval);
 	}
 
 	/* Disable the virtual timer */
@@ -47,7 +47,7 @@ void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
 void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	u64 val;
 
 	/*
@@ -59,10 +59,10 @@ void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
 	val |= CNTHCTL_EL1PCTEN;
 	write_sysreg(val, cnthctl_el2);
 
-	if (timer->enabled) {
+	if (vtimer->enabled) {
 		write_sysreg(kvm->arch.timer.cntvoff, cntvoff_el2);
-		write_sysreg_el0(timer->cntv_cval, cntv_cval);
+		write_sysreg_el0(vtimer->cnt_cval, cntv_cval);
 		isb();
-		write_sysreg_el0(timer->cntv_ctl, cntv_ctl);
+		write_sysreg_el0(vtimer->cnt_ctl, cntv_ctl);
 	}
 }
-- 
1.9.1
