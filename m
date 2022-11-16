Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F44FC4332F
	for <kvmarm@archiver.kernel.org>; Wed, 16 Nov 2022 16:57:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 39A0F4B862;
	Wed, 16 Nov 2022 11:57:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HddM6D2u45Zw; Wed, 16 Nov 2022 11:57:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCE0C4B890;
	Wed, 16 Nov 2022 11:57:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F45F4B890
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 11:57:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zhKnJM9Z8nU4 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 Nov 2022 11:57:17 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1F4384B8D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 Nov 2022 11:57:16 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1668617835;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=PJOu0pfrq2jAQIo6Bks9pUoZjM76RoOURl952XiuGoE=;
 b=PLFCEsIpQHYPkHrDRzIwl8KiYXr9h6qIjwmBInUzR+YMr4Lv9YkHUQZRZ7HacgHYkgFyp3
 PrwMAStUr2lAu7NBIGYF321EzC0G0p/LHqYPzNPnKwy+VWYDYEFecPyf3Tj3Bz+NdM95IP
 7tnXy3Nj6aI+1ptdxnUCt+9M9WO0hlM=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Subject: [PATCH v3 2/2] KVM: arm64: Don't acquire RCU read lock for exclusive
 table walks
Date: Wed, 16 Nov 2022 16:56:55 +0000
Message-Id: <20221116165655.2649475-3-oliver.upton@linux.dev>
In-Reply-To: <20221116165655.2649475-1-oliver.upton@linux.dev>
References: <20221116165655.2649475-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Marek Szyprowski <m.szyprowski@samsung.com>
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

Marek reported a BUG resulting from the recent parallel faults changes,
as the hyp stage-1 map walker attempted to allocate table memory while
holding the RCU read lock:

  BUG: sleeping function called from invalid context at
  include/linux/sched/mm.h:274
  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
  preempt_count: 0, expected: 0
  RCU nest depth: 1, expected: 0
  2 locks held by swapper/0/1:
    #0: ffff80000a8a44d0 (kvm_hyp_pgd_mutex){+.+.}-{3:3}, at:
  __create_hyp_mappings+0x80/0xc4
    #1: ffff80000a927720 (rcu_read_lock){....}-{1:2}, at:
  kvm_pgtable_walk+0x0/0x1f4
  CPU: 2 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc3+ #5918
  Hardware name: Raspberry Pi 3 Model B (DT)
  Call trace:
    dump_backtrace.part.0+0xe4/0xf0
    show_stack+0x18/0x40
    dump_stack_lvl+0x8c/0xb8
    dump_stack+0x18/0x34
    __might_resched+0x178/0x220
    __might_sleep+0x48/0xa0
    prepare_alloc_pages+0x178/0x1a0
    __alloc_pages+0x9c/0x109c
    alloc_page_interleave+0x1c/0xc4
    alloc_pages+0xec/0x160
    get_zeroed_page+0x1c/0x44
    kvm_hyp_zalloc_page+0x14/0x20
    hyp_map_walker+0xd4/0x134
    kvm_pgtable_visitor_cb.isra.0+0x38/0x5c
    __kvm_pgtable_walk+0x1a4/0x220
    kvm_pgtable_walk+0x104/0x1f4
    kvm_pgtable_hyp_map+0x80/0xc4
    __create_hyp_mappings+0x9c/0xc4
    kvm_mmu_init+0x144/0x1cc
    kvm_arch_init+0xe4/0xef4
    kvm_init+0x3c/0x3d0
    arm_init+0x20/0x30
    do_one_initcall+0x74/0x400
    kernel_init_freeable+0x2e0/0x350
    kernel_init+0x24/0x130
    ret_from_fork+0x10/0x20

Since the hyp stage-1 table walkers are serialized by kvm_hyp_pgd_mutex,
RCU protection really doesn't add anything. Don't acquire the RCU read
lock for an exclusive walk. While at it, add a warning which codifies
the lack of support for shared walks in the hypervisor code.

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 22 ++++++++++++++++------
 arch/arm64/kvm/hyp/pgtable.c         |  4 ++--
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index f23af693e3c5..a07fc5e35a8c 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -229,8 +229,16 @@ static inline kvm_pte_t *kvm_dereference_pteref(struct kvm_pgtable_walker *walke
 	return pteref;
 }
 
-static inline void kvm_pgtable_walk_begin(void) {}
-static inline void kvm_pgtable_walk_end(void) {}
+static inline void kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
+{
+	/*
+	 * Due to the lack of RCU (or a similar protection scheme), only
+	 * non-shared table walkers are allowed in the hypervisor.
+	 */
+	WARN_ON(walker->flags & KVM_PGTABLE_WALK_SHARED);
+}
+
+static inline void kvm_pgtable_walk_end(struct kvm_pgtable_walker *walker) {}
 
 static inline bool kvm_pgtable_walk_lock_held(void)
 {
@@ -247,14 +255,16 @@ static inline kvm_pte_t *kvm_dereference_pteref(struct kvm_pgtable_walker *walke
 	return rcu_dereference_check(pteref, !(walker->flags & KVM_PGTABLE_WALK_SHARED));
 }
 
-static inline void kvm_pgtable_walk_begin(void)
+static inline void kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
 {
-	rcu_read_lock();
+	if (walker->flags & KVM_PGTABLE_WALK_SHARED)
+		rcu_read_lock();
 }
 
-static inline void kvm_pgtable_walk_end(void)
+static inline void kvm_pgtable_walk_end(struct kvm_pgtable_walker *walker)
 {
-	rcu_read_unlock();
+	if (walker->flags & KVM_PGTABLE_WALK_SHARED)
+		rcu_read_unlock();
 }
 
 static inline bool kvm_pgtable_walk_lock_held(void)
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b5b91a882836..d6f3753cb87e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -289,9 +289,9 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	};
 	int r;
 
-	kvm_pgtable_walk_begin();
+	kvm_pgtable_walk_begin(walker);
 	r = _kvm_pgtable_walk(pgt, &walk_data);
-	kvm_pgtable_walk_end();
+	kvm_pgtable_walk_end(walker);
 
 	return r;
 }
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
