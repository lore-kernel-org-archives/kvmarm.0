Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D6751AFF8
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864951; cv=none; b=eWktHsKB6GQw54oGoKmvB1VK4ITXvbJTQLVAoHlpErFd9ExE4efFJ2/dwYgGhWUF5gfKX/SajhshYb7b56suxY8m7Ep0F5Xs1edfKUJHYIU8H3i4xigTFk8hx1tXhxbQ1uCv4KudtQzNkUtXQP4wfSL+smu7UKdcYya/6UxJeJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864951; c=relaxed/simple;
	bh=HkN6HeRqG4QqvLSQ352TqxvFY3uYEwMhem6LOw4LtYg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eq4tZ4USA1+pOJR0hQwogMA9xeUMcPrh9JUof14bGjxXaUWnDbvYdM6+pFC2dGEgxziErWp9kJR4E1KIPld1HsL9VwX6AzWM4xHC/27sHZKl5+WWj/0KYADAp8pox2OrWFvxkPIRDFw+uHBvMlkDDRiVuJPyN8de7DvOfnjvdak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lSDSNhAV; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lSDSNhAV"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-495689bfcc8so56667935e9.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790864940; x=1791469740; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jn0PGmRZ95YzYWjXtHNof1FVIqlljCjfwxKO/9v9jY0=;
        b=lSDSNhAV9noRI04xleD08KsKBqhMlaRbdXiRYmpwUZssjrVqNi3VhrDHfNsse9Lg1M
         olbFeXGkoJh4g6E88VoB3IkYJyZSPcU99UIZBa4DuXB8v/DC5pBJvc0UiEcF3ehWDikX
         YqrY+W2e/rYh1e0B3d/xbn8toMKo9S2OwuLWnXU4rQ8YS9BdYvOpDYsiNKb90WWpcJIK
         1nDvBw6JTZtMlRgnnc7y1MJnO3ATfSWVjMN72nUHGyiRlGwTK5u0MU86KPG7HC5cotiL
         W1Aj8GkFJIPuy2+1PvsNIt0gKYYkPnedRkYkO9PXE95Pz+oFFgOkknXk3coaHak6/K8m
         zjPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864940; x=1791469740;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jn0PGmRZ95YzYWjXtHNof1FVIqlljCjfwxKO/9v9jY0=;
        b=cGIPWOl4muDi9nT+eD2cUXnK+tDiPjB1MgCMkjtT4PMzQqWjSc7nVFgpq+xDuGvc2W
         a1IRKkyaXnFg816ZgoEjL8wKIwLaecQyvDubuqXm4dQ4+azWkBdGNOVWqJZ6c9JQ6iSh
         aPmmNVhulZzUGq2x2I+nkkJY7W3RmvjTqoA9522YaBp6jE82VLRyEZ2y3fm+Ih0hBE76
         0p9vxC9i/oWgZxO9UnvL6TunnIt587X1fDM9SGV+ov1i1SZlFAiTAaQQrxGWEw/Vk4Vc
         20I7I7n7RQkZwNuIu/3Udv/U1OPjoE6vJTGp34tsWq6sc8GFHlXUica98VU/b+vJNC7v
         erLA==
X-Forwarded-Encrypted: i=1; AKwUvBx3OTH5q+tcVgl9cCmz8Zan2ci6Rm56ywh4+4sWE8uTB0fldU6mmOrUW+5AgiIldahhuF+S5Y4=@lists.linux.dev
X-Gm-Message-State: AFuF++l/GIq7LzT+Tmqj2yVzeSp7SgevNvnJKT/dOFhXjE5IPaqUr8D1
	eVYUmEpTnomkFFXON1zhxI7fUwCTqLVBj4UQ97SiRIzVid39aV5JbMLDnk7p0AvH6wK2VrULT1O
	pBDFMq5kksIEbzFju5Q/+9Q==
X-Received: from wmna8.prod.google.com ([2002:a05:600c:688:b0:4a0:2207:2163])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:8642:10b0:4a0:1b15:8852 with SMTP id 5b1f17b1804b1-4a01b1588bfmr61447445e9.16.1790864939778;
 Thu, 01 Oct 2026 07:28:59 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:28:35 +0100
In-Reply-To: <20261001142849.3367614-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001142849.3367614-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001142849.3367614-5-vdonnefort@google.com>
Subject: [PATCH v6 04/18] KVM: arm64: Add a heap allocator for the pKVM hyp
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
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

