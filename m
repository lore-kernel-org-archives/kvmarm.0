Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C74FC433DB
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:59 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1615064FB1
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 17:58:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1615064FB1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA5964B60D;
	Wed, 10 Mar 2021 12:58:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ho5roRDb0NmU; Wed, 10 Mar 2021 12:58:57 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0C6B4B53E;
	Wed, 10 Mar 2021 12:58:57 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CF944B336
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8rTdG8svLNck for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 12:58:55 -0500 (EST)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0214C4B61F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 12:58:55 -0500 (EST)
Received: by mail-qt1-f201.google.com with SMTP id b21so13549141qtr.8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 09:58:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=KHg8GNHRWwdgHORBJFIM4n3Psw8hXYgV1Q7feze9Wwg=;
 b=r7hm1X+/A4HHjywquwAv8UbYAC4tXhZrRcjw5KRNMuRuugEIl9mZiVAY/05E4lCJ/r
 mJTLgUN7/+Hr2pV5bAsaKsvRidg2SEkD9/zXw+s5Ztk6sxyrU8HvKe+vTQLw3LG01fOE
 JHPpmFLbjbPAN+XwZHagqy2Ooi5//8Rg247YAx2wK+3j2Sft1b5cmSGrw/mSyOcP855p
 7UnlC90DSABtGbdUnuIuLTbD1MK9ZKjMlWgNcVtYWTqnnHZ+iLJIOXE53XyztiG7sCQz
 XkxrZ2zyGBLxkidgk/YANYRo9KEhtYj9pTuZiRLmeb68EDE+Dg9j77mf3Oj8CYFTC8Cy
 3qWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=KHg8GNHRWwdgHORBJFIM4n3Psw8hXYgV1Q7feze9Wwg=;
 b=YQ1wP2yM2o4EBCxq3o92zJiGchnfNinB3gOLK/bK6DXb8XsTcmnW7fNGIHfhd1sHI7
 GGmq+hLiCT6Hk06DgZe4SkXa7SVHWHWfc7AEfHh2Yehh9fWEIsKBY8oLOecA5PFTmXh+
 PrLMBbywfiylhIgAdOkkCzfqkZn4Fj6dPnYQM3E5+gZ7HzNynSaFmNfIMMh+XxB0HzBG
 eBMjoAIq2ZBdSNO+xscYFxiz9vcdO4EZ+buX4JXHQfR3faLxbVdpft/P7GagsIZL/Il8
 W8MB5po70zGGxMqPmiRo0Ny6Y6E4ZX6yJNHgjZsSnxfOiaTNHrplkYDVdhcBmLzEvOk6
 5SIQ==
X-Gm-Message-State: AOAM533cjFhw2kapAbTz2wucSDOLc5McR0+UzgMvLcw5JRhfwzIwYfmB
 PYHXMU1Py3UcAyEMok5dK8KwAxEE43sI
X-Google-Smtp-Source: ABdhPJxctmL0qh9AUqySqIh+J7wmsFSyJZCllX/E1sFQxbY+Rs5BdkUUA7jDJCdbb2ggAgOkd5NnOmpGsuXf
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:6214:1305:: with SMTP id
 a5mr4160961qvv.42.1615399134545; Wed, 10 Mar 2021 09:58:54 -0800 (PST)
Date: Wed, 10 Mar 2021 17:57:44 +0000
In-Reply-To: <20210310175751.3320106-1-qperret@google.com>
Message-Id: <20210310175751.3320106-28-qperret@google.com>
Mime-Version: 1.0
References: <20210310175751.3320106-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 27/34] KVM: arm64: Always zero invalid PTEs
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

kvm_set_invalid_pte() currently only clears bit 0 from a PTE because
stage2_map_walk_table_post() needs to be able to follow the anchor. In
preparation for re-using bits 63-02 from invalid PTEs, make sure to zero
it entirely by ensuring to cache the anchor's child upfront.

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index bdd6e3d4eeb6..f37b4179b880 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -156,10 +156,9 @@ static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_op
 	return mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
 }
 
-static void kvm_set_invalid_pte(kvm_pte_t *ptep)
+static void kvm_clear_pte(kvm_pte_t *ptep)
 {
-	kvm_pte_t pte = *ptep;
-	WRITE_ONCE(*ptep, pte & ~KVM_PTE_VALID);
+	WRITE_ONCE(*ptep, 0);
 }
 
 static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
@@ -443,6 +442,7 @@ struct stage2_map_data {
 	kvm_pte_t			attr;
 
 	kvm_pte_t			*anchor;
+	kvm_pte_t			*childp;
 
 	struct kvm_s2_mmu		*mmu;
 	void				*memcache;
@@ -532,7 +532,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 		 * There's an existing different valid leaf entry, so perform
 		 * break-before-make.
 		 */
-		kvm_set_invalid_pte(ptep);
+		kvm_clear_pte(ptep);
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
 		mm_ops->put_page(ptep);
 	}
@@ -553,7 +553,8 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 	if (!kvm_block_mapping_supported(addr, end, data->phys, level))
 		return 0;
 
-	kvm_set_invalid_pte(ptep);
+	data->childp = kvm_pte_follow(*ptep, data->mm_ops);
+	kvm_clear_pte(ptep);
 
 	/*
 	 * Invalidate the whole stage-2, as we may have numerous leaf
@@ -599,7 +600,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 * will be mapped lazily.
 	 */
 	if (kvm_pte_valid(pte)) {
-		kvm_set_invalid_pte(ptep);
+		kvm_clear_pte(ptep);
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
 		mm_ops->put_page(ptep);
 	}
@@ -615,19 +616,24 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
 				      struct stage2_map_data *data)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
+	kvm_pte_t *childp;
 	int ret = 0;
 
 	if (!data->anchor)
 		return 0;
 
-	mm_ops->put_page(kvm_pte_follow(*ptep, mm_ops));
-	mm_ops->put_page(ptep);
-
 	if (data->anchor == ptep) {
+		childp = data->childp;
 		data->anchor = NULL;
+		data->childp = NULL;
 		ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
+	} else {
+		childp = kvm_pte_follow(*ptep, mm_ops);
 	}
 
+	mm_ops->put_page(childp);
+	mm_ops->put_page(ptep);
+
 	return ret;
 }
 
@@ -736,7 +742,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 * block entry and rely on the remaining portions being faulted
 	 * back lazily.
 	 */
-	kvm_set_invalid_pte(ptep);
+	kvm_clear_pte(ptep);
 	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, addr, level);
 	mm_ops->put_page(ptep);
 
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
