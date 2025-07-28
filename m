Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E8A9275B05
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725221; cv=none; b=Or5S1Ac7FpwOTVmgxTXet0hEJalfjdaJqW+RAVi0Tx6LwgvTVve6bk5GCH/uRCnkFMJ3jF7KoMJ+jrpU+PLy+lA9q+AVKOOsxHsOmXirZQo+sb0pN6wHUZxyx73C0WE1Z/4aGIla5i7ylNGzijPN0uu08RtUdjB9Psowf9Kzvis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725221; c=relaxed/simple;
	bh=Y4CvGwXIUY4Ev31+HRlJ0cFhrxnF16Nv9z49kYxvKRk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AEx+scdHZvB0XXbBspTu7pu55d219vCsUp2UAfiWSvJ6ycq8H2Pj3e2K9Np3rs44VFvRn4aduqYAh8ux2sjoguXAHTe34an4WfUAZ/rinMtRYYNsIkCvAbj+IE2TEyCDbYW2HkKmnoYYMvdpjfT+sELF1T79RiUfVPYegccf6gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FFYtxenj; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FFYtxenj"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3a50049f8eeso1835543f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 10:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725214; x=1754330014; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I4H8DnBJi9dhZ/Q96dim+DD16hhTTr9CGyrhuncW8bw=;
        b=FFYtxenjr9L+kqXBejpZRBoe4KtDiiWMZZBu4Jzw3U8I8D1ieIGPFdBRayU3bJDXFa
         wm86GuFFi5MGWU6jxJePSuYZYQHBQj182dlYyiTB/4AlKm4msF1EW2r9Hv6B87LkXGNO
         7zwscgJkdUNddR4aXLpo7G0+euZhAJdeIx+9paL5g/ZykOD6pmETtrxdCMjHBCK35P2S
         t5p+WFPWEjeMYle+6lnPtMVzUw5hPJ3U6LZpL4bKldJisenuCQBXyxkKvCVUTjwtKJu1
         aTT+6xL/popca8TcpBmZGFi1rbghETodkxuubrvvcR8lf5d2CTenwv1PexAvf1SKcLvH
         yQ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725214; x=1754330014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I4H8DnBJi9dhZ/Q96dim+DD16hhTTr9CGyrhuncW8bw=;
        b=kFJzH2usR/0msu0iwNPfkMMMiIinJ6XjqQuoniCHklGyOGrNkOCI111fU7RK2aurE3
         YBIi8mmr8gZEGocA1jZDaWXLYtLn2OteMs8w6UCdUeV3bxlKdD7KXiGvMSS6qIWYIWAx
         Y0ugHsvoKcpYkWxQEr0aj8MdiHFV2ATHX8puoqUuUrEC+w6mB8FaVJnBn+856t9aGcV5
         7IY3W/a+/eoO46x3p5f44/8owFIhx/9X4HyfOtA6zUVrd/js07WvRxwV+soHknBvPWR6
         UQURZwvKevyZ39cBsTN2Orv5XKs9v+Jhy5s5PgWu5aFuWFoqr3T7vgMzBPVAMhRGMODG
         y0Vw==
X-Forwarded-Encrypted: i=1; AJvYcCXi2fU5RY16nPJtM6XB0awbq6D2Rhdy9nEpwLQiDmDMfwpofQprVMbEU2pjTj66zswPxqqp6M4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxlzcM6xAiN1WcDsFdx3hiIkbr+vCu79L68xP3783k/aoi2srlm
	33r6yj4aMEf4EmLGnaNyRnqyBejHoseuFRUu919t7a6t61p0+GDE0Q7FHcwpd1Ujf8YHz+2+kTw
	Xt4j8F1ZfO2JTPw==
X-Google-Smtp-Source: AGHT+IGXO5YGQCLQJZSqDOwTwYSd5qNoFR4aXpPxyBI5aa87RQI8jR5nK9M6dLW8Fw5mIfPZuy2vvMWn5CebjA==
X-Received: from wrtc13.prod.google.com ([2002:a5d:4ccd:0:b0:3b7:7de7:834b])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f85:0:b0:3a4:f55a:4ae2 with SMTP id ffacd0b85a97d-3b776679f02mr8560421f8f.50.1753725214350;
 Mon, 28 Jul 2025 10:53:34 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:52:51 +0000
In-Reply-To: <20250728175316.3706196-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250728175316.3706196-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250728175316.3706196-5-smostafa@google.com>
Subject: [PATCH v3 04/29] iommu/io-pgtable-arm: Split the page table driver
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

To allow the KVM IOMMU driver to populate page tables using the
io-pgtable-arm code, move the shared bits into io-pgtable-arm-common.c.

Here we move the bulk of the common code, and a subsequent patch handles
the bits that require more care. phys_to_virt() and virt_to_phys() do
need special handling here because the hypervisor will have its own
version. It will also implement its own version of
__arm_lpae_alloc_pages(), __arm_lpae_free_pages() and
__arm_lpae_sync_pte() since the hypervisor needs some assistance for
allocating pages.

Some other minor changes, as there is a special hook for splitting
blocks, as the hypervisor can't print string on WARN, also, in
the future the hypervsior might implement that logic (or bring it
back for itself) as an optimization.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 drivers/iommu/Makefile                |   2 +-
 drivers/iommu/io-pgtable-arm-common.c | 399 +++++++++++++++++
 drivers/iommu/io-pgtable-arm.c        | 590 +-------------------------
 drivers/iommu/io-pgtable-arm.h        | 255 +++++++++--
 4 files changed, 643 insertions(+), 603 deletions(-)
 create mode 100644 drivers/iommu/io-pgtable-arm-common.c

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 355294fa9033..a075eefca480 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_IOMMU_DEBUGFS) += iommu-debugfs.o
 obj-$(CONFIG_IOMMU_DMA) += dma-iommu.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE) += io-pgtable.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_ARMV7S) += io-pgtable-arm-v7s.o
-obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE) += io-pgtable-arm.o
+obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE) += io-pgtable-arm.o io-pgtable-arm-common.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_DART) += io-pgtable-dart.o
 obj-$(CONFIG_IOMMU_IOVA) += iova.o
 obj-$(CONFIG_OF_IOMMU)	+= of_iommu.o
