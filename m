Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0761E19AD5C
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 17:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734629641; cv=none; b=W+EBu01l6jpKU9x7Onx3BBEL/HJghkIpyDMlHedcaKLc0wmLoz1I+Q+2QZFLSW/pxhAcOjyaV6HNjBVs1ZVaWCi5UkrveRmnlwJuvtBqGInqBQB2ZApEmPDsfC+jM8iMXF51cdJRvHMgG+7hmaAQagaAegZf5BhtHI36FM7ppCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734629641; c=relaxed/simple;
	bh=FCHAHr9u2qXa0Jjz/5n8GQN/cG59u8BXZQ+8Hu+MIGo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TDnJH2cX8wz/jNThq7CM0i2pn/raf/DZdM3pRTE73J6RjkZv5ZRj1MRAK86ZhfGqEBQhoFFnUFe7NQZDLQJmIr26fPPmY/NKsLnt7XJUHB7x95zpfnl1EaExdegq21+oyieUmrYxF8Vycn7QbQK0LjxBc/BTn9yjlRZfnqlFwTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IQ1joYKB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IQ1joYKB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A70C4CEE0;
	Thu, 19 Dec 2024 17:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734629640;
	bh=FCHAHr9u2qXa0Jjz/5n8GQN/cG59u8BXZQ+8Hu+MIGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IQ1joYKBjHgn1CTmFcs47c6O/didNmiRpqaLBtB46HglBJo/rTt9owAeDSWbRsJHK
	 0L/H1soJ4jHXyljU2UM2+wLzES4vCne7A60wy/wxmNJRXYHt3ijmuabmx/ZgubK8QZ
	 FUEKJIarUTfoO+HkIOZpoWJfWFZTUiuNxRW6DQ3rQ5peIyCDq0HUGG8lAayZ6V1Y9v
	 BizTmf72fyPILh9oMNSyK683COYWptM0m3vdA3SsH6yuSy5XJSYOkVUbzwLAYtU4RB
	 h8bIcXJYBVlwHP+2heA8TcXBJbwbJFC29HnmrsZxUMVABylil9UWZa3DWFvmVv87FD
	 X21UcULcclVSg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tOKPO-005Lao-VW;
	Thu, 19 Dec 2024 17:33:59 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 4/4] arm64/sysreg: Get rid of CPACR_ELx SysregFields
Date: Thu, 19 Dec 2024 17:33:50 +0000
Message-Id: <20241219173351.1123087-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241219173351.1123087-1-maz@kernel.org>
References: <20241219173351.1123087-1-maz@kernel.org>
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

There is no such thing as CPACR_ELx in the architecture.
What we have is CPACR_EL1, for which CPTR_EL12 is an accessor.

Rename CPACR_ELx_* to CPACR_EL1_*, and fix the bit of code using
these names.

Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h      |  6 ++--
 arch/arm64/include/asm/kvm_arm.h        |  2 --
 arch/arm64/include/asm/kvm_emulate.h    | 40 ++++++++++++-------------
 arch/arm64/include/asm/kvm_nested.h     |  8 ++---
 arch/arm64/kernel/cpufeature.c          |  2 +-
 arch/arm64/kvm/emulate-nested.c         |  2 +-
 arch/arm64/kvm/fpsimd.c                 |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 +--
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  4 +--
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  2 +-
 arch/arm64/kvm/hyp/nvhe/switch.c        |  6 ++--
 arch/arm64/kvm/hyp/vhe/switch.c         | 16 +++++-----
 arch/arm64/tools/sysreg                 |  6 +---
 13 files changed, 47 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 4ef52d7245bbb..25e1626517500 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -154,7 +154,7 @@
 /* Coprocessor traps */
 .macro __init_el2_cptr
 	__check_hvhe .LnVHE_\@, x1
-	mov	x0, #CPACR_ELx_FPEN
+	mov	x0, #CPACR_EL1_FPEN
 	msr	cpacr_el1, x0
 	b	.Lskip_set_cptr_\@
 .LnVHE_\@:
@@ -332,7 +332,7 @@
 
 	// (h)VHE case
 	mrs	x0, cpacr_el1			// Disable SVE traps
-	orr	x0, x0, #CPACR_ELx_ZEN
+	orr	x0, x0, #CPACR_EL1_ZEN
 	msr	cpacr_el1, x0
 	b	.Lskip_set_cptr_\@
 
@@ -353,7 +353,7 @@
 
 	// (h)VHE case
 	mrs	x0, cpacr_el1			// Disable SME traps
