Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 560BA14F9DD
	for <kvmarm@lists.linux.dev>; Sat,  5 Oct 2024 12:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728131933; cv=none; b=BOq6feQ/BCGDsyTDg0LyWri9Vov/CSWlW8mhXhv6RAQkcOyY49OGhfsA/DamJJgAGLL8o3bh7MyMFDXOec2wUqXeNOQA+bsdnA23X/94dlJrpzS6IdYcvLgeYQc/2f8SKJw1apmjINPeAs68sbLt6EIAOwxx/hyD1LgZZYGbycY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728131933; c=relaxed/simple;
	bh=P4renK8VRo+8S283PlYDtwyBxs58Pg1nLMEqFY3M+b0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DWldk2HKucqr4BCERPGMZNMKSBVLfeevzo3tfTGht3R/GfIp3ThAewbIzREAA9njO4I5Aj1AI/5Z6y2+k3vbkg06FFmEztEGRgl9OuThvu4W26RAl8VbSuZ4LzHYYTCQIThnGI5MjeCto7oWPBKN2/ud0ZSvFJtP/OwGmxeYoHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5845D1063;
	Sat,  5 Oct 2024 05:39:21 -0700 (PDT)
Received: from a077893.arm.com (unknown [10.163.39.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0BCF33F64C;
	Sat,  5 Oct 2024 05:38:47 -0700 (PDT)
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
Subject: [PATCH 5/5] arm64/mm: Drop PXD_TABLE_BIT
Date: Sat,  5 Oct 2024 18:08:24 +0530
Message-Id: <20241005123824.1366397-6-anshuman.khandual@arm.com>
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

This just drops table bit position markers for all page table levels, which
are not used any more.

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
index 956a702cb532..a524a8bb570f 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -97,7 +97,6 @@
  * Level -1 descriptor (PGD).
  */
 #define PGD_TYPE_TABLE		(_AT(pgdval_t, 3) << 0)
-#define PGD_TABLE_BIT		(_AT(pgdval_t, 1) << 1)
 #define PGD_TYPE_MASK		(_AT(pgdval_t, 3) << 0)
 #define PGD_TABLE_PXN		(_AT(pgdval_t, 1) << 59)
 #define PGD_TABLE_UXN		(_AT(pgdval_t, 1) << 60)
@@ -106,7 +105,6 @@
  * Level 0 descriptor (P4D).
  */
 #define P4D_TYPE_TABLE		(_AT(p4dval_t, 3) << 0)
-#define P4D_TABLE_BIT		(_AT(p4dval_t, 1) << 1)
 #define P4D_TYPE_MASK		(_AT(p4dval_t, 3) << 0)
 #define P4D_TYPE_SECT		(_AT(p4dval_t, 1) << 0)
 #define P4D_SECT_RDONLY		(_AT(p4dval_t, 1) << 7)		/* AP[2] */
@@ -117,7 +115,6 @@
  * Level 1 descriptor (PUD).
  */
 #define PUD_TYPE_TABLE		(_AT(pudval_t, 3) << 0)
-#define PUD_TABLE_BIT		(_AT(pudval_t, 1) << 1)
 #define PUD_TYPE_MASK		(_AT(pudval_t, 3) << 0)
 #define PUD_TYPE_SECT		(_AT(pudval_t, 1) << 0)
 #define PUD_SECT_RDONLY		(_AT(pudval_t, 1) << 7)		/* AP[2] */
@@ -130,7 +127,6 @@
 #define PMD_TYPE_MASK		(_AT(pmdval_t, 3) << 0)
 #define PMD_TYPE_TABLE		(_AT(pmdval_t, 3) << 0)
 #define PMD_TYPE_SECT		(_AT(pmdval_t, 1) << 0)
-#define PMD_TABLE_BIT		(_AT(pmdval_t, 1) << 1)
 
 /*
  * Section
@@ -159,7 +155,6 @@
 #define PTE_TYPE_MASK		(_AT(pteval_t, 3) << 0)
 #define PTE_TYPE_PAGE		(_AT(pteval_t, 3) << 0)
 #define PTE_TYPE_SECT		(_AT(pteval_t, 1) << 0)
-#define PTE_TABLE_BIT		(_AT(pteval_t, 1) << 1)
 #define PTE_USER		(_AT(pteval_t, 1) << 6)		/* AP[1] */
 #define PTE_RDONLY		(_AT(pteval_t, 1) << 7)		/* AP[2] */
 #define PTE_SHARED		(_AT(pteval_t, 3) << 8)		/* SH[1:0], inner shareable */
-- 
2.25.1

