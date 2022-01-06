Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF575C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 04:29:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9870D40D2E;
	Wed,  5 Jan 2022 23:29:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id APHiA8h5Bf1C; Wed,  5 Jan 2022 23:29:00 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 38B9140BDB;
	Wed,  5 Jan 2022 23:28:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3975C49F23
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ctVMc9Lf8ezQ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 23:28:55 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E3ED940BDB
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:52 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 e16-20020a17090a119000b001b28f7b2a3bso1002211pja.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 20:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=qhpWp2iwuCLpyoa1E6QD3X37QmELGOPbigNABcLvgAs=;
 b=h7vlVpkJTbsOdHAcgdcdMXUgFKVOwy1rV3WkKQTkqf3rWLcqCOImrPGSpoU0PWMxUl
 Nz63y3rVjibzPPOMuEAjqhs+IFUPNHlHAVbPwmjwCjjHgsX7Xk31EdgZtSOZkRHmcVIA
 Uq5Nqpb57mQQepK6GSY1W46kKsn3YrcDCJTur0C4bXT6+eHM7iUMIAKwS2Rb+0wfWAc/
 gMrfGjZaoXlQKAnwm72I51LCu9+xez7r5PJyGxXmh8Y8zHOi1aMzr7ZaWwMQbQqFoq+N
 RwOsD0wPxt+xHUM25QrAUawYcJ0pZPeKLptsI2z9mP2QVZBO8qw9ZzSSHux4Zg/m45Ke
 MlUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=qhpWp2iwuCLpyoa1E6QD3X37QmELGOPbigNABcLvgAs=;
 b=qDmt4oJP3LoTI+92LCBUDFEa0Bx+oJfwZykolDkKgr2OETck/x2jimtASn/xe0QNzd
 EsWZJRb4z+BDod+ZSXXm43coFLzwXZ9iEA+02qT2CjQgEPTX3RohANJNepy/d9HWdMMy
 yW+ZpGKCslOBC81znwVycs0UFXs289h41hNcu17lff/rJ43up0GjNJRDt2OQO7SbT32m
 y125vTCioPHYGS1OAFQXc2brtmMKEvAAs9DcI71WwxSX7UM4NxPAT8Z0ZsP7pSlACm/t
 ByOHantlNkazgkH9DjCKoio7feGuV6dmoIpjER4JbqOm3JYxoPBBNw2fT2fhtCAlc+CA
 k/JA==
X-Gm-Message-State: AOAM533GfBX3W9VGJhtMMUAWV3c/2F+Wt/cLo/vyOqb8n3KTb3bQOsQv
 rDmWZIKSByfSr0bEPesp9ijGO47EMDQ=
X-Google-Smtp-Source: ABdhPJzyBd0liBe6yoizB5Gt4UZK12IXkMz5m3rQciDVBiDRZoPZJcXN5iWUEFrzPtErXodzXYOttj+v68U=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a05:6a00:a89:b0:4a4:e9f5:d88a with SMTP id
 b9-20020a056a000a8900b004a4e9f5d88amr58713404pfl.28.1641443332082; Wed, 05
 Jan 2022 20:28:52 -0800 (PST)
Date: Wed,  5 Jan 2022 20:26:56 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-15-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 14/26] KVM: arm64: Add consistency checking for frac
 fields of ID registers
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Feature fractional field of an ID register cannot be simply validated
at KVM_SET_ONE_REG because its validity depends on its (main) feature
field value, which could be in a different ID register (and might be
set later).
Validate fractional fields at the first KVM_RUN instead.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/kvm/arm.c              |   3 +
 arch/arm64/kvm/sys_regs.c         | 116 +++++++++++++++++++++++++++++-
 3 files changed, 117 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4509f9e7472d..7b3f86bd6a6b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -750,6 +750,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 
 void set_default_id_regs(struct kvm *kvm);
 int kvm_set_id_reg_feature(struct kvm *kvm, u32 id, u8 field_shift, u8 fval);
+int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu);
 
 /* Guest/host FPSIMD coordination helpers */
 int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5f497a0af254..16fc2ce32069 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -596,6 +596,9 @@ static int kvm_vcpu_first_run_init(struct kvm_vcpu *vcpu)
 	if (!kvm_arm_vcpu_is_finalized(vcpu))
 		return -EPERM;
 
+	if (!kvm_vm_is_protected(kvm) && kvm_id_regs_consistency_check(vcpu))
+		return -EPERM;
+
 	vcpu->arch.has_run_once = true;
 
 	kvm_arm_vcpu_init_debug(vcpu);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ddbeefc3881c..6adb7b04620c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -756,9 +756,6 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 
 static struct id_reg_info id_aa64pfr1_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR1_EL1,
