Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C4642AAD
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 15:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733154479; cv=none; b=M4sKcKTseeNc7b7PLyhyR/IR579uw7EpxEUZv6SHd0yPoD/aPAr5REsOXQ82chOv3bopRWt58ulFPgQSLyO9Q+3p0q4B78qPYjPkG2DRA8M4t9ji0xJDoU9mnlwnB7Wt0ocB3nKQIcldzqpMe85FtxsZrU5jlbdHIbRAk4d8ouM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733154479; c=relaxed/simple;
	bh=pmYMkBf8m9iHwU4g00u085oRSj3sX69LRFvgOOJjsmg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=M40cjIZtm87ViFFaKc5wYP2DjCr+Y7b3zc7kXJGmtv6KXVxBQTclDZcI8lfq1N7TvruGY8LWSISckeumR7cWJSUFD4Lr+Stp1YIaVq7UgCMXKxtWz4aOJcIqa7LfNJxnMi+3ktWqbt5p0dX+bmJy+m9YZ7A5C4TdOXtpGyByQ5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KWEFFu08; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KWEFFu08"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43499c1342aso31074815e9.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 07:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733154476; x=1733759276; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G3pSOvieBp2AragegVmEe27DQF30aRIuT+PSuVlRLXk=;
        b=KWEFFu08nwktZtJ0EoOns6bn0RJ/qGbOhIyWZOVnMXNep+BOUXhHU1UCrGmbas35ho
         jMtB7F1B9jtqKt9l52o4bz/A2DJV5FaG0DUWB78S1GHM300NhZwJ4JupV1YT8MAPIFbB
         /94aBYLj6S4STGIA5uZH4Xk5PaoI5VSgLiWJya/KDoe5BmU4tRVeajQLthY82DMPqo3h
         3UADp7C1Ob7XorI5wIx5WFJmGM34+9q9dyiUvTkeKa693aKnHrFlwRFiCjdKm8GHIGlr
         wio4xbBlN9MduKqcBP29jirlhCTE35zgF9NIRLsEhqMXYmqhQmt4Udy4OKtSsFiulbCw
         bxiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733154476; x=1733759276;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G3pSOvieBp2AragegVmEe27DQF30aRIuT+PSuVlRLXk=;
        b=tUzmKfIXge+a1G+4ls+I2w/h9yu1SHeMnYCiX0WCOh2JlJQKmuL/uM7Am4KTDjKPzH
         r0OyWes36MY5pWUPpxdpqox0TsYCZpkJrF7DR5Le+WDJcKoKEmnCVkebbxnM+O5c5Hpp
         DR7WmkNYW6qQUc1RwUSw6IaJrgBTobyFCdxpHd2Eu+H+xLu4msyvUvpMQHP5SfxyY9Hb
         laC/DJC+UdsMCV34dcA3UxV8HyLfOTDwGAVqT3IdfJYkcJ/PEmrKYvpTyRpnq/quRYBd
         dW6FOxNq80nQcez3Z6D2F0CD7U40j7lepigVKLVfrwzlDtDxQKFsIgMVjcn69AokX+sF
         tC7A==
X-Gm-Message-State: AOJu0Yzy4pBwG0I3q5/doqVQy1nOgH1ZZvWWIaUE0wrtoO64Py496OLl
	A9RUFMI2w89zqkunCOssq4D02jKjRXzHBz0UljdHxbLEBv7Gzu6+qN8BUV7JgMwQaB2EtetU0ld
	dlZ48ZcwgUcATDRSyez8/fVCqfaiHgNopyfmF2d42/rNPVF8GpXSkxduSA3/YdrIERlty3IHprV
	+7EPk4qpXPOCHubXtXilI//Xa+Jbo=
X-Google-Smtp-Source: AGHT+IEq9o4fPiVVM6t5O2IJw8C/lHZPJCVvC2maJ8cdjSK3nsHt+M+5kgfjdqRAhbxlq51j1zYxpu02Qw==
X-Received: from wman26.prod.google.com ([2002:a05:600c:6c5a:b0:434:9fab:eb5])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c81:b0:434:9936:c828
 with SMTP id 5b1f17b1804b1-434a9dc3db3mr221455355e9.12.1733154476048; Mon, 02
 Dec 2024 07:47:56 -0800 (PST)
