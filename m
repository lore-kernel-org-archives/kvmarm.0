Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B38C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 834EC6115B
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 834EC6115B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33CAE4B163;
	Wed,  3 Nov 2021 02:28:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id eJhO6LT7QmCm; Wed,  3 Nov 2021 02:28:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 855AA4B152;
	Wed,  3 Nov 2021 02:28:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE9A64B103
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C3M0tAjIV3At for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:28:23 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CB5AA4B163
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:23 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 y124-20020a623282000000b0047a09271e49so821494pfy.16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=C5yQ8yOodLMSFDUkZwymSW+rTndotw8MH+3y9C4rprM=;
 b=hp7Gve4yuw1Lb8fSnMTaCb1v3CrKrMIh7lOFjpQry051BYkVMJaPcmD5uXfn45bS99
 ZfaZECLNPlxL6/G7mCWP2IQj+t+BiUvS7Y7/Z2vYzVGt3DqYNwOYUBfkXKPDS8se+vCE
 P8IXmSxPCdU/4Ch2lQfLHZFO7HOHGCK1CugfdIJmPs6PHVY6iFHCVkpYM+bN0LndC4I9
 afP3BcZs/dkMnywcE0AMdAexTLcKeYGnFwwONqJ2q0CEonVmiplrXkDstgRS7mQAYPxS
 Q7OrAUNx5N0A8diXaGEFBUnCEl3GaFjNaJkUU1QjXmldNtoXQxMdbvwO/mZWSKOS8Exb
 tEBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=C5yQ8yOodLMSFDUkZwymSW+rTndotw8MH+3y9C4rprM=;
 b=aZc9y8r9z/eT33gL7MhWRvo7wmaGP22gDqkn1aNt+YPS+266iNdS8e9Mq0jBwVgFV9
 KU7ZrLA22Cfm6Ckwjhf/habg25XU5fOKFdctd/YX4nwpXSTiSMOUafs5NCaUO/a2WP9E
 askxf/Nk0hH3mB8goEJ7MwKeobX1IqdjxHD23qtNPhkRrYQEx3EHxN1i3S88RhBb/2mH
 RLAxd4iSaGCZp0PNzynb9K0buK50dO94+wJC+5sXR/mxB8vKqY1XkOnKjlfKH+ZcuSNN
 i1gkf8auT2o/hTduM9yr6Hoa+lF8FcsxUXYGzMfsM2qBNKZO86tACm3dSdbrSjeFdw2k
 zWaA==
X-Gm-Message-State: AOAM533mpY0WQgbrWYJRAvCtlm0YhrOrP1c7pNjF3L9L0AtPjlOl7lzz
 6qlIQHru4/nLCu8t1vQOK1DCP8uWizE=
X-Google-Smtp-Source: ABdhPJxcks24XT7LWQqlv4ZZTDZSBB0irMiSAQnwrrX8h6gSYkanjyBTWa61E3/HPOvc7PD9rNXtBIcbNp4=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:9b8a:b0:13f:c286:a060 with SMTP id
 y10-20020a1709029b8a00b0013fc286a060mr36314809plp.66.1635920903036; Tue, 02
 Nov 2021 23:28:23 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:25:09 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-18-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 17/28] KVM: arm64: Add consistency checking for frac
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
 arch/arm64/kvm/sys_regs.c | 121 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 117 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1b4ffbf539a7..ec984fd4e319 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -817,9 +817,6 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 
 static struct id_reg_info id_aa64pfr1_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR1_EL1,
-	.ftr_check_types = U_FCT(ID_AA64PFR1_RASFRAC_SHIFT, FCT_IGNORE) |
-			   U_FCT(ID_AA64PFR1_MPAMFRAC_SHIFT, FCT_IGNORE) |
-			   U_FCT(ID_AA64PFR1_CSV2FRAC_SHIFT, FCT_IGNORE),
 	.init = init_id_aa64pfr1_el1_info,
 	.validate = validate_id_aa64pfr1_el1,
 	.get_reset_val = get_reset_id_aa64pfr1_el1,
