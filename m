Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE9854B1BB
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082796; cv=none; b=GoCtUdrkoeIv6bIkaKEY+aFlBRClIQ0XESASNQgHBzFcH2Px494sRCcN+d1Ufr6EcHuSH/+GxwN0MI1Xt4ulAa3nQl359TtD/iHGEAf9KOW1MObsaQ4v8Kcgz+4IwekMt4ld079k1MADMyur4kWKbU3TJDGNZJ9uQMW8M6JNVG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082796; c=relaxed/simple;
	bh=xbuyuD7m+T78cNiaFlSg6x0NPRbFewgUSajy6FUdgro=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KSlMB61TvsMPxlT3JzsyszY9yUGa8+qSJddpc0sqwI8fTGNOFS8c1dzK69pQd2hGMNiBsovq9gEBZwQFfjlTVAIEk1gmyia8xziskYRnGMT+2R4juvZa7O00BIlzEE6iGLZfCauq1CJA679lB8m7NWqpG+C9qTAc883ju1SUUvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TIkDs6W7; arc=none smtp.client-ip=209.85.218.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TIkDs6W7"
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c293bac1764so544754566b.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082791; x=1790687591; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sDuWVFH5V4FiR6BdcPE/C+w+yXFCclhAIaiZorXFLeo=;
        b=TIkDs6W7Xc/bH3No/NN99ODTl2JYi+C6KyI2yvVLfvYhA3Tx4uRbn7Ga/H/HTSMSXY
         G7D9cKBkwA0+vgI+sUnS3FrKLu38xYeGtfgHYXhk7UfdrJL0XLX+2fajg6UDxb0UTJx1
         e7n/SUYnPrS2zJPvKydKkoQ/HSXPDqBkh2KG4i7FPRMNQxMaYstQ2L3lofVTsDg4xe/W
         dVchzGPzRfeS8Zr2bD8Ys5sbns7TQnWjbpcJH/L/PJdsAqqSjQCykvW/XmNAgJZMx3s4
         uqOVh5x0e1JtPOhax3blJBop26twpbIMCnjl7XOJjxRrtbmMs9wjaEaG2cGkf8Lz/Bt8
         /C/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082791; x=1790687591;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sDuWVFH5V4FiR6BdcPE/C+w+yXFCclhAIaiZorXFLeo=;
        b=gL2XiBpWZpNtdKKSQbPHXIRM9rV8YgwKZrPMR82Ob3uwNgU5+6aedKVCFN0/JrutSx
         7xd8Qmxkz7WFHz+8YnTOCVarqzMfrA++kFyVnkcruiT8FlvERisPqucRTOJb1Tvab3H2
         lAMxpY9/zWd8u3tSXKtRF9+vYzdFWLv5plkKXtnC3kngnJIfsGxmrYmZBd86TB8TGEGK
         Khsr6Ff0IIDDgKgbz4S/G1Gz8aKXpullfV/+u5JfSOPBG3vCrx1/DiSmX+v48eT3fLjR
         wnuJKaNnpsoZpPYyGiOONAHBaAJBkmgrbZRiIZ5xwcaNOejYcObyqFVtLLEejpzUNs0+
         qraQ==
X-Forwarded-Encrypted: i=1; AKwUvBzQVNP8zwEvE5vfRgEXQBTfdeaKxCoRM/eOtBW4rffkm8ReNV4dAvjJGRQDmVEpQmg0BsbpWX0=@lists.linux.dev
X-Gm-Message-State: AFuF++kTP6yF1UBKHbObSBE1vmKvoa3W+rXOvNNdbsUEqNGsVtWap6jm
	9R52MiHetVFXrU5DyHbZnpCmrvZDgYPjw0tezAcwSbH2UzrohnIJC4xP/n8gsODuoQQWfaEyblv
	QgFPSajX4cXufeQ==
X-Received: from ejju2.prod.google.com ([2002:a17:906:4082:b0:c29:d1be:19ab])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:c10b:b0:c29:4490:50c8 with SMTP id a640c23a62f3a-c2a156a4424mr1226800666b.8.1790082790896;
 Tue, 22 Sep 2026 06:13:10 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:12:40 +0000
In-Reply-To: <20260922131259.2975334-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922131259.2975334-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922131259.2975334-8-smostafa@google.com>
Subject: [PATCH v8 07/25] KVM: arm64: iommu: Shadow host stage-2 page table
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Create a page-table for the IOMMU that shadows the host CPU stage-2
to establish DMA isolation.

An initial snapshot is created after the driver init, then
on every permission change a callback would be called for
the IOMMU driver to update the page table.

