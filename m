Return-Path: <SRS0=nsVm=IN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F6BC433E6
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8506264FF9
	for <kvmarm@archiver.kernel.org>; Mon, 15 Mar 2021 14:36:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8506264FF9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 394404B705;
	Mon, 15 Mar 2021 10:36:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wsjHRUvc2S9S; Mon, 15 Mar 2021 10:36:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 216174B4E3;
	Mon, 15 Mar 2021 10:36:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E92294B6DC
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gMBTphRenH3E for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Mar 2021 10:36:40 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B18504B649
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 10:36:38 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id r6so1914291wrt.20
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Mar 2021 07:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=J1uZIE4CatR8RJ2mwUZGBIvYuAMTy17ux6AGbOX5tFk=;
 b=quH1WWPr+L1SVwBqv31K38Go2mHpdC6nZ0w0GUgWu8lifd6IDz7tnxeCHBvwfxXcid
 s/cfv6PNBlw7Tv1DYVDfMOsXnBOEXJFlXhMZyBMoZVhKnghB6bZBQ7RXezVsiD4bljVh
 lJBqoO4Or/KxawhVR2OPnIGrxhVyjXNvg07Fc+ZEFDUsWiUlW9oHKY+QEXLr9k42aYSH
 d2Cae4A8DBkXpZvxeLTGbGBr2odV4gqnrZpx31EngUzons5PvcQ6ycsc99xvdaHgxaKm
 V/XOC0HOZ3lOrer8gP70svjqgVCAXPSm6Ym7SYFjCDsB/ZmUMa2sDLVxAtskeXAdYfBu
 oHQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=J1uZIE4CatR8RJ2mwUZGBIvYuAMTy17ux6AGbOX5tFk=;
 b=DmhwXTsJcKu1O/LJuPlZHa+tEiprhc+bZSgYVgrNNuCOegWA+rGl65L5l8Qx7S1PpX
 Wb54TuRZ1fccYpgAJSPZ1jkBJgZP5GObOExAQdUk8ceZwBgtZMuxXvfb0Mu+fpk1XJXP
 Tz67cpo13FsAUghWAXgwVfIfdKpSPmPLXyxqEuASaHDjv6IInVCj/lgYTmHMzsYEtSpM
 5aLV1PqwkmkiqmXATrk01QH4wEzSeYEKnYxTvm2afTCOadhtsRBlx86tVFnoiR8rprzd
 m3erjENYr2QAZuiSVmjg0d7J65394ATNbb1MxkCISXwbFydqRV8V38GVQXP7su7Kodt2
 1tAA==
X-Gm-Message-State: AOAM533sPrPIDQW/ZgsMVywqR42Vx9K96d0Dw/pUoOkMPeyFfgEB/7Va
 cYGZRvoIsUV7sX+sY0892nJgtZ85CPaX
X-Google-Smtp-Source: ABdhPJxe4+QHHGpZyqH28YWZv8YfJrDVsBARhsCBGZiD6vsppmOxHGv9C0FMe9dp3bfpi8X+Fs4PaGFGP24s
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:600c:2053:: with SMTP id
 p19mr26380067wmg.87.1615818997861; Mon, 15 Mar 2021 07:36:37 -0700 (PDT)
Date: Mon, 15 Mar 2021 14:35:28 +0000
In-Reply-To: <20210315143536.214621-1-qperret@google.com>
Message-Id: <20210315143536.214621-29-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v5 28/36] KVM: arm64: Always zero invalid PTEs
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org, tabba@google.com,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

kvm_set_invalid_pte() currently only clears bit 0 from a PTE because
stage2_map_walk_table_post() needs to be able to follow the anchor. In
preparation for re-using bits 63-01 from invalid PTEs, make sure to zero
it entirely by ensuring to cache the anchor's child upfront.

Acked-by: Will Deacon <will@kernel.org>
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
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