diff --git a/drivers/iommu/io-pgtable-arm-common.c b/drivers/iommu/io-pgtable-arm-common.c
new file mode 100644
index 000000000000..6d5ae1b340b2
--- /dev/null
+++ b/drivers/iommu/io-pgtable-arm-common.c
@@ -0,0 +1,399 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * CPU-agnostic ARM page table allocator.
+ *
+ * Copyright (C) 2022 ARM Limited
+ *
+ * Author: Will Deacon <will.deacon@arm.com>
+ */
+#include <linux/sizes.h>
+#include <linux/types.h>
+
+#include "io-pgtable-arm.h"
+
+/*
+ * Convert an index returned by ARM_LPAE_PGD_IDX(), which can point into
+ * a concatenated PGD, into the maximum number of entries that can be
+ * mapped in the same table page.
+ */
+static inline int arm_lpae_max_entries(int i, struct arm_lpae_io_pgtable *data)
+{
+	int ptes_per_table = ARM_LPAE_PTES_PER_TABLE(data);
+
+	return ptes_per_table - (i & (ptes_per_table - 1));
+}
+
+static void __arm_lpae_clear_pte(arm_lpae_iopte *ptep, struct io_pgtable_cfg *cfg, int num_entries)
+{
+	for (int i = 0; i < num_entries; i++)
+		ptep[i] = 0;
+
+	if (!cfg->coherent_walk && num_entries)
+		__arm_lpae_sync_pte(ptep, num_entries, cfg);
+}
+
+static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
+			       struct iommu_iotlb_gather *gather,
+			       unsigned long iova, size_t size, size_t pgcount,
+			       int lvl, arm_lpae_iopte *ptep);
+
+static void __arm_lpae_init_pte(struct arm_lpae_io_pgtable *data,
+				phys_addr_t paddr, arm_lpae_iopte prot,
+				int lvl, int num_entries, arm_lpae_iopte *ptep)
+{
+	arm_lpae_iopte pte = prot;
+	struct io_pgtable_cfg *cfg = &data->iop.cfg;
+	size_t sz = ARM_LPAE_BLOCK_SIZE(lvl, data);
+	int i;
+
+	if (data->iop.fmt != ARM_MALI_LPAE && lvl == ARM_LPAE_MAX_LEVELS - 1)
+		pte |= ARM_LPAE_PTE_TYPE_PAGE;
+	else
+		pte |= ARM_LPAE_PTE_TYPE_BLOCK;
+
+	for (i = 0; i < num_entries; i++)
+		ptep[i] = pte | paddr_to_iopte(paddr + i * sz, data);
+
+	if (!cfg->coherent_walk)
+		__arm_lpae_sync_pte(ptep, num_entries, cfg);
+}
+
+static int arm_lpae_init_pte(struct arm_lpae_io_pgtable *data,
+			     unsigned long iova, phys_addr_t paddr,
+			     arm_lpae_iopte prot, int lvl, int num_entries,
+			     arm_lpae_iopte *ptep)
+{
+	int i;
+
+	for (i = 0; i < num_entries; i++)
+		if (iopte_leaf(ptep[i], lvl, data->iop.fmt)) {
+			/* We require an unmap first */
+			WARN_ON(!(data->iop.cfg.quirks & IO_PGTABLE_QUIRK_NO_WARN));
+			return -EEXIST;
+		} else if (iopte_type(ptep[i]) == ARM_LPAE_PTE_TYPE_TABLE) {
+			/*
+			 * We need to unmap and free the old table before
+			 * overwriting it with a block entry.
+			 */
+			arm_lpae_iopte *tblp;
+			size_t sz = ARM_LPAE_BLOCK_SIZE(lvl, data);
+
+			tblp = ptep - ARM_LPAE_LVL_IDX(iova, lvl, data);
+			if (__arm_lpae_unmap(data, NULL, iova + i * sz, sz, 1,
+					     lvl, tblp) != sz) {
+				WARN_ON(1);
+				return -EINVAL;
+			}
+		}
+
+	__arm_lpae_init_pte(data, paddr, prot, lvl, num_entries, ptep);
+	return 0;
+}
+
+static arm_lpae_iopte arm_lpae_install_table(arm_lpae_iopte *table,
+					     arm_lpae_iopte *ptep,
+					     arm_lpae_iopte curr,
+					     struct arm_lpae_io_pgtable *data)
+{
+	arm_lpae_iopte old, new;
+	struct io_pgtable_cfg *cfg = &data->iop.cfg;
+
+	new = paddr_to_iopte(__arm_lpae_virt_to_phys(table), data) |
+			     ARM_LPAE_PTE_TYPE_TABLE;
+	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_NS)
+		new |= ARM_LPAE_PTE_NSTABLE;
+
+	/*
+	 * Ensure the table itself is visible before its PTE can be.
+	 * Whilst we could get away with cmpxchg64_release below, this
+	 * doesn't have any ordering semantics when !CONFIG_SMP.
+	 */
+	dma_wmb();
+
+	old = cmpxchg64_relaxed(ptep, curr, new);
+
+	if (cfg->coherent_walk || (old & ARM_LPAE_PTE_SW_SYNC))
+		return old;
+
+	/* Even if it's not ours, there's no point waiting; just kick it */
+	__arm_lpae_sync_pte(ptep, 1, cfg);
+	if (old == curr)
+		WRITE_ONCE(*ptep, new | ARM_LPAE_PTE_SW_SYNC);
+
+	return old;
+}
+
+static int __arm_lpae_map(struct arm_lpae_io_pgtable *data, unsigned long iova,
+			  phys_addr_t paddr, size_t size, size_t pgcount,
+			  arm_lpae_iopte prot, int lvl, arm_lpae_iopte *ptep,
+			  gfp_t gfp, size_t *mapped)
+{
+	arm_lpae_iopte *cptep, pte;
+	size_t block_size = ARM_LPAE_BLOCK_SIZE(lvl, data);
+	size_t tblsz = ARM_LPAE_GRANULE(data);
+	struct io_pgtable_cfg *cfg = &data->iop.cfg;
+	int ret = 0, num_entries, max_entries, map_idx_start;
+
+	/* Find our entry at the current level */
+	map_idx_start = ARM_LPAE_LVL_IDX(iova, lvl, data);
+	ptep += map_idx_start;
+
+	/* If we can install a leaf entry at this level, then do so */
+	if (size == block_size) {
+		max_entries = arm_lpae_max_entries(map_idx_start, data);
+		num_entries = min_t(int, pgcount, max_entries);
+		ret = arm_lpae_init_pte(data, iova, paddr, prot, lvl, num_entries, ptep);
+		if (!ret)
+			*mapped += num_entries * size;
+
+		return ret;
+	}
+
+	/* We can't allocate tables at the final level */
+	if (WARN_ON(lvl >= ARM_LPAE_MAX_LEVELS - 1))
+		return -EINVAL;
+
+	/* Grab a pointer to the next level */
+	pte = READ_ONCE(*ptep);
+	if (!pte) {
+		cptep = __arm_lpae_alloc_pages(tblsz, gfp, cfg, data->iop.cookie);
+		if (!cptep)
+			return -ENOMEM;
+
+		pte = arm_lpae_install_table(cptep, ptep, 0, data);
+		if (pte)
+			__arm_lpae_free_pages(cptep, tblsz, cfg, data->iop.cookie);
+	} else if (!cfg->coherent_walk && !(pte & ARM_LPAE_PTE_SW_SYNC)) {
+		__arm_lpae_sync_pte(ptep, 1, cfg);
+	}
+
+	if (pte && !iopte_leaf(pte, lvl, data->iop.fmt)) {
+		cptep = iopte_deref(pte, data);
+	} else if (pte) {
+		/* We require an unmap first */
+		WARN_ON(!(cfg->quirks & IO_PGTABLE_QUIRK_NO_WARN));
+		return -EEXIST;
+	}
+
+	/* Rinse, repeat */
+	return __arm_lpae_map(data, iova, paddr, size, pgcount, prot, lvl + 1,
+			      cptep, gfp, mapped);
+}
+
+static arm_lpae_iopte arm_lpae_prot_to_pte(struct arm_lpae_io_pgtable *data,
+					   int prot)
+{
+	arm_lpae_iopte pte;
+
+	if (data->iop.fmt == ARM_64_LPAE_S1 ||
+	    data->iop.fmt == ARM_32_LPAE_S1) {
+		pte = ARM_LPAE_PTE_nG;
+		if (!(prot & IOMMU_WRITE) && (prot & IOMMU_READ))
+			pte |= ARM_LPAE_PTE_AP_RDONLY;
+		else if (data->iop.cfg.quirks & IO_PGTABLE_QUIRK_ARM_HD)
+			pte |= ARM_LPAE_PTE_DBM;
+		if (!(prot & IOMMU_PRIV))
+			pte |= ARM_LPAE_PTE_AP_UNPRIV;
+	} else {
+		pte = ARM_LPAE_PTE_HAP_FAULT;
+		if (prot & IOMMU_READ)
+			pte |= ARM_LPAE_PTE_HAP_READ;
+		if (prot & IOMMU_WRITE)
+			pte |= ARM_LPAE_PTE_HAP_WRITE;
+	}
+
+	/*
+	 * Note that this logic is structured to accommodate Mali LPAE
+	 * having stage-1-like attributes but stage-2-like permissions.
+	 */
+	if (data->iop.fmt == ARM_64_LPAE_S2 ||
+	    data->iop.fmt == ARM_32_LPAE_S2) {
+		if (prot & IOMMU_MMIO) {
+			pte |= ARM_LPAE_PTE_MEMATTR_DEV;
+		} else if (prot & IOMMU_CACHE) {
+			if (data->iop.cfg.quirks & IO_PGTABLE_QUIRK_ARM_S2FWB)
+				pte |= ARM_LPAE_PTE_MEMATTR_FWB_WB;
+			else
+				pte |= ARM_LPAE_PTE_MEMATTR_OIWB;
+		} else {
+			pte |= ARM_LPAE_PTE_MEMATTR_NC;
+		}
+	} else {
+		if (prot & IOMMU_MMIO)
+			pte |= (ARM_LPAE_MAIR_ATTR_IDX_DEV
+				<< ARM_LPAE_PTE_ATTRINDX_SHIFT);
+		else if (prot & IOMMU_CACHE)
+			pte |= (ARM_LPAE_MAIR_ATTR_IDX_CACHE
+				<< ARM_LPAE_PTE_ATTRINDX_SHIFT);
+	}
+
+	/*
+	 * Also Mali has its own notions of shareability wherein its Inner
+	 * domain covers the cores within the GPU, and its Outer domain is
+	 * "outside the GPU" (i.e. either the Inner or System domain in CPU
+	 * terms, depending on coherency).
+	 */
+	if (prot & IOMMU_CACHE && data->iop.fmt != ARM_MALI_LPAE)
+		pte |= ARM_LPAE_PTE_SH_IS;
+	else
+		pte |= ARM_LPAE_PTE_SH_OS;
+
+	if (prot & IOMMU_NOEXEC)
+		pte |= ARM_LPAE_PTE_XN;
+
+	if (data->iop.cfg.quirks & IO_PGTABLE_QUIRK_ARM_NS)
+		pte |= ARM_LPAE_PTE_NS;
+
+	if (data->iop.fmt != ARM_MALI_LPAE)
+		pte |= ARM_LPAE_PTE_AF;
+
+	return pte;
+}
+
+int arm_lpae_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
+		       phys_addr_t paddr, size_t pgsize, size_t pgcount,
+		       int iommu_prot, gfp_t gfp, size_t *mapped)
+{
+	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
+	struct io_pgtable_cfg *cfg = &data->iop.cfg;
+	arm_lpae_iopte *ptep = data->pgd;
+	int ret, lvl = data->start_level;
+	arm_lpae_iopte prot;
+	long iaext = (s64)iova >> cfg->ias;
+
+	if (WARN_ON(!pgsize || (pgsize & cfg->pgsize_bitmap) != pgsize))
+		return -EINVAL;
+
+	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_TTBR1)
+		iaext = ~iaext;
+	if (WARN_ON(iaext || paddr >> cfg->oas))
+		return -ERANGE;
+
+	if (!(iommu_prot & (IOMMU_READ | IOMMU_WRITE)))
+		return -EINVAL;
+
+	prot = arm_lpae_prot_to_pte(data, iommu_prot);
+	ret = __arm_lpae_map(data, iova, paddr, pgsize, pgcount, prot, lvl,
+			     ptep, gfp, mapped);
+	/*
+	 * Synchronise all PTE updates for the new mapping before there's
+	 * a chance for anything to kick off a table walk for the new iova.
+	 */
+	wmb();
+
+	return ret;
+}
+
+void __arm_lpae_free_pgtable(struct arm_lpae_io_pgtable *data, int lvl,
+			     arm_lpae_iopte *ptep)
+{
+	arm_lpae_iopte *start, *end;
+	unsigned long table_size;
+
+	if (lvl == data->start_level)
+		table_size = ARM_LPAE_PGD_SIZE(data);
+	else
+		table_size = ARM_LPAE_GRANULE(data);
+
+	start = ptep;
+
+	/* Only leaf entries at the last level */
+	if (lvl == ARM_LPAE_MAX_LEVELS - 1)
+		end = ptep;
+	else
+		end = (void *)ptep + table_size;
+
+	while (ptep != end) {
+		arm_lpae_iopte pte = *ptep++;
+
+		if (!pte || iopte_leaf(pte, lvl, data->iop.fmt))
+			continue;
+
+		__arm_lpae_free_pgtable(data, lvl + 1, iopte_deref(pte, data));
+	}
+
+	__arm_lpae_free_pages(start, table_size, &data->iop.cfg, data->iop.cookie);
+}
+
+static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
+			       struct iommu_iotlb_gather *gather,
+			       unsigned long iova, size_t size, size_t pgcount,
+			       int lvl, arm_lpae_iopte *ptep)
+{
+	arm_lpae_iopte pte;
+	struct io_pgtable *iop = &data->iop;
+	int i = 0, num_entries, max_entries, unmap_idx_start;
+
+	/* Something went horribly wrong and we ran out of page table */
+	if (WARN_ON(lvl == ARM_LPAE_MAX_LEVELS))
+		return 0;
+
+	unmap_idx_start = ARM_LPAE_LVL_IDX(iova, lvl, data);
+	ptep += unmap_idx_start;
+	pte = READ_ONCE(*ptep);
+	if (!pte) {
+		WARN_ON(!(data->iop.cfg.quirks & IO_PGTABLE_QUIRK_NO_WARN));
+		return -ENOENT;
+	}
+
+	/* If the size matches this level, we're in the right place */
+	if (size == ARM_LPAE_BLOCK_SIZE(lvl, data)) {
+		max_entries = arm_lpae_max_entries(unmap_idx_start, data);
+		num_entries = min_t(int, pgcount, max_entries);
+
+		/* Find and handle non-leaf entries */
+		for (i = 0; i < num_entries; i++) {
+			pte = READ_ONCE(ptep[i]);
+			if (!pte) {
+				WARN_ON(!(data->iop.cfg.quirks & IO_PGTABLE_QUIRK_NO_WARN));
+				break;
+			}
+
+			if (!iopte_leaf(pte, lvl, iop->fmt)) {
+				__arm_lpae_clear_pte(&ptep[i], &iop->cfg, 1);
+
+				/* Also flush any partial walks */
+				io_pgtable_tlb_flush_walk(iop, iova + i * size, size,
+							  ARM_LPAE_GRANULE(data));
+				__arm_lpae_free_pgtable(data, lvl + 1, iopte_deref(pte, data));
+			}
+		}
+
+		/* Clear the remaining entries */
+		__arm_lpae_clear_pte(ptep, &iop->cfg, i);
+
+		if (gather && !iommu_iotlb_gather_queued(gather))
+			for (int j = 0; j < i; j++)
+				io_pgtable_tlb_add_page(iop, gather, iova + j * size, size);
+
+		return i * size;
+	} else if (iopte_leaf(pte, lvl, iop->fmt)) {
+		arm_lpae_split_blk();
+		return 0;
+	}
+
+	/* Keep on walkin' */
+	ptep = iopte_deref(pte, data);
+	return __arm_lpae_unmap(data, gather, iova, size, pgcount, lvl + 1, ptep);
+}
+
+size_t arm_lpae_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
+			    size_t pgsize, size_t pgcount,
+			    struct iommu_iotlb_gather *gather)
+{
+	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
+	struct io_pgtable_cfg *cfg = &data->iop.cfg;
+	arm_lpae_iopte *ptep = data->pgd;
+	long iaext = (s64)iova >> cfg->ias;
+
+	if (WARN_ON(!pgsize || (pgsize & cfg->pgsize_bitmap) != pgsize || !pgcount))
+		return 0;
+
+	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_TTBR1)
+		iaext = ~iaext;
+	if (WARN_ON(iaext))
+		return 0;
+
+	return __arm_lpae_unmap(data, gather, iova, pgsize, pgcount,
+				data->start_level, ptep);
+}
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 96425e92f313..ca4467ad3c40 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * CPU-agnostic ARM page table allocator.
+ * Host-specific functions. The rest is in io-pgtable-arm-common.c.
  *
  * Copyright (C) 2014 ARM Limited
  *
