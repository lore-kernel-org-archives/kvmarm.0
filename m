Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E941C433F5
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 09:02:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 994B0610FC
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 09:02:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 994B0610FC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F03E4B2B9;
	Tue,  5 Oct 2021 05:02:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K4n0iAgZeo3Y; Tue,  5 Oct 2021 05:02:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 483524B2E1;
	Tue,  5 Oct 2021 05:02:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 486D34B2B7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 05:02:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HbZgsYh9xUqN for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Oct 2021 05:02:19 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 382CD4B2A7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Oct 2021 05:02:19 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 e12-20020a056000178c00b001606927de88so5479451wrg.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Oct 2021 02:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=tHk4fNmSvcmkrUgevYD4U41Hr/4Newl1f8mzt2RPUWc=;
 b=miKQfMbrmMeNk1nN5Us0pRryucqshdMsoMrRtD78bnN0xpMXDyebUIGBm2N9+RsrjS
 UXs1cSibDRvi2j5buA7f3EAJmJVPTQXbPoOTBYvIY/gj/8Pk4xMg9LHmvDqHKoPbzWhj
 CKw2r5ZL72icTM4eRY5uiI5Cmba4u3bLD6i7BCUh0Di04EY+fYYHfezaua/ZlZ0xG3CC
 XzkqJunDQFO8KNIKYFbmJHYzFqBlmK9kO4mzgbotS+atB5CwSM97GuY5iOwp7Apy6CUd
 9TDvI6JR/UrYgq52ZKMtEgOdcvtnUbgVt8CZhlFNzrhTdHOzXm/mu3rdOcnC9ZxCdibz
 l0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=tHk4fNmSvcmkrUgevYD4U41Hr/4Newl1f8mzt2RPUWc=;
 b=pDYRSIy09JxoNDL4buFR8Mp6O6y3zfLnRIc7Wy+Xz0tSHB3Cz6OQBP79RpsniuM0M3
 mBqPw+Kf/HAYmNAYRDIiAxhT5yRRaUHenhbtjyYgLHK4SLxiH/5K/fe865l551IMULF0
 JQ0pZhPWNg1pfsy0otAiwe2aZyMi5h3otQz050WkIrenzWP0i/9G2Yi/z6hSTg2SF5wD
 ltyoUN9fsj8/kpkFEyhQeJ11L0VwwN/TOn4CxgMT7j2I6VBFpeVjb+i81a1AqwI5UGv8
 jQ1bxeLxlsAFtzjzZJG5KZ9HcqRR9pBKqK/boHwSoO0lnthf7UlreGj1lRNKtKKSA3dR
 hu/A==
X-Gm-Message-State: AOAM530DnKtJRx06sf0bWEuos3JfsdP5JQb+DmYKs/bzO36JmZHR2Llb
 oR/EQEVRiYV8Q+M1bpeLTReL0/tVJ0yx
X-Google-Smtp-Source: ABdhPJwGSCqnQhZEyqfA74Q3qEcGbDWSwK0xwXi4KbcWnIWu2bbm4tNiHp9f0/QTwusKaq+9TcjstDkn7Ba3
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:5700:9128:3106:b389])
 (user=qperret job=sendgmr) by 2002:a5d:4b50:: with SMTP id
 w16mr19856776wrs.71.1633424538044; Tue, 05 Oct 2021 02:02:18 -0700 (PDT)
Date: Tue,  5 Oct 2021 10:01:38 +0100
In-Reply-To: <20211005090155.734578-1-qperret@google.com>
Message-Id: <20211005090155.734578-2-qperret@google.com>
Mime-Version: 1.0
References: <20211005090155.734578-1-qperret@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH 1/2] KVM: arm64: Fix host stage-2 PGD refcount
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>, 
 David Brazdil <dbrazdil@google.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org
Cc: kernel-team@android.com
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

The KVM page-table library refcounts the pages of concatenated stage-2
PGDs individually. However, the host's stage-2 PGD is currently managed
by EL2 as a single high-order compound page, which can cause the
refcount of the tail pages to reach 0 when they really shouldn't, hence
corrupting the page-table.

Fix this by introducing a new hyp_split_page() helper in the EL2 page
allocator (matching EL1's split_page() function), and make use of it
from host_s2_zalloc_page().

Fixes: 1025c8c0c6ac ("KVM: arm64: Wrap the host with a stage 2")
Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/gfp.h |  1 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 +++++-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c  | 14 ++++++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
index fb0f523d1492..0a048dc06a7d 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
@@ -24,6 +24,7 @@ struct hyp_pool {
 
 /* Allocation */
 void *hyp_alloc_pages(struct hyp_pool *pool, unsigned short order);
+void hyp_split_page(struct hyp_page *page);
 void hyp_get_page(struct hyp_pool *pool, void *addr);
 void hyp_put_page(struct hyp_pool *pool, void *addr);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index bacd493a4eac..93a79736c283 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -35,7 +35,11 @@ const u8 pkvm_hyp_id = 1;
 
 static void *host_s2_zalloc_pages_exact(size_t size)
 {
-	return hyp_alloc_pages(&host_s2_pool, get_order(size));
+	void *addr = hyp_alloc_pages(&host_s2_pool, get_order(size));
+
+	hyp_split_page(hyp_virt_to_page(addr));
+
+	return addr;
 }
 
 static void *host_s2_zalloc_page(void *pool)
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index 41fc25bdfb34..a6e874e61a40 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -193,6 +193,20 @@ void hyp_get_page(struct hyp_pool *pool, void *addr)
 	hyp_spin_unlock(&pool->lock);
 }
 
+void hyp_split_page(struct hyp_page *p)
+{
+	unsigned short order = p->order;
+	unsigned int i;
+
+	p->order = 0;
+	for (i = 1; i < (1 << order); i++) {
+		struct hyp_page *tail = p + i;
+
+		tail->order = 0;
+		hyp_set_page_refcounted(tail);
+	}
+}
+
 void *hyp_alloc_pages(struct hyp_pool *pool, unsigned short order)
 {
 	unsigned short i = order;
-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
