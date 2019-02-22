From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 14/27] KVM: arm/arm64: Rework the timer code to use a timer_map
Date: Fri, 22 Feb 2019 16:25:52 +0000
Message-ID: <20190222162605.5054-15-marc.zyngier@arm.com>
References: <20190222162605.5054-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CF244A200
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:28:14 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oo4S7q5u-zt7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Feb 2019 11:28:11 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B37164A331
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Feb 2019 11:28:11 -0500 (EST)
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

We are currently emulating two timers in two different ways.  When we
add support for nested virtualization in the future, we are going to be
emulating either two timers in two diffferent ways, or four timers in a
single way.

We need a unified data structure to keep track of how we map virtual
state to physical state and we need to cleanup some of the timer code to
operate more independently on a struct arch_timer_context instead of
trying to consider the global state of the VCPU and recomputing all
state.

Co-written with Marc Zyngier <marc.zyngier@arm.com>

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
---
 include/kvm/arm_arch_timer.h |  23 +--
 virt/kvm/arm/arch_timer.c    | 295 +++++++++++++++++++----------------
 virt/kvm/arm/trace.h         | 105 +++++++++++++
 3 files changed, 278 insertions(+), 145 deletions(-)

diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 6d4a33a9c45a..05a18dd265b5 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -51,11 +51,24 @@ struct arch_timer_context {
 	/* Emulated Timer (may be unused) */
 	struct hrtimer			hrtimer;
 
+	/*
+	 * We have multiple paths which can save/restore the timer state onto
+	 * the hardware, so we need some way of keeping track of where the
+	 * latest state is.
+	 */
+	bool				loaded;
+
 	/* Duplicated state from arch_timer.c for convenience */
 	u32				host_timer_irq;
 	u32				host_timer_irq_flags;
 };
 
+struct timer_map {
+	struct arch_timer_context *direct_vtimer;
+	struct arch_timer_context *direct_ptimer;
+	struct arch_timer_context *emul_ptimer;
+};
+
 struct arch_timer_cpu {
 	struct arch_timer_context timers[NR_KVM_TIMERS];
 
@@ -64,16 +77,6 @@ struct arch_timer_cpu {
 
 	/* Is the timer enabled */
 	bool			enabled;
-
-	/*
-	 * We have multiple paths which can save/restore the timer state
-	 * onto the hardware, so we need some way of keeping track of
-	 * where the latest state is.
-	 *
-	 * loaded == true:  State is loaded on the hardware registers.
-	 * loaded == false: State is stored in memory.
-	 */
-	bool			loaded;
 };
 
 int kvm_timer_hyp_init(bool);
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 10c15151c87e..17f9de73cc8a 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -68,6 +68,21 @@ u64 kvm_phys_timer_read(void)
 	return timecounter->cc->read(timecounter->cc);
 }
 
