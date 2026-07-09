Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66823AEB5C;
	Thu,  9 Jul 2026 00:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783558459; cv=none; b=n2vmGVQqJsok45LfPIJcUe9U6ApuC+d4EP5K0fx7UUjGYQpw5faxzqBgkeDW3dQ7RyDhEwLA0aFrXSPQSelaS0tw/NS/uid7s8VVVVbTbRSi4NGFZZkHDIkJpm2QXyI+Di3py9SVOXxlEdINaalIGHh+jsrLpSId4h/4XPNqyqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783558459; c=relaxed/simple;
	bh=x/XFPzNN5/J6G5E0oqhJf08B8/sFJa7dJ49zCMEJE/4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KCzb+tYGIeQGwoh1C2iYzwzfejcUyMzKqV/NMMBbVAVE/6ktFh9qclSLz2+uVclMp4iY/kVbtsxTZiZrZAqW7XpraGhxH3eOYW6ovafTqabvc9y98l8zvlvQQdrF52TSJWrz67hdCzb7W++XxQdTl+OamW6PYBXj9hjeOC6iWbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=afeQiBRX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="afeQiBRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06631F00A3E;
	Thu,  9 Jul 2026 00:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783558457;
	bh=lXCEStw7jpxbfMPkl2Z/72HpjmmD/RSWBvdz3qpCcgU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=afeQiBRXGddVjy8gvP7OiMKnoQKJcGoxKsGCxDgJNznS4OIy6Lm90hybTHJmBAHih
	 rbktnj9lG+9j/7krHmSdnUc4WCGv5+MLxVDI9a8foWsloGDFe0vPi5vr6kbElLRikD
	 RvXF+AW4rp+bswJ/Na84hOoE12rJGp9Rzx+b7PIqDG6rB+6Uh7Zvqm/4GeURz4WJi+
	 pJ88kLf3gRha+Is3iA8ZPrxrtohNHwrALFMLXk12OGFtNDMkBx5lLWo2aTX800GhEV
	 9sNveJFYEwddcBZ9puVZHmkoXmWW3Xp7aCXVwwYRKGWGxveLyvZRLWWx8v22yxGz8j
	 APIYvl/xx98ZA==
From: Mark Brown <broonie@kernel.org>
Date: Thu, 09 Jul 2026 01:52:00 +0100
Subject: [PATCH v11 23/29] KVM: arm64: Handle SME exceptions
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260709-kvm-arm64-sme-v11-23-32799f66db9d@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6115; i=broonie@kernel.org;
 h=from:subject:message-id; bh=x/XFPzNN5/J6G5E0oqhJf08B8/sFJa7dJ49zCMEJE/4=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqTvDLZPAVV2ufhgX7AgqCRpjG9WFr5V8JPGPY+
 EpN4g5jZUWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCak7wywAKCRAk1otyXVSH
 0GLMB/4pvW+iBFXiKGVzPy+LdW6AM9BRsDEubgWHKFCoTXX7bc1Kabae0HCCfgJGx9+me6of5JQ
 cgdMVdX04mY9cXEiP5BDKMaWqSfmqVIC7NOrt0yyIsvZfaqFKBV5PkE+NnEDqRnNlvZ5HKsN6cU
 brEr0qw2DmP+PrFZqFxkbvQUjIb6JV5VpYzWqNYdgiFVWbujP9T2uY3MpZlU4bBClFTocCE8XDw
 r7/pHa/aNALsdPg0U2LzC35A/t0oka3Vn4fQUy+Qknex5qdGel/kvndWi6FJvTvulMv4/WYiLQV
 IQeKWy3LtTLCQxvCYqx64P3sMxoLrZQxOeumFJP2oT5m30Jv
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

