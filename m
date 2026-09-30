Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64F252CCC6;
	Wed, 30 Sep 2026 21:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804958; cv=none; b=Dld1h9Q0YUGg+2JtwjxTleQ+5gruuPFyJsqg8szrAe6P9MeMCkyK48yPh8exYTVS438Ucb7ZG0TLCG/eV/QoXr6i2Ips8MOBESS46vqHfgKl8qKQucxD78m18sZrnIK6GNDb+5Twtx2vZdj90pakOawsO4pZxvZ4V6JaAa9ua7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804958; c=relaxed/simple;
	bh=bBnQDLmdMm1YnC+rDRboHwuSsLquBFG/4uNykMXfTLU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gA9xreFbCOTP+SS3q4DQ4WB+g4gSinP3hDsrz/H+VzUfuFSkRBkG+uJmEJssCrWUj7sdVIL/7N5Fl85JGRxqZwW0AV1tp2Gx11W6NY3ZAx7n0K9+dW79xT4PHrK6IrY/LifgcniSInjXYVWUC2vR35DVBJY4P0W6incJh4axG6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZD/bGzTd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZD/bGzTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BE31F00898;
	Wed, 30 Sep 2026 21:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790804956;
	bh=0RFak+FihnONiTiEOAUxLCIOKirVYlhzx9YeUDFVJDk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZD/bGzTdv6v1PNnNdFQSLCKIKGjX3DYJnaE9iFCxT2nnwmPFcTrxwTqCxtegvIr5e
	 A04E6WWP8DAOKxGRBHsz664uDYFutOcb/b6Al2KCfaVxKY9PPUmlscFx04XPmwMpQw
	 EG0yXIGgg9x4LB++okGpiYzpJ0oGCtwszIOJyp8m+PRyb0nBUWbcQ6dbtbdgYZJU4l
	 ZrVRYTnaRQlXANish8rhMRRj40Hiczq6pt9Fa7Bte4kwNvXNcxLESOSFxYWCaSxp/C
	 0FXgSMN/FWcPObu5DTxbZWZe7C3hNNDF4u7mSSI9oZiqgQMC1/QekyEbph55z6g9Wk
	 p+9Q9NXoIPVdA==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 30 Sep 2026 22:48:16 +0100
Subject: [PATCH v21 06/15] KVM: arm64: Validate GCS exception lock when
 emulating ERET
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260930-arm64-gcs-v21-6-3556644cd927@kernel.org>
References: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
In-Reply-To: <20260930-arm64-gcs-v21-0-3556644cd927@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Leonardo Bras <leo.bras@arm.com>, Wei-Lin Chang <weilin.chang@arm.com>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3854; i=broonie@kernel.org;
 h=from:subject:message-id; bh=bBnQDLmdMm1YnC+rDRboHwuSsLquBFG/4uNykMXfTLU=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqvYO4BhrNor4NfGVDZghSRfCcwZSvFZk+reGqp
 fL8NgZ41iSJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCar2DuAAKCRAk1otyXVSH
 0AF/B/0TgqsSBrk0vQJPq3g1ZMqss1vydZqimIRNMTu3o5sZFfy+KdQVwHVja5gnDplQX6cSw6y
 QawHZwWv21+fBfbw3khP02m4eirPe/IZ7q0SpZpXG5PmwORLdlxbsbb2TWVdfo2LfWjxg33fJ9d
 sbTskoGsl2nbKk5OzgUzxth/2FZfZOGEaqz1H9c4oUqGfW40WCPmIcUoIIh41gLUtFhUA1xKnxi
 k12APuqVzfX0Kf6XGu0aWQTsJgf0Zmffuubfdp/SYsfQocwqBaywj0to8rVLnaavMn0KFUskFDI
 T+QWTD0SOxsZiM10z3ncs6mTb8G2SkCStJ2v2Szmf2L5hi7o
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

As per DDI0487 R_TYTWB GCS adds an additional case where an illegal
exception return can be generated. If all of:

 - PSTATE.EXLOCK is 0.
 - The EL is not being changed by the ERET.
 - GCSCR_ELx.EXLOCKEN is 1.