Date: Mon,  2 Dec 2024 15:47:33 +0000
In-Reply-To: <20241202154742.3611749-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241202154742.3611749-7-tabba@google.com>
Subject: [PATCH v4 06/14] KVM: arm64: Set protected VM traps based on its view
 of feature registers
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Now that the VM's feature id registers are initialized with the
values of the supported features, use those values to determine
which traps to set using kvm_has_feature().

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c     | 85 +++++++++++-------------------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c |  7 ---
 2 files changed, 30 insertions(+), 62 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 4ef03294b2b4..3b4ea97148b9 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -52,9 +52,7 @@ static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 
 static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
 {
-	const u64 id_aa64pfr0 = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
-	const u64 id_aa64pfr1 = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR1_EL1);
-	const u64 id_aa64mmfr1 = pvm_read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
+	struct kvm *kvm = vcpu->kvm;
 	u64 val = vcpu->arch.hcr_el2;
 
 	/* No support for AArch32. */
@@ -70,25 +68,20 @@ static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
 	 */
 	val |= HCR_TACR | HCR_TIDCP | HCR_TID3 | HCR_TID1;
 
-	/* Trap RAS unless all current versions are supported */
-	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_RAS), id_aa64pfr0) <
-	    ID_AA64PFR0_EL1_RAS_V1P1) {
+	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP)) {
 		val |= HCR_TERR | HCR_TEA;
 		val &= ~(HCR_FIEN);
 	}
 
-	/* Trap AMU */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU), id_aa64pfr0))
+	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, IMP))
 		val &= ~(HCR_AMVOFFEN);
 
-	/* Memory Tagging: Trap and Treat as Untagged if not supported. */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE), id_aa64pfr1)) {
+	if (!kvm_has_feat(kvm, ID_AA64PFR1_EL1, MTE, IMP)) {
 		val |= HCR_TID5;
 		val &= ~(HCR_DCT | HCR_ATA);
 	}
 
-	/* Trap LOR */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_LO), id_aa64mmfr1))
+	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, LO, IMP))
 		val |= HCR_TLOR;
 
 	vcpu->arch.hcr_el2 = val;
@@ -96,9 +89,7 @@ static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
 
 static void pvm_init_traps_cptr(struct kvm_vcpu *vcpu)
 {
-	const u64 id_aa64pfr0 = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
-	const u64 id_aa64pfr1 = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR1_EL1);
-	const u64 id_aa64dfr0 = pvm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
+	struct kvm *kvm = vcpu->kvm;
 	u64 val = vcpu->arch.cptr_el2;
 
 	if (!has_hvhe()) {
@@ -106,12 +97,11 @@ static void pvm_init_traps_cptr(struct kvm_vcpu *vcpu)
 		val &= ~(CPTR_NVHE_EL2_RES0);
 	}
 
-	/* Trap AMU */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU), id_aa64pfr0))
+	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, AMU, IMP))
 		val |= CPTR_EL2_TAM;
 
-	/* Trap SVE */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), id_aa64pfr0)) {
+	/* SVE can be disabled by userspace even if supported. */
+	if (!vcpu_has_sve(vcpu)) {
 		if (has_hvhe())
 			val &= ~(CPACR_ELx_ZEN);
 		else
@@ -119,14 +109,13 @@ static void pvm_init_traps_cptr(struct kvm_vcpu *vcpu)
 	}
 
 	/* No SME support in KVM. */
-	BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME), id_aa64pfr1));
+	BUG_ON(kvm_has_feat(kvm, ID_AA64PFR1_EL1, SME, IMP));
 	if (has_hvhe())
 		val &= ~(CPACR_ELx_SMEN);
 	else
 		val |= CPTR_EL2_TSM;
 
