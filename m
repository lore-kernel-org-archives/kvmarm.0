Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CD3437475;
	Thu,  9 Jul 2026 18:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783622423; cv=none; b=JF+yiaB/a3+bKZGDTbCNhchdPzQ32skOV2FrjBFFrL/Zsxh4bLO3vrE6VXGR+d5bDKkcaf+kCFCbE8LRuDIuQb/dkCzDr3l/XEKm0veGCJMAO51KKmnjdF+E32OROsyFI+bsnayKEG/gvUCN4O6Lhi/ljc2MOV2KKGGdfncp8U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783622423; c=relaxed/simple;
	bh=LWJU1DW0v04tDKSLTA3TrlLIRe48SZoL4LVSvdSUkiE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mUi5zbjKzLWo/oyM+zVLhGERn1WC4ujEXouE5GmPIzazoAeiCQ5b3HrV+ZM8oeNDuJpJz/PwedIqavaeV8auamLInNcOrh+D5FGoBsfC39B8zg2Z9Qib9F+VJYBUK8izfhtDzN5tM1HEphJyvMAOF2RpfoD52GuR4a58oE1MbqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2cmPnWH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2cmPnWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91D01F000E9;
	Thu,  9 Jul 2026 18:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783622419;
	bh=IePB7KK76qxAQZKa79z6gQ5nNy5ze/T0hxePNaWjw8A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=l2cmPnWHFyYbPkDYyvLBK5Fi/6kooRZPCGFknTSS+nOdekx9qCSRwddCYNZ65NcL1
	 fif9v1Snw86W7mJXJc/fLlgUJ/Fr8MjDpajkKsyGe8DtA4zsrj3XCgqKDqNPaNwJa7
	 K1kOnl3j3gjk4jdoikgSiwHCcbK6WGqq/mu2EpQKN3LDARmwkb2LoLyTO8MaPrD7E7
	 ltV2ayheCMJ9jgP8Fyiq49k+k1Uvu+bpCQhw2q//QTXhvNCm7/HNC/s5d/WHYUaHK6
	 cfBcTxC4UuQGkgtUQmbNFBq39ptPZEeO2tLJR5pSsgAFlFpueQQZzKoO4IQcd4vGk2
	 Q/ts3lU1gO1bw==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 19:27:24 +0100
Subject: [PATCH v12 03/29] arm64/fpsimd: Decide to save ZT0 and streaming
 mode FFR at bind time
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v12-3-d0301d79ef58@kernel.org>
References: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v12-0-d0301d79ef58@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <shuah@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Fuad Tabba <tabba@google.com>, 
 Mark Rutland <mark.rutland@arm.com>, Ben Horgan <ben.horgan@arm.com>, 
 Jean-Philippe Brucker <jpb@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Peter Maydell <peter.maydell@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4661; i=broonie@kernel.org;
 h=from:subject:message-id; bh=LWJU1DW0v04tDKSLTA3TrlLIRe48SZoL4LVSvdSUkiE=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqT+rsH3CO5eCSYAwZpZpLlQCAO43p+RG46DeWJ
 i5+CW7cHHqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak/q7AAKCRAk1otyXVSH
 0MzlB/4hewygpuTmbVfoDGlv6L6XoXc5eDfeCbFGfqBc2n+UAqwBQr9an8HUqeiwFy2B2DwLSxZ
 fvGt2yawkX6SuanEt7OcdyWoi7zLhGaoUsXhg7P+IADURnm0xkmr7kygZXg6O0Z2h2+bI5q8Rdv
 0i60koBR1RCN6Gx/2x3RHrIla7g7+LqbIkhjAMnoqZxi7kjxxAWrHHvpJDvkOHCivWpbD+u/QDP
 ZyKlCg+SbqIzGJEtWLtCfjxUQ03+LACbvJd5OGDjtWgRJjK9wLEl1xwlEDOOlFVDKr47PCLuY0d
 unTqdbbLRutdhDKbmiGCk3OfI64iMf1OjaHNQ591px+f7eXW
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

Some parts of the SME state are optional, enabled by additional features
on top of the base FEAT_SME and controlled with enable bits in SMCR_ELx. We
unconditionally enable these for the host but for KVM we will allow the
feature set exposed to guests to be restricted by the VMM. These are the
FFR register (FEAT_SME_FA64) and ZT0 (FEAT_SME2).

