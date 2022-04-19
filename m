Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B5ECC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 06:57:29 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F29B4B1FB;
	Tue, 19 Apr 2022 02:57:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y56TBAFDpYvH; Tue, 19 Apr 2022 02:57:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 017434B204;
	Tue, 19 Apr 2022 02:57:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDCFE49EF2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6LuUfHtDokRO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 02:57:25 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E5DC4B1ED
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 02:57:24 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 k2-20020a170902ba8200b0015613b12004so9240653pls.22
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Apr 2022 23:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=5GFeg0Qhkqt0F/Jtoeb93WWvQllcpb+IlKZnd70ZJik=;
 b=Fv4yxIMKsOfPGl1VWc42zdtocbfbfZISNCLx3NGwULK0h1JKlUIWpfnlR/UL/RRMyA
 eKMYR3vCEvPzuoFW6dKiSVM7mNuCTj58732pG3PZ8cRx/V/jpgNu+AzLyMznTWkU7AYm
 XEbug58FYBe7rIGRKQkJPaCRjF6EBPjlknVNwBqVFn/SJT1P9Opmpy/2CQpay9I+WDBe
 hZwitU1DkclcjVe3OR1Fg1KMkZ5GPGfwYoC4VNzLLHXq+DhNlaG572W/i2tRZU+M/i+i
 Wp5xaAMVEBc0q1E5xZnp3K5MrJ62+uiDQ2cSm3mL+VFCJUUn4k8M7XbGWaLgDE7OWKPp
 ttBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=5GFeg0Qhkqt0F/Jtoeb93WWvQllcpb+IlKZnd70ZJik=;
 b=qrB3Abj4Yyi64EVJ9SOA3521cJ8EAHrhBnyqX3TAvijrqIIcLwPbj3D+30dE2o5i1r
 Pxw7YrotUspncHkOBALWNpXsIhISQz+V2LXsY6+ZAaDdgWlp63bn46ANVtrw70HwOTay
 WRnLyRE11SyXk8t7j0UeuKcW/guGpgN5/w/X3ATnBDK4VUzjICYvEVN9/dizJh7l3lqQ
 MNxOzfoyy9QTRArJ7wMK4Df5nOfFwitqVSebV9Y5wpMl1Y3ASYb0IEp4m6nmoi1ACMid
 n9nONI0khVbWomTUb3MX66yQvaUCmytMrv2hIAVp+MGS6+jJ5DN4wyO4x4rc9SrUdt/7
 7wWw==
X-Gm-Message-State: AOAM532VZLldlGxBWAo2pTC5SI0MuiMeAm/GzrUGjb8Kkb6FOA7uI4F9
 Jg9MaOKbHIUCYf4aZGXm831EnXw8Cio=
X-Google-Smtp-Source: ABdhPJxWTrb+BY8xwpwyXUFdaoymj4StHXGAR+lBoWQZOnAwK6U8eNBK6/ve0byeXMAGA0OzQxHDtDdAAhc=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:9696:b0:158:f809:310e with SMTP id
 n22-20020a170902969600b00158f809310emr9827150plp.16.1650351443506; Mon, 18
 Apr 2022 23:57:23 -0700 (PDT)
Date: Mon, 18 Apr 2022 23:55:17 -0700
In-Reply-To: <20220419065544.3616948-1-reijiw@google.com>
Message-Id: <20220419065544.3616948-12-reijiw@google.com>
Mime-Version: 1.0
References: <20220419065544.3616948-1-reijiw@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v7 11/38] KVM: arm64: Make ID_AA64MMFR0_EL1 writable
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

This patch adds id_reg_desc for ID_AA64MMFR0_EL1 to make it
writable by userspace.

Since ID_AA64MMFR0_EL1 stage 2 granule size fields don't follow the
standard ID scheme, we need a special handling to validate those fields.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 133 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 133 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ba2e6dac7774..b68ae53af792 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -542,6 +542,118 @@ static int validate_id_aa64isar2_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+/*
+ * Check if the requested stage2 translation granule size indicated in
+ * @mmfr0 is also indicated in @mmfr0_lim.
+ * If TGranX_2 field is zero, the value must be validated based on TGranX
+ * field because that indicates the feature support is identified in
+ * TGranX field.
+ * This function relies on the fact TGranX fields are validated before
+ * through arm64_check_features.
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
+				     const struct id_reg_desc *id_reg, u64 val)
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
 static void init_id_aa64pfr0_el1_desc(struct id_reg_desc *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -3413,6 +3525,24 @@ static struct id_reg_desc id_aa64isar2_el1_desc = {
 	},
 };
 
+static struct id_reg_desc id_aa64mmfr0_el1_desc = {
+	.reg_desc = ID_SANITISED(ID_AA64MMFR0_EL1),
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
+	.ftr_bits = {
+		S_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_TGRAN64_SHIFT, ID_AA64MMFR0_TGRAN64_NI),
+		S_FTR_BITS(FTR_LOWER_SAFE, ID_AA64MMFR0_TGRAN4_SHIFT, ID_AA64MMFR0_TGRAN4_NI),
+	},
+};
+
 #define ID_DESC(id_reg_name, id_reg_desc)	\
 	[IDREG_IDX(SYS_##id_reg_name)] = (id_reg_desc)
 
@@ -3426,6 +3556,9 @@ static struct id_reg_desc *id_reg_desc_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	ID_DESC(ID_AA64ISAR0_EL1, &id_aa64isar0_el1_desc),
 	ID_DESC(ID_AA64ISAR1_EL1, &id_aa64isar1_el1_desc),
 	ID_DESC(ID_AA64ISAR2_EL1, &id_aa64isar2_el1_desc),
+
+	/* CRm=7 */
+	ID_DESC(ID_AA64MMFR0_EL1, &id_aa64mmfr0_el1_desc),
 };
 
 static inline struct id_reg_desc *get_id_reg_desc(u32 id)
-- 
2.36.0.rc0.470.gd361397f0d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
