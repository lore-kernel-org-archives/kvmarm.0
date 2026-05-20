Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86613AD515
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 10:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779271329; cv=none; b=rdK8lrEdA3+0Idn7eAbpjva1Tv9dn3LC3DnJFa689gGZ1ccps/PiuJCqFyTC9oYXjWHwnp2Y7BPpCLA2AVcYni6NlTCw5lNYZBa6b1g5EtOE8+kAgBvn0e6l5dKe42hVapbcB+5DMqwCuGYw8CQJBLgqT2oyrpaaV0bcNW8mA/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779271329; c=relaxed/simple;
	bh=yUjwkx7iy6jxqqccUN94MRrWohJdRTKlbXWk3jaepME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nK1W67+7acdt7LbvJBJz0xVXcKd81IY3D3fpy8rtq7mD3WjFV0xfcQK3fmz070zd1eae0HakRHSgQOiRQ7ztVhoFL/B7lN+RL7Qif2v9gKMfsrbXApGrlpmQE+LS4YT4AqbthYPt6FrMY+9Tp5XRhQtpiQlae2U/1m++Ni8DORU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hcQRw3J3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hcQRw3J3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685B01F000E9;
	Wed, 20 May 2026 10:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779271327;
	bh=NY+2pZVVAvATFq+ysNBOpYL7U+Uy80pALTBhFMXK+so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hcQRw3J3YIWmYuU55tp/4rLmozpH5lcyTNM+QkyiHChyWZoai2uOywNvjkcAk5UQm
	 V6YpzjxunGvsfazEfFHGR+BA6O5dKuD/Yw4WVEHXP9BLgdUpK86jDF+Dbo7hgl2EYi
	 4UfFIggXAOMBts//VrY8GM/xhAN/hkncunoOHbp0xT+IhpNq5XOsm3+CSvyqM1vSh6
	 fAJlvLief50HeOItAv4Xq0YEZjRzSCVeWq3hTFdru2DuEUV8PfNElKA7hsvHssPFeA
	 TOk1UhNaRY9d6ok67+xi47mrd6Sc/E0GQyKlA0TYWVIo2aRHift74z5nEkef9VdG7J
	 6rV+2pVozAxlg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPdkb-00000004Jio-2Qkd;
	Wed, 20 May 2026 10:02:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 1/6] KVM: arm64: timer: Repaint kvm_timer_{should,irq_can}_fire() to kvm_timer_{pending,enabled}()
Date: Wed, 20 May 2026 11:01:55 +0100
Message-ID: <20260520100200.543845-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520100200.543845-1-maz@kernel.org>
References: <20260520100200.543845-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kartikey406@gmail.com, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

kvm_timer_should_fire() seems to date back to a time where the author
of the timer code didn't seem to have made the word "pending" part of
their vocabulary.

Having since slightly improved on that front, let's rename this predicate
to kvm_timer_pending(), which clearly indicates whether the timer
interrupt is pending or not.

Similarly, kvm_timer_irq_can_fire() is renamed to kvm_timer_enabled().

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 55 ++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index cbea4d9ee9552..d8add34717f07 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -39,10 +39,9 @@ static const u8 default_ppi[] = {
 	[TIMER_HVTIMER] = 28,
 };
 
-static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx);
 static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 				 struct arch_timer_context *timer_ctx);
-static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx);
+static bool kvm_timer_pending(struct arch_timer_context *timer_ctx);
 static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 				struct arch_timer_context *timer,
 				enum kvm_arch_timer_regs treg,
@@ -224,7 +223,7 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
 	else
 		ctx = map.direct_ptimer;
 
-	if (kvm_timer_should_fire(ctx))
+	if (kvm_timer_pending(ctx))
 		kvm_timer_update_irq(vcpu, true, ctx);
 
 	if (userspace_irqchip(vcpu->kvm) &&
@@ -257,7 +256,7 @@ static u64 kvm_timer_compute_delta(struct arch_timer_context *timer_ctx)
 	return kvm_counter_compute_delta(timer_ctx, timer_get_cval(timer_ctx));
 }
 
-static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx)
+static bool kvm_timer_enabled(struct arch_timer_context *timer_ctx)
 {
 	WARN_ON(timer_ctx && timer_ctx->loaded);
 	return timer_ctx &&
@@ -294,7 +293,7 @@ static u64 kvm_timer_earliest_exp(struct kvm_vcpu *vcpu)
 		struct arch_timer_context *ctx = &vcpu->arch.timer_cpu.timers[i];
 
 		WARN(ctx->loaded, "timer %d loaded\n", i);
-		if (kvm_timer_irq_can_fire(ctx))
+		if (kvm_timer_enabled(ctx))
 			min_delta = min(min_delta, kvm_timer_compute_delta(ctx));
 	}
 
@@ -358,7 +357,7 @@ static enum hrtimer_restart kvm_hrtimer_expire(struct hrtimer *hrt)
 	return HRTIMER_NORESTART;
 }
 
-static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
+static bool kvm_timer_pending(struct arch_timer_context *timer_ctx)
 {
 	enum kvm_arch_timers index;
 	u64 cval, now;
@@ -391,7 +390,7 @@ static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 		       !(cnt_ctl & ARCH_TIMER_CTRL_IT_MASK);
 	}
 
-	if (!kvm_timer_irq_can_fire(timer_ctx))
+	if (!kvm_timer_enabled(timer_ctx))
 		return false;
 
 	cval = timer_get_cval(timer_ctx);
