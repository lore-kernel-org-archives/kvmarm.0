Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0168A19ABD1
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 10:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732099997; cv=none; b=sfBFCubgaIU2+SXIKm5C1/MABhw5LrEW4XeKVZAt84A6ZWoY0ok8kkl1O32XwJwRkghbv2D++esm5/YNqm8A4qO+0Qgc2Nev3fPBZVn1IhtongoeqLNAA6SorK7hyXRXPSt6/DWWFOKH7g9g60oo/9HtkIDDPD8JRvw+wO+VV7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732099997; c=relaxed/simple;
	bh=FuKnsmC9T/x9jaWfhDr+0SmpUnMx1UC4iyF4t2MUaYA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LuBt9YjAfPgfgb3R3V+hR07MglqsUtm1FG93n5L8/8OErr5DqjDpguaFb8xd9DSt/0HVReVTDUe7Ha8LFBSLGXt+cxBI+MlhyePHKOlGzK46JVQMhe15kaodXfUsK9jv/om9sc5yjHbMBeXdNWrhW48lCukUBc3wx91JcK0d8K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I+o373R7; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I+o373R7"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4316655b2f1so35368495e9.0
        for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 02:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732099993; x=1732704793; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iWaJT4Zn84qKXgJN50ZtuLkN8oA9x5zTx7aDPyIrkU8=;
        b=I+o373R7pRw/uK0PAibBl+IAo5dHwiu1IA73Uht5i0FCvB66mwDldlJoAMUcyC5Yfa
         B2ZT39Vdb3c/u+PHXEgwsELvzRQgKXbFiZ442xDiNDFtdFKBMOttmVAuOqEDlXGSF8y7
         U7FPys2b6TTCAnH1RE5C42jdAouU0EVfkrKVxaEHyalXF9VDeElUDAFcqfyaJNxUAh+n
         7F0ox4vJfJ5jD1iU/xdV3sYmtDr917P6pIhgFoDqs906vxQOYq9xuSof8X/gCZqWhgRi
         Jjd82TGzbHFDAIakmfCecqePKXyGUr/uTpZ+QyyhX5wCuP94tvImjU+93A/sHsWwhIoM
         Oxxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732099993; x=1732704793;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iWaJT4Zn84qKXgJN50ZtuLkN8oA9x5zTx7aDPyIrkU8=;
        b=v3jo1Svdik7jtBZbBsRK1XYIlMEw5KMTtFbMFUBl0HqHFEGZgvtxD4tFFDE5sVnbed
         0WbCI7De5SQmDt+3QDUFxSVkMORWyVMqlQNvfID8BO7tqO+GR5QvJt79xf/MIaIXdevD
         +fTasz8X8I1lPdjLRWGzS2CC2wBU2AbcGYoLx3HT0TsXh4FLLV4EWLD31/OMNoypESvo
         lKbUFiwFz5skSb0oWqDkZ61r0jm09FMcP+M35J5DxxpLdeg3V1lYhPzxT1cZx4m74QXP
         4eoQjaYWwT+yrGRXl1HVHhQhxGr5abpFENsNvxHJ84QKnGuvIWK9B9Moq+MQh7l6JIDO
         FOhg==
X-Gm-Message-State: AOJu0YzF16J5//LyxCsl9M0rFomPqJnSgk4LEmt10ngGUBn4gWK9H/OL
	SfRzxWm3OERMW1yKPu+OLvpUIiUBbowG6Ta8pQz16ohSaYrOYVknXd/Jbl6f4DCzJ68wrbYokeJ
	iiSPFsBki4ByTjDSIKtQM+T6ulqyy98BTnKOlQtkoI0HbdguUHyehKYh+zToKK2fWSNVqSk1bcv
	HRZbrLLzTC/EFXmVMhqnhCSXTPONE=
X-Google-Smtp-Source: AGHT+IH3ZH8A464HT9kKlvqTsk7gt1rWRvkUtTkIvR4qGFh0oqSL92fQSxBTOOotayPgKRwGpp2nrtGztA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:f94b:0:b0:382:3787:1a12 with SMTP id
 ffacd0b85a97d-38254b188d2mr557f8f.7.1732099992972; Wed, 20 Nov 2024 02:53:12
 -0800 (PST)