-	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_RASFRAC) |
-		       ARM64_FEATURE_MASK(ID_AA64PFR1_MPAMFRAC) |
-		       ARM64_FEATURE_MASK(ID_AA64PFR1_CSV2FRAC),
 	.init = init_id_aa64pfr1_el1_info,
 	.validate = validate_id_aa64pfr1_el1,
 	.vcpu_mask = vcpu_mask_id_aa64pfr1_el1,
@@ -3434,10 +3431,109 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+/* ID register's fractional field information with its feature field. */
+struct feature_frac {
+	u32	id;
+	u32	shift;
+	u32	frac_id;
+	u32	frac_shift;
+	u8	frac_ftr_check;
+};
+
+static struct feature_frac feature_frac_table[] = {
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_shift = ID_AA64PFR1_RASFRAC_SHIFT,
+		.id = SYS_ID_AA64PFR0_EL1,
+		.shift = ID_AA64PFR0_RAS_SHIFT,
+	},
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_shift = ID_AA64PFR1_MPAMFRAC_SHIFT,
+		.id = SYS_ID_AA64PFR0_EL1,
+		.shift = ID_AA64PFR0_MPAM_SHIFT,
+	},
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_shift = ID_AA64PFR1_CSV2FRAC_SHIFT,
+		.id = SYS_ID_AA64PFR0_EL1,
+		.shift = ID_AA64PFR0_CSV2_SHIFT,
+	},
+};
+
+/*
+ * Return non-zero if the feature/fractional fields pair are not
+ * supported. Return zero otherwise.
+ * This function validates only the fractional feature field,
+ * and relies on the fact the feature field is validated before
+ * through arm64_check_features.
+ */
+static int vcpu_id_reg_feature_frac_check(const struct kvm_vcpu *vcpu,
+					  const struct feature_frac *ftr_frac)
+{
+	const struct id_reg_info *id_reg;
+	u32 id;
+	u64 val, lim, mask;
+
+	/* Check if the feature field value is same as the limit */
+	id = ftr_frac->id;
+	id_reg = GET_ID_REG_INFO(id);
+
+	mask = (u64)ARM64_FEATURE_FIELD_MASK << ftr_frac->shift;
+	val = __read_id_reg(vcpu, id) & mask;
+	lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
+	lim &= mask;
+
+	if (val != lim)
+		/*
+		 * The feature level is lower than the limit.
+		 * Any fractional version should be fine.
+		 */
+		return 0;
+
+	/* Check the fractional feature field */
+	id = ftr_frac->frac_id;
+	id_reg = GET_ID_REG_INFO(id);
+
+	mask = (u64)ARM64_FEATURE_FIELD_MASK << ftr_frac->frac_shift;
+	val = __read_id_reg(vcpu, id) & mask;
+	lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
+	lim &= mask;
+
+	if (val == lim)
+		/*
+		 * Both the feature and fractional fields are the same
+		 * as limit.
+		 */
+		return 0;
+
+	return arm64_check_features(id, val, lim);
+}
+
+int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)
+{
+	int i, err;
+	const struct feature_frac *frac;
+
+	/*
+	 * Check ID registers' fractional fields, which aren't checked
+	 * at KVM_SET_ONE_REG.
+	 */
+	for (i = 0; i < ARRAY_SIZE(feature_frac_table); i++) {
+		frac = &feature_frac_table[i];
+		err = vcpu_id_reg_feature_frac_check(vcpu, frac);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+
 static void id_reg_info_init_all(void)
 {
 	int i;
 	struct id_reg_info *id_reg;
+	struct feature_frac *frac;
+	u64 ftr_mask = ARM64_FEATURE_FIELD_MASK;
 
 	for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++) {
 		id_reg = (struct id_reg_info *)id_reg_info_table[i];
@@ -3446,6 +3542,20 @@ static void id_reg_info_init_all(void)
 
 		id_reg_info_init(id_reg);
 	}
+
+	/*
+	 * Update ignore_mask of ID registers based on fractional fields
+	 * information.  Any ID register that have fractional fields
+	 * is expected to have its own id_reg_info.
+	 */
+	for (i = 0; i < ARRAY_SIZE(feature_frac_table); i++) {
+		frac = &feature_frac_table[i];
+		id_reg = GET_ID_REG_INFO(frac->frac_id);
+		if (WARN_ON_ONCE(!id_reg))
+			continue;
+
+		id_reg->ignore_mask |= ftr_mask << frac->frac_shift;
+	}
 }
 
 void kvm_sys_reg_table_init(void)
-- 
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
