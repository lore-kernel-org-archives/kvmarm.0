Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFACA203D53
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 10:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734346266; cv=none; b=UkcC54AIN2PdrPxCyD7HqPjqVatz5nU6wBxhQkqhNjZvUvnksm/CY+9shsAlxbdL2+Q7BMkAmCQrdwh/bONVe/pHZx6irAGkE6oKjROK2iYD+uyroIOOHm/NzHitiByC+S3fs+9NgblAGI+KXfX/vlLY9hXP/b9P9puXXYLGzUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734346266; c=relaxed/simple;
	bh=2MXg4JO/O2RbcBwTffYze6u7BtSLaCIZgeadeyToQBk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zf4BWvxMJP7+QKnEsyZGZlwxdwT/7qe3+x3ONuW76ESBoHUNbiGoFXqjnnIy6gaB7NOgmH5rhR3jKoe71xc/8I1597/hJdW7WIZ2L8kxNuIicGzDpiLUPwAfdSFDK+u4C9SK/LaHHx21hIkjbtIFpdoN9KGUPpTLDDsXIE5VuF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZhkFKH8z; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZhkFKH8z"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4361d4e8359so13035315e9.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 02:51:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734346263; x=1734951063; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oL06yE+6lsDqoEZo0B6caY1IDCsqdCdZ3FGeefrguBs=;
        b=ZhkFKH8zXxGoRVEX/jiQCzkIQozBbrCyNh0hVoWECaZuQx5zc6AO0s1DKS7UsVgi3O
         1D12+/UIf5A5xXOO6BLt0M+6/LyFCu+eAjWFvVJ+Ho1LRC4KftrWyR31bih59e0v8uUc
         EgKCyPkJDZoN5XwDkE3/nftZTODxNnY3e2BcxpIhU6djwWkY6U/W23gZNyVZ47QbkX9d
         ZupmU17UGo9b01AlQYfxakEM65cDWMaN2Z5mzQHF5j1ZCaA1lTe/LuChnu+dEEFgVZ2t
         RY2OK8jfQwAY4+N7G76wVa7Hf2hlLP0QKWBsiUM7URBlZHdVACFVp8nx0BEEZzUHNbsZ
         vX2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734346263; x=1734951063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oL06yE+6lsDqoEZo0B6caY1IDCsqdCdZ3FGeefrguBs=;
        b=DRHdLTZi/dGnZfUXXoiaq/fQwrxbBqbkx+eQWnU8FzSCgOxU+2pKgrVir9M8Kie7VK
         4kZHcwY+RN/7MzptQ/UJ/SrxdmaA6xNItBqLsLr9pTwt61LO8cGw5GnLcTMTgW0F4u2F
         Kn8txtFS8HBT2pI/QWj+1WboLUDRhzFIvjI3tk/53wyaAGgFE1WG6elCucAjqYOhfkjr
         QGktK6RDngAU3upbOcieBzv6pHmhstfBwrUhSZNn31q9LcGKABMpk09GyfDxfsRM3jKV
         eZXnWrUkliN6botjd18/tf+tSwi2wJsf1eeZ+A8tlFDcjUetMzsBOIMomakqd3eQe6Cx
         2bVA==
X-Gm-Message-State: AOJu0Yw6tF50wmVfJ4ImuUNZ4GbuSp8vqHbq13k+J7oSPS69o2nckqSE
	NTilwtb4ecSNPFeu7teSWzp/iIX4I0IhkmOd+mSPGurjNNahgYRDztOGBFoWCE69KN5Au5b8Xtn
	xzXUUAzojmkpi6xybuBRdqmXVItZ2Scp3pkMCZ3Y6UYjYlbsKaNQMazHgTcZkvmPvdkYl4qBksC
	GVxAGLvaq56PbPnBMSBxsgyiDVEaM=
