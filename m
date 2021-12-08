Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF4A6C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  8 Dec 2021 15:23:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B6974B16C;
	Wed,  8 Dec 2021 10:23:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0iDfPdHSWnLD; Wed,  8 Dec 2021 10:23:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 349AA4B16E;
	Wed,  8 Dec 2021 10:23:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E8FC74B166
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 10:23:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IM+9kGQ7YvTe for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Dec 2021 10:23:07 -0500 (EST)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F09C94B092
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Dec 2021 10:23:06 -0500 (EST)
Received: by mail-wm1-f74.google.com with SMTP id
 187-20020a1c02c4000000b003335872db8dso1462150wmc.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Dec 2021 07:23:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=r27uQnQQtVbS3yI0XEL7/R9cqNgVk61W5XrAJ0Nw0Ww=;
 b=naFD9LicXyODJErTfR403GKq7ei5lGkVN74aV1AhQuJdG7N+BLYc8N+bJ37PaGYh39
 SdctqEgFuCTMuF5FWpGFNJe/hL1KT7NEPGKmw8HIn2GMoXMiktzuHvhDjfo+P9wZLdDt
 5mw45WlmYwCXT+ULUp/dRM12JoD6391Z4YYbBoWBD6E9W4TdWHwOmw+tuxk8VfsoPUFq
 FlUeaULBj+v/FzA7O1ubmKEHblv0W4KcYDQGhFM7mk6rf2k4sbm5nlj1FelFQx4kRRdl
 NCC26n15GXzmRdPue/vf6hJbdDqylJoqp5mGGTGvvUXzyNqZvoRj2euYDhHpZumkY6tV
 0qIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=r27uQnQQtVbS3yI0XEL7/R9cqNgVk61W5XrAJ0Nw0Ww=;
 b=kvPPuab6Y5Irus3G6eVmE/2VESAyYoPELyQ76tTjolFaINxpN3LJfKO4gYAid2pR/v
 BTN5imx8zaai9akNkeJTUCLmCiSXEMtdj+k9K+KskK8qacgZB4wR+wT3PtMkM+zPqRUn
 iJiUsUUArWjWkB8v+k197fp/qsMRJPnYn5cDkmiSIEwLB8wZMnDKQOh8aaA+L97yfntb
 zRAyTUngbrLFBWMni2LSxUnBgTyDMvaRS2H3lzwwmiSozpkORtvjGNtNv1uBsUt8uQCR
 e8Vt1WWMGej5Nb+7l03U/d+NPFVqrE+bVgvCiCbSntvRopYqY2jUezTsic971d9dMnC9
 wvJA==
X-Gm-Message-State: AOAM5309FlyPIuL/hNs2issbLNN/mOHLg+BCV4xDv7cjkhnWgCPILL8L
 QR7zLAwsDTzGdZ6hEJoCp+NqfEcg2Gxb
X-Google-Smtp-Source: ABdhPJyVBhdRR4oxaKYKZEdM1jxQ1KGBiBeRjA9M0nAxRA3k7kRNUlf5UDHP+FOncXY+IqD/xhb12Q9Uy29Q
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:c718:14b8:982a:57d5])
 (user=qperret job=sendgmr) by 2002:a5d:4d8b:: with SMTP id
 b11mr58840186wru.393.1638976985582; Wed, 08 Dec 2021 07:23:05 -0800 (PST)
Date: Wed,  8 Dec 2021 15:22:54 +0000
In-Reply-To: <20211208152300.2478542-1-qperret@google.com>
Message-Id: <20211208152300.2478542-2-qperret@google.com>
Mime-Version: 1.0
References: <20211208152300.2478542-1-qperret@google.com>
X-Mailer: git-send-email 2.34.1.400.ga245620fadb-goog
Subject: [PATCH 1/6] KVM: arm64: pkvm: Fix hyp_pool max order
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

The EL2 page allocator in protected mode maintains a per-pool max order
value to optimize allocations when the memory region it covers is small.
However, the max order value is currently under-estimated whenever the
number of pages in the region is a power of two. Fix the estimation.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/nvhe/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index 0bd7701ad1df..543cad6c376a 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -241,7 +241,7 @@ int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
 	int i;
 
 	hyp_spin_lock_init(&pool->lock);
-	pool->max_order = min(MAX_ORDER, get_order(nr_pages << PAGE_SHIFT));
+	pool->max_order = min(MAX_ORDER, get_order((nr_pages + 1) << PAGE_SHIFT));
 	for (i = 0; i < pool->max_order; i++)
 		INIT_LIST_HEAD(&pool->free_area[i]);
 	pool->range_start = phys;
-- 
2.34.1.400.ga245620fadb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