+static void get_timer_map(struct kvm_vcpu *vcpu, struct timer_map *map)
+{
+	if (has_vhe()) {
+		map->direct_vtimer = vcpu_vtimer(vcpu);
+		map->direct_ptimer = vcpu_ptimer(vcpu);
+		map->emul_ptimer = NULL;
+	} else {
+		map->direct_vtimer = vcpu_vtimer(vcpu);
+		map->direct_ptimer = NULL;
+		map->emul_ptimer = vcpu_ptimer(vcpu);
+	}
+
+	trace_kvm_get_timer_map(vcpu->vcpu_id, map);
+}
+
 static inline bool userspace_irqchip(struct kvm *kvm)
 {
 	return static_branch_unlikely(&userspace_irqchip_in_use) &&
@@ -89,6 +104,7 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
 {
 	struct kvm_vcpu *vcpu = *(struct kvm_vcpu **)dev_id;
 	struct arch_timer_context *ctx;
+	struct timer_map map;
 
 	/*
 	 * We may see a timer interrupt after vcpu_put() has been called which
@@ -99,10 +115,12 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
 	if (!vcpu)
 		return IRQ_HANDLED;
 
+	get_timer_map(vcpu, &map);
+
 	if (irq == host_vtimer_irq)
-		ctx = vcpu_vtimer(vcpu);
+		ctx = map.direct_vtimer;
 	else
-		ctx = vcpu_ptimer(vcpu);
+		ctx = map.direct_ptimer;
 
 	if (kvm_timer_should_fire(ctx))
 		kvm_timer_update_irq(vcpu, true, ctx);
@@ -136,7 +154,9 @@ static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
 
 static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
 {
-	return !(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
+	WARN_ON(timer_ctx && timer_ctx->loaded);
+	return timer_ctx &&
+	       !(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_IT_MASK) &&
 		(timer_ctx->cnt_ctl & ARCH_TIMER_CTRL_ENABLE);
 }
 
@@ -146,21 +166,22 @@ static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
  */
 static u64 kvm_timer_earliest_exp(struct kvm_vcpu *vcpu)
 {
-	u64 min_virt = ULLONG_MAX, min_phys = ULLONG_MAX;
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+	u64 min_delta = ULLONG_MAX;
+	int i;
 
-	if (kvm_timer_irq_can_fire(vtimer))
-		min_virt = kvm_timer_compute_delta(vtimer);
+	for (i = 0; i < NR_KVM_TIMERS; i++) {
+		struct arch_timer_context *ctx = &vcpu->arch.timer_cpu.timers[i];
 
-	if (kvm_timer_irq_can_fire(ptimer))
-		min_phys = kvm_timer_compute_delta(ptimer);
+		WARN(ctx->loaded, "timer %d loaded\n", i);
+		if (kvm_timer_irq_can_fire(ctx))
+			min_delta = min(min_delta, kvm_timer_compute_delta(ctx));
+	}
 
 	/* If none of timers can fire, then return 0 */
-	if ((min_virt == ULLONG_MAX) && (min_phys == ULLONG_MAX))
+	if (min_delta == ULLONG_MAX)
 		return 0;
 
-	return min(min_virt, min_phys);
+	return min_delta;
 }
 
 static enum hrtimer_restart kvm_bg_timer_expire(struct hrtimer *hrt)
@@ -187,37 +208,45 @@ static enum hrtimer_restart kvm_bg_timer_expire(struct hrtimer *hrt)
 	return HRTIMER_NORESTART;
 }
 
-static enum hrtimer_restart kvm_phys_timer_expire(struct hrtimer *hrt)
+static enum hrtimer_restart kvm_hrtimer_expire(struct hrtimer *hrt)
 {
-	struct arch_timer_context *ptimer;
+	struct arch_timer_context *ctx;
 	struct kvm_vcpu *vcpu;
 	u64 ns;
 
-	ptimer = container_of(hrt, struct arch_timer_context, hrtimer);
-	vcpu = ptimer->vcpu;
+	ctx = container_of(hrt, struct arch_timer_context, hrtimer);
+	vcpu = ctx->vcpu;
+
+	trace_kvm_timer_hrtimer_expire(ctx);
 
 	/*
 	 * Check that the timer has really expired from the guest's
 	 * PoV (NTP on the host may have forced it to expire
 	 * early). If not ready, schedule for a later time.
 	 */
-	ns = kvm_timer_compute_delta(ptimer);
+	ns = kvm_timer_compute_delta(ctx);
 	if (unlikely(ns)) {
 		hrtimer_forward_now(hrt, ns_to_ktime(ns));
 		return HRTIMER_RESTART;
 	}
 
-	kvm_timer_update_irq(vcpu, true, ptimer);
+	kvm_timer_update_irq(vcpu, true, ctx);
 	return HRTIMER_NORESTART;
 }
 
 static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 {
-	struct arch_timer_cpu *timer = vcpu_timer(timer_ctx->vcpu);
-	enum kvm_arch_timers index = arch_timer_ctx_index(timer_ctx);
+	struct arch_timer_cpu *timer;
+	enum kvm_arch_timers index;
 	u64 cval, now;
 
-	if (timer->loaded) {
+	if (!timer_ctx)
+		return false;
+
+	timer = vcpu_timer(timer_ctx->vcpu);
+	index = arch_timer_ctx_index(timer_ctx);
+
+	if (timer_ctx->loaded) {
 		u32 cnt_ctl = 0;
 
 		switch (index) {
@@ -249,13 +278,13 @@ static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 
 bool kvm_timer_is_pending(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+	struct timer_map map;
 
-	if (kvm_timer_should_fire(vtimer))
-		return true;
+	get_timer_map(vcpu, &map);
 
-	return kvm_timer_should_fire(ptimer);
+	return kvm_timer_should_fire(map.direct_vtimer) ||
+	       kvm_timer_should_fire(map.direct_ptimer) ||
+	       kvm_timer_should_fire(map.emul_ptimer);
 }
 
 /*
@@ -294,60 +323,28 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 	}
 }
 
-/* Schedule the background timer for the emulated timer. */
-static void phys_timer_emulate(struct kvm_vcpu *vcpu)
+static void timer_emulate(struct arch_timer_context *ctx)
 {
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+	bool should_fire = kvm_timer_should_fire(ctx);
 
-	/*
-	 * If the timer can fire now, we don't need to have a soft timer
-	 * scheduled for the future.  If the timer cannot fire at all,
-	 * then we also don't need a soft timer.
-	 */
-	if (kvm_timer_should_fire(ptimer) || !kvm_timer_irq_can_fire(ptimer)) {
-		soft_timer_cancel(&ptimer->hrtimer);
-		return;
-	}
-
-	soft_timer_start(&ptimer->hrtimer, kvm_timer_compute_delta(ptimer));
-}
-
-/*
- * Check if there was a change in the timer state, so that we should either
- * raise or lower the line level to the GIC or schedule a background timer to
- * emulate the physical timer.
- */
-static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
-{
-	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
-	bool level;
+	trace_kvm_timer_emulate(ctx, should_fire);
 
-	if (unlikely(!timer->enabled))
+	if (should_fire) {
+		kvm_timer_update_irq(ctx->vcpu, true, ctx);
 		return;
+	}
 
 	/*
-	 * If the timer virtual interrupt is a 'mapped' interrupt, part
-	 * of its lifecycle is offloaded to the hardware, and we therefore may
-	 * not have lowered the irq.level value before having to signal a new
-	 * interrupt, but have to signal an interrupt every time the level is
-	 * asserted.
+	 * If the timer can fire now, we don't need to have a soft timer
+	 * scheduled for the future.  If the timer cannot fire at all,
+	 * then we also don't need a soft timer.
 	 */
-	level = kvm_timer_should_fire(vtimer);
-	kvm_timer_update_irq(vcpu, level, vtimer);
-
-	if (has_vhe()) {
-		level = kvm_timer_should_fire(ptimer);
-		kvm_timer_update_irq(vcpu, level, ptimer);
-
+	if (!kvm_timer_irq_can_fire(ctx)) {
+		soft_timer_cancel(&ctx->hrtimer);
 		return;
 	}
 
-	phys_timer_emulate(vcpu);
-
-	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
-		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
+	soft_timer_start(&ctx->hrtimer, kvm_timer_compute_delta(ctx));
 }
 
 static void timer_save_state(struct arch_timer_context *ctx)
@@ -361,7 +358,7 @@ static void timer_save_state(struct arch_timer_context *ctx)
 
 	local_irq_save(flags);
 
-	if (!timer->loaded)
+	if (!ctx->loaded)
 		goto out;
 
 	switch (index) {
@@ -384,10 +381,12 @@ static void timer_save_state(struct arch_timer_context *ctx)
 
 		break;
 	case NR_KVM_TIMERS:
-		break; /* GCC is braindead */
+		BUG();
 	}
 
-	timer->loaded = false;
+	trace_kvm_timer_save_state(ctx);
+
+	ctx->loaded = false;
 out:
 	local_irq_restore(flags);
 }
@@ -400,14 +399,17 @@ static void timer_save_state(struct arch_timer_context *ctx)
 static void kvm_timer_blocking(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+	struct timer_map map;
+
+	get_timer_map(vcpu, &map);
 
 	/*
-	 * If both timers are not capable of raising interrupts (disabled or
+	 * If no timers are capable of raising interrupts (disabled or
 	 * masked), then there's no more work for us to do.
 	 */
-	if (!kvm_timer_irq_can_fire(vtimer) && !kvm_timer_irq_can_fire(ptimer))
+	if (!kvm_timer_irq_can_fire(map.direct_vtimer) &&
+	    !kvm_timer_irq_can_fire(map.direct_ptimer) &&
+	    !kvm_timer_irq_can_fire(map.emul_ptimer))
 		return;
 
 	/*
@@ -435,7 +437,7 @@ static void timer_restore_state(struct arch_timer_context *ctx)
 
 	local_irq_save(flags);
 
-	if (timer->loaded)
+	if (ctx->loaded)
 		goto out;
 
 	switch (index) {
@@ -450,10 +452,12 @@ static void timer_restore_state(struct arch_timer_context *ctx)
 		write_sysreg_el0(ctx->cnt_ctl, cntp_ctl);
 		break;
 	case NR_KVM_TIMERS:
-		break; /* GCC is braindead */
+		BUG();
 	}
 
-	timer->loaded = true;
+	trace_kvm_timer_restore_state(ctx);
+
+	ctx->loaded = true;
 out:
 	local_irq_restore(flags);
 }
@@ -515,37 +519,31 @@ static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+	struct timer_map map;
 
 	if (unlikely(!timer->enabled))
 		return;
 
+	get_timer_map(vcpu, &map);
+
 	if (static_branch_likely(&has_gic_active_state)) {
-		kvm_timer_vcpu_load_gic(vtimer);
-		if (has_vhe())
-			kvm_timer_vcpu_load_gic(ptimer);
+		kvm_timer_vcpu_load_gic(map.direct_vtimer);
+		if (map.direct_ptimer)
+			kvm_timer_vcpu_load_gic(map.direct_ptimer);
 	} else {
 		kvm_timer_vcpu_load_nogic(vcpu);
 	}
 
-	set_cntvoff(vtimer->cntvoff);
-
-	timer_restore_state(vtimer);
-
-	if (has_vhe()) {
-		timer_restore_state(ptimer);
-		return;
-	}
-
-	/* Set the background timer for the physical timer emulation. */
-	phys_timer_emulate(vcpu);
+	set_cntvoff(map.direct_vtimer->cntvoff);
 
 	kvm_timer_unblocking(vcpu);
 
-	/* If the timer fired while we weren't running, inject it now */
-	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
-		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
+	timer_restore_state(map.direct_vtimer);
+	if (map.direct_ptimer)
+		timer_restore_state(map.direct_ptimer);
+
+	if (map.emul_ptimer)
+		timer_emulate(map.emul_ptimer);
 }
 
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
@@ -568,20 +566,19 @@ bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+	struct timer_map map;
 
 	if (unlikely(!timer->enabled))
 		return;
 
-	timer_save_state(vtimer);
-	if (has_vhe()) {
-		timer_save_state(ptimer);
-		return;
-	}
+	get_timer_map(vcpu, &map);
+
+	timer_save_state(map.direct_vtimer);
+	if (map.direct_ptimer)
+		timer_save_state(map.direct_ptimer);
 
 	/*
-	 * Cancel the physical timer emulation, because the only case where we
+	 * Cancel soft timer emulation, because the only case where we
 	 * need it after a vcpu_put is in the context of a sleeping VCPU, and
 	 * in that case we already factor in the deadline for the physical
 	 * timer when scheduling the bg_timer.
@@ -589,7 +586,8 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	 * In any case, we re-schedule the hrtimer for the physical timer when
 	 * coming back to the VCPU thread in kvm_timer_vcpu_load().
 	 */
-	soft_timer_cancel(&ptimer->hrtimer);
+	if (map.emul_ptimer)
+		soft_timer_cancel(&map.emul_ptimer->hrtimer);
 
 	if (swait_active(kvm_arch_vcpu_wq(vcpu)))
 		kvm_timer_blocking(vcpu);
@@ -636,8 +634,9 @@ void kvm_timer_sync_hwstate(struct kvm_vcpu *vcpu)
 int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+	struct timer_map map;
+
+	get_timer_map(vcpu, &map);
 
 	/*
 	 * The bits in CNTV_CTL are architecturally reset to UNKNOWN for ARMv8
@@ -645,12 +644,22 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu)
 	 * resets the timer to be disabled and unmasked and is compliant with
 	 * the ARMv7 architecture.
 	 */
-	vtimer->cnt_ctl = 0;
-	ptimer->cnt_ctl = 0;
-	kvm_timer_update_state(vcpu);
+	vcpu_vtimer(vcpu)->cnt_ctl = 0;
+	vcpu_ptimer(vcpu)->cnt_ctl = 0;
+
+	if (timer->enabled) {
+		kvm_timer_update_irq(vcpu, false, vcpu_vtimer(vcpu));
+		kvm_timer_update_irq(vcpu, false, vcpu_ptimer(vcpu));
+
+		if (irqchip_in_kernel(vcpu->kvm)) {
+			kvm_vgic_reset_mapped_irq(vcpu, map.direct_vtimer->irq.irq);
+			if (map.direct_ptimer)
+				kvm_vgic_reset_mapped_irq(vcpu, map.direct_ptimer->irq.irq);
+		}
+	}
 
-	if (timer->enabled && irqchip_in_kernel(vcpu->kvm))
-		kvm_vgic_reset_mapped_irq(vcpu, vtimer->irq.irq);
+	if (map.emul_ptimer)
+		soft_timer_cancel(&map.emul_ptimer->hrtimer);
 
 	return 0;
 }
@@ -687,15 +696,18 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	hrtimer_init(&timer->bg_timer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 	timer->bg_timer.function = kvm_bg_timer_expire;
 
+	hrtimer_init(&vtimer->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
 	hrtimer_init(&ptimer->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
-	ptimer->hrtimer.function = kvm_phys_timer_expire;
+	vtimer->hrtimer.function = kvm_hrtimer_expire;
+	ptimer->hrtimer.function = kvm_hrtimer_expire;
 
 	vtimer->irq.irq = default_vtimer_irq.irq;
-	vtimer->host_timer_irq = host_vtimer_irq;
-	vtimer->host_timer_irq_flags = host_vtimer_irq_flags;
-
 	ptimer->irq.irq = default_ptimer_irq.irq;
+
+	vtimer->host_timer_irq = host_vtimer_irq;
 	ptimer->host_timer_irq = host_ptimer_irq;
+
+	vtimer->host_timer_irq_flags = host_vtimer_irq_flags;
 	ptimer->host_timer_irq_flags = host_ptimer_irq_flags;
 
 	vtimer->vcpu = vcpu;
@@ -710,32 +722,39 @@ static void kvm_timer_init_interrupt(void *info)
 
 int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
 {
+	struct arch_timer_context *timer;
+	bool level;
+
 	switch (regid) {
 	case KVM_REG_ARM_TIMER_CTL:
-		kvm_arm_timer_write(vcpu,
-				    vcpu_vtimer(vcpu), TIMER_REG_CTL, value);
+		timer = vcpu_vtimer(vcpu);
+		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CTL, value);
 		break;
 	case KVM_REG_ARM_TIMER_CNT:
+		timer = vcpu_vtimer(vcpu);
 		update_vtimer_cntvoff(vcpu, kvm_phys_timer_read() - value);
 		break;
 	case KVM_REG_ARM_TIMER_CVAL:
-		kvm_arm_timer_write(vcpu,
-				    vcpu_vtimer(vcpu), TIMER_REG_CVAL, value);
+		timer = vcpu_vtimer(vcpu);
+		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CVAL, value);
 		break;
 	case KVM_REG_ARM_PTIMER_CTL:
-		kvm_arm_timer_write(vcpu,
-				    vcpu_ptimer(vcpu), TIMER_REG_CTL, value);
+		timer = vcpu_ptimer(vcpu);
+		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CTL, value);
 		break;
 	case KVM_REG_ARM_PTIMER_CVAL:
-		kvm_arm_timer_write(vcpu,
-				    vcpu_ptimer(vcpu), TIMER_REG_CVAL, value);
+		timer = vcpu_ptimer(vcpu);
+		kvm_arm_timer_write(vcpu, timer, TIMER_REG_CVAL, value);
 		break;
 
 	default:
 		return -1;
 	}
 
-	kvm_timer_update_state(vcpu);
+	level = kvm_timer_should_fire(timer);
+	kvm_timer_update_irq(vcpu, level, timer);
+	timer_emulate(timer);
+
 	return 0;
 }
 
@@ -1020,8 +1039,7 @@ bool kvm_arch_timer_get_input_level(int vintid)
 int kvm_timer_enable(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_cpu *timer = vcpu_timer(vcpu);
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
+	struct timer_map map;
 	int ret;
 
 	if (timer->enabled)
@@ -1039,18 +1057,25 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
 
-	ret = kvm_vgic_map_phys_irq(vcpu, host_vtimer_irq, vtimer->irq.irq,
+	get_timer_map(vcpu, &map);
+
+	ret = kvm_vgic_map_phys_irq(vcpu,
+				    map.direct_vtimer->host_timer_irq,
+				    map.direct_vtimer->irq.irq,
 				    kvm_arch_timer_get_input_level);
 	if (ret)
 		return ret;
 
-	if (has_vhe()) {
-		ret = kvm_vgic_map_phys_irq(vcpu, host_ptimer_irq, ptimer->irq.irq,
+	if (map.direct_ptimer) {
+		ret = kvm_vgic_map_phys_irq(vcpu,
+					    map.direct_ptimer->host_timer_irq,
+					    map.direct_ptimer->irq.irq,
 					    kvm_arch_timer_get_input_level);
-		if (ret)
-			return ret;
 	}
 
+	if (ret)
+		return ret;
+
 no_vgic:
 	timer->enabled = 1;
 	return 0;
diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
index 3828beab93f2..54bb059243b9 100644
--- a/virt/kvm/arm/trace.h
+++ b/virt/kvm/arm/trace.h
@@ -2,6 +2,7 @@
 #if !defined(_TRACE_KVM_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_KVM_H
 
+#include <kvm/arm_arch_timer.h>
 #include <linux/tracepoint.h>
 
 #undef TRACE_SYSTEM
@@ -262,6 +263,110 @@ TRACE_EVENT(kvm_timer_update_irq,
 		  __entry->vcpu_id, __entry->irq, __entry->level)
 );
 
+TRACE_EVENT(kvm_get_timer_map,
+	TP_PROTO(unsigned long vcpu_id, struct timer_map *map),
+	TP_ARGS(vcpu_id, map),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,		vcpu_id	)
+		__field(	int,			direct_vtimer	)
+		__field(	int,			direct_ptimer	)
+		__field(	int,			emul_ptimer	)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_id		= vcpu_id;
+		__entry->direct_vtimer		= arch_timer_ctx_index(map->direct_vtimer);
+		__entry->direct_ptimer =
+			(map->direct_ptimer) ? arch_timer_ctx_index(map->direct_ptimer) : -1;
+		__entry->emul_ptimer =
+			(map->emul_ptimer) ? arch_timer_ctx_index(map->emul_ptimer) : -1;
+	),
+
+	TP_printk("VCPU: %ld, dv: %d, dp: %d, ep: %d",
+		  __entry->vcpu_id,
+		  __entry->direct_vtimer,
+		  __entry->direct_ptimer,
+		  __entry->emul_ptimer)
+);
+
+TRACE_EVENT(kvm_timer_save_state,
+	TP_PROTO(struct arch_timer_context *ctx),
+	TP_ARGS(ctx),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,		ctl		)
+		__field(	unsigned long long,	cval		)
+		__field(	int,			timer_idx	)
+	),
+
+	TP_fast_assign(
+		__entry->ctl			= ctx->cnt_ctl;
+		__entry->cval			= ctx->cnt_cval;
+		__entry->timer_idx		= arch_timer_ctx_index(ctx);
+	),
+
+	TP_printk("   CTL: %#08lx CVAL: %#16llx arch_timer_ctx_index: %d",
+		  __entry->ctl,
+		  __entry->cval,
+		  __entry->timer_idx)
+);
+
+TRACE_EVENT(kvm_timer_restore_state,
+	TP_PROTO(struct arch_timer_context *ctx),
+	TP_ARGS(ctx),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,		ctl		)
+		__field(	unsigned long long,	cval		)
+		__field(	int,			timer_idx	)
+	),
+
+	TP_fast_assign(
+		__entry->ctl			= ctx->cnt_ctl;
+		__entry->cval			= ctx->cnt_cval;
+		__entry->timer_idx		= arch_timer_ctx_index(ctx);
+	),
+
+	TP_printk("CTL: %#08lx CVAL: %#16llx arch_timer_ctx_index: %d",
+		  __entry->ctl,
+		  __entry->cval,
+		  __entry->timer_idx)
+);
+
+TRACE_EVENT(kvm_timer_hrtimer_expire,
+	TP_PROTO(struct arch_timer_context *ctx),
+	TP_ARGS(ctx),
+
+	TP_STRUCT__entry(
+		__field(	int,			timer_idx	)
+	),
+
+	TP_fast_assign(
+		__entry->timer_idx		= arch_timer_ctx_index(ctx);
+	),
+
+	TP_printk("arch_timer_ctx_index: %d", __entry->timer_idx)
+);
+
+TRACE_EVENT(kvm_timer_emulate,
+	TP_PROTO(struct arch_timer_context *ctx, bool should_fire),
+	TP_ARGS(ctx, should_fire),
+
+	TP_STRUCT__entry(
+		__field(	int,			timer_idx	)
+		__field(	bool,			should_fire	)
+	),
+
+	TP_fast_assign(
+		__entry->timer_idx		= arch_timer_ctx_index(ctx);
+		__entry->should_fire		= should_fire;
+	),
+
+	TP_printk("arch_timer_ctx_index: %d (should_fire: %d)",
+		  __entry->timer_idx, __entry->should_fire)
+);
+
 #endif /* _TRACE_KVM_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.20.1
