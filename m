Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4EB433D2
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 15:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733154481; cv=none; b=KUTDZo6q0JHOIHXu2vHmB6qzq5JP6pNNnYIDklBTNdoFsUDdAzOl4Z6YqyrlbP75BBX1sFmpspJm+uaCjLTWQvyNcn2AFsSOXL4eKYgUVvZ2l5aSF0odhgK4M3EdcA5wJRF/c+QcOQO2D/BEJj7dt+9tDrwEjGPfgeyMtBoo+9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733154481; c=relaxed/simple;
	bh=Ob51WVrjljNsNafAaHS7BRBE/KdLxXmm7C7Nu+Wg1D4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Za7YHW3czvRB6ZWLw4Batw7OGSHOeBTYhwNTwramLTFhULHgJIPVcOsBdE80zG9Y4RxTIM6Hr5L4XEtVWsZESpQ0lz9t86PWMMVZP+5z9UG/tw/kpt0McIQPq93g5TzussSTGsIlnUvuXPm+PQZWcopmxkmQkrqu8xSBkd1y6tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=itK9bRs8; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="itK9bRs8"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4349f32c9a6so36131365e9.3
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 07:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733154478; x=1733759278; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tlrkrFFDSGutm1nLVZfaQz5ciGITXu/fnNsjmBq5kzE=;
        b=itK9bRs8CeFHOm721JpAcTLRJhKK+YUF3LhrKcz8HmScKhAngEnKPcSCVMP5Q2yixs
         iT8GP5Hwc5rRq6KsbLsbaTP4bp3vTBUQZKqd1Ca27BxTAA+PsBEPX6DvTSv94/r4oo/3
         faaOvUcUd0DZZgZHY6ShF9pzJVIF7b+kTu1KFWyRr8B+f79lZa7qgjhChRT1Aflyd9n6
         Y7oL8TduQQIhXz3hc80rP5YXlyY7eK2ATqb5w7yRSkSBNHmmQ/B3eoDOzRwBABN+N8wM
         cgSz+kDTbhXVlJY5AgFYBAz0RAETZQ90aFsfZeeYs4/V+dZkERACnefCXENUPwBVN3dd
         RFDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733154478; x=1733759278;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tlrkrFFDSGutm1nLVZfaQz5ciGITXu/fnNsjmBq5kzE=;
        b=GyS8UE2HHUXIUE3U38NKpGeOrvV7cwvmkPu5p3mydUM90Up8IQTTFba46pIRT63TWH
         xj6QYFvw869g8M9G3DUPLhddtSKiwQWnQlsG4nMolzIegE5P8VZIQXF0n3hpp4sSxtaf
         xFPO4NJzeisXOtExmOfOfquTNdCJgqQvtyqFvn6H46HQbgFRpofRET97xpSc98cuPcpu
         hkaEoPoBkM/GckwUIi+nAyG9wWH07thTj2TegaohyofURrkj9P3IEVM+rx1W6AbXY5ZP
         M92mOxWrmfW0/uD1dszZU2Dta9CvatmsBWAkfWz5Ed++Epb5yef7YnUECw3bwwQoLrMK
         JDaQ==
X-Gm-Message-State: AOJu0YwN9xTmiwxIY4LkI4sWz/Ejvdnjq71EiCAuCppa/ahgRlxb9VLl
	gmhkwYLF+cZe8+p0o/vOH4+FSWhzMtEor2AVEgMi6bqe6H9GUIfeCb0nLMrpt7TVuKkjxboLZEn
	Hghs15hRRm9niHGPk388dmMknCxv7KCyh+DtZKu25/6coMqBivBNJMbLtw4rS66/U44ul1nRi1A
	zaeDOylE6TUMCwrmMP1qpirdC6Xik=
X-Google-Smtp-Source: AGHT+IGTe0YnOAh1dDo7n49QmXQNOFyCZrC3404h0So/y91hGVGrtByEFeppIAAqJ9DkAssJPl/0RLSxRw==
X-Received: from wmbjq10.prod.google.com ([2002:a05:600c:55ca:b0:434:a508:6e2e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5021:b0:434:a706:c0f0
 with SMTP id 5b1f17b1804b1-434a9dc16damr226302635e9.14.1733154478014; Mon, 02
 Dec 2024 07:47:58 -0800 (PST)
Date: Mon,  2 Dec 2024 15:47:34 +0000
In-Reply-To: <20241202154742.3611749-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241202154742.3611749-8-tabba@google.com>
Subject: [PATCH v4 07/14] KVM: arm64: Rework specifying restricted features
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

