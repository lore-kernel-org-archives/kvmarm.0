Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D237C47082
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 11:45:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 98DD56135D
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 11:45:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98DD56135D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C3DA4A319;
	Tue,  8 Jun 2021 07:45:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id g4NjM9VE+eOj; Tue,  8 Jun 2021 07:45:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C3724A003;
	Tue,  8 Jun 2021 07:45:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 47D8840878
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 07:45:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kGkmp0k8QGYn for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 07:45:30 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6413949D50
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 07:45:30 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 q15-20020adfc50f0000b0290111f48b865cso9315407wrf.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 04:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=LthYGSx9khubk0Q8iirSxhsMo2f7JJJGJq7fjYN5P38=;
 b=f2wQRB2jWBShQeudJb2Rmut+KMQOsZgySbE+sTH8oSLU6gFAIffflC/ma+62ucmDoj
 7XeuFCB9mACIijeZC4zq5Dfd3nwANdrfG/dzHB+CtvH2bVxNlVc1M71oEMRwwolxuLvw
 /h35q0ZqMfz7SEVEqlZy8xEj8AA3AXvglFwvD4blk7ugoBTvGGwuwtrr2Zue/YXZ2Aor
 c69B6hM/6XZP8KvobS1YTao33E7DXN4ioJi3ViVlj58EeiDQOgIgbJ0eE8PplqWKTd2w
 LAHZepXukg8vmCGKkzLFL8TIohz3WkwjeeLJpDa+CZafFq2XWMPVRriusB39/NMuV/GE
 uVhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=LthYGSx9khubk0Q8iirSxhsMo2f7JJJGJq7fjYN5P38=;
 b=tO8dH1JQBfjdRQa1yPUdtl3ZJuMa34AwGhsr7uaChSHeaE9A5nrbo8EjfaSvvSw6b/
 j88qWI258vU7wNZGtrMSWJjAhofvBtd3UVFlNsHkjoNhWjTThN6k/cxtJ7b7hAPC2L84
 V40JiNk8ExMDMPq1xsgOFGzioplKCXw9GubJZLsR64P4mVIIGWtszvql+m8KRnULdois
 uVwjJ2AxN9jG9APT07puCioYH/2+Cn4avOxXCw1A9ujSrejdrmjMx+dEzBu5PEZgG6yg
 cqCb8AtdMnIfHLlx+XxoxaRVqClYG1ZQD4tEK/dzt2/R4qQwr39rQVUcHUTzDLqce4x5
 4buw==
X-Gm-Message-State: AOAM532jAskwI+SrhYk8p/HhFf8tQC/nxNuXhHSun/Nvdxkq9nUjjJyC
 SVJRxKLbXpzqVdB/uDFsK0IP77cO9D47
X-Google-Smtp-Source: ABdhPJxAu10Zi5a8GAxfgrCM5/ofdSfnO2007lyftbaojQBH+mzj7bMUM0GJxPqdZ4Q2zSw6PtaVyeR6V8I9
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:600c:1910:: with SMTP id
 j16mr21226843wmq.39.1623152729448; Tue, 08 Jun 2021 04:45:29 -0700 (PDT)
Date: Tue,  8 Jun 2021 11:45:13 +0000
In-Reply-To: <20210608114518.748712-1-qperret@google.com>
Message-Id: <20210608114518.748712-3-qperret@google.com>
Mime-Version: 1.0
References: <20210608114518.748712-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v3 2/7] KVM: arm64: Use refcount at hyp to check page
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
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
