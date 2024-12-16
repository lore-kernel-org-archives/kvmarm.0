Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811F220B1F3
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 17:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734371897; cv=none; b=oSc61llIAN5Ob/XVhMYu4ij+nNCFMI6XkM7QemyYA+s4dU70K0RKvZlHD4zjnQI5O7UfVM/yKGfCIrVoQ/xx0/S2CQCAyR1ABmzr17qsgEeFV+0UrI1KZRwJD9aZaRkFsco8ZkGBbOva3A0b5yi5JfuhiicicG2B+vj0s2bGv0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734371897; c=relaxed/simple;
	bh=JpCnhciCKgdtJ9loLkNK97utWA9gB73i3sJzS3IT1Ho=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oO8OMK6+SB/vNbBUQ9oAXBkW2RsuwSbDtYkx1zgLLgh3Zinfuwh3SOjfXYSMzFgWVFhpBP9irKYIVBHL+yGPBnmdHFVTTV6vjj++jKUW044700gx8+4LreEza9UIguCmo+Gkae/IcO7SOWUfz8MJwJ8pRCPpEqOYpzESguLjzLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cezo5kJ3; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cezo5kJ3"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-5d0b5036394so3298357a12.3
        for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 09:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734371894; x=1734976694; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aNbeauvqp5W7nuvO39aHLHQD/cqU02ozkTE0BlHZ7yk=;
        b=cezo5kJ3FB/bN5kw2jVRyjdMZbPPDv/ioq0ctTpWiJP01tgTUV3IFjRW9i4Qprq+De
         +hUjPoVUnmcxojgWYVP6C8AEJgxF1TV5UJKPGMrrCJbB2C1q6T5BIddGfGZFEwX/tnVz
         ackOcUkIE8HT2AizIHuOpCJVCvC93gUH1Jx2GEcqJRiymkeolwa3QpBE2VqLyTQI+7xf
         uXs6QwwtOGa6C7WYLycLmLRX8rCAg8zKbmrmqhFBN5vqhHgFiFPSu14hDzTbobXTUmwx
         1omXUw4WwoPA88jpA9pHHb8TCvdQHOtHHTvhut6LSCpdTtVOF9LbaBFSftbtH7zABmLP
         KfLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734371894; x=1734976694;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aNbeauvqp5W7nuvO39aHLHQD/cqU02ozkTE0BlHZ7yk=;
        b=gvEO/wzjbfHra2ysX25PqMDBs9B0GWTMUuW9sXTWxffKRB5tlQheKVr6AmasDSQATz
         3rysz20woicp0zSuKuBN2aeZpRiKyBKZvKlAYE/ESc3dUaL88PzerBmdiSB5ANS9jAT8
         4MFMtOhE9NDy87Pws0eR87MTYHrOYlrsjUnjkxOIjSdfz9o3qiVzHO76oNDgB/1k16LK
         goUw2XkFREEar96y/ZUHHOHbNY2WdFLxGtWxjkq46gbwKTnDK+CaVUjJId9kx+RZNPyc
         Kohs77xEtNoYGXKs5B469GNVW5tEBTnkmeE0tIXoI+PlrrZixgvE+inISG1+8plIkPMh
         z2sw==
X-Forwarded-Encrypted: i=1; AJvYcCU3DOQOvQuw6155+IZEbOknoiqwHNTmqPfqUltTDtCC5ySI7yPvtUxTgJSfaE0e05rRz+Eytnw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxebuw0E1K0be6CALp/Y5rMhKPOzhneU0B8x5SBobW5dwXQ/3Gq
	t7JyUCOUtwN5cgOPa/AcRwYB9qqetqqo7PAICPtNJ9Hx1D35vAX/C73yfCQNEDg0K8aV0vMG8cG
	qJlT63g==
X-Google-Smtp-Source: AGHT+IHxPGCw1y5ow9DgOQAPQ4TBp6JWxKWj0NrM4CPtdBj7NEcwM4Oy4ozYXUpiXyHJXYrisQbzG3ZC92H8
X-Received: from edon15.prod.google.com ([2002:aa7:d04f:0:b0:5d2:7266:10e])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:278b:b0:5d0:b7c5:c409
 with SMTP id 4fb4d7f45d1cf-5d63c3163f0mr12759048a12.14.1734371893900; Mon, 16
 Dec 2024 09:58:13 -0800 (PST)
