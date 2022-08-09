Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61E93C25B07
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 09:15:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B80E4C9BB;
	Tue,  9 Aug 2022 05:15:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N7REKJgQDqUJ; Tue,  9 Aug 2022 05:15:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CCE044CA08;
	Tue,  9 Aug 2022 05:15:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 464794C460
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DVHQ6RBoUuat for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:15:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 096A24C991
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:35 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE2571477;
 Tue,  9 Aug 2022 02:15:34 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 184A03F67D;
 Tue,  9 Aug 2022 02:15:32 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 05/19] lib/alloc_phys: Remove locking
Date: Tue,  9 Aug 2022 10:15:44 +0100
Message-Id: <20220809091558.14379-6-alexandru.elisei@arm.com>
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

With powerpc moving the page allocator, there are no architectures left
which use the physical allocator after the boot setup:  arm, arm64,
s390x and powerpc drain the physical allocator to initialize the page
allocator; and x86 calls setup_vm() to drain the allocator for each of
the tests that allocate memory.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/alloc_phys.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/lib/alloc_phys.c b/lib/alloc_phys.c
index efb783b34002..2e0b9c079d1d 100644
--- a/lib/alloc_phys.c
+++ b/lib/alloc_phys.c
@@ -21,7 +21,6 @@ struct phys_alloc_region {
 static struct phys_alloc_region regions[PHYS_ALLOC_NR_REGIONS];
 static int nr_regions;
 
-static struct spinlock lock;
 static phys_addr_t base, top;
 
 #define DEFAULT_MINIMUM_ALIGNMENT	32
@@ -37,7 +36,6 @@ void phys_alloc_show(void)
 {
 	int i;
 
-	spin_lock(&lock);
 	printf("phys_alloc minimum alignment: %#" PRIx64 "\n", (u64)align_min);
 	for (i = 0; i < nr_regions; ++i)
 		printf("%016" PRIx64 "-%016" PRIx64 " [%s]\n",
@@ -46,24 +44,19 @@ void phys_alloc_show(void)
 			"USED");
 	printf("%016" PRIx64 "-%016" PRIx64 " [%s]\n",
 		(u64)base, (u64)(top - 1), "FREE");
-	spin_unlock(&lock);
 }
 
 void phys_alloc_init(phys_addr_t base_addr, phys_addr_t size)
 {
-	spin_lock(&lock);
 	base = base_addr;
 	top = base + size;
 	nr_regions = 0;
-	spin_unlock(&lock);
 }
 
 void phys_alloc_set_minimum_alignment(phys_addr_t align)
 {
 	assert(align && !(align & (align - 1)));
-	spin_lock(&lock);
 	align_min = align;
-	spin_unlock(&lock);
 }
 
 static void *memalign_early(size_t alignment, size_t sz)
@@ -76,8 +69,6 @@ static void *memalign_early(size_t alignment, size_t sz)
 
 	assert(align && !(align & (align - 1)));
 
-	spin_lock(&lock);
-
 	top_safe = top;
 
 	if (sizeof(long) == 4)
@@ -97,7 +88,6 @@ static void *memalign_early(size_t alignment, size_t sz)
 		       "top=%#" PRIx64 ", top_safe=%#" PRIx64 "\n",
 		       (u64)size_orig, (u64)align, (u64)size,
 		       (u64)(top_safe - base), (u64)top, (u64)top_safe);
-		spin_unlock(&lock);
 		return NULL;
 	}
 
@@ -113,8 +103,6 @@ static void *memalign_early(size_t alignment, size_t sz)
 		warned = true;
 	}
 
-	spin_unlock(&lock);
-
 	return phys_to_virt(addr);
 }
 
@@ -124,10 +112,8 @@ void phys_alloc_get_unused(phys_addr_t *p_base, phys_addr_t *p_top)
 	*p_top = top;
 	if (base == top)
 		return;
-	spin_lock(&lock);
 	regions[nr_regions].base = base;
 	regions[nr_regions].size = top - base;
 	++nr_regions;
 	base = top;
-	spin_unlock(&lock);
 }
-- 
2.37.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
