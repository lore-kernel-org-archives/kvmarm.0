Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A6332DE1ED
	for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 13:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167460; cv=none; b=G8NnYZ+1cDZKOsj+mJntbo8a+gyxaOsecVCdhZAOGLYfuNAIl8eC9SgKXubp+ysOCNA/cncNr0b5Fz8YGA0SVy1Vqtopr/ebAAJZaFUEfvdsugq0Sr0Xy1zrE72LHgdu/5aNnGglCodmhGAZJZxZvK3Ud1KzB/SaU5vl/h+RWyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167460; c=relaxed/simple;
	bh=zRVf7PgWHAOip8ZH5jegI/z2rr7m6mztJlkIU+lNzhk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DawvTQxaWaUp7LvOpr4UIVyY+khgFNGbJOJQgYXY09p71FxPLWC52/xvyZLvtFjx8UNgvRSH5SmxulKjqzQS0bdipgoGa61LFVI5zu1xsjFpEN5GQnyvIoZXlxlx5uVc+8b6jHuDQEKXhYf0nYI4ByKaXa8b7DHJhfk/uGuFngU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C9D9150C;
	Tue, 17 Jun 2025 06:37:16 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A33363F673;
	Tue, 17 Jun 2025 06:37:35 -0700 (PDT)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	kvmarm@lists.linux.dev,
	mark.rutland@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	stable@vger.kernel.org,
	tabba@google.com,
	will@kernel.org
Subject: [PATCH 3/7] KVM: arm64: Reorganise CPTR trap manipulation
Date: Tue, 17 Jun 2025 14:37:14 +0100
Message-Id: <20250617133718.4014181-4-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250617133718.4014181-1-mark.rutland@arm.com>
References: <20250617133718.4014181-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The NVHE/HVHE and VHE modes have separate implementations of
__activate_cptr_traps() and __deactivate_cptr_traps() in their
respective switch.c files. There's some duplication of logic, and it's
not currently possible to reuse this logic elsewhere.

Move the logic into the common switch.h header so that it can be reused,
and de-duplicate the common logic.

This rework changes the way SVE traps are deactivated in VHE mode,
aligning it with NVHE/HVHE modes:

* Before this patch, VHE's __deactivate_cptr_traps() would
  unconditionally enable SVE for host EL2 (but not EL0), regardless of
  whether the ARM64_SVE cpucap was set.

* After this patch, VHE's __deactivate_cptr_traps() will take the
  ARM64_SVE cpucap into account. When ARM64_SVE is not set, SVE will be
  trapped from EL2 and below.

The old and new behaviour are both benign:

* When ARM64_SVE is not set, the host will not touch SVE state, and will
  not reconfigure SVE traps. Host EL0 access to SVE will be trapped as
  expected.

* When ARM64_SVE is set, the host will configure EL0 SVE traps before
  returning to EL0 as part of reloading the EL0 FPSIMD/SVE/SME state.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 130 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        |  59 -----------
 arch/arm64/kvm/hyp/vhe/switch.c         |  81 ---------------
 3 files changed, 130 insertions(+), 140 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index aa5b561b92182..9b025276fcc8e 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -65,6 +65,136 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 	}
 }
 
