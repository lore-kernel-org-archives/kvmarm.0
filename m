Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8147840B6D0;
	Thu, 26 Mar 2026 15:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774539338; cv=none; b=ANFzQENQTb+tS/lqyT57VP4QDzYTzTdtTLE4eqQtvCDJFuzVMrXoxcNY+o4ZoVFAafMoHUFU2MgkeaWw+kT6SUmsR76Qd5fWMCb6h/DIHV/oUeH0Njk0Xr3TtOo9FWnM0sjmRVpGXCtQ1uSRUt4XAestjRQiwc+SegXdHOn7bCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774539338; c=relaxed/simple;
	bh=JkhDOiUWj8vJwfdrAJzWW8C4iPkVzQFcygk2ZWMvfzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnMM8iWrdWmo5ojJ5n/Bz0dbfYWZ6bNmqZy8nE62NGiImO2i0JJf/OByetX/J3dMproxjmaqxzQx/W1WIDdkqq0hDtUUrxMrMnKqXyhmZpvrV3JAXN71kNejrMLgMzbcWEFFOERCMHILHyDAq5XTa/ef5aNeNGgsSp4ldWB0jic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mgZaSN/D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mgZaSN/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55088C19424;
	Thu, 26 Mar 2026 15:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774539338;
	bh=JkhDOiUWj8vJwfdrAJzWW8C4iPkVzQFcygk2ZWMvfzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mgZaSN/D3i21HE/R0OV41wRZ9N8suMZwjsMhw7A6VQPkpUHpN1sP9iK/BioDcH5qH
	 hCjPRA5Y1sauETiJXMUqho9oKlHX2Pcz5ic5WX+LLT+ta5YocbRhXK26LFU76lfLpQ
	 FXu3ZoDCD4eSQZIeMFAuVA1uV1WAgp1poTF/VM3oIsAtHE6N+D9V7mN6KeesyCtWtn
	 VP8jNY+NjDqacafWKzIlfYSEvI+JSY3W3szUJ6fV7QMuNlnCBov8WpQnApiRiucUnf
	 X4BNIftej2qVzgd8iVPblGrA7voiN86N12O8FyhRbwsGYpzUfBSYWPWFdTpIyMZCYQ
	 ZRm0FJ6cqstuw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w5mkC-000000060II-2XLE;
	Thu, 26 Mar 2026 15:35:36 +0000
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
Subject: [PATCH 11/15] KVM: arm64: Kill arch_timer_context::direct field
Date: Thu, 26 Mar 2026 15:35:26 +0000
Message-ID: <20260326153530.3981879-12-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326153530.3981879-1-maz@kernel.org>
References: <20260326153530.3981879-1-maz@kernel.org>
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

The newly introduced arch_timer_context::direct field is a bit pointless,
as it is always set on timers that are... err... direct, while
we already have a way to get to that by doing a get_map() operation.

Additionally, this field is:

- only set when get_map() is called

- never cleared

and the single point where it is actually checked doesn't call get_map()
at all.

At this stage, it is probably better to just kill it, and rely on
get_map() to give us the correct information.

Fixes: 9491c63b6cd7b ("KVM: arm64: gic-v5: Enlighten arch timer for GICv5")
Link: https://sashiko.dev/#/patchset/20260319154937.3619520-1-sascha.bischoff%40arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c  | 15 +++++++++------
 include/kvm/arm_arch_timer.h |  3 ---
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 67b989671b410..37279f8748695 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -183,10 +183,6 @@ void get_timer_map(struct kvm_vcpu *vcpu, struct timer_map *map)
 		map->emul_ptimer = vcpu_ptimer(vcpu);
 	}
 
-	map->direct_vtimer->direct = true;
-	if (map->direct_ptimer)
-		map->direct_ptimer->direct = true;
-
 	trace_kvm_get_timer_map(vcpu->vcpu_id, map);
 }
 
@@ -462,8 +458,15 @@ static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level,
 		return;
 
 	/* Skip injecting on GICv5 for directly injected (DVI'd) timers */
-	if (vgic_is_v5(vcpu->kvm) && timer_ctx->direct)
-		return;
+	if (vgic_is_v5(vcpu->kvm)) {
+		struct timer_map map;
+
+		get_timer_map(vcpu, &map);
+
+		if (map.direct_ptimer == timer_ctx ||
+		    map.direct_vtimer == timer_ctx)
+			return;
+	}
 
 	kvm_vgic_inject_irq(vcpu->kvm, vcpu,
 			    timer_irq(timer_ctx),
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index a7754e0a2ef41..bf8cc9589bd09 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -76,9 +76,6 @@ struct arch_timer_context {
 
 	/* Duplicated state from arch_timer.c for convenience */
 	u32				host_timer_irq;
-
-	/* Is this a direct timer? */
-	bool				direct;
 };
 
 struct timer_map {
-- 
2.47.3