Date: Mon, 16 Dec 2024 17:57:49 +0000
In-Reply-To: <20241216175803.2716565-1-qperret@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241216175803.2716565-5-qperret@google.com>
Subject: [PATCH v3 04/18] KVM: arm64: Move host page ownership tracking to the
 hyp vmemmap
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

We currently store part of the page-tracking state in PTE software bits
for the host, guests and the hypervisor. This is sub-optimal when e.g.
sharing pages as this forces to break block mappings purely to support
this software tracking. This causes an unnecessarily fragmented stage-2
page-table for the host in particular when it shares pages with Secure,
which can lead to measurable regressions. Moreover, having this state
stored in the page-table forces us to do multiple costly walks on the
page transition path, hence causing overhead.

In order to work around these problems, move the host-side page-tracking
logic from SW bits in its stage-2 PTEs to the hypervisor's vmemmap.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/memory.h |   6 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c    | 100 ++++++++++++++++-------
 arch/arm64/kvm/hyp/nvhe/setup.c          |   7 +-
 3 files changed, 77 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 45b8d1840aa4..8bd9a539f260 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -8,7 +8,7 @@
 #include <linux/types.h>
 
 /*
- * SW bits 0-1 are reserved to track the memory ownership state of each page:
+ * Bits 0-1 are reserved to track the memory ownership state of each page:
  *   00: The page is owned exclusively by the page-table owner.
  *   01: The page is owned by the page-table owner, but is shared
  *       with another entity.
@@ -43,7 +43,9 @@ static inline enum pkvm_page_state pkvm_getstate(enum kvm_pgtable_prot prot)
 struct hyp_page {
 	u16 refcount;
 	u8 order;
-	u8 reserved;
+
+	/* Host (non-meta) state. Guarded by the host stage-2 lock. */
+	enum pkvm_page_state host_state : 8;
 };
 
 extern u64 __hyp_vmemmap;
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index caba3e4bd09e..12bb5445fe47 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -201,8 +201,8 @@ static void *guest_s2_zalloc_page(void *mc)
 
 	memset(addr, 0, PAGE_SIZE);
 	p = hyp_virt_to_page(addr);
-	memset(p, 0, sizeof(*p));
 	p->refcount = 1;
+	p->order = 0;
 
 	return addr;
 }
@@ -268,6 +268,7 @@ int kvm_guest_prepare_stage2(struct pkvm_hyp_vm *vm, void *pgd)
 
 void reclaim_guest_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
 {
+	struct hyp_page *page;
 	void *addr;
 
 	/* Dump all pgtable pages in the hyp_pool */
@@ -279,7 +280,9 @@ void reclaim_guest_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
 	/* Drain the hyp_pool into the memcache */
 	addr = hyp_alloc_pages(&vm->pool, 0);
 	while (addr) {
-		memset(hyp_virt_to_page(addr), 0, sizeof(struct hyp_page));
+		page = hyp_virt_to_page(addr);
+		page->refcount = 0;
+		page->order = 0;
 		push_hyp_memcache(mc, addr, hyp_virt_to_phys);
 		WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(addr), 1));
 		addr = hyp_alloc_pages(&vm->pool, 0);
@@ -382,19 +385,28 @@ bool addr_is_memory(phys_addr_t phys)
 	return !!find_mem_range(phys, &range);
 }
 
-static bool addr_is_allowed_memory(phys_addr_t phys)
+static bool is_in_mem_range(u64 addr, struct kvm_mem_range *range)
+{
+	return range->start <= addr && addr < range->end;
+}
+
+static int check_range_allowed_memory(u64 start, u64 end)
 {
 	struct memblock_region *reg;
 	struct kvm_mem_range range;
 
-	reg = find_mem_range(phys, &range);
+	/*
+	 * Callers can't check the state of a range that overlaps memory and
+	 * MMIO regions, so ensure [start, end[ is in the same kvm_mem_range.
+	 */
+	reg = find_mem_range(start, &range);
+	if (!is_in_mem_range(end - 1, &range))
+		return -EINVAL;
 
-	return reg && !(reg->flags & MEMBLOCK_NOMAP);
-}
+	if (!reg || reg->flags & MEMBLOCK_NOMAP)
+		return -EPERM;
 
-static bool is_in_mem_range(u64 addr, struct kvm_mem_range *range)
-{
-	return range->start <= addr && addr < range->end;
+	return 0;
 }
 
 static bool range_is_memory(u64 start, u64 end)
