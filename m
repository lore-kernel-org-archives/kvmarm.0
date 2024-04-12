Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA3B954677;
	Fri, 12 Apr 2024 10:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918104; cv=none; b=WYT1amHDlc9f7u8T1bfA5vQlloBIl9o1qiNvtaTeDLkNoxbX8h6h73gjjTJ8LiCt0iYm7yylWG0XdiheZg9FlEncLwSOG7qbDMpQ70CM5UEmIh+LCRmhgTX/UbZoImsH5U4KU/Re4cBJouRjSO3G0dwYNSTjUvJGUCmm5EhvikE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918104; c=relaxed/simple;
	bh=I7sjzoM/r8GL7yzwe7yecDHVw8xur7f0XhiwJ6YeBRU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n0Gbx02w/0ZWipg4BqxFn1e5FOAPYwYPikP5ow/ysSapXZ1vCnGZ1pi5xMhdlQyRTKiSvJmawVqqNetLjb1gyeudr3ukFGFDH9kcGm5FWw2ZSWiwqp2nBtC3pwIPC7uMVcR8C7ImlFITQlrJCzHCODOrgS53YKyfhq2iq8kUBwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DDD8113E;
	Fri, 12 Apr 2024 03:35:30 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 975EC3F64C;
	Fri, 12 Apr 2024 03:34:59 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 21/33] lib/alloc_page: Add shared page allocation support
Date: Fri, 12 Apr 2024 11:33:56 +0100
Message-Id: <20240412103408.2706058-22-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joey Gouly <joey.gouly@arm.com>

Add support for allocating "pages" that can be shared with the host.
Or in other words, decrypted pages. This is achieved by adding hooks for
setting a memory region as "encrypted" or "decrypted", which can be overridden
by the architecture specific backends.

Also add a new flag - FLAG_SHARED - for allocating shared pages.

The page allocation/free routines get a "_shared_" variant too.
These will be later used for Realm support and tests.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/alloc_page.c     | 20 +++++++++++++++++---
 lib/alloc_page.h     | 24 ++++++++++++++++++++++++
 lib/asm-generic/io.h | 12 ++++++++++++
 3 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/lib/alloc_page.c b/lib/alloc_page.c
index 84f01e11..e253cd1d 100644
--- a/lib/alloc_page.c
+++ b/lib/alloc_page.c
@@ -263,7 +263,7 @@ static bool coalesce(struct mem_area *a, u8 order, pfn_t pfn, pfn_t pfn2)
  * - no pages in the memory block were already free
  * - no pages in the memory block are special
  */
-static void _free_pages(void *mem)
+static void _free_pages(void *mem, u32 flags)
 {
 	pfn_t pfn2, pfn = virt_to_pfn(mem);
 	struct mem_area *a = NULL;
@@ -281,6 +281,9 @@ static void _free_pages(void *mem)
 	p = pfn - a->base;
 	order = a->page_states[p] & ORDER_MASK;
 
+	if (flags & FLAG_SHARED)
+		set_memory_encrypted((unsigned long)mem, BIT(order) * PAGE_SIZE);
+
 	/* ensure that the first page is allocated and not special */
 	assert(IS_ALLOCATED(a->page_states[p]));
 	/* ensure that the order has a sane value */
@@ -320,7 +323,14 @@ static void _free_pages(void *mem)
 void free_pages(void *mem)
 {
 	spin_lock(&lock);
-	_free_pages(mem);
+	_free_pages(mem, 0);
+	spin_unlock(&lock);
+}
+
+void free_pages_shared(void *mem)
+{
+	spin_lock(&lock);
+	_free_pages(mem, FLAG_SHARED);
 	spin_unlock(&lock);
 }
 
@@ -353,7 +363,7 @@ static void _unreserve_one_page(pfn_t pfn)
 	i = pfn - a->base;
 	assert(a->page_states[i] == STATUS_SPECIAL);
 	a->page_states[i] = STATUS_ALLOCATED;
-	_free_pages(pfn_to_virt(pfn));
+	_free_pages(pfn_to_virt(pfn), 0);
 }
 
 int reserve_pages(phys_addr_t addr, size_t n)
@@ -401,6 +411,10 @@ static void *page_memalign_order_flags(u8 al, u8 ord, u32 flags)
 		if (area & BIT(i))
 			res = page_memalign_order(areas + i, al, ord, fresh);
 	spin_unlock(&lock);
+
+	if (res && (flags & FLAG_SHARED))
+		set_memory_decrypted((unsigned long)res, BIT(ord) * PAGE_SIZE);
+
 	if (res && !(flags & FLAG_DONTZERO))
 		memset(res, 0, BIT(ord) * PAGE_SIZE);
 	return res;
diff --git a/lib/alloc_page.h b/lib/alloc_page.h
index 060e0418..8c1ea7b5 100644
--- a/lib/alloc_page.h
+++ b/lib/alloc_page.h
@@ -21,6 +21,7 @@
 
 #define FLAG_DONTZERO	0x10000
 #define FLAG_FRESH	0x20000
+#define FLAG_SHARED	0x40000
 
 /* Returns true if the page allocator has been initialized */
 bool page_alloc_initialized(void);
@@ -121,4 +122,27 @@ int reserve_pages(phys_addr_t addr, size_t npages);
  */
 void unreserve_pages(phys_addr_t addr, size_t npages);
 
+/* Shared page operations */
+static inline void *alloc_pages_shared(unsigned int order)
+{
+	return alloc_pages_flags(order, FLAG_SHARED);
+}
+
+static inline void *alloc_page_shared(void)
+{
+	return alloc_pages_shared(0);
+}
+
+void free_pages_shared(void *mem);
+
+static inline void free_page_shared(void *page)
+{
+	free_pages_shared(page);
+}
+
+static inline void free_pages_shared_by_order(void *mem, unsigned int order)
+{
+	free_pages_shared(mem);
+}
+
 #endif
diff --git a/lib/asm-generic/io.h b/lib/asm-generic/io.h
index dc0f46f5..fb65184b 100644
--- a/lib/asm-generic/io.h
+++ b/lib/asm-generic/io.h
@@ -214,4 +214,16 @@ static inline void *phys_to_virt(unsigned long address)
 }
 #endif
 
+#ifndef set_memory_encrypted
+static inline void set_memory_encrypted(unsigned long mem, size_t size)
+{
+}
+#endif
+
+#ifndef set_memory_decrypted
+static inline void set_memory_decrypted(unsigned long mem, size_t size)
+{
+}
+#endif
+
 #endif /* _ASM_GENERIC_IO_H_ */
-- 
2.34.1

