Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF06D217709
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115008; cv=none; b=CdQ4qefutjX2WZD54vjnoy3a+wAZO+2PutY8wFPtMqlL6EO72+R/+EguvRff8SELKnWjoE6i76TGOnOxfhr1B8FuT+Ltfx5pt2KlnXobR3HYWAAXiItWuTkz2nXye/2HWOwB+z5RVaAkmuRNIE535ciro+E5mX5t+SmSx6Ny+Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115008; c=relaxed/simple;
	bh=Xa99bqgVKio9f8jlkvXkbfmUQ/IMlsfdKunI5NU6P9c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ELt44nsnQH7yEFqiy0kYeKBFxTWxCdbvTqAkrHN++7WpYJE7fkT2GQqFT+02qKYcjX0jFRDfFadgjDDKYbKWndymgTag8ety3LZsQJHXwqoTlnwTv/SjvQwrkTnox5w/hICSy4kn5oUM5OtNK63cTbCpwRTqbN3cDOW/pBUhkaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BJv/HEM4; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BJv/HEM4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750115004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a2+Fmnh3pOffOrdsfxXW9rtTsj4KBgcldeNtv1L7D+I=;
	b=BJv/HEM4rW7lZHXQIlNM0g5hshuF9WsVvjytS239Jp1TQsNlZIPfjKlsgtCX65FRxWQQZ1
	/CBXyI2h/us3w17nKG3gbhxoekrUwQ3Qu4n7YGgfZZyydMDYV/52w9Yn9xIqfn9HwPyyga
	rdziaIj0RsLpBRS7NMfnC7/JHyBW5gc=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 03/27] KVM: arm64: Add helper to identify a nested context
Date: Mon, 16 Jun 2025 16:02:44 -0700
Message-Id: <20250616230308.1192565-4-oliver.upton@linux.dev>
In-Reply-To: <20250616230308.1192565-1-oliver.upton@linux.dev>
References: <20250616230308.1192565-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Marc Zyngier <maz@kernel.org>

A common idiom in the KVM code is to check if we are currently
dealing with a "nested" context, defined as having NV enabled,
but being in the EL1&0 translation regime.

This is usually expressed as:

	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu) ... )

which is a mouthful and a bit hard to read, specially when followed
by additional conditions.

Introduce a new helper that encapsulate these two terms, allowing
the above to be written as

	if (is_nested_context(vcpu) ... )

which is both shorter and easier to read, and makes more obvious
the potential for simplification on some code paths.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_emulate.h    |  5 +++++
 arch/arm64/kvm/arch_timer.c             |  2 +-
 arch/arm64/kvm/arm.c                    |  2 +-
 arch/arm64/kvm/emulate-nested.c         |  9 ++-------
 arch/arm64/kvm/handle_exit.c            | 20 +++++++-------------
 arch/arm64/kvm/hyp/include/hyp/switch.h |  8 ++++----
 arch/arm64/kvm/hyp/vgic-v3-sr.c         |  2 +-
 arch/arm64/kvm/vgic/vgic-v3-nested.c    |  2 +-
 8 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index bd020fc28aa9..19ffe9b0d3c1 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -224,6 +224,11 @@ static inline bool vcpu_is_host_el0(const struct kvm_vcpu *vcpu)
 	return is_hyp_ctxt(vcpu) && !vcpu_is_el2(vcpu);
 }
 
+static inline bool is_nested_ctxt(struct kvm_vcpu *vcpu)
+{
+	return vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu);
+}
+
 /*
  * The layout of SPSR for an AArch32 state is different when observed from an
  * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 701ea10a63f1..dbd74e4885e2 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -830,7 +830,7 @@ static void timer_set_traps(struct kvm_vcpu *vcpu, struct timer_map *map)
 	 * by the guest (either FEAT_VHE or FEAT_E2H0 is implemented, but
 	 * not both). This simplifies the handling of the EL1NV* bits.
 	 */
