Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E4DC4332F
	for <kvmarm@archiver.kernel.org>; Thu,  6 Jan 2022 04:28:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EDD9349E4A;
	Wed,  5 Jan 2022 23:28:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 19+6h4xd07Lh; Wed,  5 Jan 2022 23:28:53 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C928449F19;
	Wed,  5 Jan 2022 23:28:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09B9C49EEE
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Argp0F3T3F0c for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jan 2022 23:28:50 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A875A49F2D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jan 2022 23:28:49 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 u13-20020a17090a450d00b001b1e6726fccso4037466pjg.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 05 Jan 2022 20:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=dNkIY86roqvUs5KX8m9clWmkcxYrW6AP5WIcgyGoEyo=;
 b=Nzz+VxZf/lB+zPH+PqKajDHFdhn1JdeZEJzsLwwupGArmVBXhQe8QQ6qGhWt75yn9t
 9co4L/J1Cpeuu7gKqT324yGMZT4umFYWyo0isuQcHr5O4v9gzUFT3O4qItVmPBTL7EIW
 fFYSl2PSQWPoAz7jUX0y1q2OA3cOXIAl11SzYbaF1wlewoIEqaouLdYkAEbdnfafS6+3
 oWTziBOVd1zgc7moWOkVZlqhU+qy2foHjOB6xa+G6PnKXNLPufGgtngqcFKWTH0XvIVz
 ZZZxGOqCGZfn/WVwYWEyOqqyk+6bFUudMia2RSJq/RZb1brUNXzAPfGMXdCKJA3JGyk9
 j+0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=dNkIY86roqvUs5KX8m9clWmkcxYrW6AP5WIcgyGoEyo=;
 b=M98ISuTYdf1G2Tv8YvxEun8i4DsZbVBWZbOIbeC0+0jiNY1V2gSFONDqcwqFrByb8h
 WbWnnlOJZpxr/XjO2pDVQttGD9d3ERBZXU9Qwy3hjNQt9lAB3akNQhdDPptuE33z032H
 neaY67MapYcUlxJW/PJbXuTKl7PKxTMrNVgQORklhSHF43KTOOXT3CogUmDKgEULY8tu
 jSUNtNDrLG/1rslWcbj0VXm79lXYX/F31P60pyiR+FM2phaW4vzeHnUr3foTlRngO+y2
 s+9jbggAAI4zOyjdJxDIZrL8+UoISiFhWgnVL7FC1zKORYRfcDUzKlV5LRoaX16u2Kw1
 Tukw==
X-Gm-Message-State: AOAM531iCMxJjutMb6EOwXDfcIVcq/76iOv+UUNnXO8ZyHR0GV28uSvm
 sLCdbn1Zs6fSrGDjmcHvpCN48Au7GbI=
X-Google-Smtp-Source: ABdhPJx6ej0/VULi52k2Cisyjwi/BQ1mJqWpnqSt57jvJErT5sSc3j4wqzqGEgzikXKJrB0iKnva8GTQ0Ws=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:5d8d:: with SMTP id
 t13mr7987455pji.47.1641443328938; Wed, 05 Jan 2022 20:28:48 -0800 (PST)
Date: Wed,  5 Jan 2022 20:26:54 -0800
In-Reply-To: <20220106042708.2869332-1-reijiw@google.com>
Message-Id: <20220106042708.2869332-13-reijiw@google.com>
Mime-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v4 12/26] KVM: arm64: Make MVFR1_EL1 writable
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
index 1707c7832593..1c18a19c5785 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -617,6 +617,36 @@ static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
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
@@ -774,6 +804,11 @@ static struct id_reg_info id_dfr0_el1_info = {
 	.vcpu_mask = vcpu_mask_id_dfr0_el1,
 };
 
+static struct id_reg_info mvfr1_el1_info = {
+	.sys_reg = SYS_MVFR1_EL1,
+	.validate = validate_mvfr1_el1,
+};
+
 /*
  * An ID register that needs special handling to control the value for the
  * guest must have its own id_reg_info in id_reg_info_table.
@@ -784,6 +819,7 @@ static struct id_reg_info id_dfr0_el1_info = {
 #define	GET_ID_REG_INFO(id)	(id_reg_info_table[IDREG_IDX(id)])
 static struct id_reg_info *id_reg_info_table[KVM_ARM_ID_REG_MAX_NUM] = {
 	[IDREG_IDX(SYS_ID_DFR0_EL1)] = &id_dfr0_el1_info,
+	[IDREG_IDX(SYS_MVFR1_EL1)] = &mvfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] = &id_aa64pfr0_el1_info,
 	[IDREG_IDX(SYS_ID_AA64PFR1_EL1)] = &id_aa64pfr1_el1_info,
 	[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] = &id_aa64dfr0_el1_info,
-- 
2.34.1.448.ga2b2bfdf31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
