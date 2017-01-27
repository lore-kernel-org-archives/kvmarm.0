From: Jintack Lim <jintack@cs.columbia.edu>
Subject: [RFC v2 01/10] KVM: arm/arm64: Abstract virtual timer context into
 separate structure
Date: Thu, 26 Jan 2017 20:04:51 -0500
Message-ID: <1485479100-4966-2-git-send-email-jintack@cs.columbia.edu>
References: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80B1040666
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:04:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BlYaUtOzrqzu for <kvmarm@lists.cs.columbia.edu>;
 Thu, 26 Jan 2017 20:04:55 -0500 (EST)
Received: from outprodmail01.cc.columbia.edu (outprodmail01.cc.columbia.edu
 [128.59.72.39])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D31040430
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:04:55 -0500 (EST)
Received: from hazelnut (hazelnut.cc.columbia.edu [128.59.213.250])
 by outprodmail01.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0R156KY051166
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:06 -0500
Received: from hazelnut (localhost.localdomain [127.0.0.1])
 by hazelnut (Postfix) with ESMTP id 5D97393
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:06 -0500 (EST)
Received: from sendprodmail04.cc.columbia.edu (sendprodmail04.cc.columbia.edu
 [128.59.72.16]) by hazelnut (Postfix) with ESMTP id 03129A0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:04 -0500 (EST)
