Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692C220E02A
	for <kvmarm@lists.linux.dev>; Wed, 12 Feb 2025 18:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739384764; cv=none; b=jV93zZ7wmR1CcjpnikHSKjKve9IVClcdXSnr2+fPoR26LEGvYKQUiUbado3riB4mQWVYwVo831M+COZjaiJP8E5sWIsqbA/AWFqZgFXJdz3p2k7L1EckU4D2cVg5bpb4AazFKNqhu3CZ8+e+UcmGd+mOgXlXM9pzZDLpbwE7xhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739384764; c=relaxed/simple;
	bh=fGkPZyC1lHaD1dNGIgbR3MqllKvLH1NgrTHM4VOF/rQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F5pNUQ5kKWYmk98rjHcyt+gCLEWYBwNR+0Zua0C00hl4bg7FI1vhacCzFkzDpaUvCb5Al3zP/TSIFl+OLsYwox26fhUkwr6zDqPkpXf0eOEboAQB+3fiY83vwoZWNlf1U6hrY0Y7hEuYXJxksYE8w3qNmsYx5gU2/iWM2w+3DB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HP5kfWaQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HP5kfWaQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DB5C4CEE2;
	Wed, 12 Feb 2025 18:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739384763;
	bh=fGkPZyC1lHaD1dNGIgbR3MqllKvLH1NgrTHM4VOF/rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HP5kfWaQrTj8IWiUizfTjRRzMbWG7N1W/1x4ceK8yciCy4GseCo9u59S11tsCyEKF
	 4my0iiapBCv2tP0fg7D/VCcaun2k9OQWLoX+hPjEtd8PcJP+wLThWktjuO2LRqztss
	 CCbuXexHkEjlYlTsTthZiY57LFPn7fpc1kCx2kLwwu70glHSBBn4+nPmc+saXv3Q8i
	 5irVv/vvvAm9cODD/fFrCNXKWRMhdA76/ArJuB9Itf+WHAUi+e2Ps8dORlTW4LcNSL
	 SaETN+g8QChCIG6lMyw+m3N4qa/m3zbfLLspZ3lKikr6/gzjWgz0FX+xaYFMKzcZ2M
	 3CMn35O42ZFqg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tiHQv-003RQt-Qs;
	Wed, 12 Feb 2025 18:26:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Alexander Potapenko <glider@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 1/2] KVM: arm64: timer: Drop warning on failed interrupt signalling
Date: Wed, 12 Feb 2025 18:25:57 +0000
Message-Id: <20250212182558.2865232-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250212182558.2865232-1-maz@kernel.org>
References: <20250212182558.2865232-1-maz@kernel.org>
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

