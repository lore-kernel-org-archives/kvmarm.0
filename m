Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C881FBEB9
	for <kvmarm@lists.linux.dev>; Fri, 21 Feb 2025 04:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740113003; cv=none; b=ahhavdcV1AfXfYB5ASyLtLO4R0dS5kBiZiiy/hK9jCxkQnjPVljCvBsdwffyNZ6fGZxwppMCVEd7V7WM/ufMGrNPhyrVN6t6tmB85hH1xlh+pdBHC9TDuODs5+KBX4lREIecngCf1Skc1MXv9Ty4LYkUsbcVixn6tEKYXyGWyfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740113003; c=relaxed/simple;
	bh=D2OKJrx1OW0VXw8kaAyRpIYZbuy2DmVlwH6ECyJpnJM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N7ai37Md5zeRBEC0ADQO6oG+p/w707LwbMuigFGg0JJhZjAIgHQGnjxIzzfi3WrfUeBzs/OSfCj3sAJ3DuCqWNMM36CNye8L/PzdNBKSanHL2gCbAhRFh7Aj/Z8LxNvoHfPS2YGplOC7uLPFXvRGlh7Mltze/g+hRAkR5uPY1lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2A1DD271B;
	Thu, 20 Feb 2025 20:43:39 -0800 (PST)
Received: from a077893.blr.arm.com (a077893.blr.arm.com [10.162.40.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DCE923F6A8;
	Thu, 20 Feb 2025 20:43:16 -0800 (PST)
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
Subject: [PATCH V2 8/8] arm64/mm: Drop PXD_TABLE_BIT
Date: Fri, 21 Feb 2025 10:12:27 +0530
Message-Id: <20250221044227.1145393-9-anshuman.khandual@arm.com>
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

Drop all PXD_TABLE_BIT macros as they are not used any more.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/pgtable-hwdef.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index a9136cc551cc..d2a13c329702 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -97,7 +97,6 @@
  * Level -1 descriptor (PGD).
  */
 #define PGD_TYPE_TABLE		(_AT(pgdval_t, 3) << 0)
-#define PGD_TABLE_BIT		(_AT(pgdval_t, 1) << 1)
 #define PGD_TYPE_MASK		(_AT(pgdval_t, 3) << 0)
 #define PGD_TABLE_AF		(_AT(pgdval_t, 1) << 10)	/* Ignored if no FEAT_HAFT */
 #define PGD_TABLE_PXN		(_AT(pgdval_t, 1) << 59)
@@ -107,7 +106,6 @@
  * Level 0 descriptor (P4D).
  */
 #define P4D_TYPE_TABLE		(_AT(p4dval_t, 3) << 0)
-#define P4D_TABLE_BIT		(_AT(p4dval_t, 1) << 1)
 #define P4D_TYPE_MASK		(_AT(p4dval_t, 3) << 0)
 #define P4D_TYPE_SECT		(_AT(p4dval_t, 1) << 0)
 #define P4D_SECT_RDONLY		(_AT(p4dval_t, 1) << 7)		/* AP[2] */
@@ -119,7 +117,6 @@
  * Level 1 descriptor (PUD).
  */
 #define PUD_TYPE_TABLE		(_AT(pudval_t, 3) << 0)
-#define PUD_TABLE_BIT		(_AT(pudval_t, 1) << 1)
 #define PUD_TYPE_MASK		(_AT(pudval_t, 3) << 0)
 #define PUD_TYPE_SECT		(_AT(pudval_t, 1) << 0)
 #define PUD_SECT_RDONLY		(_AT(pudval_t, 1) << 7)		/* AP[2] */
@@ -133,7 +130,6 @@
 #define PMD_TYPE_MASK		(_AT(pmdval_t, 3) << 0)
 #define PMD_TYPE_TABLE		(_AT(pmdval_t, 3) << 0)
 #define PMD_TYPE_SECT		(_AT(pmdval_t, 1) << 0)
-#define PMD_TABLE_BIT		(_AT(pmdval_t, 1) << 1)
 #define PMD_TABLE_AF		(_AT(pmdval_t, 1) << 10)	/* Ignored if no FEAT_HAFT */
 
 /*
@@ -162,7 +158,6 @@
 #define PTE_VALID		(_AT(pteval_t, 1) << 0)
 #define PTE_TYPE_MASK		(_AT(pteval_t, 3) << 0)
 #define PTE_TYPE_PAGE		(_AT(pteval_t, 3) << 0)
-#define PTE_TABLE_BIT		(_AT(pteval_t, 1) << 1)
 #define PTE_USER		(_AT(pteval_t, 1) << 6)		/* AP[1] */
 #define PTE_RDONLY		(_AT(pteval_t, 1) << 7)		/* AP[2] */
 #define PTE_SHARED		(_AT(pteval_t, 3) << 8)		/* SH[1:0], inner shareable */
-- 
2.25.1

