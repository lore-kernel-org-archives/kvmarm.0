Return-Path: <SRS0=VcQF=EX=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F1DC5519F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:17:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 589222467D
	for <kvmarm@archiver.kernel.org>; Tue, 17 Nov 2020 18:17:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="qMufXY54"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 589222467D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ECD834B8A7;
	Tue, 17 Nov 2020 13:17:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9ki42PTlMGWd; Tue, 17 Nov 2020 13:17:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F57C4B821;
	Tue, 17 Nov 2020 13:17:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23EEC4B601
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:17:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Lda5jzB2d9A8 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Nov 2020 13:17:05 -0500 (EST)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A99744B559
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 13:17:01 -0500 (EST)
Received: by mail-qk1-f202.google.com with SMTP id c18so14698281qkl.15
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Nov 2020 10:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=EZMTqnbgaQsSDAJvbG1XxJlQ79bagawpZ079qLuIDUc=;
 b=qMufXY54r9Tw35ml8YyFoPlAwDp0r3TGxMAr86L/dQTFHJDmLAygkajnXncZ6HZQ2k
 2xNFCfSX0DlCJ065rQ8Hi/6WXafc8DZpYAgTbrHNf1F1+kiPJ8hWXMEfKskS2nWCZ28N
 d6WRT972maQTo7niliiLO+H94x2r+g8fAK7s9FPaTTY/iyAoYE1MDxxbQz54qAtI0Y+m
 znuZs/tR2Yho5nq/SRXBlObO0lJOH1SQLeHUCqGq5p7mvYw44FJLW6qMUDQPvqKKmxBc
 dSxg2dX0HlCBEbRqk9LUZzg4OxnawJSbHzk/FpR0msYJGzYoMIUPRFdwMuqNJdYFlZhs
 xGnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=EZMTqnbgaQsSDAJvbG1XxJlQ79bagawpZ079qLuIDUc=;
 b=oHSOrZj0VM7BKdrRfK+lwAHlH1JI/ymO3MSoraI4YPT3b7NA26QZOXenvFYjiCvUCx
 SPca3P2xlF7M3ULZOuSg6XA9I4ltvqFKMGNLWaS7TQK7P/Wp5lwlVHd6pmgzb8sueBfA
 fsTaoh83l+IaVviJj09saOa7DvX+RjkXFity0iJLGppKwSqvnA96Lr1ncTsrfazXu0Bw
 wnA13RUEH/3G2ogeKbOV/ghe04St0i2reKjha+b10/fu5Sg3TzH1wKXw6KvcddN/3zwx
 uC1i1GITIY579UoEl4iGPLXqZahEvoraE62hd3DMw8XKJqOAS5UuGnIohvLjCMFvBo/s
 TGsA==
X-Gm-Message-State: AOAM530n3lU2lgsiYiJXWGjA6sOFf77ccgdFwgH247Wk8zFkUAwa0dWt
 dCi3eoB16jFpd2Las9uB5VhIvlgXkAH5
X-Google-Smtp-Source: ABdhPJxEnDzHoSiNaMlrXnG6cnHtgZaXnUxTO1bmEfh2lGjsMU/qzCf4IQGItC9HE+ZfEJGOV/17H4jHf0yD
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:f693:9fff:fef4:a7ef])
 (user=qperret job=sendgmr) by 2002:a05:6214:612:: with SMTP id
 z18mr817548qvw.41.1605637021225; Tue, 17 Nov 2020 10:17:01 -0800 (PST)
Date: Tue, 17 Nov 2020 18:15:58 +0000
In-Reply-To: <20201117181607.1761516-1-qperret@google.com>
Message-Id: <20201117181607.1761516-19-qperret@google.com>
Mime-Version: 1.0
References: <20201117181607.1761516-1-qperret@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [RFC PATCH 18/27] KVM: arm64: Use kvm_arch for stage 2 pgtable
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE"
 <devicetree@vger.kernel.org>, android-kvm@google.com,
 open list <linux-kernel@vger.kernel.org>, kernel-team@android.com,
 "open list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>,
 "moderated list:ARM64 PORT \(AARCH64 ARCHITECTURE\)"
 <linux-arm-kernel@lists.infradead.org>
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

In order to make use of the stage 2 pgtable code for the host stage 2,
use struct kvm_arch in lieu of struct kvm as the host will have the
former but not the latter.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 5 +++--
 arch/arm64/kvm/hyp/pgtable.c         | 6 +++---
 arch/arm64/kvm/mmu.c                 | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 45acc9dc6c45..8e8f1d2c5e0e 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -151,12 +151,13 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 /**
  * kvm_pgtable_stage2_init() - Initialise a guest stage-2 page-table.
  * @pgt:	Uninitialised page-table structure to initialise.
- * @kvm:	KVM structure representing the guest virtual machine.
+ * @arch:	Arch-specific KVM structure representing the guest virtual
+ *		machine.
  * @mm_ops:	Memory management callbacks.
  *
  * Return: 0 on success, negative error code on failure.
  */
-int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm,
+int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_arch *arch,
 			    struct kvm_pgtable_mm_ops *mm_ops);
 
 /**
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 61a8a34ddfdb..96a25d0b7b6e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -855,11 +855,11 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
-int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm,
+int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_arch *arch,
 			    struct kvm_pgtable_mm_ops *mm_ops)
 {
 	size_t pgd_sz;
-	u64 vtcr = kvm->arch.vtcr;
+	u64 vtcr = arch->vtcr;
 	u32 ia_bits = VTCR_EL2_IPA(vtcr);
 	u32 sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
 	u32 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
@@ -872,7 +872,7 @@ int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm,
 	pgt->ia_bits		= ia_bits;
 	pgt->start_level	= start_level;
 	pgt->mm_ops		= mm_ops;
-	pgt->mmu		= &kvm->arch.mmu;
+	pgt->mmu		= &arch->mmu;
 
 	/* Ensure zeroed PGD pages are visible to the hardware walker */
 	dsb(ishst);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5c2e0feb9689..384f2acc0115 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -461,7 +461,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	if (!pgt)
 		return -ENOMEM;
 
-	err = kvm_pgtable_stage2_init(pgt, kvm, &kvm_s2_mm_ops);
+	err = kvm_pgtable_stage2_init(pgt, &kvm->arch, &kvm_s2_mm_ops);
 	if (err)
 		goto out_free_pgtable;
 
-- 
2.29.2.299.gdc1121823c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