are true then the return is illegal. Emulate this behaviour when
emulating ERET for nested guests, while we're at it using the symbolic
definition for EXLOCK in SPSR.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 32 ++++++++++++++++++++++++++++++++
 arch/arm64/kvm/emulate-nested.c     |  5 ++++-
 arch/arm64/kvm/hyp/vhe/switch.c     |  4 ++++
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 1ed708335809..9e595e8e7642 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -240,6 +240,38 @@ static inline bool kvm_auth_eretax(struct kvm_vcpu *vcpu, u64 *elr)
 }
 #endif
 
+#ifdef CONFIG_ARM64_GCS
+/* See IllegalExceptionReturn() pseudocode */
+static inline bool kvm_check_illegal_exlock_return(struct kvm_vcpu *vcpu,
+						   u64 spsr)
+{
+	u64 pstate, cur_mode, target_mode;
+
+	if (!kvm_has_gcs(vcpu->kvm))
+		return false;
+
+	if (vcpu->arch.ctxt.regs.pstate & PSR_EXLOCK_BIT)
+		return false;
+
+	/* Check the EL only, ignore thread mode */
+	pstate = vcpu->arch.ctxt.regs.pstate;
+	cur_mode = (pstate & PSR_MODE_MASK) | PSR_MODE_THREAD_BIT;
+	target_mode = (spsr & PSR_MODE_MASK) | PSR_MODE_THREAD_BIT;
+
+	if (cur_mode != target_mode)
+		return false;
+
+	return vcpu_read_sys_reg(vcpu, GCSCR_EL2) & GCSCR_ELx_EXLOCKEN;
+}
+
+#else
+static inline bool kvm_check_illegal_exlock_return(struct kvm_vcpu *vcpu,
+						   u64 spsr)
+{
+	return false;
+}
+#endif
+
 #define KVM_NV_GUEST_MAP_SZ	(KVM_PGTABLE_PROT_SW1 | KVM_PGTABLE_PROT_SW0)
 
 static inline u64 kvm_encode_nested_level(struct kvm_s2_trans *trans)
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 625604019fb3..5aa26384720a 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2748,10 +2748,13 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 	 * - trying to return to an illegal M value
 	 * - trying to return to a 32bit EL
 	 * - trying to return to EL1 with HCR_EL2.TGE set
+	 * - GCSCR_ELx.EXLOCKEN is 1 and PSTATE.EXLOCK is 0 when attempting
+	 *   to return from ELx the same EL.
 	 */
 	if (mode == PSR_MODE_EL3t   || mode == PSR_MODE_EL3h ||
 	    mode == 0b00001         || (mode & BIT(1))       ||
 	    (spsr & PSR_MODE32_BIT) ||
+	    kvm_check_illegal_exlock_return(vcpu, spsr) ||
 	    (vcpu_el2_tge_is_set(vcpu) && (mode == PSR_MODE_EL1t ||
 					   mode == PSR_MODE_EL1h))) {
 		u64 mask;
@@ -2778,7 +2781,7 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 
 		mask = PSR_MODE_MASK | PSR_MODE32_BIT;
 		if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
-			mask |= BIT_ULL(34);	/* PSTATE.EXLOCK */
+			mask |= PSR_EXLOCK_BIT;
 
 		spsr |= *vcpu_cpsr(vcpu) & mask;
 		spsr |= PSR_IL_BIT;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 7875911c0506..af59d1bf51ad 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -383,6 +383,10 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 		return false;
 	}
 
+	/* Push GCS exception lock failures into the slow path */
+	if (kvm_check_illegal_exlock_return(vcpu, spsr))
+		return false;
+
 	/* If ERETAx fails, take the slow path */
 	if (esr_iss_is_eretax(esr)) {
 		if (!(vcpu_has_ptrauth(vcpu) && kvm_auth_eretax(vcpu, &elr)))

-- 
2.47.3