X-Google-Smtp-Source: AGHT+IFg69F+3yITUCN2X1rz1XbXd2N//273G1BVBp5meeevRiOwrmLXkI17PqET6QB/QfncGJgbAVG8Qg==
X-Received: from wmd15.prod.google.com ([2002:a05:600c:604f:b0:435:4bd2:1dcd])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1e0d:b0:42c:b9c8:2bb0
 with SMTP id 5b1f17b1804b1-4362aa27057mr102733325e9.4.1734346263294; Mon, 16
 Dec 2024 02:51:03 -0800 (PST)
Date: Mon, 16 Dec 2024 10:50:42 +0000
In-Reply-To: <20241216105057.579031-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216105057.579031-1-tabba@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216105057.579031-3-tabba@google.com>
Subject: [PATCH v5 02/17] KVM: arm64: Group setting traps for protected VMs by
 control register
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, kristina.martsenko@arm.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Group setting protected VM traps by control register rather than
feature id register, since some trap values (e.g., PAuth), depend
on more than one feature id register.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/pkvm.c | 317 +++++++++++++++------------------
 1 file changed, 144 insertions(+), 173 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 76a70fee7647..1744574e79b2 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -23,233 +23,204 @@ unsigned int kvm_arm_vmid_bits;
 
 unsigned int kvm_host_sve_max_vl;
 
-/*
- * Set trap register values based on features in ID_AA64PFR0.
- */
-static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
+static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
-	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
-	u64 hcr_set = HCR_RW;
-	u64 hcr_clear = 0;
-	u64 cptr_set = 0;
-	u64 cptr_clear = 0;
-
-	/* Protected KVM does not support AArch32 guests. */
-	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0),
-		PVM_ID_AA64PFR0_ALLOW) != ID_AA64PFR0_EL1_EL0_IMP);
-	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1),
-		PVM_ID_AA64PFR0_ALLOW) != ID_AA64PFR0_EL1_EL1_IMP);
-
-	/*
-	 * Linux guests assume support for floating-point and Advanced SIMD. Do
-	 * not change the trapping behavior for these from the KVM default.
-	 */
-	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_FP),
-				PVM_ID_AA64PFR0_ALLOW));
-	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AdvSIMD),
-				PVM_ID_AA64PFR0_ALLOW));
+	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
 
 	if (has_hvhe())
-		hcr_set |= HCR_E2H;
+		vcpu->arch.hcr_el2 |= HCR_E2H;
 
-	/* Trap RAS unless all current versions are supported */
-	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_RAS), feature_ids) <
-	    ID_AA64PFR0_EL1_RAS_V1P1) {
-		hcr_set |= HCR_TERR | HCR_TEA;
-		hcr_clear |= HCR_FIEN;
+	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
+		/* route synchronous external abort exceptions to EL2 */
+		vcpu->arch.hcr_el2 |= HCR_TEA;
+		/* trap error record accesses */
+		vcpu->arch.hcr_el2 |= HCR_TERR;
 	}
 
-	/* Trap AMU */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU), feature_ids)) {
-		hcr_clear |= HCR_AMVOFFEN;
-		cptr_set |= CPTR_EL2_TAM;
-	}
+	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
+		vcpu->arch.hcr_el2 |= HCR_FWB;
 
-	/* Trap SVE */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), feature_ids)) {
-		if (has_hvhe())
-			cptr_clear |= CPACR_ELx_ZEN;
-		else
-			cptr_set |= CPTR_EL2_TZ;
-	}
+	if (cpus_have_final_cap(ARM64_HAS_EVT) &&
+	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE))
+		vcpu->arch.hcr_el2 |= HCR_TID4;
+	else
+		vcpu->arch.hcr_el2 |= HCR_TID2;
 
-	vcpu->arch.hcr_el2 |= hcr_set;
-	vcpu->arch.hcr_el2 &= ~hcr_clear;
-	vcpu->arch.cptr_el2 |= cptr_set;
-	vcpu->arch.cptr_el2 &= ~cptr_clear;
+	if (vcpu_has_ptrauth(vcpu))
+		vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
 }
 
