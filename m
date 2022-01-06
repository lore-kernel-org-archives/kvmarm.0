Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D35C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 04:28:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90B7F49F06;
	Wed,  5 Jan 2022 23:28:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gHaV9nUyV88q; Wed,  5 Jan 2022 23:28:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3056D49ED3;
	Wed,  5 Jan 2022 23:28:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C431A49E27
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VXrICKIUvzm7 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 23:28:43 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 67F2A49E10
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:43 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 w189-20020a6262c6000000b004ba80a30727so951263pfb.1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 20:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=FYAWMgJ1GXCK4xG/yft+copCnvq5I5zKK2PH7FlAtFI=;
 b=c3B8anzf3EjmHy/jCcSXnzExaealsFE90+zm5dPK8RfPwdtLHPsmDrhrl8Jq8l4p42
 4CrectJilOzE8B8CSPN93kKROQ+b/CnT4ema6ozQCfYn0PVTHRAYVuTNhKUaHDsYBCq2
 Gl4kfBLLIz8gznaiJVxIkmqXs1kaK8FUjrLen0jqr0dzqiU3XGUk9sQWfilPY+wqaMUY
 Z9onCQlOGXH0tli3k2JzkTyxFD44B99wptWvoWKxfxPvJnN78LvM17UR/MFVtatiWWrv
 opIkNROcLQMaRVeEkonSnD8pcOGHDgChkjMfhqkLBtWztB9FqnGip35kC01NP8LA3R9q
 JEuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=FYAWMgJ1GXCK4xG/yft+copCnvq5I5zKK2PH7FlAtFI=;
 b=IYXI5yrMN+9MKAAxKH/jII7+8hmu6Q2VN+914GssvXpWuyNLdwsW/hLm/MQwr49Ls+
 JEbRKpZJNitR3HqL0CyrpHOP65GuIOFmPN3t5XHTbOVh7fniXn27Q6g/kF5y6lDAghHR
 qILjtwqGRAXldmbf/ipobJbQJJ0Mf1V9Zu+m2BHGHcPHWxL9GilxwtCUYAxotTV9svAU
 ZEyAbV8/uq9VoQkpic04fBr7tvFyLlxUtBWLMmWjdNTCAniF/G9XTnBMew9KbtHP14+k
 fOAIR7ox+yKNvNUJf7g/Z91hntrnSk+vjLMLNd0EpfeJSy/2guJXZQI2iScGcDg/AEFB
 MspA==
X-Gm-Message-State: AOAM530NQGOWEy5YAKwtnED7t+tfVA/kjEk2f2off1vaQW01635yyAcn
 Tmfw2oMI4i5Rj3JUu/Nd8LlVdfbjbcU=
X-Google-Smtp-Source: ABdhPJx4nw8sDxazxfcaU4f//9EHhcIyYEvher1FjW1hqgePsRXhREI6VNvfCeeMk32TK/65KntSJX+t0P0=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:604f:: with SMTP id
 h15mr7980595pjm.87.1641443322615; Wed, 05 Jan 2022 20:28:42 -0800 (PST)
Date: Wed,  5 Jan 2022 20:26:50 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-9-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 08/26] KVM: arm64: Make ID_AA64MMFR0_EL1 writable
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

This patch adds id_reg_info for ID_AA64MMFR0_EL1 to make it
writable by userspace.

