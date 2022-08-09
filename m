Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3F2C25B07
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 09:15:46 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BB144C497;
	Tue,  9 Aug 2022 05:15:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nKDxtkhCgkAv; Tue,  9 Aug 2022 05:15:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E75DC4C4FF;
	Tue,  9 Aug 2022 05:15:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB9994C918
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id caTncDCcty8A for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:15:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E429B4C4A1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:35 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A8CF23A;
 Tue,  9 Aug 2022 02:15:36 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7886E3F67D;
 Tue,  9 Aug 2022 02:15:34 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 06/19] lib/alloc_phys: Remove allocation
 accounting
Date: Tue,  9 Aug 2022 10:15:45 +0100
Message-Id: <20220809091558.14379-7-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809091558.14379-1-alexandru.elisei@arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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

The page allocator has better allocation tracking and is used by all
architectures, while the physical allocator is now never used for
allocating memory.

Simplify the physical allocator by removing allocation accounting. This
accomplishes two things:

1. It makes the allocator more useful, as the warning that was displayed
each allocation after the 256th is removed.

2. Together with the lock removal, the physical allocator becomes more
appealing as a very early allocator, when using the page allocator might
not be desirable or feasible.

Also, phys_alloc_show() has received a slight change in the way it displays
the use and free regions: the end of the region is now non-inclusive, to
allow phys_alloc_show() to express that no memory has been used, or no
memory is free, in which case the start and the end adresses are equal.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_phys.c | 65 ++++++++++++++----------------------------------
 lib/alloc_phys.h |  5 ++--
 2 files changed, 21 insertions(+), 49 deletions(-)

diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
index 2e0b9c079d1d..1e1fc179f108 100644
--- a/lib/alloc_phys.c
+++ b/lib/alloc_phys.c
@@ -11,17 +11,11 @@
 #include "asm/io.h"
 #include "alloc_phys.h"
 
-#define PHYS_ALLOC_NR_REGIONS	256
-
-struct phys_alloc_region {
-	phys_addr_t base;
-	phys_addr_t size;
-};
-
-static struct phys_alloc_region regions[PHYS_ALLOC_NR_REGIONS];
-static int nr_regions;
-
-static phys_addr_t base, top;
+/*
+ * used is the end address of the currently allocated memory, non-inclusive.
+ * used equals top means that all memory has been allocated.
+ */
+static phys_addr_t base, used, top;
 
 #define DEFAULT_MINIMUM_ALIGNMENT	32
 static size_t align_min = DEFAULT_MINIMUM_ALIGNMENT;
@@ -34,23 +28,15 @@ struct alloc_ops *alloc_ops = &early_alloc_ops;
 
 void phys_alloc_show(void)
 {
-	int i;
-
 	printf("phys_alloc minimum alignment: %#" PRIx64 "\n", (u64)align_min);
-	for (i = 0; i < nr_regions; ++i)
-		printf("%016" PRIx64 "-%016" PRIx64 " [%s]\n",
-			(u64)regions[i].base,
-			(u64)(regions[i].base + regions[i].size - 1),
-			"USED");
-	printf("%016" PRIx64 "-%016" PRIx64 " [%s]\n",
-		(u64)base, (u64)(top - 1), "FREE");
+	printf("%016" PRIx64 "-%016" PRIx64 " [USED]\n", (u64)base, (u64)used);
+	printf("%016" PRIx64 "-%016" PRIx64 " [FREE]\n", (u64)used, (u64)top);
 }
 
 void phys_alloc_init(phys_addr_t base_addr, phys_addr_t size)
 {
-	base = base_addr;
+	used = base = base_addr;
 	top = base + size;
-	nr_regions = 0;
 }
 
 void phys_alloc_set_minimum_alignment(phys_addr_t align)
@@ -61,7 +47,6 @@ void phys_alloc_set_minimum_alignment(phys_addr_t align)
 
 static void *memalign_early(size_t alignment, size_t sz)
 {
-	static bool warned = false;
 	phys_addr_t align = (phys_addr_t)alignment;
 	phys_addr_t size = (phys_addr_t)sz;
 	phys_addr_t size_orig = size;
@@ -70,50 +55,36 @@ static void *memalign_early(size_t alignment, size_t sz)
 	assert(align && !(align & (align - 1)));
 
 	top_safe = top;
-
 	if (sizeof(long) == 4)
 		top_safe = MIN(top_safe, 1ULL << 32);
+	assert(used < top_safe);
 
-	assert(base < top_safe);
 	if (align < align_min)
 		align = align_min;
 
-	addr = ALIGN(base, align);
-	size += addr - base;
+	addr = ALIGN(used, align);
+	size += addr - used;
 
-	if ((top_safe - base) < size) {
+	if (size > top_safe - used) {
 		printf("phys_alloc: requested=%#" PRIx64
 		       " (align=%#" PRIx64 "), "
 		       "need=%#" PRIx64 ", but free=%#" PRIx64 ". "
 		       "top=%#" PRIx64 ", top_safe=%#" PRIx64 "\n",
 		       (u64)size_orig, (u64)align, (u64)size,
-		       (u64)(top_safe - base), (u64)top, (u64)top_safe);
+		       (u64)(top_safe - used), (u64)top, (u64)top_safe);
 		return NULL;
 	}
 
-	base += size;
-
-	if (nr_regions < PHYS_ALLOC_NR_REGIONS) {
-		regions[nr_regions].base = addr;
-		regions[nr_regions].size = size_orig;
-		++nr_regions;
-	} else if (!warned) {
-		printf("WARNING: phys_alloc: No free log entries, "
-		       "can no longer log allocations...\n");
-		warned = true;
-	}
+	used += size;
 
 	return phys_to_virt(addr);
 }
 
 void phys_alloc_get_unused(phys_addr_t *p_base, phys_addr_t *p_top)
 {
-	*p_base = base;
+	*p_base = used;
 	*p_top = top;
-	if (base == top)
-		return;
-	regions[nr_regions].base = base;
-	regions[nr_regions].size = top - base;
-	++nr_regions;
-	base = top;
+
+	/* Empty allocator. */
+	used = top;
 }
diff --git a/lib/alloc_phys.h b/lib/alloc_phys.h
index 8049c340818d..4d350f010031 100644
--- a/lib/alloc_phys.h
+++ b/lib/alloc_phys.h
@@ -29,8 +29,9 @@ extern void phys_alloc_set_minimum_alignment(phys_addr_t align);
 
 /*
  * phys_alloc_show outputs all currently allocated regions with the
- * following format
- *   <start_addr>-<end_addr> [<USED|FREE>]
+ * following format, where <end_addr> is non-inclusive:
+ *
+ * <start_addr>-<end_addr> [<USED|FREE>]
  */
 extern void phys_alloc_show(void);
 
-- 
2.37.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
