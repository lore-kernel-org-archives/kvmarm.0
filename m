Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499A1471414;
	Wed, 22 Jul 2026 07:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784706180; cv=none; b=uiPrLrMy3sT1nybNAJlz9RBsVA5wDA96kq4uWTrp4aw0PJUzALB4qDUlqu771OsiFdqcIBWFTFl9fMoly3m5Qzv5aOq64IVFC9UP0yQ5tjvqyTPPsoKv4IgIqgEIQrbPFPh9qbJeXTe4i14ovm8ntoJV+Yw4XwM3p1Kkqy3l9lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784706180; c=relaxed/simple;
	bh=+7jFGniBNclzIaFlVXX9Cvi5pf0+Y06aAXhYuCJmI50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSATdOhwwDUz2ej1a0QILQkHj5shqtMDaeL+5X+vhE3yl+rDFTdlaUVzA7ILppND6WDzITmwnUmNWQzo5CHPNR6RjSu7X83b17CODS1cA4QkvHA2ZtPGjc3Lin3Bs0OxtS7htuSXHCn1qSQQjPjGgu19RBQyJJ6v5PIFeNuVTBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YBD+yLi2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YBD+yLi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D741F00AC4;
	Wed, 22 Jul 2026 07:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784706178;
	bh=7qRzhMyRtUFwvrdRgEcMK88rCkmdI2qILS64BOePkLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YBD+yLi2XeTbE9COI5JC1T2ghyv72IlBatdeTQoOr/oazg3L/iT95hCwQwzeKJZCe
	 JCJ4dFhFtqZ17qE12FQpbRr9PNY6ypfO+KMkF/slAxRRa9iS7FiF+Nda7Eq4PQ8Tkm
	 EGhnw5TVmwJrCM3/c0lygtnluCq68gX9kH+6/6vSqn1b/K1vG2chZMOEmPawfJK1AM
	 XCbKyoDqr2iaWBc/Ss/hsKSIcXTefl2XMcMpopQt9GFTfbgQcHu7cUOAcv1c4jDfhW
	 LVwFALGJb1rHlb4fY+LNQQNHKvG+W1adtaJPvPUvnFZifS4EQAOHhjOzwlYaQSGlUR
	 j4tw62ooqh4Jw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wmRbU-00000007VfN-1txg;
	Wed, 22 Jul 2026 07:42:56 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 10/28] KVM: arm64: Relax CNTHCTL_EL2 handling when FEAT_NV2p1 is present
Date: Wed, 22 Jul 2026 08:42:16 +0100
Message-ID: <20260722074234.3330999-11-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722074234.3330999-1-maz@kernel.org>
References: <20260722074234.3330999-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, yaoyuan@linux.alibaba.com, weilin.chang@arm.com
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

