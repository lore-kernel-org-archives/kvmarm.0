Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51851C25B06
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 09:15:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A7904C982;
	Tue,  9 Aug 2022 05:15:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 496S9LC196Qj; Tue,  9 Aug 2022 05:15:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 315FC4C4CB;
	Tue,  9 Aug 2022 05:15:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D644C4C4E2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lq+2YS5McLiS for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:15:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9CCAE4C53B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:38 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25EA723A;
 Tue,  9 Aug 2022 02:15:39 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 460433F67D;
 Tue,  9 Aug 2022 02:15:37 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 08/19] arm/arm64: Use pgd_alloc() to
 allocate mmu_idmap
Date: Tue,  9 Aug 2022 10:15:47 +0100
Message-Id: <20220809091558.14379-9-alexandru.elisei@arm.com>
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

Until commit 031755dbfefb ("arm: enable vmalloc"), the idmap was allocated
using pgd_alloc(). After that commit, all the page table allocator
functions were switched to using the page allocator, but pgd_alloc() was
left unchanged and became unused, with the idmap now being allocated with
alloc_page().

For arm64, the pgd table size varies based on the page size, which is
configured by the user. For arm, it will always contain 4 entries (it
translates bits 31:30 of the input address). To keep things simple and
consistent with the other functions and across both architectures, modify
pgd_alloc() to use alloc_page() instead of memalign like the rest of the
page table allocator functions and use it to allocate the idmap.

Note that when the idmap is created, alloc_ops->memalign is
memalign_pages() which allocates memory with page granularity. Using
memalign() as before would still have allocated a full page.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/pgtable.h   | 4 ++--
 lib/arm/mmu.c           | 4 ++--
 lib/arm64/asm/pgtable.h | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index d7c73906ba5e..a35f42965df9 100644
--- a/lib/arm/asm/pgtable.h
+++ b/lib/arm/asm/pgtable.h
@@ -43,8 +43,8 @@
 #define pgd_free(pgd) free(pgd)
 static inline pgd_t *pgd_alloc(void)
 {
-	pgd_t *pgd = memalign(L1_CACHE_BYTES, PTRS_PER_PGD * sizeof(pgd_t));
-	memset(pgd, 0, PTRS_PER_PGD * sizeof(pgd_t));
+	assert(PTRS_PER_PGD * sizeof(pgd_t) <= PAGE_SIZE);
+	pgd_t *pgd = alloc_page();
 	return pgd;
 }
 
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 8f936acafe8b..2b7405d0274f 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -165,7 +165,7 @@ void *setup_mmu(phys_addr_t unused0, void *unused1)
 #endif
 
 	if (!mmu_idmap)
-		mmu_idmap = alloc_page();
+		mmu_idmap = pgd_alloc();
 
 	for (r = mem_regions; r->end; ++r) {
 		if (r->flags & MR_F_IO) {
@@ -197,7 +197,7 @@ void __iomem *__ioremap(phys_addr_t phys_addr, size_t size)
 		pgtable = current_thread_info()->pgtable;
 	} else {
 		if (!mmu_idmap)
-			mmu_idmap = alloc_page();
+			mmu_idmap = pgd_alloc();
 		pgtable = mmu_idmap;
 	}
 
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index bfb8a993e112..06357920aa74 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -49,8 +49,8 @@
 #define pgd_free(pgd) free(pgd)
 static inline pgd_t *pgd_alloc(void)
 {
-	pgd_t *pgd = memalign(PAGE_SIZE, PTRS_PER_PGD * sizeof(pgd_t));
-	memset(pgd, 0, PTRS_PER_PGD * sizeof(pgd_t));
+	assert(PTRS_PER_PGD * sizeof(pgd_t) <= PAGE_SIZE);
+	pgd_t *pgd = alloc_page();
 	return pgd;
 }
 
-- 
2.37.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
