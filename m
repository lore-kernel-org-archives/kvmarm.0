Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA6B3F65E8;
	Wed,  1 Apr 2026 10:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039793; cv=none; b=JlaKRjJed4TLWhzeeMEmWNhxgHHupv/gA5dF1ctYR/vcTHJ2f2m9mFtGDe8UF2fuvfavFWjySauuOWd0/skwxRpOVm+lleLsgI32lxG9LiDMbPZvw9ZxxvMHucDG5O+QiuE4noeP4lfuGaV2KatoyIuTksxUOfUgAgW8qG17WXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039793; c=relaxed/simple;
	bh=H6jm/RYaSFrmN5gb3D/jhBBnlIwUM3w23KPKgkQu2iA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0/c/430EvSjsifNeyUqTU1T583vc4CoPOSO9VEBrazK42nuvvTxJAqi6RraFapOAx9bWN/1uTcOOeCCq3m8nb7P3OvJ4HCJ7WBz0oPY7BiZkUwXGoYzvDwE099Wdm7xoQkIqECb5EXrwOe+zrXdH36MDBduyNldaISU8cgZdyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ci5WlcT7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ci5WlcT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C83AC2BCB5;
	Wed,  1 Apr 2026 10:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775039793;
	bh=H6jm/RYaSFrmN5gb3D/jhBBnlIwUM3w23KPKgkQu2iA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ci5WlcT7A+fThmLbBA3Q3bdbAEnVfj0eh2s187ofpuwyjNfCNKx3TNPJDIlpUswhV
	 jq/yhtfSgIRhvNF93KD8BQ3a7KmVsrmhNjLuEifAFKGlOWCFywLmgh9odXZ83CukrT
	 lYGy88XXlvNMQDMOSB0wxQDFFuVkKKOUkZ71bdw+k8RzagS6sUnEP88w/i4F/K8gN5
	 gyJuAt1kLvi+2TBQiuWLZxwhnY8NR8fXYEPzsw4z2ByKIR+ZVx1RtN1zKPynFcaH87
	 aGltsiOBK0bGieeWxzvH54aktyG0sTaujZLrYZaYdLd87KMbuUjjhtZNVjhPKEmVUN
	 0zOUdGz9Zggxw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w7sw3-00000007oRQ-3bHI;
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
Subject: [PATCH v2 12/16] KVM: arm64: Remove evaluation of timer state in kvm_cpu_has_pending_timer()
Date: Wed,  1 Apr 2026 11:36:07 +0100
Message-ID: <20260401103611.357092-13-maz@kernel.org>
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

The vgic-v5 code added some evaluations of the timers in a helper funtion
(kvm_cpu_has_pending_timer()) that is called to determine whether
the vcpu can wake-up.

But looking at the timer there is wrong:

- we want to see timers that are signalling an interrupt to the
  vcpu, and not just that have a pending interrupt

- we already have kvm_arch_vcpu_runnable() that evaluates the
  state of interrupts

- kvm_cpu_has_pending_timer() really is about WFIT, as the timeout
  does not generate an interrupt, and is therefore distinct from
  the point above

As a consequence, revert these changes and teach vgic_v5_has_pending_ppi()
about checking for pending HW interrupts instead.

Fixes: 9491c63b6cd7b ("KVM: arm64: gic-v5: Enlighten arch timer for GICv5")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c   | 6 +-----
 arch/arm64/kvm/vgic/vgic-v5.c | 4 ++--
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 37279f8748695..6608c47d1f628 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -402,11 +402,7 @@ static bool kvm_timer_should_fire(struct arch_timer_context *timer_ctx)
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
-	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
-
-	return kvm_timer_should_fire(vtimer) || kvm_timer_should_fire(ptimer) ||
-	       (vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) == 0);
+	return vcpu_has_wfit_active(vcpu) && wfit_delay_ns(vcpu) == 0;
 }
 
 /*
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index 31040cfb61fc7..8680a8354db9d 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -366,8 +366,8 @@ bool vgic_v5_has_pending_ppi(struct kvm_vcpu *vcpu)
 		irq = vgic_get_vcpu_irq(vcpu, intid);
 
 		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock)
-			has_pending = (irq->enabled && irq_is_pending(irq) &&
-				       irq->priority < priority_mask);
+			if (irq->enabled && irq->priority < priority_mask)
+				has_pending = irq->hw ? vgic_get_phys_line_level(irq) : irq_is_pending(irq);
 
 		vgic_put_irq(vcpu->kvm, irq);
 
-- 
2.47.3