We defer saving of guest floating point state for non-protected guests to
the host kernel. We also want to avoid having to reconfigure the guest
floating point state if nothing used the floating point state while running
the host. If the guest was running with the optional features disabled then
traps will be enabled for them so the host kernel will need to skip
accessing that state when saving state for the guest.

Support this by moving the decision about saving this state to the point
where we bind floating point state to the CPU, instead of only storing
the SME VL to use we store the SMCR value.  This includes all the enable
controls for the subfeatures along the vector length.

In order to keep the code paths for the vector extensions consistent
also adjust the SVE path to store a ZCR value instead of the VL, since
no fields other than LEN are currently defined for ZCR this is much less
of a meaningful change.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h |  4 ++--
 arch/arm64/kernel/fpsimd.c      | 16 ++++++++--------
 arch/arm64/kvm/fpsimd.c         |  3 ++-
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 8d2a3d63481b..0a3299142683 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -166,8 +166,8 @@ struct cpu_fp_state {
 	struct arm64_sme_state *sme_state;
 	u64 *svcr;
 	u64 *fpmr;
-	unsigned int sve_vl;
-	unsigned int sme_vl;
+	u64 smcr;
+	u64 zcr;
 	enum fp_type *fp_type;
 	enum fp_type to_save;
 };
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 8009213288b1..dc1ad10e39a2 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -470,7 +470,7 @@ static void fpsimd_save_user_state(void)
 	/* set by fpsimd_bind_task_to_cpu() or fpsimd_bind_state_to_cpu() */
 	bool save_sve_regs = false;
 	bool save_ffr;
-	unsigned int vl;
+	unsigned int vq;
 
 	WARN_ON(!system_supports_fpsimd());
 	WARN_ON(preemptible());
@@ -494,7 +494,7 @@ static void fpsimd_save_user_state(void)
 	    last->to_save == FP_STATE_SVE) {
 		save_sve_regs = true;
 		save_ffr = true;
-		vl = last->sve_vl;
+		vq = SYS_FIELD_GET(ZCR_ELx, LEN, last->zcr) + 1;
 	}
 
 	if (system_supports_sme()) {
@@ -504,19 +504,19 @@ static void fpsimd_save_user_state(void)
 
 		if (*svcr & SVCR_ZA_MASK)
 			sme_save_state(last->sme_state,
-				       system_supports_sme2());
+				       last->smcr & SMCR_ELx_EZT0);
 
 		/* If we are in streaming mode override regular SVE. */
 		if (*svcr & SVCR_SM_MASK) {
 			save_sve_regs = true;
-			save_ffr = system_supports_fa64();
-			vl = last->sme_vl;
+			save_ffr = last->smcr & SMCR_ELx_FA64;
+			vq = SYS_FIELD_GET(SMCR_ELx, LEN, last->smcr) + 1;
 		}
 	}
 
 	if (IS_ENABLED(CONFIG_ARM64_SVE) && save_sve_regs) {
 		/* Get the configured VL from RDVL, will account for SM */
-		if (WARN_ON(sve_get_vl() != vl)) {
+		if (WARN_ON(sve_get_vl() != sve_vl_from_vq(vq))) {
 			/*
 			 * Can't save the user regs, so current would
 			 * re-enter user with corrupt state.
@@ -1704,8 +1704,8 @@ static void fpsimd_bind_task_to_cpu(void)
 	last->st = &current->thread.uw.fpsimd_state;
 	last->sve_state = current->thread.sve_state;
 	last->sme_state = current->thread.sme_state;
-	last->sve_vl = task_get_sve_vl(current);
-	last->sme_vl = task_get_sme_vl(current);
+	last->zcr = task_zcr(current);
+	last->smcr = task_smcr(current);
 	last->svcr = &current->thread.svcr;
 	last->fpmr = &current->thread.uw.fpmr;
 	last->fp_type = &current->thread.fp_type;
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 3f6b1e29cd6b..567dd43970c5 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -89,7 +89,8 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 		 */
 		fp_state.st = &vcpu->arch.ctxt.fp_regs;
 		fp_state.sve_state = vcpu->arch.sve_state;
-		fp_state.sve_vl = vcpu->arch.sve_max_vl;
+		fp_state.zcr = vcpu_sve_max_vq(vcpu) - 1;
+		fp_state.smcr = 0;
 		fp_state.sme_state = NULL;
 		fp_state.svcr = __ctxt_sys_reg(&vcpu->arch.ctxt, SVCR);
 		fp_state.fpmr = __ctxt_sys_reg(&vcpu->arch.ctxt, FPMR);

-- 
2.47.3

