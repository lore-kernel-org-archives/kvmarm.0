Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA537C433F5
	for <kvmarm@archiver.kernel.org>; Mon, 14 Feb 2022 06:59:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F4C340BDC;
	Mon, 14 Feb 2022 01:59:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q61r05hIaSyc; Mon, 14 Feb 2022 01:59:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 578F541173;
	Mon, 14 Feb 2022 01:59:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6518C40AEA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 01:59:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XwGLxv2BGpPa for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Feb 2022 01:59:44 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C42C408A7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Feb 2022 01:59:44 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 z14-20020a170902ccce00b0014d7a559635so5753335ple.16
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Feb 2022 22:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=6OEjGTSBcs9E9DCSR861EY1Iv8ylt1L45PBzbTqlbig=;
 b=lkbqq2YiEoOz++TGO9eSGDVy2tgftXNGnR0+H6WJpB+lJCJDvtMKow42G9L4fUF/od
 pgKio252qg02AwgrHRhNYR1CWBggMhWSzoArmmDelMzcIIN5+N7fpYoBVGseGIhexM2p
 lSkqlvmx5cZaNdofdlPNZa8fGOyBHoA0Pm0nIe0vbck8hYu2tho6Hq1CcR1s5/6Wn+uc
 Aj1zlzSamSCaV7cn4axUM8UAiqamPeNI0mJk5Od6Yb8gfBN0YflZX2U1oL4Nt8U1Kr5H
 XhzFpYPk+lI1OTXs5lM8jtKca9/ZVWLHZ8uBJWeggDgx/aiTRfw0mQ6k42B/i+OIw336
 ogGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=6OEjGTSBcs9E9DCSR861EY1Iv8ylt1L45PBzbTqlbig=;
 b=58N1er6JkQGeul9Y2ql5/lBPTrkindHyb7/iDlXCWHDoLJCBfQ8WyFogSHHkyasmsd
 ZZcm4LTrGnhiU7OMWBimA0trmS0DrEys0ycouKG/+R+CmHFV6B7JkLDCDu5dPLZbCd7X
 q4jafuZKjiJfDuYOSpawXqD/HMHlf6kCQNjsioSUeX+H0PNndSLcuGcCuLZZ53HE8y9k
 s+JO6KzNUE6KwKyAFHpYU1SagVtVvl/T+lz7M0PARfnHflvn980+e7IAHbOkdiTbBGhw
 EbGV62LNsoZcjLiLw/3REKgxP1+LDzlqbGpOG1P/WHbn/e4F6jG4/cH5PCW/cpupMLmR
 03ww==
X-Gm-Message-State: AOAM5307q+6VsM0C5xMsGgWnuRZDRyLR7zDLFlJbOOw0C/v4zTcsFZCq
 OY6Xd+8PRY/p8QYhEbBOD7836ka3FaM=
X-Google-Smtp-Source: ABdhPJxAahVKstmCyHWIx48Kjk5Z/Shz7FLxfutP2t3sqVVA2Gn1b8K1HKbt0o57a5EH+d4hHgCkNx0hU6E=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:902:cec9:: with SMTP id
 d9mr12377298plg.128.1644821983308; Sun, 13 Feb 2022 22:59:43 -0800 (PST)
Date: Sun, 13 Feb 2022 22:57:27 -0800
In-Reply-To: <20220214065746.1230608-1-reijiw@google.com>
Message-Id: <20220214065746.1230608-9-reijiw@google.com>
Mime-Version: 1.0
References: <20220214065746.1230608-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v5 08/27] KVM: arm64: Make ID_AA64MMFR0_EL1 writable
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
index 7032a7285447..4ed15ae7f160 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -458,6 +458,118 @@ static int validate_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+/*
+ * Check if the requested stage2 translation granule size indicated in
+ * @mmfr0 is also indicated in @mmfr0_lim.
+ * If TGranX_2 field is zero, the value must be validated based on TGranX
+ * field because that indicates the feature support is identified in
+ * TGranX field.
+ * This function relies on the fact TGranX fields are validated before
+ * through arm64_check_features_kvm.
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
+		 * validated by arm64_check_features_kvm, tgran2 must be fine.
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
@@ -549,6 +661,20 @@ static struct id_reg_info id_aa64isar1_el1_info = {
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
@@ -562,6 +688,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu, u32 id, u64 val)
-- 
2.35.1.265.g69c8d7142f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