+static inline void __activate_cptr_traps_nvhe(struct kvm_vcpu *vcpu)
+{
+	u64 val = CPTR_NVHE_EL2_RES1 | CPTR_EL2_TAM | CPTR_EL2_TTA;
+
+	/*
+	 * Always trap SME since it's not supported in KVM.
+	 * TSM is RES1 if SME isn't implemented.
+	 */
+	val |= CPTR_EL2_TSM;
+
+	if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs())
+		val |= CPTR_EL2_TZ;
+
+	if (!guest_owns_fp_regs())
+		val |= CPTR_EL2_TFP;
+
+	write_sysreg(val, cptr_el2);
+}
+
+static inline void __activate_cptr_traps_vhe(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * With VHE (HCR.E2H == 1), accesses to CPACR_EL1 are routed to
+	 * CPTR_EL2. In general, CPACR_EL1 has the same layout as CPTR_EL2,
+	 * except for some missing controls, such as TAM.
+	 * In this case, CPTR_EL2.TAM has the same position with or without
+	 * VHE (HCR.E2H == 1) which allows us to use here the CPTR_EL2.TAM
+	 * shift value for trapping the AMU accesses.
+	 */
+	u64 val = CPTR_EL2_TAM | CPACR_EL1_TTA;
+	u64 cptr;
+
+	if (guest_owns_fp_regs()) {
+		val |= CPACR_EL1_FPEN;
+		if (vcpu_has_sve(vcpu))
+			val |= CPACR_EL1_ZEN;
+	}
+
+	if (!vcpu_has_nv(vcpu))
+		goto write;
+
+	/*
+	 * The architecture is a bit crap (what a surprise): an EL2 guest
+	 * writing to CPTR_EL2 via CPACR_EL1 can't set any of TCPAC or TTA,
+	 * as they are RES0 in the guest's view. To work around it, trap the
+	 * sucker using the very same bit it can't set...
+	 */
+	if (vcpu_el2_e2h_is_set(vcpu) && is_hyp_ctxt(vcpu))
+		val |= CPTR_EL2_TCPAC;
+
+	/*
+	 * Layer the guest hypervisor's trap configuration on top of our own if
+	 * we're in a nested context.
+	 */
+	if (is_hyp_ctxt(vcpu))
+		goto write;
+
+	cptr = vcpu_sanitised_cptr_el2(vcpu);
+
+	/*
+	 * Pay attention, there's some interesting detail here.
+	 *
+	 * The CPTR_EL2.xEN fields are 2 bits wide, although there are only two
+	 * meaningful trap states when HCR_EL2.TGE = 0 (running a nested guest):
+	 *
+	 *  - CPTR_EL2.xEN = x0, traps are enabled
+	 *  - CPTR_EL2.xEN = x1, traps are disabled
+	 *
+	 * In other words, bit[0] determines if guest accesses trap or not. In
+	 * the interest of simplicity, clear the entire field if the guest
+	 * hypervisor has traps enabled to dispel any illusion of something more
+	 * complicated taking place.
+	 */
+	if (!(SYS_FIELD_GET(CPACR_EL1, FPEN, cptr) & BIT(0)))
+		val &= ~CPACR_EL1_FPEN;
+	if (!(SYS_FIELD_GET(CPACR_EL1, ZEN, cptr) & BIT(0)))
+		val &= ~CPACR_EL1_ZEN;
+
+	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S2POE, IMP))
+		val |= cptr & CPACR_EL1_E0POE;
+
+	val |= cptr & CPTR_EL2_TCPAC;
+
+write:
+	write_sysreg(val, cpacr_el1);
+}
+
+static inline void __activate_cptr_traps(struct kvm_vcpu *vcpu)
+{
+	if (!guest_owns_fp_regs())
+		__activate_traps_fpsimd32(vcpu);
+
+	if (has_vhe() || has_hvhe())
+		__activate_cptr_traps_vhe(vcpu);
+	else
+		__activate_cptr_traps_nvhe(vcpu);
+}
+
+static inline void __deactivate_cptr_traps_nvhe(struct kvm_vcpu *vcpu)
+{
+	u64 val = CPTR_NVHE_EL2_RES1;
+
+	if (!cpus_have_final_cap(ARM64_SVE))
+		val |= CPTR_EL2_TZ;
+	if (!cpus_have_final_cap(ARM64_SME))
+		val |= CPTR_EL2_TSM;
+
+	write_sysreg(val, cptr_el2);
+}
+
+static inline void __deactivate_cptr_traps_vhe(struct kvm_vcpu *vcpu)
+{
+	u64 val = CPACR_EL1_FPEN;
+
+	if (cpus_have_final_cap(ARM64_SVE))
+		val |= CPACR_EL1_ZEN;
+	if (cpus_have_final_cap(ARM64_SME))
+		val |= CPACR_EL1_SMEN;
+
+	write_sysreg(val, cpacr_el1);
+}
+
+static inline void __deactivate_cptr_traps(struct kvm_vcpu *vcpu)
+{
+	if (has_vhe() || has_hvhe())
+		__deactivate_cptr_traps_vhe(vcpu);
+	else
+		__deactivate_cptr_traps_nvhe(vcpu);
+}
+
 #define reg_to_fgt_masks(reg)						\
 	({								\
 		struct fgt_masks *m;					\
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 73affe1333a49..0e752b515d0fd 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -47,65 +47,6 @@ struct fgt_masks hdfgwtr2_masks;
 
 extern void kvm_nvhe_prepare_backtrace(unsigned long fp, unsigned long pc);
 
-static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
-{
-	u64 val = CPTR_EL2_TAM;	/* Same bit irrespective of E2H */
-
-	if (!guest_owns_fp_regs())
-		__activate_traps_fpsimd32(vcpu);
-
-	if (has_hvhe()) {
-		val |= CPACR_EL1_TTA;
-
-		if (guest_owns_fp_regs()) {
-			val |= CPACR_EL1_FPEN;
-			if (vcpu_has_sve(vcpu))
-				val |= CPACR_EL1_ZEN;
-		}
-
-		write_sysreg(val, cpacr_el1);
-	} else {
-		val |= CPTR_EL2_TTA | CPTR_NVHE_EL2_RES1;
-
-		/*
-		 * Always trap SME since it's not supported in KVM.
-		 * TSM is RES1 if SME isn't implemented.
-		 */
-		val |= CPTR_EL2_TSM;
-
-		if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs())
-			val |= CPTR_EL2_TZ;
-
-		if (!guest_owns_fp_regs())
-			val |= CPTR_EL2_TFP;
-
-		write_sysreg(val, cptr_el2);
-	}
-}
-
-static void __deactivate_cptr_traps(struct kvm_vcpu *vcpu)
-{
-	if (has_hvhe()) {
-		u64 val = CPACR_EL1_FPEN;
-
-		if (cpus_have_final_cap(ARM64_SVE))
-			val |= CPACR_EL1_ZEN;
-		if (cpus_have_final_cap(ARM64_SME))
-			val |= CPACR_EL1_SMEN;
-
-		write_sysreg(val, cpacr_el1);
-	} else {
-		u64 val = CPTR_NVHE_EL2_RES1;
-
-		if (!cpus_have_final_cap(ARM64_SVE))
-			val |= CPTR_EL2_TZ;
-		if (!cpus_have_final_cap(ARM64_SME))
-			val |= CPTR_EL2_TSM;
-
-		write_sysreg(val, cptr_el2);
-	}
-}
-
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	___activate_traps(vcpu, vcpu->arch.hcr_el2);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 20df44b49ceb8..32b4814eb2b7a 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -90,87 +90,6 @@ static u64 __compute_hcr(struct kvm_vcpu *vcpu)
 	return hcr | (guest_hcr & ~NV_HCR_GUEST_EXCLUDE);
 }
 