-/*
- * Set trap register values based on features in ID_AA64PFR1.
- */
-static void pvm_init_traps_aa64pfr1(struct kvm_vcpu *vcpu)
+static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
 {
-	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR1_EL1);
-	u64 hcr_set = 0;
-	u64 hcr_clear = 0;
+	const u64 id_aa64pfr0 = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
+	const u64 id_aa64pfr1 = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR1_EL1);
+	const u64 id_aa64mmfr1 = pvm_read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
+	u64 val = vcpu->arch.hcr_el2;
+
+	/* No support for AArch32. */
+	val |= HCR_RW;
+
+	if (has_hvhe())
+		val |= HCR_E2H;
+
+	/*
+	 * Always trap:
+	 * - Feature id registers: to control features exposed to guests
+	 * - Implementation-defined features
+	 */
+	val |= HCR_TACR | HCR_TIDCP | HCR_TID3 | HCR_TID1;
+
+	/* Trap RAS unless all current versions are supported */
+	if (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_RAS), id_aa64pfr0) <
+	    ID_AA64PFR0_EL1_RAS_V1P1) {
+		val |= HCR_TERR | HCR_TEA;
+		val &= ~(HCR_FIEN);
+	}
+
+	/* Trap AMU */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU), id_aa64pfr0))
+		val &= ~(HCR_AMVOFFEN);
 
 	/* Memory Tagging: Trap and Treat as Untagged if not supported. */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE), feature_ids)) {
-		hcr_set |= HCR_TID5;
-		hcr_clear |= HCR_DCT | HCR_ATA;
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_MTE), id_aa64pfr1)) {
+		val |= HCR_TID5;
+		val &= ~(HCR_DCT | HCR_ATA);
 	}
 
-	vcpu->arch.hcr_el2 |= hcr_set;
-	vcpu->arch.hcr_el2 &= ~hcr_clear;
+	/* Trap LOR */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_LO), id_aa64mmfr1))
+		val |= HCR_TLOR;
+
+	vcpu->arch.hcr_el2 = val;
 }
 
-/*
- * Set trap register values based on features in ID_AA64DFR0.
- */
-static void pvm_init_traps_aa64dfr0(struct kvm_vcpu *vcpu)
+static void pvm_init_traps_cptr(struct kvm_vcpu *vcpu)
 {
-	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
-	u64 mdcr_set = 0;
-	u64 mdcr_clear = 0;
-	u64 cptr_set = 0;
+	const u64 id_aa64pfr0 = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
+	const u64 id_aa64pfr1 = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR1_EL1);
+	const u64 id_aa64dfr0 = pvm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
+	u64 val = vcpu->arch.cptr_el2;
 
-	/* Trap/constrain PMU */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), feature_ids)) {
-		mdcr_set |= MDCR_EL2_TPM | MDCR_EL2_TPMCR;
-		mdcr_clear |= MDCR_EL2_HPME | MDCR_EL2_MTPME |
-			      MDCR_EL2_HPMN_MASK;
+	if (!has_hvhe()) {
+		val |= CPTR_NVHE_EL2_RES1;
+		val &= ~(CPTR_NVHE_EL2_RES0);
 	}
 
-	/* Trap Debug */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), feature_ids))
-		mdcr_set |= MDCR_EL2_TDRA | MDCR_EL2_TDA | MDCR_EL2_TDE;
-
-	/* Trap OS Double Lock */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DoubleLock), feature_ids))
-		mdcr_set |= MDCR_EL2_TDOSA;
+	/* Trap AMU */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU), id_aa64pfr0))
+		val |= CPTR_EL2_TAM;
 
-	/* Trap SPE */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer), feature_ids)) {
-		mdcr_set |= MDCR_EL2_TPMS;
-		mdcr_clear |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
+	/* Trap SVE */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), id_aa64pfr0)) {
+		if (has_hvhe())
+			val &= ~(CPACR_ELx_ZEN);
+		else
+			val |= CPTR_EL2_TZ;
 	}
 