The access control for SME follows the same structure as for the base FP
and SVE extensions, with control being via CPACR_ELx.SMEN and CPTR_EL2.TSM
mirroring the equivalent FPSIMD and SVE controls in those registers. Add
handling for these controls and exceptions mirroring the existing handling
for FPSIMD and SVE.

Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/handle_exit.c            | 14 ++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 11 ++++++-----
 arch/arm64/kvm/hyp/nvhe/switch.c        |  2 ++
 arch/arm64/kvm/hyp/vhe/switch.c         | 17 ++++++++++++-----
 4 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 54aedf93c78b..e69bdb87f19d 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -237,6 +237,19 @@ static int handle_sve(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+/*
+ * Guest access to SME registers should be routed to this handler only
+ * when the system doesn't support SME.
+ */
+static int handle_sme(struct kvm_vcpu *vcpu)
+{
+	if (guest_hyp_sme_traps_enabled(vcpu))
+		return kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+
+	kvm_inject_undefined(vcpu);
+	return 1;
+}
+
 /*
  * Two possibilities to handle a trapping ptrauth instruction:
  *
@@ -390,6 +403,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_SVC64]	= handle_svc,
 	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
 	[ESR_ELx_EC_SVE]	= handle_sve,
+	[ESR_ELx_EC_SME]	= handle_sme,
 	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
 	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
 	[ESR_ELx_EC_DABT_LOW]	= kvm_handle_guest_abort,
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 7c913da9babb..47f523a37cbe 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -67,11 +67,8 @@ static inline void __activate_cptr_traps_nvhe(struct kvm_vcpu *vcpu)
 {
 	u64 val = CPTR_NVHE_EL2_RES1 | CPTR_EL2_TAM | CPTR_EL2_TTA;
 
-	/*
-	 * Always trap SME since it's not supported in KVM.
-	 * TSM is RES1 if SME isn't implemented.
-	 */
-	val |= CPTR_EL2_TSM;
+	if (!vcpu_has_sme(vcpu) || !guest_owns_fp_regs())
+		val |= CPTR_EL2_TSM;
 
 	if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs())
 		val |= CPTR_EL2_TZ;
@@ -99,6 +96,8 @@ static inline void __activate_cptr_traps_vhe(struct kvm_vcpu *vcpu)
 		val |= CPACR_EL1_FPEN;
 		if (vcpu_has_sve(vcpu))
 			val |= CPACR_EL1_ZEN;
+		if (vcpu_has_sme(vcpu))
+			val |= CPACR_EL1_SMEN;
 	}
 
 	if (!vcpu_has_nv(vcpu))
@@ -140,6 +139,8 @@ static inline void __activate_cptr_traps_vhe(struct kvm_vcpu *vcpu)
 		val &= ~CPACR_EL1_FPEN;
 	if (!(SYS_FIELD_GET(CPACR_EL1, ZEN, cptr) & BIT(0)))
 		val &= ~CPACR_EL1_ZEN;
+	if (!(SYS_FIELD_GET(CPACR_EL1, SMEN, cptr) & BIT(0)))
+		val &= ~CPACR_EL1_SMEN;
 
 	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1POE, IMP))
 		val |= cptr & CPACR_EL1_E0POE;
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7318e3e6a5f3..2d5029dbfb00 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -196,6 +196,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
 	[ESR_ELx_EC_SYS64]		= kvm_hyp_handle_sysreg,
 	[ESR_ELx_EC_SVE]		= kvm_hyp_handle_fpsimd,
+	[ESR_ELx_EC_SME]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
@@ -208,6 +209,7 @@ static const exit_handler_fn pvm_exit_handlers[] = {
 	[ESR_ELx_EC_HVC64]		= kvm_handle_pvm_hvc64,
 	[ESR_ELx_EC_SYS64]		= kvm_handle_pvm_sys64,
 	[ESR_ELx_EC_SVE]		= kvm_handle_pvm_restricted,
+	[ESR_ELx_EC_SME]		= kvm_handle_pvm_restricted,
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
 	[ESR_ELx_EC_DABT_LOW]		= kvm_hyp_handle_dabt_low,
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index bbe9cebd3d9d..5fc677afcaf9 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -458,22 +458,28 @@ static bool kvm_hyp_handle_cpacr_el1(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
-static bool kvm_hyp_handle_zcr_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
+static bool kvm_hyp_handle_vec_cr_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
 
 	if (!vcpu_has_nv(vcpu))
 		return false;
 
-	if (sysreg != SYS_ZCR_EL2)
+	switch (sysreg) {
+	case SYS_ZCR_EL2:
+	case SYS_SMCR_EL2:
+		break;
+	default:
 		return false;
+	}
 
 	if (guest_owns_fp_regs())
 		return false;
 
 	/*
-	 * ZCR_EL2 traps are handled in the slow path, with the expectation
-	 * that the guest's FP context has already been loaded onto the CPU.
+	 * ZCR_EL2 and SMCR_EL2 traps are handled in the slow path,
+	 * with the expectation that the guest's FP context has
+	 * already been loaded onto the CPU.
 	 *
 	 * Load the guest's FP context and unconditionally forward to the
 	 * slow path for handling (i.e. return false).
@@ -493,7 +499,7 @@ static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (kvm_hyp_handle_cpacr_el1(vcpu, exit_code))
 		return true;
 
-	if (kvm_hyp_handle_zcr_el2(vcpu, exit_code))
+	if (kvm_hyp_handle_vec_cr_el2(vcpu, exit_code))
 		return true;
 
 	return kvm_hyp_handle_sysreg(vcpu, exit_code);
@@ -522,6 +528,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
 	[ESR_ELx_EC_SYS64]		= kvm_hyp_handle_sysreg_vhe,
+	[ESR_ELx_EC_SME]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_SVE]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,

-- 
2.47.3