-static void __activate_cptr_traps(struct kvm_vcpu *vcpu)
-{
-	u64 cptr;
-
-	/*
-	 * With VHE (HCR.E2H == 1), accesses to CPACR_EL1 are routed to
-	 * CPTR_EL2. In general, CPACR_EL1 has the same layout as CPTR_EL2,
-	 * except for some missing controls, such as TAM.
-	 * In this case, CPTR_EL2.TAM has the same position with or without
-	 * VHE (HCR.E2H == 1) which allows us to use here the CPTR_EL2.TAM
-	 * shift value for trapping the AMU accesses.
-	 */
-	u64 val = CPACR_EL1_TTA | CPTR_EL2_TAM;
-
-	if (guest_owns_fp_regs()) {
-		val |= CPACR_EL1_FPEN;
-		if (vcpu_has_sve(vcpu))
-			val |= CPACR_EL1_ZEN;
-	} else {
-		__activate_traps_fpsimd32(vcpu);
-	}
-
-	if (!vcpu_has_nv(vcpu))
-		goto write;
-
-	/*
-	 * The architecture is a bit crap (what a surprise): an EL2 guest
-	 * writing to CPTR_EL2 via CPACR_EL1 can't set any of TCPAC or TTA,
-	 * as they are RES0 in the guest's view. To work around it, trap the
-	 * sucker using the very same bit it can't set...
-	 */
-	if (vcpu_el2_e2h_is_set(vcpu) && is_hyp_ctxt(vcpu))
-		val |= CPTR_EL2_TCPAC;
-
-	/*
-	 * Layer the guest hypervisor's trap configuration on top of our own if
-	 * we're in a nested context.
-	 */
-	if (is_hyp_ctxt(vcpu))
-		goto write;
-
-	cptr = vcpu_sanitised_cptr_el2(vcpu);
-
-	/*
-	 * Pay attention, there's some interesting detail here.
-	 *
-	 * The CPTR_EL2.xEN fields are 2 bits wide, although there are only two
-	 * meaningful trap states when HCR_EL2.TGE = 0 (running a nested guest):
-	 *
-	 *  - CPTR_EL2.xEN = x0, traps are enabled
-	 *  - CPTR_EL2.xEN = x1, traps are disabled
-	 *
-	 * In other words, bit[0] determines if guest accesses trap or not. In
-	 * the interest of simplicity, clear the entire field if the guest
-	 * hypervisor has traps enabled to dispel any illusion of something more
-	 * complicated taking place.
-	 */
-	if (!(SYS_FIELD_GET(CPACR_EL1, FPEN, cptr) & BIT(0)))
-		val &= ~CPACR_EL1_FPEN;
-	if (!(SYS_FIELD_GET(CPACR_EL1, ZEN, cptr) & BIT(0)))
-		val &= ~CPACR_EL1_ZEN;
-
-	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S2POE, IMP))
-		val |= cptr & CPACR_EL1_E0POE;
-
-	val |= cptr & CPTR_EL2_TCPAC;
-
-write:
-	write_sysreg(val, cpacr_el1);
-}
-
-static void __deactivate_cptr_traps(struct kvm_vcpu *vcpu)
-{
-	u64 val = CPACR_EL1_FPEN | CPACR_EL1_ZEN_EL1EN;
-
-	if (cpus_have_final_cap(ARM64_SME))
-		val |= CPACR_EL1_SMEN_EL1EN;
-
-	write_sysreg(val, cpacr_el1);
-}
-
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
-- 
2.30.2

