Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DAD23642A
	for <kvmarm@lists.linux.dev>; Thu,  6 Feb 2025 15:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738855273; cv=none; b=asCnocEGQAfQDECwlkKqzdQ/3p3jaPvA1uCUxoZvCHyMr3UnfPsQDyATmL/KfPkSq5zFO2VNKaOFBp0ouEfUaDl3Li61nEv/cZ1Azh16w9oxe83/T0BT9J7J91rpHaX462JowBly24ON5dvn/x//3OulOaThQWZPjMcPrUMmQQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738855273; c=relaxed/simple;
	bh=fGkPZyC1lHaD1dNGIgbR3MqllKvLH1NgrTHM4VOF/rQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XFeUTGe2IoEbNNd7vsAKjNfdASvjId1YSXGtOHOZ73EU+rTPIdLqe6vFYiI0+wQ5rT8XwMKLozvg7h9klW++7bD6CQ5OAB9tYC8ed0yOH+aF+PqzBZ2yiCRa2DpXVI8jAtcN81NeXiF8KlbInlBGXAi5m7W3Wfjul45pM+Qff8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DAPAqhM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DAPAqhM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB9AC4CEDF;
	Thu,  6 Feb 2025 15:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738855272;
	bh=fGkPZyC1lHaD1dNGIgbR3MqllKvLH1NgrTHM4VOF/rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAPAqhM8xt+twMxtoArge3pECx/FD9GqReBEPTDv1rOzbK/WPMa8I5zDqHagGBREk
	 sA74L5y7Q2TjyKTfzg6Y7Fj8e0h5n85bsW8bf4mdTALDj/uWCBofnPeTSa9P5HjMli
	 gcbnTqicA8AIvE5PCAfMd3Z8O6dZ41167rto5b1sM1YrwPozWZAp221XLGw5z9JIW0
	 TnFmoY6LXIcuOADbNyrH5df0HBRJ4BRFiz6quAld7tsUDDwgmy5qB9S2se5PH37x7M
	 BlI4iTBR2tnnpvZPn1CsvSVwyt75dQnEk5pvqfrL4aDQSgNNmBx2GeJE/aspcTdaJ5
	 TTzTmIQsD2IZw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tg3gk-001Axu-CO;
	Thu, 06 Feb 2025 15:21:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Alexander Potapenko <glider@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 1/3] KVM: arm64: timer: Drop warning on failed interrupt signalling
Date: Thu,  6 Feb 2025 15:20:58 +0000
Message-Id: <20250206152100.1107909-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250206152100.1107909-1-maz@kernel.org>
References: <20250206152100.1107909-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, glider@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We currently spit out a warning if making a timer interrupt pending
fails. But not only this is loud and easy to trigger from userspace,
we also fail to do anything useful with that information.

Dropping the warning is the easiest thing to do for now. We can
always add error reporting if we really want in the future.

Reported-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 231c0cd9c7b4b..70802e4c91cf5 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -447,21 +447,19 @@ static void kvm_timer_update_status(struct arch_timer_context *ctx, bool level)
 static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 				 struct arch_timer_context *timer_ctx)
 {
-	int ret;
-
 	kvm_timer_update_status(timer_ctx, new_level);
 
 	timer_ctx->irq.level = new_level;
 	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer_irq(timer_ctx),
 				   timer_ctx->irq.level);
 
-	if (!userspace_irqchip(vcpu->kvm)) {
-		ret = kvm_vgic_inject_irq(vcpu->kvm, vcpu,
-					  timer_irq(timer_ctx),
-					  timer_ctx->irq.level,
-					  timer_ctx);
-		WARN_ON(ret);
-	}
+	if (userspace_irqchip(vcpu->kvm))
+		return;
+
+	kvm_vgic_inject_irq(vcpu->kvm, vcpu,
+			    timer_irq(timer_ctx),
+			    timer_ctx->irq.level,
+			    timer_ctx);
 }
 
 /* Only called for a fully emulated timer */
-- 
2.39.2

