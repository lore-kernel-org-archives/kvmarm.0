Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B7A2AD03;
	Thu,  9 Jul 2026 00:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783558374; cv=none; b=a17074pK/ghrhYJ05im+Z4joPEoPedvAGewf4IkNbun9MTQmSiHN4yrtwn+zIQqOYHSJy+D6/E7Rp9660tudOJ6Q5hPOa3HxKbGG27iTLnVn/I46FHh6c2G20SKfOxuZ/I6BRpugk1vVRuabasxxWmZ/Hi2Ec4U2o6WSc1QsqKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783558374; c=relaxed/simple;
	bh=LWJU1DW0v04tDKSLTA3TrlLIRe48SZoL4LVSvdSUkiE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=u/MLNKUp6exjQ7ygPNAda9cbUbv53QLaYxJgE5weMXoSpywWX2dQBGrRd2qDOopYkWgoTQYdxezX9oufAPDpU/x+wGt+YmDuD6+ooVMdUfwZaziaCFs+u0R1Wh1zAfQ4PQmcu2ISIWnJsmBQQpPBJ0I8bZZOnj7aWQT+sgEvtMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kn9phhYl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kn9phhYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BDE1F00A3E;
	Thu,  9 Jul 2026 00:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783558370;
	bh=IePB7KK76qxAQZKa79z6gQ5nNy5ze/T0hxePNaWjw8A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Kn9phhYlV3dM1yI+8PUvLOeeStUzYRHFUfda70kY3lpFm7j7CzGJjfYn41iWluJPe
	 mJ596/GXA11N3hj0z+chLjh5XAJxPkabeWCVddRJRiBcnMJApeLpb0oWSgG56L01Fp
	 y5r0o9pnbAr6QirjzI2JfQKxHwTuJS34NjzaU/MK17cAdoJk9gFGY8sh7VD/D0ooPU
	 giPiLCphhHbIbQi0LUcFYiQETbdJ9Io8LtcylJvGzbTwkRF+oB1Q7+B6bd34gi5ipi
	 tcf6m76hggFBNQ+uAtHtY1tjwH2nZ0UBRS3tWvS7xXKhazzzTOCeqa/wGwnUq6uVT4
	 mYT3TN3iTfpLA==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 01:51:40 +0100
Subject: [PATCH v11 03/29] arm64/fpsimd: Decide to save ZT0 and streaming
 mode FFR at bind time
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v11-3-32799f66db9d@kernel.org>
References: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
In-Reply-To: <20260709-kvm-arm64-sme-v11-0-32799f66db9d@kernel.org>
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
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqTvC8Ge7pUcHh4cCt9FdpWrvSNC8oGszZ+9HUz
 02cgNo+njeJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak7wvAAKCRAk1otyXVSH
 0IjpCACDA3g14xXQRsL/rlCDCFAP5XhgSCl8Oz/2s+XVxivxsWadoxEBt/a+vib/6XDT5JxMOF/
 wU1jbufPmbBGHzo3hfhL2lERaA6RTH3JvjcoDDkEDA+YmOztd8HnfdWxKqNzwFdGf5RFULEko0o
 UxKvfkEF9QUVYAcmPaR+f+LckcBAC08ryW55yLweTuXNhYjjR9dzoheUVhPlhnKMxcJCEvl04Mf
 sI6PCGQVrzYSvObEb5UCLqDnZQNVMu+YDJjFaaT/bsPogJsN5Q+qPBo6jogRVFCnyaVamLvq8zm
 SgYHrhKjhguBGrBJEs+B7zHz1sFjh6H2qCtlm6eSsydoZiJd
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

