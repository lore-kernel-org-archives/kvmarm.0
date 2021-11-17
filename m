Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84866C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2746B61BD3
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2746B61BD3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC73D4B18A;
	Wed, 17 Nov 2021 01:53:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hpzZkFmqT3p4; Wed, 17 Nov 2021 01:53:47 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E39724B1BD;
	Wed, 17 Nov 2021 01:53:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 147134B17D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YgeaDl9XzouV for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:53:44 -0500 (EST)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 255F94A7FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:42 -0500 (EST)
Received: by mail-pj1-f74.google.com with SMTP id
 b11-20020a17090acc0b00b001a9179dc89fso2617781pju.6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:53:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Amc04gsXjzkn+vjiDgw0OgbmKYNLvSS2/kqn0hw3weE=;
 b=Be2YyTojkLCu9YEXlOJwcvNwijfwGmtrTojbG8RXAybGDqfnHBYiPKUSnvVZlfBEZH
 Xlk8JuxOCy5zDu6joNjSKNnlj4pcnHBYYjZwI/GTf+l6HScQoc/ZSoZVG9d9Lb6IwAiv
 Hd1RnT9anrnn17DoPDMNemBeNGbTh8S4c4pHFc5CZ2WFOswIARxDUv4PGNeDaWvAtDI7
 MIMCSC7obwyC1XtO1lLqbIob8WlWamA29f44TXMuYIWeNwQTks3Q5vpi/yM5Wn5hwn49
 0vCbjLY47br7WG/C1sTsj1FxRv7HllnuskXK5wrYVL2frKNoGOmoLITv9Mi+4Rl9ejPx
 eThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Amc04gsXjzkn+vjiDgw0OgbmKYNLvSS2/kqn0hw3weE=;
 b=WsBa93gjH3RUbaHrK3launaGUcb4zBqlqyl9w5OiiWt2T75urIJ0hKEss6dNyGRNQC
 PH8RshULycVa8v+bX6MtTn+QUkuuLkpMZFQZsuV1jss3aS8X8Z5wTgE9L/1t5uQf0Mfe
 dG73VQ2STkYV1uia54uGsqr61KfBKMemBVLbmQN+4HF//yMbTUoPVxpw+1i3uqaHNmro
 49nDD436XCL5G7ewH5jCkxhz2i2NmUBq95CBRnxQNyuEJpxK+6jpwouyfAr38EteUft6
 bo3fPoFqyVUlfZY0fFJJmjrLQLoWc/ivIDo5fM7FpNQ2TS241ixclaWDiYjj/rQq3i3R
 h/Sg==
X-Gm-Message-State: AOAM5322SgMI34Q+rcBe/TeFWEUBIsqFK1GORzEMNywsROhlqEDteKD0
 xkTx6Y23Nk9uVGDmYuuM+9Y1VOMzHFg=
X-Google-Smtp-Source: ABdhPJwaOePmyjg4Hc7vZIE16txaFDjohjlCKsgeQ1wSfRlTJ+Jyp/xqcbs1/JJuveMw6sbd0jRvkRvOd20=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:390c:: with SMTP id
 y12mr314836pjb.0.1637132021101; Tue, 16 Nov 2021 22:53:41 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:51 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-22-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 21/29] KVM: arm64: Introduce framework to trap disabled
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
 arch/arm64/kvm/sys_regs.c | 121 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 120 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2f96103fc0d2..501de08dacb7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -376,8 +376,38 @@ static int arm64_check_features(u64 check_types, u64 val, u64 lim)
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
+	u64	sys_val;	/* Sanitized system value */
 
 	/*
 	 * Limit value of the register for a vcpu. The value is the sanitized
@@ -410,11 +440,15 @@ struct id_reg_info {
 	/* Return the reset value of the register for the vCPU */
 	u64 (*get_reset_val)(struct kvm_vcpu *vcpu,
 			     const struct id_reg_info *id_reg);
+
+	/* Information to trap features that are disabled for the guest */
+	const struct feature_config_ctrl *(*trap_features)[];
 };
 
 static void id_reg_info_init(struct id_reg_info *id_reg)
 {
-	id_reg->vcpu_limit_val = read_sanitised_ftr_reg(id_reg->sys_reg);
+	id_reg->sys_val = read_sanitised_ftr_reg(id_reg->sys_reg);
+	id_reg->vcpu_limit_val = id_reg->sys_val;
 	if (id_reg->init)
 		id_reg->init(id_reg);
 }
@@ -952,6 +986,47 @@ static int validate_id_reg(struct kvm_vcpu *vcpu,
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
+	val = __read_id_reg(vcpu, ctrl->ftr_reg);
+	return feature_avail(ctrl, val);
+}
+
 /*
  * ARMv8.1 mandates at least a trivial LORegion implementation, where all the
  * RW registers are RES0 (which we can implement as RAZ/WI). On an ARMv8.0
@@ -1831,6 +1906,42 @@ static int reg_from_user(u64 *val, const void __user *uaddr, u64 id);
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
+	val = __read_id_reg(vcpu, id_reg->sys_reg);
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
@@ -3457,6 +3568,14 @@ int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	return write_demux_regids(uindices);
 }
 
+void kvm_vcpu_init_traps(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(id_reg_info_table); i++)
+		id_reg_features_trap_activate(vcpu, id_reg_info_table[i]);
+}
+
 /* ID register's fractional field information with its feature field. */
 struct feature_frac {
 	u32	id;
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
