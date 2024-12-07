Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6DE14F9FA
	for <kvmarm@lists.linux.dev>; Sat,  7 Dec 2024 19:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733598489; cv=none; b=Wx5S9t6w+phn9IS+BZRjfsE1BjAHe7/8S8WSsmAU2vdN8poPNYHm76XWXB+jAy5M8gqwRmrJF9TZEh4CoHScY25BSNVKPUVX6kDQhnHfXj/KYbqdP7UlWAg0bxcEopv/QT6ZlE4Vl6B9om0jL0q2siK0q3dE9UgTG2b2+tyOYz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733598489; c=relaxed/simple;
	bh=ZC7d56oVMqqp7u1xr2KdKB6p6gazYRFX5ireIjl4BqU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f4QbjmWwDlb78SpLxD1L5u4Nr/oQgdb7uDxN3dt0mDsomf6oo7sU5aUA94RyygB9Sbf82fWRtvQOq1wYDxfLaPptqTAu0ZTmUluRzoh+kd55or4fvbwrZAElAnVBy3gxM8Sl8sW4UGw4TlMiCPJG7NoMwgSAsXl9Z8HTCH+JDf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SENIG6j/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SENIG6j/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F18C4CEDF;
	Sat,  7 Dec 2024 19:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733598488;
	bh=ZC7d56oVMqqp7u1xr2KdKB6p6gazYRFX5ireIjl4BqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SENIG6j/E/tVq3RRFeq4CtqIOrVILoev4VL6CkhIahDtCehg61Hn+3vqdQqhDqNbo
	 k2H2Yi+QE9VYFJsY06u7RoPlFBN4cGzKt5yBOChyK/tzyMwZ1pj2/65a8OMleItDgJ
	 8ayl+VFZTsc4ijN6LY6Kkjgl8YZOjiXKKEIbBL536RgmmaKr8ehWVMPMWcfwH5ELPJ
	 WOBhgmwTUZ4V3XYzL4IBYrGLYpBEVCl32jlhnoEKcXdTBAEdDHeFdRfEXQvPGiH1nc
	 ORPlDgFGNmRnz00Ga+um+zFY5dvSvjKGvb7L5WTmjoUxScUFtwUpa/sqFjhwL7EYQG
	 x5JQ5h/0zr5ZA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tK09u-001TOc-9t;
	Sat, 07 Dec 2024 19:08:06 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 2/4] arm64/sysreg: Get rid of the TCR2_EL1x SysregFields
Date: Sat,  7 Dec 2024 19:07:38 +0000
Message-Id: <20241207190740.2607673-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241207190740.2607673-1-maz@kernel.org>
References: <20241207190740.2607673-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

TCR2_ELx is a pretty bizarre construct, as it is shared between
TCR2_EL1 and TCR2_EL12. But the latter is obviously only an
accessor to the former.

In order to make things more consistent, upgrade TCR2_EL1x to
a full-blown sysreg definition for TCR2_EL1, and describe TCR2_EL12
as a mapping to TCR2_EL1.

This results in a couple of minor changes to the actual code.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 2 +-
 arch/arm64/kvm/at.c            | 6 +++---
 arch/arm64/mm/proc.S           | 5 +++--
 arch/arm64/tools/sysreg        | 8 ++------
 4 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6ce71f444ed84..7712df48758e9 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2376,7 +2376,7 @@ static void cpu_enable_mops(const struct arm64_cpu_capabilities *__unused)
 #ifdef CONFIG_ARM64_POE
 static void cpu_enable_poe(const struct arm64_cpu_capabilities *__unused)
 {
-	sysreg_clear_set(REG_TCR2_EL1, 0, TCR2_EL1x_E0POE);
+	sysreg_clear_set(REG_TCR2_EL1, 0, TCR2_EL1_E0POE);
 	sysreg_clear_set(CPACR_EL1, 0, CPACR_ELx_E0POE);
 }
 #endif
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 8c5d7990e5b31..0905b8778a9bb 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -111,7 +111,7 @@ static bool s1pie_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
 		return vcpu_read_sys_reg(vcpu, TCR2_EL2) & TCR2_EL2_PIE;
 	case TR_EL10:
 		return  (__vcpu_sys_reg(vcpu, HCRX_EL2) & HCRX_EL2_TCR2En) &&
-			(__vcpu_sys_reg(vcpu, TCR2_EL1) & TCR2_EL1x_PIE);
+			(__vcpu_sys_reg(vcpu, TCR2_EL1) & TCR2_EL1_PIE);
 	default:
 		BUG();
 	}
@@ -140,8 +140,8 @@ static void compute_s1poe(struct kvm_vcpu *vcpu, struct s1_walk_info *wi)
 		}
 
 		val = __vcpu_sys_reg(vcpu, TCR2_EL1);
-		wi->poe = val & TCR2_EL1x_POE;
-		wi->e0poe = val & TCR2_EL1x_E0POE;
+		wi->poe = val & TCR2_EL1_POE;
+		wi->e0poe = val & TCR2_EL1_E0POE;
 	}
 }
 
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index b8edc5765441e..fb30c8804f87b 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -501,7 +501,7 @@ alternative_else_nop_endif
 #ifdef CONFIG_ARM64_HAFT
 	cmp	x9, ID_AA64MMFR1_EL1_HAFDBS_HAFT
 	b.lt	1f
-	orr	tcr2, tcr2, TCR2_EL1x_HAFT
+	orr	tcr2, tcr2, TCR2_EL1_HAFT
 #endif /* CONFIG_ARM64_HAFT */
 1:
 #endif	/* CONFIG_ARM64_HW_AFDBM */
@@ -532,7 +532,8 @@ alternative_else_nop_endif
 #undef PTE_MAYBE_NG
 #undef PTE_MAYBE_SHARED
 
-	orr	tcr2, tcr2, TCR2_EL1x_PIE
+	orr	tcr2, tcr2, TCR2_EL1_PIE
+	msr	REG_TCR2_EL1, x0
 
 .Lskip_indirection:
 
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index b6846c601df6c..19d137d9c50ed 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2999,7 +2999,7 @@ Sysreg	TTBR1_EL1	3	0	2	0	1
 Fields	TTBRx_EL1
 EndSysreg
 
-SysregFields	TCR2_EL1x
+Sysreg	TCR2_EL1	3	0	2	0	3
 Res0	63:16
 Field	15	DisCH1
 Field	14	DisCH0
@@ -3013,14 +3013,10 @@ Field	3	POE
 Field	2	E0POE
 Field	1	PIE
 Field	0	PnCH
-EndSysregFields
-
-Sysreg	TCR2_EL1	3	0	2	0	3
-Fields	TCR2_EL1x
 EndSysreg
 
 Sysreg	TCR2_EL12	3	5	2	0	3
-Fields	TCR2_EL1x
+Mapping	TCR2_EL1
 EndSysreg
 
 Sysreg	TCR2_EL2	3	4	2	0	3
-- 
2.39.2

