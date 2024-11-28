Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2288E198A11
	for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 12:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732797335; cv=none; b=pnc9OdgE8xSsb1xaMBTW6ojGz2vfWQ4lQD2GFHMPA8n5d52eaUS3Ndm5W2JLT1cPD7Y1m/D1lwpIXeQ8yZCpp9Hf9QXUMClQIz8qWvizNqLpweNC/XLqfWK2pmAMqsLEH0c3TJxiTTH+yrQTaDuiQWCe8ZQ/TJY8JyvmAxNfK0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732797335; c=relaxed/simple;
	bh=Ob51WVrjljNsNafAaHS7BRBE/KdLxXmm7C7Nu+Wg1D4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hQCybgfj20iUlmDXf1AiXCxFGtBMvP1z1ucNtQ5OctnTBxae5ihFo3hsr085zXvNQJNPLTYA9zkOl2RIlkIW08py4Rr+hTk/tIfK/CTmz7LAQ+rw1SzZLiyZ0rhhitRA3txbSHaSYnAChAmctYiS0hzU+aO16op0eW5OpcGbULU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xgk3YDIm; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xgk3YDIm"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-434a90fecfeso6154075e9.1
        for <kvmarm@lists.linux.dev>; Thu, 28 Nov 2024 04:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732797331; x=1733402131; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tlrkrFFDSGutm1nLVZfaQz5ciGITXu/fnNsjmBq5kzE=;
        b=Xgk3YDImGFEczUjHjV/a/hFvSNRgKhPJPJ/lZfwSnaYF1IGUTyd4HvwsceGhy6QGXh
         DO14fBLGpkRJ5Ay3QvamBNrddkC/Wk1WHeyKZegufVkrSnfdjaSA79sc1lX4PXPeTSO6
         2DgJ8OKaJSdU4d264NznOxo3KL47NAIjCTS80dYz5HDnkDHlRBcKCfBKjNSO56nq0vmp
         y5d0Z3rDcfYG94bN7teYcx1/4Ji6xhWBttdtfn3hB/BKf7k7AjguB0AcbBPSC6Mcr8lg
         uoXpXStsSoViJVOCJHG/qe8+7MRbEksJ2eTdrPTHYkAzWR3ZbYplDMb3T/zBugtu8ZQe
         9YRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732797331; x=1733402131;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tlrkrFFDSGutm1nLVZfaQz5ciGITXu/fnNsjmBq5kzE=;
        b=uAV60ki1LY/KDkQV6s32Yl9ep7IMoFXLOHkaEUAzbNGW8WSWTvkKo8bMjx/X1haffg
         atgYakGMfH1L+BBxUqTvbse1+s3IPFI9pGKo+W7rtJyRnimRuhU2tyZYZilhCwjlCRk9
         9OO02pg1TTPM2t9fWrmoDyksiWJMZsYxqkhdKewbXv/hwbgsf5Op5MclT12optkrJ5IH
         7U86om3cO8YVlJ61XvWbwHO2lRtNX9p1536arlEnBRhJGOyJglxBZqpTV+e2GDIUfxiC
         8htXjtcgaYV8w3LT4UckMWqtMeWcReqsMKT6j6Qh8ooqHtLAeltk/vbsCtVcYTOepvLO
         YYwA==
X-Gm-Message-State: AOJu0YxOm0WjyEOLNNjO+ihTGsOZ0/OdUxewpgiShcwNFaYRMmixdhaL
	PHTq7gygNjG1KCvq6F/7b7Nmn+iJSE3xnfwGiNaVEvqJICzkkC6OsPO3GzDT6QA+NrB5IH77QfQ
	4gsCaCSjwpu2uUJdOVp9GGum5szV8Vek7nmsTysOYZE+xlgXtlru1ImoK+lqWtJWozm63U7SWHB
	d+PcJ0k5g5ixlMPqvSy55nopES8hQ=