Since ID_AA64MMFR0_EL1 stage 2 granule size fields don't follow the
standard ID scheme, we need a special handling to validate those fields.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 127 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 127 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2f79997016a4..723910267966 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -445,6 +445,118 @@ static int validate_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+/*
+ * Check if the requested stage2 translation granule size indicated in
+ * @mmfr0 is also indicated in @mmfr0_lim.
+ * If TGranX_2 field is zero, the value must be validated based on TGranX
+ * field because that indicates the feature support is identified in
+ * TGranX field.
+ * This function relies on the fact TGranX fields are validated before
+ * through the arm64_check_features.
+ */
+static int aa64mmfr0_tgran2_check(int field, u64 mmfr0, u64 mmfr0_lim)
+{
+	s64 tgran2, lim_tgran2, rtgran1;
+	int f1;
+	bool is_signed;
+
+	tgran2 = cpuid_feature_extract_unsigned_field(mmfr0, field);
+	lim_tgran2 = cpuid_feature_extract_unsigned_field(mmfr0_lim, field);
+	if (tgran2 && lim_tgran2)
+		/*
+		 * We don't need to check TGranX field. We can simply
+		 * compare tgran2 and lim_tgran2.
+		 */
+		return (tgran2 > lim_tgran2) ? -E2BIG : 0;
+
+	if (tgran2 == lim_tgran2)
+		/*
+		 * Both of them are zero.  Since TGranX in @mmfr0 is already
+		 * validated by arm64_check_features, tgran2 must be fine.
+		 */
+		return 0;
+
+	/*
+	 * Either tgran2 or lim_tgran2 is zero.
+	 * Need stage1 granule size to validate tgran2.
+	 */
+
+	/*
+	 * Get TGranX's bit position by subtracting 12 from TGranX_2's bit
+	 * position.
+	 */
+	f1 = field - 12;
+
+	/* TGran4/TGran64 is signed and TGran16 is unsigned field. */
+	is_signed = (f1 == ID_AA64MMFR0_TGRAN16_SHIFT) ? false : true;
+
+	/*
+	 * If tgran2 == 0 (&& lim_tgran2 != 0), the requested stage2 granule
+	 * size is indicated in the stage1 granule size field of @mmfr0.
+	 * So, validate the stage1 granule size against the stage2 limit
+	 * granule size.
+	 * If lim_tgran2 == 0 (&& tgran2 != 0), the stage2 limit granule size
+	 * is indicated in the stage1 granule size field of @mmfr0_lim.
+	 * So, validate the requested stage2 granule size against the stage1
+	 * limit granule size.
+	 */
+
+	 /* Get the relevant stage1 granule size to validate tgran2 */
+	if (tgran2 == 0)
+		/* The requested stage1 granule size */
+		rtgran1 = cpuid_feature_extract_field(mmfr0, f1, is_signed);
+	else /* lim_tgran2 == 0 */
+		/* The stage1 limit granule size */
+		rtgran1 = cpuid_feature_extract_field(mmfr0_lim, f1, is_signed);
+
+	/*
+	 * Adjust the value of rtgran1 to compare with stage2 granule size,
+	 * which indicates: 1: Not supported, 2: Supported, etc.
+	 */
+	if (is_signed)
+		/* For signed, -1: Not supported, 0: Supported, etc. */
+		rtgran1 += 0x2;
+	else
+		/* For unsigned, 0: Not supported, 1: Supported, etc. */
+		rtgran1 += 0x1;
+
+	if ((tgran2 == 0) && (rtgran1 > lim_tgran2))
+		/*
+		 * The requested stage1 granule size (== the requested stage2
+		 * granule size) is larger than the stage2 limit granule size.
+		 */
+		return -E2BIG;
+	else if ((lim_tgran2 == 0) && (tgran2 > rtgran1))
+		/*
+		 * The requested stage2 granule size is larger than the stage1
+		 * limit granulze size (== the stage2 limit granule size).
+		 */
+		return -E2BIG;
+
+	return 0;
+}
+
+static int validate_id_aa64mmfr0_el1(struct kvm_vcpu *vcpu,
+				     const struct id_reg_info *id_reg, u64 val)
+{
+	u64 limit = id_reg->vcpu_limit_val;
+	int ret;
+
+	ret = aa64mmfr0_tgran2_check(ID_AA64MMFR0_TGRAN4_2_SHIFT, val, limit);
+	if (ret)
+		return ret;
+
+	ret = aa64mmfr0_tgran2_check(ID_AA64MMFR0_TGRAN64_2_SHIFT, val, limit);
+	if (ret)
+		return ret;
+
+	ret = aa64mmfr0_tgran2_check(ID_AA64MMFR0_TGRAN16_2_SHIFT, val, limit);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -536,6 +648,20 @@ static struct id_reg_info id_aa64isar1_el1_info = {
 	.vcpu_mask = vcpu_mask_id_aa64isar1_el1,
 };
 
+static struct id_reg_info id_aa64mmfr0_el1_info = {
+	.sys_reg = SYS_ID_AA64MMFR0_EL1,
+	/*
+	 * When TGranX_2 value is 0, validity of the value depend on TGranX
+	 * value, and TGranX_2 value must be validated against TGranX value,
+	 * which is done by validate_id_aa64mmfr0_el1.
+	 * So, skip the regular validity checking for TGranX_2 fields.
+	 */
+	.ignore_mask = ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN4_2) |
+		       ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN64_2) |
+		       ARM64_FEATURE_MASK(ID_AA64MMFR0_TGRAN16_2),
+	.validate = validate_id_aa64mmfr0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -549,6 +675,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
-- 
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