@@ -417,9 +416,9 @@ void kvm_timer_update_run(struct kvm_vcpu *vcpu)
 	/* Populate the device bitmap with the timer states */
 	regs->device_irq_level &= ~(KVM_ARM_DEV_EL1_VTIMER |
 				    KVM_ARM_DEV_EL1_PTIMER);
-	if (kvm_timer_should_fire(vtimer))
+	if (kvm_timer_pending(vtimer))
 		regs->device_irq_level |= KVM_ARM_DEV_EL1_VTIMER;
-	if (kvm_timer_should_fire(ptimer))
+	if (kvm_timer_pending(ptimer))
 		regs->device_irq_level |= KVM_ARM_DEV_EL1_PTIMER;
 }
 
@@ -473,21 +472,21 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 /* Only called for a fully emulated timer */
 static void timer_emulate(struct arch_timer_context *ctx)
 {
-	bool should_fire = kvm_timer_should_fire(ctx);
+	bool pending = kvm_timer_pending(ctx);
 
-	trace_kvm_timer_emulate(ctx, should_fire);
+	trace_kvm_timer_emulate(ctx, pending);
 
-	if (should_fire != ctx->irq.level)
-		kvm_timer_update_irq(timer_context_to_vcpu(ctx), should_fire, ctx);
+	if (pending != ctx->irq.level)
+		kvm_timer_update_irq(timer_context_to_vcpu(ctx), pending, ctx);
 
-	kvm_timer_update_status(ctx, should_fire);
+	kvm_timer_update_status(ctx, pending);
 
 	/*
-	 * If the timer can fire now, we don't need to have a soft timer
-	 * scheduled for the future.  If the timer cannot fire at all,
-	 * then we also don't need a soft timer.
+	 * If the timer is pending, we don't need to have a soft timer
+	 * scheduled for the future.  If the timer is disabled, then
+	 * we don't need a soft timer either.
 	 */
-	if (should_fire || !kvm_timer_irq_can_fire(ctx))
+	if (pending || !kvm_timer_enabled(ctx))
 		return;
 
 	soft_timer_start(&ctx->hrtimer, kvm_timer_compute_delta(ctx));
@@ -594,10 +593,10 @@ static void kvm_timer_blocking(struct kvm_vcpu *vcpu)
 	 * If no timers are capable of raising interrupts (disabled or
 	 * masked), then there's no more work for us to do.
 	 */
-	if (!kvm_timer_irq_can_fire(map.direct_vtimer) &&
-	    !kvm_timer_irq_can_fire(map.direct_ptimer) &&
-	    !kvm_timer_irq_can_fire(map.emul_vtimer) &&
-	    !kvm_timer_irq_can_fire(map.emul_ptimer) &&
+	if (!kvm_timer_enabled(map.direct_vtimer) &&
+	    !kvm_timer_enabled(map.direct_ptimer) &&
+	    !kvm_timer_enabled(map.emul_vtimer) &&
+	    !kvm_timer_enabled(map.emul_ptimer) &&
 	    !vcpu_has_wfit_active(vcpu))
 		return;
 
@@ -685,7 +684,7 @@ static void kvm_timer_vcpu_load_gic(struct arch_timer_context *ctx)
 	 * this point and the register restoration, we'll take the
 	 * interrupt anyway.
 	 */
-	kvm_timer_update_irq(vcpu, kvm_timer_should_fire(ctx), ctx);
+	kvm_timer_update_irq(vcpu, kvm_timer_pending(ctx), ctx);
 
 	if (irqchip_in_kernel(vcpu->kvm))
 		phys_active = kvm_vgic_map_is_active(vcpu, timer_irq(ctx));
@@ -706,7 +705,7 @@ static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
 	 * this point and the register restoration, we'll take the
 	 * interrupt anyway.
 	 */
-	kvm_timer_update_irq(vcpu, kvm_timer_should_fire(vtimer), vtimer);
+	kvm_timer_update_irq(vcpu, kvm_timer_pending(vtimer), vtimer);
 
 	/*
 	 * When using a userspace irqchip with the architected timers and a
@@ -917,8 +916,8 @@ bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
 	vlevel = sregs->device_irq_level & KVM_ARM_DEV_EL1_VTIMER;
 	plevel = sregs->device_irq_level & KVM_ARM_DEV_EL1_PTIMER;
 
-	return kvm_timer_should_fire(vtimer) != vlevel ||
-	       kvm_timer_should_fire(ptimer) != plevel;
+	return kvm_timer_pending(vtimer) != vlevel ||
+	       kvm_timer_pending(ptimer) != plevel;
 }
 
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
@@ -1006,7 +1005,7 @@ static void unmask_vtimer_irq_user(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
-	if (!kvm_timer_should_fire(vtimer)) {
+	if (!kvm_timer_pending(vtimer)) {
 		kvm_timer_update_irq(vcpu, false, vtimer);
 		if (static_branch_likely(&has_gic_active_state))
 			set_timer_irq_phys_active(vtimer, false);
@@ -1579,7 +1578,7 @@ static bool kvm_arch_timer_get_input_level(int vintid)
 
 		ctx = vcpu_get_timer(vcpu, i);
 		if (timer_irq(ctx) == vintid)
-			return kvm_timer_should_fire(ctx);
+			return kvm_timer_pending(ctx);
 	}
 
 	/* A timer IRQ has fired, but no matching timer was found? */
-- 
2.47.3

