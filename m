Return-Path: <SRS0=Zoam=PA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D64AFC433EF
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8A3FC610A3
	for <kvmarm@archiver.kernel.org>; Tue, 12 Oct 2021 04:36:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8A3FC610A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E1714A531;
	Tue, 12 Oct 2021 00:36:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id c7ErFaZGscHa; Tue, 12 Oct 2021 00:36:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3BD64B149;
	Tue, 12 Oct 2021 00:36:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17A6A4A531
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FbhiNZody+rF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Oct 2021 00:36:49 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5703F4B0BF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Oct 2021 00:36:48 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 c2-20020a63d5020000b029023ae853b72cso8025226pgg.18
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Oct 2021 21:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=OQYgwRpV/afvA18lL6MxXV8IUfnKjIjbj1gRfgEyVlM=;
 b=IXmq+jTnwzeMBZKuKOipuIYaqVqyDgFMjOwwqaAgqb69yrm6IYJI+VT/YZ5EeAWbSq
 gCLxYJ+uTN3DFS1my5x2/PLGxbN9dRP5QOnJ/ssIh7ETvLkRsUOqZlVwI/ahI8wMgahd
 bCXEbEQzWffBR905nT9Ci/R/YNi+a+J9L6RmWiRtI0WBgUIUd4hCS+EgjruLZtHR40WH
 hkCCqtj9wBP07X1FJFqKlmx39A4gvLr+AXiIvUp94hY3RkNS7y3kZCECK51vw7qF/gcq
 lQUcFrWMU2XfVxGskB5pP/mWuzWV4MnjVj+dLW5eyUPPGDPUj5CUUy2HBW7TvX6rhT2n
 Adjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=OQYgwRpV/afvA18lL6MxXV8IUfnKjIjbj1gRfgEyVlM=;
 b=o/l4QDcxKFvKqyTOJ4JKkR2eKS0WwcgcTVsCgBwBOlup/jRYJL5knKUBABCaDFNnFp
 baM12BlgDPDJAH1md3dqaRF1zfncdSUnWyBDDgT6qT6lwAcSm2edyc96wvmpPzISMMVe
 y3zx3cBdRMheAewZQj8dtqzGkpYmMyEfeswi6PZvRN7ah8EODZ661VL0WNBZjKPFgSgH
 LUJYM+T8imnrpN7di/dyJtg5pawNW5cmUHqDwVoKVHril4WzK7aNWSpAO166gfFpex13
 bPIoPDNkjYNCvB+4cSt2HjkbhwPNI5C9JpbzfnT29U4YTdIAkYpD4jFB3J1MYVVSFiyr
 eeGQ==
X-Gm-Message-State: AOAM531t8WAAHTqUK9Dyx8ryKoAIyDDzUjXLxPbK8MrwUeegvcIFOIMa
 BkA+bNRaKqtGBLUK9SVF9Mi6sHyaOAQ=
X-Google-Smtp-Source: ABdhPJxBaQNXtyGD8dhFMG0rTvuje7KSg1St0xidYAdYw8pJDEOzrI/xNhyhGBTWV3iL65bgyq5YRTWE8mM=
X-Received: from reiji-vws.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:15a3])
 (user=reijiw job=sendgmr) by 2002:a17:90a:3ee4:: with SMTP id
 k91mr295603pjc.1.1634013407117; Mon, 11 Oct 2021 21:36:47 -0700 (PDT)
Date: Mon, 11 Oct 2021 21:35:28 -0700
In-Reply-To: <20211012043535.500493-1-reijiw@google.com>
Message-Id: <20211012043535.500493-19-reijiw@google.com>
Mime-Version: 1.0
References: <20211012043535.500493-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [RFC PATCH 18/25] KVM: arm64: Introduce framework to trap disabled
 features
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

When a CPU feature that is supported on the host is not exposed to
its guest, emulating a real CPU's behavior (by trapping or disabling
guest's using the feature) is generally a desirable behavior (when
it's possible without any or little side effect).

Introduce feature_config_ctrl structure, which manages feature
information to program configuration register to trap or disable
the feature when the feature is not exposed to the guest, and
functions that uses the structure to activate trapping the feature.

