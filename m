Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22144C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:52:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C014C619F6
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:52:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C014C619F6
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 65DD94B091;
	Wed, 17 Nov 2021 01:52:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4MAV6kK9mVRt; Wed, 17 Nov 2021 01:52:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 106674B0BA;
	Wed, 17 Nov 2021 01:52:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4BC34A19F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:52:52 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YmGZZahZf8mg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:52:51 -0500 (EST)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8E63E49F5D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:52:51 -0500 (EST)
Received: by mail-pf1-f201.google.com with SMTP id
 s22-20020a056a0008d600b00480fea2e96cso1127658pfu.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=NoLQttS74SYAnZZthD/shZb12TIR6ivBDSUsCWLtqtc=;
 b=CcxMAc+SL67BI3kc2oW+z3/3vhXp1OKwrkvUCJJiZR/3EX4i6JPRnvpelk7wPBPBDS
 loQ++iTRyW/M/9G24JLkAJuw/ycM5ncLFq0mQyMCSTUVGqeBf7zrkbHMcJnDBlqE7WDA
 M0NqrZxyd1gwAC+bkfO0LBziewV70xBpkp83V6vBDDoODYGupcWpnYLUjMZwiNptnv0+
 moiBG0qv/ghVnuNs3l+pGyBQv6KLsr9beO3ZYw7cPz2aV3dnnsl7fIuA0bzW3VeaHn6R
 5G0KQ4G7bYsZrSUL70BxK4/IDHV9ZLfH8YZ55x7He5r+xUnaZUzViBNFmIDDj1Ujd/Fh
 iVPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=NoLQttS74SYAnZZthD/shZb12TIR6ivBDSUsCWLtqtc=;
 b=uZ7vsluAi9LZFsa/eddnwkgl4Tg0WHSUhRMIKoceC6d8oXH4kcTuS4qizwPAlbL0Oy
 ldKxKXeUL5ZA8I8M1ymhopo+Cudd6E6Y2tCsF94Hk4ClG4imCIZMob4bIzE9o2zKL+m9
 CGqt1vkJtnAr9kuGsaPbBrPKKGrFYB/8N072KeIHqVpKdsE0G2q0V4tfMh8N5pFr1wGV
 bs3dAWbMW4ZkQBAv8IZw0GKyY8IpIno8m56U+i5JTYK66yWHtTCq+BR3d1PzddF5P4Jf
 9/tawPkPT6995jINSV+28QzlcgbYEPDe9KXFdtiAPVNFjUqPnG04gnUvrmDpIeXdACey
 N2CA==
X-Gm-Message-State: AOAM532JilrohUGKt0sycjSiLRHlqLuY8XaAKz2uJSe+wratYivaUqk5
 1Uixqewy9NA9YU0Jkl4BURlMfh1LQiw=
X-Google-Smtp-Source: ABdhPJwuLMc8Oqfj6238AuyyJCo4QKQmSwYQgaXokQqy8EDcMnL0mZW0RsTCGldUYu8oGZZPxcOr8EMF+yI=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90b:30c6:: with SMTP id
 hi6mr6846337pjb.201.1637131970736; Tue, 16 Nov 2021 22:52:50 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:38 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-9-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 08/29] KVM: arm64: Make ID_AA64MMFR0_EL1 writable
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
 arch/arm64/kvm/sys_regs.c | 118 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5812e39602fe..772e3d3067b2 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -519,6 +519,113 @@ static int validate_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+/*
+ * Check if the requested stage2 translation granule size indicated in
+ * @mmfr0 is also indicated in @mmfr0_lim.  This function assumes that
+ * the stage1 granule size indicated in @mmfr0 has been validated already.
+ */
+static int aa64mmfr0_tgran2_check(int field, u64 mmfr0, u64 mmfr0_lim)
+{
+	s64 tgran2, lim_tgran2, rtgran1;
+	int f1;
+	bool is_signed = true;
+
+	tgran2 = cpuid_feature_extract_unsigned_field(mmfr0, field);
+	lim_tgran2 = cpuid_feature_extract_unsigned_field(mmfr0_lim, field);
+	if (tgran2 == lim_tgran2)
+		return 0;
+
+	if (tgran2 && lim_tgran2)
+		return (tgran2 > lim_tgran2) ? -E2BIG : 0;
+
+	/*
+	 * Either tgran2 or lim_tgran2 is zero.
+	 * Need stage1 granule size to validate tgran2.
+	 */
+	switch (field) {
+	case ID_AA64MMFR0_TGRAN4_2_SHIFT:
+		f1 = ID_AA64MMFR0_TGRAN4_SHIFT;
+		break;
+	case ID_AA64MMFR0_TGRAN64_2_SHIFT:
+		f1 = ID_AA64MMFR0_TGRAN64_SHIFT;
+		break;
+	case ID_AA64MMFR0_TGRAN16_2_SHIFT:
+		f1 = ID_AA64MMFR0_TGRAN16_SHIFT;
+		is_signed = false;
+		break;
+	default:
+		/* Should never happen */
+		WARN_ONCE(1, "Unexpected stage2 granule field (%d)\n", field);
+		return 0;
+	}
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
@@ -625,6 +732,16 @@ static struct id_reg_info id_aa64isar1_el1_info = {
 	.get_reset_val = get_reset_id_aa64isar1_el1,
 };
 
+static struct id_reg_info id_aa64mmfr0_el1_info = {
+	.sys_reg = SYS_ID_AA64MMFR0_EL1,
+	.ftr_check_types = S_FCT(ID_AA64MMFR0_TGRAN4_SHIFT, FCT_LOWER_SAFE) |
+			   S_FCT(ID_AA64MMFR0_TGRAN64_SHIFT, FCT_LOWER_SAFE) |
+			   U_FCT(ID_AA64MMFR0_TGRAN4_2_SHIFT, FCT_IGNORE) |
+			   U_FCT(ID_AA64MMFR0_TGRAN64_2_SHIFT, FCT_IGNORE) |
+			   U_FCT(ID_AA64MMFR0_TGRAN16_2_SHIFT, FCT_IGNORE),
+	.validate = validate_id_aa64mmfr0_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -638,6 +755,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
