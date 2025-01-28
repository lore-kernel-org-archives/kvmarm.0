Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CFA1917D9;
	Tue, 28 Jan 2025 16:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738081052; cv=none; b=rua3FyJQ/QtkotpoU58WpxFZGKPVz6oud1gxDteZNDoOc04cpDAKqQkelL7UDbRH8Cq3IA6oMH/z/5AxnB7l5KUhQAiOi4Qk/wdBO9x84WPQS7hoyfhMe+pFhJk+ifvwjxgcRTD4Zid16VET44RYWipYp4+guTJ8Uww80SFaMCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738081052; c=relaxed/simple;
	bh=zUnsuDJ9SEtgVgV4nZafL+jOte8yEfS+p4rbkLAt0yE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VPLVzEseBi8n0gZO/CKZ13Ikt4MqTtpoP6/Ht+4N6o/B2Lzn9E97UI+C91m9aU81JZfWYUheFwZL2o+tunkD+K4T1bWnKbYiCk+jXeBZ39bTCSz7ObjcT77U5QvpkbDOcoUktgE07+wJmvGSW+15ZOpSPQpEDh23BrzKz6VO4LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pCPHfq8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pCPHfq8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C04C4CEE4;
	Tue, 28 Jan 2025 16:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738081052;
	bh=zUnsuDJ9SEtgVgV4nZafL+jOte8yEfS+p4rbkLAt0yE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCPHfq8/4JaM3m/zoL+vzy5pn95OF9kQyR/MCQuHD0ilREtEFVDJ73RHOMUefFGxm
	 0V2avTc2LFy3toisb+xKCrvI3pCbO7iRZB/VSd8vA9+V+mFQNK6FwggxFH9A7k/sHD
	 tLYit5xJCuL+XPoL8CibKDSA2W1tVXmZLaOrKm+B/yFlVKTOym4WLcjcHH4//YMTvE
	 vvVwtFW9ipb9TV/nyuNEOsAxaPg2X1UWCfcR2DlYw8TBQIblyNDa39Z8TE5cwvuWWP
	 eYY33f2uF2z9pZQ+c1EpzhjDVK0R2zplL5hKaOuZaiurqMnU+R5atz6z9Q8vTsmh7M
	 +q0O+kuOw/yoA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tcoHJ-00G6bi-U6;
	Tue, 28 Jan 2025 16:17:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>,
	Dmytro Terletskyi <Dmytro_Terletskyi@epam.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/3] KVM: arm64: timer: Always evaluate the need for a soft timer
Date: Tue, 28 Jan 2025 16:17:19 +0000
Message-Id: <20250128161721.3279927-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250128161721.3279927-1-maz@kernel.org>
References: <20250128161721.3279927-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, r09922117@csie.ntu.edu.tw, Volodymyr_Babchuk@epam.com, Dmytro_Terletskyi@epam.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

When updating the interrupt state for an emulated timer, we return
early and skip the setup of a soft timer that runs in parallel
with the guest.

While this is OK if we have set the interrupt pending, it is pretty
wrong if the guest moved CVAL into the future.  In that case,
no timer is armed and the guest can wait for a very long time
(it will take a full put/load cycle for the situation to resolve).

This is specially visible with EDK2 running at EL2, but still
using the EL1 virtual timer, which in that case is fully emulated.
Any key-press takes ages to be captured, as there is no UART
interrupt and EDK2 relies on polling from a timer...

The fix is simply to drop the early return. If the timer interrupt
is pending, we will still return early, and otherwise arm the soft
timer.

Fixes: 4d74ecfa6458b ("KVM: arm64: Don't arm a hrtimer for an already pending timer")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
---
 arch/arm64/kvm/arch_timer.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index d3d243366536c..035e43f5d4f9a 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -471,10 +471,8 @@ static void timer_emulate(struct arch_timer_context *ctx)
 
 	trace_kvm_timer_emulate(ctx, should_fire);
 
-	if (should_fire != ctx->irq.level) {
+	if (should_fire != ctx->irq.level)
 		kvm_timer_update_irq(ctx->vcpu, should_fire, ctx);
-		return;
-	}
 
 	kvm_timer_update_status(ctx, should_fire);
 
-- 
2.39.2