Received: from mail-qt0-f199.google.com (mail-qt0-f199.google.com
 [209.85.216.199])
 by sendprodmail04.cc.columbia.edu (8.14.4/8.14.4) with ESMTP id v0R153ks011831
 (version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 20:05:03 -0500
Received: by mail-qt0-f199.google.com with SMTP id h53so62285679qth.6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 26 Jan 2017 17:05:03 -0800 (PST)
In-Reply-To: <1485479100-4966-1-git-send-email-jintack@cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: pbonzini@redhat.com, rkrcmar@redhat.com, christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, andre.przywara@arm.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Abstract virtual timer context into a separate structure and change all
callers referring to timer registers, irq state and so on. No change in
functionality.

This is about to become very handy when adding the EL1 physical timer.

Signed-off-by: Jintack Lim <jintack@cs.columbia.edu>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/arm_arch_timer.h | 27 ++++++++---------
 virt/kvm/arm/arch_timer.c    | 69 +++++++++++++++++++++++---------------------
 virt/kvm/arm/hyp/timer-sr.c  | 10 ++++---
 3 files changed, 56 insertions(+), 50 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 5c970ce..daad3c1 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -28,15 +28,20 @@ struct arch_timer_kvm {
 	u64			cntvoff;
 };
 
-struct arch_timer_cpu {
+struct arch_timer_context {
 	/* Registers: control register, timer value */
-	u32				cntv_ctl;	/* Saved/restored */
-	u64				cntv_cval;	/* Saved/restored */
+	u32				cnt_ctl;
+	u64				cnt_cval;
+
+	/* Timer IRQ */
+	struct kvm_irq_level		irq;
+
+	/* Active IRQ state caching */
+	bool				active_cleared_last;
+};
 
-	/*
-	 * Anything that is not used directly from assembly code goes
-	 * here.
-	 */
+struct arch_timer_cpu {
+	struct arch_timer_context	vtimer;
 
 	/* Background timer used when the guest is not running */
 	struct hrtimer			timer;
@@ -47,12 +52,6 @@ struct arch_timer_cpu {
 	/* Background timer active */
 	bool				armed;
 
-	/* Timer IRQ */
-	struct kvm_irq_level		irq;
-
-	/* Active IRQ state caching */
-	bool				active_cleared_last;
-
 	/* Is the timer enabled */
 	bool			enabled;
 };
@@ -77,4 +76,6 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
 
 void kvm_timer_init_vhe(void);
+
+#define vcpu_vtimer(v)	(&(v)->arch.timer_cpu.vtimer)
 #endif
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 6a084cd..6740efa 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -37,7 +37,7 @@
 
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.timer_cpu.active_cleared_last = false;
+	vcpu_vtimer(vcpu)->active_cleared_last = false;
 }
 
 static u64 kvm_phys_timer_read(void)
@@ -102,7 +102,7 @@ static u64 kvm_timer_compute_delta(struct kvm_vcpu *vcpu)
 {
 	u64 cval, now;
 
-	cval = vcpu->arch.timer_cpu.cntv_cval;
+	cval = vcpu_vtimer(vcpu)->cnt_cval;
 	now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
 
 	if (now < cval) {
@@ -144,21 +144,21 @@ static enum hrtimer_restart kvm_timer_expire(struct hrtimer *hrt)
 
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
 	u64 cval, now;
 
 	if (!kvm_timer_irq_can_fire(vcpu))
 		return false;
 
-	cval = timer->cntv_cval;
+	cval = vtimer->cnt_cval;
 	now = kvm_phys_timer_read() - vcpu->kvm->arch.timer.cntvoff;
 
 	return cval <= now;
@@ -167,17 +167,17 @@ bool kvm_timer_should_fire(struct kvm_vcpu *vcpu)
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
 
@@ -188,18 +188,19 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
 static int kvm_timer_update_state(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
 	/*
 	 * If userspace modified the timer registers via SET_ONE_REG before
-	 * the vgic was initialized, we mustn't set the timer->irq.level value
+	 * the vgic was initialized, we mustn't set the vtimer->irq.level value
 	 * because the guest would never see the interrupt.  Instead wait
 	 * until we call this function from kvm_timer_flush_hwstate.
 	 */
 	if (!vgic_initialized(vcpu->kvm) || !timer->enabled)
 		return -ENODEV;
 
-	if (kvm_timer_should_fire(vcpu) != timer->irq.level)
-		kvm_timer_update_irq(vcpu, !timer->irq.level);
+	if (kvm_timer_should_fire(vcpu) != vtimer->irq.level)
+		kvm_timer_update_irq(vcpu, !vtimer->irq.level);
 
 	return 0;
 }
@@ -249,7 +250,7 @@ void kvm_timer_unschedule(struct kvm_vcpu *vcpu)
  */
 void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	bool phys_active;
 	int ret;
 
@@ -273,8 +274,8 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	* to ensure that hardware interrupts from the timer triggers a guest
 	* exit.
 	*/
-	phys_active = timer->irq.level ||
-			kvm_vgic_map_is_active(vcpu, timer->irq.irq);
+	phys_active = vtimer->irq.level ||
+			kvm_vgic_map_is_active(vcpu, vtimer->irq.irq);
 
 	/*
 	 * We want to avoid hitting the (re)distributor as much as
@@ -296,7 +297,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 	 * - cached value is "active clear"
 	 * - value to be programmed is "active clear"
 	 */
-	if (timer->active_cleared_last && !phys_active)
+	if (vtimer->active_cleared_last && !phys_active)
 		return;
 
 	ret = irq_set_irqchip_state(host_vtimer_irq,
@@ -304,7 +305,7 @@ void kvm_timer_flush_hwstate(struct kvm_vcpu *vcpu)
 				    phys_active);
 	WARN_ON(ret);
 
-	timer->active_cleared_last = !phys_active;
+	vtimer->active_cleared_last = !phys_active;
 }
 
 /**
@@ -330,7 +331,7 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 			 const struct kvm_irq_level *irq)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
 	/*
 	 * The vcpu timer irq number cannot be determined in
@@ -338,7 +339,7 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	 * kvm_vcpu_set_target(). To handle this, we determine
 	 * vcpu timer irq number when the vcpu is reset.
 	 */
-	timer->irq.irq = irq->irq;
+	vtimer->irq.irq = irq->irq;
 
 	/*
 	 * The bits in CNTV_CTL are architecturally reset to UNKNOWN for ARMv8
@@ -346,7 +347,7 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
 	 * resets the timer to be disabled and unmasked and is compliant with
 	 * the ARMv7 architecture.
 	 */
-	timer->cntv_ctl = 0;
+	vtimer->cnt_ctl = 0;
 	kvm_timer_update_state(vcpu);
 
 	return 0;
@@ -368,17 +369,17 @@ static void kvm_timer_init_interrupt(void *info)
 
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
@@ -390,15 +391,15 @@ int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 
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
@@ -462,14 +463,16 @@ int kvm_timer_hyp_init(void)
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
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct irq_desc *desc;
 	struct irq_data *data;
 	int phys_irq;
@@ -497,7 +500,7 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 	 * Tell the VGIC that the virtual interrupt is tied to a
 	 * physical interrupt. We do that once per VCPU.
 	 */
-	ret = kvm_vgic_map_phys_irq(vcpu, timer->irq.irq, phys_irq);
+	ret = kvm_vgic_map_phys_irq(vcpu, vtimer->irq.irq, phys_irq);
 	if (ret)
 		return ret;
 
diff --git a/virt/kvm/arm/hyp/timer-sr.c b/virt/kvm/arm/hyp/timer-sr.c
index 63e28dd..0cf0895 100644
--- a/virt/kvm/arm/hyp/timer-sr.c
+++ b/virt/kvm/arm/hyp/timer-sr.c
@@ -25,11 +25,12 @@
 void __hyp_text __timer_save_state(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	u64 val;
 
 	if (timer->enabled) {
-		timer->cntv_ctl = read_sysreg_el0(cntv_ctl);
-		timer->cntv_cval = read_sysreg_el0(cntv_cval);
+		vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
+		vtimer->cnt_cval = read_sysreg_el0(cntv_cval);
 	}
 
 	/* Disable the virtual timer */
@@ -54,6 +55,7 @@ void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	u64 val;
 
 	/* Those bits are already configured at boot on VHE-system */
@@ -70,8 +72,8 @@ void __hyp_text __timer_restore_state(struct kvm_vcpu *vcpu)
 
 	if (timer->enabled) {
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
