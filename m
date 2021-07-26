Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93762C4338F
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 20B8460F4C
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 20B8460F4C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BA59249F5F;
	Mon, 26 Jul 2021 05:29:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RgHcJ4HfKnop; Mon, 26 Jul 2021 05:29:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 96B174A4A0;
	Mon, 26 Jul 2021 05:29:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C197449F5D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h6ZTQI03757s for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 05:29:18 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ABBEC4A2E5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:18 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 25-20020a05600c0219b029024ebb12928cso2266321wmi.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 02:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=q1zqD73fJkFVmAAq4dO3uZVcGUuPFE+HczOzBsWKqIA=;
 b=MGESZEF7diylBA6Kx1cQU7HsTAr2Dx3Sx2H/5ckbKa1+lNzUwqXNq3+HyK7pQ7t+79
 GdSkBeHZk2on8PnJvvmF7eeNr3gYvaA4hb2R/vEdxFXLjdIYQMs6dXGIAgcJKAFuJuvk
 9YIEBUcgIAThdYkh3hLGPnW+J4a2ufP8TaR5xvj7I7smpbQd6k81PXyf0wIvDOjPHSnO
 GsUi68byOHXQ1RiabG7/pQ9xq3UZP89oLuQwZsRgH0Szp0DpmeIOIEA518pldBB0RMru
 b5fxHNLKCpJtoYgrOEFncCNUgrmp+YvtHf1zA5RkIxmDYe9WMiYoGQg0yzNbKzMtuKKm
 B4xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=q1zqD73fJkFVmAAq4dO3uZVcGUuPFE+HczOzBsWKqIA=;
 b=Qoh/hARaPR2HueCGK6NK/mTgnEJXX/If8J07ACH4h4U5Kg+qLwuXVSvOzdVGpskV5p
 m327RZlmHAZOM6W2gbxubn9mGUAo0hEnYtYXaI2Jdx0097+W/xjcPC7LyauiDbvl6SaB
 dktLjmI5F0Wn13g+2qX8FJ0W/iRfRGBrTYs6PZDcwzawOXVUjP5GBZXSlL4Bbs4ebvs2
 /p+RthQqA8AG6EdJScM/nn7bByAtuvenk0N83qB7q2upF+0GRov5Vkn7RCf34b8X1UwX
 TulNxrmXUw7RoIjS0qqJV5vTQOX6Uhf3abGMrRqcedDikTdMc2Bnzup3sFAh+SGXXT3T
 Vr6A==
X-Gm-Message-State: AOAM533KZKQSB6rwfoxUsaKpaEX+h8VXHn/aEOhyMQ5/5yLJCXZEmZdB
 INV6lYI2vWxu53U5/0VfiOrC7uz+NUe1
X-Google-Smtp-Source: ABdhPJx1wCuqsWbjKEjDSr1O9R264wGcMnHVqFdGsLki/Uzi81IzUAaHKQtIg2C1kDCAaUPziAz6p3UcRgZ0
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:23a0:2f14:433:e6cb])
 (user=qperret job=sendgmr) by 2002:a05:6000:120f:: with SMTP id
 e15mr17783536wrx.399.1627291757591; Mon, 26 Jul 2021 02:29:17 -0700 (PDT)
Date: Mon, 26 Jul 2021 10:28:52 +0100
In-Reply-To: <20210726092905.2198501-1-qperret@google.com>
Message-Id: <20210726092905.2198501-4-qperret@google.com>
Mime-Version: 1.0
References: <20210726092905.2198501-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 03/16] KVM: arm64: Expose page-table helpers
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Cc: qwandor@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
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

The KVM pgtable API exposes the kvm_pgtable_walk() function to allow
the definition of walkers outside of pgtable.c. However, it is not easy
to implement any of those walkers without some of the low-level helpers.
Move some of them to the header file to allow re-use from other places.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 27 +++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 26 --------------------------
 2 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 082b9d65f40b..5a7a13bbd4a1 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -25,6 +25,33 @@ static inline u64 kvm_get_parange(u64 mmfr0)
 
 typedef u64 kvm_pte_t;
 
+#define KVM_PTE_VALID			BIT(0)
+
+static inline bool kvm_pte_valid(kvm_pte_t pte)
+{
+	return pte & KVM_PTE_VALID;
+}
+
+static inline u64 kvm_granule_shift(u32 level)
+{
+	/* Assumes KVM_PGTABLE_MAX_LEVELS is 4 */
+	return ARM64_HW_PGTABLE_LEVEL_SHIFT(level);
+}
+
+static inline u64 kvm_granule_size(u32 level)
+{
+	return BIT(kvm_granule_shift(level));
+}
+
+static inline bool kvm_level_supports_block_mapping(u32 level)
+{
+	/*
+	 * Reject invalid block mappings and don't bother with 4TB mappings for
+	 * 52-bit PAs.
+	 */
+	return !(level == 0 || (PAGE_SIZE != SZ_4K && level == 1));
+}
+
 /**
  * struct kvm_pgtable_mm_ops - Memory management callbacks.
  * @zalloc_page:		Allocate a single zeroed memory page.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 78f36bd5df6c..2c5d4d3e31cc 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -11,7 +11,6 @@
 #include <asm/kvm_pgtable.h>
 #include <asm/stage2_pgtable.h>
 
-#define KVM_PTE_VALID			BIT(0)
 
 #define KVM_PTE_TYPE			BIT(1)
 #define KVM_PTE_TYPE_BLOCK		0
@@ -61,17 +60,6 @@ struct kvm_pgtable_walk_data {
 	u64				end;
 };
 
-static u64 kvm_granule_shift(u32 level)
-{
-	/* Assumes KVM_PGTABLE_MAX_LEVELS is 4 */
-	return ARM64_HW_PGTABLE_LEVEL_SHIFT(level);
-}
-
-static u64 kvm_granule_size(u32 level)
-{
-	return BIT(kvm_granule_shift(level));
-}
-
 #define KVM_PHYS_INVALID (-1ULL)
 
 static bool kvm_phys_is_valid(u64 phys)
@@ -79,15 +67,6 @@ static bool kvm_phys_is_valid(u64 phys)
 	return phys < BIT(id_aa64mmfr0_parange_to_phys_shift(ID_AA64MMFR0_PARANGE_MAX));
 }
 
-static bool kvm_level_supports_block_mapping(u32 level)
-{
-	/*
-	 * Reject invalid block mappings and don't bother with 4TB mappings for
-	 * 52-bit PAs.
-	 */
-	return !(level == 0 || (PAGE_SIZE != SZ_4K && level == 1));
-}
-
 static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
 {
 	u64 granule = kvm_granule_size(level);
@@ -135,11 +114,6 @@ static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
 	return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
 }
 
-static bool kvm_pte_valid(kvm_pte_t pte)
-{
-	return pte & KVM_PTE_VALID;
-}
-
 static bool kvm_pte_table(kvm_pte_t pte, u32 level)
 {
 	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