X-Google-Smtp-Source: AGHT+IHmyqOlOUZGFN5LfCwFrj4ZXzup6eiTxkRGJ25m097OsdTBaF8xQevSC9GK1rygQ+UFnjq7fnuaTA==
X-Received: from wmbhi24.prod.google.com ([2002:a05:600c:5358:b0:434:a2c3:d51b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3ba6:b0:434:9e63:faff
 with SMTP id 5b1f17b1804b1-434a9dbc41bmr65124405e9.2.1732797331465; Thu, 28
 Nov 2024 04:35:31 -0800 (PST)
Date: Thu, 28 Nov 2024 12:35:07 +0000
In-Reply-To: <20241128123515.1709777-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241128123515.1709777-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128123515.1709777-8-tabba@google.com>
Subject: [PATCH v3 07/15] KVM: arm64: Rework specifying restricted features
 for protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The existing code didn't properly distinguish between signed and
unsigned features, and was difficult to read and to maintain.
Rework it using the same method used in other parts of KVM when
handling vcpu features.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h             |   1 +
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h |   1 -
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 357 +++++++++---------
 3 files changed, 189 insertions(+), 170 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f333b189fb43..230b0638f0c2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1422,6 +1422,7 @@ static inline bool __vcpu_has_feature(const struct kvm_arch *ka, int feature)
 	return test_bit(feature, ka->vcpu_features);
 }
 
+#define kvm_vcpu_has_feature(k, f)	__vcpu_has_feature(&(k)->arch, (f))
 #define vcpu_has_feature(v, f)	__vcpu_has_feature(&(v)->kvm->arch, (f))
 
 #define kvm_vcpu_initialized(v) vcpu_get_flag(vcpu, VCPU_INITIALIZED)
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
index 39b678d2c120..b6140590b569 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -28,221 +28,240 @@ u64 id_aa64mmfr1_el1_sys_val;
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
-
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
+struct pvm_ftr_bits {
+	bool		sign;
+	u8		shift;
+	u8		width;
+	u8		max_val;
+	bool (*vm_supported)(const struct kvm *kvm);
+};
 
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
+#define __MAX_FEAT_FUNC(id, fld, max, func, sgn)				\
+	{									\
+		.sign = sgn,							\
+		.shift = id##_##fld##_SHIFT,					\
+		.width = id##_##fld##_WIDTH,					\
+		.max_val = id##_##fld##_##max,					\
+		.vm_supported = func,						\
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
+#define MAX_FEAT_FUNC(id, fld, max, func)					\
+	__MAX_FEAT_FUNC(id, fld, max, func, id##_##fld##_SIGNED)
 
-	return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
-}
-
-static u64 get_pvm_id_aa64pfr1(const struct kvm_vcpu *vcpu)
-{
-	const struct kvm *kvm = (const struct kvm *)kern_hyp_va(vcpu->kvm);
-	u64 allow_mask = PVM_ID_AA64PFR1_ALLOW;
+#define MAX_FEAT(id, fld, max)							\
+	MAX_FEAT_FUNC(id, fld, max, NULL)
 
-	if (!kvm_has_mte(kvm))
-		allow_mask &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE);
+#define MAX_FEAT_ENUM(id, fld, max)						\
+	__MAX_FEAT_FUNC(id, fld, max, NULL, false)
 
-	return id_aa64pfr1_el1_sys_val & allow_mask;
-}
+#define FEAT_END {	.width = 0,	}
 
-static u64 get_pvm_id_aa64zfr0(const struct kvm_vcpu *vcpu)
+static bool vm_has_ptrauth(const struct kvm *kvm)
 {
-	/*
-	 * No support for Scalable Vectors, therefore, hyp has no sanitized
-	 * copy of the feature id register.
-	 */
-	BUILD_BUG_ON(PVM_ID_AA64ZFR0_ALLOW != 0ULL);
-	return 0;
-}
-
-static u64 get_pvm_id_aa64dfr0(const struct kvm_vcpu *vcpu)
-{
-	/*
-	 * No support for debug, including breakpoints, and watchpoints,
-	 * therefore, pKVM has no sanitized copy of the feature id register.
-	 */
-	BUILD_BUG_ON(PVM_ID_AA64DFR0_ALLOW != 0ULL);
-	return 0;
-}
-
-static u64 get_pvm_id_aa64dfr1(const struct kvm_vcpu *vcpu)
-{
-	/*
-	 * No support for debug, therefore, hyp has no sanitized copy of the
-	 * feature id register.
-	 */
-	BUILD_BUG_ON(PVM_ID_AA64DFR1_ALLOW != 0ULL);
-	return 0;
-}
+	if (!IS_ENABLED(CONFIG_ARM64_PTR_AUTH))
+		return false;
 
-static u64 get_pvm_id_aa64afr0(const struct kvm_vcpu *vcpu)
-{
-	/*
-	 * No support for implementation defined features, therefore, hyp has no
-	 * sanitized copy of the feature id register.
-	 */
-	BUILD_BUG_ON(PVM_ID_AA64AFR0_ALLOW != 0ULL);
-	return 0;
+	return (cpus_have_final_cap(ARM64_HAS_ADDRESS_AUTH) ||
+		cpus_have_final_cap(ARM64_HAS_GENERIC_AUTH)) &&
+		kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_PTRAUTH_GENERIC);
 }
 