@@ -454,8 +466,10 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 	if (kvm_pte_valid(pte))
 		return -EAGAIN;
 
-	if (pte)
+	if (pte) {
+		WARN_ON(addr_is_memory(addr) && hyp_phys_to_page(addr)->host_state != PKVM_NOPAGE);
 		return -EPERM;
+	}
 
 	do {
 		u64 granule = kvm_granule_size(level);
@@ -477,10 +491,33 @@ int host_stage2_idmap_locked(phys_addr_t addr, u64 size,
 	return host_stage2_try(__host_stage2_idmap, addr, addr + size, prot);
 }
 
+static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_state state)
+{
+	phys_addr_t end = addr + size;
+
+	for (; addr < end; addr += PAGE_SIZE)
+		hyp_phys_to_page(addr)->host_state = state;
+}
+
 int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
 {
-	return host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt,
-			       addr, size, &host_s2_pool, owner_id);
+	int ret;
+
+	if (!addr_is_memory(addr))
+		return -EPERM;
+
+	ret = host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt,
+			      addr, size, &host_s2_pool, owner_id);
+	if (ret)
+		return ret;
+
+	/* Don't forget to update the vmemmap tracking for the host */
+	if (owner_id == PKVM_ID_HOST)
+		__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
+	else
+		__host_update_page_state(addr, size, PKVM_NOPAGE);
+
+	return 0;
 }
 
 static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
@@ -604,35 +641,38 @@ static int check_page_state_range(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
-static enum pkvm_page_state host_get_page_state(kvm_pte_t pte, u64 addr)
-{
-	if (!addr_is_allowed_memory(addr))
-		return PKVM_NOPAGE;
-
-	if (!kvm_pte_valid(pte) && pte)
-		return PKVM_NOPAGE;
-
-	return pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte));
-}
-
 static int __host_check_page_state_range(u64 addr, u64 size,
 					 enum pkvm_page_state state)
 {
-	struct check_walk_data d = {
-		.desired	= state,
-		.get_page_state	= host_get_page_state,
-	};
+	u64 end = addr + size;
+	int ret;
+
+	ret = check_range_allowed_memory(addr, end);
+	if (ret)
+		return ret;
 
 	hyp_assert_lock_held(&host_mmu.lock);
-	return check_page_state_range(&host_mmu.pgt, addr, size, &d);
+	for (; addr < end; addr += PAGE_SIZE) {
+		if (hyp_phys_to_page(addr)->host_state != state)
+			return -EPERM;
+	}
+
+	return 0;
 }
 
 static int __host_set_page_state_range(u64 addr, u64 size,
 				       enum pkvm_page_state state)
 {
-	enum kvm_pgtable_prot prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, state);
+	if (hyp_phys_to_page(addr)->host_state == PKVM_NOPAGE) {
+		int ret = host_stage2_idmap_locked(addr, size, PKVM_HOST_MEM_PROT);
 
-	return host_stage2_idmap_locked(addr, size, prot);
+		if (ret)
+			return ret;
+	}
+
+	__host_update_page_state(addr, size, state);
+
+	return 0;
 }
 
 static int host_request_owned_transition(u64 *completer_addr,
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index cbdd18cd3f98..7e04d1c2a03d 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -180,7 +180,6 @@ static void hpool_put_page(void *addr)
 static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
 				     enum kvm_pgtable_walk_flags visit)
 {
-	enum kvm_pgtable_prot prot;
 	enum pkvm_page_state state;
 	phys_addr_t phys;
 
@@ -203,16 +202,16 @@ static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	case PKVM_PAGE_OWNED:
 		return host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HYP);
 	case PKVM_PAGE_SHARED_OWNED:
-		prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_SHARED_BORROWED);
+		hyp_phys_to_page(phys)->host_state = PKVM_PAGE_SHARED_BORROWED;
 		break;
 	case PKVM_PAGE_SHARED_BORROWED:
-		prot = pkvm_mkstate(PKVM_HOST_MEM_PROT, PKVM_PAGE_SHARED_OWNED);
+		hyp_phys_to_page(phys)->host_state = PKVM_PAGE_SHARED_OWNED;
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	return host_stage2_idmap_locked(phys, PAGE_SIZE, prot);
+	return 0;
 }
 
 static int fix_hyp_pgtable_refcnt_walker(const struct kvm_pgtable_visit_ctx *ctx,
-- 
2.47.1.613.gc27f4b7a9f-goog

