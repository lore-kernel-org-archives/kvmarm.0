Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06D7377EA1
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 22:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773701050; cv=none; b=jVVRPgAGGdgNqEiQHr99S7eoJwRFvRtPvRUR0JUHO9cRuYmKgjgEpiu3XPgkjEo7mn33KbjpI6pRsxt+Hn9EcUwDC0dL8HlAvcFAte7Ce39u5iZJ6xtQ+qyfy2uQTmDWks6L9q66fDaY84IyVzdpll8xq9MwPvH26ej5DfleprM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773701050; c=relaxed/simple;
	bh=REhfTjhDYB+NU2kipg4FjUlvNXfF+jPJ1kz4U4esLbI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hGuxXKy5pdUPQiTxfqG/gHo6sb8XRQKWq0cQdobXPZxjBRh7hwOkCBlqsq/RAAvDKqIgX0N9GiTv+DJQycb8xydciFoensJldfDytLvVcYJNAByTwr/KVHu4cKtVhWIOdaQ6l/TrWkrNxaPwRsmb7gkGCJZ+iLb6cAUbh2WaQUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qxySpVhk; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qxySpVhk"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-829a535ad50so2528270b3a.2
        for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 15:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773701048; x=1774305848; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zbs6baHZM/VcGOty/zicaWf9CNhUnoAyJ6TAs0Ok+Kc=;
        b=qxySpVhkUFvnwiKCF1L4llJqMZ0YhNzXJR2rFKIVtfgrIEdtjQm/DzWWdvwAes1K2O
         DGvMxjgfq0rybof6oQK+wPCWW/rrtaO/AeMYqNQpNqNzwqxPr5eoN1ZPKI+IoPtVrPPM
         CyCUwK+fEXvtwvphu22PnZDoYaSgzikXDi508PCzAuFnPm4df4NvHrNhttSFZSCcZYnP
         feKcqa9XJuEuzd7TsHnII4kAp688/U/4LO3HvluXpGPwysQbeCjA8so1oPVZ91vWwLCw
         UDEgRTrQuxMafcipiYY5TVV8F+4N40kFPIn6U5QBraGVY5JI8JM/WO1abR0RIGGOG8fZ
         5zoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773701048; x=1774305848;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zbs6baHZM/VcGOty/zicaWf9CNhUnoAyJ6TAs0Ok+Kc=;
        b=OsEfpoR+pthvA3hvT3jQWX6SNHA3MKpl3kdYvFSpVaPEV2rncFWrKw0bOHhmGu9hEU
         8RlALyBW88L3u/eb00UGs+tYu+hUMGTrOgO/SBjFe3BTcleRwFn/d8hMKKdl5Tp1cKr6
         JVE1Zs7XjTwahEBmXjCTAjyMpZrsc2QX3fcSerNNHe78JSQ+RPzP0aex9qh2Kjx7ehyA
         rWucI75z/6zS4z7MZ1x9s1rLIOvfcrtpoZKXgHWiGYUIgoFbkJ3OeATPW70li6JACG9R
         u+VjPn0k7Na21DtiUbKpB8CX1Y/bv47azd2IaVxlr2aErBIH1uX+uR1GQkUGNRm34S7u
         XYGA==
X-Forwarded-Encrypted: i=1; AJvYcCWwNkeDujZ9ibvyVm1MrzCtbjG7g4vo8zokBX4jgbIsi9LEPUfdoDQ8eLndZtxBcIVjKsOAavk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzfLfJdCkLifs4VhMRNZoqHcarrZrPRYSoP2oQe/XHZP/xIe4vI
	GEqWAYu/ZBGKyIUDZQAyLNq+fZ04ibhULUYqxJnqlPjspGA/PrB/WWRhDuxFiOt5t/uziQbJRc/
	5tFqlkRzy/qMBDfxDQXSDNWMpyA==
