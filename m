Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15993BFAEE
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 09:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779268818; cv=none; b=lzpVt85fR8E0au5FirQk4YOXsnMi2aTI3V2dIyYQMsUwbh/tX8Lb8CpC4JDprTWuZCBz5nZvu0ZrV8+jppGTwsf7UgiCcxwfmb5YTGdjTOyIV8ME2RNZL4E+R8wJxBeDPdvvlmc77t1PvhFHeKDxbuXorufP0wdrmedvWd/4lmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779268818; c=relaxed/simple;
	bh=2XomehQKiUEMkDL/xL8zcJ058RSYu3stHmH3ujNqmjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDif0K+MzQKmaiGcfmov7IEYjuOqbMc5Um9d7qP2johJvj3KmF6vWVgcWoZEldPx1VxYg3gC/QTFhql6QQ89NDiGR/cbT/KBoriztkI/PXbLm0lBB31vbM16eKl6WTm0BDNs79CVnowD3plTpbwJ7cdcKZL+5t3wE3U5w2mdR0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jazC8r9Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jazC8r9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3F71F000E9;
	Wed, 20 May 2026 09:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779268815;
	bh=VTLxlivkME/czNHyhw9EkvAVtPi+VjAelN5GZKQJJEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jazC8r9ZUguaHrDqiZC3qIUTt/z79p629oMA+INQYk+AkhcWivGvOcSFz55+35Vyk
	 XvXHowM4z2+uGpyTxsrQBKshN616XU9bxS4mLNlE/zWk7yiofe+HX3euoeflRoZ2Yf
	 BRSR/VJ64i1puZS26MCfLW6pnbINB8F3YslRLAtulaH3+0bO/7SthdcdB+TmLntAdA
	 8KYVLatZNSYmD1j3ZwoEXfHItwP9VVRk9/18kRL+I86npZ98OIWf0fVmREljv8SEdw
	 qysgd74ImyTHu8HEA9DLnPCXYFBkEQP9BnwOfo37c/SUrCdKor211fJHZoMvItpCSe
	 cI/HvsaQmLsEg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wPd65-00000004IaV-45ow;
	Wed, 20 May 2026 09:20:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sascha Bischoff <sascha.bischoff@arm.com>
Subject: [PATCH v2 18/18] KVM: arm64: Fix arch timer interrupts for GICv3-on-GICv5 guests
Date: Wed, 20 May 2026 10:19:49 +0100
Message-ID: <20260520091949.542365-19-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520091949.542365-1-maz@kernel.org>
References: <20260520091949.542365-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, sascha.bischoff@arm.com
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