Date: Wed, 20 Nov 2024 10:52:49 +0000
In-Reply-To: <20241120105254.2842020-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241120105254.2842020-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241120105254.2842020-8-tabba@google.com>
Subject: [PATCH v1 07/12] KVM: arm64: Rework specifying restricted features
 for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

The existing code didn't properly distinguish between signed and
unsigned features, and was difficult to read and to maintain.
Rework it using the same method used in other parts of KVM when
handling vcpu features.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h |   1 -
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 356 +++++++++---------
 2 files changed, 186 insertions(+), 171 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
index 69e26d1a0ebe..37a6d2434e47 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
@@ -198,7 +198,6 @@
 	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3), ID_AA64ISAR2_EL1_APA3_PAuth) \
 	)
 
-u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
 bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
 bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
 void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index cc6a57455b20..764d6d700598 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -28,221 +28,237 @@ u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
 u64 id_aa64smfr0_el1_sys_val;
 
-/*
- * Inject an unknown/undefined exception to an AArch64 guest while most of its
- * sysregs are live.
- */
-static void inject_undef64(struct kvm_vcpu *vcpu)
-{
-	u64 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
-
-	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
-	*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
-
-	kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
-
-	__kvm_adjust_pc(vcpu);
-
-	write_sysreg_el1(esr, SYS_ESR);
-	write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
-	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
-	write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
-}
+struct pvm_feature {
+	int shift;
+	int width;
+	u64 mask;
+	u64 max_supported;
+	bool is_signed;
+	bool (*vcpu_supported)(const struct kvm_vcpu *vcpu);
+};
 
