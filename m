Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2554639C010
	for <kvmarm@lists.linux.dev>; Fri, 17 Apr 2026 12:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776429979; cv=none; b=XFDQn5IBKpB3IqhJGQKaEVLiuFN4o27OqLv81YhixzI/Ya+rop7dLaEbELg1PhaNDZxBi4FIdlZ21Ra3M0qj4Yy5ToAKDcT1Y206zA5DRdu57vtdTZyI1UmEn4VqNnjn1BL+fS0fQLHb+lvT0TLU5eY18sBem0Wk0WAC7TmwNGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776429979; c=relaxed/simple;
	bh=cCzTpj8a7thfnmfP5wYleNzjqeTa21Yo99b1fJOtkiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oI+RN7GiV+BLz1TpFIMlNWvMPHEELz54e53JyY8dsbyr7yI2MuRJtDi2QMXhARHt0hqi82c95jvV0xSqDk5F2YfGCPZmk/Gav4xN9ASMvrIm/h2eEpIKWkhjBWcCeX0vDY1F+RHMLKcZaefq6hwsbKrFZlsm2QZcaamkgv3JPa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p7I9pR0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p7I9pR0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7650C19425;
	Fri, 17 Apr 2026 12:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776429978;
	bh=cCzTpj8a7thfnmfP5wYleNzjqeTa21Yo99b1fJOtkiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p7I9pR0bzyHRUEGRnTgPvE35EQulrmQxgwS2NHwhBiQ1MAAZLB+/WWxrSoC89zBr9
	 +whMDzoSsYnfWVlEOUCAizlXANpB6nBGXKvRiodzAFVgJA+7ge67ABCEBCDLBVHpY6
	 CEzk49NFYZL2hQBER5zuhh7g5j6ehWFlhgb+fT6hP+XX2M/cCk5mjSxajNkKZSERaN
	 6s+avKNfmm5ISnlDYu26afD/+eV+3NyPC9N8Zlta/o4nZEwNCsQ9SpL3QdjKFX8Yhu
	 kJ29v3ZhULlCG3a8O0fz5Zy/PLSw9PoYC9v+HQU5L4CWkDYs7/+0/IBqfo4QHYj1SB
	 YOCTY9+9ANOJg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wDiaO-0000000CRo5-31Ep;
	Fri, 17 Apr 2026 12:46:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/4] KVM: arm64: timer: Repaint kvm_timer_should_fire() to kvm_timer_pending()
Date: Fri, 17 Apr 2026 13:46:09 +0100
Message-ID: <20260417124612.2770268-2-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260417124612.2770268-1-maz@kernel.org>
References: <20260417124612.2770268-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kartikey406@gmail.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

kvm_timer_should_fire() seems to date back to a time where the author
of the timer code didn't seem to have made the word "pending" part of
their vocabulary.

Having since slightly improved on that front, let's rename this predicate
to kvm_timer_pending(), which clearly indicates whether the timer
interrupt is pending or not.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index cbea4d9ee9552..d6802fc87e085 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -42,7 +42,7 @@ static const u8 default_ppi[] = {
 static bool kvm_timer_irq_can_fire(struct arch_timer_context *timer_ctx);
 static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 				 struct arch_timer_context *timer_ctx);
-static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx);
+static bool kvm_timer_pending(struct arch_timer_context *timer_ctx);
 static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 				struct arch_timer_context *timer,
 				enum kvm_arch_timer_regs treg,
@@ -224,7 +224,7 @@ static irqreturn_t kvm_arch_timer_handler(int irq, void *dev_id)
 	else
 		ctx = map.direct_ptimer;
 
-	if (kvm_timer_should_fire(ctx))
+	if (kvm_timer_pending(ctx))
 		kvm_timer_update_irq(vcpu, true, ctx);
 
 	if (userspace_irqchip(vcpu->kvm) &&
@@ -358,7 +358,7 @@ static enum hrtimer_restart kvm_hrtimer_expire(struct hrtimer *hrt)
 	return HRTIMER_NORESTART;
 }
 
-static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
+static bool kvm_timer_pending(struct arch_timer_context *timer_ctx)
 {
 	enum kvm_arch_timers index;
 	u64 cval, now;
@@ -417,9 +417,9 @@ void kvm_timer_update_run(struct kvm_vcpu *vcpu)
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
 
@@ -473,21 +473,21 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
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
 	 * If the timer can fire now, we don't need to have a soft timer
 	 * scheduled for the future.  If the timer cannot fire at all,
 	 * then we also don't need a soft timer.
 	 */
-	if (should_fire || !kvm_timer_irq_can_fire(ctx))
+	if (pending || !kvm_timer_irq_can_fire(ctx))
 		return;
 
 	soft_timer_start(&ctx->hrtimer, kvm_timer_compute_delta(ctx));
@@ -685,7 +685,7 @@ static void kvm_timer_vcpu_load_gic(struct arch_timer_context *ctx)
 	 * this point and the register restoration, we'll take the
 	 * interrupt anyway.
 	 */
-	kvm_timer_update_irq(vcpu, kvm_timer_should_fire(ctx), ctx);
+	kvm_timer_update_irq(vcpu, kvm_timer_pending(ctx), ctx);
 
 	if (irqchip_in_kernel(vcpu->kvm))
 		phys_active = kvm_vgic_map_is_active(vcpu, timer_irq(ctx));
@@ -706,7 +706,7 @@ static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
 	 * this point and the register restoration, we'll take the
 	 * interrupt anyway.
 	 */
-	kvm_timer_update_irq(vcpu, kvm_timer_should_fire(vtimer), vtimer);
+	kvm_timer_update_irq(vcpu, kvm_timer_pending(vtimer), vtimer);
 
 	/*
 	 * When using a userspace irqchip with the architected timers and a
@@ -917,8 +917,8 @@ bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
 	vlevel = sregs->device_irq_level & KVM_ARM_DEV_EL1_VTIMER;
 	plevel = sregs->device_irq_level & KVM_ARM_DEV_EL1_PTIMER;
 
-	return kvm_timer_should_fire(vtimer) != vlevel ||
-	       kvm_timer_should_fire(ptimer) != plevel;
+	return kvm_timer_pending(vtimer) != vlevel ||
+	       kvm_timer_pending(ptimer) != plevel;
 }
 
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
@@ -1006,7 +1006,7 @@ static void unmask_vtimer_irq_user(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
 
-	if (!kvm_timer_should_fire(vtimer)) {
+	if (!kvm_timer_pending(vtimer)) {
 		kvm_timer_update_irq(vcpu, false, vtimer);
 		if (static_branch_likely(&has_gic_active_state))
 			set_timer_irq_phys_active(vtimer, false);
@@ -1579,7 +1579,7 @@ static bool kvm_arch_timer_get_input_level(int vintid)
 
 		ctx = vcpu_get_timer(vcpu, i);
 		if (timer_irq(ctx) == vintid)
-			return kvm_timer_should_fire(ctx);
+			return kvm_timer_pending(ctx);
 	}
 
 	/* A timer IRQ has fired, but no matching timer was found? */
-- 
2.47.3

