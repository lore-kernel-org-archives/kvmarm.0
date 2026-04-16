Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A28435F5E4
	for <kvmarm@lists.linux.dev>; Thu, 16 Apr 2026 15:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776352795; cv=none; b=HJYIS6Hgz0Qfrf6M0p5LAB5j7z1KYK2Kh8fLnVyTWspdpsIUxdrPIjL0jg4ika/4KmVKPp7JTSkKLmIfD2N8STkBx0aYssmeOCzmmyuI5br52vLBOdbygtpVj+b3N2+NvOA0VpR6oopTTtfa22CQLsze70wyU+t3em+hBns2N5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776352795; c=relaxed/simple;
	bh=+xOUlJ7WlRqbTw6W9672KhZXgpwcLY5mZOB7Pk/vxec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J2MXG+LBOHxMEW0RjJjpQdkM8kg1u8ntKnm+mlzTF7cm5UMGbbkRQLNxeDDZT/NCDgcqcFqaMziuR4O4xwm+52AxnL9MvBXrwPNUn3rQEKXHa4lMID+m5SxhYGHog0SILOg3877ndWEX/kpYY6dMx5HPdd1dzVeP7Q6ygALGmYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ox1sg/Bn; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ox1sg/Bn"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B55EB2050;
	Thu, 16 Apr 2026 08:19:46 -0700 (PDT)