-	/* Trap Trace */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceVer), id_aa64dfr0)) {
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceVer, IMP)) {
 		if (has_hvhe())
 			val |= CPACR_EL1_TTA;
 		else
@@ -138,40 +127,33 @@ static void pvm_init_traps_cptr(struct kvm_vcpu *vcpu)
 
 static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
 {
-	const u64 id_aa64dfr0 = pvm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
-	const u64 id_aa64mmfr0 = pvm_read_id_reg(vcpu, SYS_ID_AA64MMFR0_EL1);
+	struct kvm *kvm = vcpu->kvm;
 	u64 val = vcpu->arch.mdcr_el2;
 
-	/* Trap/constrain PMU */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), id_aa64dfr0)) {
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMUVer, IMP)) {
 		val |= MDCR_EL2_TPM | MDCR_EL2_TPMCR;
 		val &= ~(MDCR_EL2_HPME | MDCR_EL2_MTPME | MDCR_EL2_HPMN_MASK);
 	}
 
-	/* Trap Debug */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), id_aa64dfr0))
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DebugVer, IMP))
 		val |= MDCR_EL2_TDRA | MDCR_EL2_TDA;
 
-	/* Trap OS Double Lock */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DoubleLock), id_aa64dfr0))
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, DoubleLock, IMP))
 		val |= MDCR_EL2_TDOSA;
 
-	/* Trap SPE */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer), id_aa64dfr0)) {
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, PMSVer, IMP)) {
 		val |= MDCR_EL2_TPMS;
 		val &= ~(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT);
 	}
 
-	/* Trap Trace Filter */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceFilt), id_aa64dfr0))
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, TraceFilt, IMP))
 		val |= MDCR_EL2_TTRF;
 
-	/* Trap External Trace */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_ExtTrcBuff), id_aa64dfr0))
+	if (!kvm_has_feat(kvm, ID_AA64DFR0_EL1, ExtTrcBuff, IMP))
 		val |= MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
 
 	/* Trap Debug Communications Channel registers */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_FGT), id_aa64mmfr0))
+	if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, FGT, IMP))
 		val |= MDCR_EL2_TDCC;
 
 	vcpu->arch.mdcr_el2 = val;
@@ -183,31 +165,24 @@ static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
  */
 static int pkvm_check_pvm_cpu_features(struct kvm_vcpu *vcpu)
 {
-	/*
-	 * PAuth is allowed if supported by the system and the vcpu.
-	 * Properly checking for PAuth requires checking various fields in
-	 * ID_AA64ISAR1_EL1 and ID_AA64ISAR2_EL1. The way that fixed config
-	 * is controlled now in pKVM does not easily allow that. This will
-	 * change later to follow the changes upstream wrt fixed configuration
-	 * and nested virt.
-	 */
-	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPI),
-				PVM_ID_AA64ISAR1_ALLOW));
+	struct kvm *kvm = vcpu->kvm;
 
 	/* Protected KVM does not support AArch32 guests. */
-	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0),
-		PVM_ID_AA64PFR0_ALLOW) != ID_AA64PFR0_EL1_EL0_IMP);
-	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1),
-		PVM_ID_AA64PFR0_ALLOW) != ID_AA64PFR0_EL1_EL1_IMP);
+	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL0, AARCH32) ||
+	    kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL1, AARCH32))
+		return -EINVAL;
 
 	/*
 	 * Linux guests assume support for floating-point and Advanced SIMD. Do
 	 * not change the trapping behavior for these from the KVM default.
 	 */
-	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_FP),
-				PVM_ID_AA64PFR0_ALLOW));
-	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AdvSIMD),
-				PVM_ID_AA64PFR0_ALLOW));
+	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, FP, IMP) ||
+	    !kvm_has_feat(kvm, ID_AA64PFR0_EL1, AdvSIMD, IMP))
+		return -EINVAL;
+
+	/* No SME support in KVM right now. Check to catch if it changes. */
+	if (kvm_has_feat(kvm, ID_AA64PFR1_EL1, SME, IMP))
+		return -EINVAL;
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 1261da6a2861..39b678d2c120 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -285,13 +285,6 @@ static bool pvm_access_id_aarch32(struct kvm_vcpu *vcpu,
 		return false;
 	}
 
-	/*
-	 * No support for AArch32 guests, therefore, pKVM has no sanitized copy
-	 * of AArch32 feature id registers.
-	 */
-	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1),
-		     PVM_ID_AA64PFR0_ALLOW) > ID_AA64PFR0_EL1_EL1_IMP);
-
 	return pvm_access_raz_wi(vcpu, p, r);
 }
 
-- 
2.47.0.338.g60cca15819-goog

