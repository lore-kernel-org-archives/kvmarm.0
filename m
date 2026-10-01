Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF977488DA0
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 15:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867823; cv=none; b=I1hD83wdV8gvqitP7mwXGKQLDukorjZsGfvHBzhg/VCYclv3Negep+Enwen35Qcb+6z6yosFqWQL8N6nJZCSmlNeTSTa6EcExicTJy8Ut4mY2MJhHiGBK7EpJ2Fpy0GLX3+dy1laq4HSsJ8p1l4Suy3EAM4EnIsrlrqdM6O7eAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867823; c=relaxed/simple;
	bh=E3wmf/sxRiqvJrdcJTqXrzJH+pnOvyFD54tPrUyx9lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VppQpTqccJ7QyxwJwLjXhxUBm0mAY/7nk1fBjZ70o9vEAoOyfiyccW+TcmiNXJEic6s0uzVaXXIf+Odk/K0NzB207TJZMlUbNYLVLULZRBJlP6rjtME4Hn5CUONog4y9teoJfQnqFDm8lPCKXR4k0ifczsse3JEuhYDgJrBKPq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=D4F1rFZd; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="D4F1rFZd"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD17A1476;
	Thu,  1 Oct 2026 08:16:57 -0700 (PDT)
Received: from e143914.cambridge.arm.com (e143914.arm.com [10.2.213.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7CA43F86F;
	Thu,  1 Oct 2026 08:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790867821; bh=E3wmf/sxRiqvJrdcJTqXrzJH+pnOvyFD54tPrUyx9lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4F1rFZdt7fxNxhJXkFE+L2wK3fzJYYfk1fCB1b0EnGi4jQTIzMY/jxGWGlsqPxDi
	 ITcFf97BanVZlOda2gPf8N/8XHB9STnnrK+putYX2pB6RteSfAG6brtEk8ENkw0jZ5
	 +5vI9gNbRgT6/h2ffURJ0zsyKZlIKLkCeeIz6y+4=
From: Joey Gouly <joey.gouly@arm.com>
To: kvmarm@lists.linux.dev
Cc: Jing Zhang <jingzhangos@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	andrew.jones@linux.dev,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH v3 3/8] lib: arm64: Add stage2 page table management library
Date: Thu,  1 Oct 2026 16:16:40 +0100
Message-ID: <20261001151645.2427065-4-joey.gouly@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001151645.2427065-1-joey.gouly@arm.com>
References: <20261001151645.2427065-1-joey.gouly@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jing Zhang <jingzhangos@google.com>

Tests running at EL2 (hypervisor level) require the ability to manage Stage
2 translation tables to control Guest Physical Address (IPA) to Host
Physical Address (PA) translation.

Add a generic Stage 2 MMU library that provides software management of
ARM64 Stage-2 translation tables.

The library features include:
- Support for 4K translation granules, further work needed for 16K/64K.
- Dynamic page table allocation using the allocator.
- Basic support for block mappings where applicable.
- APIs for mapping, unmapping, and loading the Stage 2 MMU.
- Basic fault info reporting (ESR, FAR, HPFAR).

Signed-off-by: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
---
 arm/Makefile.arm64         |   1 +
 lib/arm64/asm/stage2_mmu.h |  76 +++++++
 lib/arm64/asm/sysreg.h     |  29 +++
 lib/arm64/stage2_mmu.c     | 406 +++++++++++++++++++++++++++++++++++++
 4 files changed, 512 insertions(+)
 create mode 100644 lib/arm64/asm/stage2_mmu.h
 create mode 100644 lib/arm64/stage2_mmu.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index a40c830d..5e50f5ba 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -40,6 +40,7 @@ cflatobjs += lib/arm64/stack.o
 cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
+cflatobjs += lib/arm64/stage2_mmu.o
 
 ifeq ($(CONFIG_EFI),y)
 cflatobjs += lib/acpi.o
diff --git a/lib/arm64/asm/stage2_mmu.h b/lib/arm64/asm/stage2_mmu.h
new file mode 100644
index 00000000..182225e1
--- /dev/null
+++ b/lib/arm64/asm/stage2_mmu.h
@@ -0,0 +1,76 @@
+/*
+ * Copyright (C) 2026, Google LLC.
+ * Author: Jing Zhang <jingzhangos@google.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.0-or-later
+ */
+#ifndef _ASMARM64_STAGE2_MMU_H_
+#define _ASMARM64_STAGE2_MMU_H_
+
+#include <libcflat.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+#define pte_is_table(pte)	(pte_val(pte) & PTE_TABLE_BIT)
+
+/* Stage-2 Memory Attributes (MemAttr[3:0]) */
+#define S2_MEMATTR_NORMAL	(0xFUL << 2) /* Normal Memory, Outer/Inner Write-Back */
+#define S2_MEMATTR_DEVICE	(0x0UL << 2) /* Device-nGnRnE */
+
+/* Stage-2 Access Permissions (S2AP[1:0]) */
+#define S2AP_NONE	(0UL << 6)
+#define S2AP_RO		(1UL << 6) /* Read-only */
+#define S2AP_WO		(2UL << 6) /* Write-only */
+#define S2AP_RW		(3UL << 6) /* Read-Write */
+
+/* Flags for mapping */
+#define S2_MAP_RW	(S2AP_RW | S2_MEMATTR_NORMAL | PTE_AF | PTE_SHARED)
+#define S2_MAP_DEVICE	(S2AP_RW | S2_MEMATTR_DEVICE | PTE_AF)
+
+enum s2_granule {
+	S2_PAGE_4K,
+	S2_PAGE_16K,
+	S2_PAGE_64K,
+};
+
+enum s2mmu_error {
+	S2MMU_ERR_NOMEM = -1,
+	S2MMU_ERR_MAPPING_CONFLICT = -2,
+};
+
+/* Main Stage-2 MMU Structure */
+struct s2_mmu {
+	pgd_t *pgd;
+	int vmid;
+	unsigned long vtcr_el2;
+	unsigned long vttbr_el2;
+
+	/* Configuration */
+	enum s2_granule granule;
+	bool allow_block_mappings;
+
+	/* Internal helpers calculated from granule & VA_BITS */
+	unsigned int page_shift;
+	unsigned int level_shift;
+	int root_level; /* 0, 1, or 2 */
+	unsigned long page_size;
+	unsigned long block_size;
+};
+
+/* API */
+/* Initialize an s2_mmu struct with specific settings */
+struct s2_mmu *s2mmu_init(int vmid, enum s2_granule granule, bool allow_block_mappings);
+
+/* Management */
+void s2mmu_destroy(struct s2_mmu *mmu);
+int s2mmu_map(struct s2_mmu *mmu, unsigned long ipa, unsigned long pa,
+	      unsigned long size, unsigned long flags);
+void s2mmu_unmap(struct s2_mmu *mmu, unsigned long ipa, unsigned long size);
+
+/* Install this context on the current CPU. */
+void s2mmu_load(const struct s2_mmu *mmu);
+
+/* Debug */
+void s2mmu_print_fault_info(void);
+
+#endif /* _ASMARM64_STAGE2_MMU_H_ */
diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
index f2d05018..72767cf0 100644
--- a/lib/arm64/asm/sysreg.h
+++ b/lib/arm64/asm/sysreg.h
@@ -118,6 +118,35 @@ asm(
 #define SCTLR_EL1_TCF0_SHIFT	38
 #define SCTLR_EL1_TCF0_MASK	GENMASK_ULL(39, 38)
 
+#define VTCR_EL2_RES1		_BITULL(31)
+
+#define VTCR_EL2_T0SZ_MASK	GENMASK_ULL(5, 0)
+
+#define VTCR_EL2_SL0_SHIFT	6
+
+#define VTCR_EL2_IRGN0_SHIFT	8
+#define VTCR_EL2_IRGN0_WBWA	(UL(1) << VTCR_EL2_IRGN0_SHIFT)
+
+#define VTCR_EL2_ORGN0_SHIFT	10
+#define VTCR_EL2_ORGN0_WBWA	(UL(1) << VTCR_EL2_ORGN0_SHIFT)
+
+#define VTCR_EL2_SH0_SHIFT	12
+#define VTCR_EL2_SH0_INNER	(UL(3) << VTCR_EL2_SH0_SHIFT)
+
+#define VTCR_EL2_TG0_SHIFT	14
+#define VTCR_EL2_TG0_4K		(UL(0) << VTCR_EL2_TG0_SHIFT)
+#define VTCR_EL2_TG0_64K	(UL(1) << VTCR_EL2_TG0_SHIFT)
+#define VTCR_EL2_TG0_16K	(UL(2) << VTCR_EL2_TG0_SHIFT)
+
+#define VTCR_EL2_PS_SHIFT	16
+#define VTCR_EL2_PS_40BIT	(UL(2) << VTCR_EL2_PS_SHIFT)
+#define VTCR_EL2_PS_48BIT	(UL(5) << VTCR_EL2_PS_SHIFT)
+
+#define VTTBR_EL2_CNP		_BITULL(0)
+#define VTTBR_EL2_BADDR_MASK	GENMASK_ULL(47, 1)
+#define VTTBR_EL2_VMID_SHIFT	48
+#define VTTBR_EL2_VMID_MASK	GENMASK_ULL(63, 48)
+
 #define HCR_EL2_TGE		_BITULL(27)
 #define HCR_EL2_RW		_BITULL(31)
 #define HCR_EL2_E2H		_BITULL(34)
diff --git a/lib/arm64/stage2_mmu.c b/lib/arm64/stage2_mmu.c
new file mode 100644
index 00000000..c1c371f4
--- /dev/null
+++ b/lib/arm64/stage2_mmu.c
@@ -0,0 +1,406 @@
+/*
+ * Copyright (C) 2026, Google LLC.
+ * Author: Jing Zhang <jingzhangos@google.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.0-or-later
+ */
+#include <libcflat.h>
+#include <alloc.h>
+#include <asm/stage2_mmu.h>
+#include <asm/sysreg.h>
+#include <asm/io.h>
+#include <asm/barrier.h>
+#include <alloc_page.h>
+
+/* Physical Address Size (PS) - Derive from VA_BITS for simplicity or max */
+#if VA_BITS > 40
+#define VTCR_PS_VAL		VTCR_EL2_PS_48BIT
+#else
+#define VTCR_PS_VAL		VTCR_EL2_PS_40BIT
+#endif
+
+#define S2MMU_SUPPORTED_IPA_BITS	48
+#define S2MMU_MAX_VMID			255
+
+#if VA_BITS != S2MMU_SUPPORTED_IPA_BITS
+#error "The stage-2 MMU currently supports only a 48-bit IPA"
+#endif
+
+static unsigned long s2mmu_build_vtcr(const struct s2_mmu *mmu)
+{
+	unsigned long vtcr = VTCR_EL2_RES1 | VTCR_PS_VAL |
+	                     VTCR_EL2_SH0_INNER | VTCR_EL2_ORGN0_WBWA |
+			     VTCR_EL2_IRGN0_WBWA;
+
+	switch (mmu->granule) {
+	case S2_PAGE_4K:
+		vtcr |= VTCR_EL2_TG0_4K;
+		/* SL0 Encodings for 4K: 0=L2, 1=L1, 2=L0 */
+		if (mmu->root_level == 0)
+			vtcr |= (2UL << VTCR_EL2_SL0_SHIFT); /* Start L0 */
+		else if (mmu->root_level == 1)
+			vtcr |= (1UL << VTCR_EL2_SL0_SHIFT); /* Start L1 */
+		else
+			vtcr |= (0UL << VTCR_EL2_SL0_SHIFT); /* Start L2 */
+		break;
+	case S2_PAGE_16K:
+		vtcr |= VTCR_EL2_TG0_16K;
+		/* SL0 Encodings for 16K: 1=L2, 2=L1 */
+		if (mmu->root_level == 1)
+			vtcr |= (2UL << VTCR_EL2_SL0_SHIFT); /* Start L1 */
+		else
+			vtcr |= (1UL << VTCR_EL2_SL0_SHIFT); /* Start L2 */
+		break;
+	case S2_PAGE_64K:
+		vtcr |= VTCR_EL2_TG0_64K;
+		/* SL0 Encodings for 64K: 1=L2, 2=L1 */
+		if (mmu->root_level == 1)
+			vtcr |= (2UL << VTCR_EL2_SL0_SHIFT); /* Start L1 */
+		else
+			vtcr |= (1UL << VTCR_EL2_SL0_SHIFT); /* Start L2 */
+		break;
+	}
+
+	return vtcr | ((64 - VA_BITS) & VTCR_EL2_T0SZ_MASK);
+}
+
+struct s2_mmu *s2mmu_init(int vmid, enum s2_granule granule, bool allow_block_mappings)
+{
+	struct s2_mmu *mmu;
+	int order = 0;
+
+	/*
+	 * Only accept limited configurations for now.
+	 */
+	if (vmid < 0 || vmid > S2MMU_MAX_VMID || granule != S2_PAGE_4K)
+		return NULL;
+
+	mmu = calloc(1, sizeof(*mmu));
+	if (!mmu)
+		return NULL;
+
+	mmu->vmid = vmid;
+	mmu->granule = granule;
+	mmu->allow_block_mappings = allow_block_mappings;
+
+	/* Configure shifts based on granule */
+	switch (granule) {
+	case S2_PAGE_4K:
+		mmu->page_shift = 12;
+		mmu->level_shift = 9;
+		/*
+		 * Determine Root Level for 4K:
+		 * VA_BITS > 39 (e.g. 48) -> Start L0
+		 * VA_BITS <= 39 (e.g. 32, 36) -> Start L1
+		 */
+		mmu->root_level = (VA_BITS > 39) ? 0 : 1;
+		break;
+	case S2_PAGE_16K:
+		mmu->page_shift = 14;
+		mmu->level_shift = 11;
+		/*
+		 * 16K: L1 covers 47 bits. L0 not valid for 16K
+		 * Start L1 for 47 bits. Start L2 for 36 bits.
+		 */
+		mmu->root_level = (VA_BITS > 36) ? 1 : 2;
+		break;
+	case S2_PAGE_64K:
+		mmu->page_shift = 16;
+		mmu->level_shift = 13;
+		/* 64K: L1 covers 52 bits. L2 covers 42 bits. */
+		mmu->root_level = (VA_BITS > 42) ? 1 : 2;
+		break;
+	}
+
+	mmu->page_size = 1UL << mmu->page_shift;
+	mmu->block_size = 1UL << (mmu->page_shift + mmu->level_shift);
+
+	/* Alloc PGD. Use order for allocation size */
+	if (mmu->page_size > PAGE_SIZE) {
+		order = __builtin_ctz(mmu->page_size / PAGE_SIZE);
+	}
+	mmu->pgd = (pgd_t *)alloc_pages(order);
+	if (mmu->pgd) {
+		memset(mmu->pgd, 0, mmu->page_size);
+	} else {
+		free(mmu);
+		return NULL;
+	}
+
+	mmu->vtcr_el2 = s2mmu_build_vtcr(mmu);
+	mmu->vttbr_el2 = (virt_to_phys(mmu->pgd) & VTTBR_EL2_BADDR_MASK) |
+			    (((unsigned long)mmu->vmid << VTTBR_EL2_VMID_SHIFT) &
+			     VTTBR_EL2_VMID_MASK);
+
+	return mmu;
+}
+
+static unsigned long s2mmu_get_addr_mask(struct s2_mmu *mmu)
+{
+	switch (mmu->granule) {
+	case S2_PAGE_16K:
+		return GENMASK_ULL(47, 14);
+	case S2_PAGE_64K:
+		return GENMASK_ULL(47, 16);
+	default:
+		return GENMASK_ULL(47, 12); /* 4K */
+	}
+}
+
+static void s2mmu_tlbi_all(void)
+{
+	/* Publish page-table writes before invalidating cached translations. */
+	dsb(ishst);
+	asm volatile("tlbi vmalls12e1is" : : : "memory");
+	dsb(ish);
+	isb();
+}
+
+static void s2mmu_free_tables(struct s2_mmu *mmu, pte_t *table, int level)
+{
+	unsigned long entries = 1UL << mmu->level_shift;
+	unsigned long mask = s2mmu_get_addr_mask(mmu);
+	unsigned long i;
+
+	/*
+	 * Recurse if not leaf level
+	 * Level 3 is always leaf page. Levels 0-2 can be Table or Block.
+	 */
+	if (level < 3) {
+		for (i = 0; i < entries; i++) {
+			pte_t entry = table[i];
+			if ((pte_valid(entry) && pte_is_table(entry))) {
+				pte_t *next = (pte_t *)phys_to_virt(pte_val(entry) & mask);
+				s2mmu_free_tables(mmu, next, level + 1);
+			}
+		}
+	}
+
+	free_pages(table);
+}
+
+void s2mmu_destroy(struct s2_mmu *mmu)
+{
+	if (mmu->pgd)
+		s2mmu_free_tables(mmu, (pte_t *)mmu->pgd, mmu->root_level);
+	free(mmu);
+}
+
+void s2mmu_load(const struct s2_mmu *mmu)
+{
+	write_sysreg(mmu->vtcr_el2, vtcr_el2);
+	write_sysreg(mmu->vttbr_el2, vttbr_el2);
+	isb();
+	s2mmu_tlbi_all();
+}
+
+static int get_pte(struct s2_mmu *mmu, pte_t *table, unsigned long idx,
+		   pte_t **next_table)
+{
+	unsigned long mask = s2mmu_get_addr_mask(mmu);
+	pte_t entry = table[idx];
+	int order = 0;
+
+	if (pte_valid(entry)) {
+		if (!pte_is_table(entry))
+			return S2MMU_ERR_MAPPING_CONFLICT;
+
+		*next_table = (pte_t *)phys_to_virt(pte_val(entry) & mask);
+		return 0;
+	}
+
+	/* Allocate table memory covering the Stage-2 Granule size */
+	if (mmu->page_size > PAGE_SIZE)
+		order = __builtin_ctz(mmu->page_size / PAGE_SIZE);
+
+	*next_table = (pte_t *)alloc_pages(order);
+	if (!*next_table)
+		return S2MMU_ERR_NOMEM;
+
+	memset(*next_table, 0, mmu->page_size);
+
+	pte_val(entry) = virt_to_phys(*next_table) | PTE_TABLE_BIT | PTE_VALID;
+	WRITE_ONCE(table[idx], entry);
+
+	return 0;
+}
+
+int s2mmu_map(struct s2_mmu *mmu, unsigned long ipa, unsigned long pa,
+	      unsigned long size, unsigned long flags)
+{
+	unsigned long level_mask, level_shift, level_size, level;
+	unsigned long start_ipa, end_ipa, idx;
+	pte_t entry, *table, *next_table;
+	bool is_block_level;
+	int ret;
+
+	start_ipa = ipa;
+	end_ipa = ipa + size;
+	level_mask = (1UL << mmu->level_shift) - 1;
+
+	while (start_ipa < end_ipa) {
+		table = (pte_t *)mmu->pgd;
+
+		/* Walk from Root to Leaf */
+		for (level = mmu->root_level; level < 3; level++) {
+			level_shift = mmu->page_shift + (3 - level) * mmu->level_shift;
+			idx = (start_ipa >> level_shift) & level_mask;
+			level_size = 1UL << level_shift;
+
+			/*
+			 * Check for Block Mapping
+			 * Valid Block Levels:
+			 * 4K:  L1 (1G), L2 (2MB)
+			 * 16K: L2 (32MB)
+			 * 64K: L2 (512MB)
+			 */
+			is_block_level = (level == 2) ||
+				(mmu->granule == S2_PAGE_4K && level == 1);
+
+			if (mmu->allow_block_mappings && is_block_level) {
+				if ((start_ipa & (level_size - 1)) == 0 &&
+				    (pa & (level_size - 1)) == 0 &&
+				    (start_ipa + level_size) <= end_ipa) {
+					/* Map Block */
+					pte_val(entry) = (pa & ~(level_size - 1)) |
+							 flags | PTE_VALID;
+					WRITE_ONCE(table[idx], entry);
+					start_ipa += level_size;
+					pa += level_size;
+					goto next_chunk; /* Continue outer loop */
+				}
+			}
+
+			/* Move to next level */
+			ret = get_pte(mmu, table, idx, &next_table);
+			if (ret)
+				return ret;
+			table = next_table;
+		}
+
+		/* Leaf Level (Level 3 PTE) */
+		if (level == 3) {
+			idx = (start_ipa >> mmu->page_shift) & level_mask;
+			pte_val(entry) = (pa & ~(mmu->page_size - 1)) | flags | PTE_TYPE_PAGE;
+			WRITE_ONCE(table[idx], entry);
+			start_ipa += mmu->page_size;
+			pa += mmu->page_size;
+		}
+
+next_chunk:
+		continue;
+	}
+
+	s2mmu_tlbi_all();
+	return 0;
+}
+
+/*
+ * Recursive helper to unmap a range within a specific table.
+ * Returns true if the table at this level is now completely empty
+ * and should be freed by the caller.
+ */
+static bool s2mmu_unmap_level(struct s2_mmu *mmu, pte_t *table,
+			      unsigned long current_ipa, int level,
+			      unsigned long start_ipa, unsigned long end_ipa,
+			      unsigned long mask)
+{
+	unsigned long level_size, entry_ipa, entry_end;
+	bool child_empty, table_empty = true;
+	pte_t entry, *next_table;
+	unsigned int level_shift;
+	unsigned long i;
+
+	/* Calculate shift and size for this level */
+	if (level == 3) {
+		level_shift = mmu->page_shift;
+	} else {
+		level_shift = mmu->page_shift + (3 - level) * mmu->level_shift;
+	}
+	level_size = 1UL << level_shift;
+
+	/* Iterate over all entries in this table */
+	for (i = 0; i < (1UL << mmu->level_shift); i++) {
+		entry = table[i];
+		entry_ipa = current_ipa + (i * level_size);
+		entry_end = entry_ipa + level_size;
+
+		/* Skip entries completely outside our target range */
+		if (entry_end <= start_ipa || entry_ipa >= end_ipa) {
+			if (pte_valid(entry))
+				table_empty = false;
+			continue;
+		}
+
+		/*
+		 * If the entry is fully covered by the unmap range,
+		 * we can clear it (leaf) or recurse and free (table).
+		 */
+		if (entry_ipa >= start_ipa && entry_end <= end_ipa) {
+			if (pte_valid(entry)) {
+				if (pte_is_table(entry) && level < 3) {
+					/* Recurse to free children first */
+					next_table = (pte_t *)phys_to_virt(pte_val(entry) & mask);
+					s2mmu_free_tables(mmu, next_table, level + 1);
+				}
+				/* Invalidate the entry */
+				WRITE_ONCE(table[i], __pte(0));
+			}
+			continue;
+		}
+
+		/*
+		 * Partial overlap: This must be a table (split required).
+		 * If it's a Block, we can't split easily in this context
+		 * without complex logic, so we generally skip or fail.
+		 * Assuming standard breakdown: recurse into the table.
+		 */
+		if (pte_valid(entry) && pte_is_table(entry) && level < 3) {
+			next_table = (pte_t *)phys_to_virt(pte_val(entry) & mask);
+			child_empty = s2mmu_unmap_level(mmu, next_table, entry_ipa, level + 1,
+							start_ipa, end_ipa, mask);
+
+			if (child_empty) {
+				free_pages(next_table);
+				WRITE_ONCE(table[i], __pte(0));
+			} else {
+				table_empty = false;
+			}
+		} else if (pte_valid(entry)) {
+			/*
+			 * Overlap on a leaf/block entry that extends
+			 * beyond the unmap range. We cannot simply clear it.
+			 */
+			table_empty = false;
+		}
+	}
+
+	return table_empty;
+}
+
+void s2mmu_unmap(struct s2_mmu *mmu, unsigned long ipa, unsigned long size)
+{
+	unsigned long end_ipa = ipa + size;
+	unsigned long mask = s2mmu_get_addr_mask(mmu);
+
+	if (!mmu->pgd)
+		return;
+
+	/*
+	 * Start recursion from the root level.
+	 * We rarely free the PGD itself unless destroying the MMU,
+	 * so we ignore the return value here.
+	 */
+	s2mmu_unmap_level(mmu, (pte_t *)mmu->pgd, 0, mmu->root_level,
+			  ipa, end_ipa, mask);
+
+	s2mmu_tlbi_all();
+}
+
+void s2mmu_print_fault_info(void)
+{
+	unsigned long esr = read_sysreg(esr_el2);
+	unsigned long far = read_sysreg(far_el2);
+	unsigned long hpfar = read_sysreg(hpfar_el2);
+	printf("Stage-2 Fault Info: ESR=0x%lx FAR=0x%lx HPFAR=0x%lx\n", esr, far, hpfar);
+}
-- 
2.43.0

