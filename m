Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8F4C07E95
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C98A761481
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C98A761481
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BE7F4B0BC;
	Mon, 19 Jul 2021 12:04:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MG8ZtGhrvX7e; Mon, 19 Jul 2021 12:04:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EDDB4B092;
	Mon, 19 Jul 2021 12:04:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88CDB4A5A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:04:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dE-Y3rCEHAA1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 12:03:59 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D9AA4B086
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:03:59 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 r1-20020a05600c35c1b0290223be6fd23dso2007227wmq.1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 09:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=GDqskojL7dyXpCREyAWDqO7MHA/WU9T+kxKaEf44dB0=;
 b=rZVHJk2Z0+nWKmBUX0mm3cqH9vYGulzcqpX9aqYyTTQT1WF91Ke37EurEKLmcF2DCL
 keDGWcvL5Eov7/qcjCIs3tIX0eIw8v47J+bkm4uBrX21ondXLKbqPPfETvkh3JmN2HF3
 lVQvFfjfEGWwWt7c6h7aJLYmb3uDiLRE8iD5Lu8vDIP0tbA4RgerBAn2zoxcd7EWdCIv
 EwgRukwaJ1agHHeJR5GyAzTxZG9ktl2QwQ7WvZqtSwsT0XTiFq6A1FQTVpebID91Ae9Z
 sQahfVdSSjsOIgNUF51cL7t1EEcrRajBDHGZl5vxsF1EMfXHD5Sn6PPayoPHy/NhT5zZ
 nEyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=GDqskojL7dyXpCREyAWDqO7MHA/WU9T+kxKaEf44dB0=;
 b=Mx53MYzpb/uZSCdFEN8bNQTvoNI82oZ+xdlyau+UOzWDpqb5Mc+YhFVRT9SRlnoBBQ
 vLOEOT+a6KzJheQvbn9zthnu6eKFHBOZfCT7WnzJfgPEd7h1Tcr6sdqU0TKcrcqvdGY1
 1FvZSm1pIzDv2hSquE2n/OuBteIIc2118W5IIvloHOOU6ymZIhIilN9PuQ2e7nOgBudm
 Xs6cITBL+qr55mloTr3WJe3OC8wNFOMuFNsbA5BbKlc1B/Gs8yBEdOUTMumEjMCf15uL
 4k/Cmz8/oZ7kJsi7OQ1OyfwjkgEKeYp1ti48EK4IESjA45WTO8eeIhE8d31fEg0Ai8GJ
 y5+Q==
X-Gm-Message-State: AOAM531pEUV563kzVBwf1CXdiBGTAyiWmiH2J8hj4P4Bgn3sldXY3w9u
 SqHgvvHGGw9uIQAwtWZd2wHNe+j7csAm8gViKZFWlgzfGgMBYrBiPgpLV/W0wWRw/3BZd9sKCjB
 Pwbq34yKmWFvw8Nf8pZqzdQKL0g1IB9POPHsnUSKnhdYcFdUNAzAmoFTpHQmLXglhvb0=
X-Google-Smtp-Source: ABdhPJwp/L7WERVfHFTFWu/xpgqq2mIayL4vupqwygWgiPvc5ZG2Z0+cqTWmTKkJweVf7nAnOAngrv1AQg==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:35c2:: with SMTP id
 c185mr19332555wma.73.1626710638515; 
 Mon, 19 Jul 2021 09:03:58 -0700 (PDT)
Date: Mon, 19 Jul 2021 17:03:36 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-6-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 05/15] KVM: arm64: Refactor sys_regs.h,c for nVHE reuse
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

Refactor sys_regs.h and sys_regs.c to make it easier to reuse
common code. It will be used in nVHE in a later patch.

Note that the refactored code uses __inline_bsearch for find_reg
instead of bsearch to avoid copying the bsearch code for nVHE.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/sysreg.h |  3 +++
 arch/arm64/kvm/sys_regs.c       | 30 +-----------------------------
 arch/arm64/kvm/sys_regs.h       | 31 +++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 7b9c3acba684..326f49e7bd42 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -1153,6 +1153,9 @@
 #define ICH_VTR_A3V_SHIFT	21
 #define ICH_VTR_A3V_MASK	(1 << ICH_VTR_A3V_SHIFT)
 