-	/* Trap Trace Filter */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceFilt), feature_ids))
-		mdcr_set |= MDCR_EL2_TTRF;
+	/* No SME support in KVM. */
+	BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME), id_aa64pfr1));
+	if (has_hvhe())
+		val &= ~(CPACR_ELx_SMEN);
+	else
+		val |= CPTR_EL2_TSM;
 
 	/* Trap Trace */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceVer), feature_ids)) {
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceVer), id_aa64dfr0)) {
 		if (has_hvhe())
-			cptr_set |= CPACR_EL1_TTA;
+			val |= CPACR_EL1_TTA;
 		else
-			cptr_set |= CPTR_EL2_TTA;
+			val |= CPTR_EL2_TTA;
 	}
 
-	/* Trap External Trace */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_ExtTrcBuff), feature_ids))
-		mdcr_clear |= MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
-
-	vcpu->arch.mdcr_el2 |= mdcr_set;
-	vcpu->arch.mdcr_el2 &= ~mdcr_clear;
-	vcpu->arch.cptr_el2 |= cptr_set;
-}
-
-/*
- * Set trap register values based on features in ID_AA64MMFR0.
- */
-static void pvm_init_traps_aa64mmfr0(struct kvm_vcpu *vcpu)
-{
-	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64MMFR0_EL1);
-	u64 mdcr_set = 0;
-
-	/* Trap Debug Communications Channel registers */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_FGT), feature_ids))
-		mdcr_set |= MDCR_EL2_TDCC;
-
-	vcpu->arch.mdcr_el2 |= mdcr_set;
+	vcpu->arch.cptr_el2 = val;
 }
 
-/*
- * Set trap register values based on features in ID_AA64MMFR1.
- */
-static void pvm_init_traps_aa64mmfr1(struct kvm_vcpu *vcpu)
-{
-	const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64MMFR1_EL1);
-	u64 hcr_set = 0;
-
-	/* Trap LOR */
-	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR1_EL1_LO), feature_ids))
-		hcr_set |= HCR_TLOR;
-
-	vcpu->arch.hcr_el2 |= hcr_set;
-}
-
-/*
- * Set baseline trap register values.
- */
-static void pvm_init_trap_regs(struct kvm_vcpu *vcpu)
+static void pvm_init_traps_mdcr(struct kvm_vcpu *vcpu)
 {
-	const u64 hcr_trap_feat_regs = HCR_TID3;
-	const u64 hcr_trap_impdef = HCR_TACR | HCR_TIDCP | HCR_TID1;
-
-	/*
-	 * Always trap:
-	 * - Feature id registers: to control features exposed to guests
-	 * - Implementation-defined features
-	 */
-	vcpu->arch.hcr_el2 |= hcr_trap_feat_regs | hcr_trap_impdef;
+	const u64 id_aa64dfr0 = pvm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
+	const u64 id_aa64mmfr0 = pvm_read_id_reg(vcpu, SYS_ID_AA64MMFR0_EL1);
+	u64 val = vcpu->arch.mdcr_el2;
 
-	/* Clear res0 and set res1 bits to trap potential new features. */
-	vcpu->arch.hcr_el2 &= ~(HCR_RES0);
-	vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_RES0);
-	if (!has_hvhe()) {
-		vcpu->arch.cptr_el2 |= CPTR_NVHE_EL2_RES1;
-		vcpu->arch.cptr_el2 &= ~(CPTR_NVHE_EL2_RES0);
+	/* Trap/constrain PMU */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), id_aa64dfr0)) {
+		val |= MDCR_EL2_TPM | MDCR_EL2_TPMCR;
+		val &= ~(MDCR_EL2_HPME | MDCR_EL2_MTPME | MDCR_EL2_HPMN_MASK);
 	}
-}
 
-static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
+	/* Trap Debug */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), id_aa64dfr0))
+		val |= MDCR_EL2_TDRA | MDCR_EL2_TDA;
 
-	if (has_hvhe())
-		vcpu->arch.hcr_el2 |= HCR_E2H;
+	/* Trap OS Double Lock */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DoubleLock), id_aa64dfr0))
+		val |= MDCR_EL2_TDOSA;
 
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
-		/* route synchronous external abort exceptions to EL2 */
-		vcpu->arch.hcr_el2 |= HCR_TEA;
-		/* trap error record accesses */
-		vcpu->arch.hcr_el2 |= HCR_TERR;
+	/* Trap SPE */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer), id_aa64dfr0)) {
+		val |= MDCR_EL2_TPMS;
+		val &= ~(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT);
 	}
 
