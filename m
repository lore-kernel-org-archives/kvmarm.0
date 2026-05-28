Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E763367F36;
	Thu, 28 May 2026 23:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780009680; cv=none; b=GvZ/C1PWMP9EdZCNM8iZ79YdUjRiyuM3DSzsWHDpEsw6NuuKBUsyeMAvEy24TEEo/YxAH8M3vdACpRv1t0Dh85kvi4KZR1UJm/E16a5nlSWSr2uZU4N6+WXS20ao7Y0K/N1OmdV6nZgPTFTSnBdHTM8M3q0YPEmMj0m3f2RECWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780009680; c=relaxed/simple;
	bh=/PiKYJWz9gvmc4Ax3o+7W5qhwU6FgIEJncOBBReKn3U=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=odhvQQMbcyhm2in1q5pnMl3MfctmoLFioLD1FwJt5dHQjnX3NvR2/p+fVBgMBp3oFCcC5SKWdj0MIRMyHBUeQjtoHMSqXlXH6DonRcdEh20kP7iZBqHsWVo4h/cXVXMT5c/76bZKQWOEexbk0rPNstzXf1cKiu7jsUDYxUz1Dzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NFBv6Nmd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NFBv6Nmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B721F000E9;
	Thu, 28 May 2026 23:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780009678;
	bh=m8wKs5HNoGHP0jSxnKSD1ZlK+t0QNPM64QnFvO48QdY=;
	h=From:Date:Subject:To:Cc;
	b=NFBv6NmdOiXWzG22Avv21qAqoaRn04aTbZYWsUqbo/Q4rrUflkw+tUFADPcuzTJpD
	 2iOUKp01XZxrl3g7P8bg6IeUTF0weSZhkCGbTajcLiwgDPUpQJNJB2SJSDc7p1QX9z
	 NH/TZ15ZJHeCzBLiki4Wfn5anzg3fUw1aAXGqo3kdDAMQh9mXefq7v7EHtWlE9M8AB
	 vOGTcBLshh/NVX8er5R7MzE8ZLf6ujYguLqZ+udyzWoyu4Y7COtldTjTX+Vzyq/l5d
	 beuJHcSGHfiCps0Q1WZs11b/uKVoP/vhsoFL7fEgS4Gv/xmE6UtKoGwccaHZ5N7Q2r
	 xp1Mw47ELhapA==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 29 May 2026 00:01:44 +0100
Subject: [PATCH v2] KVM: arm64: Preserve all guest ZCR_EL2.LEN values
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260529-kvm-arm64-fix-zcr-len-nv-v2-1-86cad51992bd@kernel.org>
X-B4-Tracking: v=1; b=H4sIAFfJGGoC/3WNyw6CMBBFf4V07Zi24WFd8R+GRakDVKCYKTYq4
 d8t6NblSc69Z2EeyaJn52RhhMF6O7kI8pAw02nXIthrZCa5zHkmFPRhBE1jnkJjn/A2BAM6cAE
 UKixqjVxIzeL8ThiN/fpSfdk/6huaefvbjM76eaLX3g5i834ZKf9nggABaGSWouLFyTRlj+RwO
 E7Usmpd1w8OIs500wAAAA==
