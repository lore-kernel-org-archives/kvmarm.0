Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECA6C433FE
	for <kvmarm@archiver.kernel.org>; Fri,  7 Oct 2022 23:29:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF8F640BEE;
	Fri,  7 Oct 2022 19:29:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rTrgpjus-9LO; Fri,  7 Oct 2022 19:29:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1CA141071;
	Fri,  7 Oct 2022 19:29:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7AA540C58
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Oct 2022 19:29:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AFQNXlc8jgJp for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 Oct 2022 19:29:23 -0400 (EDT)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9289040E25
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 Oct 2022 19:29:23 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1665185362;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=VSPfpEbpaF1HVCxRtymHK1iFw2Ndlq59kfZN9gAzh+o=;
 b=cNg6oTFgzO6GY0L1TSYs7VSjRhECOO45tRYmyHyGTLCGVfbUe1OMQZDUhlHB5r2lpF6zDS
 2D+3RKe920GacKOattZz33WA70jNktLYMN/nLuxTOfrgoBEWrnF636GWOmA8Torc/pEFPj
 QL2sulno3gIzHRFCHhAZJcOqkha0/VA=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v2 09/15] KVM: arm64: Free removed stage-2 tables in RCU
 callback
Date: Fri,  7 Oct 2022 23:28:12 +0000
Message-Id: <20221007232818.459650-10-oliver.upton@linux.dev>
In-Reply-To: <20221007232818.459650-1-oliver.upton@linux.dev>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
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

There is no real urgency to free a stage-2 subtree that was pruned.
Nonetheless, KVM does the tear down in the stage-2 fault path while
holding the MMU lock.

Free removed stage-2 subtrees after an RCU grace period. To guarantee
all stage-2 table pages are freed before killing a VM, add an
rcu_barrier() to the flush path.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/mmu.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 04a25319abb0..66eede0fbb36 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -104,9 +104,21 @@ static void *kvm_host_zalloc_pages_exact(size_t size)
 
 static struct kvm_pgtable_mm_ops kvm_s2_mm_ops;
 
+static void stage2_free_removed_table_rcu_cb(struct rcu_head *head)
+{
+	struct page *page = container_of(head, struct page, rcu_head);
+	void *pgtable = page_to_virt(page);
+	u32 level = page_private(page);
+
+	kvm_pgtable_stage2_free_removed(&kvm_s2_mm_ops, pgtable, level);
+}
+
 static void stage2_free_removed_table(void *addr, u32 level)
 {
-	kvm_pgtable_stage2_free_removed(&kvm_s2_mm_ops, addr, level);
+	struct page *page = virt_to_page(addr);
+
+	set_page_private(page, (unsigned long)level);
+	call_rcu(&page->rcu_head, stage2_free_removed_table_rcu_cb);
 }
 
 static void kvm_host_get_page(void *addr)
-- 
2.38.0.rc1.362.ged0d419d3c-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
