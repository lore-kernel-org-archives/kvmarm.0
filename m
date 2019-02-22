From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 12/27] KVM: arm/arm64: timer: Rework data structures for
 multiple timers
Date: Fri, 22 Feb 2019 16:25:50 +0000
Message-ID: <20190222162605.5054-13-marc.zyngier@arm.com>
References: <20190222162605.5054-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E309B4A200
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:28:01 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yxk2wg7q6QUW for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 11:28:00 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EEC884A2AC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:27:59 -0500 (EST)
In-Reply-To: <20190222162605.5054-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, kvmarm@lists.cs.columbia.edu, Shaokun Zhang <zhangshaokun@hisilicon.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-arm-kernel@lists.infradead.org, Zenghui Yu <yuzenghui@huawei.com>, Colin Ian King <colin.king@canonical.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

Prepare for having 4 timer data structures (2 for now).

Move loaded to the cpu data structure and not the individual timer
structure, in preparation for assigning the EL1 phys timer as well.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_arch_timer.h | 41 ++++++++++++-------------
 virt/kvm/arm/arch_timer.c    | 58 +++++++++++++++++++-----------------
 2 files changed, 51 insertions(+), 48 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index d26b7fde9935..ab835112204d 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -36,6 +36,8 @@ enum kvm_arch_timer_regs {
 };
 
 struct arch_timer_context {
+	struct kvm_vcpu			*vcpu;
+
 	/* Registers: control register, timer value */
 	u32				cnt_ctl;
 	u64				cnt_cval;
@@ -43,32 +45,31 @@ struct arch_timer_context {
 	/* Timer IRQ */
 	struct kvm_irq_level		irq;
 
-	/*
-	 * We have multiple paths which can save/restore the timer state
-	 * onto the hardware, so we need some way of keeping track of
-	 * where the latest state is.
-	 *
-	 * loaded == true:  State is loaded on the hardware registers.
-	 * loaded == false: State is stored in memory.
-	 */
-	bool			loaded;
-
 	/* Virtual offset */
-	u64			cntvoff;
+	u64				cntvoff;
+
+	/* Emulated Timer (may be unused) */
+	struct hrtimer			hrtimer;
 };
 
 struct arch_timer_cpu {
-	struct arch_timer_context	vtimer;
-	struct arch_timer_context	ptimer;
+	struct arch_timer_context timers[NR_KVM_TIMERS];
 
 	/* Background timer used when the guest is not running */
 	struct hrtimer			bg_timer;
 
-	/* Physical timer emulation */
-	struct hrtimer			phys_timer;
-
 	/* Is the timer enabled */
 	bool			enabled;
+
+	/*
+	 * We have multiple paths which can save/restore the timer state
+	 * onto the hardware, so we need some way of keeping track of
+	 * where the latest state is.
+	 *
+	 * loaded == true:  State is loaded on the hardware registers.
+	 * loaded == false: State is stored in memory.
+	 */
+	bool			loaded;
 };
 
 int kvm_timer_hyp_init(bool);
@@ -98,10 +99,10 @@ void kvm_timer_init_vhe(void);
 
 bool kvm_arch_timer_get_input_level(int vintid);
 
-#define vcpu_vtimer(v)	(&(v)->arch.timer_cpu.vtimer)
-#define vcpu_ptimer(v)	(&(v)->arch.timer_cpu.ptimer)
-#define vcpu_get_timer(v,t)					\
-	(t == TIMER_VTIMER ? vcpu_vtimer(v) : vcpu_ptimer(v))
+#define vcpu_timer(v)	(&(v)->arch.timer_cpu)
+#define vcpu_get_timer(v,t)	(&vcpu_timer(v)->timers[(t)])
+#define vcpu_vtimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_VTIMER])
+#define vcpu_ptimer(v)	(&(v)->arch.timer_cpu.timers[TIMER_PTIMER])
 
 u64 kvm_arm_timer_read_sysreg(struct kvm_vcpu *vcpu,
 			      enum kvm_arch_timers tmr,
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index f7d377448438..471f9fd004c9 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -184,13 +184,11 @@ static enum hrtimer_restart kvm_bg_timer_expire(struct hrtimer *hrt)
 static enum hrtimer_restart kvm_phys_timer_expire(struct hrtimer *hrt)
 {
 	struct arch_timer_context *ptimer;
-	struct arch_timer_cpu *timer;
 	struct kvm_vcpu *vcpu;
 	u64 ns;
 
-	timer = container_of(hrt, struct arch_timer_cpu, phys_timer);
-	vcpu = container_of(timer, struct kvm_vcpu, arch.timer_cpu);
-	ptimer = vcpu_ptimer(vcpu);
+	ptimer = container_of(hrt, struct arch_timer_context, hrtimer);
+	vcpu = ptimer->vcpu;
 
 	/*
 	 * Check that the timer has really expired from the guest's
@@ -209,9 +207,10 @@ static enum hrtimer_restart kvm_phys_timer_expire(struct hrtimer *hrt)
 
 static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 {
+	struct arch_timer_cpu *timer = vcpu_timer(timer_ctx->vcpu);
 	u64 cval, now;
 
-	if (timer_ctx->loaded) {
+	if (timer->loaded) {
 		u32 cnt_ctl;
 
 		/* Only the virtual timer can be loaded so far */
@@ -280,7 +279,6 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 /* Schedule the background timer for the emulated timer. */
 static void phys_timer_emulate(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
 	/*
@@ -289,11 +287,11 @@ static void phys_timer_emulate(struct kvm_vcpu *vcpu)
 	 * then we also don't need a soft timer.
 	 */
 	if (kvm_timer_should_fire(ptimer) || !kvm_timer_irq_can_fire(ptimer)) {
-		soft_timer_cancel(&timer->phys_timer);
+		soft_timer_cancel(&ptimer->hrtimer);
 		return;
 	}
 
-	soft_timer_start(&timer->phys_timer, kvm_timer_compute_delta(ptimer));
+	soft_timer_start(&ptimer->hrtimer, kvm_timer_compute_delta(ptimer));
 }
 
 /*
@@ -303,7 +301,7 @@ static void phys_timer_emulate(struct kvm_vcpu *vcpu)
  */
 static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 	bool level;
@@ -329,13 +327,13 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
 
 static void vtimer_save_state(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	unsigned long flags;
 
 	local_irq_save(flags);
 
-	if (!vtimer->loaded)
+	if (!timer->loaded)
 		goto out;
 
 	if (timer->enabled) {
@@ -347,7 +345,7 @@ static void vtimer_save_state(struct kvm_vcpu *vcpu)
 	write_sysreg_el0(0, cntv_ctl);
 	isb();
 
-	vtimer->loaded = false;
+	timer->loaded = false;
 out:
 	local_irq_restore(flags);
 }
@@ -359,7 +357,7 @@ static void vtimer_save_state(struct kvm_vcpu *vcpu)
  */
 static void kvm_timer_blocking(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
@@ -379,20 +377,20 @@ static void kvm_timer_blocking(struct kvm_vcpu *vcpu)
 
 static void kvm_timer_unblocking(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 
 	soft_timer_cancel(&timer->bg_timer);
 }
 
 static void vtimer_restore_state(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	unsigned long flags;
 
 	local_irq_save(flags);
 
-	if (vtimer->loaded)
+	if (timer->loaded)
 		goto out;
 
 	if (timer->enabled) {
@@ -401,7 +399,7 @@ static void vtimer_restore_state(struct kvm_vcpu *vcpu)
 		write_sysreg_el0(vtimer->cnt_ctl, cntv_ctl);
 	}
 
-	vtimer->loaded = true;
+	timer->loaded = true;
 out:
 	local_irq_restore(flags);
 }
@@ -462,7 +460,7 @@ static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
 
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
@@ -507,7 +505,8 @@ bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
 
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
+	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
 	if (unlikely(!timer->enabled))
 		return;
@@ -523,7 +522,7 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	 * In any case, we re-schedule the hrtimer for the physical timer when
 	 * coming back to the VCPU thread in kvm_timer_vcpu_load().
 	 */
-	soft_timer_cancel(&timer->phys_timer);
+	soft_timer_cancel(&ptimer->hrtimer);
 
 	if (swait_active(kvm_arch_vcpu_wq(vcpu)))
 		kvm_timer_blocking(vcpu);
@@ -559,7 +558,7 @@ static void unmask_vtimer_irq_user(struct kvm_vcpu *vcpu)
 
 void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 
 	if (unlikely(!timer->enabled))
 		return;
@@ -570,7 +569,7 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
@@ -611,22 +610,25 @@ static void update_vtimer_cntvoff(struct kvm_vcpu *vcpu, u64 cntvoff)
 
 void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
 
 	/* Synchronize cntvoff across all vtimers of a VM. */
 	update_vtimer_cntvoff(vcpu, kvm_phys_timer_read());
-	vcpu_ptimer(vcpu)->cntvoff = 0;
+	ptimer->cntvoff = 0;
 
 	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 	timer->bg_timer.function = kvm_bg_timer_expire;
 
-	hrtimer_init(&timer->phys_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
-	timer->phys_timer.function = kvm_phys_timer_expire;
+	hrtimer_init(&ptimer->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	ptimer->hrtimer.function = kvm_phys_timer_expire;
 
 	vtimer->irq.irq = default_vtimer_irq.irq;
 	ptimer->irq.irq = default_ptimer_irq.irq;
+
+	vtimer->vcpu = vcpu;
+	ptimer->vcpu = vcpu;
 }
 
 static void kvm_timer_init_interrupt(void *info)
@@ -860,7 +862,7 @@ int kvm_timer_hyp_init(bool has_gic)
 
 void kvm_timer_vcpu_terminate(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 
 	soft_timer_cancel(&timer->bg_timer);
 }
@@ -904,7 +906,7 @@ bool kvm_arch_timer_get_input_level(int vintid)
 
 int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
+	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 	int ret;
 
-- 
2.20.1
