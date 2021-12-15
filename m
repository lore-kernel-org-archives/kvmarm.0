Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8121C433FE
	for <kvmarm@archiver.kernel.org>; Wed, 15 Dec 2021 16:12:49 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BD794B159;
	Wed, 15 Dec 2021 11:12:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SHqYfkUNP8lj; Wed, 15 Dec 2021 11:12:48 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 147B64B1C0;
	Wed, 15 Dec 2021 11:12:48 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C74874B0D6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 11:12:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oRFY-QOc2JRk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Dec 2021 11:12:45 -0500 (EST)
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com
 [209.85.208.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 10A504B1C9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 11:12:45 -0500 (EST)
Received: by mail-ed1-f73.google.com with SMTP id
 eg20-20020a056402289400b003eb56fcf6easo20515369edb.20
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 08:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=9UncJz09b52+rulxMEJfzwQAU0lESQ6s/aE8Lup77NM=;
 b=IoTXNcUh80VkspkGKEhVZPGmIgfwuEX2hfWC85I6z4BP91X7qiSyJSelcdBwSw1+z/
 ENHIv3PJ0avwndy5ipE//qEnaQSgTyXUbFnvdFYPJ9WV487qISa/CYlxv4wvG7jxgNnE
 uklhvdl0bjLKzKwujXWYoEg5w88I7O1+ks77TzECjDlQ/E56agN6hwB7e7EumJx7le6e
 IkHpzTlXUq/uxD56jvtOXsS+joBN2L8q4BTBmur++c6puzfe6OlwiQeG1wD2kPS6Abtc
 277ohHjDPdJuIij7EWGEkECn+V/zDZqYSe3KMBnaE+mIXvhyAxJf4mZl27WNdzb0jUEC
 03xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=9UncJz09b52+rulxMEJfzwQAU0lESQ6s/aE8Lup77NM=;
 b=4xyUdlyEGXXPMs9fC95K6mQHyT+5d+xaJKn9cuyt2lUXIjN2zE7lC7kG4ekx4cLpGW
 5/r6vlr2E4SUs347aV1M8t18k5FHxJ42C8fkKDSSRgJU7lDTSMd9wuYjSCz1wHy/HCb5
 1mqO/XfUL/TFU2dRWaRH9nJI1BurpjjRXkDmY5v+owGLSoFQ4nrdzpCE3p5hQiPWk7Nh
 inypZmpn00Q9iS4JatGdMsGc4STsoeJHz9WUMBPJhpU3w8zE3e0y00NJjrZo1LbSHO+H
 ikywJjn1V6MU2k8aAZRlscoaXtVvB07+RawNnXovx9ExQGHTqLqQq9JtnYp9Remimlhx
 9RPg==
X-Gm-Message-State: AOAM532aLdL+PhkRnC8nnMP4AkKDYyDOYrDp2H1t8iH3vHXR4rrA5I1c
 EPdJu6266nYlu54WBC0LxEgSrR1USekI
X-Google-Smtp-Source: ABdhPJwCHc7fxmz5DGHLcuofkXghjPhU8hYkQXG2pB5/De5FAlnDqDB9RnWoWN1bvIdS4I1Eas5U47PGeAb+
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:fc03:4f5b:4e9b:3ec1])
 (user=qperret job=sendgmr) by 2002:a17:906:4fc4:: with SMTP id
 i4mr11224234ejw.81.1639584764044; Wed, 15 Dec 2021 08:12:44 -0800 (PST)
Date: Wed, 15 Dec 2021 16:12:19 +0000
In-Reply-To: <20211215161232.1480836-1-qperret@google.com>
Message-Id: <20211215161232.1480836-3-qperret@google.com>
Mime-Version: 1.0
References: <20211215161232.1480836-1-qperret@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v4 02/14] KVM: arm64: Refcount hyp stage-1 pgtable pages
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: qwandor@google.com, linux-kernel@vger.kernel.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

To prepare the ground for allowing hyp stage-1 mappings to be removed at
run-time, update the KVM page-table code to maintain a correct refcount
using the ->{get,put}_page() function callbacks.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 39 ++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index f8ceebe4982e..e50e9158fc56 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -383,21 +383,6 @@ enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte)
 	return prot;
 }
 
-static bool hyp_pte_needs_update(kvm_pte_t old, kvm_pte_t new)
-{
-	/*
-	 * Tolerate KVM recreating the exact same mapping, or changing software
-	 * bits if the existing mapping was valid.
-	 */
-	if (old == new)
-		return false;
-
-	if (!kvm_pte_valid(old))
-		return true;
-
-	return !WARN_ON((old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW);
-}
-
 static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 				    kvm_pte_t *ptep, struct hyp_map_data *data)
 {
@@ -407,11 +392,16 @@ static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	if (!kvm_block_mapping_supported(addr, end, phys, level))
 		return false;
 
+	data->phys += granule;
 	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
-	if (hyp_pte_needs_update(old, new))
-		smp_store_release(ptep, new);
+	if (old == new)
+		return true;
+	if (!kvm_pte_valid(old))
+		data->mm_ops->get_page(ptep);
+	else if (WARN_ON((old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW))
+		return false;
 
-	data->phys += granule;
+	smp_store_release(ptep, new);
 	return true;
 }
 
@@ -433,6 +423,7 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		return -ENOMEM;
 
 	kvm_set_table_pte(ptep, childp, mm_ops);
+	mm_ops->get_page(ptep);
 	return 0;
 }
 
@@ -482,8 +473,16 @@ static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			   enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = arg;
+	kvm_pte_t pte = *ptep;
+
+	if (!kvm_pte_valid(pte))
+		return 0;
+
+	mm_ops->put_page(ptep);
+
+	if (kvm_pte_table(pte, level))
+		mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
 
-	mm_ops->put_page((void *)kvm_pte_follow(*ptep, mm_ops));
 	return 0;
 }
 
@@ -491,7 +490,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= hyp_free_walker,
-		.flags	= KVM_PGTABLE_WALK_TABLE_POST,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 		.arg	= pgt->mm_ops,
 	};
 
-- 
2.34.1.173.g76aa8bc2d0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
