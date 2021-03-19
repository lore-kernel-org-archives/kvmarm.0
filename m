Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D58C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DE2FB64F1F
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE2FB64F1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C1D94B6A2;
	Fri, 19 Mar 2021 06:02:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uSnOvw+9IBYf; Fri, 19 Mar 2021 06:02:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 596054B723;
	Fri, 19 Mar 2021 06:02:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79A294B72A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HHO02XRuk3Ti for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:02:51 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 139CF4B682
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:51 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id h5so21519887wrr.17
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=uBuSDgADlVyxIdI3BmsAIPCPmlM7WqeZ0Oeo6QVFLts=;
 b=qCWraLZ0Tszd8AH74n5bMJc2ZNxpli+5BtX1Qu0TYtfObzVU7M02pQnddE7gvCf0iN
 pxmN8wb8E3OkHG0yFhoGSKXtXucoyZgOukVOd9KIzkfTZ/qis1gqdYkYBY6SgONRydNY
 KY5mRl/bU+IaXK3gVCVIou3kiMKprdEqZ7Fs1tKl1gCFYmPlEuuIQYwaYZS+QSHTyqNY
 47eTUx6l0G5XKkzF68I0V5R/05uQim6YGk9NHHdWAPWlBjSiZ4pqQy1/gCTdPSfuywh9
 Pg0WV+45hM8j8NIgdxeyB2hzRuAj3f9jXw1V3wXA8TEq7M0aKy6iE4YGWe1j2bPyM4Xy
 etHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=uBuSDgADlVyxIdI3BmsAIPCPmlM7WqeZ0Oeo6QVFLts=;
 b=lgMBmlciyl21285evoJ1PBimDFCL2zsW2zLIhO48VfcuhEFQ4kpAGkPlKSZacsLAN4
 JglAvHohEg81ANuH2HL+kd3Nef2JhEwl9wGfvZiw3NUyGlepo8u32Sm16j8LvQGIRmzZ
 SlH9Oy+HIn++9XV2+S1UdX62iQ/5m/qBLYP/gf2yMw0oZ5f5cddZRSRrvGu13Ixu3zpX
 NuUaGEmrMA2A201Vx2P1wlKmNSJdsIepcV2HczS7Hkq3jyKOfQ5+YdsS00i1pd/3LXLw
 +pl/NT/EncIxzZEtWOUYGQ5yR3m50F/TyHEUSTtr5EwB9gl2qCqTyKSZ1UjWeL4Ue/+P
 6LOQ==
X-Gm-Message-State: AOAM532FnZHLKc5Mb6Hhr9Nl+cKyeLi2cU4dYY/yjPFapUOT5kDpyD1L
 BApoPKWFZwMCRUQ389JX8HpmQa05tT6x
X-Google-Smtp-Source: ABdhPJy7gzoGDveYEOxbSnLDlDyWEZkPizO1OQME7oNr7V9YSTxgGFBprzpO+9yJFS/BuMsKlUSbA1VxNmbB
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:600c:4ed1:: with SMTP id
 g17mr2965040wmq.67.1616148170085; Fri, 19 Mar 2021 03:02:50 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:36 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-29-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 28/38] KVM: arm64: Always zero invalid PTEs
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
index 15de1708cfcd..0a674010afb6 100644
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
@@ -444,6 +443,7 @@ struct stage2_map_data {
 	kvm_pte_t			attr;
 
 	kvm_pte_t			*anchor;
+	kvm_pte_t			*childp;
 
 	struct kvm_s2_mmu		*mmu;
 	void				*memcache;
@@ -533,7 +533,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 		 * There's an existing different valid leaf entry, so perform
 		 * break-before-make.
 		 */
-		kvm_set_invalid_pte(ptep);
+		kvm_clear_pte(ptep);
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
 		mm_ops->put_page(ptep);
 	}
@@ -554,7 +554,8 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 	if (!kvm_block_mapping_supported(addr, end, data->phys, level))
 		return 0;
 
-	kvm_set_invalid_pte(ptep);
+	data->childp = kvm_pte_follow(*ptep, data->mm_ops);
+	kvm_clear_pte(ptep);
 
 	/*
 	 * Invalidate the whole stage-2, as we may have numerous leaf
@@ -600,7 +601,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 * will be mapped lazily.
 	 */
 	if (kvm_pte_valid(pte)) {
-		kvm_set_invalid_pte(ptep);
+		kvm_clear_pte(ptep);
 		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, addr, level);
 		mm_ops->put_page(ptep);
 	}
@@ -616,19 +617,24 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
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
 
@@ -737,7 +743,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
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