Additionally, harden the allocator with a fast hash of the chunks
meta-data. This intends to detect accidental corruptions and makes the
allocator slightly more robust to potential attacks.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/include/nvhe/alloc.h |   17 +
 arch/arm64/kvm/hyp/nvhe/Makefile        |    2 +-
 arch/arm64/kvm/hyp/nvhe/alloc.c         | 1027 +++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c         |    6 +
 4 files changed, 1051 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/alloc.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/alloc.c

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
index ccc1fe839409..ee0abb2e6af5 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -23,7 +23,7 @@ lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 CFLAGS_switch.nvhe.o += -Wno-override-init
 
 hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
-	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
+	 hyp-main.o hyp-smp.o psci-relay.o alloc.o early_alloc.o page_alloc.o \
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o
diff --git a/arch/arm64/kvm/hyp/nvhe/alloc.c b/arch/arm64/kvm/hyp/nvhe/alloc.c
new file mode 100644
index 000000000000..e0104d2dd6c0
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/alloc.c
@@ -0,0 +1,1027 @@
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
+/*
+ * A minimum of 16 bytes allows us to comply with the alignment requirement for
+ * FPSIMD registers that are part of struct pkvm_hyp_vcpu.
+ *
+ * It also must be a power of two.
+ */
+#define MIN_ALLOC_SIZE 16UL
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
+static void hyp_allocator_set_errno(struct hyp_allocator *allocator, int errno)
+{
+	*this_cpu_ptr(allocator->errno) = errno;
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
+static int hyp_allocator_map(struct hyp_allocator *allocator, struct chunk_hdr *chunk,
+			     struct chunk_hdr *next,
+			     void *addr, void *end)
+{
+	void *unmapped = chunk ? chunk_unmapped(chunk) : allocator->first_unmapped;
+	void *unmapped_end = next ?: allocator->end;
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
+		ret = pkvm_map_private_va_range(unmapped, hyp_virt_to_phys(page), PAGE_SIZE);
+		if (ret) {
+			push_hyp_memcache(&allocator->mc, page, hyp_virt_to_phys);
+			return ret;
+		}
+
+		unmapped += PAGE_SIZE;
+
+		/*
+		 * Reset the unmap field if we've reached the next chunk or the
+		 * allocator boundary. Chunks are always installed to cover a
+		 * mapped region followed by an unmapped one. Therefore, we
+		 * expect next to be PAGE_ALIGNED.
+		 */
+		WARN_ON(!PAGE_ALIGNED(unmapped_end));
+		if (unmapped == unmapped_end)
+			unmapped = NULL;
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
+		phys_addr_t pa = pkvm_private_va_range_pa((void *)unmap);
+		void *page = hyp_phys_to_virt(pa);
+
+		push_hyp_memcache(&allocator->mc, page, hyp_virt_to_phys);
+		unmap += PAGE_SIZE;
+	}
+
+	pkvm_remove_mappings(addr, end);
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
+	chunk_set_unmapped(prev, NULL);
+	chunk_set_hash(prev);
+
+	return chunk;
+}
+
+static bool hyp_allocator_can_destroy_chunk(const struct chunk_hdr *prev,
+					    const struct chunk_hdr *next,
+					    const struct chunk_hdr *chunk)
+{
+	if (chunk_is_used(chunk))
+		return false;
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
+	struct chunk_hdr *next = chunk_get_next(chunk);
+
+	if (!hyp_allocator_can_destroy_chunk(prev, next, chunk))
+		return -EINVAL;
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
+		if (missing == best_missing && data_size >= best_data_size)
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
+static struct chunk_hdr *hyp_allocator_alloc_chunk(struct hyp_allocator *allocator, size_t size)
+{
+	struct chunk_hdr *chunk;
+	void *start, *end;
+
+	/* First allocation */
+	if (!allocator->head) {
+		start = allocator->start;
+		end = start + chunk_hdr_size() + size;
+		return hyp_allocator_create_chunk(allocator, NULL, start, end, true);
+	}
+
+	chunk = hyp_allocator_find_efficient_chunk(allocator, size);
+
+	/* Nothing found, create a new chunk at the end in the list */
+	if (!chunk) {
+		start = chunk_start(chunk_data(allocator->tail) +
+				    chunk_used_size(allocator->tail, allocator));
+		end = start + chunk_hdr_size() + size;
+		return hyp_allocator_create_chunk(allocator, allocator->tail, start, end, true);
+	}
+
+	return hyp_allocator_reuse_chunk(allocator, chunk, size);
+}
+
+static void *hyp_allocator_alloc(struct hyp_allocator *allocator, size_t size)
+{
+	struct chunk_hdr *chunk;
+
+	size = max(size, MIN_ALLOC_SIZE);
+
+	/* Ensure we do not overflow ALIGN(MIN_ALLOC_SIZE) */
+	if (size > U32_MAX) {
+		hyp_allocator_set_errno(allocator, -E2BIG);
+		return NULL;
+	}
+
+	size = ALIGN(size, MIN_ALLOC_SIZE);
+	if (size > (allocator->end - allocator->start - chunk_hdr_size())) {
+		hyp_allocator_set_errno(allocator, -E2BIG);
+		return NULL;
+	}
+
+	scoped_guard(hyp_spinlock, &allocator->lock) {
+		chunk = hyp_allocator_alloc_chunk(allocator, size);
+		if (IS_ERR_OR_NULL(chunk)) {
+			hyp_allocator_set_errno(allocator,
+						IS_ERR(chunk) ? PTR_ERR(chunk) : -EINVAL);
+			return NULL;
+		}
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
+	guard(hyp_spinlock)(&allocator->lock);
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
+static void hyp_allocator_drain_memcache(struct hyp_allocator *allocator,
+					 struct kvm_hyp_memcache *host_mc,
+					 unsigned long target)
+{
+	struct kvm_hyp_memcache *mc = &allocator->mc;
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
+	}
+}
+
+static void hyp_allocator_reclaim(struct hyp_allocator *allocator, struct kvm_hyp_memcache *host_mc,
+				  unsigned long target)
+{
+	unsigned long reclaimed = 0;
+
+	if (!target)
+		return;
+
+	guard(hyp_spinlock)(&allocator->lock);
+
+	do {
+		struct chunk_hdr *chunk;
+		unsigned long r;
+		u64 addr, end;
+
+		chunk = hyp_allocator_find_reclaimable_chunk(allocator, &addr, &end);
+		if (!chunk)
+			break;
+
+		r = min((end - addr) >> PAGE_SHIFT, target - reclaimed);
+		addr = end - (r << PAGE_SHIFT);
+		hyp_allocator_reclaim_chunk(allocator, chunk, (void *)addr, (void *)end);
+
+		reclaimed += r;
+	} while (reclaimed < target);
+
+	hyp_allocator_drain_memcache(allocator, host_mc, target);
+}
+
+static unsigned long hyp_allocator_reclaimable(struct hyp_allocator *allocator)
+{
+	unsigned long reclaimable;
+	struct chunk_hdr *chunk;
+
+	guard(hyp_spinlock)(&allocator->lock);
+
+	/*
+	 * While allocator->mc typically contains transient pages,
+	 * over-allocation or an aborted operation could leave pages behind.
+	 * Account for allocator->mc so stalled topup pages can be reclaimed.
+	 */
+	reclaimable = allocator->mc.nr_pages;
+
+	chunk = allocator->head;
+	while (chunk) {
+		reclaimable += hyp_allocator_chunk_reclaimable(allocator, chunk, NULL, NULL);
+		chunk = chunk_get_next(chunk);
+	}
+
+	return reclaimable;
+}
+
+static int hyp_allocator_topup(struct hyp_allocator *allocator,
+			       struct kvm_hyp_memcache *host_mc)
+{
+	struct kvm_hyp_memcache *alloc_mc = &allocator->mc;
+
+	guard(hyp_spinlock)(&allocator->lock);
+	return refill_memcache(alloc_mc, host_mc->nr_pages + alloc_mc->nr_pages, host_mc);
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
+ * Callers must ensure they do not hold pkvm_pgd_lock to avoid deadlocks,
+ * as the allocator may modify the hyp stage-1 page-table.
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
index 75b00c323310..9fd3dcde3557 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -10,6 +10,7 @@
 #include <asm/kvm_pgtable.h>
 #include <asm/kvm_pkvm.h>
 
+#include <nvhe/alloc.h>
 #include <nvhe/early_alloc.h>
 #include <nvhe/ffa.h>
 #include <nvhe/gfp.h>
@@ -363,6 +364,11 @@ int __pkvm_init(phys_addr_t phys, unsigned long size, unsigned long *per_cpu_bas
 	if (ret)
 		return ret;
 
+	/* Arbitrary size, unmapped at boot and only consume VA-space */
+	ret = hyp_alloc_init(SZ_128M);
+	if (ret)
+		return ret;
+
 	update_nvhe_init_params();
 
 	/* Jump in the idmap page to switch to the new page-tables */
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

