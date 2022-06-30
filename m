Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F41C43334
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jun 2022 13:58:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E8D84B4C3;
	Thu, 30 Jun 2022 09:58:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4uGoYenLBkLV; Thu, 30 Jun 2022 09:58:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2507F4B4AF;
	Thu, 30 Jun 2022 09:58:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 551294B32E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:58:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NCISkU1tmysK for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2022 09:58:08 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 247D44B4D0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2022 09:58:06 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id A2794620E4;
 Thu, 30 Jun 2022 13:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BABA0C341CB;
 Thu, 30 Jun 2022 13:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1656597485;
 bh=CGAYlm140TLjTsKj1pjG8aKb8iu3Aml36A9Qr4wRzmg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=XspaDEvsZuFNNTyleQt8+dPtY3ge5fn5Ul2s8DJXkA3le/YemYo96lThuC7JJZrn2
 Cv1kViRakFl0XkCxswQdZ1leknhMDEGDD7YMWegfcaQOiRfcB07oa4nJG39avCne5m
 QNzqEV2Q0jByX6oyeMic32oijHe07wpP72Ug5pqOpBW8Z+EVkt35QrTgGb947oXDji
 UzeW+3yQ2qEK2Q1Ze7zm4LU/cT5WGJc+oz854b3dP0XIRj/uSVdTixb+iSp6JPJSm0
 yTu5pIZavoy+2uHLq5MuPfp3mcZtVXxUBLTxudj7utPXFOyTvaJq3iydcbmFzH0XMj
 hTMu2mRBcAy4g==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 02/24] KVM: arm64: Allow non-coalescable pages in a hyp_pool
Date: Thu, 30 Jun 2022 14:57:25 +0100
Message-Id: <20220630135747.26983-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220630135747.26983-1-will@kernel.org>
References: <20220630135747.26983-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

All the contiguous pages used to initialize a hyp_pool are considered
coalescable, which means that the hyp page allocator will actively
try to merge them with their buddies on the hyp_put_page() path.
However, using hyp_put_page() on a page that is not part of the inital
memory range given to a hyp_pool() is currently unsupported.

In order to allow dynamically extending hyp pools at run-time, add a
check to __hyp_attach_page() to allow inserting 'external' pages into
the free-list of order 0. This will be necessary to allow lazy
donation of pages from the host to the hypervisor when allocating guest
stage-2 page-table pages at EL2.

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
2.37.0.rc0.161.g10f37bed90-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
