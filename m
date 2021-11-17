Return-Path: <SRS0=Jx+E=QE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5103C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D82E63231
	for <kvmarm@archiver.kernel.org>; Wed, 17 Nov 2021 06:53:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4D82E63231
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03AF6406E7;
	Wed, 17 Nov 2021 01:53:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fryFIQkmQFuY; Wed, 17 Nov 2021 01:53:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DCE234B12E;
	Wed, 17 Nov 2021 01:53:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8ACA04A7FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Xs+s21cobQg9 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Nov 2021 01:53:31 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 853ED406E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Nov 2021 01:53:31 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 b8-20020a17090a10c800b001a61dff6c9dso771826pje.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Nov 2021 22:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=yLVjb77owO5ybb+blXdLB2u8TBEDp8SiZFpXOiEwz6E=;
 b=fDzUBhciz6ab1h3rP9Ucku2G59ZHon7OMlm9GJaTcxGw2QIj3w2oxTr1XbvW+YZGLK
 7wlw21isyxEL1SzBvtRO/6hdnL6njQInjzEyBb2El4SNEGGElu1d4+EsGvx58kgvAnZM
 8Gz4R4bDwans0su5HW0IxJMKTcNsIDR45GF3PbE/M5ON0BtbzheJDgH3qDgKegWzIKAT
 tFxMfu1B4/TO71tiG8E2e62rlo237Abtbxy+MpcnGSQV+Xh+nRNyk7K2+ULWma3kgQDz
 O01BmklYF4syu1w6IWWxuSSa6AoJyckwb7/7v5xiN3vqEvebFLzUrS3vaFD+4jTLJLsA
 5Yxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=yLVjb77owO5ybb+blXdLB2u8TBEDp8SiZFpXOiEwz6E=;
 b=YWK1uvgfTYmccDFXm2AGoEdLvT8+TaYC4JLtIMbUoQqQzEAEKJvrmg+nHlNcJioi/h
 3yUVcJ8Fv6vHTYqhNlzNASJ+2nDCs0671ZHISjIow8vijz+OXJKjenZ3ifSRPHjxI9j4
 NYpCS37h0iC47x+WafdIEHN5o12kwX+3nA8ZoDakn2aXxBoQVHxkgdnxdI7Ee3yAqh/A
 QClce9YESBW3si+bgDo1EV0TRdYW8KdxqkOSEm36mNrbIxynzFJ692clGbM1Xp55InRi
 FamrKqPaFOo3s0HSTifb6vG0GOX0HY3PGLRWvMOeYTQJT3TIRTJ2gNaWC8jFZ99yHsTH
 30PQ==
X-Gm-Message-State: AOAM531c2HdmHhCWOuiGG1B2ndoEGmt/4O2UBdiRuX9CknoXkc47ig49
 aYfk4UhXoa5tLdCPrQyGW4eekk0a9t4=
X-Google-Smtp-Source: ABdhPJwT4TE1Cp4Q7rnEHEKQedPKGeSfrSxBPQGD89L53thUMmYvU82rt7nCRoE3lbp7K0eH1lqvYb0pO6M=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr314180pjf.1.1637132010579; Tue, 16 Nov 2021 22:53:30 -0800 (PST)
Date: Tue, 16 Nov 2021 22:43:44 -0800
In-Reply-To: <20211117064359.2362060-1-reijiw@google.com>
Message-Id: <20211117064359.2362060-15-reijiw@google.com>
Mime-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [RFC PATCH v3 14/29] KVM: arm64: Make MVFR1_EL1 writable
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

This patch adds id_reg_info for MVFR1_EL1 to make it writable
by userspace.

There are only a few valid combinations of values that can be set
for FPHP and SIMDHP fields according to Arm ARM.  Return an error
when userspace tries to set those fields to values that don't match
any of the valid combinations.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 5b16d422b37d..659ec880d527 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -686,6 +686,36 @@ static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int validate_mvfr1_el1(struct kvm_vcpu *vcpu,
+			      const struct id_reg_info *id_reg, u64 val)
+{
+	unsigned int fphp, simdhp;
+	struct fphp_simdhp {
+		unsigned int fphp;
+		unsigned int simdhp;
+	};
+	/* Permitted fphp/simdhp value combinations according to Arm ARM */
+	struct fphp_simdhp valid_fphp_simdhp[3] = {{0, 0}, {2, 1}, {3, 2}};
+	int i;
+	bool is_valid_fphp_simdhp = false;
+
+	fphp = cpuid_feature_extract_unsigned_field(val, MVFR1_FPHP_SHIFT);
+	simdhp = cpuid_feature_extract_unsigned_field(val, MVFR1_SIMDHP_SHIFT);
+
+	for (i = 0; i < ARRAY_SIZE(valid_fphp_simdhp); i++) {
+		if (valid_fphp_simdhp[i].fphp == fphp &&
+		    valid_fphp_simdhp[i].simdhp == simdhp) {
+			is_valid_fphp_simdhp = true;
+			break;
+		}
+	}
+
+	if (!is_valid_fphp_simdhp)
+		return -EINVAL;
+
+	return 0;
+}
+
 static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
 {
 	u64 limit = id_reg->vcpu_limit_val;
@@ -870,6 +900,11 @@ static struct id_reg_info id_mmfr0_el1_info = {
 			   S_FCT(ID_MMFR0_OUTERSHR_SHIFT, FCT_LOWER_SAFE),
 };
 
+static struct id_reg_info mvfr1_el1_info = {
+	.sys_reg = SYS_MVFR1_EL1,
+	.validate = validate_mvfr1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -881,6 +916,7 @@ static struct id_reg_info id_mmfr0_el1_info = {
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
 	[IDREG_IDX(SYS_ID_MMFR0_EL1)] = &id_mmfr0_el1_info,
+	[IDREG_IDX(SYS_MVFR1_EL1)] = &mvfr1_el1_info,
 	[IDREG_IDX(SYS_ID_DFR1_EL1)] = &id_dfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
-- 
2.34.0.rc1.387.gb447b232ab-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