At present, no feature has feature_config_ctrl yet and the following
patches will add the feature_config_ctrl for several features.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 117 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 536e313992d4..55c514e21214 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -281,6 +281,35 @@ static bool trap_raz_wi(struct kvm_vcpu *vcpu,
 	(cpuid_feature_extract_unsigned_field(val, ID_AA64ISAR1_GPI_SHIFT) >= \
 	 ID_AA64ISAR1_GPI_IMP_DEF)
 
+enum vcpu_config_reg {
+	VCPU_HCR_EL2 = 1,
+	VCPU_MDCR_EL2,
+	VCPU_CPTR_EL2,
+};
+
+/*
+ * Feature information to program configuration register to trap or disable
+ * guest's using a feature when the feature is not exposed to the guest.
+ */
+struct feature_config_ctrl {
+	/* ID register/field for the feature */
+	u32	ftr_reg;	/* ID register */
+	bool	ftr_signed;	/* Is the feature field signed ? */
+	u8	ftr_shift;	/* Field of ID register for the feature */
+	s8	ftr_min;	/* Min value that indicate the feature */
+
+	/*
+	 * Function to check trapping is needed. This is used when the above
+	 * fields are not enough to determine if trapping is needed.
+	 */
+	bool	(*ftr_need_trap)(struct kvm_vcpu *vcpu);
+
+	/* Configuration register information to trap the feature. */
+	enum vcpu_config_reg cfg_reg;	/* Configuration register */
+	u64	cfg_mask;	/* Field of the configuration register */
+	u64	cfg_val;	/* Value that are set for the field */
+};
+
 struct id_reg_info {
 	u32	sys_reg;	/* Register ID */
 	u64	sys_val;	/* Sanitized system value */
@@ -302,6 +331,9 @@ struct id_reg_info {
 
 	/* Return the reset value of the register for the vCPU */
 	u64 (*get_reset_val)(struct kvm_vcpu *vcpu, struct id_reg_info *id_reg);
+
+	/* Information to trap features that are disabled for the guest */
+	const struct feature_config_ctrl *(*trap_features)[];
 };
 
 static void id_reg_info_init(struct id_reg_info *id_reg)
@@ -717,6 +749,47 @@ static int validate_id_reg(struct kvm_vcpu *vcpu,
 	return err;
 }
 
+static void feature_trap_activate(struct kvm_vcpu *vcpu,
+				  const struct feature_config_ctrl *config)
+{
+	u64 *reg_ptr, reg_val;
+
+	switch (config->cfg_reg) {
+	case VCPU_HCR_EL2:
+		reg_ptr = &vcpu->arch.hcr_el2;
+		break;
+	case VCPU_MDCR_EL2:
+		reg_ptr = &vcpu->arch.mdcr_el2;
+		break;
+	case VCPU_CPTR_EL2:
+		reg_ptr = &vcpu->arch.cptr_el2;
+		break;
+	}
+
+	/* Update cfg_mask fields with cfg_val */
+	reg_val = (*reg_ptr & ~config->cfg_mask);
+	reg_val |= config->cfg_val;
+	*reg_ptr = reg_val;
+}
+
+static inline bool feature_avail(const struct feature_config_ctrl *ctrl,
+				 u64 id_val)
+{
+	int field_val = cpuid_feature_extract_field(id_val,
+				ctrl->ftr_shift, ctrl->ftr_signed);
+
+	return (field_val >= ctrl->ftr_min);
+}
+
+static inline bool vcpu_feature_is_available(struct kvm_vcpu *vcpu,
+					const struct feature_config_ctrl *ctrl)
+{
+	u64 val;
+
+	val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(ctrl->ftr_reg));
+	return feature_avail(ctrl, val);
+}
+
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -1570,6 +1643,42 @@ static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
 static int reg_to_user(void __user *uaddr, const u64 *val, u64 id);
 static u64 sys_reg_to_index(const struct sys_reg_desc *reg);
 
+static void id_reg_features_trap_activate(struct kvm_vcpu *vcpu,
+					  const struct id_reg_info *id_reg)
+{
+	u64 val;
+	int i = 0;
+	const struct feature_config_ctrl **ctrlp_array, *ctrl;
+
+	if (!id_reg || !id_reg->trap_features)
+		/* No information to trap a feature */
+		return;
+
+	val = __vcpu_sys_reg(vcpu, IDREG_SYS_IDX(id_reg->sys_reg));
+	if (val == id_reg->sys_val)
+		/* No feature needs to be trapped (no feature is disabled). */
+		return;
+
+	ctrlp_array = *id_reg->trap_features;
+	while ((ctrl = ctrlp_array[i++]) != NULL) {
+		if (ctrl->ftr_need_trap && ctrl->ftr_need_trap(vcpu)) {
+			feature_trap_activate(vcpu, ctrl);
+			continue;
+		}
+
+		if (!feature_avail(ctrl, id_reg->sys_val))
+			/* The feature is not supported on the host. */
+			continue;
+
+		if (feature_avail(ctrl, val))
+			/* The feature is enabled for the guest. */
+			continue;
+
+		/* The feature is supported but disabled. */
+		feature_trap_activate(vcpu, ctrl);
+	}
+}
+
 /* Visibility overrides for SVE-specific control registers */
 static unsigned int sve_visibility(const struct kvm_vcpu *vcpu,
 				   const struct sys_reg_desc *rd)
@@ -3195,6 +3304,14 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+void kvm_vcpu_id_regs_trap_activate(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++)
+		id_reg_features_trap_activate(vcpu, id_reg_info_table[i]);
+}
+
 /* ID register's fractional field information with its feature field. */
 struct feature_frac {
 	u32	frac_id;
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