+/* Extract the feature specified from the feature id register. */
+#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
+
 #ifdef __ASSEMBLY__
 
 	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 80a6e41cadad..1a939c464858 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -44,10 +44,6 @@
  * 64bit interface.
  */
 
-#define reg_to_encoding(x)						\
-	sys_reg((u32)(x)->Op0, (u32)(x)->Op1,				\
-		(u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2)
-
 static bool read_from_write_only(struct kvm_vcpu *vcpu,
 				 struct sys_reg_params *params,
 				 const struct sys_reg_desc *r)
@@ -1026,8 +1022,6 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
-#define FEATURE(x)	(GENMASK_ULL(x##_SHIFT + 3, x##_SHIFT))
-
 /* Read a sanitised cpufeature ID register by sys_reg_desc */
 static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		struct sys_reg_desc const *r, bool raz)
@@ -2106,23 +2100,6 @@ static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
 	return 0;
 }
 
-static int match_sys_reg(const void *key, const void *elt)
-{
-	const unsigned long pval = (unsigned long)key;
-	const struct sys_reg_desc *r = elt;
-
-	return pval - reg_to_encoding(r);
-}
-
-static const struct sys_reg_desc *find_reg(const struct sys_reg_params *params,
-					 const struct sys_reg_desc table[],
-					 unsigned int num)
-{
-	unsigned long pval = reg_to_encoding(params);
-
-	return bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
-}
-
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu)
 {
 	kvm_inject_undefined(vcpu);
@@ -2365,13 +2342,8 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 
 	trace_kvm_handle_sys_reg(esr);
 
-	params.Op0 = (esr >> 20) & 3;
-	params.Op1 = (esr >> 14) & 0x7;
-	params.CRn = (esr >> 10) & 0xf;
-	params.CRm = (esr >> 1) & 0xf;
-	params.Op2 = (esr >> 17) & 0x7;
+	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
-	params.is_write = !(esr & 1);
 
 	ret = emulate_sys_reg(vcpu, &params);
 
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index 9d0621417c2a..cc0cc95a0280 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -11,6 +11,12 @@
 #ifndef __ARM64_KVM_SYS_REGS_LOCAL_H__
 #define __ARM64_KVM_SYS_REGS_LOCAL_H__
 
+#include <linux/bsearch.h>
+
+#define reg_to_encoding(x)						\
+	sys_reg((u32)(x)->Op0, (u32)(x)->Op1,				\
+		(u32)(x)->CRn, (u32)(x)->CRm, (u32)(x)->Op2)
+
 struct sys_reg_params {
 	u8	Op0;
 	u8	Op1;
@@ -21,6 +27,14 @@ struct sys_reg_params {
 	bool	is_write;
 };
 
+#define esr_sys64_to_params(esr)                                               \
+	((struct sys_reg_params){ .Op0 = ((esr) >> 20) & 3,                    \
+				  .Op1 = ((esr) >> 14) & 0x7,                  \
+				  .CRn = ((esr) >> 10) & 0xf,                  \
+				  .CRm = ((esr) >> 1) & 0xf,                   \
+				  .Op2 = ((esr) >> 17) & 0x7,                  \
+				  .is_write = !((esr) & 1) })
+
 struct sys_reg_desc {
 	/* Sysreg string for debug */
 	const char *name;
@@ -152,6 +166,23 @@ static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
 	return i1->Op2 - i2->Op2;
 }
 
+static inline int match_sys_reg(const void *key, const void *elt)
+{
+	const unsigned long pval = (unsigned long)key;
+	const struct sys_reg_desc *r = elt;
+
+	return pval - reg_to_encoding(r);
+}
+
+static inline const struct sys_reg_desc *
+find_reg(const struct sys_reg_params *params, const struct sys_reg_desc table[],
+	 unsigned int num)
+{
+	unsigned long pval = reg_to_encoding(params);
+
+	return __inline_bsearch((void *)pval, table, num, sizeof(table[0]), match_sys_reg);
+}
+
 const struct sys_reg_desc *find_reg_by_id(u64 id,
 					  struct sys_reg_params *params,
 					  const struct sys_reg_desc table[],
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