-	orr	x0, x0, #CPACR_ELx_SMEN
+	orr	x0, x0, #CPACR_EL1_SMEN
 	msr	cpacr_el1, x0
 	b	.Lskip_set_cptr_sme_\@
 
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 3e0f0de1d2da8..43e365fbff0b2 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -391,8 +391,6 @@
 	ECN(SOFTSTP_CUR), ECN(WATCHPT_LOW), ECN(WATCHPT_CUR), \
 	ECN(BKPT32), ECN(VECTOR32), ECN(BRK64), ECN(ERET)
 
-#define CPACR_EL1_TTA		(1 << 28)
-
 #define kvm_mode_names				\
 	{ PSR_MODE_EL0t,	"EL0t" },	\
 	{ PSR_MODE_EL1t,	"EL1t" },	\
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index cf811009a33c9..4f1d99725f6b3 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -556,13 +556,13 @@ static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
 	({								\
 		u64 cptr = 0;						\
 									\
-		if ((set) & CPACR_ELx_FPEN)				\
+		if ((set) & CPACR_EL1_FPEN)				\
 			cptr |= CPTR_EL2_TFP;				\
-		if ((set) & CPACR_ELx_ZEN)				\
+		if ((set) & CPACR_EL1_ZEN)				\
 			cptr |= CPTR_EL2_TZ;				\
-		if ((set) & CPACR_ELx_SMEN)				\
+		if ((set) & CPACR_EL1_SMEN)				\
 			cptr |= CPTR_EL2_TSM;				\
-		if ((clr) & CPACR_ELx_TTA)				\
+		if ((clr) & CPACR_EL1_TTA)				\
 			cptr |= CPTR_EL2_TTA;				\
 		if ((clr) & CPTR_EL2_TAM)				\
 			cptr |= CPTR_EL2_TAM;				\
@@ -576,13 +576,13 @@ static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
 	({								\
 		u64 cptr = 0;						\
 									\
-		if ((clr) & CPACR_ELx_FPEN)				\
+		if ((clr) & CPACR_EL1_FPEN)				\
 			cptr |= CPTR_EL2_TFP;				\
-		if ((clr) & CPACR_ELx_ZEN)				\
+		if ((clr) & CPACR_EL1_ZEN)				\
 			cptr |= CPTR_EL2_TZ;				\
-		if ((clr) & CPACR_ELx_SMEN)				\
+		if ((clr) & CPACR_EL1_SMEN)				\
 			cptr |= CPTR_EL2_TSM;				\
-		if ((set) & CPACR_ELx_TTA)				\
+		if ((set) & CPACR_EL1_TTA)				\
 			cptr |= CPTR_EL2_TTA;				\
 		if ((set) & CPTR_EL2_TAM)				\
 			cptr |= CPTR_EL2_TAM;				\
@@ -595,13 +595,13 @@ static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
 #define cpacr_clear_set(clr, set)					\
 	do {								\
 		BUILD_BUG_ON((set) & CPTR_VHE_EL2_RES0);		\
-		BUILD_BUG_ON((clr) & CPACR_ELx_E0POE);			\
-		__build_check_all_or_none((clr), CPACR_ELx_FPEN);	\
-		__build_check_all_or_none((set), CPACR_ELx_FPEN);	\
-		__build_check_all_or_none((clr), CPACR_ELx_ZEN);	\
-		__build_check_all_or_none((set), CPACR_ELx_ZEN);	\
-		__build_check_all_or_none((clr), CPACR_ELx_SMEN);	\
-		__build_check_all_or_none((set), CPACR_ELx_SMEN);	\
+		BUILD_BUG_ON((clr) & CPACR_EL1_E0POE);			\
+		__build_check_all_or_none((clr), CPACR_EL1_FPEN);	\
+		__build_check_all_or_none((set), CPACR_EL1_FPEN);	\
+		__build_check_all_or_none((clr), CPACR_EL1_ZEN);	\
+		__build_check_all_or_none((set), CPACR_EL1_ZEN);	\
+		__build_check_all_or_none((clr), CPACR_EL1_SMEN);	\
+		__build_check_all_or_none((set), CPACR_EL1_SMEN);	\
 									\
 		if (has_vhe() || has_hvhe())				\
 			sysreg_clear_set(cpacr_el1, clr, set);		\
@@ -624,16 +624,16 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
 	u64 val;
 
 	if (has_vhe()) {
-		val = (CPACR_ELx_FPEN | CPACR_EL1_ZEN_EL1EN);
+		val = (CPACR_EL1_FPEN | CPACR_EL1_ZEN_EL1EN);
 		if (cpus_have_final_cap(ARM64_SME))
 			val |= CPACR_EL1_SMEN_EL1EN;
 	} else if (has_hvhe()) {
-		val = CPACR_ELx_FPEN;
+		val = CPACR_EL1_FPEN;
 
 		if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs())
-			val |= CPACR_ELx_ZEN;
+			val |= CPACR_EL1_ZEN;
 		if (cpus_have_final_cap(ARM64_SME))
-			val |= CPACR_ELx_SMEN;
+			val |= CPACR_EL1_SMEN;
 	} else {
 		val = CPTR_NVHE_EL2_RES1;
 
@@ -685,7 +685,7 @@ static inline bool ____cptr_xen_trap_enabled(const struct kvm_vcpu *vcpu,
 #define __guest_hyp_cptr_xen_trap_enabled(vcpu, xen)				\
 	(!vcpu_has_nv(vcpu) ? false :						\
 	 ____cptr_xen_trap_enabled(vcpu,					\
-				   SYS_FIELD_GET(CPACR_ELx, xen,		\
+				   SYS_FIELD_GET(CPACR_EL1, xen,		\
 						 vcpu_sanitised_cptr_el2(vcpu))))
 
 static inline bool guest_hyp_fpsimd_traps_enabled(const struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 233e655227164..6cd08198bf195 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -33,14 +33,14 @@ static inline u64 translate_tcr_el2_to_tcr_el1(u64 tcr)
 
 static inline u64 translate_cptr_el2_to_cpacr_el1(u64 cptr_el2)
 {
-	u64 cpacr_el1 = CPACR_ELx_RES1;
+	u64 cpacr_el1 = CPACR_EL1_RES1;
 
 	if (cptr_el2 & CPTR_EL2_TTA)
-		cpacr_el1 |= CPACR_ELx_TTA;
+		cpacr_el1 |= CPACR_EL1_TTA;
 	if (!(cptr_el2 & CPTR_EL2_TFP))
-		cpacr_el1 |= CPACR_ELx_FPEN;
+		cpacr_el1 |= CPACR_EL1_FPEN;
 	if (!(cptr_el2 & CPTR_EL2_TZ))
-		cpacr_el1 |= CPACR_ELx_ZEN;
+		cpacr_el1 |= CPACR_EL1_ZEN;
 
 	cpacr_el1 |= cptr_el2 & (CPTR_EL2_TCPAC | CPTR_EL2_TAM);
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 7712df48758e9..6e220da3a495b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2377,7 +2377,7 @@ static void cpu_enable_mops(const struct arm64_cpu_capabilities *__unused)
 static void cpu_enable_poe(const struct arm64_cpu_capabilities *__unused)
 {
 	sysreg_clear_set(REG_TCR2_EL1, 0, TCR2_EL1_E0POE);
-	sysreg_clear_set(CPACR_EL1, 0, CPACR_ELx_E0POE);
+	sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_E0POE);
 }
 #endif
 
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 1ffbfd1c3cf2e..f1b7287e1f3c3 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -494,7 +494,7 @@ static enum trap_behaviour check_cptr_tta(struct kvm_vcpu *vcpu)
 	if (!vcpu_el2_e2h_is_set(vcpu))
 		val = translate_cptr_el2_to_cpacr_el1(val);
 
-	if (val & CPACR_ELx_TTA)
+	if (val & CPACR_EL1_TTA)
 		return BEHAVE_FORWARD_RW;
 
 	return BEHAVE_HANDLE_LOCALLY;
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index ea5484ce1f3ba..98718bd65bf15 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -169,7 +169,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 	if (has_vhe() && system_supports_sme()) {
 		/* Also restore EL0 state seen on entry */
 		if (vcpu_get_flag(vcpu, HOST_SME_ENABLED))
-			sysreg_clear_set(CPACR_EL1, 0, CPACR_ELx_SMEN);
+			sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_SMEN);
 		else
 			sysreg_clear_set(CPACR_EL1,
 					 CPACR_EL1_SMEN_EL0EN,
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 34f53707892df..abfa6ad92e91e 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -419,9 +419,9 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 	/* First disable enough traps to allow us to update the registers */
 	if (sve_guest || (is_protected_kvm_enabled() && system_supports_sve()))
-		cpacr_clear_set(0, CPACR_ELx_FPEN | CPACR_ELx_ZEN);
+		cpacr_clear_set(0, CPACR_EL1_FPEN | CPACR_EL1_ZEN);
 	else
-		cpacr_clear_set(0, CPACR_ELx_FPEN);
+		cpacr_clear_set(0, CPACR_EL1_FPEN);
 	isb();
 
 	/* Write out the host state if it's in the registers */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 6aa0b13d86e58..6c90ef6736d63 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -68,7 +68,7 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	if (!guest_owns_fp_regs())
 		return;
 
-	cpacr_clear_set(0, CPACR_ELx_FPEN | CPACR_ELx_ZEN);
+	cpacr_clear_set(0, CPACR_EL1_FPEN | CPACR_EL1_ZEN);
 	isb();
 
 	if (vcpu_has_sve(vcpu))
@@ -481,7 +481,7 @@ void handle_trap(struct kvm_cpu_context *host_ctxt)
 		handle_host_smc(host_ctxt);
 		break;
 	case ESR_ELx_EC_SVE:
-		cpacr_clear_set(0, CPACR_ELx_ZEN);
+		cpacr_clear_set(0, CPACR_EL1_ZEN);
 		isb();
 		sve_cond_update_zcr_vq(sve_vq_from_vl(kvm_host_sve_max_vl) - 1,
 				       SYS_ZCR_EL2);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 071993c16de81..73e3198913272 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -68,7 +68,7 @@ static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
 	/* Trap SVE */
 	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), feature_ids)) {
 		if (has_hvhe())
-			cptr_clear |= CPACR_ELx_ZEN;
+			cptr_clear |= CPACR_EL1_ZEN;
 		else
 			cptr_set |= CPTR_EL2_TZ;
 	}
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index cc69106734ca7..0f6b01b3da5cf 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -48,14 +48,14 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	val |= has_hvhe() ? CPACR_EL1_TTA : CPTR_EL2_TTA;
 	if (cpus_have_final_cap(ARM64_SME)) {
 		if (has_hvhe())
-			val &= ~CPACR_ELx_SMEN;
+			val &= ~CPACR_EL1_SMEN;
 		else
 			val |= CPTR_EL2_TSM;
 	}
 
 	if (!guest_owns_fp_regs()) {
 		if (has_hvhe())
-			val &= ~(CPACR_ELx_FPEN | CPACR_ELx_ZEN);
+			val &= ~(CPACR_EL1_FPEN | CPACR_EL1_ZEN);
 		else
 			val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
 
@@ -192,7 +192,7 @@ static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 
 		/* Re-enable SVE traps if not supported for the guest vcpu. */
 		if (!vcpu_has_sve(vcpu))
-			cpacr_clear_set(CPACR_ELx_ZEN, 0);
+			cpacr_clear_set(CPACR_EL1_ZEN, 0);
 
 	} else {
 		__fpsimd_save_state(*host_data_ptr(fpsimd_state));
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 80581b1c39959..59d992455793d 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -77,12 +77,12 @@ static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 	 * VHE (HCR.E2H == 1) which allows us to use here the CPTR_EL2.TAM
 	 * shift value for trapping the AMU accesses.
 	 */
-	u64 val = CPACR_ELx_TTA | CPTR_EL2_TAM;
+	u64 val = CPACR_EL1_TTA | CPTR_EL2_TAM;
 
 	if (guest_owns_fp_regs()) {
-		val |= CPACR_ELx_FPEN;
+		val |= CPACR_EL1_FPEN;
 		if (vcpu_has_sve(vcpu))
-			val |= CPACR_ELx_ZEN;
+			val |= CPACR_EL1_ZEN;
 	} else {
 		__activate_traps_fpsimd32(vcpu);
 	}
@@ -122,13 +122,13 @@ static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
 	 * hypervisor has traps enabled to dispel any illusion of something more
 	 * complicated taking place.
 	 */
-	if (!(SYS_FIELD_GET(CPACR_ELx, FPEN, cptr) & BIT(0)))
-		val &= ~CPACR_ELx_FPEN;
-	if (!(SYS_FIELD_GET(CPACR_ELx, ZEN, cptr) & BIT(0)))
-		val &= ~CPACR_ELx_ZEN;
+	if (!(SYS_FIELD_GET(CPACR_EL1, FPEN, cptr) & BIT(0)))
+		val &= ~CPACR_EL1_FPEN;
+	if (!(SYS_FIELD_GET(CPACR_EL1, ZEN, cptr) & BIT(0)))
+		val &= ~CPACR_EL1_ZEN;
 
 	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S2POE, IMP))
-		val |= cptr & CPACR_ELx_E0POE;
+		val |= cptr & CPACR_EL1_E0POE;
 
 	val |= cptr & CPTR_EL2_TCPAC;
 
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 899526e16a4cd..40a9e4e2cae69 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -1986,7 +1986,7 @@ Field	1	A
 Field	0	M
 EndSysreg
 
-SysregFields	CPACR_ELx
+Sysreg	CPACR_EL1	3	0	1	0	2
 Res0	63:30
 Field	29	E0POE
 Field	28	TTA
@@ -1997,10 +1997,6 @@ Field	21:20	FPEN
 Res0	19:18
 Field	17:16	ZEN
 Res0	15:0
-EndSysregFields
-
-Sysreg	CPACR_EL1	3	0	1	0	2
-Fields	CPACR_ELx
 EndSysreg
 
 Sysreg	SMPRI_EL1	3	0	1	2	4
-- 
2.39.2

