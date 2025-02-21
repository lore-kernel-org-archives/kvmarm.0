Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0443D1FBC9F
	for <kvmarm@lists.linux.dev>; Fri, 21 Feb 2025 04:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740112998; cv=none; b=kjMhDqjhiLXPUTWIijqVmi4gkb0SciUMEkbtTAHzgwyQodkwhsRtOJatNM/Tba/uLGglJNur2Xgj/IFGZaQrJTV/ZrPG/mB2soSJJSnbJAloogS7qvFE8Pes8FzhyX7gDN+OZCFt+/0jZOYKtfTf/5b9Kmpo4+pbFiKobCg6cG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740112998; c=relaxed/simple;
	bh=o7ocm2mFHHcbmmMokLaKZy8UH7LG+uFyktAwvZTFEd0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e23CsKVRyu6HmCUOMN/BtO3FrKhuWXYdFkxN8vJZfEQQ61xNIvPVcz3g4wsy293a1lm/BxTqtay6UGoQ3X4CivB3YJWCvtK3eNrSshGIK9SxpdcCI5srMu1yeiD8IVsgGtqL0eqyfRlVIGPWEN0OCo4lPmXR+oNkhSsgrqrKw3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 261351C01;
	Thu, 20 Feb 2025 20:43:34 -0800 (PST)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.40.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BF62E3F6A8;
	Thu, 20 Feb 2025 20:43:11 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: arm-kernel@lists.infradead.org
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
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V2 7/8] arm64/mm: Check pmd_table() in pmd_trans_huge()
Date: Fri, 21 Feb 2025 10:12:26 +0530
Message-Id: <20250221044227.1145393-8-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250221044227.1145393-1-anshuman.khandual@arm.com>
References: <20250221044227.1145393-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ryan Roberts <ryan.roberts@arm.com>

Check for pmd_table() in pmd_trans_huge() rather then just checking for the
PMD_TABLE_BIT. But ensure all present-invalid entries are handled correctly
by always setting PTE_VALID before checking with pmd_table().

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index d16f514bde0f..df89e8ec8413 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -548,18 +548,6 @@ static inline int pmd_protnone(pmd_t pmd)
 #endif
 
 #define pmd_present(pmd)	pte_present(pmd_pte(pmd))
-
-/*
- * THP definitions.
- */
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-static inline int pmd_trans_huge(pmd_t pmd)
-{
-	return pmd_val(pmd) && pmd_present(pmd) && !(pmd_val(pmd) & PMD_TABLE_BIT);
-}
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-
 #define pmd_dirty(pmd)		pte_dirty(pmd_pte(pmd))
 #define pmd_young(pmd)		pte_young(pmd_pte(pmd))
 #define pmd_valid(pmd)		pte_valid(pmd_pte(pmd))
@@ -746,6 +734,18 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 #define pmd_leaf_size(pmd)	(pmd_cont(pmd) ? CONT_PMD_SIZE : PMD_SIZE)
 #define pte_leaf_size(pte)	(pte_cont(pte) ? CONT_PTE_SIZE : PAGE_SIZE)
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline int pmd_trans_huge(pmd_t pmd)
+{
+	/*
+	 * If pmd is present-invalid, pmd_table() won't detect it
+	 * as a table, so force the valid bit for the comparison.
+	 */
+	return pmd_val(pmd) && pmd_present(pmd) &&
+	       !pmd_table(__pmd(pmd_val(pmd) | PTE_VALID));
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
 #if defined(CONFIG_ARM64_64K_PAGES) || CONFIG_PGTABLE_LEVELS < 3
 static inline bool pud_sect(pud_t pud) { return false; }
 static inline bool pud_table(pud_t pud) { return true; }
-- 
2.25.1

