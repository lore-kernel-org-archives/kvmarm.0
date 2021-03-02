Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F73FC433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2FBFC64F3A
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2FBFC64F3A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D45D44B670;
	Tue,  2 Mar 2021 10:00:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I-J5-CJIBcny; Tue,  2 Mar 2021 10:00:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF3EB4B671;
	Tue,  2 Mar 2021 10:00:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B3754B64F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id njlkAitsfe1h for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:00:48 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DA304B645
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:45 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id g2so4337781wrx.20
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:00:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=G2AeCN7EWhkuYtFbkPhDKNEy1oVSwJAjORcxRM9VGLM=;
 b=Dt0TxCXfs9c8jH2bVodVvIJerD5ufsP7ZFcR78FzQli/GcMwnUQb9f1H+QfiLX46BM
 2Fb6lkOenRdyIPSYRLBFiuqS9jrfJxP3AY2xLec7qqciaO5yu+6Simfe8Mx9bfqQmGqz
 6znfOSv6M9SiQhinpKMc1WKEI0hAgIcSppjPBroVtDfipQDXbG7fAZNBsRLkK7pzwkr6
 C21ukzmfaq6LTMD814VkT42lxaZvxsN5wPoYRFXyus1F/Yi0LAthE+VMNbfcNW2LbVSb
 ms8jbMf49WD8yLYKISSizdbQgNBbKlpR2ugbE8R0HcQnaEk0BBl2KMImZCWPE3WpvvLw
 uUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=G2AeCN7EWhkuYtFbkPhDKNEy1oVSwJAjORcxRM9VGLM=;
 b=F11uwvJI3aAreUcFyINJZ1dl0KMZNHbb6go902nyTUwC1rF1SczJeTSOw3UAU0G5yJ
 TBCXko0Z8bEcG9rcjbvQIPlYQ4BJJiHWi5nTvaJCxqoa/hX4Y52mgcxhAVmKz3+c9ptT
 yJh32jtYtT+ekiRMmDdJoBEUWEWi+JtKtbFCAFFM4G/O0Y9M8XiTYbM82QmBmBB54E7Q
 VuM1cd99xxEWuk7Pa2/2RpW+FRiqdEdivK2vQ1bKKXvqN+ggPgKbKmCrwDbjSfIMWA0e
 ugWcoqvQnIDWMDZySak5sVHjvULhynT1CpTKlAS/2tpNYkhMuPd67yDgsZrNCWZKVc2E
 q16A==
X-Gm-Message-State: AOAM533Y+TR48QsybtWRSUokqFL5XExL8TU2P4WcroB0SzbI5rZgVxlu
 QqF5PR/hIiXyr7pGJPTmkykQWw1ScDtt
X-Google-Smtp-Source: ABdhPJwLj20ogsXve2nNaQuzCTevuLCR5AMDfnsGA+66q9RbQn2Lw/suoS7gkshS8KR9yQywFM1C2SmNTxIY
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:8041:: with SMTP id
 b62mr4675280wmd.0.1614697244902; Tue, 02 Mar 2021 07:00:44 -0800 (PST)
Date: Tue,  2 Mar 2021 14:59:47 +0000
In-Reply-To: <20210302150002.3685113-1-qperret@google.com>
Message-Id: <20210302150002.3685113-18-qperret@google.com>
Mime-Version: 1.0
References: <20210302150002.3685113-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 17/32] KVM: arm64: Use kvm_arch for stage 2 pgtable
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 5 +++--
 arch/arm64/kvm/hyp/pgtable.c         | 6 +++---
 arch/arm64/kvm/mmu.c                 | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 7898610fbeeb..a8255d55c168 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -162,12 +162,13 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
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
index 7ce0969203e8..3d79c8094cdd 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -879,11 +879,11 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
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
@@ -896,7 +896,7 @@ int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm *kvm,
 	pgt->ia_bits		= ia_bits;
 	pgt->start_level	= start_level;
 	pgt->mm_ops		= mm_ops;
-	pgt->mmu		= &kvm->arch.mmu;
+	pgt->mmu		= &arch->mmu;
 
 	/* Ensure zeroed PGD pages are visible to the hardware walker */
 	dsb(ishst);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9d331bf262d2..41f9c03cbcc3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -457,7 +457,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
 	if (!pgt)
 		return -ENOMEM;
 
-	err = kvm_pgtable_stage2_init(pgt, kvm, &kvm_s2_mm_ops);
+	err = kvm_pgtable_stage2_init(pgt, &kvm->arch, &kvm_s2_mm_ops);
 	if (err)
 		goto out_free_pgtable;
 
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