-	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
+	if (is_nested_ctxt(vcpu)) {
 		u64 val = __vcpu_sys_reg(vcpu, CNTHCTL_EL2);
 
 		/* Use the VHE format for mental sanity */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index de2b4e9c9f9f..8419da3581d3 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -521,7 +521,7 @@ static void vcpu_set_pauth_traps(struct kvm_vcpu *vcpu)
 		 * Either we're running an L2 guest, and the API/APK bits come
 		 * from L1's HCR_EL2, or API/APK are both set.
 		 */
-		if (unlikely(vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu))) {
+		if (unlikely(is_nested_ctxt(vcpu))) {
 			u64 val;
 
 			val = __vcpu_sys_reg(vcpu, HCR_EL2);
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 3a384e9660b8..1de4a9001d9d 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2592,13 +2592,8 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 
 static bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg, u64 control_bit)
 {
-	bool control_bit_set;
-
-	if (!vcpu_has_nv(vcpu))
-		return false;
-
-	control_bit_set = __vcpu_sys_reg(vcpu, reg) & control_bit;
-	if (!is_hyp_ctxt(vcpu) && control_bit_set) {
+	if (is_nested_ctxt(vcpu) &&
+	    (__vcpu_sys_reg(vcpu, reg) & control_bit)) {
 		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
 		return true;
 	}
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 453266c96481..c37c58d9d25d 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -252,7 +252,7 @@ static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
-	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
+	if (is_nested_ctxt(vcpu)) {
 		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
 		return 1;
 	}
@@ -311,12 +311,11 @@ static int kvm_handle_gcs(struct kvm_vcpu *vcpu)
 
 static int handle_other(struct kvm_vcpu *vcpu)
 {
-	bool is_l2 = vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu);
+	bool allowed, fwd = is_nested_ctxt(vcpu);
 	u64 hcrx = __vcpu_sys_reg(vcpu, HCRX_EL2);
 	u64 esr = kvm_vcpu_get_esr(vcpu);
 	u64 iss = ESR_ELx_ISS(esr);
 	struct kvm *kvm = vcpu->kvm;
-	bool allowed, fwd = false;
 
 	/*
 	 * We only trap for two reasons:
@@ -335,28 +334,23 @@ static int handle_other(struct kvm_vcpu *vcpu)
 	switch (iss) {
 	case ESR_ELx_ISS_OTHER_ST64BV:
 		allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_V);
-		if (is_l2)
-			fwd = !(hcrx & HCRX_EL2_EnASR);
+		fwd &= !(hcrx & HCRX_EL2_EnASR);
 		break;
 	case ESR_ELx_ISS_OTHER_ST64BV0:
 		allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64_ACCDATA);
-		if (is_l2)
-			fwd = !(hcrx & HCRX_EL2_EnAS0);
+		fwd &= !(hcrx & HCRX_EL2_EnAS0);
 		break;
 	case ESR_ELx_ISS_OTHER_LDST64B:
 		allowed = kvm_has_feat(kvm, ID_AA64ISAR1_EL1, LS64, LS64);
-		if (is_l2)
-			fwd = !(hcrx & HCRX_EL2_EnALS);
+		fwd &= !(hcrx & HCRX_EL2_EnALS);
 		break;
 	case ESR_ELx_ISS_OTHER_TSBCSYNC:
 		allowed = kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceBuffer, TRBE_V1P1);
-		if (is_l2)
-			fwd = (__vcpu_sys_reg(vcpu, HFGITR2_EL2) & HFGITR2_EL2_TSBCSYNC);
+		fwd &= (__vcpu_sys_reg(vcpu, HFGITR2_EL2) & HFGITR2_EL2_TSBCSYNC);
 		break;
 	case ESR_ELx_ISS_OTHER_PSBCSYNC:
 		allowed = kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, V1P5);
-		if (is_l2)
-			fwd = (__vcpu_sys_reg(vcpu, HFGITR_EL2) & HFGITR_EL2_PSBCSYNC);
+		fwd &= (__vcpu_sys_reg(vcpu, HFGITR_EL2) & HFGITR_EL2_PSBCSYNC);
 		break;
 	default:
 		/* Clearly, we're missing something. */
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 76dfda116e56..71a66c910ab2 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -168,7 +168,7 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 		u64 val;						\
 									\
 		ctxt_sys_reg(hctxt, reg) = read_sysreg_s(SYS_ ## reg);	\
-		if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu))		\
+		if (is_nested_ctxt(vcpu))				\
 			compute_clr_set(vcpu, reg, c, s);		\
 									\
 		compute_undef_clr_set(vcpu, kvm, reg, c, s);		\
@@ -306,7 +306,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 
 	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
 		u64 hcrx = vcpu->arch.hcrx_el2;
-		if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
+		if (is_nested_ctxt(vcpu)) {
 			u64 val = __vcpu_sys_reg(vcpu, HCRX_EL2);
 			hcrx |= val & __HCRX_EL2_MASK;
 			hcrx &= ~(~val & __HCRX_EL2_nMASK);
@@ -401,7 +401,7 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 	 * nested guest, as the guest hypervisor could select a smaller VL. Slap
 	 * that into hardware before wrapping up.
 	 */
-	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu))
+	if (is_nested_ctxt(vcpu))
 		sve_cond_update_zcr_vq(__vcpu_sys_reg(vcpu, ZCR_EL2), SYS_ZCR_EL2);
 
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, vcpu_sve_zcr_elx(vcpu)), SYS_ZCR);
@@ -427,7 +427,7 @@ static inline void fpsimd_lazy_switch_to_guest(struct kvm_vcpu *vcpu)
 
 	if (vcpu_has_sve(vcpu)) {
 		/* A guest hypervisor may restrict the effective max VL. */
-		if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu))
+		if (is_nested_ctxt(vcpu))
 			zcr_el2 = __vcpu_sys_reg(vcpu, ZCR_EL2);
 		else
 			zcr_el2 = vcpu_sve_max_vq(vcpu) - 1;
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index f162b0df5cae..ac84710fa14e 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -1050,7 +1050,7 @@ static bool __vgic_v3_check_trap_forwarding(struct kvm_vcpu *vcpu,
 {
 	u64 ich_hcr;
 
-	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
+	if (!is_nested_ctxt(vcpu))
 		return false;
 
 	ich_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index d22a8ad7bcc5..a1b40bf703f6 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -111,7 +111,7 @@ bool vgic_state_is_nested(struct kvm_vcpu *vcpu)
 {
 	u64 xmo;
 
-	if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
+	if (is_nested_ctxt(vcpu)) {
 		xmo = __vcpu_sys_reg(vcpu, HCR_EL2) & (HCR_IMO | HCR_FMO);
 		WARN_ONCE(xmo && xmo != (HCR_IMO | HCR_FMO),
 			  "Separate virtual IRQ/FIQ settings not supported\n");
-- 
2.39.5