-/*
- * Returns the restricted features values of the feature register based on the
- * limitations in restrict_fields.
- * A feature id field value of 0b0000 does not impose any restrictions.
- * Note: Use only for unsigned feature field values.
- */
-static u64 get_restricted_features_unsigned(u64 sys_reg_val,
-					    u64 restrict_fields)
-{
-	u64 value = 0UL;
-	u64 mask = GENMASK_ULL(ARM64_FEATURE_FIELD_BITS - 1, 0);
-
-	/*
-	 * According to the Arm Architecture Reference Manual, feature fields
-	 * use increasing values to indicate increases in functionality.
-	 * Iterate over the restricted feature fields and calculate the minimum
-	 * unsigned value between the one supported by the system, and what the
-	 * value is being restricted to.
-	 */
-	while (sys_reg_val && restrict_fields) {
-		value |= min(sys_reg_val & mask, restrict_fields & mask);
-		sys_reg_val &= ~mask;
-		restrict_fields &= ~mask;
-		mask <<= ARM64_FEATURE_FIELD_BITS;
+#define __MAX_FEAT_FUNC(id, fld, max, func, sign)				\
+	{									\
+		.shift = id##_##fld##_SHIFT,					\
+		.width = id##_##fld##_WIDTH,					\
+		.mask = id##_##fld##_MASK,					\
+		.max_supported = id##_##fld##_##max,				\
+		.is_signed = sign,						\
+		.vcpu_supported = func,						\
 	}
 
-	return value;
-}
-
-/*
- * Functions that return the value of feature id registers for protected VMs
- * based on allowed features, system features, and KVM support.
- */
-
-static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
-{
-	u64 set_mask = 0;
-	u64 allow_mask = PVM_ID_AA64PFR0_ALLOW;
-
-	set_mask |= get_restricted_features_unsigned(id_aa64pfr0_el1_sys_val,
-		PVM_ID_AA64PFR0_ALLOW);
-
-	return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
-}
-
-static u64 get_pvm_id_aa64pfr1(const struct kvm_vcpu *vcpu)
-{
-	const struct kvm *kvm = (const struct kvm *)kern_hyp_va(vcpu->kvm);
-	u64 allow_mask = PVM_ID_AA64PFR1_ALLOW;
-
-	if (!kvm_has_mte(kvm))
-		allow_mask &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE);
+#define MAX_FEAT_FUNC(id, fld, max, func)					\
+	__MAX_FEAT_FUNC(id, fld, max, func, id##_##fld##_SIGNED)
 
-	return id_aa64pfr1_el1_sys_val & allow_mask;
-}
+#define MAX_FEAT(id, fld, max)							\
+	MAX_FEAT_FUNC(id, fld, max, NULL)
 
-static u64 get_pvm_id_aa64zfr0(const struct kvm_vcpu *vcpu)
-{
-	/*
-	 * No support for Scalable Vectors, therefore, hyp has no sanitized
-	 * copy of the feature id register.
-	 */
-	BUILD_BUG_ON(PVM_ID_AA64ZFR0_ALLOW != 0ULL);
-	return 0;
-}
+#define MAX_FEAT_ENUM(id, fld, max)						\
+	__MAX_FEAT_FUNC(id, fld, max, NULL, false)
 
-static u64 get_pvm_id_aa64dfr0(const struct kvm_vcpu *vcpu)
-{
-	/*
-	 * No support for debug, including breakpoints, and watchpoints,
-	 * therefore, pKVM has no sanitized copy of the feature id register.
-	 */
-	BUILD_BUG_ON(PVM_ID_AA64DFR0_ALLOW != 0ULL);
-	return 0;
-}
+#define FEAT_END {	.shift = -1,	}
 
-static u64 get_pvm_id_aa64dfr1(const struct kvm_vcpu *vcpu)
+static bool _vcpu_has_ptrauth(const struct kvm_vcpu *vcpu)
 {
-	/*
-	 * No support for debug, therefore, hyp has no sanitized copy of the
-	 * feature id register.
-	 */
-	BUILD_BUG_ON(PVM_ID_AA64DFR1_ALLOW != 0ULL);
-	return 0;
+	return vcpu_has_ptrauth(vcpu);
 }
 
-static u64 get_pvm_id_aa64afr0(const struct kvm_vcpu *vcpu)
+static bool _vcpu_has_sve(const struct kvm_vcpu *vcpu)
 {
-	/*
-	 * No support for implementation defined features, therefore, hyp has no
-	 * sanitized copy of the feature id register.
-	 */
-	BUILD_BUG_ON(PVM_ID_AA64AFR0_ALLOW != 0ULL);
-	return 0;
+	return vcpu_has_sve(vcpu);
 }
 
-static u64 get_pvm_id_aa64afr1(const struct kvm_vcpu *vcpu)
-{
-	/*
-	 * No support for implementation defined features, therefore, hyp has no
-	 * sanitized copy of the feature id register.
-	 */
-	BUILD_BUG_ON(PVM_ID_AA64AFR1_ALLOW != 0ULL);
-	return 0;
-}
-
-static u64 get_pvm_id_aa64isar0(const struct kvm_vcpu *vcpu)
-{
-	return id_aa64isar0_el1_sys_val & PVM_ID_AA64ISAR0_ALLOW;
-}
+/*
+ * Definitions for features to be allowed or restricted for protected guests.
+ *
+ * Each field in the masks represents the highest supported value for the
+ * feature. If a feature field is not present, it is not supported. Moreover,
+ * these are used to generate the guest's view of the feature registers.
+ *
+ * The approach for protected VMs is to at least support features that are:
+ * - Needed by common Linux distributions (e.g., floating point)
+ * - Trivial to support, e.g., supporting the feature does not introduce or
+ * require tracking of additional state in KVM
+ * - Cannot be trapped or prevent the guest from using anyway
+ */
 
-static u64 get_pvm_id_aa64isar1(const struct kvm_vcpu *vcpu)
-{
-	u64 allow_mask = PVM_ID_AA64ISAR1_ALLOW;
+static const struct pvm_feature pvmid_aa64pfr0[] = {
+	MAX_FEAT(ID_AA64PFR0_EL1, EL0, IMP),
+	MAX_FEAT(ID_AA64PFR0_EL1, EL1, IMP),
+	MAX_FEAT(ID_AA64PFR0_EL1, EL2, IMP),
+	MAX_FEAT(ID_AA64PFR0_EL1, EL3, IMP),
+	MAX_FEAT(ID_AA64PFR0_EL1, FP, FP16),
+	MAX_FEAT(ID_AA64PFR0_EL1, AdvSIMD, FP16),
+	MAX_FEAT(ID_AA64PFR0_EL1, GIC, IMP),
+	MAX_FEAT_FUNC(ID_AA64PFR0_EL1, SVE, IMP, _vcpu_has_sve),
+	MAX_FEAT(ID_AA64PFR0_EL1, RAS, IMP),
+	MAX_FEAT(ID_AA64PFR0_EL1, DIT, IMP),
+	MAX_FEAT(ID_AA64PFR0_EL1, CSV2, IMP),
+	MAX_FEAT(ID_AA64PFR0_EL1, CSV3, IMP),
+	FEAT_END
+};
 
-	if (!vcpu_has_ptrauth(vcpu))
-		allow_mask &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_APA) |
-				ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_API) |
-				ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPA) |
-				ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPI));
+static const struct pvm_feature pvmid_aa64pfr1[] = {
+	MAX_FEAT(ID_AA64PFR1_EL1, BT, IMP),
+	MAX_FEAT(ID_AA64PFR1_EL1, SSBS, SSBS2),
+	MAX_FEAT_ENUM(ID_AA64PFR1_EL1, MTE_frac, NI),
+	FEAT_END
+};
 
