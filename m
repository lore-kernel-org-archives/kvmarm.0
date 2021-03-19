Return-Path: <SRS0=QSSN=IR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38883C433DB
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BDEFB64F6E
	for <kvmarm@archiver.kernel.org>; Fri, 19 Mar 2021 10:02:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BDEFB64F6E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CC6B4B6AA;
	Fri, 19 Mar 2021 06:02:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id slenin5L3-gt; Fri, 19 Mar 2021 06:02:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 528A44B667;
	Fri, 19 Mar 2021 06:02:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 110994B60C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i98sXM-XAwbV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 06:02:01 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F34684B682
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 06:02:00 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id u17so31771499qvq.23
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 03:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=TccyldlGh8jyXKeMFND/Hm+ER293Gl9fJb4reK7MIeI=;
 b=aMJKsUpMZtoc6Vo/NUkiAkgYytwPwSWdxjtMAs/nwSVhtmr7fkCBs4zK4jrX9Yto1t
 74J9Oa4XC1AXlMHlxsjiWj0R+BJ/BW71UzD9HCCF5luXJ6jarXUOYwcVVJiF/gr8VTqx
 myolrurPb6MIli6tKDX09K3FlNugO6bAL+YGGRoS0if+l6Ke09o0IeRRed9bXZwdSsc7
 2NpwMa0ikNeXDOX4HRkuwwDYa/uvCiM4/rq5BHexXiim5y6aSnWh0wLRHXcKZAqE+7je
 7ENBURMGCufhIVy84m7LAuCtnB/TvZ8pLGRbR8xZBGQYsyFEAC6sVdPK5f6txbQ0Em3n
 Rliw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=TccyldlGh8jyXKeMFND/Hm+ER293Gl9fJb4reK7MIeI=;
 b=ayxT2rAjCkwe5bC59QeDGWZHH5A5Ui97webAaH54idobPrkbuZOPlLEObDRt27q/Uh
 d7CDDa0jFtjy077KRmRhfTAFp7X5rSiiBVvOaACBj3sZoDZma+aEo9//Ag471JPgdAGO
 f6PgKXYAzfhHZWaxI1xQBHWS7Q7czc8NCQEdhHwE0YEy66HF1yg8xpYGHX+p9eKQqQgA
 H+1h8DOe184hRmc59P9icJTe5BqFi1cyrgowFr1ona8MVuMFYQQ9tAesQ92PWgzDIna/
 1h2agQuu3Dg66C7cUZU4z7lCSrnZE7oTErLbNQdUQ63IEnc6Pg8ggtieeIYf6FAACLZU
 /39Q==
X-Gm-Message-State: AOAM530edyYYcbk5GotG/UPVkXGjG+C3ymtvqnfTWNRyHaVxATbTxoJI
 BmzOgmjP9QiXpGRPWO3QVigeNJyEohFf
X-Google-Smtp-Source: ABdhPJyAfHPltOr6Ii1E0fGpZSgU/xa1c+709JNQ28p9DHhYeGy8ayWuxcmcxY1y7/l8XTGyuuWxYQ0eD4Sf
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:df02:: with SMTP id
 g2mr8475100qvl.40.1616148120563; Fri, 19 Mar 2021 03:02:00 -0700 (PDT)
Date: Fri, 19 Mar 2021 10:01:13 +0000
In-Reply-To: <20210319100146.1149909-1-qperret@google.com>
Message-Id: <20210319100146.1149909-6-qperret@google.com>
Mime-Version: 1.0
References: <20210319100146.1149909-1-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH v6 05/38] KVM: arm64: Avoid free_page() in page-table allocator
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
index 926fc07074f5..0990fda19198 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -414,7 +414,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits)
 static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			   enum kvm_pgtable_walk_flags flag, void * const arg)
 {
-	free_page((unsigned long)kvm_pte_follow(*ptep));
+	put_page(virt_to_page(kvm_pte_follow(*ptep)));
 	return 0;
 }
 
@@ -426,7 +426,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 	};
 
 	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
-	free_page((unsigned long)pgt->pgd);
+	put_page(virt_to_page(pgt->pgd));
 	pgt->pgd = NULL;
 }
 
@@ -578,7 +578,7 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
 	if (!data->anchor)
 		return 0;
 
-	free_page((unsigned long)kvm_pte_follow(*ptep));
+	put_page(virt_to_page(kvm_pte_follow(*ptep)));
 	put_page(virt_to_page(ptep));
 
 	if (data->anchor == ptep) {
@@ -701,7 +701,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	}
 
 	if (childp)
-		free_page((unsigned long)childp);
+		put_page(virt_to_page(childp));
 
 	return 0;
 }
@@ -898,7 +898,7 @@ static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	put_page(virt_to_page(ptep));
 
 	if (kvm_pte_table(pte, level))
-		free_page((unsigned long)kvm_pte_follow(pte));
+		put_page(virt_to_page(kvm_pte_follow(pte)));
 
 	return 0;
 }
-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
