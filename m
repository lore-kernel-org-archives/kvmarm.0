Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D5FECAAD8
	for <kvmarm@archiver.kernel.org>; Wed, 14 Sep 2022 08:35:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FA154BC6F;
	Wed, 14 Sep 2022 04:35:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id onktHzB2U3t0; Wed, 14 Sep 2022 04:35:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CE3A4BC71;
	Wed, 14 Sep 2022 04:35:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBE6B4BC4B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:35:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GQBqe0lGviL7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Sep 2022 04:35:18 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D46AA4BC42
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Sep 2022 04:35:18 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id E6ECFB8163C;
 Wed, 14 Sep 2022 08:35:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCF6C433D6;
 Wed, 14 Sep 2022 08:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1663144516;
 bh=wTTdQWUvyZH6c3nEbsfnPkmCEbPghOtqLvRf1xG/40Q=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=T+ngWi3OxD2sR+hlSgKMwa58N9pNSJ7/3Upa60OO9ovhoIhsku3G3yoyru1Rob6CW
 aTi1KhZVzIY6inYs30BaOK7dwDMbhZc6yg+GxuxBQMALb2zb7FnfXbhMbatfezgNoq
 itC7fcNmr3Udb4gdIqlWro3cr0LVGf3eLRz4ef6ruy8sfStepJYnQ9cYao4sOhGCA5
 D5onhJKDzx8OGnG83UZ/ADSgGGc9KY19p7zCA2Lu/T26G4qmR58HaKw+dd0guc+Yp3
 02Mw7bWiMYRj/Gf3/cf3Lh63Oa7XBB4iculq74X9xtyk49Fo6lmKOcHwEP2fDPHYGS
 sWpOHZQ5eTsXg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 02/25] KVM: arm64: Allow attaching of non-coalescable pages
 to a hyp pool
Date: Wed, 14 Sep 2022 09:34:37 +0100
Message-Id: <20220914083500.5118-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220914083500.5118-1-will@kernel.org>
References: <20220914083500.5118-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>,
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

From: Quentin Perret <qperret@google.com>

All the contiguous pages used to initialize a 'struct hyp_pool' are
considered coalescable, which means that the hyp page allocator will
actively try to merge them with their buddies on the hyp_put_page() path.
However, using hyp_put_page() on a page that is not part of the inital
memory range given to a hyp_pool() is currently unsupported.

In order to allow dynamically extending hyp pools at run-time, add a
check to __hyp_attach_page() to allow inserting 'external' pages into
the free-list of order 0. This will be necessary to allow lazy donation
of pages from the host to the hypervisor when allocating guest stage-2
page-table pages at EL2.

Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/page_alloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index 1ded09fc9b10..0d15227aced8 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -93,11 +93,15 @@ static inline struct hyp_page *node_to_page(struct list_head *node)
 static void __hyp_attach_page(struct hyp_pool *pool,
 			      struct hyp_page *p)
 {
+	phys_addr_t phys = hyp_page_to_phys(p);
 	unsigned short order = p->order;
 	struct hyp_page *buddy;
 
 	memset(hyp_page_to_virt(p), 0, PAGE_SIZE << p->order);
 
+	if (phys < pool->range_start || phys >= pool->range_end)
+		goto insert;
+
 	/*
 	 * Only the first struct hyp_page of a high-order page (otherwise known
 	 * as the 'head') should have p->order set. The non-head pages should
@@ -116,6 +120,7 @@ static void __hyp_attach_page(struct hyp_pool *pool,
 		p = min(p, buddy);
 	}
 
+insert:
 	/* Mark the new head, and insert it */
 	p->order = order;
 	page_add_to_list(p, &pool->free_area[order]);
-- 
2.37.2.789.g6183377224-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
