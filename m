Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E1E1D271A
	for <kvmarm@lists.linux.dev>; Mon, 14 Oct 2024 11:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728903716; cv=none; b=pv9xPjKg6KJYTpgWrTVUGQme/Z/GTQgzAaKmxdGny5kvO0gS3HNcK1ijnfri9fw3YMofx58JDUhb4Iq/KyNKEik8FvnCQOVsBe7HBugfj/2CyafRkg0ESxYVCi8gbQ5nBZQ6mHxD7jL0kaXZxhPCRLJhrxr52vPTv0Iq/yEpnL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728903716; c=relaxed/simple;
	bh=sjwU7BUgzN01wTQM2WKLIvC11P4vGU1exV8tjpcVD2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoYL2VMzH6o/bB+sAIZdxTiWC0Wfq5pNpczvblp/6Zya68XYSvxqJ3oiBmvzNDQnvizq32nPs2teq1BAa4mCphtETwvRrCZv0WnljBKZewvMVirSKy6XWQlaDjsX+mCAYOkjka7jRKOIGXpj4dM0fIq/tByqD39MSBtq4Av0Vcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A0064176C;
	Mon, 14 Oct 2024 04:02:23 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 62FEC3F51B;
	Mon, 14 Oct 2024 04:01:51 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Greg Marsden <greg.marsden@oracle.com>,
	Ivan Ivanov <ivan.ivanov@suse.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Matthias Brugger <mbrugger@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1 48/57] arm64: Convert switch to if for non-const comparison values
Date: Mon, 14 Oct 2024 11:58:55 +0100
Message-ID: <20241014105912.3207374-48-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241014105912.3207374-1-ryan.roberts@arm.com>
References: <20241014105514.3206191-1-ryan.roberts@arm.com>
 <20241014105912.3207374-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When we enable boot-time page size, some macros are no longer
compile-time constants. Where these macros are used as cases in switch
statements, the switch statements no longer compile.

Let's convert these to if/else blocks, which can handle the runtime
values.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---

***NOTE***
Any confused maintainers may want to read the cover note here for context:
https://lore.kernel.org/all/20241014105514.3206191-1-ryan.roberts@arm.com/

 arch/arm64/kvm/mmu.c        | 32 +++++++++++++++-----------------
 arch/arm64/mm/hugetlbpage.c | 34 +++++++++++-----------------------
 2 files changed, 26 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a509b63bd4dd5..248a2d7ad6dbb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1487,29 +1487,27 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		vma_shift = get_vma_page_shift(vma, hva);
 	}
 
-	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
-	case PUD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
-			break;
-		fallthrough;
+	if (vma_shift == PUD_SHIFT) {
+		if (!fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
+			vma_shift = PMD_SHIFT;
+	}
 #endif
-	case CONT_PMD_SHIFT:
+	if (vma_shift == CONT_PMD_SHIFT) {
 		vma_shift = PMD_SHIFT;
-		fallthrough;
-	case PMD_SHIFT:
-		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
-			break;
-		fallthrough;
-	case CONT_PTE_SHIFT:
+	}
+	if (vma_shift == PMD_SHIFT) {
+		if (!fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
+			vma_shift = PAGE_SHIFT;
+	}
+	if (vma_shift == CONT_PTE_SHIFT) {
 		vma_shift = PAGE_SHIFT;
 		force_pte = true;
-		fallthrough;
-	case PAGE_SHIFT:
-		break;
-	default:
-		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
 	}
+	if (vma_shift != PUD_SHIFT &&
+	    vma_shift != PMD_SHIFT &&
+	    vma_shift != PAGE_SHIFT)
+		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
 
 	vma_pagesize = 1UL << vma_shift;
 
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 5f1e2103888b7..bc98c20655bba 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -51,16 +51,12 @@ void __init arm64_hugetlb_cma_reserve(void)
 
 static bool __hugetlb_valid_size(unsigned long size)
 {
-	switch (size) {
 #ifndef __PAGETABLE_PMD_FOLDED
-	case PUD_SIZE:
+	if (size == PUD_SIZE)
 		return pud_sect_supported();
 #endif
-	case CONT_PMD_SIZE:
-	case PMD_SIZE:
-	case CONT_PTE_SIZE:
+	if (size == CONT_PMD_SIZE || size == PMD_SIZE || size == CONT_PTE_SIZE)
 		return true;
-	}
 
 	return false;
 }
@@ -104,24 +100,20 @@ static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
 
 	*pgsize = size;
 
-	switch (size) {
 #ifndef __PAGETABLE_PMD_FOLDED
-	case PUD_SIZE:
+	if (size == PUD_SIZE) {
 		if (pud_sect_supported())
 			contig_ptes = 1;
-		break;
+	} else
 #endif
-	case PMD_SIZE:
+	if (size == PMD_SIZE) {
 		contig_ptes = 1;
-		break;
-	case CONT_PMD_SIZE:
+	} else if (size == CONT_PMD_SIZE) {
 		*pgsize = PMD_SIZE;
 		contig_ptes = CONT_PMDS;
-		break;
-	case CONT_PTE_SIZE:
+	} else if (size == CONT_PTE_SIZE) {
 		*pgsize = PAGE_SIZE;
 		contig_ptes = CONT_PTES;
-		break;
 	}
 
 	return contig_ptes;
@@ -339,20 +331,16 @@ unsigned long hugetlb_mask_last_page(struct hstate *h)
 {
 	unsigned long hp_size = huge_page_size(h);
 
-	switch (hp_size) {
 #ifndef __PAGETABLE_PMD_FOLDED
-	case PUD_SIZE:
+	if (hp_size == PUD_SIZE)
 		return PGDIR_SIZE - PUD_SIZE;
 #endif
-	case CONT_PMD_SIZE:
+	if (hp_size == CONT_PMD_SIZE)
 		return PUD_SIZE - CONT_PMD_SIZE;
-	case PMD_SIZE:
+	if (hp_size == PMD_SIZE)
 		return PUD_SIZE - PMD_SIZE;
-	case CONT_PTE_SIZE:
+	if (hp_size == CONT_PTE_SIZE)
 		return PMD_SIZE - CONT_PTE_SIZE;
-	default:
-		break;
-	}
 
 	return 0UL;
 }
-- 
2.43.0

