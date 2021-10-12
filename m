Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50EACC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 045BA61076
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 045BA61076
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC6774B133;
	Tue, 12 Oct 2021 00:36:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id CJFZ6LHSwgsw; Tue, 12 Oct 2021 00:36:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49CD14048B;
	Tue, 12 Oct 2021 00:36:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 354D84A534
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id grTXkWWc1ik5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 00:36:43 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C9C694B0BF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:41 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 2-20020aa79102000000b0044c216dd8ecso8590490pfh.18
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 21:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=NdSMRo52Kt8R49ASB3iWmgOfNvqbp057LlUUAD7mUQ8=;
 b=UJMj1LQnQg8ni482AfX60HHwpm8Qdom8NNgfPE0bTl86X4YpvAIA/blDO5OHvVVxpt
 OMG9HXknPMZA4yh62hHr1vUuixaM5NtleBEvLLzCSflMqnJR94YrBRunIlqd27uYLYzo
 Hke6AO32AiOv7drD5U03XDkZJ4BJwD9kLzPeXwwzxkOwEOfZFdxzlj2p0ncOC1z7EL0H
 YJiP8uqQz3Ozfmb3zGYTDjQtsnZkCpE26TLAb3d7ro6dcu8FBo2zNWngLlRQQtPh9mHA
 py5TkWMBMMoPGNxlnZAu46Jzbv+EzyRZ2ULtjhNyIDXMgvJme8F7lkvqQUrLXOfbNQ3n
 uPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=NdSMRo52Kt8R49ASB3iWmgOfNvqbp057LlUUAD7mUQ8=;
 b=fdXhXntu3rhlHUSZydQbrLokJ6UvQnWXzx9VWjp6zDRmZpYf5ObzTn1XIkXSurPiXJ
 8PgTRooORWRBhzVuHHcKTxhWnw5hENGMNc3BfUCn0NrkYdDDt50BvIDhkCifIiW8IUG/
 mRxDKB/Br0n0qqMdsNQrxxVb1sF4SZELDkyVtNADnpLSI2YH6iVTtxwWaCpo3+ApIsuY
 /UAlT+iHLhDPE4my/Y9esVUSA33btoUpyTEfoo4vrqz+sdskLx7zMba06NKb9G7PCusJ
 GmnAJVhfp019O8SGV7Wui70na89VEH+p5oHWJOUqMxr1QT1+tatS/cAQkduJjxWONABV
 wm3w==
X-Gm-Message-State: AOAM530U4H9/Nr5dtpEkWibMY2rbQ86jjO7qSG6KsvZVRShveIFVvm+1
 jRkQ4sj72Z1kivM3Vjx4U6lHPAVcp5I=
X-Google-Smtp-Source: ABdhPJwFu+FIz+R1kOBR7i1iuVZKIe5AIiaGB4ZNE8m5SuwM1w6CfzaHd9uansbux6G4jPV1AJeCKsHeMB0=
X-Received: from reiji-vws.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a17:90a:8b8d:: with SMTP id
 z13mr296149pjn.0.1634013400403; Mon, 11 Oct 2021 21:36:40 -0700 (PDT)
Date: Mon, 11 Oct 2021 21:35:24 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-15-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 14/25] KVM: arm64: Add consistency checking for frac
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
 arch/arm64/kvm/sys_regs.c | 98 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 94 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2c092136cdff..536e313992d4 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -632,9 +632,6 @@ static struct id_reg_info id_aa64pfr0_el1_info = {
 
 static struct id_reg_info id_aa64pfr1_el1_info = {
 	.sys_reg = SYS_ID_AA64PFR1_EL1,
-	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_RASFRAC) |
-		       ARM64_FEATURE_MASK(ID_AA64PFR1_MPAMFRAC) |
-		       ARM64_FEATURE_MASK(ID_AA64PFR1_CSV2FRAC),
 	.init = init_id_aa64pfr1_el1_info,
 	.validate = validate_id_aa64pfr1_el1,
 	.get_reset_val = get_reset_id_aa64pfr1_el1,
@@ -3198,10 +3195,79 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+/* ID register's fractional field information with its feature field. */
+struct feature_frac {
+	u32	frac_id;
+	u32	id;
+	u64	frac_mask;
+	u64	mask;
+};
+
+static const struct feature_frac feature_frac_table[] = {
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_RASFRAC),
+		.id = SYS_ID_AA64PFR0_EL1,
+		.mask = ARM64_FEATURE_MASK(ID_AA64PFR0_RAS),
+	},
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_MPAMFRAC),
+		.id = SYS_ID_AA64PFR0_EL1,
+		.mask = ARM64_FEATURE_MASK(ID_AA64PFR0_MPAM),
+	},
+	{
+		.frac_id = SYS_ID_AA64PFR1_EL1,
+		.frac_mask = ARM64_FEATURE_MASK(ID_AA64PFR1_CSV2FRAC),
+		.id = SYS_ID_AA64PFR0_EL1,
+		.mask = ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2),
+	},
+};
+
+/*
+ * Return non-zero if the feature/fractional fields pair are not
+ * supported. Return zero otherwise.
+ */
+static int vcpu_id_reg_feature_frac_check(const struct kvm_vcpu *vcpu,
+					  const struct feature_frac *ftr_frac)
+{
+	const struct id_reg_info *id_reg;
+	u32 id;
+	u64 val, lim;
+	int err;
+
+	/* Check the feature field */
+	id = ftr_frac->id;
+	val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) & ftr_frac->mask;
+	id_reg = GET_ID_REG_INFO(id);
+	lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
+	lim &= ftr_frac->mask;
+	err = arm64_check_features(id, val, lim);
+	if (err)
+		/* The feature version is larger than the limit. */
+		return err;
+
+	if (val != lim)
+		/*
+		 * The feature version is smaller than the limit.
+		 * Any fractional version should be fine.
+		 */
+		return 0;
+
+	/* Check the fractional field */
+	id = ftr_frac->frac_id;
+	val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id)) & ftr_frac->frac_mask;
+	id_reg = GET_ID_REG_INFO(id);
+	lim = id_reg ? id_reg->vcpu_limit_val : read_sanitised_ftr_reg(id);
+	lim &= ftr_frac->frac_mask;
+	return arm64_check_features(id, val, lim);
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
@@ -3222,6 +3288,17 @@ int kvm_id_regs_consistency_check(const struct kvm_vcpu *vcpu)
 					KVM_ARM_ID_REG_MAX_NUM))
 			return -EINVAL;
 	}
+
+	/*
+	 * Check ID registers' fractional fields, which aren't checked
+	 * when userspace sets.
+	 */
+	for (i = 0; i < ARRAY_SIZE(feature_frac_table); i++) {
+		frac = &feature_frac_table[i];
+		err = vcpu_id_reg_feature_frac_check(vcpu, frac);
+		if (err)
+			return err;
+	}
 	return 0;
 }
 
@@ -3240,6 +3317,19 @@ static void id_reg_info_init_all(void)
 		else
 			id_reg_info_init(id_reg);
 	}
+
+	/*
+	 * Update ignore_mask of ID registers based on fractional fields
+	 * information.  Any ID register that have fractional fields
+	 * is expected to have its own id_reg_info.
+	 */
+	for (i = 0; i < ARRAY_SIZE(feature_frac_table); i++) {
+		id_reg = GET_ID_REG_INFO(feature_frac_table[i].frac_id);
+		if (WARN_ON_ONCE(!id_reg))
+			continue;
+
+		id_reg->ignore_mask |= feature_frac_table[i].frac_mask;
+	}
 }
 
 void kvm_sys_reg_table_init(void)
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
