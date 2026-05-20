Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5C13D3D1F
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 10:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779271329; cv=none; b=kUO2ds0LvsyzXvqDejd+hIARyIaaRZNTrdhBUhCemk6HdhjppuC0+dJfqCt8ry7tIppAYkCCNpQIOP3fIcgNuLpT5DxFF1ITEeCGLERp7pJJgk0YLv7274SZB7vSbw1Fzhs2VIShEwRxhatkjY6oZAjCEKkhlmAWa1DVNpxRSEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779271329; c=relaxed/simple;
	bh=sWI0+ZMFRGK9dCJKU/1iPQWFFfLSzmuLg7FPDjp6Dwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzW4+bpuxTg4VZ4BFJMqafOhFUftHqv4C72R1JyIdb5YjQDJyfJ1HbbIJVNWvExmuMqmvngDfE1MHuAJw8/KRA4quUdM8MGNhJuVHaZomxfTa3/645NGQD3lJYYTljRtEkvu+J/Sk7xCEkHq4FPTt/GkPOnuavf74cZiDWKNqKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WkF2IyP8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WkF2IyP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81481F00894;
	Wed, 20 May 2026 10:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779271327;
	bh=Ivc4Ew6RtkewqbXfeERM9YlzozOUwZTMIA5HjaS/4RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WkF2IyP8PHyU9H4zvNiUMePbvKrRdcsoMoOWag0pUOo3z3aIaHMCjaogCDM5MRTTr
	 cTmr4ezZCxi4EXF40evFk3xHYOvn/O0qY95JbN+L8jdzXI1NugE4kwvqpdi5RhfZvU
	 7K0v4m9udccIC18AXMCgo6MSlmOKG/KRx+tBlIBB/Mj9j3lhp7FCKVHT6s+l7n7gz8
	 DSgRJjzx2xOcVOlm2W5k9FuJmA8PCIjCs9yYy8tyCM8QNUWfZJlp9TUix6exv6iD03
	 bJj0zjq4KWTg8k0vDxow6LDR6MNFN9WSoapi5S30pHl0qUKbn0tUgsE96d60teSKxV
	 qSYYowmrWnCGw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPdkc-00000004Jio-08Bs;
	Wed, 20 May 2026 10:02:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v3 3/6] KVM: arm64: timer: Kill the per-timer irq level cache
Date: Wed, 20 May 2026 11:01:57 +0100
Message-ID: <20260520100200.543845-4-maz@kernel.org>
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
index 7236dd6a99e67..c3b8257888e89 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -453,9 +453,8 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 {
 	kvm_timer_update_status(timer_ctx, new_level);
 
-	timer_ctx->irq.level = new_level;
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_irq(timer_ctx),
-				   timer_ctx->irq.level);
+				   new_level);
 
 	if (userspace_irqchip(vcpu->kvm))
 		return;
@@ -473,7 +472,7 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 
 	kvm_vgic_inject_irq(vcpu->kvm, vcpu,
 			    timer_irq(timer_ctx),
-			    timer_ctx->irq.level,
+			    new_level,
 			    timer_ctx);
 }
 
@@ -484,10 +483,7 @@ static void timer_emulate(struct arch_timer_context *ctx)
 
 	trace_kvm_timer_emulate(ctx, pending);
 
-	if (pending != ctx->irq.level)
-		kvm_timer_update_irq(timer_context_to_vcpu(ctx), pending, ctx);
-
-	kvm_timer_update_status(ctx, pending);
+	kvm_timer_update_irq(timer_context_to_vcpu(ctx), pending, ctx);
 
 	/*
 	 * If the timer is pending, we don't need to have a soft timer
@@ -684,6 +680,7 @@ static inline void set_timer_irq_phys_active(struct arch_timer_context *ctx, boo
 static void kvm_timer_vcpu_load_gic(struct arch_timer_context *ctx)
 {
 	struct kvm_vcpu *vcpu = timer_context_to_vcpu(ctx);
+	bool pending = kvm_timer_pending(ctx);
 	bool phys_active = false;
 
 	/*
@@ -692,12 +689,12 @@ static void kvm_timer_vcpu_load_gic(struct arch_timer_context *ctx)
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
@@ -706,6 +703,7 @@ static void kvm_timer_vcpu_load_gic(struct arch_timer_context *ctx)
 static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
 {
 	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
+	bool pending = kvm_timer_pending(vtimer);
 
 	/*
 	 * Update the timer output so that it is likely to match the
@@ -713,7 +711,7 @@ static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
 	 * this point and the register restoration, we'll take the
 	 * interrupt anyway.
 	 */
-	kvm_timer_update_irq(vcpu, kvm_timer_pending(vtimer), vtimer);
+	kvm_timer_update_irq(vcpu, pending, vtimer);
 
 	/*
 	 * When using a userspace irqchip with the architected timers and a
@@ -725,7 +723,7 @@ static void kvm_timer_vcpu_load_nogic(struct kvm_vcpu *vcpu)
 	 * being de-asserted, we unmask the interrupt again so that we exit
 	 * from the guest when the timer fires.
 	 */
-	if (vtimer->irq.level)
+	if (pending)
 		disable_percpu_irq(host_vtimer_irq);
 	else
 		enable_percpu_irq(host_vtimer_irq, host_vtimer_irq_flags);
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 9e4076eebd29f..15a4f97f81051 100644
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