-	return id_aa64isar1_el1_sys_val & allow_mask;
-}
+static const struct pvm_feature pvmid_aa64mmfr0[] = {
+	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, PARANGE, 40),
+	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, ASIDBITS, 16),
+	MAX_FEAT(ID_AA64MMFR0_EL1, BIGEND, IMP),
+	MAX_FEAT(ID_AA64MMFR0_EL1, SNSMEM, IMP),
+	MAX_FEAT(ID_AA64MMFR0_EL1, BIGENDEL0, IMP),
+	MAX_FEAT(ID_AA64MMFR0_EL1, EXS, IMP),
+	FEAT_END
+};
 
-static u64 get_pvm_id_aa64isar2(const struct kvm_vcpu *vcpu)
-{
-	u64 allow_mask = PVM_ID_AA64ISAR2_ALLOW;
+static const struct pvm_feature pvmid_aa64mmfr1[] = {
+	MAX_FEAT(ID_AA64MMFR1_EL1, HAFDBS, DBM),
+	MAX_FEAT_ENUM(ID_AA64MMFR1_EL1, VMIDBits, 16),
+	MAX_FEAT(ID_AA64MMFR1_EL1, HPDS, HPDS2),
+	MAX_FEAT(ID_AA64MMFR1_EL1, PAN, PAN3),
+	MAX_FEAT(ID_AA64MMFR1_EL1, SpecSEI, IMP),
+	MAX_FEAT(ID_AA64MMFR1_EL1, ETS, IMP),
+	MAX_FEAT(ID_AA64MMFR1_EL1, CMOW, IMP),
+	FEAT_END
+};
 
-	if (!vcpu_has_ptrauth(vcpu))
-		allow_mask &= ~(ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3) |
-				ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_GPA3));
+static const struct pvm_feature pvmid_aa64mmfr2[] = {
+	MAX_FEAT(ID_AA64MMFR2_EL1, CnP, IMP),
+	MAX_FEAT(ID_AA64MMFR2_EL1, UAO, IMP),
+	MAX_FEAT(ID_AA64MMFR2_EL1, IESB, IMP),
+	MAX_FEAT(ID_AA64MMFR2_EL1, AT, IMP),
+	MAX_FEAT_ENUM(ID_AA64MMFR2_EL1, IDS, 0x18),
+	MAX_FEAT(ID_AA64MMFR2_EL1, TTL, IMP),
+	MAX_FEAT(ID_AA64MMFR2_EL1, BBM, 2),
+	MAX_FEAT(ID_AA64MMFR2_EL1, E0PD, IMP),
+	FEAT_END
+};
 
