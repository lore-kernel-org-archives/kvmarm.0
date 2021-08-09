Return-Path: <SRS0=yt8/=NA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46337C432BE
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D6BD86101D
	for <kvmarm@archiver.kernel.org>; Mon,  9 Aug 2021 15:25:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D6BD86101D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 72E324B0EB;
	Mon,  9 Aug 2021 11:25:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id za5rHMJwvuYz; Mon,  9 Aug 2021 11:25:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A37D4B109;
	Mon,  9 Aug 2021 11:25:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FD324A319
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id A419xFDIxk7F for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Aug 2021 11:25:02 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 905454B0EF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Aug 2021 11:25:02 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 c196-20020ae9edcd0000b02903c9e325c3b2so12699052qkg.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 Aug 2021 08:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=nXWh1aBsmvvArSdynKqs/F6MGOyla+y37XGDQDAw0Zw=;
 b=cYfnUsIb5gGe+lWEdMn95RmDSxRUQoPfJdok4pDTRDFpRWfOU0ggbk9mfKP2zsxOUh
 GscOCxW3U2TBjao5XjoBagZImLZH1sNAULkmo2jw8VpjVzlpCivcuhOuCZwZPuvY+KCl
 hAD2kr6od+cAD1+GqOldj1CvFuTxUb7B8NZ51j4ufwBiHfiW6Tm4JyHxRwYCziDocagZ
 uoFADrALl5V/33jTieDKrHukSUoZfweS5IakvG1sJ5RrSD7eHFpVjbt0/Fh1sSvEF3c2
 KqkKTxt+xL7wbhcTpQUvE+6MzgrWIlXHS4E06USqLnvqPIi0HL3+gAKM1SKKoqlrQGdF
 8UsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=nXWh1aBsmvvArSdynKqs/F6MGOyla+y37XGDQDAw0Zw=;
 b=dDUYKtzY4k4DxTspOagoXlyp8n2z0D3rZbUH/wqwfooiQeXu0VV0F1oNx4X/1uyw75
 YZeNZj8RpVZjk5q/MGbT0PO4wb1htePSRrYUCbX5sIqcykpM4Xn8ejv6D9k10bI4K7HB
 zgb+VggCbds5QAnKWW++O81ec8FKtbeIU53V4YtPIx+oeU4bEJegd9fub41tFdQUn+IU
 LLmDQPWWBi7Bect0wZkJfMVrY8D8+SK0cz3RZjnNCwdILhaGrJYWscPmMKlhV1NLmTKN
 JsgC7p4XD1T3l14tx2E/9VRFelbaYO5hFWq+JaQXgHov6N6k3AWEF+2bnbrN0xjawrSy
 u+2g==
X-Gm-Message-State: AOAM5301xQ53GkAI2iF5teSklZUnxJDcGH8C5YwBfHwzdg2yR+ZLpNpl
 UNEj0mIVilYUk5cjdFJT8a9N6E7/Oaq/
X-Google-Smtp-Source: ABdhPJzInJfMmMfgDqEILlYqnmWDME8lUUPA1VgIQarM5NixXRbdPCHLe8fmcxdPmKC8j+G1kAF2nZVLpZyc
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:b0e8:d460:758b:a0ae])
 (user=qperret job=sendgmr) by 2002:a0c:fe6a:: with SMTP id
 b10mr24245399qvv.6.1628522702203; Mon, 09 Aug 2021 08:25:02 -0700 (PDT)
Date: Mon,  9 Aug 2021 16:24:32 +0100
In-Reply-To: <20210809152448.1810400-1-qperret@google.com>
Message-Id: <20210809152448.1810400-6-qperret@google.com>
Mime-Version: 1.0
References: <20210809152448.1810400-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v4 05/21] KVM: arm64: Expose page-table helpers
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
 arch/arm64/include/asm/kvm_pgtable.h | 40 ++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 39 ---------------------------
 2 files changed, 40 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 082b9d65f40b..6938eac72c1f 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -25,6 +25,46 @@ static inline u64 kvm_get_parange(u64 mmfr0)
 
 typedef u64 kvm_pte_t;
 
+#define KVM_PTE_VALID			BIT(0)
+
+#define KVM_PTE_ADDR_MASK		GENMASK(47, PAGE_SHIFT)
+#define KVM_PTE_ADDR_51_48		GENMASK(15, 12)
+
+static inline bool kvm_pte_valid(kvm_pte_t pte)
+{
+	return pte & KVM_PTE_VALID;
+}
+
+static inline u64 kvm_pte_to_phys(kvm_pte_t pte)
+{
+	u64 pa = pte & KVM_PTE_ADDR_MASK;
+
+	if (PAGE_SHIFT == 16)
+		pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
+
+	return pa;
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
index 78f36bd5df6c..49d768b92997 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -11,16 +11,12 @@
 #include <asm/kvm_pgtable.h>
 #include <asm/stage2_pgtable.h>
 
-#define KVM_PTE_VALID			BIT(0)
 
 #define KVM_PTE_TYPE			BIT(1)
 #define KVM_PTE_TYPE_BLOCK		0
 #define KVM_PTE_TYPE_PAGE		1
 #define KVM_PTE_TYPE_TABLE		1
 
-#define KVM_PTE_ADDR_MASK		GENMASK(47, PAGE_SHIFT)
-#define KVM_PTE_ADDR_51_48		GENMASK(15, 12)
-
 #define KVM_PTE_LEAF_ATTR_LO		GENMASK(11, 2)
 
 #define KVM_PTE_LEAF_ATTR_LO_S1_ATTRIDX	GENMASK(4, 2)
@@ -61,17 +57,6 @@ struct kvm_pgtable_walk_data {
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
@@ -79,15 +64,6 @@ static bool kvm_phys_is_valid(u64 phys)
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
@@ -135,11 +111,6 @@ static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
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
@@ -151,16 +122,6 @@ static bool kvm_pte_table(kvm_pte_t pte, u32 level)
 	return FIELD_GET(KVM_PTE_TYPE, pte) == KVM_PTE_TYPE_TABLE;
 }
 
-static u64 kvm_pte_to_phys(kvm_pte_t pte)
-{
-	u64 pa = pte & KVM_PTE_ADDR_MASK;
-
-	if (PAGE_SHIFT == 16)
-		pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
-
-	return pa;
-}
-
 static kvm_pte_t kvm_phys_to_pte(u64 pa)
 {
 	kvm_pte_t pte = pa & KVM_PTE_ADDR_MASK;
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
