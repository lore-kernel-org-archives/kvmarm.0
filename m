Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF3FC433DB
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:24 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B3D3A64F38
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B3D3A64F38
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 55D974B65C;
	Tue,  2 Mar 2021 10:00:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lw44FZdg5T9Z; Tue,  2 Mar 2021 10:00:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C1554B66C;
	Tue,  2 Mar 2021 10:00:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FBB04B66E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uSxPJyp63b6p for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:00:19 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A7CBF4B651
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:18 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id h16so1302668wmq.8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=lIPthT51J+nIs48nl/QvpI3Ln3AY2S6u6ppS3XkUMwM=;
 b=HY2FQJKTnEHypa62GHDeyX5+DVpyd3kd+DNyVif3kQtZ0Ox8tb7XmQpSllG+iYjI1q
 2QUVT2ttxPR69J+1gr+Neb8KNaKUHnwZPw3KUtPEso2PhLlezOzkuodC5vfiw9ttCpDt
 PRv1H5+P/SxKxew8i6WYse/QbcgSljdRs8FF7QDs49k78eLuvKtMpiJAuzX2X73QLIXU
 D6R6lQ6XuxLRnxSp+qKmjlwaaJbUgl6MooyomJKPlhfPlxL+ZUe44/BrLtDEXg46c0WL
 EuYGfH2gL3Od1t6WL3JKq7MFziOBysv7Jm4YOo4Ku6QwkNhrBF/wvIu6ii7T0msYsmIh
 2teA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=lIPthT51J+nIs48nl/QvpI3Ln3AY2S6u6ppS3XkUMwM=;
 b=geJCTyoclsNfGZyRVh65y2pe29SI7+aDgT7NqXxmFmn3s1HVrmJlULEUHszssiS9HQ
 3oZvCRSEOFRckqxCbwqZKBKzXqvkEstO2vbuAAe3+ykx0B2+LcijCauqh50N7yIGgDNT
 NaE7NF2kzPsgGKBX7VPa1GvpnxI7y5H0Boc4UiRK+SYJ1XMxjid+QFyVn9dFzG4Vpv/l
 RyHeTM5stKIxdjfj0+k3bMXTSsq9BN1iir92qrwQ8CO4QOhKkZEKrcwSymzRM1hYnIX8
 rCMexj9cmLoqOJYOEDb5acfkAabjhtZmAuoegogVu6m3c2iv+qAfkvDgP11qXqbXxTfc
 3Gwg==
X-Gm-Message-State: AOAM531UncwjYMguR0AsoYYgIIcsOM4w82wZItNo/CItnuoYMqNvCIOX
 XnOmu6oxnQt5FufGa6pArkDjv2gqdOXD
X-Google-Smtp-Source: ABdhPJwsf7neAAxO1z8gBsowskCoHbhgsUYl3UEiGSThsujkIogwftEA1DRC0UHx1iWXfw2Ebq84LUWTcvS+
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a7b:c18e:: with SMTP id
 y14mr495425wmi.1.1614697217407; Tue, 02 Mar 2021 07:00:17 -0800 (PST)
Date: Tue,  2 Mar 2021 14:59:35 +0000
In-Reply-To: <20210302150002.3685113-1-qperret@google.com>
Message-Id: <20210302150002.3685113-6-qperret@google.com>
Mime-Version: 1.0
References: <20210302150002.3685113-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 05/32] KVM: arm64: Avoid free_page() in page-table allocator
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

Currently, the KVM page-table allocator uses a mix of put_page() and
free_page() calls depending on the context even though page-allocation
is always achieved using variants of __get_free_page().

Make the code consistent by using put_page() throughout, and reduce the
memory management API surface used by the page-table code. This will
ease factoring out page-allocation from pgtable.c, which is a
pre-requisite to creating page-tables at EL2.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 4d177ce1d536..81fe032f34d1 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -413,7 +413,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits)
 static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			   enum kvm_pgtable_walk_flags flag, void * const arg)
 {
-	free_page((unsigned long)kvm_pte_follow(*ptep));
+	put_page(virt_to_page(kvm_pte_follow(*ptep)));
 	return 0;
 }
 
@@ -425,7 +425,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 	};
 
 	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
-	free_page((unsigned long)pgt->pgd);
+	put_page(virt_to_page(pgt->pgd));
 	pgt->pgd = NULL;
 }
 
@@ -577,7 +577,7 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
 	if (!data->anchor)
 		return 0;
 
-	free_page((unsigned long)kvm_pte_follow(*ptep));
+	put_page(virt_to_page(kvm_pte_follow(*ptep)));
 	put_page(virt_to_page(ptep));
 
 	if (data->anchor == ptep) {
@@ -700,7 +700,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	}
 
 	if (childp)
-		free_page((unsigned long)childp);
+		put_page(virt_to_page(childp));
 
 	return 0;
 }
@@ -897,7 +897,7 @@ static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	put_page(virt_to_page(ptep));
 
 	if (kvm_pte_table(pte, level))
-		free_page((unsigned long)kvm_pte_follow(pte));
+		put_page(virt_to_page(kvm_pte_follow(pte)));
 
 	return 0;
 }
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