There are 3 different ways to add the callback:
1) In the high level memory transitions: (__pkvm_host_donate_hyp(),
  __pkvm_host_donate_guest()...

2) In Lower level functions covering all transitions
  - host_stage2_set_owner_metadata_locked() which covers:
   - __pkvm_host_donate_hyp()
   - __pkvm_host_donate_guest()
   - __pkvm_host_donate_hyp()
   - __pkvm_guest_unshare_host()
  - host_stage2_set_owner_locked() only for ID_HOST which covers:
   - __pkvm_hyp_donate_host()
   - __pkvm_host_force_reclaim_page_guest()
   - __pkvm_host_reclaim_page_guest()
  - __pkvm_guest_share_host()

3) In the lowest level function __host_update_page_state(), which
   requires only one callback. However, in that case the page state
   is not enough as we might need to know the old state also.

Option #2 was implemented here.

For some cases, an SMMUv3 may be able to share the same page-table
used with the host CPU stage-2 directly.

However, this is too strict and requires changes to the core hypervisor
page-table code, plus it would require the hypervisor to handle IOMMU
page-faults. This can be added later as an optimization for SMMUV3.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/iommu.h |   5 +
 arch/arm64/kvm/hyp/nvhe/iommu.c         | 130 +++++++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   |  27 ++---
 3 files changed, 146 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index 83abe1a443c6..2e35ec01c75d 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -2,10 +2,15 @@
 #ifndef __ARM64_KVM_NVHE_IOMMU_H__
 #define __ARM64_KVM_NVHE_IOMMU_H__
 
+#include <asm/kvm_pgtable.h>
+
 struct pkvm_iommu_ops {
 	int (*init)(void);
+	int (*host_stage2_idmap)(phys_addr_t start, phys_addr_t end, int prot);
 };
 
 int pkvm_iommu_init(void);
 
+int pkvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
+				 enum kvm_pgtable_prot prot);
 #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu.c
index ef456eff42d2..3637b0327d9e 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu.c
@@ -4,16 +4,138 @@
  *
  * Copyright (C) 2022 Linaro Ltd.
  */
+#include <linux/iommu.h>
+#include <asm/kvm_pkvm.h>
+
 #include <nvhe/iommu.h>
+#include <nvhe/mem_protect.h>
+#include <nvhe/spinlock.h>
 
 /* Only one set of ops supported */
 struct pkvm_iommu_ops *pkvm_iommu_ops;
 
