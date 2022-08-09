Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83582C25B06
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 09:15:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 324AA4C53E;
	Tue,  9 Aug 2022 05:15:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IEP5JcPbmqXX; Tue,  9 Aug 2022 05:15:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A7D54C99A;
	Tue,  9 Aug 2022 05:15:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06A224C491
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wZaVzQebGt+m for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:15:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA2924C47F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:31 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCA7E23A;
 Tue,  9 Aug 2022 02:15:31 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 083503F67D;
 Tue,  9 Aug 2022 02:15:29 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 03/19] lib/alloc_phys: Use
 phys_alloc_aligned_safe and rename it to memalign_early
Date: Tue,  9 Aug 2022 10:15:42 +0100
Message-Id: <20220809091558.14379-4-alexandru.elisei@arm.com>
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

phys_alloc_aligned_safe() is called only by early_memalign() and the safe
parameter is always true. In the spirit of simplifying the code, merge the
two functions together. Rename it to memalign_early(), to match the naming
scheme used by the page allocator.

Change the type of top_safe to phys_addr_t, to match the type of the top
and base variables describing the available physical memory; this is a
cosmetic change only, since libcflat.h defines phys_addr_t as an alias
for u64.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_phys.c | 38 ++++++++++++++------------------------
 1 file changed, 14 insertions(+), 24 deletions(-)

diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
index 3a78d0acd718..efb783b34002 100644
--- a/lib/alloc_phys.c
+++ b/lib/alloc_phys.c
@@ -27,9 +27,9 @@ static phys_addr_t base, top;
 #define DEFAULT_MINIMUM_ALIGNMENT	32
 static size_t align_min = DEFAULT_MINIMUM_ALIGNMENT;
 
-static void *early_memalign(size_t alignment, size_t size);
+static void *memalign_early(size_t alignment, size_t sz);
 static struct alloc_ops early_alloc_ops = {
-	.memalign = early_memalign,
+	.memalign = memalign_early,
 };
 struct alloc_ops *alloc_ops = &early_alloc_ops;
 
@@ -66,18 +66,21 @@ void phys_alloc_set_minimum_alignment(phys_addr_t align)
 	spin_unlock(&lock);
 }
 
-static phys_addr_t phys_alloc_aligned_safe(phys_addr_t size,
-					   phys_addr_t align, bool safe)
+static void *memalign_early(size_t alignment, size_t sz)
 {
 	static bool warned = false;
-	phys_addr_t addr, size_orig = size;
-	u64 top_safe;
+	phys_addr_t align = (phys_addr_t)alignment;
+	phys_addr_t size = (phys_addr_t)sz;
+	phys_addr_t size_orig = size;
+	phys_addr_t addr, top_safe;
+
+	assert(align && !(align & (align - 1)));
 
 	spin_lock(&lock);
 
 	top_safe = top;
 
-	if (safe && sizeof(long) == 4)
+	if (sizeof(long) == 4)
 		top_safe = MIN(top_safe, 1ULL << 32);
 
 	assert(base < top_safe);
@@ -92,10 +95,10 @@ static phys_addr_t phys_alloc_aligned_safe(phys_addr_t size,
 		       " (align=%#" PRIx64 "), "
 		       "need=%#" PRIx64 ", but free=%#" PRIx64 ". "
 		       "top=%#" PRIx64 ", top_safe=%#" PRIx64 "\n",
-		       (u64)size_orig, (u64)align, (u64)size, top_safe - base,
-		       (u64)top, top_safe);
+		       (u64)size_orig, (u64)align, (u64)size,
+		       (u64)(top_safe - base), (u64)top, (u64)top_safe);
 		spin_unlock(&lock);
-		return INVALID_PHYS_ADDR;
+		return NULL;
 	}
 
 	base += size;
@@ -112,7 +115,7 @@ static phys_addr_t phys_alloc_aligned_safe(phys_addr_t size,
 
 	spin_unlock(&lock);
 
-	return addr;
+	return phys_to_virt(addr);
 }
 
 void phys_alloc_get_unused(phys_addr_t *p_base, phys_addr_t *p_top)
@@ -128,16 +131,3 @@ void phys_alloc_get_unused(phys_addr_t *p_base, phys_addr_t *p_top)
 	base = top;
 	spin_unlock(&lock);
 }
-
-static void *early_memalign(size_t alignment, size_t size)
-{
-	phys_addr_t addr;
-
-	assert(alignment && !(alignment & (alignment - 1)));
-
-	addr = phys_alloc_aligned_safe(size, alignment, true);
-	if (addr == INVALID_PHYS_ADDR)
-		return NULL;
-
-	return phys_to_virt(addr);
-}
-- 
2.37.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
