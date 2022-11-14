Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E2CDC433FE
	for <kvmarm@archiver.kernel.org>; Mon, 14 Nov 2022 20:11:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88BFD4B90A;
	Mon, 14 Nov 2022 15:11:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MdLK-hHJiX30; Mon, 14 Nov 2022 15:11:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E93B4B949;
	Mon, 14 Nov 2022 15:11:46 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C2B54B949
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2022 15:11:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X+wGieylDm-6 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Nov 2022 15:11:43 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2010E4B8CD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Nov 2022 15:11:42 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668456701;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=mglCJONHjZaMkBoIgcjixSkCCSFrzRBKYTMx418wVb4=;
 b=oja4AWIi6mYdgYeWVFJ67Cqf9vP4TIUr4x/wU74OS60f/fSGWh3gGuvD4GPrnpZnx90l/i
 VttLBxAj+U4AeyZ91bChgEKiB0+OiIzyb2uhL8ZQ+9QFn96jNJQx0u/v6/1iAHZ/62fWMD
 c/OEw66RkQ10zTcxDtKRoUdPA010VyQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: [PATCH 1/1] KVM: arm64: Use a separate function for hyp stage-1 walks
Date: Mon, 14 Nov 2022 20:11:27 +0000
Message-Id: <20221114201127.1814794-2-oliver.upton@linux.dev>
In-Reply-To: <20221114201127.1814794-1-oliver.upton@linux.dev>
References: <20221114201127.1814794-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
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

A subsequent change to the page table walkers adds RCU protection for
walking stage-2 page tables. KVM uses a global lock to serialize hyp
stage-1 walks, meaning RCU protection is quite meaningless for
protecting hyp stage-1 walkers.

Add a new helper, kvm_pgtable_hyp_walk(), for use when walking hyp
stage-1 tables. Call directly into __kvm_pgtable_walk() as table
concatenation is not a supported feature at stage-1.

No functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c      |  2 +-
 arch/arm64/kvm/hyp/pgtable.c         | 18 +++++++++++++++---
 3 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index a874ce0ce7b5..43b2f1882e11 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -596,6 +596,30 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
 int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		     struct kvm_pgtable_walker *walker);
 
+/**
+ * kvm_pgtable_hyp_walk() - Walk a hyp stage-1 page-table.
+ * @pgt:	Page-table structure initialized by kvm_pgtable_hyp_init().
+ * @addr:	Input address for the start of the walk.
+ * @size:	Size of the range to walk.
+ * @walker:	Walker callback description.
+ *
+ * The offset of @addr within a page is ignored and @size is rounded-up to
+ * the next page boundary.
+ *
+ * The walker will walk the page-table entries corresponding to the input
+ * address range specified, visiting entries according to the walker flags.
+ * Invalid entries are treated as leaf entries. Leaf entries are reloaded
+ * after invoking the walker callback, allowing the walker to descend into
+ * a newly installed table.
+ *
+ * Returning a negative error code from the walker callback function will
+ * terminate the walk immediately with the same error code.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_hyp_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
+			 struct kvm_pgtable_walker *walker);
+
 /**
  * kvm_pgtable_get_leaf() - Walk a page-table and retrieve the leaf entry
  *			    with its level.
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 1068338d77f3..55eeb3ed1891 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -246,7 +246,7 @@ static int finalize_host_mappings(void)
 		struct memblock_region *reg = &hyp_memory[i];
 		u64 start = (u64)hyp_phys_to_virt(reg->base);
 
-		ret = kvm_pgtable_walk(&pkvm_pgtable, start, reg->size, &walker);
+		ret = kvm_pgtable_hyp_walk(&pkvm_pgtable, start, reg->size, &walker);
 		if (ret)
 			return ret;
 	}
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 5bca9610d040..385fa1051b5d 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -335,6 +335,18 @@ int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
 	return ret;
 }
 
+int kvm_pgtable_hyp_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
+			 struct kvm_pgtable_walker *walker)
+{
+	struct kvm_pgtable_walk_data data = {
+		.walker	= walker,
+		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
+		.end	= PAGE_ALIGN(addr + size),
+	};
+
+	return __kvm_pgtable_walk(&data, pgt->mm_ops, pgt->pgd, pgt->start_level);
+}
+
 struct hyp_map_data {
 	u64				phys;
 	kvm_pte_t			attr;
@@ -454,7 +466,7 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 	if (ret)
 		return ret;
 
-	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	ret = kvm_pgtable_hyp_walk(pgt, addr, size, &walker);
 	dsb(ishst);
 	isb();
 	return ret;
@@ -512,7 +524,7 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	if (!pgt->mm_ops->page_count)
 		return 0;
 
-	kvm_pgtable_walk(pgt, addr, size, &walker);
+	kvm_pgtable_hyp_walk(pgt, addr, size, &walker);
 	return unmapped;
 }
 
@@ -557,7 +569,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 	};
 
-	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
+	WARN_ON(kvm_pgtable_hyp_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
 	pgt->mm_ops->put_page(kvm_dereference_pteref(pgt->pgd, false));
 	pgt->pgd = NULL;
 }
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