@@ -24,204 +25,15 @@
 #include "io-pgtable-arm.h"
 #include "iommu-pages.h"
 
-#define ARM_LPAE_MAX_ADDR_BITS		52
-#define ARM_LPAE_S2_MAX_CONCAT_PAGES	16
-#define ARM_LPAE_MAX_LEVELS		4
-
-/* Struct accessors */
-#define io_pgtable_to_data(x)						\
-	container_of((x), struct arm_lpae_io_pgtable, iop)
-
-#define io_pgtable_ops_to_data(x)					\
-	io_pgtable_to_data(io_pgtable_ops_to_pgtable(x))
-
-/*
- * Calculate the right shift amount to get to the portion describing level l
- * in a virtual address mapped by the pagetable in d.
- */
-#define ARM_LPAE_LVL_SHIFT(l,d)						\
-	(((ARM_LPAE_MAX_LEVELS - (l)) * (d)->bits_per_level) +		\
-	ilog2(sizeof(arm_lpae_iopte)))
-
-#define ARM_LPAE_GRANULE(d)						\
-	(sizeof(arm_lpae_iopte) << (d)->bits_per_level)
-#define ARM_LPAE_PGD_SIZE(d)						\
-	(sizeof(arm_lpae_iopte) << (d)->pgd_bits)
-
-#define ARM_LPAE_PTES_PER_TABLE(d)					\
-	(ARM_LPAE_GRANULE(d) >> ilog2(sizeof(arm_lpae_iopte)))
-
-/*
- * Calculate the index at level l used to map virtual address a using the
- * pagetable in d.
- */
-#define ARM_LPAE_PGD_IDX(l,d)						\
-	((l) == (d)->start_level ? (d)->pgd_bits - (d)->bits_per_level : 0)
-
-#define ARM_LPAE_LVL_IDX(a,l,d)						\
-	(((u64)(a) >> ARM_LPAE_LVL_SHIFT(l,d)) &			\
-	 ((1 << ((d)->bits_per_level + ARM_LPAE_PGD_IDX(l,d))) - 1))
-
-/* Calculate the block/page mapping size at level l for pagetable in d. */
-#define ARM_LPAE_BLOCK_SIZE(l,d)	(1ULL << ARM_LPAE_LVL_SHIFT(l,d))
-
-/* Page table bits */
-#define ARM_LPAE_PTE_TYPE_SHIFT		0
-#define ARM_LPAE_PTE_TYPE_MASK		0x3
-
-#define ARM_LPAE_PTE_TYPE_BLOCK		1
-#define ARM_LPAE_PTE_TYPE_TABLE		3
-#define ARM_LPAE_PTE_TYPE_PAGE		3
-
-#define ARM_LPAE_PTE_ADDR_MASK		GENMASK_ULL(47,12)
-
-#define ARM_LPAE_PTE_NSTABLE		(((arm_lpae_iopte)1) << 63)
-#define ARM_LPAE_PTE_XN			(((arm_lpae_iopte)3) << 53)
-#define ARM_LPAE_PTE_DBM		(((arm_lpae_iopte)1) << 51)
-#define ARM_LPAE_PTE_AF			(((arm_lpae_iopte)1) << 10)
-#define ARM_LPAE_PTE_SH_NS		(((arm_lpae_iopte)0) << 8)
-#define ARM_LPAE_PTE_SH_OS		(((arm_lpae_iopte)2) << 8)
-#define ARM_LPAE_PTE_SH_IS		(((arm_lpae_iopte)3) << 8)
-#define ARM_LPAE_PTE_NS			(((arm_lpae_iopte)1) << 5)
-#define ARM_LPAE_PTE_VALID		(((arm_lpae_iopte)1) << 0)
-
-#define ARM_LPAE_PTE_ATTR_LO_MASK	(((arm_lpae_iopte)0x3ff) << 2)
-/* Ignore the contiguous bit for block splitting */
-#define ARM_LPAE_PTE_ATTR_HI_MASK	(ARM_LPAE_PTE_XN | ARM_LPAE_PTE_DBM)
-#define ARM_LPAE_PTE_ATTR_MASK		(ARM_LPAE_PTE_ATTR_LO_MASK |	\
-					 ARM_LPAE_PTE_ATTR_HI_MASK)
-/* Software bit for solving coherency races */
-#define ARM_LPAE_PTE_SW_SYNC		(((arm_lpae_iopte)1) << 55)
-
-/* Stage-1 PTE */
-#define ARM_LPAE_PTE_AP_UNPRIV		(((arm_lpae_iopte)1) << 6)
-#define ARM_LPAE_PTE_AP_RDONLY_BIT	7
-#define ARM_LPAE_PTE_AP_RDONLY		(((arm_lpae_iopte)1) << \
-					   ARM_LPAE_PTE_AP_RDONLY_BIT)
-#define ARM_LPAE_PTE_AP_WR_CLEAN_MASK	(ARM_LPAE_PTE_AP_RDONLY | \
-					 ARM_LPAE_PTE_DBM)
-#define ARM_LPAE_PTE_ATTRINDX_SHIFT	2
-#define ARM_LPAE_PTE_nG			(((arm_lpae_iopte)1) << 11)
-
-/* Stage-2 PTE */
-#define ARM_LPAE_PTE_HAP_FAULT		(((arm_lpae_iopte)0) << 6)
-#define ARM_LPAE_PTE_HAP_READ		(((arm_lpae_iopte)1) << 6)
-#define ARM_LPAE_PTE_HAP_WRITE		(((arm_lpae_iopte)2) << 6)
-/*
- * For !FWB these code to:
- *  1111 = Normal outer write back cachable / Inner Write Back Cachable
- *         Permit S1 to override
- *  0101 = Normal Non-cachable / Inner Non-cachable
- *  0001 = Device / Device-nGnRE
- * For S2FWB these code:
- *  0110 Force Normal Write Back
- *  0101 Normal* is forced Normal-NC, Device unchanged
- *  0001 Force Device-nGnRE
- */
-#define ARM_LPAE_PTE_MEMATTR_FWB_WB	(((arm_lpae_iopte)0x6) << 2)
-#define ARM_LPAE_PTE_MEMATTR_OIWB	(((arm_lpae_iopte)0xf) << 2)
-#define ARM_LPAE_PTE_MEMATTR_NC		(((arm_lpae_iopte)0x5) << 2)
-#define ARM_LPAE_PTE_MEMATTR_DEV	(((arm_lpae_iopte)0x1) << 2)
-
-/* Register bits */
-#define ARM_LPAE_VTCR_SL0_MASK		0x3
-
-#define ARM_LPAE_TCR_T0SZ_SHIFT		0
-
-#define ARM_LPAE_VTCR_PS_SHIFT		16
-#define ARM_LPAE_VTCR_PS_MASK		0x7
-
-#define ARM_LPAE_MAIR_ATTR_SHIFT(n)	((n) << 3)
-#define ARM_LPAE_MAIR_ATTR_MASK		0xff
-#define ARM_LPAE_MAIR_ATTR_DEVICE	0x04
-#define ARM_LPAE_MAIR_ATTR_NC		0x44
-#define ARM_LPAE_MAIR_ATTR_INC_OWBRWA	0xf4
-#define ARM_LPAE_MAIR_ATTR_WBRWA	0xff
-#define ARM_LPAE_MAIR_ATTR_IDX_NC	0
-#define ARM_LPAE_MAIR_ATTR_IDX_CACHE	1
-#define ARM_LPAE_MAIR_ATTR_IDX_DEV	2
-#define ARM_LPAE_MAIR_ATTR_IDX_INC_OCACHE	3
-
-#define ARM_MALI_LPAE_TTBR_ADRMODE_TABLE (3u << 0)
-#define ARM_MALI_LPAE_TTBR_READ_INNER	BIT(2)
-#define ARM_MALI_LPAE_TTBR_SHARE_OUTER	BIT(4)
-
-#define ARM_MALI_LPAE_MEMATTR_IMP_DEF	0x88ULL
-#define ARM_MALI_LPAE_MEMATTR_WRITE_ALLOC 0x8DULL
-
-/* IOPTE accessors */
-#define iopte_deref(pte,d) __va(iopte_to_paddr(pte, d))
-
-#define iopte_type(pte)					\
-	(((pte) >> ARM_LPAE_PTE_TYPE_SHIFT) & ARM_LPAE_PTE_TYPE_MASK)
-
-#define iopte_prot(pte)	((pte) & ARM_LPAE_PTE_ATTR_MASK)
-
 #define iopte_writeable_dirty(pte)				\
 	(((pte) & ARM_LPAE_PTE_AP_WR_CLEAN_MASK) == ARM_LPAE_PTE_DBM)
 
 #define iopte_set_writeable_clean(ptep)				\
 	set_bit(ARM_LPAE_PTE_AP_RDONLY_BIT, (unsigned long *)(ptep))
 
