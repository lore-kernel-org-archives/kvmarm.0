Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E1921ABD7
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290842; cv=none; b=qyjj/iWHxImtAnwx/QvkLAA3/2s1tUC0k0sX8WlxXm8yhMSD3KojXYRdzZf/AE+dGF7RdDny8xyNSSKj0Bs4j+hdoHxKn8vuXJzgy6wTfUrdKYg1I93CP7HtiCGHdQ5KTsjNRFqFGUZIOL3r0yOF5xc2a/OFRhtiZrjoAG2E08g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290842; c=relaxed/simple;
	bh=tUO6XUOXHIpN0D6Ji7ySlMGJGK6uB/X57tK+8a5kMCc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Snl5iujveYuceLT9/oHU/BuN8kiCvluAm6NpllPZzmnpio4cYrFOwlHTByvX2cQLHa0rzRjTIcIqf1xLmDtuVF937tfhPFShdUTGsjTPsifY3aGssHnFDAlmkGQEqX8KGCZyRJp2LUldz5l3JZu9n6rJNsyqchzhGs/NKVeW/J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bhXg+igc; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bhXg+igc"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fe44ce385so40571695e9.0
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290838; x=1779895638; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rpLl0BzoAnI0iTWjiJTM36ynoL2K/MApXE5nl+el19c=;
        b=bhXg+igc+A62vBSZFAfqo7PkDlXP1hHzyesq1AvyRtaQeuKyV6GCnaOGh38bXPvrij
         tm1Ed2siVqSRk2GrLb6Tyjo9Pg1Gm3+FeCA7O3aV95P3Xoj7P8zr5/JpugY1eb0/jQUd
         LF90usCOtS2HzD7d6hEMynKVh5RRjf6ki9GVFh/VICN0ICG/mViAXgpxQjVg98XoteBH
         Ftq+ao3rjTmp0+FV5xTVDu98Mc4yc6F9zJOCYdDx/rrwxC7kWHcNX/ltd/1QxHNb/Y7q
         s8ii11nPLSCiH26OdEgNIecpTZBFCEeZeLi7IW8pnwyFmzS8kyqPplL0TG4ukKURHeQ/
         ANsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290838; x=1779895638;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rpLl0BzoAnI0iTWjiJTM36ynoL2K/MApXE5nl+el19c=;
        b=qUpCKt7Z8h6aGrH06/xCWd4AG7QjaNCX+9XPcH+iK8Ncrl1fsIZQsjX8Il3wmEHVJA
         0prQTzY813G9Yier74dxiwZLjAlv9n7sc2s9O/OpROPvOQFmT3SCG0CKwrMg5keX93qV
         GNvrHmdiZdHs4y8d07aC67/KkqhMHKHlYYGNvx44hdxoh8+ODt7SAScXHky/YryPoGa3
         9Y0lYgjEqmZJyGfRq7G1uyD6kseM60DVi8dGzYB2bHFyrLvbPsv5gK7+yIzPRXfa4Cby
         6+VR1JF7yOCQW8YHiW1hEaZw6uzPOl53cCDIIssckF5OfLXtbibW78CrASY2dgnDeam5
         irsQ==
X-Forwarded-Encrypted: i=1; AFNElJ8OW5xN3Xhl0elU8/9Oj66rywCaRP8PgOsCzJImQXJ/0NoMeMQ2vUCyQvlkfNR+Nni2CN66K5A=@lists.linux.dev
X-Gm-Message-State: AOJu0YypYed/UVKJaFhAUVmZZ/WD1Shof4gwSsX+UbwGhdoA1mizKDZ+
	K1QWqqDnQRXPu7qUjdGm0+zMduYhGI+EAVU0s/SCU7o51TzBrM66dV/kfkkdPuya4epYZnNOIA1
	ABtwCmfeq736iKtlajAr/2w==
X-Received: from wmpi26.prod.google.com ([2002:a05:600c:4b1a:b0:489:1c31:2982])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:620d:b0:490:18cb:e820 with SMTP id 5b1f17b1804b1-49018cbf419mr140275415e9.21.1779290838353;
 Wed, 20 May 2026 08:27:18 -0700 (PDT)
Date: Wed, 20 May 2026 16:26:37 +0100
In-Reply-To: <20260520152650.4107895-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520152650.4107895-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Message-ID: <20260520152650.4107895-5-vdonnefort@google.com>
Subject: [PATCH 04/17] KVM: arm64: Add a heap allocator for the pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Currently, memory used by the hypervisor comes from donations that are
embedded within HVCs. e.g. __pkvm_init_vm()'s hyp_vm.

This is cumbersome: the host needs to know the size of those
struct, the memory must be page-aligned and physically contiguous which
may be difficult to satisfy when host memory is highly fragmented.

Create a heap allocator to manage VA-contiguous memory. This allocator
grows upward, recycles unused chunks of memory and provides a simple API
to allocate and free:

  hyp_alloc(size), hyp_free(addr)

This heap allocator also manages the underlying physical memory,
allowing the host to top up the allocator's pool and reclaim memory.

  hyp_alloc_topup(), hyp_alloc_reclaim().

