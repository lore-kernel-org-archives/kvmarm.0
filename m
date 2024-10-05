Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ACB1145FEB
	for <kvmarm@lists.linux.dev>; Sat,  5 Oct 2024 12:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728131921; cv=none; b=TN3PFtIfum/nyP/TYKGX61WNCRXITgTyVUeK+TfelGLm256ZgEf89EbhxUvhE+7R/zYyn3KgXYgWrVlcMmsDQhdDnIblIcguDd2Q4mBTzLnb3p+tgIVyNQRRFhZLl/Gko7w/sokCo++4L4GAiWilIuU/aFuBZtGk5OddNZ0OSJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728131921; c=relaxed/simple;
	bh=7zrasJNwnYsyr+LOvEEOwy/SzZXk+OU/QkFhgFojQsQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dxuwYBGaBM/XtxqTbao1lSvFeWdr1tDgjnkTHefWJyDN/Pq21ngAR91QRdQQmm1bOg8PWfrclCuGOBMbg6t6iV90cIw+uMftC+iXUbV7mtP0AqZallz42kGZz7zPO2LCYhOCYM60s5FBV+aOE+a2gVJKMsR4NoxzGSr+BzJXNTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F37C106F;
	Sat,  5 Oct 2024 05:39:08 -0700 (PDT)
Received: from a077893.arm.com (unknown [10.163.39.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DE9D83F64C;
	Sat,  5 Oct 2024 05:38:34 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] arm64/mm: Replace PXD_TABLE_BIT with PXD_TYPE_[MASK|SECT]
Date: Sat,  5 Oct 2024 18:08:21 +0530
Message-Id: <20241005123824.1366397-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241005123824.1366397-1-anshuman.khandual@arm.com>
References: <20241005123824.1366397-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This modifies existing block mapping related helpers e.g [pmd|pud]_mkhuge()
, mk_[pmd|pud]_sect_prot() and pmd_trans_huge() to use PXD_TYPE_[MASK|SECT]
instead of corresponding PXD_TABLE_BIT. This also moves pmd_sect() earlier
for the symbol's availability preventing a build warning.

While here this also drops pmd_val() check from pmd_trans_huge() helper, as
pmd_present() returning true already ensures that pmd_val() cannot be false

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index fa4c32a9f572..45c49c5ace80 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -484,12 +484,12 @@ static inline pmd_t pte_pmd(pte_t pte)
 
 static inline pgprot_t mk_pud_sect_prot(pgprot_t prot)
 {
-	return __pgprot((pgprot_val(prot) & ~PUD_TABLE_BIT) | PUD_TYPE_SECT);
+	return __pgprot((pgprot_val(prot) & ~PUD_TYPE_MASK) | PUD_TYPE_SECT);
 }
 
 static inline pgprot_t mk_pmd_sect_prot(pgprot_t prot)
 {
-	return __pgprot((pgprot_val(prot) & ~PMD_TABLE_BIT) | PMD_TYPE_SECT);
+	return __pgprot((pgprot_val(prot) & ~PMD_TYPE_MASK) | PMD_TYPE_SECT);
 }
 
 static inline pte_t pte_swp_mkexclusive(pte_t pte)
@@ -554,10 +554,13 @@ static inline int pmd_protnone(pmd_t pmd)
  * THP definitions.
  */
 
+#define pmd_sect(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
+				 PMD_TYPE_SECT)
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int pmd_trans_huge(pmd_t pmd)
 {
-	return pmd_val(pmd) && pmd_present(pmd) && !(pmd_val(pmd) & PMD_TABLE_BIT);
+	return pmd_present(pmd) && pmd_sect(pmd);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
@@ -586,7 +589,7 @@ static inline int pmd_trans_huge(pmd_t pmd)
 
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 
-#define pmd_mkhuge(pmd)		(__pmd(pmd_val(pmd) & ~PMD_TABLE_BIT))
+#define pmd_mkhuge(pmd)		(__pmd((pmd_val(pmd) & ~PMD_TYPE_MASK) | PMD_TYPE_SECT))
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define pmd_devmap(pmd)		pte_devmap(pmd_pte(pmd))
@@ -614,7 +617,7 @@ static inline pmd_t pmd_mkspecial(pmd_t pmd)
 #define pud_mkyoung(pud)	pte_pud(pte_mkyoung(pud_pte(pud)))
 #define pud_write(pud)		pte_write(pud_pte(pud))
 
-#define pud_mkhuge(pud)		(__pud(pud_val(pud) & ~PUD_TABLE_BIT))
+#define pud_mkhuge(pud)		(__pud((pud_val(pud) & ~PUD_TYPE_MASK) | PUD_TYPE_SECT))
 
 #define __pud_to_phys(pud)	__pte_to_phys(pud_pte(pud))
 #define __phys_to_pud_val(phys)	__phys_to_pte_val(phys)
@@ -712,8 +715,6 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 
 #define pmd_table(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
 				 PMD_TYPE_TABLE)
-#define pmd_sect(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
-				 PMD_TYPE_SECT)
 #define pmd_leaf(pmd)		(pmd_present(pmd) && !pmd_table(pmd))
 #define pmd_bad(pmd)		(!pmd_table(pmd))
 
-- 
2.25.1