-struct arm_lpae_io_pgtable {
-	struct io_pgtable	iop;
-
-	int			pgd_bits;
-	int			start_level;
-	int			bits_per_level;
-
-	void			*pgd;
-};
-
-typedef u64 arm_lpae_iopte;
-
-static inline bool iopte_leaf(arm_lpae_iopte pte, int lvl,
-			      enum io_pgtable_fmt fmt)
-{
-	if (lvl == (ARM_LPAE_MAX_LEVELS - 1) && fmt != ARM_MALI_LPAE)
-		return iopte_type(pte) == ARM_LPAE_PTE_TYPE_PAGE;
-
-	return iopte_type(pte) == ARM_LPAE_PTE_TYPE_BLOCK;
-}
-
-static inline bool iopte_table(arm_lpae_iopte pte, int lvl)
-{
-	if (lvl == (ARM_LPAE_MAX_LEVELS - 1))
-		return false;
-	return iopte_type(pte) == ARM_LPAE_PTE_TYPE_TABLE;
-}
-
-static arm_lpae_iopte paddr_to_iopte(phys_addr_t paddr,
-				     struct arm_lpae_io_pgtable *data)
+void arm_lpae_split_blk(void)
 {
-	arm_lpae_iopte pte = paddr;
-
-	/* Of the bits which overlap, either 51:48 or 15:12 are always RES0 */
-	return (pte | (pte >> (48 - 12))) & ARM_LPAE_PTE_ADDR_MASK;
-}
-
-static phys_addr_t iopte_to_paddr(arm_lpae_iopte pte,
-				  struct arm_lpae_io_pgtable *data)
-{
-	u64 paddr = pte & ARM_LPAE_PTE_ADDR_MASK;
-
-	if (ARM_LPAE_GRANULE(data) < SZ_64K)
-		return paddr;
-
-	/* Rotate the packed high-order bits back to the top */
-	return (paddr | (paddr << (48 - 12))) & (ARM_LPAE_PTE_ADDR_MASK << 4);
-}
-
-/*
- * Convert an index returned by ARM_LPAE_PGD_IDX(), which can point into
- * a concatenated PGD, into the maximum number of entries that can be
- * mapped in the same table page.
- */
-static inline int arm_lpae_max_entries(int i, struct arm_lpae_io_pgtable *data)
-{
-	int ptes_per_table = ARM_LPAE_PTES_PER_TABLE(data);
-
-	return ptes_per_table - (i & (ptes_per_table - 1));
+	WARN_ONCE(true, "Unmap of a partial large IOPTE is not allowed");
 }
 
 /*
@@ -257,9 +69,9 @@ static dma_addr_t __arm_lpae_dma_addr(void *pages)
 	return (dma_addr_t)virt_to_phys(pages);
 }
 
-static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
-				    struct io_pgtable_cfg *cfg,
-				    void *cookie)
+void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
+			     struct io_pgtable_cfg *cfg,
+			     void *cookie)
 {
 	struct device *dev = cfg->iommu_dev;
 	size_t alloc_size;
@@ -308,9 +120,9 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
 	return NULL;
 }
 
-static void __arm_lpae_free_pages(void *pages, size_t size,
-				  struct io_pgtable_cfg *cfg,
-				  void *cookie)
+void __arm_lpae_free_pages(void *pages, size_t size,
+			   struct io_pgtable_cfg *cfg,
+			   void *cookie)
 {
 	if (!cfg->coherent_walk)
 		dma_unmap_single(cfg->iommu_dev, __arm_lpae_dma_addr(pages),
@@ -322,393 +134,19 @@ static void __arm_lpae_free_pages(void *pages, size_t size,
 		iommu_free_pages(pages);
 }
 
-static void __arm_lpae_sync_pte(arm_lpae_iopte *ptep, int num_entries,
-				struct io_pgtable_cfg *cfg)
+void __arm_lpae_sync_pte(arm_lpae_iopte *ptep, int num_entries,
+			 struct io_pgtable_cfg *cfg)
 {
 	dma_sync_single_for_device(cfg->iommu_dev, __arm_lpae_dma_addr(ptep),
 				   sizeof(*ptep) * num_entries, DMA_TO_DEVICE);
 }
 
-static void __arm_lpae_clear_pte(arm_lpae_iopte *ptep, struct io_pgtable_cfg *cfg, int num_entries)
-{
-	for (int i = 0; i < num_entries; i++)
-		ptep[i] = 0;
-
-	if (!cfg->coherent_walk && num_entries)
-		__arm_lpae_sync_pte(ptep, num_entries, cfg);
-}
-
-static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
-			       struct iommu_iotlb_gather *gather,
-			       unsigned long iova, size_t size, size_t pgcount,
-			       int lvl, arm_lpae_iopte *ptep);
-
-static void __arm_lpae_init_pte(struct arm_lpae_io_pgtable *data,
-				phys_addr_t paddr, arm_lpae_iopte prot,
-				int lvl, int num_entries, arm_lpae_iopte *ptep)
-{
-	arm_lpae_iopte pte = prot;
-	struct io_pgtable_cfg *cfg = &data->iop.cfg;
-	size_t sz = ARM_LPAE_BLOCK_SIZE(lvl, data);
-	int i;
-
-	if (data->iop.fmt != ARM_MALI_LPAE && lvl == ARM_LPAE_MAX_LEVELS - 1)
-		pte |= ARM_LPAE_PTE_TYPE_PAGE;
-	else
-		pte |= ARM_LPAE_PTE_TYPE_BLOCK;
-
-	for (i = 0; i < num_entries; i++)
-		ptep[i] = pte | paddr_to_iopte(paddr + i * sz, data);
-
-	if (!cfg->coherent_walk)
-		__arm_lpae_sync_pte(ptep, num_entries, cfg);
-}
-
-static int arm_lpae_init_pte(struct arm_lpae_io_pgtable *data,
-			     unsigned long iova, phys_addr_t paddr,
-			     arm_lpae_iopte prot, int lvl, int num_entries,
-			     arm_lpae_iopte *ptep)
-{
-	int i;
-
-	for (i = 0; i < num_entries; i++)
-		if (iopte_leaf(ptep[i], lvl, data->iop.fmt)) {
-			/* We require an unmap first */
-			WARN_ON(!(data->iop.cfg.quirks & IO_PGTABLE_QUIRK_NO_WARN));
-			return -EEXIST;
-		} else if (iopte_type(ptep[i]) == ARM_LPAE_PTE_TYPE_TABLE) {
-			/*
-			 * We need to unmap and free the old table before
-			 * overwriting it with a block entry.
-			 */
-			arm_lpae_iopte *tblp;
-			size_t sz = ARM_LPAE_BLOCK_SIZE(lvl, data);
-
-			tblp = ptep - ARM_LPAE_LVL_IDX(iova, lvl, data);
-			if (__arm_lpae_unmap(data, NULL, iova + i * sz, sz, 1,
-					     lvl, tblp) != sz) {
-				WARN_ON(1);
-				return -EINVAL;
-			}
-		}
-
-	__arm_lpae_init_pte(data, paddr, prot, lvl, num_entries, ptep);
-	return 0;
-}
-
-static arm_lpae_iopte arm_lpae_install_table(arm_lpae_iopte *table,
-					     arm_lpae_iopte *ptep,
-					     arm_lpae_iopte curr,
-					     struct arm_lpae_io_pgtable *data)
-{
-	arm_lpae_iopte old, new;
-	struct io_pgtable_cfg *cfg = &data->iop.cfg;
-
-	new = paddr_to_iopte(__pa(table), data) | ARM_LPAE_PTE_TYPE_TABLE;
-	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_NS)
-		new |= ARM_LPAE_PTE_NSTABLE;
-
-	/*
-	 * Ensure the table itself is visible before its PTE can be.
-	 * Whilst we could get away with cmpxchg64_release below, this
-	 * doesn't have any ordering semantics when !CONFIG_SMP.
-	 */
-	dma_wmb();
-
-	old = cmpxchg64_relaxed(ptep, curr, new);
-
-	if (cfg->coherent_walk || (old & ARM_LPAE_PTE_SW_SYNC))
-		return old;
-
-	/* Even if it's not ours, there's no point waiting; just kick it */
-	__arm_lpae_sync_pte(ptep, 1, cfg);
-	if (old == curr)
-		WRITE_ONCE(*ptep, new | ARM_LPAE_PTE_SW_SYNC);
-
-	return old;
-}
-
-static int __arm_lpae_map(struct arm_lpae_io_pgtable *data, unsigned long iova,
-			  phys_addr_t paddr, size_t size, size_t pgcount,
-			  arm_lpae_iopte prot, int lvl, arm_lpae_iopte *ptep,
-			  gfp_t gfp, size_t *mapped)
-{
-	arm_lpae_iopte *cptep, pte;
-	size_t block_size = ARM_LPAE_BLOCK_SIZE(lvl, data);
-	size_t tblsz = ARM_LPAE_GRANULE(data);
-	struct io_pgtable_cfg *cfg = &data->iop.cfg;
-	int ret = 0, num_entries, max_entries, map_idx_start;
-
-	/* Find our entry at the current level */
-	map_idx_start = ARM_LPAE_LVL_IDX(iova, lvl, data);
-	ptep += map_idx_start;
-
-	/* If we can install a leaf entry at this level, then do so */
-	if (size == block_size) {
-		max_entries = arm_lpae_max_entries(map_idx_start, data);
-		num_entries = min_t(int, pgcount, max_entries);
-		ret = arm_lpae_init_pte(data, iova, paddr, prot, lvl, num_entries, ptep);
-		if (!ret)
-			*mapped += num_entries * size;
-
-		return ret;
-	}
-
-	/* We can't allocate tables at the final level */
-	if (WARN_ON(lvl >= ARM_LPAE_MAX_LEVELS - 1))
-		return -EINVAL;
-
-	/* Grab a pointer to the next level */
-	pte = READ_ONCE(*ptep);
-	if (!pte) {
-		cptep = __arm_lpae_alloc_pages(tblsz, gfp, cfg, data->iop.cookie);
-		if (!cptep)
-			return -ENOMEM;
-
-		pte = arm_lpae_install_table(cptep, ptep, 0, data);
-		if (pte)
-			__arm_lpae_free_pages(cptep, tblsz, cfg, data->iop.cookie);
-	} else if (!cfg->coherent_walk && !(pte & ARM_LPAE_PTE_SW_SYNC)) {
-		__arm_lpae_sync_pte(ptep, 1, cfg);
-	}
-
-	if (pte && !iopte_leaf(pte, lvl, data->iop.fmt)) {
-		cptep = iopte_deref(pte, data);
-	} else if (pte) {
-		/* We require an unmap first */
-		WARN_ON(!(cfg->quirks & IO_PGTABLE_QUIRK_NO_WARN));
-		return -EEXIST;
-	}
-
-	/* Rinse, repeat */
-	return __arm_lpae_map(data, iova, paddr, size, pgcount, prot, lvl + 1,
-			      cptep, gfp, mapped);
-}
-
-static arm_lpae_iopte arm_lpae_prot_to_pte(struct arm_lpae_io_pgtable *data,
-					   int prot)
-{
-	arm_lpae_iopte pte;
-
-	if (data->iop.fmt == ARM_64_LPAE_S1 ||
-	    data->iop.fmt == ARM_32_LPAE_S1) {
-		pte = ARM_LPAE_PTE_nG;
-		if (!(prot & IOMMU_WRITE) && (prot & IOMMU_READ))
-			pte |= ARM_LPAE_PTE_AP_RDONLY;
-		else if (data->iop.cfg.quirks & IO_PGTABLE_QUIRK_ARM_HD)
-			pte |= ARM_LPAE_PTE_DBM;
-		if (!(prot & IOMMU_PRIV))
-			pte |= ARM_LPAE_PTE_AP_UNPRIV;
-	} else {
-		pte = ARM_LPAE_PTE_HAP_FAULT;
-		if (prot & IOMMU_READ)
-			pte |= ARM_LPAE_PTE_HAP_READ;
-		if (prot & IOMMU_WRITE)
-			pte |= ARM_LPAE_PTE_HAP_WRITE;
-	}
-
-	/*
-	 * Note that this logic is structured to accommodate Mali LPAE
-	 * having stage-1-like attributes but stage-2-like permissions.
-	 */
-	if (data->iop.fmt == ARM_64_LPAE_S2 ||
-	    data->iop.fmt == ARM_32_LPAE_S2) {
-		if (prot & IOMMU_MMIO) {
-			pte |= ARM_LPAE_PTE_MEMATTR_DEV;
-		} else if (prot & IOMMU_CACHE) {
-			if (data->iop.cfg.quirks & IO_PGTABLE_QUIRK_ARM_S2FWB)
-				pte |= ARM_LPAE_PTE_MEMATTR_FWB_WB;
-			else
-				pte |= ARM_LPAE_PTE_MEMATTR_OIWB;
-		} else {
-			pte |= ARM_LPAE_PTE_MEMATTR_NC;
-		}
-	} else {
-		if (prot & IOMMU_MMIO)
-			pte |= (ARM_LPAE_MAIR_ATTR_IDX_DEV
-				<< ARM_LPAE_PTE_ATTRINDX_SHIFT);
-		else if (prot & IOMMU_CACHE)
-			pte |= (ARM_LPAE_MAIR_ATTR_IDX_CACHE
-				<< ARM_LPAE_PTE_ATTRINDX_SHIFT);
-	}
-
-	/*
-	 * Also Mali has its own notions of shareability wherein its Inner
-	 * domain covers the cores within the GPU, and its Outer domain is
-	 * "outside the GPU" (i.e. either the Inner or System domain in CPU
-	 * terms, depending on coherency).
-	 */
-	if (prot & IOMMU_CACHE && data->iop.fmt != ARM_MALI_LPAE)
-		pte |= ARM_LPAE_PTE_SH_IS;
-	else
-		pte |= ARM_LPAE_PTE_SH_OS;
-
-	if (prot & IOMMU_NOEXEC)
-		pte |= ARM_LPAE_PTE_XN;
-
-	if (data->iop.cfg.quirks & IO_PGTABLE_QUIRK_ARM_NS)
-		pte |= ARM_LPAE_PTE_NS;
-
-	if (data->iop.fmt != ARM_MALI_LPAE)
-		pte |= ARM_LPAE_PTE_AF;
-
-	return pte;
-}
-
-static int arm_lpae_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
-			      phys_addr_t paddr, size_t pgsize, size_t pgcount,
-			      int iommu_prot, gfp_t gfp, size_t *mapped)
-{
-	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
-	struct io_pgtable_cfg *cfg = &data->iop.cfg;
-	arm_lpae_iopte *ptep = data->pgd;
-	int ret, lvl = data->start_level;
-	arm_lpae_iopte prot;
-	long iaext = (s64)iova >> cfg->ias;
-
-	if (WARN_ON(!pgsize || (pgsize & cfg->pgsize_bitmap) != pgsize))
-		return -EINVAL;
-
-	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_TTBR1)
-		iaext = ~iaext;
-	if (WARN_ON(iaext || paddr >> cfg->oas))
-		return -ERANGE;
-
-	if (!(iommu_prot & (IOMMU_READ | IOMMU_WRITE)))
-		return -EINVAL;
-
-	prot = arm_lpae_prot_to_pte(data, iommu_prot);
-	ret = __arm_lpae_map(data, iova, paddr, pgsize, pgcount, prot, lvl,
-			     ptep, gfp, mapped);
-	/*
-	 * Synchronise all PTE updates for the new mapping before there's
-	 * a chance for anything to kick off a table walk for the new iova.
-	 */
-	wmb();
-
-	return ret;
-}
-
-static void __arm_lpae_free_pgtable(struct arm_lpae_io_pgtable *data, int lvl,
-				    arm_lpae_iopte *ptep)
-{
-	arm_lpae_iopte *start, *end;
-	unsigned long table_size;
-
-	if (lvl == data->start_level)
-		table_size = ARM_LPAE_PGD_SIZE(data);
-	else
-		table_size = ARM_LPAE_GRANULE(data);
-
-	start = ptep;
-
-	/* Only leaf entries at the last level */
-	if (lvl == ARM_LPAE_MAX_LEVELS - 1)
-		end = ptep;
-	else
-		end = (void *)ptep + table_size;
-
-	while (ptep != end) {
-		arm_lpae_iopte pte = *ptep++;
-
-		if (!pte || iopte_leaf(pte, lvl, data->iop.fmt))
-			continue;
-
-		__arm_lpae_free_pgtable(data, lvl + 1, iopte_deref(pte, data));
-	}
-
-	__arm_lpae_free_pages(start, table_size, &data->iop.cfg, data->iop.cookie);
-}
-
 static void arm_lpae_free_pgtable(struct io_pgtable *iop)
 {
-	struct arm_lpae_io_pgtable *data = io_pgtable_to_data(iop);
-
-	__arm_lpae_free_pgtable(data, data->start_level, data->pgd);
-	kfree(data);
-}
-
-static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
-			       struct iommu_iotlb_gather *gather,
-			       unsigned long iova, size_t size, size_t pgcount,
-			       int lvl, arm_lpae_iopte *ptep)
-{
-	arm_lpae_iopte pte;
-	struct io_pgtable *iop = &data->iop;
-	int i = 0, num_entries, max_entries, unmap_idx_start;
-
-	/* Something went horribly wrong and we ran out of page table */
-	if (WARN_ON(lvl == ARM_LPAE_MAX_LEVELS))
-		return 0;
-
-	unmap_idx_start = ARM_LPAE_LVL_IDX(iova, lvl, data);
-	ptep += unmap_idx_start;
-	pte = READ_ONCE(*ptep);
-	if (!pte) {
-		WARN_ON(!(data->iop.cfg.quirks & IO_PGTABLE_QUIRK_NO_WARN));
-		return -ENOENT;
-	}
-
-	/* If the size matches this level, we're in the right place */
-	if (size == ARM_LPAE_BLOCK_SIZE(lvl, data)) {
-		max_entries = arm_lpae_max_entries(unmap_idx_start, data);
-		num_entries = min_t(int, pgcount, max_entries);
-
-		/* Find and handle non-leaf entries */
-		for (i = 0; i < num_entries; i++) {
-			pte = READ_ONCE(ptep[i]);
-			if (!pte) {
-				WARN_ON(!(data->iop.cfg.quirks & IO_PGTABLE_QUIRK_NO_WARN));
-				break;
-			}
-
-			if (!iopte_leaf(pte, lvl, iop->fmt)) {
-				__arm_lpae_clear_pte(&ptep[i], &iop->cfg, 1);
-
-				/* Also flush any partial walks */
-				io_pgtable_tlb_flush_walk(iop, iova + i * size, size,
-							  ARM_LPAE_GRANULE(data));
-				__arm_lpae_free_pgtable(data, lvl + 1, iopte_deref(pte, data));
-			}
-		}
-
-		/* Clear the remaining entries */
-		__arm_lpae_clear_pte(ptep, &iop->cfg, i);
-
-		if (gather && !iommu_iotlb_gather_queued(gather))
-			for (int j = 0; j < i; j++)
-				io_pgtable_tlb_add_page(iop, gather, iova + j * size, size);
-
-		return i * size;
-	} else if (iopte_leaf(pte, lvl, iop->fmt)) {
-		WARN_ONCE(true, "Unmap of a partial large IOPTE is not allowed");
-		return 0;
-	}
-
-	/* Keep on walkin' */
-	ptep = iopte_deref(pte, data);
-	return __arm_lpae_unmap(data, gather, iova, size, pgcount, lvl + 1, ptep);
-}
-
-static size_t arm_lpae_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
-				   size_t pgsize, size_t pgcount,
-				   struct iommu_iotlb_gather *gather)
-{
-	struct arm_lpae_io_pgtable *data = io_pgtable_ops_to_data(ops);
-	struct io_pgtable_cfg *cfg = &data->iop.cfg;
-	arm_lpae_iopte *ptep = data->pgd;
-	long iaext = (s64)iova >> cfg->ias;
-
-	if (WARN_ON(!pgsize || (pgsize & cfg->pgsize_bitmap) != pgsize || !pgcount))
-		return 0;
-
-	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_TTBR1)
-		iaext = ~iaext;
-	if (WARN_ON(iaext))
-		return 0;
+       struct arm_lpae_io_pgtable *data = io_pgtable_to_data(iop);
 