Pages remain mapped in the allocator's VA-space as long as they are not
reclaimed.

When the allocator runs out of memory, hyp_alloc() fails and
hyp_alloc_errno() returns -ENOMEM to signal that a top-up is required.

Additionally, harden the allocator by hashing chunk headers to detect
metadata corruption.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/alloc.h b/arch/arm64/kvm/hyp/include/nvhe/alloc.h
new file mode 100644
index 000000000000..8f87a63f8946
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/alloc.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __KVM_NVHE_ALLOC__
+#define __KVM_NVHE_ALLOC__
+#include <linux/types.h>
+
+#include <asm/kvm_host.h>
+
+void *hyp_alloc(size_t size);
+int hyp_alloc_errno(void);
+u32 hyp_alloc_topup_needed(void);
+void hyp_free(void *addr);
+
+int hyp_alloc_init(size_t size);
+int hyp_alloc_topup(struct kvm_hyp_memcache *host_mc);
+unsigned long hyp_alloc_reclaimable(void);
+void hyp_alloc_reclaim(struct kvm_hyp_memcache *host_mc, unsigned long target);
+#endif
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 62cdfbff7562..66362bfa7061 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -23,7 +23,7 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 CFLAGS_switch.nvhe.o += -Wno-override-init
 
 hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
-	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
+	 hyp-main.o hyp-smp.o psci-relay.o alloc.o early_alloc.o page_alloc.o \
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o
diff --git a/arch/arm64/kvm/hyp/nvhe/alloc.c b/arch/arm64/kvm/hyp/nvhe/alloc.c
new file mode 100644
index 000000000000..183336f297c3
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/alloc.c
@@ -0,0 +1,1037 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026 Google LLC
+ * Author: Vincent Donnefort <vdonnefort@google.com>
+ *
+ * This heap allocator manages a reserved VA space range, dynamically mapping
+ * and unmapping physical pages on-demand to minimise the pKVM hypervisor
+ * footprint. As memory is reclaimed and relinquished to the host, unmapped
+ * holes are introduced within the VA space. To prevent orphans mapped regions,
+ * neighboring unused chunks cannot be merged if they are separated by an
+ * unmapped region.
+ *
+ */
+
+#include <nvhe/alloc.h>
+#include <nvhe/mem_protect.h>
+#include <nvhe/mm.h>
+#include <nvhe/spinlock.h>
+
+#include <linux/build_bug.h>
+#include <linux/hash.h>
+
+#define MIN_ALLOC_SIZE 8UL /* Must be a power of two */
+
+/**
+ * struct chunk_hdr - Chunk header
+ * @next:       offset from this chunk header to the next one.
+ * @prev:       offset from this chunk header to the previous one.
+ * @__unmapped: Internal field containing the offset to the unmapped page
+ *              boundary, multiplexed with the allocation state flag.
+ * @hash:       Hash computed over the chunk header.
+ */
+struct chunk_hdr {
+	u32			next;
+	u32			prev;
+#define USED_BIT_MASK		1U
+	u32			__unmapped;
+	u32			hash;
+	char			data[];
+} __aligned(MIN_ALLOC_SIZE);
+
+/**
+ * struct hyp_allocator - Heap allocator
+ * @start:		Start in the allocator's reserved virtual address range.
+ * @end:		End in the allocator's reserved virtual address range.
+ * @last_used:		Pointer to the end of the last used chunk. This is
+ *			necessary for the last chunk in the list as the
+ *			allocated size of a chunk is derived from the next one.
+ * @first_unmapped:	Pointer to the first unmapped page in the
+ *			allocator's range. This is only necessary and
+ *			updated when no chunk is in the list.
+ * @head:		Head of the chunk list.
+ * @tail:		Tail of the chunk list.
+ * @mc:			Memcache containing pre-allocated pages for mapping.
+ * @lock:		Spinlock protecting the allocator state.
+ * @errno:		Per-CPU error code for allocation failures.
+ * @topup_needed:	Per-CPU page counter needed to top-up the memcache.
+ */
+struct hyp_allocator {
+	void			*start;
+	void			*end;
+	void			*last_used;
+	void			*first_unmapped;
+	struct chunk_hdr	*head;
+	struct chunk_hdr	*tail;
+	struct kvm_hyp_memcache	mc;
+	hyp_spinlock_t		lock;
+	int __percpu		*errno;
+	u32 __percpu		*topup_needed;
+};
+
+static u32 chunk_hash_compute(const struct chunk_hdr *chunk)
+{
+	u32 hash = 0;
+
+	BUILD_BUG_ON(sizeof(*chunk) != 16);
+
+	hash ^= hash_64(*(const u64 *)chunk, 32);
+	hash ^= hash_32(chunk->__unmapped, 32);
+	return hash;
+}
+
+static void chunk_set_hash(struct chunk_hdr *chunk)
+{
+	if (chunk)
+		chunk->hash = chunk_hash_compute(chunk);
+}
+
+static void chunk_check_hash(const struct chunk_hdr *chunk)
+{
+	if (chunk)
+		WARN_ON(chunk->hash != chunk_hash_compute(chunk));
+}
+
+static bool chunk_is_used(const struct chunk_hdr *chunk)
+{
+	return !!(chunk->__unmapped & USED_BIT_MASK);
+}
+
+static void chunk_set_used(struct chunk_hdr *chunk)
+{
+	chunk->__unmapped |= USED_BIT_MASK;
+}
+
+static void chunk_set_unused(struct chunk_hdr *chunk)
+{
+	chunk->__unmapped &= ~USED_BIT_MASK;
+}
+
+static void *chunk_unmapped(const struct chunk_hdr *chunk)
+{
+	u32 offset = chunk->__unmapped & ~USED_BIT_MASK;
+
+	if (!offset)
+		return NULL;
+
+	return (void *)chunk + offset;
+}
+
+static void __chunk_set_unmapped(struct chunk_hdr *chunk, u32 unmapped)
+{
+	chunk->__unmapped = unmapped | (chunk_is_used(chunk) ? USED_BIT_MASK : 0);
+}
+
+static void chunk_set_unmapped(struct chunk_hdr *chunk, void *unmapped)
+{
+	WARN_ON(!PAGE_ALIGNED(unmapped));
+
+	if (unmapped) {
+		WARN_ON((void *)chunk > unmapped);
+		__chunk_set_unmapped(chunk, unmapped - (void *)chunk);
+	} else {
+		__chunk_set_unmapped(chunk, 0);
+	}
+}
+
+static void *chunk_data(const struct chunk_hdr *chunk)
+{
+	return (void *)&chunk->data;
+}
+
+static struct chunk_hdr *__chunk_next(const struct chunk_hdr *chunk)
+{
+	if (!chunk->next)
+		return NULL;
+
+	return (struct chunk_hdr *)((void *)chunk + chunk->next);
+}
+
+static struct chunk_hdr *__chunk_prev(const struct chunk_hdr *chunk)
+{
+	if (!chunk->prev)
+		return NULL;
+
+	return (struct chunk_hdr *)((void *)chunk - chunk->prev);
+}
+
+static void chunk_set_next(struct chunk_hdr *chunk, struct chunk_hdr *next)
+{
+	if (!chunk)
+		return;
+
+	if (next) {
+		WARN_ON(chunk > next);
+		chunk->next = (void *)next - (void *)chunk;
+	} else {
+		chunk->next = 0;
+	}
+}
+
+static void chunk_set_prev(struct chunk_hdr *chunk, struct chunk_hdr *prev)
+{
+	if (!chunk)
+		return;
+
+	if (prev) {
+		WARN_ON(chunk < prev);
+		chunk->prev = (void *)chunk - (void *)prev;
+	} else {
+		chunk->prev = 0;
+	}
+}
+
+static struct chunk_hdr *chunk_get_next(const struct chunk_hdr *chunk)
+{
+	struct chunk_hdr *next = __chunk_next(chunk);
+
+	chunk_check_hash(next);
+	return next;
+}
+
+static struct chunk_hdr *chunk_get_prev(const struct chunk_hdr *chunk)
+{
+	struct chunk_hdr *prev = __chunk_prev(chunk);
+
+	chunk_check_hash(prev);
+	return prev;
+}
+
+static struct chunk_hdr *chunk_get(struct chunk_hdr *chunk)
+{
+	chunk_check_hash(chunk);
+	return chunk;
+}
+
+#define chunk_hdr_size() \
+	offsetof(struct chunk_hdr, data)
+
+#define chunk_min_size() \
+	(chunk_hdr_size() + MIN_ALLOC_SIZE)
+
+static size_t chunk_data_size(const struct chunk_hdr *chunk, struct hyp_allocator *allocator)
+{
+	struct chunk_hdr *next = chunk_get_next(chunk);
+	void *end;
+
+	if (next)
+		end = (void *)next;
+	else
+		end = allocator->end;
+
+	return end - chunk_data(chunk);
+}
+
+static size_t chunk_mapped_data_size(const struct chunk_hdr *chunk, struct hyp_allocator *allocator)
+{
+	void *unmapped = chunk_unmapped(chunk);
+
+	if (!unmapped)
+		return chunk_data_size(chunk, allocator);
+
+	return unmapped - chunk_data(chunk);
+}
+
+static size_t chunk_used_size(const struct chunk_hdr *chunk, struct hyp_allocator *allocator)
+{
+	struct chunk_hdr *next = chunk_get_next(chunk);
+
+	if (!chunk_is_used(chunk))
+		return 0;
+
+	if (next)
+		return chunk_mapped_data_size(chunk, allocator);
+
+	return allocator->last_used - chunk_data(chunk);
+}
+
+static void chunk_list_insert(struct chunk_hdr *chunk, struct chunk_hdr *prev)
+{
+	struct chunk_hdr *next = NULL;
+
+	WARN_ON(!chunk);
+
+	if (prev) {
+		next = chunk_get_next(prev);
+		chunk_set_next(prev, chunk);
+		chunk_set_hash(prev);
+	}
+
+	if (next) {
+		chunk_set_prev(next, chunk);
+		chunk_set_hash(next);
+	}
+
+	chunk_set_next(chunk, next);
+	chunk_set_prev(chunk, prev);
+}
+
+static void chunk_list_del(struct chunk_hdr *chunk)
+{
+	struct chunk_hdr *prev, *next;
+
+	WARN_ON(!chunk);
+
+	prev = chunk_get_prev(chunk);
+	next = chunk_get_next(chunk);
+
+	if (prev) {
+		chunk_set_next(prev, next);
+		chunk_set_hash(prev);
+	}
+
+	if (next) {
+		chunk_set_prev(next, prev);
+		chunk_set_hash(next);
+	}
+}
+
+/*
+ * Return a fixup start address for chunk creation. It makes sure the chunk
+ * header doesn't cross any page boundary and that it leaves enough space at the
+ * start of page. This is intended to prevent orphan mapped regions during chunk
+ * memory reclaim
+ */
+static void *chunk_start(void *start)
+{
+	void *page = PTR_ALIGN(start, PAGE_SIZE);
+
+	if (page - start < chunk_hdr_size())
+		return page;
+
+	page = PTR_ALIGN_DOWN(start, PAGE_SIZE);
+	if (start - page < chunk_min_size())
+		return page + chunk_min_size();
+
+	return start;
+}
+
+static int hyp_allocator_map(struct hyp_allocator *allocator, struct chunk_hdr *chunk,
+			     struct chunk_hdr *next,
+			     void *addr, void *end)
+{
+	void *unmapped = chunk ? chunk_unmapped(chunk) : allocator->first_unmapped;
+
+	/*
+	 * hyp_allocator_can_create_chunk() already validates addr/end
+	 * belong to the chunk.
+	 */
+	WARN_ON(end <= addr);
+
+	/* The chunk does not span an unmapped region */
+	if (!unmapped)
+		return 0;
+
+	while (unmapped < end) {
+		void *page = pop_hyp_memcache(&allocator->mc, hyp_phys_to_virt);
+		int ret;
+
+		if (!page) {
+			end = PTR_ALIGN(end, PAGE_SIZE);
+			*this_cpu_ptr(allocator->topup_needed) =
+				(unsigned long)(end - unmapped) >> PAGE_SHIFT;
+			return -ENOMEM;
+		}
+
+		ret = __hyp_allocator_map(unmapped, hyp_virt_to_phys(page));
+		if (ret) {
+			push_hyp_memcache(&allocator->mc, page, hyp_virt_to_phys);
+			return ret;
+		}
+
+		unmapped += PAGE_SIZE;
+
+		/*
+		 * Reset the unmap field if we've reached the next chunk or the
+		 * allocator boundary.
+		 */
+		if (unmapped == (next ?: allocator->end))
+			unmapped = 0;
+
+		if (chunk) {
+			chunk_set_unmapped(chunk, unmapped);
+			chunk_set_hash(chunk);
+		} else {
+			allocator->first_unmapped = unmapped;
+		}
+
+		if (!unmapped)
+			break;
+	}
+
+	return 0;
+}
+
+static void hyp_allocator_unmap(struct hyp_allocator *allocator, struct chunk_hdr *chunk,
+				void *addr, void *end)
+{
+	void *unmap = addr;
+
+	/*
+	 * hyp_allocator_chunk_reclaimable() already computes valid addr/end, no
+	 * need to check them again
+	 */
+	WARN_ON(end <= addr);
+
+	while (unmap < end) {
+		phys_addr_t pa = __pkvm_private_range_pa((void *)unmap);
+		void *page = hyp_phys_to_virt(pa);
+
+		push_hyp_memcache(&allocator->mc, page, hyp_virt_to_phys);
+		unmap += PAGE_SIZE;
+	}
+
+	pkvm_remove_mappings((void *)addr, (void *)(end));
+
+	if (chunk) {
+		chunk_set_unmapped(chunk, addr);
+		chunk_set_hash(chunk);
+	} else {
+		allocator->first_unmapped = addr;
+	}
+}
+
+static bool hyp_allocator_can_create_chunk(struct hyp_allocator *allocator,
+					   const struct chunk_hdr *prev,
+					   const struct chunk_hdr *next,
+					   void *addr, void *end)
+{
+	void *page, *unmapped;
+
+	if (addr < allocator->start || end > allocator->end)
+		return false;
+
+	/* First chunk created must be installed at allocator->start */
+	if (!prev)
+		return addr == allocator->start;
+
+	/* Must not overwrite the next chunk */
+	if (next && end > (void *)next)
+		return false;
+
+	/* Must not overwrite the previous chunk */
+	if (addr < (chunk_data(prev) + chunk_used_size(prev, allocator)))
+		return false;
+
+	/* Header must not cross page boundaries */
+	page = PTR_ALIGN(addr, PAGE_SIZE);
+	if (page != addr && (page - addr) < chunk_hdr_size())
+		return false;
+
+	/* Must leave a minimum distance from a page-start to maximise reclaim */
+	page = PTR_ALIGN_DOWN(addr, PAGE_SIZE);
+	if (page != addr && (addr - page) < chunk_min_size())
+		return false;
+
+	unmapped = chunk_unmapped(prev);
+	if (!unmapped)
+		return true;
+
+	/* Must never create an orphan mapped region */
+	if (addr > unmapped)
+		return false;
+
+	return true;
+}
+
+/*
+ * Tries to create a new chunk in the allocator whose header starts at @addr and
+ * whose data finishes at @end.
+ */
+static struct chunk_hdr *hyp_allocator_create_chunk(struct hyp_allocator *allocator,
+						    struct chunk_hdr *prev, void *addr,
+						    void *end, bool used)
+{
+	struct chunk_hdr *next, *chunk = addr;
+	void *unmapped;
+	int ret;
+
+	if (end > allocator->end)
+		return ERR_PTR(-E2BIG);
+
+	next = prev ? chunk_get_next(prev) : NULL;
+	if (!hyp_allocator_can_create_chunk(allocator, prev, next, addr, end))
+		return ERR_PTR(-EINVAL);
+
+	ret = hyp_allocator_map(allocator, prev, next, addr, end);
+	if (ret)
+		return ERR_PTR(ret);
+
+	memset(chunk, 0, sizeof(*chunk));
+	if (used)
+		chunk_set_used(chunk);
+	else
+		chunk_set_unused(chunk);
+
+	/* First chunk, first allocation */
+	if (!prev) {
+		chunk_set_unmapped(chunk, allocator->first_unmapped);
+		chunk_list_insert(chunk, NULL);
+		chunk_set_hash(chunk);
+
+		allocator->last_used = end;
+		allocator->head = allocator->tail = chunk;
+		return chunk;
+	}
+
+	/* Last chunk in the list */
+	if (!next) {
+		allocator->last_used = end;
+		allocator->tail = chunk;
+	}
+
+	/* Inherit prev's unmapped region */
+	unmapped = chunk_unmapped(prev);
+	chunk_set_unmapped(chunk, unmapped);
+	chunk_list_insert(chunk, prev);
+	chunk_set_hash(chunk);
+
+	chunk_set_unmapped(prev, 0);
+	chunk_set_hash(prev);
+
+	return chunk;
+}
+
+static bool hyp_allocator_can_destroy_chunk(struct hyp_allocator *allocator,
+					    const struct chunk_hdr *prev,
+					    const struct chunk_hdr *next,
+					    const struct chunk_hdr *chunk)
+{
+	if (chunk_is_used(chunk))
+		return false;
+
+	/* Last chunk in the allocator */
+	if (!prev)
+		return true;
+
+	/* Can't merge down unless we are the last one in the list */
+	if (next && chunk_is_used(prev))
+		return false;
+
+	/* Must never create an orphan mapped region */
+	if (chunk_unmapped(prev))
+		return false;
+
+	return true;
+}
+
+static int hyp_allocator_destroy_chunk(struct hyp_allocator *allocator,
+				       struct chunk_hdr *prev,
+				       struct chunk_hdr *chunk)
+{
+	struct chunk_hdr *next;
+
+	next = prev ? chunk_get_next(chunk) : NULL;
+	if (!hyp_allocator_can_destroy_chunk(allocator, prev, next, chunk))
+		return -EINVAL;
+
+	/* Last chunk in the allocator */
+	if (!prev) {
+		allocator->first_unmapped = chunk_unmapped(chunk);
+		allocator->head = allocator->tail = NULL;
+		return 0;
+	}
+
+	/* Last chunk in the list */
+	if (!next) {
+		allocator->last_used = chunk;
+		allocator->tail = prev;
+	}
+
+	chunk_set_unmapped(prev, chunk_unmapped(chunk));
+	chunk_set_hash(prev);
+	chunk_list_del(chunk);
+
+	return 0;
+}
+
+/*
+ * Return the best unused chunk for recycling, that is the smallest chunk
+ * fitting the allocation which needs to use the least unmapped region.
+ */
+static struct chunk_hdr *hyp_allocator_find_efficient_chunk(struct hyp_allocator *allocator,
+							    size_t size)
+{
+	struct chunk_hdr *chunk, *best_chunk = NULL;
+	size_t best_data_size = SIZE_MAX;
+	size_t best_missing = SIZE_MAX;
+
+	chunk = allocator->head;
+	while (chunk) {
+		size_t missing, mapped, data_size;
+
+		if (chunk_is_used(chunk))
+			goto next;
+
+		data_size = chunk_data_size(chunk, allocator);
+		if (data_size < size)
+			goto next;
+
+		mapped = chunk_mapped_data_size(chunk, allocator);
+		missing = (size > mapped) ? DIV_ROUND_UP(size - mapped, PAGE_SIZE) : 0;
+		if (missing > best_missing)
+			goto next;
+
+		if (data_size >= best_data_size)
+			goto next;
+
+		best_missing = missing;
+		best_data_size = data_size;
+		best_chunk = chunk;
+
+next:
+		chunk = chunk_get_next(chunk);
+	}
+
+	return best_chunk;
+}
+
+static struct chunk_hdr *hyp_allocator_reuse_chunk(struct hyp_allocator *allocator,
+						   struct chunk_hdr *chunk, size_t size)
+{
+	struct chunk_hdr *next = chunk_get_next(chunk);
+	void *start, *end, *split, *split_end;
+	int ret;
+
+	start = chunk_data(chunk);
+	end = start + size;
+
+	/* Last chunk in the list, no need to split */
+	if (!next) {
+		split = split_end = NULL;
+		allocator->last_used = chunk_data(chunk) + size;
+	} else {
+		split = chunk_start(end);
+		split_end = split + chunk_min_size();
+
+		if (!hyp_allocator_can_create_chunk(allocator, chunk, next, split, split_end))
+			split = split_end = NULL;
+	}
+
+	/* Batch the mapping of the reused chunk and the split */
+	ret = hyp_allocator_map(allocator, chunk, next, chunk_data(chunk), split ? split_end : end);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (split)
+		WARN_ON(IS_ERR_OR_NULL(
+			hyp_allocator_create_chunk(allocator, chunk, split, split_end, false)));
+
+	chunk_set_used(chunk);
+	chunk_set_hash(chunk);
+
+	return chunk;
+}
+
+static void *hyp_allocator_alloc(struct hyp_allocator *allocator, size_t size)
+{
+	struct chunk_hdr *chunk = ERR_PTR(-E2BIG);
+	void *start, *end;
+
+	size = max(size, MIN_ALLOC_SIZE);
+
+	/* Ensure we do not overflow ALIGN(MIN_ALLOC_SIZE) */
+	if (size > U32_MAX)
+		goto errno;
+
+	size = ALIGN(size, MIN_ALLOC_SIZE);
+	if (size > (allocator->end - allocator->start - chunk_hdr_size()))
+		goto errno;
+
+#ifdef CONFIG_NVHE_EL2_DEBUG
+	/* The allocator can modify the hyp stage-1 */
+	if (WARN_ON(hyp_spin_is_locked(&pkvm_pgd_lock))) {
+		chunk = ERR_PTR(-EINVAL);
+		goto errno;
+	}
+#endif
+	hyp_spin_lock(&allocator->lock);
+
+	/* First allocation */
+	if (!allocator->head) {
+		start = allocator->start;
+		end = start + chunk_hdr_size() + size;
+		chunk = hyp_allocator_create_chunk(allocator, NULL, start, end, true);
+		goto unlock;
+	}
+
+	chunk = hyp_allocator_find_efficient_chunk(allocator, size);
+
+	/* Nothing found, create a new chunk at the end in the list */
+	if (!chunk) {
+		start = chunk_start(chunk_data(allocator->tail) +
+				    chunk_used_size(allocator->tail, allocator));
+		end = start + chunk_hdr_size() + size;
+		chunk = hyp_allocator_create_chunk(allocator, allocator->tail, start, end, true);
+		goto unlock;
+	}
+
+	chunk = hyp_allocator_reuse_chunk(allocator, chunk, size);
+
+unlock:
+	hyp_spin_unlock(&allocator->lock);
+
+errno:
+	if (IS_ERR_OR_NULL(chunk)) {
+		int errno = IS_ERR(chunk) ? PTR_ERR(chunk) : -EINVAL;
+
+		*this_cpu_ptr(allocator->errno) = errno;
+		return NULL;
+	}
+
+	memset(chunk_data(chunk), 0, size);
+	return chunk_data(chunk);
+}
+
+static void hyp_allocator_free(struct hyp_allocator *allocator, void *data)
+{
+	struct chunk_hdr *chunk, *next, *prev;
+
+	if (!data)
+		return;
+
+	WARN_ON(!IS_ALIGNED((unsigned long)data, MIN_ALLOC_SIZE));
+	WARN_ON(data >= allocator->end || data < allocator->start + chunk_hdr_size());
+
+	hyp_spin_lock(&allocator->lock);
+
+	chunk = chunk_get(container_of(data, struct chunk_hdr, data));
+	WARN_ON(!chunk_is_used(chunk));
+	chunk_set_unused(chunk);
+	chunk_set_hash(chunk);
+
+	next = chunk_get_next(chunk);
+	if (next)
+		hyp_allocator_destroy_chunk(allocator, chunk, next);
+
+	prev = chunk_get_prev(chunk);
+	if (prev)
+		hyp_allocator_destroy_chunk(allocator, prev, chunk);
+
+	hyp_spin_unlock(&allocator->lock);
+}
+
+static unsigned long hyp_allocator_chunk_reclaimable(struct hyp_allocator *allocator,
+						     const struct chunk_hdr *chunk,
+						     u64 *__addr, u64 *__end)
+{
+	struct chunk_hdr *next;
+	void *addr, *end;
+
+	/* Last chunk in the allocator */
+	if (chunk == allocator->head && chunk == allocator->tail && !chunk_is_used(chunk)) {
+		addr = (void *)chunk;
+		end = chunk_unmapped(chunk);
+		if (!end)
+			end = allocator->end;
+		goto end;
+	}
+
+	next = chunk_get_next(chunk);
+
+	/* Last chunk in the list we can reclaim, even if used */
+	if (!next) {
+		addr = chunk_data(chunk) + chunk_used_size(chunk, allocator);
+		addr = PTR_ALIGN(addr, PAGE_SIZE);
+		end = chunk_unmapped(chunk);
+		if (!end)
+			end = allocator->end;
+		goto end;
+	}
+
+	if (chunk_is_used(chunk))
+		return 0;
+
+	addr = PTR_ALIGN(chunk_data(chunk), PAGE_SIZE);
+	end = chunk_unmapped(chunk);
+	if (!end)
+		end = PTR_ALIGN_DOWN(next, PAGE_SIZE);
+
+end:
+	if (addr >= end)
+		return 0;
+
+	if (__end)
+		*__end = (u64)end;
+	if (__addr)
+		*__addr = (u64)addr;
+
+	return (end - addr) >> PAGE_SHIFT;
+}
+
+static void hyp_allocator_reclaim_chunk(struct hyp_allocator *allocator, struct chunk_hdr *chunk,
+					void *addr, void *end)
+{
+	struct chunk_hdr *next;
+
+	WARN_ON(end <= addr);
+
+	/* We are about to destroy the last chunk in the allocator */
+	if (addr == allocator->start) {
+		allocator->tail = allocator->head = chunk = NULL;
+		goto unmap;
+	}
+
+	next = chunk_get_next(chunk);
+
+	/*
+	 * Split the reclaimed chunk at the next page boundary,
+	 * this ensures no orphan mapped region is created. Splitting at the page boundary is always
+	 * possible because chunks always leave a minimum distance to the page start.
+	 *
+	 *  +--------------+
+	 *  |______________|
+	 *  |______________|<- Next chunk
+	 *  |_ _ _ __ _ _ _|
+	 *  |              |<- Page-aligned split
+	 *  +--------------+
+	 *  +--------------+
+	 *  |              |
+	 *  |              |<- Page reclaimed
+	 *  |              |
+	 *  |              |
+	 *  +--------------+
+	 *  +--------------+
+	 *  |              |
+	 *  |______________|
+	 *  |______________|<- Chunk to split
+	 *  |              |
+	 *  +--------------+
+	 */
+	if (next && !chunk_unmapped(chunk) && next != end)
+		WARN_ON(IS_ERR_OR_NULL(hyp_allocator_create_chunk(allocator, chunk, end, next,
+								  false)));
+unmap:
+	hyp_allocator_unmap(allocator, chunk, addr, end);
+}
+
+/*
+ * Return the best reclaimable chunk which is the highest chunk in the list
+ * with the biggest reclaimable region.
+ */
+static struct chunk_hdr *hyp_allocator_find_reclaimable_chunk(struct hyp_allocator *allocator,
+							      u64 *addr, u64 *end)
+{
+	struct chunk_hdr *chunk, *best_chunk = NULL;
+	unsigned long best_reclaimable = 0;
+
+	chunk = allocator->head;
+	while (chunk) {
+		u64 __addr, __end;
+		unsigned long reclaimable = hyp_allocator_chunk_reclaimable(allocator, chunk,
+									    &__addr, &__end);
+
+		/* Favour the top biggest chunks */
+		if (reclaimable && reclaimable >= best_reclaimable) {
+			best_reclaimable = reclaimable;
+			best_chunk = chunk;
+			*addr = __addr;
+			*end = __end;
+		}
+
+		chunk = chunk_get_next(chunk);
+	}
+
+	return best_chunk;
+}
+
+static unsigned long hyp_allocator_drain_memcache(struct hyp_allocator *allocator,
+						  struct kvm_hyp_memcache *host_mc,
+						  unsigned long target)
+{
+	struct kvm_hyp_memcache *mc = &allocator->mc;
+	unsigned long drained = 0;
+
+	while (target && mc->nr_pages) {
+		void *page = pop_hyp_memcache(mc, hyp_phys_to_virt);
+
+		memset(page, 0, PAGE_SIZE);
+		kvm_flush_dcache_to_poc(page, PAGE_SIZE);
+		push_hyp_memcache(host_mc, page, hyp_virt_to_phys);
+		WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(page), 1));
+
+		target--;
+		drained++;
+	}
+
+	return drained;
+}
+
+static void hyp_allocator_reclaim(struct hyp_allocator *allocator, struct kvm_hyp_memcache *host_mc,
+				  unsigned long target)
+{
+	if (!target)
+		return;
+
+	hyp_spin_lock(&allocator->lock);
+
+	target -= hyp_allocator_drain_memcache(allocator, host_mc, target);
+	if (!target)
+		goto unlock;
+
+	do {
+		unsigned long reclaimable;
+		struct chunk_hdr *chunk;
+		u64 addr, end;
+
+		chunk = hyp_allocator_find_reclaimable_chunk(allocator, &addr, &end);
+		if (!chunk)
+			break;
+
+		reclaimable = min((end - addr) >> PAGE_SHIFT, target);
+		addr = end - (reclaimable << PAGE_SHIFT);
+		hyp_allocator_reclaim_chunk(allocator, chunk, (void *)addr, (void *)end);
+
+		target -= reclaimable;
+	} while (target);
+
+	hyp_allocator_drain_memcache(allocator, host_mc, ULONG_MAX);
+
+unlock:
+	hyp_spin_unlock(&allocator->lock);
+}
+
+static unsigned long hyp_allocator_reclaimable(struct hyp_allocator *allocator)
+{
+	unsigned long reclaimable = 0;
+	struct chunk_hdr *chunk;
+
+	hyp_spin_lock(&allocator->lock);
+
+	chunk = allocator->head;
+	while (chunk) {
+		reclaimable += hyp_allocator_chunk_reclaimable(allocator, chunk, NULL, NULL);
+		chunk = chunk_get_next(chunk);
+	}
+
+	hyp_spin_unlock(&allocator->lock);
+
+	return reclaimable;
+}
+
+static int hyp_allocator_topup(struct hyp_allocator *allocator,
+			       struct kvm_hyp_memcache *host_mc)
+{
+	struct kvm_hyp_memcache *alloc_mc = &allocator->mc;
+	int ret;
+
+	hyp_spin_lock(&allocator->lock);
+	ret = refill_memcache(alloc_mc, host_mc->nr_pages + alloc_mc->nr_pages, host_mc);
+	hyp_spin_unlock(&allocator->lock);
+
+	return ret;
+}
+
+static u32 hyp_allocator_topup_needed(struct hyp_allocator *allocator)
+{
+	u32 *topup_needed = this_cpu_ptr(allocator->topup_needed);
+	u32 ret = *topup_needed;
+
+	*topup_needed = 0;
+
+	return ret;
+}
+
+static int hyp_allocator_errno(struct hyp_allocator *allocator)
+{
+	int *errno = this_cpu_ptr(allocator->errno);
+	int ret = *errno;
+
+	*errno = 0;
+
+	return ret;
+}
+
+
+static int hyp_allocator_init(struct hyp_allocator *allocator, size_t size)
+{
+	unsigned long start;
+	int ret;
+
+	size = PAGE_ALIGN(size);
+
+	/* constrained by chunk_hdr u32 types */
+	if (size > U32_MAX || !size)
+		return -EINVAL;
+
+	ret = pkvm_alloc_private_va_range(size, &start);
+	if (ret)
+		return ret;
+
+	allocator->first_unmapped = allocator->start = (void *)start;
+	allocator->end = allocator->start + size;
+	hyp_spin_lock_init(&allocator->lock);
+
+	return 0;
+}
+
+static DEFINE_PER_CPU(int, __hyp_allocator_errno);
+static DEFINE_PER_CPU(u32, __hyp_allocator_topup_needed);
+
+static struct hyp_allocator hyp_allocator = {
+	.errno = &__hyp_allocator_errno,
+	.topup_needed = &__hyp_allocator_topup_needed,
+};
+
+/**
+ * hyp_alloc() - Allocate memory from the heap allocator
+ *
+ * @size:	Allocation size in bytes.
+ *
+ * Return: A pointer to the allocated memory on success, else NULL.
+ */
+void *hyp_alloc(size_t size)
+{
+	return hyp_allocator_alloc(&hyp_allocator, size);
+}
+
+/**
+ * hyp_free() - Free memory allocated with hyp_alloc()
+ *
+ * @data:	Address returned by the original hyp_alloc().
+ *
+ * The use of any other address than one returned by hyp_alloc() will cause a
+ * hypervisor panic.
+ */
+void hyp_free(void *data)
+{
+	hyp_allocator_free(&hyp_allocator, data);
+}
+
+/**
+ * hyp_alloc_errno() - Read the errno on allocation error
+ *
+ * Get the return code from an allocation failure.
+ *
+ * Return: -ENOMEM if the allocator needs a refill from the host, -E2BIG if
+ * there is no VA space left else 0.
+ */
+int hyp_alloc_errno(void)
+{
+	return hyp_allocator_errno(&hyp_allocator);
+}
+
+int hyp_alloc_init(size_t size)
+{
+	return hyp_allocator_init(&hyp_allocator, size);
+}
+
+void hyp_alloc_reclaim(struct kvm_hyp_memcache *mc, unsigned long target)
+{
+	hyp_allocator_reclaim(&hyp_allocator, mc, target);
+}
+
+unsigned long hyp_alloc_reclaimable(void)
+{
+	return hyp_allocator_reclaimable(&hyp_allocator);
+}
+
+int hyp_alloc_topup(struct kvm_hyp_memcache *host_mc)
+{
+	return hyp_allocator_topup(&hyp_allocator, host_mc);
+}
+
+u32 hyp_alloc_topup_needed(void)
+{
+	return hyp_allocator_topup_needed(&hyp_allocator);
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index d461981616d9..95ce7496e67f 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -10,6 +10,7 @@
 #include <asm/kvm_pgtable.h>
 #include <asm/kvm_pkvm.h>
 
+#include <nvhe/alloc.h>
 #include <nvhe/early_alloc.h>
 #include <nvhe/ffa.h>
 #include <nvhe/gfp.h>
@@ -363,6 +364,10 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long *per_cpu_bas
 	if (ret)
 		return ret;
 
+	ret = hyp_alloc_init(SZ_128M);
+	if (ret)
+		return ret;
+
 	update_nvhe_init_params();
 
 	/* Jump in the idmap page to switch to the new page-tables */
-- 
2.54.0.631.ge1b05301d1-goog

