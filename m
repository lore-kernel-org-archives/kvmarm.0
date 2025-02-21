Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F5931FBE88
	for <kvmarm@lists.linux.dev>; Fri, 21 Feb 2025 04:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740112982; cv=none; b=OR3KPJ0jQy61kv3w8P3rQy5wu5aI4fzvHwrdVLnhQN5RuiVkWRCR/rRsfk898/B5ZbT9WpA3WJKsG+Z7I+h024D0g/WhZuG78KJJppQ1H7GUpjD65WzMJpOLxnXfa+Alv7+a2kuLr7Z7hVSgjBHFCDEKFqzaH+tyB+kFb5ncKT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740112982; c=relaxed/simple;
	bh=w12RmaK2E7AsICmm7r1Zy5+t5NgzhGpim7OZ2dRKUyA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V6p2RKWo8x+I6x/of8Uu/wGNpJfCYIGKFPKUbl9gdnJRfFXqnqorBavFjlCNW0yK5vvaiCtSDK9eq61fYYRV/DRZ+XqHwCbVrdA0nfj4EyBPqP9xnI/70yX7GV6H366r5C9kZ8YthUsjiE5VfsN4wW+IN2caVUS9eyz4H4vr+GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DBB601C01;
	Thu, 20 Feb 2025 20:43:18 -0800 (PST)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.40.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 808E03F6A8;
	Thu, 20 Feb 2025 20:42:56 -0800 (PST)
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
Subject: [PATCH V2 4/8] arm64/mm: Clear PXX_TYPE_MASK and set PXD_TYPE_SECT in [pmd|pud]_mkhuge()
Date: Fri, 21 Feb 2025 10:12:23 +0530
Message-Id: <20250221044227.1145393-5-anshuman.khandual@arm.com>
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

Clear PXX_TYPE_MASK in [pmd|pud]_mkhuge() while creating section mappings
instead of just the PXX_TABLE_BIT and also set PXD_TYPE_SECT. Also ensure
PTE_VALID does not get modified in these helpers, because present-invalid
entries should preserve their state across.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index c16e9e74e309..4485ecdffd8a 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -585,7 +585,18 @@ static inline int pmd_trans_huge(pmd_t pmd)
 
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 
-#define pmd_mkhuge(pmd)		(__pmd(pmd_val(pmd) & ~PMD_TABLE_BIT))
+static inline pmd_t pmd_mkhuge(pmd_t pmd)
+{
+	/*
+	 * It's possible that the pmd is present-invalid on entry
+	 * and in that case it needs to remain present-invalid on
+	 * exit. So ensure the VALID bit does not get modified.
+	 */
+	pmdval_t mask = PMD_TYPE_MASK & ~PTE_VALID;
+	pmdval_t val = PMD_TYPE_SECT & ~PTE_VALID;
+
+	return __pmd((pmd_val(pmd) & ~mask) | val);
+}
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define pmd_devmap(pmd)		pte_devmap(pmd_pte(pmd))
@@ -613,7 +624,18 @@ static inline pmd_t pmd_mkspecial(pmd_t pmd)
 #define pud_mkyoung(pud)	pte_pud(pte_mkyoung(pud_pte(pud)))
 #define pud_write(pud)		pte_write(pud_pte(pud))
 
-#define pud_mkhuge(pud)		(__pud(pud_val(pud) & ~PUD_TABLE_BIT))
+static inline pud_t pud_mkhuge(pud_t pud)
+{
+	/*
+	 * It's possible that the pud is present-invalid on entry
+	 * and in that case it needs to remain present-invalid on
+	 * exit. So ensure the VALID bit does not get modified.
+	 */
+	pudval_t mask = PUD_TYPE_MASK & ~PTE_VALID;
+	pudval_t val = PUD_TYPE_SECT & ~PTE_VALID;
+
+	return __pud((pud_val(pud) & ~mask) | val);
+}
 
 #define __pud_to_phys(pud)	__pte_to_phys(pud_pte(pud))
 #define __phys_to_pud_val(phys)	__phys_to_pte_val(phys)
-- 
2.25.1

