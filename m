Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53932BE64
	for <kvmarm@lists.linux.dev>; Wed, 23 Aug 2023 13:16:36 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F7C11655;
	Wed, 23 Aug 2023 06:17:16 -0700 (PDT)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 880023F740;
	Wed, 23 Aug 2023 06:16:29 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	oliver.upton@linux.dev,
	maz@kernel.org,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	arnd@arndb.de,
	akpm@linux-foundation.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	bristot@redhat.com,
	vschneid@redhat.com,
	mhiramat@kernel.org,
	rppt@kernel.org,
	hughd@google.com
Cc: pcc@google.com,
	steven.price@arm.com,
	anshuman.khandual@arm.com,
	vincenzo.frascino@arm.com,
	david@redhat.com,
	eugenis@google.com,
	kcc@google.com,
	hyesoo.yu@samsung.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH RFC 23/37] mm: Teach vma_alloc_folio() about metadata-enabled VMAs
Date: Wed, 23 Aug 2023 14:13:36 +0100
Message-Id: <20230823131350.114942-24-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230823131350.114942-1-alexandru.elisei@arm.com>
References: <20230823131350.114942-1-alexandru.elisei@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an anonymous page is mapped into the user address space as a result of
a write fault, that page is zeroed. On arm64, when the VMA has metadata
enabled, the tags are zeroed at the same time as the page contents, with
the combination of gfp flags __GFP_ZERO | __GFP_TAGGED (which used be
called __GFP_ZEROTAGS for this reason). For this use case, it is enough to
set the __GFP_TAGGED flag in vma_alloc_zeroed_movable_folio().

But with dynamic tag storage reuse, it becomes necessary to have the
__GFP_TAGGED flag set when allocating a page to be mapped in a VMA with
metadata enabled in order reserve the corresponding metadata storage.
Change vma_alloc_folio() to take into account VMAs with metadata enabled.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/page.h |  5 ++---
 arch/arm64/mm/fault.c         | 19 -------------------
 mm/mempolicy.c                |  3 +++
 3 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index 2312e6ee595f..88bab032a493 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -29,9 +29,8 @@ void copy_user_highpage(struct page *to, struct page *from,
 void copy_highpage(struct page *to, struct page *from);
 #define __HAVE_ARCH_COPY_HIGHPAGE
 
-struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
-						unsigned long vaddr);
-#define vma_alloc_zeroed_movable_folio vma_alloc_zeroed_movable_folio
+#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
+	vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr, false)
 
 void tag_clear_highpage(struct page *to);
 #define __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 1ca421c11ebc..7e2dcf5e3baf 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -936,25 +936,6 @@ void do_debug_exception(unsigned long addr_if_watchpoint, unsigned long esr,
 }
 NOKPROBE_SYMBOL(do_debug_exception);
 
-/*
- * Used during anonymous page fault handling.
- */
-struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
-						unsigned long vaddr)
-{
-	gfp_t flags = GFP_HIGHUSER_MOVABLE | __GFP_ZERO;
-
-	/*
-	 * If the page is mapped with PROT_MTE, initialise the tags at the
-	 * point of allocation and page zeroing as this is usually faster than
-	 * separate DC ZVA and STGM.
-	 */
-	if (vma->vm_flags & VM_MTE)
-		flags |= __GFP_TAGGED;
-
-	return vma_alloc_folio(flags, 0, vma, vaddr, false);
-}
-
 void tag_clear_highpage(struct page *page)
 {
 	/* Tag storage pages cannot be tagged. */
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index d164b5c50243..782e0771cabd 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2170,6 +2170,9 @@ struct folio *vma_alloc_folio(gfp_t gfp, int order, struct vm_area_struct *vma,
 	int preferred_nid;
 	nodemask_t *nmask;
 
+	if (vma->vm_flags & VM_MTE)
+		gfp |= __GFP_TAGGED;
+
 	pol = get_vma_policy(vma, addr);
 
 	if (pol->mode == MPOL_INTERLEAVE) {
-- 
2.41.0

