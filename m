Return-Path: <SRS0=1z46=PW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE81FC4332F
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 870E56115B
	for <kvmarm@archiver.kernel.org>; Wed,  3 Nov 2021 06:28:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 870E56115B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A1F14B10A;
	Wed,  3 Nov 2021 02:28:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Jp4SJC5LuhPV; Wed,  3 Nov 2021 02:28:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D39E4B16F;
	Wed,  3 Nov 2021 02:28:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 742E74B162
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U+dxPmRJyOjV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Nov 2021 02:28:10 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16FED4B13A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Nov 2021 02:28:10 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 g36-20020a25ae64000000b005c1f46f7ee6so2709378ybe.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Nov 2021 23:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=lJ8r9zWPVVKmzZ6XSiFVL9KgUM/7kGO2C8okeqFq7iE=;
 b=GqPCo2kbDo0gSPnj0m72zxZN00OWSr6pB/bwwtdLgEnl+1CHLDmcJ7wRo2HBZZl1Uw
 VJGWlUmgdT15yGsf419qc5odq6L42fdhxeD/SceMwaKW+IJIpMb55xdO8oNMVCc+YC4f
 SPUnMH279dlDVDa4J21/pmG99XYuWQn3g9fblMyc2IXrAu3Kl1c7HVIWeA4HF7BTg1aw
 C/pdtC0RxeBplDs+nI9HpawzVghMQe8H06V2FUC9lXnZ8wLza/XlMnqDVLCn+a0Jnx0o
 vVmHmHg7dah9XVqJfLu3d7/Y8oBnftMRWwQ6gtiwA07RE9JlVNSye4iUezXitwJtiuR+
 2AvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=lJ8r9zWPVVKmzZ6XSiFVL9KgUM/7kGO2C8okeqFq7iE=;
 b=HY1O5AeFc4iJPuT6biewDnYm+tuOai1tc4/z13/l5+QLx2XrtIlMZcGlWefE0GW97s
 PZp9wZXTGpunEk1E8VofSpd+DaKvz0UDl7yqb/Zzf9OMt6UuYBrrNd/n8G5jkGRt6/Yo
 l6DfHWUO7fKXfq+F0P7wH+h95a4d0Wk7WxNq1sAa/rY69y0DvQdAj3SZ6ovSe2DIRvzD
 H/HAHr+0IOTKuHtiOcedTx8cu1o8h8oZhoWWpSZHW9TsI1WnG8Cy7hGMhH6IytnYjMv0
 hPoD8FZW4MCr6BMArmIA87iLaT9QX0lnBQyQj859zWHs5/IJyYV350CQcS96mubIM2iR
 GFBA==
X-Gm-Message-State: AOAM530vsU68GQ0IesJNMqHjxLXQw0JsOhAVZFoLguK//rvUiyRfapW5
 K5pLY7T1TSZ4w32/6E1lniIF7tOcEGE=
X-Google-Smtp-Source: ABdhPJxFZGDuaoZmZoSlnGY8V5l2x9kpOlI3wBqVBwlIEIxhhs0O0wxDwHts1tnVSjNnd+MvZ7X1wOjo66k=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a25:2395:: with SMTP id
 j143mr38737153ybj.415.1635920889503; 
 Tue, 02 Nov 2021 23:28:09 -0700 (PDT)
Date: Tue,  2 Nov 2021 23:25:01 -0700
In-Reply-To: <20211103062520.1445832-1-reijiw@google.com>
Message-Id: <20211103062520.1445832-10-reijiw@google.com>
Mime-Version: 1.0
References: <20211103062520.1445832-1-reijiw@google.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [RFC PATCH v2 09/28] KVM: arm64: Make ID_AA64MMFR0_EL1 writable
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
index 83b05d37afbd..7c1ac456dc94 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -508,6 +508,113 @@ static int validate_id_aa64isar1_el1(struct kvm_vcpu *vcpu,
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
@@ -601,6 +708,16 @@ static struct id_reg_info id_aa64isar1_el1_info = {
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
@@ -614,6 +731,7 @@ static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR0_EL1)] = &id_aa64isar0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64ISAR1_EL1)] = &id_aa64isar1_el1_info,
+	[IDREG_IDX(SYS_ID_AA64MMFR0_EL1)] = &id_aa64mmfr0_el1_info,
 };
 
 static int validate_id_reg(struct kvm_vcpu *vcpu,
-- 
2.33.1.1089.g2158813163f-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