-static u64 get_pvm_id_aa64afr1(const struct kvm_vcpu *vcpu)
+static bool vm_has_sve(const struct kvm *kvm)
 {
-	/*
-	 * No support for implementation defined features, therefore, hyp has no
-	 * sanitized copy of the feature id register.
-	 */
-	BUILD_BUG_ON(PVM_ID_AA64AFR1_ALLOW != 0ULL);
-	return 0;
+	return system_supports_sve() && kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_SVE);
 }
 
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
+static const struct pvm_ftr_bits pvmid_aa64pfr0[] = {
+	MAX_FEAT(ID_AA64PFR0_EL1, EL0, IMP),
+	MAX_FEAT(ID_AA64PFR0_EL1, EL1, IMP),
+	MAX_FEAT(ID_AA64PFR0_EL1, EL2, IMP),
+	MAX_FEAT(ID_AA64PFR0_EL1, EL3, IMP),
+	MAX_FEAT(ID_AA64PFR0_EL1, FP, FP16),
+	MAX_FEAT(ID_AA64PFR0_EL1, AdvSIMD, FP16),
+	MAX_FEAT(ID_AA64PFR0_EL1, GIC, IMP),
+	MAX_FEAT_FUNC(ID_AA64PFR0_EL1, SVE, IMP, vm_has_sve),
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
+static const struct pvm_ftr_bits pvmid_aa64pfr1[] = {
+	MAX_FEAT(ID_AA64PFR1_EL1, BT, IMP),
+	MAX_FEAT(ID_AA64PFR1_EL1, SSBS, SSBS2),
+	MAX_FEAT_ENUM(ID_AA64PFR1_EL1, MTE_frac, NI),
+	FEAT_END
+};
 
-	return id_aa64isar1_el1_sys_val & allow_mask;
-}
+static const struct pvm_ftr_bits pvmid_aa64mmfr0[] = {
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
+static const struct pvm_ftr_bits pvmid_aa64mmfr1[] = {
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
+static const struct pvm_ftr_bits pvmid_aa64mmfr2[] = {
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
+static const struct pvm_ftr_bits pvmid_aa64isar1[] = {
+	MAX_FEAT(ID_AA64ISAR1_EL1, DPB, DPB2),
+	MAX_FEAT_FUNC(ID_AA64ISAR1_EL1, APA, PAuth, vm_has_ptrauth),
+	MAX_FEAT_FUNC(ID_AA64ISAR1_EL1, API, PAuth, vm_has_ptrauth),
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
+static const struct pvm_ftr_bits pvmid_aa64isar2[] = {
+	MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, GPA3, IMP, vm_has_ptrauth),
+	MAX_FEAT_FUNC(ID_AA64ISAR2_EL1, APA3, PAuth, vm_has_ptrauth),
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
+				   const struct pvm_ftr_bits restrictions[])
 {
-	return id_aa64mmfr1_el1_sys_val & PVM_ID_AA64MMFR1_ALLOW;
-}
+	u64 val = 0UL;
+	int i;
+
+	for (i = 0; restrictions[i].width != 0; i++) {
+		bool (*vm_supported)(const struct kvm *) = restrictions[i].vm_supported;
+		bool sign = restrictions[i].sign;
+		int shift = restrictions[i].shift;
+		int width = restrictions[i].width;
+		u64 min_signed = (1UL << width) - 1UL;
+		u64 sign_bit = 1UL << (width - 1);
+		u64 mask = GENMASK_ULL(width + shift - 1, shift);
+		u64 sys_val = (sys_reg_val & mask) >> shift;
+		u64 pvm_max = restrictions[i].max_val;
+
+		if (vm_supported && !vm_supported(vcpu->kvm))
+			val |= (sign ? min_signed : 0) << shift;
+		else if (sign && (sys_val >= sign_bit || pvm_max >= sign_bit))
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

