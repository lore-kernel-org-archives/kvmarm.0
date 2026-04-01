Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F26938B158;
	Wed,  1 Apr 2026 10:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039793; cv=none; b=fOTnJt41hmQ1ix8JfVfYB1SlH+rNpMqj2pJEemGHYBeKVcjxUKl+pkBRmnkeU37Tw1mH2ca2fXQuqAccckAs7QYO3Yrj/9TvO+kWaycXTbIxz2jFGcWLi9eS3NfM2B0q9xMmJUD+FCcsEZHemjyQ+JFwHlAOS0cKmvY4DvZ5Qj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039793; c=relaxed/simple;
	bh=Tlhke2n7aD76htBjxfrB0HrLonqyMetbPN+e9m7UcW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nt/IGkW9+Erc8GM1CfIzKA4kqq589h5JRU5vtgsSCB+XAEDYiDwPRKitXq/G+XSMkEg7lzkfgFEmnpdGKZAZjtA9famExSN7oVQAm5K0lTnyT6QFC9PxeIrJ7hHcFVXgVF7FaPaZu21OPZJiR9wVKJYxIDGY7UNaFnWVW92XUZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ciddHgOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ciddHgOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE2AC2BC9E;
	Wed,  1 Apr 2026 10:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775039792;
	bh=Tlhke2n7aD76htBjxfrB0HrLonqyMetbPN+e9m7UcW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ciddHgOgia7Z20hKHC2pyMgokHByfwqHdnVvb4qmt9BiA1NRLsy05uv+6hAfFIP2w
	 jEonT2LzGH8I+pvWpnS4jiLHKuixQJMkINOfrGO7XBJainlLmkHyjcJJH8ZEdjCY4v
	 yipskR8QmKGKdeI8owE8gNbzn77CwPPvatFpDoJfu4oJ3qgSPUZBWOtIuQKHnMKw/O
	 DF4A/yVYKvDFuddryXlwZGEShlbtHSgHZQZ6ftp0R/yfeZ14Vp9OuVLr1c4JTa0XVc
	 qG4h+Kg/M8rZWyX4fa7AiBt5MAhGnJWIIPbNkTw1ZKLzCKHp44nll73tJ07WFa0269
	 WkSQSDZZx1J6w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7sw3-00000007oRQ-0lx6;
	Wed, 01 Apr 2026 10:36:31 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 09/16] KVM: arm64: vgic-v5: Make the effective priority mask a strict limit
Date: Wed,  1 Apr 2026 11:36:04 +0100
Message-ID: <20260401103611.357092-10-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103611.357092-1-maz@kernel.org>
References: <20260401103611.357092-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The way the effective priority mask is compared to the priority of
an interrupt to decide whether to wake-up or not, is slightly odd,
and breaks at the limits.

This could result in spurious wake-ups that are undesirable.

Make the computed priority mask comparison a strict inequality, so
that interrupts that have the same priority as the mask are not
signalled.

Fixes: 933e5288fa971 ("KVM: arm64: gic-v5: Check for pending PPIs")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 0f269321ece4b..31040cfb61fc7 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -367,7 +367,7 @@ bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu)
 
 		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
 			has_pending = (irq->enabled && irq_is_pending(irq) &&
-				       irq->priority <= priority_mask);
+				       irq->priority < priority_mask);
 
 		vgic_put_irq(vcpu->kvm, irq);
 
-- 
2.47.3

