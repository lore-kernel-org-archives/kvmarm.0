Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA3A43E9DC;
	Tue, 14 Jul 2026 09:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784020612; cv=none; b=Jp3xQ9SrkFK0TMeNWQXBZYw8UVGZOxNq2tjhMV6YBB8JA70H1nOd6jD1sT3ENB4tIRTCvue9g+7LhYUgC5j8ikh0RHiY5Q5EBT3N3IczQCyRDL0E22ailltmNs+83si9uBjszbOKFpdzKMgXd8jXVMHtTk5Nu+zWRCAufDqi4dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784020612; c=relaxed/simple;
	bh=+7jFGniBNclzIaFlVXX9Cvi5pf0+Y06aAXhYuCJmI50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arpXc3MOYvauIa6OVcW3TsYsXQv29mIoty2J44iRO3PJP2RI2ZrAjML/O2rGJBn7zxBF9lUNZ35VL2qM+92ZrNf/UH0oCn43DONHNjuzjmNQPOl5cHmoMjSI6k/nPau9Zb3c/wGX24bY7Gk0J3xiI6ljF4W1X/KLAySGAOAaVdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQeT3+2+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQeT3+2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C949E1F0155B;
	Tue, 14 Jul 2026 09:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784020610;
	bh=7qRzhMyRtUFwvrdRgEcMK88rCkmdI2qILS64BOePkLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UQeT3+2+AQt4qhY2T2toVzAzdskvxSQofzjYDuqBGStvRcci/ek8/qcq5KOb+6im2
	 qiiIAd7cyLuCvEJy0pPD3ww0DPQalUq9LlH2xT4UJntP4f0UGh5Tjnt5Ais819XbMF
	 LWr4Oq4nMkLeRA9YjT1jGhsh06jNFVsU48pz1MYu+tFGgbTV6rVFVwV/rSggpRuOQJ
	 nm1tdG2vQcnTXumsOBCvR5XxiTEbh4LxRu04s6rY+KeCm84AIGXIWjU5Mn8mB3uKsR
	 yApVryJCpgu6C1SWi6W9E7wUciyTpzXCDuBrfQoVA1i+PJEEBbw3uSe3Ce9Y0/Vuga
	 yDPdKRv+cRiSw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wjZFx-00000004ny1-0Fl5;
	Tue, 14 Jul 2026 09:16:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 10/28] KVM: arm64: Relax CNTHCTL_EL2 handling when FEAT_NV2p1 is present
Date: Tue, 14 Jul 2026 10:16:23 +0100
Message-ID: <20260714091641.1970822-11-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714091641.1970822-1-maz@kernel.org>
References: <20260714091641.1970822-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

With NV2p1, it is no longer necessary to use the split approach
where bits of CNTHCTL_EL2 cannot be accessed via CNTKCTL_EL1,
and we can treat the CNTKCTL_EL1 accessor as if it was "normal".

Key the special casing on FEAT_NV2P1 not being implemented.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c        | 10 ++++++++--
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 13 ++++++++++---
 arch/arm64/kvm/sys_regs.c          |  6 ++++--
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 4155fe89b58a1..db60facad9f3c 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -876,8 +876,14 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 	assign_clear_set_bit(tvt02, CNTHCTL_EL1NVVCT, clr, set);
 	assign_clear_set_bit(tpt02, CNTHCTL_EL1NVPCT, clr, set);
 
-	/* This only happens on VHE, so use the CNTHCTL_EL2 accessor. */
-	sysreg_clear_set(cnthctl_el2, clr, set);
+	/*
+	 * This only happens on VHE, so use the CNTHCTL_EL2 accessor, unless
+	 * we are sure CNTKCTL_EL1 is completely stateful with FEAT_NV2p1.
+	 */
+	if (!cpus_have_final_cap(ARM64_HAS_NV2P1))
+		sysreg_clear_set(cnthctl_el2, clr, set);
+	else
+		sysreg_clear_set(cntkctl_el1, clr, set);
 }
 
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 6f0f046e4ca4e..0c4ef1ce32ae7 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -69,11 +69,18 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 		 * The EL1 view of CNTKCTL_EL1 has a bunch of RES0 bits where
 		 * the interesting CNTHCTL_EL2 bits live. So preserve these
 		 * bits when reading back the guest-visible value.
+		 *
+		 * While NV2p1 fixes some of that, it makes CNTHCTL_EL2.ECV
+		 * even more broken than it already was with NV2.
 		 */
 		val = read_sysreg_el1(SYS_CNTKCTL);
-		val &= CNTKCTL_VALID_BITS;
-		__vcpu_rmw_sys_reg(vcpu, CNTHCTL_EL2, &=, ~CNTKCTL_VALID_BITS);
-		__vcpu_rmw_sys_reg(vcpu, CNTHCTL_EL2, |=, val);
+		if (!cpus_have_final_cap(ARM64_HAS_NV2P1)) {
+			val &= CNTKCTL_VALID_BITS;
+			__vcpu_rmw_sys_reg(vcpu, CNTHCTL_EL2, &=, ~CNTKCTL_VALID_BITS);
+			__vcpu_rmw_sys_reg(vcpu, CNTHCTL_EL2, |=, val);
+		} else {
+			__vcpu_assign_sys_reg(vcpu, CNTHCTL_EL2, val);
+		}
 	}
 
 	__vcpu_assign_sys_reg(vcpu, SP_EL2,	 read_sysreg(sp_el1));
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1dfc1f88bec82..9439c5b2b1fe8 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -322,8 +322,10 @@ u64 vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
 		switch (reg) {
 		case CNTHCTL_EL2:
 			val = read_sysreg_el1(SYS_CNTKCTL);
-			val &= CNTKCTL_VALID_BITS;
-			val |= __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
+			if (!cpus_have_final_cap(ARM64_HAS_NV2P1)) {
+				val &= CNTKCTL_VALID_BITS;
+				val |= __vcpu_sys_reg(vcpu, reg) & ~CNTKCTL_VALID_BITS;
+			}
 			return val;
 		case CPTR_EL2:
 			if (cpus_have_final_cap(ARM64_HAS_NV2P1))
-- 
2.47.3