X-Change-ID: 20260519-kvm-arm64-fix-zcr-len-nv-9e9e7bae012a
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=7113; i=broonie@kernel.org;
 h=from:subject:message-id; bh=/PiKYJWz9gvmc4Ax3o+7W5qhwU6FgIEJncOBBReKn3U=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqGMrL6RTPvvntCgQnm5ff91NvugCqQe8i393fp
 x/5ncnA0yOJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCahjKywAKCRAk1otyXVSH
 0NgMB/kBTUgZGRmtJouc2XSSAfGbkO9NNO+WZcXaVZIT+wpXcGtupf8q3oX2y+uQiOsainGcvM0
 tbfluFjC56h/pb90Wjfx97nnmicXYwY779uvs+NvbyYAiYfcweFU3eSvehWW4SFNYPBAXPLictr
 LiNPmDlkv2rD49lsv0sSQRmxM1JiwhCaLUezLTsWYrONLHfpoDaCkebYFYTD4SqIGfUZ8ku/B2L
 TdUZs2YBLVUAAo9hJYXkwTCiQ19h+RSLlkasEPHCWFH1tVpTULIhW1obmlCo/30MP9br6MXRDf/
 H93bnKaPaWafv8ZnEvaC9Sacx8HNXr7fvCeP6YpL/QInC1LA
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Since commit b3d29a823099 ("KVM: arm64: nv: Handle ZCR_EL2 traps") when
guests write to ZCR_EL2 we have clamped the value of ZCR_EL2.LEN to be
at most that configuring the maximum guest VL when accessed directly as
ZCR_EL2. This is not clearly the behaviour the architecture documents
for ZCR_EL2.LEN, while things are a little ambiguous currently there is
a fairly direct reading that suggests values will be read as written.
Further, the documented procedure for enumerating vector lengths means
that it is expected that values larger than the largest supported vector
length will be written in practice.

The reasoning for the current behaviour is not specifically articulated, my
best guess is that it is intended to ensure that the guest can not see an
effective VL greater than the maximum that has been configured, though
this will be ineffective when a VHE guest uses the ZCR_EL1 accessor.
The VL can instead be constrained by configuring ZCR_EL2 when loading
L2 guest state:

 - When the L2 guest is running in EL1 or EL0 state configure
   ZCR_EL2.LEN to the minimum of the guest ZCR_EL2.LEN and
   vcpu_sve_max_vq(vcpu)-1.
 - When the L2 guest is running at EL2 configure the maximum VL for
   the guest in ZCR_EL2.LEN like we do for L1 guests and load the
   guest ZCR_EL2 into ZCR_EL1.

This will ensure that the effective VL seen by the guest is always
constrained by all of the maximum VL configured by the VMM and the
ZCR_ELx values in effect.

With the above implemented we can simplify the emulation for trapped
writes to ZCR_EL2 to store LEN configured by the guest directly,
matching the handling for ZCR_EL1. We still need to sanitise the values
written to ensure no unsupported fields are written, do this by adding
the register to our generic sanitisation infrastructure. This register
is a bit unusual in that as an unnamed field at bits 8:4 which is
RAZ/WI, for the purposes of sanitisation treat these bits as though they
were RES0.

Fixes: b3d29a823099 ("KVM: arm64: nv: Handle ZCR_EL2 traps")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
---
Changes in v2:
- Use generic santisation infrastructure.
- Remove redundant !is_hyp_ctxt() check.
- Also fix ZCR_EL2 configuration in __hyp_sve_restore_guest().
- Commit message clarifications.
- Link to v1: https://patch.msgid.link/20260522-kvm-arm64-fix-zcr-len-nv-v1-1-ec254e9078cf@kernel.org
---
 arch/arm64/include/asm/kvm_host.h       |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h | 16 ++++++++++------
 arch/arm64/kvm/nested.c                 |  5 +++++
 arch/arm64/kvm/sys_regs.c               |  6 +-----
 4 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 65eead8362e0..a49042bfa801 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -511,7 +511,6 @@ enum vcpu_sysreg {
 	ACTLR_EL2,	/* Auxiliary Control Register (EL2) */
 	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
 	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
-	ZCR_EL2,	/* SVE Control Register (EL2) */
 	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
 	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
 	TCR_EL2,	/* Translation Control Register (EL2) */
@@ -543,6 +542,7 @@ enum vcpu_sysreg {
 	SCTLR2_EL2,	/* System Control Register 2 (EL2) */
 	MDCR_EL2,	/* Monitor Debug Configuration Register (EL2) */
 	CNTHCTL_EL2,	/* Counter-timer Hypervisor Control register */
+	ZCR_EL2,	/* SVE Control Register (EL2) */
 
 	/* Any VNCR-capable reg goes after this point */
 	MARKER(__VNCR_START__),
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index bf0eb5e43427..320cd45d49c5 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -462,11 +462,13 @@ static inline bool kvm_hyp_handle_mops(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 {
+	u64 zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
+
 	/*
 	 * The vCPU's saved SVE state layout always matches the max VL of the
 	 * vCPU. Start off with the max VL so we can load the SVE state.
 	 */
-	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
+	sve_cond_update_zcr_vq(zcr_el2, SYS_ZCR_EL2);
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
 			    &vcpu->arch.ctxt.fp_regs.fpsr,
 			    true);
@@ -476,8 +478,10 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	 * nested guest, as the guest hypervisor could select a smaller VL. Slap
 	 * that into hardware before wrapping up.
 	 */
-	if (is_nested_ctxt(vcpu))
-		sve_cond_update_zcr_vq(__vcpu_sys_reg(vcpu, ZCR_EL2), SYS_ZCR_EL2);
+	if (is_nested_ctxt(vcpu)) {
+		zcr_el2 = min(zcr_el2, __vcpu_sys_reg(vcpu, ZCR_EL2));
+		sve_cond_update_zcr_vq(zcr_el2, SYS_ZCR_EL2);
+	}
 
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu)), SYS_ZCR);
 }
