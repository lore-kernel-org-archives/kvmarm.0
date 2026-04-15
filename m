Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B456037C920
	for <kvmarm@lists.linux.dev>; Wed, 15 Apr 2026 11:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776254184; cv=none; b=GE54Yh5xREzr+UcVBr4cOAk8yV/bIuKgwlOrE4cHc1yCDqIYcyHGf0lvzZKyGT7JiItxWQIOIpnxHFsTwuAWqC7tQ5IyYRGWH51wMEO8OpOlkmDXEsJY4GylNyi2SJDO3CyLCAcGcpUWcN4WVQrh8MnhUxFv6qgtGFiFGz0k4zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776254184; c=relaxed/simple;
	bh=2XomehQKiUEMkDL/xL8zcJ058RSYu3stHmH3ujNqmjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pl48MMtCC9I0BtlgdXXFhJRVzY0E/lkPAXoPWYML6kGlbKQJ4vYidW7EvQPiZ84gtnTet+AMFOVsTvE2hHE8+rsRNHm9DKjSgrvE+G4jpQy+439uB/mh3tHuOKNm5At0jUaf/aFtBHIvLYftvAEf6gPeR6I3TksOU9HoHM1nu0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DABC6DyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DABC6DyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E39C2BCB7;
	Wed, 15 Apr 2026 11:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776254184;
	bh=2XomehQKiUEMkDL/xL8zcJ058RSYu3stHmH3ujNqmjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DABC6DyMohWwM5zOFTaecGD6kbU44ytQDfOeXZzvkwXHE75aPxfuc2Duz1qLR+OI8
	 4Iw5tY1/rFEJYZkXgGBfs4GaHoBr8XWAXyKtACUCl9Tv++o7T6MG0deovDXK/3AopO
	 sDtO+eFgSkUy6RzWTRRBHvNXBBMzcXmlhqxkG/7dt+TZQ9oYcQ89GhglM/BoUrMUvF
	 zP+sZ798FFryb6OaUGkIV2hX18ULSkknWxKUaznEzzTmKu02odHf58g96/RvHfUYuD
	 87dtqqkQR7ePIv4TFI256/EBH+U52Z5hG+bmH2gW6aTudZ+7YNFOG5oOQ+7GiPfWDA
	 bcsB+AD6d/I2w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wCyr0-0000000Bqsi-3TB1;
	Wed, 15 Apr 2026 11:56:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH 18/18] KVM: arm64: Fix arch timer interrupts for GICv3-on-GICv5 guests
Date: Wed, 15 Apr 2026 12:55:59 +0100
Message-ID: <20260415115559.2227718-19-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415115559.2227718-1-maz@kernel.org>
References: <20260415115559.2227718-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Sascha Bischoff <sascha.bischoff@arm.com>

When running on a GICv5 host, we push an arch-timer-specific interrupt
domain for the timer interrupts. This interrupt domain is used to mask
the host interrupt when a GICv5 guest is running. However, this
interrupt domain is still in place when running with a GICv3 guest on
GICv5 hardware. The result is that some interrupt state changes are
not correctly propragated to the host irqchip driver for legacy
guests.

Explicitly pass irqchip state changes though to the host irqchip
driver when running a GICv3-based guest on a GICv5 host. This bypasses
all masking, and thereby operates just as a native GICv3 guest would,
with the exception of having an additional irq domain in the
hierarchy.

Fixes: 9491c63b6cd7 ("KVM: arm64: gic-v5: Enlighten arch timer for GICv5")
Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index f003df76fdda7..53b67b4d0bf24 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1294,7 +1294,12 @@ static int timer_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu)
 static int timer_irq_set_irqchip_state(struct irq_data *d,
 				       enum irqchip_irq_state which, bool val)
 {
-	if (which != IRQCHIP_STATE_ACTIVE || !irqd_is_forwarded_to_vcpu(d))
+	bool passthrough = which != IRQCHIP_STATE_ACTIVE ||
+		!irqd_is_forwarded_to_vcpu(d) ||
+		(kvm_vgic_global_state.type == VGIC_V5 &&
+		 vgic_is_v3(kvm_get_running_vcpu()->kvm));
+
+	if (passthrough)
 		return irq_chip_set_parent_state(d, which, val);
 
 	if (val)
@@ -1307,15 +1312,7 @@ static int timer_irq_set_irqchip_state(struct irq_data *d,
 
 static void timer_irq_eoi(struct irq_data *d)
 {
-	/*
-	 * On a GICv5 host, we still need to call EOI on the parent for
-	 * PPIs. The host driver already handles irqs which are forwarded to
-	 * vcpus, and skips the GIC CDDI while still doing the GIC CDEOI. This
-	 * is required to emulate the EOIMode=1 on GICv5 hardware. Failure to
-	 * call EOI unsurprisingly results in *BAD* lock-ups.
-	 */
-	if (!irqd_is_forwarded_to_vcpu(d) ||
-	    kvm_vgic_global_state.type == VGIC_V5)
+	if (!irqd_is_forwarded_to_vcpu(d))
 		irq_chip_eoi_parent(d);
 }
 
-- 
2.47.3

