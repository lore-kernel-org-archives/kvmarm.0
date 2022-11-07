Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A5BC4332F
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 21:58:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E7774B8D0;
	Mon,  7 Nov 2022 16:58:01 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wrF+tuHZpDAz; Mon,  7 Nov 2022 16:57:59 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D714D4B8A2;
	Mon,  7 Nov 2022 16:57:59 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 084AF4B831
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 16:57:58 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id m3jMquxUwHlS for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 16:57:56 -0500 (EST)
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E8C824B895
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 16:57:54 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1667858274;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=vlMEzdNgHf7wiuW7CTQkZnwfNnM0HFjoar2vWU53GNw=;
 b=Az2FCcw3bdQ5UtxP/IufM5r5Wfpsl7/R5fzIxcyu4RGrB6YUZyJFkMGwDObayCqK0Bs0ET
 57UoSVNBSmhxKOZKH+SNrXyWmGjwq2VPL3A4r/FT/dY34yanYNtIDCK5WfZH5NVKIbwA5C
 uybnFFlQQVmgMpPxpXjf8CEQ8q0aE4w=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v5 08/14] KVM: arm64: Protect stage-2 traversal with RCU
Date: Mon,  7 Nov 2022 21:56:38 +0000
Message-Id: <20221107215644.1895162-9-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-1-oliver.upton@linux.dev>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
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

Use RCU to safely walk the stage-2 page tables in parallel. Acquire and
release the RCU read lock when traversing the page tables. Defer the
freeing of table memory to an RCU callback. Indirect the calls into RCU
and provide stubs for hypervisor code, as RCU is not available in such a
context.

The RCU protection doesn't amount to much at the moment, as readers are
already protected by the read-write lock (all walkers that free table
memory take the write lock). Nonetheless, a subsequent change will
futher relax the locking requirements around the stage-2 MMU, thereby
depending on RCU.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 49 ++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 10 +++++-
 arch/arm64/kvm/mmu.c                 | 14 +++++++-
 3 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index e70cf57b719e..7634b6964779 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -37,6 +37,13 @@ static inline u64 kvm_get_parange(u64 mmfr0)
 
 typedef u64 kvm_pte_t;
 
+/*
+ * RCU cannot be used in a non-kernel context such as the hyp. As such, page
+ * table walkers used in hyp do not call into RCU and instead use other
+ * synchronization mechanisms (such as a spinlock).
+ */
+#if defined(__KVM_NVHE_HYPERVISOR__) || defined(__KVM_VHE_HYPERVISOR__)
+
 typedef kvm_pte_t *kvm_pteref_t;
 
 static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
@@ -44,6 +51,40 @@ static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared
 	return pteref;
 }
 
+static inline void kvm_pgtable_walk_begin(void) {}
+static inline void kvm_pgtable_walk_end(void) {}
+
+static inline bool kvm_pgtable_walk_lock_held(void)
+{
+	return true;
+}
+
+#else
+
+typedef kvm_pte_t __rcu *kvm_pteref_t;
+
+static inline kvm_pte_t *kvm_dereference_pteref(kvm_pteref_t pteref, bool shared)
+{
+	return rcu_dereference_check(pteref, !shared);
+}
+
+static inline void kvm_pgtable_walk_begin(void)
+{
+	rcu_read_lock();
+}
+
+static inline void kvm_pgtable_walk_end(void)
+{
+	rcu_read_unlock();
+}
+
+static inline bool kvm_pgtable_walk_lock_held(void)
+{
+	return rcu_read_lock_held();
+}
+
+#endif
+
 #define KVM_PTE_VALID			BIT(0)
 
 #define KVM_PTE_ADDR_MASK		GENMASK(47, PAGE_SHIFT)
@@ -202,11 +243,14 @@ struct kvm_pgtable {
  *					children.
  * @KVM_PGTABLE_WALK_TABLE_POST:	Visit table entries after their
  *					children.
+ * @KVM_PGTABLE_WALK_SHARED:		Indicates the page-tables may be shared
+ *					with other software walkers.
  */
 enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_LEAF			= BIT(0),
 	KVM_PGTABLE_WALK_TABLE_PRE		= BIT(1),
 	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
+	KVM_PGTABLE_WALK_SHARED			= BIT(3),
 };
 
 struct kvm_pgtable_visit_ctx {
@@ -223,6 +267,11 @@ struct kvm_pgtable_visit_ctx {
 typedef int (*kvm_pgtable_visitor_fn_t)(const struct kvm_pgtable_visit_ctx *ctx,
 					enum kvm_pgtable_walk_flags visit);
 
+static inline bool kvm_pgtable_walk_shared(const struct kvm_pgtable_visit_ctx *ctx)
+{
+	return ctx->flags & KVM_PGTABLE_WALK_SHARED;
+}
+
 /**
  * struct kvm_pgtable_walker - Hook into a page-table walk.
  * @cb:		Callback function to invoke during the walk.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 7c9782347570..d8d963521d4e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -171,6 +171,9 @@ static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data,
 				  enum kvm_pgtable_walk_flags visit)
 {
 	struct kvm_pgtable_walker *walker = data->walker;
+
+	/* Ensure the appropriate lock is held (e.g. RCU lock for stage-2 MMU) */
+	WARN_ON_ONCE(kvm_pgtable_walk_shared(ctx) && !kvm_pgtable_walk_lock_held());
 	return walker->cb(ctx, visit);
 }
 
@@ -281,8 +284,13 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.end	= PAGE_ALIGN(walk_data.addr + size),
 		.walker	= walker,
 	};
+	int r;
+
+	kvm_pgtable_walk_begin();
+	r = _kvm_pgtable_walk(pgt, &walk_data);
+	kvm_pgtable_walk_end();
 
-	return _kvm_pgtable_walk(pgt, &walk_data);
+	return r;
 }
 
 struct leaf_walk_data {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 73ae908eb5d9..52e042399ba5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -130,9 +130,21 @@ static void kvm_s2_free_pages_exact(void *virt, size_t size)
 
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
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