Received: from e124191.cambridge.arm.com (e124191.cambridge.arm.com [10.1.197.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9499A3F7B4;
	Thu, 16 Apr 2026 08:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776352792; bh=+xOUlJ7WlRqbTw6W9672KhZXgpwcLY5mZOB7Pk/vxec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ox1sg/BntB2EZVmgE3IzBeqmR8YvbTr8CtGgL4PCe5iT57P9OzTlc+IoUpFmjPOyA
	 cNH4yZdffgB0V7j/Ljgb/DT2t2wb1T/E5VmHLIbzUWDndiAtQm0KC7tslxCxTEYEz4
	 T5QS046JULkZWmjOvfkCkEP/0AV7JxqMQgyvj4ZU=
Date: Thu, 16 Apr 2026 16:19:44 +0100
From: Joey Gouly <joey.gouly@arm.com>
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
	Marc Zyngier <maz@kernel.org>, Wei-Lin Chang <weilin.chang@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Andrew Jones <andrew.jones@linux.dev>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mingwei Zhang <mizhang@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Colton Lewis <coltonlewis@google.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/7] lib: arm64: Add stage2 page table
 management library
Message-ID: <20260416151944.GA3142999@e124191.cambridge.arm.com>
References: <20260413204630.1149038-1-jingzhangos@google.com>
 <20260413204630.1149038-3-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413204630.1149038-3-jingzhangos@google.com>

Hi Jing,

On Mon, Apr 13, 2026 at 01:46:25PM -0700, Jing Zhang wrote:
> Tests running at EL2 (hypervisor level) often require the ability to
> manage Stage 2 translation tables to control Guest Physical Address (IPA)
> to Host Physical Address (PA) translation.
> 
> Add a generic Stage 2 MMU library that provides software management of
> ARM64 Stage 2 translation tables.
> 
> The library features include:
> - Support for 4K, 16K, and 64K translation granules.
> - Dynamic page table allocation using the allocator.
> - Support for 2M block mappings where applicable.
> - APIs for mapping, unmapping, enabling, and disabling the Stage 2 MMU.
> - Basic fault info reporting (ESR, FAR, HPFAR).
> 
> This infrastructure is necessary for upcoming virtualization and
> hypervisor-mode tests.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arm/Makefile.arm64         |   1 +
>  lib/arm64/asm/stage2_mmu.h |  70 +++++++
>  lib/arm64/stage2_mmu.c     | 403 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 474 insertions(+)
>  create mode 100644 lib/arm64/asm/stage2_mmu.h
>  create mode 100644 lib/arm64/stage2_mmu.c
> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index a40c830d..5e50f5ba 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -40,6 +40,7 @@ cflatobjs += lib/arm64/stack.o
>  cflatobjs += lib/arm64/processor.o
>  cflatobjs += lib/arm64/spinlock.o
>  cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
> +cflatobjs += lib/arm64/stage2_mmu.o
>  
>  ifeq ($(CONFIG_EFI),y)
>  cflatobjs += lib/acpi.o
> diff --git a/lib/arm64/asm/stage2_mmu.h b/lib/arm64/asm/stage2_mmu.h
> new file mode 100644
> index 00000000..a5324108
> --- /dev/null
> +++ b/lib/arm64/asm/stage2_mmu.h
> @@ -0,0 +1,70 @@
> +/*
> + * Copyright (C) 2026, Google LLC.
> + * Author: Jing Zhang <jingzhangos@google.com>
> + *
> + * SPDX-License-Identifier: LGPL-2.0-or-later
> + */
> +#ifndef _ASMARM64_STAGE2_MMU_H_
> +#define _ASMARM64_STAGE2_MMU_H_
> +
> +#include <libcflat.h>
> +#include <asm/page.h>
> +#include <asm/pgtable.h>
> +
> +#define pte_is_table(pte)	(pte_val(pte) & PTE_TABLE_BIT)

This can go in lib/arm64/asm/pgtable.h.

> +
> +/* Stage-2 Memory Attributes (MemAttr[3:0]) */
> +#define S2_MEMATTR_NORMAL	(0xFUL << 2) /* Normal Memory, Outer/Inner Write-Back */
> +#define S2_MEMATTR_DEVICE	(0x0UL << 2) /* Device-nGnRnE */
> +
> +/* Stage-2 Access Permissions (S2AP[1:0]) */
> +#define S2AP_NONE	(0UL << 6)
> +#define S2AP_RO		(1UL << 6) /* Read-only */
> +#define S2AP_WO		(2UL << 6) /* Write-only */
> +#define S2AP_RW		(3UL << 6) /* Read-Write */

Do we need S2AP_NONE, it's just 0? Maybe S2AP_MASK would be useful for
something (which would be same as S2AP_RW)

Could you do:

#define S2AP_RO		BIT(6) /* Read-only */
#define S2AP_WO		BIT(7) /* Write-only */
#define S2AP_RW		S2AP_RO | S2AP_WO /* Read-Write */

Maybe even drop the comments, I think the suffixes are understandable.

> +
> +/* Flags for mapping */
> +#define S2_MAP_RW	(S2AP_RW | S2_MEMATTR_NORMAL | PTE_AF | PTE_SHARED)
> +#define S2_MAP_DEVICE	(S2AP_RW | S2_MEMATTR_DEVICE | PTE_AF)
> +
> +enum s2_granule {
> +	S2_PAGE_4K,
> +	S2_PAGE_16K,
> +	S2_PAGE_64K,
> +};
> +
> +/* Main Stage-2 MMU Structure */
> +struct s2_mmu {
> +	pgd_t *pgd;
> +	int vmid;
> +
> +	/* Configuration */
> +	enum s2_granule granule;
> +	bool allow_block_mappings;
> +
> +	/* Internal helpers calculated from granule & VA_BITS */
> +	unsigned int page_shift;
> +	unsigned int level_shift;
> +	int root_level; /* 0, 1, or 2 */
> +	unsigned long page_size;
> +	unsigned long block_size;
> +};
> +
> +/* API */
> +/* Initialize an s2_mmu struct with specific settings */
> +struct s2_mmu *s2mmu_init(int vmid, enum s2_granule granule, bool allow_block_mappings);
> +
> +/* Management */
> +void s2mmu_destroy(struct s2_mmu *mmu);
> +void s2mmu_map(struct s2_mmu *mmu, unsigned long ipa, unsigned long pa,
> +	       unsigned long size, unsigned long flags);
> +void s2mmu_unmap(struct s2_mmu *mmu, unsigned long ipa, unsigned long size);
> +
> +/* Activation */
> +void s2mmu_enable(struct s2_mmu *mmu);
> +void s2mmu_disable(struct s2_mmu *mmu);
> +
> +/* Debug */
> +void s2mmu_print_fault_info(void);
> +
> +#endif /* _ASMARM64_STAGE2_MMU_H_ */
> diff --git a/lib/arm64/stage2_mmu.c b/lib/arm64/stage2_mmu.c
> new file mode 100644
> index 00000000..cf419e28
> --- /dev/null
> +++ b/lib/arm64/stage2_mmu.c
> @@ -0,0 +1,403 @@
> +/*
> + * Copyright (C) 2026, Google LLC.
> + * Author: Jing Zhang <jingzhangos@google.com>
> + *
> + * SPDX-License-Identifier: LGPL-2.0-or-later
> + */
> +#include <libcflat.h>
> +#include <alloc.h>
> +#include <asm/stage2_mmu.h>
> +#include <asm/sysreg.h>
> +#include <asm/io.h>
> +#include <asm/barrier.h>
> +#include <alloc_page.h>
> +
> +/* VTCR_EL2 Definitions */
> +#define VTCR_SH0_INNER		(3UL << 12)
> +#define VTCR_ORGN0_WBWA		(1UL << 10)
> +#define VTCR_IRGN0_WBWA		(1UL << 8)
> +
> +/* TG0 Encodings */
> +#define VTCR_TG0_SHIFT		14
> +#define VTCR_TG0_4K		(0UL << VTCR_TG0_SHIFT)
> +#define VTCR_TG0_64K		(1UL << VTCR_TG0_SHIFT)
> +#define VTCR_TG0_16K		(2UL << VTCR_TG0_SHIFT)
> +
> +/* Physical Address Size (PS) - Derive from VA_BITS for simplicity or max */
> +#define VTCR_PS_SHIFT		16
> +#if VA_BITS > 40
> +#define VTCR_PS_VAL		(5UL << VTCR_PS_SHIFT) /* 48-bit PA */
> +#else
> +#define VTCR_PS_VAL		(2UL << VTCR_PS_SHIFT) /* 40-bit PA */
> +#endif

These definitions could go in headers?

> +
> +struct s2_mmu *s2mmu_init(int vmid, enum s2_granule granule, bool allow_block_mappings)
> +{
> +	struct s2_mmu *mmu = calloc(1, sizeof(struct s2_mmu));
> +	int order = 0;
> +
> +	mmu->vmid = vmid;
> +	mmu->granule = granule;
> +	mmu->allow_block_mappings = allow_block_mappings;
> +
> +	/* Configure shifts based on granule */
> +	switch (granule) {
> +	case S2_PAGE_4K:
> +		mmu->page_shift = 12;
> +		mmu->level_shift = 9;
> +		/*
> +		 * Determine Root Level for 4K:
> +		 * VA_BITS > 39 (e.g. 48) -> Start L0
> +		 * VA_BITS <= 39 (e.g. 32, 36) -> Start L1
> +		 */
> +		mmu->root_level = (VA_BITS > 39) ? 0 : 1;
> +		break;
> +	case S2_PAGE_16K:
> +		mmu->page_shift = 14;
> +		mmu->level_shift = 11;
> +		/*
> +		 * 16K: L1 covers 47 bits. L0 not valid for 16K
> +		 * Start L1 for 47 bits. Start L2 for 36 bits.
> +		 */
> +		mmu->root_level = (VA_BITS > 36) ? 1 : 2;
> +		break;
> +	case S2_PAGE_64K:
> +		mmu->page_shift = 16;
> +		mmu->level_shift = 13;
> +		/* 64K: L1 covers 52 bits. L2 covers 42 bits. */
> +		mmu->root_level = (VA_BITS > 42) ? 1 : 2;
> +		break;
> +	}
> +
> +	mmu->page_size = 1UL << mmu->page_shift;
> +	mmu->block_size = 1UL << (mmu->page_shift + mmu->level_shift);
> +
> +	/* Alloc PGD. Use order for allocation size */
> +	if (mmu->page_size > PAGE_SIZE) {
> +		order = __builtin_ctz(mmu->page_size / PAGE_SIZE);
> +	}
> +	mmu->pgd = (pgd_t *)alloc_pages(order);
> +	if (mmu->pgd) {
> +		memset(mmu->pgd, 0, mmu->page_size);
> +	} else {
> +		free(mmu);
> +		return NULL;
> +	}
> +
> +	return mmu;
> +}
> +
> +static unsigned long s2mmu_get_addr_mask(struct s2_mmu *mmu)
> +{
> +	switch (mmu->granule) {
> +	case S2_PAGE_16K:
> +		return GENMASK_ULL(47, 14);
> +	case S2_PAGE_64K:
> +		return GENMASK_ULL(47, 16);
> +	default:
> +		return GENMASK_ULL(47, 12); /* 4K */
> +	}
> +}
> +
> +static void s2mmu_free_tables(struct s2_mmu *mmu, pte_t *table, int level)
> +{
> +	unsigned long entries = 1UL << mmu->level_shift;
> +	unsigned long mask = s2mmu_get_addr_mask(mmu);
> +	unsigned long i;
> +
> +	/*
> +	 * Recurse if not leaf level
> +	 * Level 3 is always leaf page. Levels 0-2 can be Table or Block.
> +	 */
> +	if (level < 3) {
> +		for (i = 0; i < entries; i++) {
> +			pte_t entry = table[i];
> +			if ((pte_valid(entry) && pte_is_table(entry))) {
> +				pte_t *next = (pte_t *)phys_to_virt(pte_val(entry) & mask);
> +				s2mmu_free_tables(mmu, next, level + 1);
> +			}
> +		}
> +	}
> +
> +	free_pages(table);
> +}
> +
> +void s2mmu_destroy(struct s2_mmu *mmu)
> +{
> +	if (mmu->pgd)
> +		s2mmu_free_tables(mmu, (pte_t *)mmu->pgd, mmu->root_level);
> +	free(mmu);
> +}
> +
> +void s2mmu_enable(struct s2_mmu *mmu)
> +{
> +	unsigned long vtcr = VTCR_PS_VAL | VTCR_SH0_INNER |
> +			     VTCR_ORGN0_WBWA | VTCR_IRGN0_WBWA;
> +	unsigned long t0sz = 64 - VA_BITS;
> +	unsigned long vttbr;
> +
> +	switch (mmu->granule) {
> +	case S2_PAGE_4K:
> +		vtcr |= VTCR_TG0_4K;
> +		/* SL0 Encodings for 4K: 0=L2, 1=L1, 2=L0 */
> +		if (mmu->root_level == 0)
> +			vtcr |= (2UL << 6); /* Start L0 */
> +		else if (mmu->root_level == 1)
> +			vtcr |= (1UL << 6); /* Start L1 */
> +		else
> +			vtcr |= (0UL << 6); /* Start L2 */
> +		break;
> +	case S2_PAGE_16K:
> +		vtcr |= VTCR_TG0_16K;
> +		/* SL0 Encodings for 16K: 0=L3(Res), 1=L2, 2=L1, 3=L0(Res) */
> +		if (mmu->root_level == 1)
> +			vtcr |= (2UL << 6); /* Start L1 */
> +		else
> +			vtcr |= (1UL << 6); /* Start L2 */
> +		break;
> +	case S2_PAGE_64K:
> +		vtcr |= VTCR_TG0_64K;
> +		/* SL0 Encodings for 64K: 0=L3(Res), 1=L2, 2=L1, 3=L0(Res) */
> +		if (mmu->root_level == 1)
> +			vtcr |= (2UL << 6); /* Start L1 */
> +		else
> +			vtcr |= (1UL << 6); /* Start L2 */
> +		break;
> +	}

This could use a VTCR_EL2_SL0_SHIFT to remove the hardcoded 6.

> +
> +	vtcr |= t0sz;
> +
> +	write_sysreg(vtcr, vtcr_el2);
> +
> +	/* Setup VTTBR */
> +	vttbr = virt_to_phys(mmu->pgd);
> +	vttbr |= ((unsigned long)mmu->vmid << 48);

VTTBR_VMID_SHIFT instead of the bare 48.

> +	write_sysreg(vttbr, vttbr_el2);
> +
> +	asm volatile("tlbi vmalls12e1is");
> +
> +	dsb(ish);
> +	isb();
> +}
> +
> +void s2mmu_disable(struct s2_mmu *mmu)
> +{
> +	write_sysreg(0, vttbr_el2);
> +	isb();
> +}
> +
> +static pte_t *get_pte(struct s2_mmu *mmu, pte_t *table, unsigned long idx, bool alloc)
> +{
> +	unsigned long mask = s2mmu_get_addr_mask(mmu);
> +	pte_t entry = table[idx];
> +	pte_t *next_table;
> +	int order = 0;
> +
> +	if (pte_valid(entry)) {
> +		if (pte_is_table(entry))
> +			return (pte_t *)phys_to_virt(pte_val(entry) & mask);
> +		/* Block Entry */
> +		return NULL;
> +	}
> +
> +	if (!alloc)
> +		return NULL;
> +
> +	/* Allocate table memory covering the Stage-2 Granule size */
> +	if (mmu->page_size > PAGE_SIZE)
> +		order = __builtin_ctz(mmu->page_size / PAGE_SIZE);
> +
> +	next_table = (pte_t *)alloc_pages(order);
> +	if (next_table)
> +		memset(next_table, 0, mmu->page_size);
> +
> +	pte_val(entry) = virt_to_phys(next_table) | PTE_TABLE_BIT | PTE_VALID;
> +	WRITE_ONCE(table[idx], entry);

Should these two lines be inside `if (next_table)`?

> +
> +	return next_table;
> +}
> +
> +void s2mmu_map(struct s2_mmu *mmu, unsigned long ipa, unsigned long pa,
> +	       unsigned long size, unsigned long flags)
> +{
> +	unsigned long level_mask, level_shift, level_size, level;
> +	unsigned long start_ipa, end_ipa, idx;
> +	pte_t entry, *table, *next_table;
> +	bool is_block_level;
> +
> +	start_ipa = ipa;
> +	end_ipa = ipa + size;
> +	level_mask = (1UL << mmu->level_shift) - 1;
> +
> +	while (start_ipa < end_ipa) {
> +		table = (pte_t *)mmu->pgd;
> +
> +		/* Walk from Root to Leaf */
> +		for (level = mmu->root_level; level < 3; level++) {
> +			level_shift = mmu->page_shift + (3 - level) * mmu->level_shift;
> +			idx = (start_ipa >> level_shift) & level_mask;
> +			level_size = 1UL << level_shift;
> +
> +			/*
> +			 * Check for Block Mapping
> +			 * Valid Block Levels:
> +			 * 4K:  L1 (1G), L2 (2MB)
> +			 * 16K: L2 (32MB)
> +			 * 64K: L2 (512MB)
> +			 */
> +			is_block_level = (level == 2) ||
> +				(mmu->granule == S2_PAGE_4K && level == 1);
> +
> +			if (mmu->allow_block_mappings && is_block_level) {
> +				if ((start_ipa & (level_size - 1)) == 0 &&
> +				    (pa & (level_size - 1)) == 0 &&
> +				    (start_ipa + level_size) <= end_ipa) {
> +					/* Map Block */
> +					pte_val(entry) = (pa & ~(level_size - 1)) |
> +							 flags | PTE_VALID;
> +					WRITE_ONCE(table[idx], entry);

Should this check if there's some mapping here already?

If the table[idx] is an invalid pte, we can overwrite it.
If `table[idx] == entry`, do nothing.
If `table[idx] != entry` I think we can assert. Could add Break-Before-Make
handling, but I think it makes sense to keep it simple for now.

What do you think?

> +					start_ipa += level_size;
> +					pa += level_size;
> +					goto next_chunk; /* Continue outer loop */
> +				}
> +			}
> +
> +			/* Move to next level */
> +			next_table = get_pte(mmu, table, idx, true);
> +			if (!next_table) {
> +				printf("Error allocating or existing block conflict.\n");
> +				return;
> +			}
> +			table = next_table;
> +		}
> +
> +		/* Leaf Level (Level 3 PTE) */
> +		if (level == 3) {
> +			idx = (start_ipa >> mmu->page_shift) & level_mask;
> +			pte_val(entry) = (pa & ~(mmu->page_size - 1)) | flags | PTE_TYPE_PAGE;
> +			WRITE_ONCE(table[idx], entry);

Same comment as above.

> +			start_ipa += mmu->page_size;
> +			pa += mmu->page_size;
> +		}
> +
> +next_chunk:
> +		continue;
> +	}
> +
> +	asm volatile("tlbi vmalls12e1is");

This invalidates the current vmid, which might not be the vmid of `mmu` (see
enter_vmid_context() in Linux for example).

s2mmu_enable() is what sets vmid, but there are some calls to s2mmu_map()
before that. Either map/unmap could save/restore vmid, or maybe could assert
the current vmid is equal to `mmu`s vmid?

> +	dsb(ish);
> +	isb();
> +}
> +
> +/*
> + * Recursive helper to unmap a range within a specific table.
> + * Returns true if the table at this level is now completely empty
> + * and should be freed by the caller.
> + */
> +static bool s2mmu_unmap_level(struct s2_mmu *mmu, pte_t *table,
> +			      unsigned long current_ipa, int level,
> +			      unsigned long start_ipa, unsigned long end_ipa,
> +			      unsigned long mask)
> +{
> +	unsigned long level_size, entry_ipa, entry_end;
> +	bool child_empty, table_empty = true;
> +	pte_t entry, *next_table;
> +	unsigned int level_shift;
> +	unsigned long i;
> +
> +	/* Calculate shift and size for this level */
> +	if (level == 3) {
> +		level_shift = mmu->page_shift;
> +	} else {
> +		level_shift = mmu->page_shift + (3 - level) * mmu->level_shift;
> +	}

We don't really need the conditional since if level was 3, this subtraction is
0, but either way is fine to me.

> +	level_size = 1UL << level_shift;
> +
> +	/* Iterate over all entries in this table */
> +	for (i = 0; i < (1UL << mmu->level_shift); i++) {
> +		entry = table[i];
> +		entry_ipa = current_ipa + (i * level_size);
> +		entry_end = entry_ipa + level_size;
> +
> +		/* Skip entries completely outside our target range */
> +		if (entry_end <= start_ipa || entry_ipa >= end_ipa) {
> +			if (pte_valid(entry))
> +				table_empty = false;
> +			continue;
> +		}
> +
> +		/*
> +		 * If the entry is fully covered by the unmap range,
> +		 * we can clear it (leaf) or recurse and free (table).
> +		 */
> +		if (entry_ipa >= start_ipa && entry_end <= end_ipa) {
> +			if (pte_valid(entry)) {
> +				if (pte_is_table(entry) && level < 3) {
> +					/* Recurse to free children first */
> +					next_table = (pte_t *)phys_to_virt(pte_val(entry) & mask);
> +					s2mmu_free_tables(mmu, next_table, level + 1);
> +				}
> +				/* Invalidate the entry */
> +				WRITE_ONCE(table[i], __pte(0));
> +			}
> +			continue;
> +		}
> +
> +		/*
> +		 * Partial overlap: This must be a table (split required).
> +		 * If it's a Block, we can't split easily in this context
> +		 * without complex logic, so we generally skip or fail.
> +		 * Assuming standard breakdown: recurse into the table.
> +		 */
> +		if (pte_valid(entry) && pte_is_table(entry) && level < 3) {
> +			next_table = (pte_t *)phys_to_virt(pte_val(entry) & mask);
> +			child_empty = s2mmu_unmap_level(mmu, next_table, entry_ipa, level + 1,
> +							start_ipa, end_ipa, mask);
> +
> +			if (child_empty) {
> +				free_pages(next_table);
> +				WRITE_ONCE(table[i], __pte(0));
> +			} else {
> +				table_empty = false;
> +			}
> +		} else if (pte_valid(entry)) {
> +			/*
> +			 * Overlap on a leaf/block entry that extends
> +			 * beyond the unmap range. We cannot simply clear it.

Can we overlap a leaf here, or is it definitely a block? I'm just wondering if
it makes sense to assert() here? Since we're in full control of the code.

> +			 */
> +			table_empty = false;
> +		}
> +	}
> +
> +	return table_empty;
> +}
> +
> +void s2mmu_unmap(struct s2_mmu *mmu, unsigned long ipa, unsigned long size)
> +{
> +	unsigned long end_ipa = ipa + size;
> +	unsigned long mask = s2mmu_get_addr_mask(mmu);
> +
> +	if (!mmu->pgd)
> +		return;
> +
> +	/*
> +	 * Start recursion from the root level.
> +	 * We rarely free the PGD itself unless destroying the MMU,
> +	 * so we ignore the return value here.
> +	 */
> +	s2mmu_unmap_level(mmu, (pte_t *)mmu->pgd, 0, mmu->root_level,
> +			  ipa, end_ipa, mask);
> +
> +	/* Ensure TLB invalidation occurs after page table updates */
> +	asm volatile("tlbi vmalls12e1is");

Same as other comment earlier about vmid.

> +	dsb(ish);
> +	isb();
> +}
> +
> +void s2mmu_print_fault_info(void)
> +{
> +	unsigned long esr = read_sysreg(esr_el2);
> +	unsigned long far = read_sysreg(far_el2);
> +	unsigned long hpfar = read_sysreg(hpfar_el2);
> +	printf("Stage-2 Fault Info: ESR=0x%lx FAR=0x%lx HPFAR=0x%lx\n", esr, far, hpfar);
> +}

Thanks,
Joey