@@ -501,11 +505,11 @@ static inline void fpsimd_lazy_switch_to_guest(struct kvm_vcpu *vcpu)
 		return;
 
 	if (vcpu_has_sve(vcpu)) {
+		zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
+
 		/* A guest hypervisor may restrict the effective max VL. */
 		if (is_nested_ctxt(vcpu))
-			zcr_el2 = __vcpu_sys_reg(vcpu, ZCR_EL2);
-		else
-			zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
+			zcr_el2 = min(zcr_el2, __vcpu_sys_reg(vcpu, ZCR_EL2));
 
 		write_sysreg_el2(zcr_el2, SYS_ZCR);
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 883b6c1008fb..38f672e94087 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1834,6 +1834,11 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	resx.res1 = VNCR_EL2_RES1;
 	set_sysreg_masks(kvm, VNCR_EL2, resx);
 
+	/* ZCR_EL2 - bits 8:4 are RAZ/WI so treat them as RES0 */
+	resx.res0 = ZCR_ELx_RES0 | GENMASK_ULL(8, 4);
+	resx.res1 = ZCR_ELx_RES1;
+	set_sysreg_masks(kvm, ZCR_EL2, resx);
+
 out:
 	for (enum vcpu_sysreg sr = __SANITISED_REG_START__; sr < NR_SYS_REGS; sr++)
 		__vcpu_rmw_sys_reg(vcpu, sr, |=, 0);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 148fc3400ea8..77e1b5d223c6 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2862,8 +2862,6 @@ static bool access_zcr_el2(struct kvm_vcpu *vcpu,
 			   struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	unsigned int vq;
-
 	if (guest_hyp_sve_traps_enabled(vcpu)) {
 		kvm_inject_nested_sve_trap(vcpu);
 		return false;
@@ -2874,9 +2872,7 @@ static bool access_zcr_el2(struct kvm_vcpu *vcpu,
 		return true;
 	}
 
-	vq = SYS_FIELD_GET(ZCR_ELx, LEN, p->regval) + 1;
-	vq = min(vq, vcpu_sve_max_vq(vcpu));
-	__vcpu_assign_sys_reg(vcpu, ZCR_EL2, vq - 1);
+	__vcpu_assign_sys_reg(vcpu, ZCR_EL2, p->regval);
 	return true;
 }
 

---
base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
change-id: 20260519-kvm-arm64-fix-zcr-len-nv-9e9e7bae012a

Best regards,
--  
Mark Brown <broonie@kernel.org>

