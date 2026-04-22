Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912F62773F0
	for <kvmarm@lists.linux.dev>; Wed, 22 Apr 2026 10:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776852135; cv=none; b=Ir0fwJghgRqhJPn58/jmNi5oMkdy8RWqGTjl1fWUPRif+JWfwIq+xA28WafUUxAapsfzzfIR+gmCDDkLkq6rgqTi/EoKP+8q0Z8DuEXo8M0MLa6aRs3c4gKhLqlFRRoJ86PGiU1Zp7jBGyvFGWIK6uH+tZDnQRS86FvnPSheaWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776852135; c=relaxed/simple;
	bh=MYIzJavI3yebu0vMZIgZk6qVHjn6xHFyWVX9r0v7fRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLmxtA36JhCbNOm7WPP8cjXjnBmiOHi8NT+4QhOcYg9UeK6SMpEAjg6nzH1nkdLQ0jplDUTCPvSsdpCCrnf9H5Qr9Hnq6VS4Y0hhY8VZ0qu6eZnmklrEPqj7Kd+Xy9t8fmtKdoD/zO3oeEuAx6bGcGYudRn6eTWbZs/QOA8LS1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TS9sAN6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TS9sAN6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6614CC2BCB3;
	Wed, 22 Apr 2026 10:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776852135;
	bh=MYIzJavI3yebu0vMZIgZk6qVHjn6xHFyWVX9r0v7fRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TS9sAN6pPt9RokB5uVO1C+XJbE+mm9F8S/D1C9OA2W1puXSJ7ZLsLwtaW2nGvEOTt
	 Y1Nx9yL7OmsyFrOI8Rqe83dOtHR/idnMvlU1jIWJH9DoBQoXWE2MEDIeBVzREMOSuF
	 tngxFw42PzlJB032k8TSMA2CPEZMIKFhCK2ByCzAvyh6/1HVC9UiHq1XSYc7TifO7B
	 7hKrZzu1f6lR+5ytM8hS0y5TvxpiwiC5NTGEUcN737G8OPY+YEC4YVhrJdMrzyS3/w
	 OqSygnqMOR1puu8Ja+NWrufDqzOZ7xSckhJWz3Ag/XQCDJL9H610KrPTKJoFKx4MYb
	 JE5D6eJ2B8vWw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wFUPN-0000000Dh6d-1OnG;
	Wed, 22 Apr 2026 10:02:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 2/4] KVM: arm64: timer: Kill the per-timer level cache
Date: Wed, 22 Apr 2026 11:02:08 +0100
Message-ID: <20260422100210.3008156-3-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260422100210.3008156-1-maz@kernel.org>
References: <20260422100210.3008156-1-maz@kernel.org>
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

The timer code makes use of a per-timer irq level cache, which
looks like a very minor optimisation to avoid taking a lock upon
updating the GIC view of the interrupt when it is unchanged from
the previous state.

This is coming in the way of more important correctness issues,
so get rid of the cache, which simplifies a couple of minor things.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c  | 20 +++++++++-----------
 include/kvm/arm_arch_timer.h |  5 -----
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 22e79ecb34bc4..5cfe223da2996 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -445,9 +445,8 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 {
 	kvm_timer_update_status(timer_ctx, new_level);
 
-	timer_ctx->irq.level = new_level;
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_irq(timer_ctx),
-				   timer_ctx->irq.level);
+				   new_level);
 
 	if (userspace_irqchip(vcpu->kvm))
 		return;
@@ -465,7 +464,7 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 
 	kvm_vgic_inject_irq(vcpu->kvm, vcpu,
 			    timer_irq(timer_ctx),
-			    timer_ctx->irq.level,
+			    new_level,
 			    timer_ctx);
 }
 
@@ -476,10 +475,7 @@ static void timer_emulate(struct arch_timer_context *ctx)
 
 	trace_kvm_timer_emulate(ctx, pending);
 
-	if (pending != ctx->irq.level)
-		kvm_timer_update_irq(timer_context_to_vcpu(ctx), pending, ctx);
-
-	kvm_timer_update_status(ctx, pending);
+	kvm_timer_update_irq(timer_context_to_vcpu(ctx), pending, ctx);
 
 	/*
 	 * If the timer can fire now, we don't need to have a soft timer
@@ -676,6 +672,7 @@ static inline void set_timer_irq_phys_active(struct arch_timer_context *ctx, boo
 static void kvm_timer_vcpu_load_gic(struct arch_timer_context *ctx)
 {
 	struct kvm_vcpu *vcpu = timer_context_to_vcpu(ctx);
+	bool pending = kvm_timer_pending(ctx);
 	bool phys_active = false;
 
 	/*
@@ -684,12 +681,12 @@ static void kvm_timer_vcpu_load_gic(struct arch_timer_context *ctx)
 	 * this point and the register restoration, we'll take the
 	 * interrupt anyway.
 	 */
-	kvm_timer_update_irq(vcpu, kvm_timer_pending(ctx), ctx);
+	kvm_timer_update_irq(vcpu, pending, ctx);
 
 	if (irqchip_in_kernel(vcpu->kvm))
 		phys_active = kvm_vgic_map_is_active(vcpu, timer_irq(ctx));
 
-	phys_active |= ctx->irq.level;
+	phys_active |= pending;
 	phys_active |= vgic_is_v5(vcpu->kvm);
 
 	set_timer_irq_phys_active(ctx, phys_active);
@@ -698,6 +695,7 @@ static void kvm_timer_vcpu_load_gic(struct arch_timer_context *ctx)
 static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+	bool pending = kvm_timer_pending(vtimer);
 
 	/*
 	 * Update the timer output so that it is likely to match the
@@ -705,7 +703,7 @@ static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
 	 * this point and the register restoration, we'll take the
 	 * interrupt anyway.
 	 */
-	kvm_timer_update_irq(vcpu, kvm_timer_pending(vtimer), vtimer);
+	kvm_timer_update_irq(vcpu, pending, vtimer);
 
 	/*
 	 * When using a userspace irqchip with the architected timers and a
@@ -717,7 +715,7 @@ static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
 	 * being de-asserted, we unmask the interrupt again so that we exit
 	 * from the guest when the timer fires.
 	 */
-	if (vtimer->irq.level)
+	if (pending)
 		disable_percpu_irq(host_vtimer_irq);
 	else
 		enable_percpu_irq(host_vtimer_irq, host_vtimer_irq_flags);
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index bf8cc9589bd09..2c26d457c3510 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -66,11 +66,6 @@ struct arch_timer_context {
 	 */
 	bool				loaded;
 
-	/* Output level of the timer IRQ */
-	struct {
-		bool			level;
-	} irq;
-
 	/* Who am I? */
 	enum kvm_arch_timers		timer_id;
 
-- 
2.47.3