-	return id_aa64isar2_el1_sys_val & allow_mask;
-}
+static const struct pvm_feature pvmid_aa64isar1[] = {
+	MAX_FEAT(ID_AA64ISAR1_EL1, DPB, DPB2),
+	MAX_FEAT_FUNC(ID_AA64ISAR1_EL1, APA, PAuth, _vcpu_has_ptrauth),
+	MAX_FEAT_FUNC(ID_AA64ISAR1_EL1, API, PAuth, _vcpu_has_ptrauth),
+	MAX_FEAT(ID_AA64ISAR1_EL1, JSCVT, IMP),
+	MAX_FEAT(ID_AA64ISAR1_EL1, FCMA, IMP),
+	MAX_FEAT(ID_AA64ISAR1_EL1, LRCPC, LRCPC3),
+	MAX_FEAT(ID_AA64ISAR1_EL1, GPA, IMP),
+	MAX_FEAT(ID_AA64ISAR1_EL1, GPI, IMP),
+	MAX_FEAT(ID_AA64ISAR1_EL1, FRINTTS, IMP),
+	MAX_FEAT(ID_AA64ISAR1_EL1, SB, IMP),
+	MAX_FEAT(ID_AA64ISAR1_EL1, SPECRES, COSP_RCTX),
+	MAX_FEAT(ID_AA64ISAR1_EL1, BF16, EBF16),
+	MAX_FEAT(ID_AA64ISAR1_EL1, DGH, IMP),
+	MAX_FEAT(ID_AA64ISAR1_EL1, I8MM, IMP),
+	FEAT_END
+};
 
-static u64 get_pvm_id_aa64mmfr0(const struct kvm_vcpu *vcpu)
-{
-	u64 set_mask;
+static const struct pvm_feature pvmid_aa64isar2[] = {
+	MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, GPA3, IMP, _vcpu_has_ptrauth),
+	MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, APA3, PAuth, _vcpu_has_ptrauth),
+	MAX_FEAT(ID_AA64ISAR2_EL1, ATS1A, IMP),
+	FEAT_END
+};
 
-	set_mask = get_restricted_features_unsigned(id_aa64mmfr0_el1_sys_val,
-		PVM_ID_AA64MMFR0_ALLOW);
+/*
+ * None of the features in ID_AA64DFR0_EL1 nor ID_AA64MMFR4_EL1 are supported.
+ * However, both have Not-Implemented values that are non-zero. Define them
+ * so they can be used when getting the value of these registers.
+ */
+#define ID_AA64DFR0_EL1_NONZERO_NI					\
+(									\
+	SYS_FIELD_PREP_ENUM(ID_AA64DFR0_EL1, DoubleLock, NI)	|	\
+	SYS_FIELD_PREP_ENUM(ID_AA64DFR0_EL1, MTPMU, NI)			\
+)
 
-	return (id_aa64mmfr0_el1_sys_val & PVM_ID_AA64MMFR0_ALLOW) | set_mask;
-}
+#define ID_AA64MMFR4_EL1_NONZERO_NI					\
+	SYS_FIELD_PREP_ENUM(ID_AA64MMFR4_EL1, E2H0, NI)
 
-static u64 get_pvm_id_aa64mmfr1(const struct kvm_vcpu *vcpu)
+/*
+ * Returns the value of the feature registers based on the system register
+ * value, the vcpu support for the revelant features, and the additional
+ * restrictions for protected VMs.
+ */
+static u64 get_restricted_features(const struct kvm_vcpu *vcpu,
+				   u64 sys_reg_val,
+				   const struct pvm_feature restrictions[])
 {
-	return id_aa64mmfr1_el1_sys_val & PVM_ID_AA64MMFR1_ALLOW;
-}
+	u64 val = 0UL;
+	int i;
+
+	for (i = 0; restrictions[i].shift != -1; i++) {
+		bool (*vcpu_supported)(const struct kvm_vcpu *) = restrictions[i].vcpu_supported;
+		bool is_signed = restrictions[i].is_signed;
+		int shift = restrictions[i].shift;
+		int width = restrictions[i].width;
+		u64 min_signed = (1UL << width) - 1UL;
+		u64 sign_bit = 1UL << (width - 1);
+		u64 mask = restrictions[i].mask;
+		u64 sys_val = (sys_reg_val & mask) >> shift;
+		u64 pvm_max = restrictions[i].max_supported;
+
+		if (vcpu_supported && !vcpu_supported(vcpu))
+			val |= (is_signed ? min_signed : 0) << shift;
+		else if (is_signed && (sys_val >= sign_bit || pvm_max >= sign_bit))
+			val |= max(sys_val, pvm_max) << shift;
+		else
+			val |= min(sys_val, pvm_max) << shift;
+	}
 
