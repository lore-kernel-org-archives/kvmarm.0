Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE7C4C433F5
	for <kvmarm@archiver.kernel.org>; Wed,  1 Dec 2021 17:04:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6556F4B22A;
	Wed,  1 Dec 2021 12:04:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gu1q-+4ZxfJo; Wed,  1 Dec 2021 12:04:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 62E8A4B246;
	Wed,  1 Dec 2021 12:04:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0A3B4B204
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jivQKOo0x6QZ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Dec 2021 12:04:30 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7C7AF4B264
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Dec 2021 12:04:30 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id
 n16-20020a05600c3b9000b003331973fdbbso1222517wms.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 01 Dec 2021 09:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=9uBUypl+EXPtiyqLggdiPCeBqKTFxHsKtVyJKG8pgmY=;
 b=Vv1c7CHoktHXpAkMllAbrV9Qh8WJZnyTA3AZU15KbH4HMkRzFi9p8jcrrt9SYvw/vm
 XiJfozl/oFlTHNfLRWY3HBA3gFa9GG27TT0SAeeuzCVqz8nF3/MFgRTE1JTlFJUP24Ec
 BzDBGevNwW/zf0YB+zazdFhJ4kiNaPq5iHmleo2R5XUDtGWhB+8awKuhqPooz9Z/mSNG
 gs4ndbhCyBpRHS3gb21jCowKbTdnE1ozwPsjKll5mD7/DVNd1EvOyQ72bfzphCiSXYhN
 gFAldNGJnBPpUdYyDkMsuJXxN+63Mq6uHhqZqhCmWw9MzrD9lAxNSXUtKzeOMkHVbfX8
 pvlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=9uBUypl+EXPtiyqLggdiPCeBqKTFxHsKtVyJKG8pgmY=;
 b=PkMSS+jv6IwBY6hqv5ytQcmBSoK3HslAWEiyT90Bqiyt+IJDKM3wHCkCfq5rBDt2x3
 JtI3CZZ+bWM3k1ZuVDlVws5VbJgl+mlMT61RBwsARS6beyL8o+gHl4dXRwbEa/iyx6Is
 GNSvus/qVE4u1reYc/Lxtq+mcsBswR+AW1gzVZkGkz0Rh8GyJh0nOf7lCMs73DW4IRyG
 2q0qg4eplttiOAg5NeE8drsVOR2ESK8IJCtcwagmPdi9P1sUhL9lbj9/iqate71uC5YZ
 iDzv5j8lgW0R2b1cHSzwhCl96BT5AbIsDHy1MtTQsNGqZcw2iVoRBASSeHH5muVdQIPw
 5Aqw==
X-Gm-Message-State: AOAM530WwnKeaCyfSLcbNBhf5iqZEv2AfA84j53zBRnYoRPP2mBb0WH0
 Rf7qn0M1n0r6KVadV6o5sXg90iwNpP1V
X-Google-Smtp-Source: ABdhPJynMlhVluzA+1W+geGVMD660u2IXflLbXQYLj5MfYI1LEe60lA76lE/vavpHK8Z8gHIBVjRNs1KfRK+
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1cab:1a20:2ef1:ddde])
 (user=qperret job=sendgmr) by 2002:a05:600c:1d1b:: with SMTP id
 l27mr113174wms.1.1638378269441; Wed, 01 Dec 2021 09:04:29 -0800 (PST)
Date: Wed,  1 Dec 2021 17:03:58 +0000
In-Reply-To: <20211201170411.1561936-1-qperret@google.com>
Message-Id: <20211201170411.1561936-5-qperret@google.com>
Mime-Version: 1.0
References: <20211201170411.1561936-1-qperret@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH v3 04/15] KVM: arm64: Fixup hyp stage-1 refcount
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

In nVHE-protected mode, the hyp stage-1 page-table refcount is broken
due to the lack of refcount support in the early allocator. Fix-up the
refcount in the finalize walker, once the 'hyp_vmemmap' is up and running.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/setup.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 578f71798c2e..875b5174342f 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -165,6 +165,7 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 					 enum kvm_pgtable_walk_flags flag,
 					 void * const arg)
 {
+	struct kvm_pgtable_mm_ops *mm_ops = arg;
 	enum kvm_pgtable_prot prot;
 	enum pkvm_page_state state;
 	kvm_pte_t pte = *ptep;
@@ -173,6 +174,15 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 	if (!kvm_pte_valid(pte))
 		return 0;
 
+	/*
+	 * Fix-up the refcount for the page-table pages as the early allocator
+	 * was unable to access the hyp_vmemmap and so the buddy allocator has
+	 * initialised the refcount to '1'.
+	 */
+	mm_ops->get_page(ptep);
+	if (flag != KVM_PGTABLE_WALK_LEAF)
+		return 0;
+
 	if (level != (KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
 
@@ -205,7 +215,8 @@ static int finalize_host_mappings(void)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= finalize_host_mappings_walker,
-		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
+		.arg	= pkvm_pgtable.mm_ops,
 	};
 	int i, ret;
 
@@ -240,10 +251,6 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
-	ret = finalize_host_mappings();
-	if (ret)
-		goto out;
-
 	pkvm_pgtable_mm_ops = (struct kvm_pgtable_mm_ops) {
 		.zalloc_page = hyp_zalloc_hyp_page,
 		.phys_to_virt = hyp_phys_to_virt,
@@ -253,6 +260,10 @@ void __noreturn __pkvm_init_finalise(void)
 	};
 	pkvm_pgtable.mm_ops = &pkvm_pgtable_mm_ops;
 
+	ret = finalize_host_mappings();
+	if (ret)
+		goto out;
+
 out:
 	/*
 	 * We tail-called to here from handle___pkvm_init() and will not return,
-- 
2.34.0.rc2.393.gf8c9666880-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