-	return __arm_lpae_unmap(data, gather, iova, pgsize, pgcount,
-				data->start_level, ptep);
+       __arm_lpae_free_pgtable(data, data->start_level, data->pgd);
+       kfree(data);
 }
 
 struct io_pgtable_walk_data {
diff --git a/drivers/iommu/io-pgtable-arm.h b/drivers/iommu/io-pgtable-arm.h
index ba7cfdf7afa0..c3a3b4fd44c3 100644
--- a/drivers/iommu/io-pgtable-arm.h
+++ b/drivers/iommu/io-pgtable-arm.h
@@ -2,29 +2,232 @@
 #ifndef IO_PGTABLE_ARM_H_
 #define IO_PGTABLE_ARM_H_
 
-#define ARM_LPAE_TCR_TG0_4K		0
-#define ARM_LPAE_TCR_TG0_64K		1
-#define ARM_LPAE_TCR_TG0_16K		2
-
-#define ARM_LPAE_TCR_TG1_16K		1
-#define ARM_LPAE_TCR_TG1_4K		2
-#define ARM_LPAE_TCR_TG1_64K		3
-
-#define ARM_LPAE_TCR_SH_NS		0
-#define ARM_LPAE_TCR_SH_OS		2
-#define ARM_LPAE_TCR_SH_IS		3
-
-#define ARM_LPAE_TCR_RGN_NC		0
-#define ARM_LPAE_TCR_RGN_WBWA		1
-#define ARM_LPAE_TCR_RGN_WT		2
-#define ARM_LPAE_TCR_RGN_WB		3
-
-#define ARM_LPAE_TCR_PS_32_BIT		0x0ULL
-#define ARM_LPAE_TCR_PS_36_BIT		0x1ULL
-#define ARM_LPAE_TCR_PS_40_BIT		0x2ULL
-#define ARM_LPAE_TCR_PS_42_BIT		0x3ULL
-#define ARM_LPAE_TCR_PS_44_BIT		0x4ULL
-#define ARM_LPAE_TCR_PS_48_BIT		0x5ULL
-#define ARM_LPAE_TCR_PS_52_BIT		0x6ULL
-
-#endif /* IO_PGTABLE_ARM_H_ */
+#include <linux/io-pgtable.h>
+
+typedef u64 arm_lpae_iopte;
+
+struct arm_lpae_io_pgtable {
+	struct io_pgtable	iop;
+
+	int			pgd_bits;
+	int			start_level;
+	int			bits_per_level;
+
+	void			*pgd;
+};
+
+#define ARM_LPAE_MAX_ADDR_BITS		52
+#define ARM_LPAE_S2_MAX_CONCAT_PAGES	16
+#define ARM_LPAE_MAX_LEVELS		4
+
+/* Struct accessors */
+#define io_pgtable_to_data(x)						\
+	container_of((x), struct arm_lpae_io_pgtable, iop)
+
+#define io_pgtable_ops_to_data(x)					\
+	io_pgtable_to_data(io_pgtable_ops_to_pgtable(x))
+
+/*
+ * Calculate the right shift amount to get to the portion describing level l
+ * in a virtual address mapped by the pagetable in d.
+ */
+#define ARM_LPAE_LVL_SHIFT(l,d)						\
+	(((ARM_LPAE_MAX_LEVELS - (l)) * (d)->bits_per_level) +		\
+	ilog2(sizeof(arm_lpae_iopte)))
+
+#define ARM_LPAE_GRANULE(d)						\
+	(sizeof(arm_lpae_iopte) << (d)->bits_per_level)
+#define ARM_LPAE_PGD_SIZE(d)						\
+	(sizeof(arm_lpae_iopte) << (d)->pgd_bits)
+
+#define ARM_LPAE_PTES_PER_TABLE(d)					\
+	(ARM_LPAE_GRANULE(d) >> ilog2(sizeof(arm_lpae_iopte)))
+
+/*
+ * Calculate the index at level l used to map virtual address a using the
+ * pagetable in d.
+ */
+#define ARM_LPAE_PGD_IDX(l,d)						\
+	((l) == (d)->start_level ? (d)->pgd_bits - (d)->bits_per_level : 0)
+
+#define ARM_LPAE_LVL_IDX(a,l,d)						\
+	(((u64)(a) >> ARM_LPAE_LVL_SHIFT(l,d)) &			\
+	 ((1 << ((d)->bits_per_level + ARM_LPAE_PGD_IDX(l,d))) - 1))
+
+/* Calculate the block/page mapping size at level l for pagetable in d. */
+#define ARM_LPAE_BLOCK_SIZE(l,d)	(1ULL << ARM_LPAE_LVL_SHIFT(l,d))
+
+/* Page table bits */
+#define ARM_LPAE_PTE_TYPE_SHIFT		0
+#define ARM_LPAE_PTE_TYPE_MASK		0x3
+
+#define ARM_LPAE_PTE_TYPE_BLOCK		1
+#define ARM_LPAE_PTE_TYPE_TABLE		3
+#define ARM_LPAE_PTE_TYPE_PAGE		3
+
+#define ARM_LPAE_PTE_ADDR_MASK		GENMASK_ULL(47,12)
+
+#define ARM_LPAE_PTE_NSTABLE		(((arm_lpae_iopte)1) << 63)
+#define ARM_LPAE_PTE_XN			(((arm_lpae_iopte)3) << 53)
+#define ARM_LPAE_PTE_DBM		(((arm_lpae_iopte)1) << 51)
+#define ARM_LPAE_PTE_AF			(((arm_lpae_iopte)1) << 10)
+#define ARM_LPAE_PTE_SH_NS		(((arm_lpae_iopte)0) << 8)
+#define ARM_LPAE_PTE_SH_OS		(((arm_lpae_iopte)2) << 8)
+#define ARM_LPAE_PTE_SH_IS		(((arm_lpae_iopte)3) << 8)
+#define ARM_LPAE_PTE_NS			(((arm_lpae_iopte)1) << 5)
+#define ARM_LPAE_PTE_VALID		(((arm_lpae_iopte)1) << 0)
+
+#define ARM_LPAE_PTE_ATTR_LO_MASK	(((arm_lpae_iopte)0x3ff) << 2)
+/* Ignore the contiguous bit for block splitting */
+#define ARM_LPAE_PTE_ATTR_HI_MASK	(ARM_LPAE_PTE_XN | ARM_LPAE_PTE_DBM)
+#define ARM_LPAE_PTE_ATTR_MASK		(ARM_LPAE_PTE_ATTR_LO_MASK |	\
+					 ARM_LPAE_PTE_ATTR_HI_MASK)
+/* Software bit for solving coherency races */
+#define ARM_LPAE_PTE_SW_SYNC		(((arm_lpae_iopte)1) << 55)
+
+/* Stage-1 PTE */
+#define ARM_LPAE_PTE_AP_UNPRIV		(((arm_lpae_iopte)1) << 6)
+#define ARM_LPAE_PTE_AP_RDONLY_BIT	7
+#define ARM_LPAE_PTE_AP_RDONLY		(((arm_lpae_iopte)1) << \
+					   ARM_LPAE_PTE_AP_RDONLY_BIT)
+#define ARM_LPAE_PTE_AP_WR_CLEAN_MASK	(ARM_LPAE_PTE_AP_RDONLY | \
+					 ARM_LPAE_PTE_DBM)
+#define ARM_LPAE_PTE_ATTRINDX_SHIFT	2
+#define ARM_LPAE_PTE_nG			(((arm_lpae_iopte)1) << 11)
+
+/* Stage-2 PTE */
+#define ARM_LPAE_PTE_HAP_FAULT		(((arm_lpae_iopte)0) << 6)
+#define ARM_LPAE_PTE_HAP_READ		(((arm_lpae_iopte)1) << 6)
+#define ARM_LPAE_PTE_HAP_WRITE		(((arm_lpae_iopte)2) << 6)
+/*
+ * For !FWB these code to:
+ *  1111 = Normal outer write back cachable / Inner Write Back Cachable
+ *         Permit S1 to override
+ *  0101 = Normal Non-cachable / Inner Non-cachable
+ *  0001 = Device / Device-nGnRE
+ * For S2FWB these code:
+ *  0110 Force Normal Write Back
+ *  0101 Normal* is forced Normal-NC, Device unchanged
+ *  0001 Force Device-nGnRE
+ */
+#define ARM_LPAE_PTE_MEMATTR_FWB_WB	(((arm_lpae_iopte)0x6) << 2)
+#define ARM_LPAE_PTE_MEMATTR_OIWB	(((arm_lpae_iopte)0xf) << 2)
+#define ARM_LPAE_PTE_MEMATTR_NC		(((arm_lpae_iopte)0x5) << 2)
+#define ARM_LPAE_PTE_MEMATTR_DEV	(((arm_lpae_iopte)0x1) << 2)
+
+/* Register bits */
+#define ARM_LPAE_VTCR_SL0_MASK		0x3
+
+#define ARM_LPAE_TCR_T0SZ_SHIFT		0
+
+#define ARM_LPAE_VTCR_PS_SHIFT		16
+#define ARM_LPAE_VTCR_PS_MASK		0x7
+
+#define ARM_LPAE_MAIR_ATTR_SHIFT(n)	((n) << 3)
+#define ARM_LPAE_MAIR_ATTR_MASK		0xff
+#define ARM_LPAE_MAIR_ATTR_DEVICE	0x04
+#define ARM_LPAE_MAIR_ATTR_NC		0x44
+#define ARM_LPAE_MAIR_ATTR_INC_OWBRWA	0xf4
+#define ARM_LPAE_MAIR_ATTR_WBRWA	0xff
+#define ARM_LPAE_MAIR_ATTR_IDX_NC	0
+#define ARM_LPAE_MAIR_ATTR_IDX_CACHE	1
+#define ARM_LPAE_MAIR_ATTR_IDX_DEV	2
+#define ARM_LPAE_MAIR_ATTR_IDX_INC_OCACHE	3
+
+#define ARM_MALI_LPAE_TTBR_ADRMODE_TABLE (3u << 0)
+#define ARM_MALI_LPAE_TTBR_READ_INNER	BIT(2)
+#define ARM_MALI_LPAE_TTBR_SHARE_OUTER	BIT(4)
+
+#define ARM_MALI_LPAE_MEMATTR_IMP_DEF	0x88ULL
+#define ARM_MALI_LPAE_MEMATTR_WRITE_ALLOC 0x8DULL
+
+#define ARM_LPAE_TCR_TG0_4K            0
+#define ARM_LPAE_TCR_TG0_64K           1
+#define ARM_LPAE_TCR_TG0_16K           2
+
+#define ARM_LPAE_TCR_TG1_16K           1
+#define ARM_LPAE_TCR_TG1_4K            2
+#define ARM_LPAE_TCR_TG1_64K           3
+
+#define ARM_LPAE_TCR_SH_NS             0
+#define ARM_LPAE_TCR_SH_OS             2
+#define ARM_LPAE_TCR_SH_IS             3
+
+#define ARM_LPAE_TCR_RGN_NC            0
+#define ARM_LPAE_TCR_RGN_WBWA          1
+#define ARM_LPAE_TCR_RGN_WT            2
+#define ARM_LPAE_TCR_RGN_WB            3
+
+#define ARM_LPAE_TCR_PS_32_BIT         0x0ULL
+#define ARM_LPAE_TCR_PS_36_BIT         0x1ULL
+#define ARM_LPAE_TCR_PS_40_BIT         0x2ULL
+#define ARM_LPAE_TCR_PS_42_BIT         0x3ULL
+#define ARM_LPAE_TCR_PS_44_BIT         0x4ULL
+#define ARM_LPAE_TCR_PS_48_BIT         0x5ULL
+#define ARM_LPAE_TCR_PS_52_BIT         0x6ULL
+
+/* IOPTE accessors */
+#define iopte_type(pte)					\
+	(((pte) >> ARM_LPAE_PTE_TYPE_SHIFT) & ARM_LPAE_PTE_TYPE_MASK)
+
+#define iopte_prot(pte)	((pte) & ARM_LPAE_PTE_ATTR_MASK)
+
+static inline bool iopte_leaf(arm_lpae_iopte pte, int lvl,
+			      enum io_pgtable_fmt fmt)
+{
+	if (lvl == (ARM_LPAE_MAX_LEVELS - 1) && fmt != ARM_MALI_LPAE)
+		return iopte_type(pte) == ARM_LPAE_PTE_TYPE_PAGE;
+
+	return iopte_type(pte) == ARM_LPAE_PTE_TYPE_BLOCK;
+}
+
+static inline bool iopte_table(arm_lpae_iopte pte, int lvl)
+{
+	if (lvl == (ARM_LPAE_MAX_LEVELS - 1))
+		return false;
+	return iopte_type(pte) == ARM_LPAE_PTE_TYPE_TABLE;
+}
+
+#define __arm_lpae_virt_to_phys        __pa
+#define __arm_lpae_phys_to_virt        __va
+
+static inline phys_addr_t iopte_to_paddr(arm_lpae_iopte pte,
+					 struct arm_lpae_io_pgtable *data)
+{
+	u64 paddr = pte & ARM_LPAE_PTE_ADDR_MASK;
+
+	if (ARM_LPAE_GRANULE(data) < SZ_64K)
+		return paddr;
+
+	/* Rotate the packed high-order bits back to the top */
+	return (paddr | (paddr << (48 - 12))) & (ARM_LPAE_PTE_ADDR_MASK << 4);
+}
+
+#define iopte_deref(pte, d) __arm_lpae_phys_to_virt(iopte_to_paddr(pte, d))
+
+static inline arm_lpae_iopte paddr_to_iopte(phys_addr_t paddr,
+					    struct arm_lpae_io_pgtable *data)
+{
+	arm_lpae_iopte pte = paddr;
+
+	/* Of the bits which overlap, either 51:48 or 15:12 are always RES0 */
+	return (pte | (pte >> (48 - 12))) & ARM_LPAE_PTE_ADDR_MASK;
+}
+
+/* Generic functions */
+int arm_lpae_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
+		       phys_addr_t paddr, size_t pgsize, size_t pgcount,
+		       int iommu_prot, gfp_t gfp, size_t *mapped);
+size_t arm_lpae_unmap_pages(struct io_pgtable_ops *ops, unsigned long iova,
+			    size_t pgsize, size_t pgcount,
+			    struct iommu_iotlb_gather *gather);
+
+/* Host/hyp-specific functions */
+void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp, struct io_pgtable_cfg *cfg, void *cookie);
+void __arm_lpae_free_pages(void *pages, size_t size, struct io_pgtable_cfg *cfg, void *cookie);
+void __arm_lpae_sync_pte(arm_lpae_iopte *ptep, int num_entries,
+			 struct io_pgtable_cfg *cfg);
+void __arm_lpae_free_pgtable(struct arm_lpae_io_pgtable *data, int lvl,
+			     arm_lpae_iopte *ptep);
+void arm_lpae_split_blk(void);
+#endif /* IO_PGTABLE_H_ */
\ No newline at end of file
-- 
2.50.1.552.g942d659e1b-goog