@@ -3407,10 +3404,86 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
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
+ * This function only checks fractional feature field and assumes
+ * the feature field is valid.
+ */
+static int vcpu_id_reg_feature_frac_check(const struct kvm_vcpu *vcpu,
+					  const struct feature_frac *ftr_frac)
+{
+	u32 id;
+	int fval, flim, ret;
+	u64 val, lim, mask;
+	const struct id_reg_info *id_reg;
+	bool sign = FCT_SIGN(ftr_frac->frac_ftr_check);
+	enum feature_check_type type = FCT_TYPE(ftr_frac->frac_ftr_check);
+
+	/* Check if the feature field value is same as the limit */
+	id = ftr_frac->id;
+	id_reg = GET_ID_REG_INFO(id);
+
+	val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
+	lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
+
+	mask = (u64)ARM64_FEATURE_FIELD_MASK << ftr_frac->shift;
+	if ((val & mask) != (lim & mask))
+		/*
+		 * The feature level is smaller than the limit.
+		 * Any fractional version should be fine.
+		 */
+		return 0;
+
+	/* Check the fractional feature field */
+	id = ftr_frac->frac_id;
+	id_reg = GET_ID_REG_INFO(id);
+
+	val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id));
+	fval = cpuid_feature_extract_field(val, ftr_frac->frac_shift, sign);
+
+	lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
+	flim = cpuid_feature_extract_field(lim, ftr_frac->frac_shift, sign);
+
+	ret = arm64_check_feature_one(type, fval, flim);
+	return ret ? -E2BIG : 0;
+}
+
 int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)
 {
-	int i;
+	int i, err;
 	const struct kvm_vcpu *t_vcpu;
+	const struct feature_frac *frac;
 
 	/*
 	 * Make sure vcpu->arch.has_run_once is visible for others so that
@@ -3431,6 +3504,17 @@ int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)
 					KVM_ARM_ID_REG_MAX_NUM))
 			return -EINVAL;
 	}
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
 	return 0;
 }
 
@@ -3438,6 +3522,9 @@ static void id_reg_info_init_all(void)
 {
 	int i;
 	struct id_reg_info *id_reg;
+	struct feature_frac *frac;
+	u64 mask = ARM64_FEATURE_FIELD_MASK;
+	u64 org;
 
 	for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++) {
 		id_reg = (struct id_reg_info *)id_reg_info_table[i];
@@ -3446,6 +3533,32 @@ static void id_reg_info_init_all(void)
 
 		id_reg_info_init(id_reg);
 	}
+
+	for (i = 0; i < ARRAY_SIZE(feature_frac_table); i++) {
+		frac = &feature_frac_table[i];
+		id_reg = GET_ID_REG_INFO(frac->frac_id);
+
+		/*
+		 * An ID register that has fractional fields is expected
+		 * to have its own id_reg_info.
+		 */
+		if (WARN_ON_ONCE(!id_reg))
+			continue;
+
+		/*
+		 * Update the id_reg's ftr_check_types for the fractional
+		 * field with FCT_IGNORE so that the field won't be validated
+		 * when the ID register is set by userspace, which could
+		 * temporarily cause an inconsistency if its (main) feature
+		 * field is not set yet.  Save the original ftr_check_types
+		 * for the fractional field to validate the field later.
+		 */
+		org = (id_reg->ftr_check_types >> frac->frac_shift) & mask;
+		id_reg->ftr_check_types &= ~(mask << frac->frac_shift);
+		id_reg->ftr_check_types |=
+			MAKE_FCT(frac->frac_shift, FCT_IGNORE, FCT_SIGN(org));
+		frac->frac_ftr_check = org;
+	}
 }
 
 void kvm_sys_reg_table_init(void)
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
