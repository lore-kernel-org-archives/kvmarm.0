Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DBA3672A0;
	Wed, 12 Aug 2026 19:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786562016; cv=none; b=fNtt2vS5V7MlVEzMOqRex9NGBIVxMDuts0WvbuoFb2Nj6UmSTSMpVZQ5kzdbtxSDgXFgqGvtrzqFcufpp5uuH58MoL9vPX3dNpGCsdsJTNtSDNyZ1htG8E+bai4F5r9lUMldmUGT27xsKmGvQ0GwaqPgA6TjFcr1VmRckghmByc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786562016; c=relaxed/simple;
	bh=w1HB4rs5vY0+63MM8ZA5YTnCURRtbHA3eauKDkRJi+E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mPnCnGHw0Gw5meuE3dbMysEQcMShH1zaOLKN0hS+FBiHMDBXidEG0MdXKLGaz96dPZdPouYlw/u8Xgb5edSCdvZAxD/nzqiiNRs9FWWSp2jjxIXL3XFgiAUB3kfIQxAZTnQod5OtEvMRDMBm7G6ygd6TqJBrNGbdca/1a2SzgYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hj99b/Aj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hj99b/Aj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62191F000E9;
	Wed, 12 Aug 2026 19:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786562014;
	bh=ekUzBfAXxHvdC2xt7PI8Q+t+4ak8Ryuiu6Ia4c40YAE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Hj99b/AjIrkDTJjSHaHl9lN4vatwjDpar/bZu++3yjWEFzRNdGgVUtpMDsSL76Szr
	 LyjAgjtCvQMABEATtT9c2mdkGKd2Ibh3/A6VvC5k9AE6+06cZ3Dgc8uwtSNoOTYRGq
	 hQebnwVfPR94FHI+8awK3ue8Cx+q5nGrblwsZ6pp53oBEdQNacmYDt1M2gee3wLEJE
	 NpXD+Kkh27pLAbA132olK/8O4JfEmkITd86SPCtJ01C/Mnui+g4guCe3IE5fUu8Tz3
	 GZhaVlpAu5YrTswlBLm/E8ygu5QoZkA3d+Z8Ub3gqvoXzfWaFVRV/vZQ7CrhE8W6sU
	 n4iCzvTp8cBHw==
From: Mark Brown <broonie@kernel.org>
Date: Wed, 12 Aug 2026 20:12:05 +0100
Subject: [PATCH v19 06/14] KVM: arm64: Validate GCS exception lock when
 emulating ERET
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260812-arm64-gcs-v19-6-9105afd828ac@kernel.org>
References: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
In-Reply-To: <20260812-arm64-gcs-v19-0-9105afd828ac@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 Yao Yuan <yaoyuan@linux.alibaba.com>, linux-arm-kernel@lists.infradead.org, 
 linux-doc@vger.kernel.org, kvmarm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3932; i=broonie@kernel.org;
 h=from:subject:message-id; bh=w1HB4rs5vY0+63MM8ZA5YTnCURRtbHA3eauKDkRJi+E=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqfMW+qURaHc9Q5vmsUMxHx3+JR2PeEpsiUfRAl
 P+P2z5r1GKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanzFvgAKCRAk1otyXVSH
 0NWXB/46bhkWeosLjx9La/4KroVKU/+57tiYRbdX1d1ta8kuLj90gvsb2IIUnSLzPJ/n6aMonF4
 UZAKeeKkqAxOFvIQuZmwpWZ7noA3dXcfGFqdBCcTVEDB2R6rc3LXvLZy12VlnK8IrPV/NLMuN43
 1EnAs/vgENv9dJQWtP/8HC/FZlC6q7dbcqik5fnOOvvqfuv0ciFgxOInUNdrw/hDrTFtBzN/b5y
 VJ3zOAsm0d6MfBQ9mA2R89Fb32KQWaumBJHPlGbngC4cCenau7vVHUJiyXebcA1Z3At59PekfeT
 y6RTDSgfVUpnkQyeNYkCLBAdplPdzs3YsZEwA1Q0EO+Wy28x
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

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 39 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/emulate-nested.c     |  5 ++++-
 arch/arm64/kvm/hyp/vhe/switch.c     |  4 ++++
 3 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 012d711034d1..f25ddee89206 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -240,6 +240,45 @@ static inline bool kvm_auth_eretax(struct kvm_vcpu *vcpu, u64 *elr)
 }
 #endif
 
+#ifdef CONFIG_ARM64_GCS
+/*
+ * A subset of the pseudocode ELFromSPSR(), validity checks are
+ * assumed to have been done in code that is not GCS specific.
+ */
+static inline int exlock_el_from_spsr(u64 spsr)
+{
+	return FIELD_GET(GENMASK(3, 2), spsr);
+}
+
+/* See IllegalExceptionReturn() pseudocode */
+static inline bool kvm_check_illegal_exlock_return(struct kvm_vcpu *vcpu,
+						   u64 spsr)
+{
+	u64 cur_el, target_el;
+
+	if (!kvm_has_gcs(vcpu->kvm))
+		return false;
+
+	if (vcpu->arch.ctxt.regs.pstate & PSR_EXLOCK_BIT)
+		return false;
+
+	cur_el = exlock_el_from_spsr(vcpu->arch.ctxt.regs.pstate);
+	target_el = exlock_el_from_spsr(spsr);
+
+	if (cur_el != target_el)
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
index b32742d9dd73..0f0723f22000 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2740,10 +2740,13 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
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
@@ -2770,7 +2773,7 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 
 		mask = PSR_MODE_MASK | PSR_MODE32_BIT;
 		if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
-			mask |= BIT_ULL(34);	/* PSTATE.EXLOCK */
+			mask |= PSR_EXLOCK_BIT;
 
 		spsr |= *vcpu_cpsr(vcpu) & mask;
 		spsr |= PSR_IL_BIT;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index bbe9cebd3d9d..e09d9a425689 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -371,6 +371,10 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
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