-int pkvm_iommu_init(void)
+/* Protected by host_mmu.lock */
+static bool pkvm_idmap_initialized;
+
+static inline int pkvm_to_iommu_prot(enum kvm_pgtable_prot prot)
 {
-	/* Keep DMA isolation optional. */
-	if (!pkvm_iommu_ops || !pkvm_iommu_ops->init)
+	int iommu_prot = 0;
+
+	if (prot & KVM_PGTABLE_PROT_R)
+		iommu_prot |= IOMMU_READ;
+	if (prot & KVM_PGTABLE_PROT_W)
+		iommu_prot |= IOMMU_WRITE;
+
+	/* We don't understand that, might be dangerous. */
+	WARN_ON(prot & ~PKVM_HOST_MEM_PROT);
+	return iommu_prot;
+}
+
+/*
+ * IOMMU page tables are shadowed and not shared, that is mainly because:
+ * - Possible inconsistency between IOMMU and CPU features or format.
+ * - KVM relies on handling in page faults (BBM, lazy mapping).
+ */
+static int __snapshot_host_stage2(const struct kvm_pgtable_visit_ctx *ctx,
+				  enum kvm_pgtable_walk_flags visit)
+{
+	bool is_memory = *(bool *)ctx->arg;
+	kvm_pte_t pte = *ctx->ptep;
+	u64 start = ctx->addr;
+	u64 block_end, end;
+	int prot;
+
+	block_end = ALIGN_DOWN(ctx->addr, kvm_granule_size(ctx->level)) +
+			kvm_granule_size(ctx->level);
+	end = min(ctx->end, block_end);
+	/*
+	 * Keep annotated PTEs unmapped, and map everything else even lazily
+	 * mapped PTEs (0), as the IOMMU can't handle page faults.
+	 * That maps the whole address space which can be large, but that doesn't
+	 * use a lot of memory as it will be mostly large blocks (1 GB with 4kb pages)
+	 */
+	if (pte && !kvm_pte_valid(pte))
 		return 0;
 
-	return pkvm_iommu_ops->init();
+	if (kvm_pte_valid(pte))
+		prot = pkvm_to_iommu_prot(kvm_pgtable_stage2_pte_prot(pte));
+	else
+		prot = IOMMU_READ | IOMMU_WRITE;
+
+	if (!is_memory)
+		prot |= IOMMU_MMIO;
+
+	return pkvm_iommu_ops->host_stage2_idmap(start, end, prot);
+}
+
+static int pkvm_iommu_snapshot_host_stage2(void)
+{
+	struct kvm_pgtable *pgt = &host_mmu.pgt;
+	bool is_memory;
+	struct kvm_pgtable_walker walker = {
+		.cb	= __snapshot_host_stage2,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.arg	= &is_memory,
+	};
+	int ret = 0, i;
+	u64 start = 0;
+
+	hyp_spin_lock(&host_mmu.lock);
+	for (i = 0; i < hyp_memblock_nr; i++) {
+		struct memblock_region *reg = &hyp_memory[i];
+
+		if (start < reg->base) {
+			is_memory = false;
+			ret = kvm_pgtable_walk(pgt, start, reg->base - start, &walker);
+			if (ret)
+				goto out_unlock;
+		}
+
+		is_memory = true;
+		ret = kvm_pgtable_walk(pgt, reg->base, reg->size, &walker);
+		if (ret)
+			goto out_unlock;
+
+		start = reg->base + reg->size;
+	}
+
+	if (start < BIT(pgt->ia_bits)) {
+		is_memory = false;
+		ret = kvm_pgtable_walk(pgt, start, BIT(pgt->ia_bits) - start, &walker);
+		if (ret)
+			goto out_unlock;
+	}
+
+	pkvm_idmap_initialized = true;
+
+out_unlock:
+	hyp_spin_unlock(&host_mmu.lock);
+	return ret;
+}
+
+int pkvm_iommu_init(void)
+{
+	int ret;
+
+	/* Keep DMA isolation optional. */
+	if (!pkvm_iommu_ops || !pkvm_iommu_ops->init ||
+	    !pkvm_iommu_ops->host_stage2_idmap)
+		return 0;
+
+	ret = pkvm_iommu_ops->init();
+	if (ret)
+		return ret;
+
+	return WARN_ON(pkvm_iommu_snapshot_host_stage2());
+}
+
+int pkvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
+				 enum kvm_pgtable_prot prot)
+{
+	hyp_assert_lock_held(&host_mmu.lock);
+
+	if (!pkvm_idmap_initialized)
+		return 0;
+
+	return pkvm_iommu_ops->host_stage2_idmap(start, end, pkvm_to_iommu_prot(prot));
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index c1a8fd811c0f..da5014e4e96b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -17,6 +17,7 @@
 
 #include <nvhe/arm-smccc.h>
 #include <nvhe/gfp.h>
+#include <nvhe/iommu.h>
 #include <nvhe/memory.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -603,16 +604,15 @@ static int host_stage2_set_owner_metadata_locked(phys_addr_t addr, u64 size,
 	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
 			      addr, size, &host_s2_pool,
 			      KVM_HOST_INVALID_PTE_TYPE_DONATION, annotation);
-	if (!ret) {
-		/*
-		 * After stage2 maintenance has happened, but before the page
-		 * owner has changed.
-		 */
-		pkvm_sme_dvmsync_fw_call();
-		__host_update_page_state(addr, size, PKVM_NOPAGE);
-	}
-
-	return ret;
+	if (ret)
+		return ret;
+	/*
+	 * After stage2 maintenance has happened, but before the page
+	 * owner has changed.
+	 */
+	pkvm_sme_dvmsync_fw_call();
+	__host_update_page_state(addr, size, PKVM_NOPAGE);
+	return WARN_ON(pkvm_iommu_host_stage2_idmap(addr, addr + size, 0));
 }
 
 int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
@@ -625,8 +625,10 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
 			return -EPERM;
 
 		ret = host_stage2_idmap_locked(addr, size, PKVM_HOST_MEM_PROT);
-		if (!ret)
-			__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
+		if (ret)
+			break;
+		__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
+		ret = WARN_ON(pkvm_iommu_host_stage2_idmap(addr, addr + size, PKVM_HOST_MEM_PROT));
 		break;
 	case PKVM_ID_HYP:
 		ret = host_stage2_set_owner_metadata_locked(addr, size,
@@ -1029,6 +1031,7 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
 				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED),
 				       &vcpu->vcpu.arch.pkvm_memcache, 0));
 	WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED));
+	WARN_ON(pkvm_iommu_host_stage2_idmap(phys, phys + PAGE_SIZE, PKVM_HOST_MEM_PROT));
 unlock:
 	guest_unlock_component(vm);
 	host_unlock_component();
-- 
2.55.0.1082.g2b9226bbc0-goog

