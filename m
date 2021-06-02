Return-Path: <SRS0=fRMP=K4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E92ECC47093
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 09:44:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 79134613BF
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 09:44:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 79134613BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17E1849F8F;
	Wed,  2 Jun 2021 05:44:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HG0rcAPhNIfH; Wed,  2 Jun 2021 05:44:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ABF74A4A0;
	Wed,  2 Jun 2021 05:43:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 72416409DD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 05:43:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3whVV8HExqNe for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Jun 2021 05:43:56 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 84E014081C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 05:43:56 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 k6-20020a0cd6860000b029021936c6e8ffso1288950qvi.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Jun 2021 02:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=iZUQk8fIlBvRNxDOUvgxujyUIWimZaPXfaVXd2+o6PY=;
 b=VLEyklUT17eTyvASVE7D7VJJlhe5fAE1d9RgPZBqibyIBB6t1KdUSjsMDHUTzawsYb
 kX7dTP9UCIcEy4saEDT8A1ACHMYxFaTwbasSzUy9XUR/Y2LxVJc9AKyM8VvhpSZRZ3NL
 MxZ1AY2eP2/bBpheP6r59nKkqlZ/ZGdBOqYGu8KXHl7lSkugmxTEnm+8Wu68jUWSVkJL
 0xrNW3CgzLjbiR2UH+ZZSedoZtMHG+8aASS7O0TbNhnJBXFav94x+bAlSa4Vz6cWhaK6
 egWJUSMlQpeb1mS5RVmlTwu/ULC5Aw0INHSbGNgFhYW0WNgXxCvaRJ0qlrTHoPcNIdkK
 Jcnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=iZUQk8fIlBvRNxDOUvgxujyUIWimZaPXfaVXd2+o6PY=;
 b=tcQ8618ZtqBt7e6H4RUwx4j0ABZ9dR+rv6dNtiQzhITKzUQeskRLOi0RhikU0Msftg
 5JNjVGJBQkeGVkaMQeNwLELnYYxtl5EaF8ZXVN9dvGVMIu6DBGRQPxm8twI7kKzZgHzp
 mgdkC2J1VU7/QlCtZMrjCrin97R9KU6ETLq6WT4/yzp+Y06q1axmPe+GOCUFXAZCcBDJ
 SXVMhRfWoXKB9WNzByEP0sfACj5Ngv7rVLdY2RXB+mYW5zHhQZdMC24XlHc2fyCa6ob2
 7HzmmusFPBG8fsVK2gBpt+bWPbnCyrWUhE2RQQAz5iZpPi3s5fU/XpT+7n5YQSrSQSZ7
 xziA==
X-Gm-Message-State: AOAM532ahnRugkYu/oQ1kKIIg79RSWh/p5Ib1x09irW6vQIKYfgcMumo
 m5GCQ5IInhv1rkAoRDaqeNOCQu/jfNzH
X-Google-Smtp-Source: ABdhPJw5u97rh4yWHjSnTxNGWaGWtM7mSfMb+qJ6Mxm9lPPMCbPzQl92O3It3Tn7cZ0dBOcajFXTAP9JCzwj
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:6214:c88:: with SMTP id
 r8mr6671320qvr.58.1622627036015; Wed, 02 Jun 2021 02:43:56 -0700 (PDT)
Date: Wed,  2 Jun 2021 09:43:42 +0000
In-Reply-To: <20210602094347.3730846-1-qperret@google.com>
Message-Id: <20210602094347.3730846-3-qperret@google.com>
Mime-Version: 1.0
References: <20210602094347.3730846-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
Subject: [PATCH v2 2/7] KVM: arm64: Use refcount at hyp to check page
 availability
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, will@kernel.org, james.morse@arm.com, 
 alexandru.elisei@arm.com, catalin.marinas@arm.com, suzuki.poulose@arm.com
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

The hyp buddy allocator currently checks the struct hyp_page list node
to see if a page is available for allocation or not when trying to
coalesce memory. Now that decrementing the refcount and attaching to
the buddy tree is done in the same critical section, we can rely on the
refcount of the buddy page to be in sync, which allows to replace the
list node check by a refcount check. This will ease removing the list
node from struct hyp_page later on.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/page_alloc.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index d666f4789e31..2602577daa00 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -55,7 +55,7 @@ static struct hyp_page *__find_buddy_avail(struct hyp_pool *pool,
 {
 	struct hyp_page *buddy = __find_buddy_nocheck(pool, p, order);
 
-	if (!buddy || buddy->order != order || list_empty(&buddy->node))
+	if (!buddy || buddy->order != order || buddy->refcount)
 		return NULL;
 
 	return buddy;
@@ -133,6 +133,12 @@ static inline void hyp_set_page_refcounted(struct hyp_page *p)
 	p->refcount = 1;
 }
 
+static void __hyp_put_page(struct hyp_pool *pool, struct hyp_page *p)
+{
+	if (hyp_page_ref_dec_and_test(p))
+		__hyp_attach_page(pool, p);
+}
+
 /*
  * Changes to the buddy tree and page refcounts must be done with the hyp_pool
  * lock held. If a refcount change requires an update to the buddy tree (e.g.
@@ -146,8 +152,7 @@ void hyp_put_page(void *addr)
 	struct hyp_pool *pool = hyp_page_to_pool(p);
 
 	hyp_spin_lock(&pool->lock);
-	if (hyp_page_ref_dec_and_test(p))
-		__hyp_attach_page(pool, p);
+	__hyp_put_page(pool, p);
 	hyp_spin_unlock(&pool->lock);
 }
 
@@ -202,15 +207,16 @@ int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
 
 	/* Init the vmemmap portion */
 	p = hyp_phys_to_page(phys);
-	memset(p, 0, sizeof(*p) * nr_pages);
 	for (i = 0; i < nr_pages; i++) {
 		p[i].pool = pool;
+		p[i].order = 0;
 		INIT_LIST_HEAD(&p[i].node);
+		hyp_set_page_refcounted(&p[i]);
 	}
 
 	/* Attach the unused pages to the buddy tree */
 	for (i = reserved_pages; i < nr_pages; i++)
-		__hyp_attach_page(pool, &p[i]);
+		__hyp_put_page(pool, &p[i]);
 
 	return 0;
 }
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