-	if (cpus_have_final_cap(ARM64_HAS_STAGE2_FWB))
-		vcpu->arch.hcr_el2 |= HCR_FWB;
+	/* Trap Trace Filter */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceFilt), id_aa64dfr0))
+		val |= MDCR_EL2_TTRF;
 
-	if (cpus_have_final_cap(ARM64_HAS_EVT) &&
-	    !cpus_have_final_cap(ARM64_MISMATCHED_CACHE_TYPE))
-		vcpu->arch.hcr_el2 |= HCR_TID4;
-	else
-		vcpu->arch.hcr_el2 |= HCR_TID2;
+	/* Trap External Trace */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_ExtTrcBuff), id_aa64dfr0))
+		val |= MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
 
-	if (vcpu_has_ptrauth(vcpu))
-		vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
+	/* Trap Debug Communications Channel registers */
+	if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_FGT), id_aa64mmfr0))
+		val |= MDCR_EL2_TDCC;
+
+	vcpu->arch.mdcr_el2 = val;
 }
 
 /*
  * Initialize trap register values in protected mode.
  */
-static void pkvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
+static void pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
 {
+	struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
+
 	vcpu->arch.cptr_el2 = kvm_get_reset_cptr_el2(vcpu);
 	vcpu->arch.mdcr_el2 = 0;
 
 	pkvm_vcpu_reset_hcr(vcpu);
 
-	if ((!vcpu_is_protected(vcpu)))
+	if ((!pkvm_hyp_vcpu_is_protected(hyp_vcpu)))
 		return;
 
-	pvm_init_trap_regs(vcpu);
-	pvm_init_traps_aa64pfr0(vcpu);
-	pvm_init_traps_aa64pfr1(vcpu);
-	pvm_init_traps_aa64dfr0(vcpu);
-	pvm_init_traps_aa64mmfr0(vcpu);
-	pvm_init_traps_aa64mmfr1(vcpu);
+	/*
+	 * PAuth is allowed if supported by the system and the vcpu.
+	 * Properly checking for PAuth requires checking various fields in
+	 * ID_AA64ISAR1_EL1 and ID_AA64ISAR2_EL1. The way that fixed config
+	 * is controlled now in pKVM does not easily allow that. This will
+	 * change later to follow the changes upstream wrt fixed configuration
+	 * and nested virt.
+	 */
+	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64ISAR1_EL1_GPI),
+				PVM_ID_AA64ISAR1_ALLOW));
+
+	/* Protected KVM does not support AArch32 guests. */
+	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0),
+		PVM_ID_AA64PFR0_ALLOW) != ID_AA64PFR0_EL1_EL0_IMP);
+	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1),
+		PVM_ID_AA64PFR0_ALLOW) != ID_AA64PFR0_EL1_EL1_IMP);
+
+	/*
+	 * Linux guests assume support for floating-point and Advanced SIMD. Do
+	 * not change the trapping behavior for these from the KVM default.
+	 */
+	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_FP),
+				PVM_ID_AA64PFR0_ALLOW));
+	BUILD_BUG_ON(!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AdvSIMD),
+				PVM_ID_AA64PFR0_ALLOW));
+
+	pvm_init_traps_hcr(vcpu);
+	pvm_init_traps_cptr(vcpu);
+	pvm_init_traps_mdcr(vcpu);
 }
 
 /*
@@ -448,7 +419,7 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
 
 	pkvm_vcpu_init_sve(hyp_vcpu, host_vcpu);
 	pkvm_vcpu_init_ptrauth(hyp_vcpu);
-	pkvm_vcpu_init_traps(&hyp_vcpu->vcpu);
+	pkvm_vcpu_init_traps(hyp_vcpu);
 done:
 	if (ret)
 		unpin_host_vcpu(host_vcpu);
-- 
2.47.1.613.gc27f4b7a9f-goog