X-Received: from pfie21.prod.google.com ([2002:a62:ee15:0:b0:824:b397:47e6])
 (user=jingzhangos job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2e02:b0:829:7087:7e79 with SMTP id d2e1a72fcca58-82a198cd93dmr13108580b3a.30.1773701047787;
 Mon, 16 Mar 2026 15:44:07 -0700 (PDT)
Date: Mon, 16 Mar 2026 15:43:47 -0700
In-Reply-To: <20260316224349.2360482-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260316224349.2360482-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260316224349.2360482-2-jingzhangos@google.com>
Subject: [kvm-unit-tests PATCH v1 1/3] lib: arm64: Add stage2 page table
 management library
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Andrew Jones <andrew.jones@linux.dev>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Tests running at EL2 (hypervisor level) often require the ability to
manage Stage 2 translation tables to control Guest Physical Address (IPA)
to Host Physical Address (PA) translation.

Add a generic Stage 2 MMU library that provides software management of
ARM64 Stage 2 translation tables.

The library features include:
- Support for 4K, 16K, and 64K translation granules.
- Dynamic page table allocation using the allocator.
- Support for 2M block mappings where applicable.
- APIs for mapping, unmapping, enabling, and disabling the Stage 2 MMU.
- Basic fault info reporting (ESR, FAR, HPFAR).

This infrastructure is necessary for upcoming virtualization and
hypervisor-mode tests.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arm/Makefile.arm64         |   1 +
 lib/arm64/asm/stage2_mmu.h |  74 +++++++
 lib/arm64/stage2_mmu.c     | 402 +++++++++++++++++++++++++++++++++++++
 3 files changed, 477 insertions(+)
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
index 00000000..c9e931a8
--- /dev/null
+++ b/lib/arm64/asm/stage2_mmu.h
@@ -0,0 +1,74 @@
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
+#define ESR_ELx_EC_SHIFT	(26)
+#define ESR_ELx_EC_HVC64	UL(0x16)
+#define ESR_ELx_EC_DABT_LOW	UL(0x24)
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
+/* Main Stage-2 MMU Structure */
+struct s2_mmu {
+	pgd_t *pgd;
+	int vmid;
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
+void s2mmu_map(struct s2_mmu *mmu, unsigned long ipa, unsigned long pa,
+	       unsigned long size, unsigned long flags);
+void s2mmu_unmap(struct s2_mmu *mmu, unsigned long ipa, unsigned long size);
+
+/* Activation */
+void s2mmu_enable(struct s2_mmu *mmu);
+void s2mmu_disable(struct s2_mmu *mmu);
+
+/* Debug */
+void s2mmu_print_fault_info(void);
+
+#endif /* _ASMARM64_STAGE2_MMU_H_ */
diff --git a/lib/arm64/stage2_mmu.c b/lib/arm64/stage2_mmu.c
new file mode 100644
index 00000000..bfe87eac
--- /dev/null
+++ b/lib/arm64/stage2_mmu.c
@@ -0,0 +1,402 @@
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
+/* VTCR_EL2 Definitions */
+#define VTCR_SH0_INNER		(3UL << 12)
+#define VTCR_ORGN0_WBWA		(1UL << 10)
+#define VTCR_IRGN0_WBWA		(1UL << 8)
+
+/* TG0 Encodings */
+#define VTCR_TG0_4K		(0UL << 14)
+#define VTCR_TG0_64K		(1UL << 14)
+#define VTCR_TG0_16K		(2UL << 14)
+
+/* Physical Address Size (PS) - Derive from VA_BITS for simplicity or max */
+#if VA_BITS > 40
+#define VTCR_PS_VAL		(5UL << 16) /* 48-bit PA */
+#else
+#define VTCR_PS_VAL		(2UL << 16) /* 40-bit PA */
+#endif
+
+struct s2_mmu *s2mmu_init(int vmid, enum s2_granule granule, bool allow_block_mappings)
+{
+	struct s2_mmu *mmu = calloc(1, sizeof(struct s2_mmu));
+	int order = 0;
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
+void s2mmu_enable(struct s2_mmu *mmu)
+{
+	unsigned long vtcr = VTCR_PS_VAL | VTCR_SH0_INNER |
+			     VTCR_ORGN0_WBWA | VTCR_IRGN0_WBWA;
+	unsigned long t0sz = 64 - VA_BITS;
+	unsigned long vttbr;
+
+	switch (mmu->granule) {
+	case S2_PAGE_4K:
+		vtcr |= VTCR_TG0_4K;
+		/* SL0 Encodings for 4K: 0=L2, 1=L1, 2=L0 */
+		if (mmu->root_level == 0)
+			vtcr |= (2UL << 6); /* Start L0 */
+		else if (mmu->root_level == 1)
+			vtcr |= (1UL << 6); /* Start L1 */
+		else
+			vtcr |= (0UL << 6); /* Start L2 */
+		break;
+	case S2_PAGE_16K:
+		vtcr |= VTCR_TG0_16K;
+		/* SL0 Encodings for 16K: 0=L3(Res), 1=L2, 2=L1, 3=L0(Res) */
+		if (mmu->root_level == 1)
+			vtcr |= (2UL << 6); /* Start L1 */
+		else
+			vtcr |= (1UL << 6); /* Start L2 */
+		break;
+	case S2_PAGE_64K:
+		vtcr |= VTCR_TG0_64K;
+		/* SL0 Encodings for 64K: 0=L3(Res), 1=L2, 2=L1, 3=L0(Res) */
+		if (mmu->root_level == 1)
+			vtcr |= (2UL << 6); /* Start L1 */
+		else
+			vtcr |= (1UL << 6); /* Start L2 */
+		break;
+	}
+
+	vtcr |= t0sz;
+
+	write_sysreg(vtcr, vtcr_el2);
+	isb();
+
+	/* Setup VTTBR */
+	vttbr = virt_to_phys(mmu->pgd);
+	vttbr |= ((unsigned long)mmu->vmid << 48);
+	write_sysreg(vttbr, vttbr_el2);
+	isb();
+
+	asm volatile("tlbi vmalls12e1is");
+	dsb(ish);
+	isb();
+}
+
+void s2mmu_disable(struct s2_mmu *mmu)
+{
+	write_sysreg(0, vttbr_el2);
+	isb();
+}
+
+static pte_t *get_pte(struct s2_mmu *mmu, pte_t *table, unsigned long idx, bool alloc)
+{
+	unsigned long mask = s2mmu_get_addr_mask(mmu);
+	pte_t entry = table[idx];
+	pte_t *next_table;
+	int order = 0;
+
+	if (pte_valid(entry)) {
+		if (pte_is_table(entry))
+			return (pte_t *)phys_to_virt(pte_val(entry) & mask);
+		/* Block Entry */
+		return NULL;
+	}
+
+	if (!alloc)
+		return NULL;
+
+	/* Allocate table memory covering the Stage-2 Granule size */
+	if (mmu->page_size > PAGE_SIZE)
+		order = __builtin_ctz(mmu->page_size / PAGE_SIZE);
+
+	next_table = (pte_t *)alloc_pages(order);
+	if (next_table)
+		memset(next_table, 0, mmu->page_size);
+
+	pte_val(entry) = virt_to_phys(next_table) | PTE_TABLE_BIT | PTE_VALID;
+	WRITE_ONCE(table[idx], entry);
+
+	return next_table;
+}
+
+void s2mmu_map(struct s2_mmu *mmu, unsigned long ipa, unsigned long pa,
+	       unsigned long size, unsigned long flags)
+{
+	unsigned long level_mask, level_shift, level_size, level;
+	unsigned long start_ipa, end_ipa, idx;
+	pte_t entry, *table, *next_table;
+	bool is_block_level;
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
+			next_table = get_pte(mmu, table, idx, true);
+			if (!next_table) {
+				printf("Error allocating or existing block conflict.\n");
+				return;
+			}
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
+	asm volatile("tlbi vmalls12e1is");
+	dsb(ish);
+	isb();
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
+	/* Ensure TLB invalidation occurs after page table updates */
+	asm volatile("tlbi vmalls12e1is");
+	dsb(ish);
+	isb();
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
2.53.0.851.ga537e3e6e9-goog