-static u64 get_pvm_id_aa64mmfr2(const struct kvm_vcpu *vcpu)
-{
-	return id_aa64mmfr2_el1_sys_val & PVM_ID_AA64MMFR2_ALLOW;
+	return val;
 }
 
 static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 {
 	switch (id) {
 	case SYS_ID_AA64PFR0_EL1:
-		return get_pvm_id_aa64pfr0(vcpu);
+		return get_restricted_features(vcpu, id_aa64pfr0_el1_sys_val, pvmid_aa64pfr0);
 	case SYS_ID_AA64PFR1_EL1:
-		return get_pvm_id_aa64pfr1(vcpu);
-	case SYS_ID_AA64ZFR0_EL1:
-		return get_pvm_id_aa64zfr0(vcpu);
-	case SYS_ID_AA64DFR0_EL1:
-		return get_pvm_id_aa64dfr0(vcpu);
-	case SYS_ID_AA64DFR1_EL1:
-		return get_pvm_id_aa64dfr1(vcpu);
-	case SYS_ID_AA64AFR0_EL1:
-		return get_pvm_id_aa64afr0(vcpu);
-	case SYS_ID_AA64AFR1_EL1:
-		return get_pvm_id_aa64afr1(vcpu);
+		return get_restricted_features(vcpu, id_aa64pfr1_el1_sys_val, pvmid_aa64pfr1);
 	case SYS_ID_AA64ISAR0_EL1:
-		return get_pvm_id_aa64isar0(vcpu);
+		return id_aa64isar0_el1_sys_val;
 	case SYS_ID_AA64ISAR1_EL1:
-		return get_pvm_id_aa64isar1(vcpu);
+		return get_restricted_features(vcpu, id_aa64isar1_el1_sys_val, pvmid_aa64isar1);
 	case SYS_ID_AA64ISAR2_EL1:
-		return get_pvm_id_aa64isar2(vcpu);
+		return get_restricted_features(vcpu, id_aa64isar2_el1_sys_val, pvmid_aa64isar2);
 	case SYS_ID_AA64MMFR0_EL1:
-		return get_pvm_id_aa64mmfr0(vcpu);
+		return get_restricted_features(vcpu, id_aa64mmfr0_el1_sys_val, pvmid_aa64mmfr0);
 	case SYS_ID_AA64MMFR1_EL1:
-		return get_pvm_id_aa64mmfr1(vcpu);
+		return get_restricted_features(vcpu, id_aa64mmfr1_el1_sys_val, pvmid_aa64mmfr1);
 	case SYS_ID_AA64MMFR2_EL1:
-		return get_pvm_id_aa64mmfr2(vcpu);
+		return get_restricted_features(vcpu, id_aa64mmfr2_el1_sys_val, pvmid_aa64mmfr2);
+	case SYS_ID_AA64DFR0_EL1:
+		return ID_AA64DFR0_EL1_NONZERO_NI;
+	case SYS_ID_AA64MMFR4_EL1:
+		return ID_AA64MMFR4_EL1_NONZERO_NI;
 	default:
 		/* Unhandled ID register, RAZ */
 		return 0;
 	}
 }
 
-/* Read a sanitized cpufeature ID register by its encoding */
-u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
+/*
+ * Inject an unknown/undefined exception to an AArch64 guest while most of its
+ * sysregs are live.
+ */
+static void inject_undef64(struct kvm_vcpu *vcpu)
 {
-	return pvm_calc_id_reg(vcpu, id);
+	u64 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
+
+	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
+	*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
+
+	kvm_pend_exception(vcpu, EXCEPT_AA64_EL1_SYNC);
+
+	__kvm_adjust_pc(vcpu);
+
+	write_sysreg_el1(esr, SYS_ESR);
+	write_sysreg_el1(read_sysreg_el2(SYS_ELR), SYS_ELR);
+	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
+	write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
 }
 
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
-- 
2.47.0.338.g60cca15819-goog

