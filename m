Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F2A45348D
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116766; cv=none; b=cAA2SAnn7bX9yOtRtMdUtDf+plFRr4IxyDVD/xIwAI3Y/REKCnZJ8Qx8W2RfSKSYywb96K8rEWzEDIbT1WH1BfpqHR5iiQm6HiMSFHQojMxQOoaf9lTI4k9/nM6wclBBhIfWf/3fANB8xMk+2mvIDvC79YrKd9NZ8ULjcvg6EII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116766; c=relaxed/simple;
	bh=qCxK+JJaa38XcTX5702v5OnV9lqkbVBWQHIBYkDbADs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dIUU2k9CD3DI8ha6qDbq9O/zwKjCt/MfH7jraGMH3MWzVK6bBs6X8xBAwOTKeMCP+Fzap6bQxg5eKtfqKoU/zCStZ2NAH0OuB7KzNtF0s8Hhr2by5L+dhefMD3u1a9MmdFKHDVv8R5pjQqpwTc0kUAHiFMH2gT5v2/wcSmhv1QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Aww2IA8Q; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Aww2IA8Q"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4953c5d6d87so6751275e9.3
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116762; x=1784721562; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DulTGTw97uMRHQPlm6xWX2ICmo+Sh9dZV8TFaDf+QVU=;
        b=Aww2IA8Q3CCeyjm1Hl5LnssGvC2rV3IINE6MgiMbjGUm8qU5TymW5NIpxV1bZKodrG
         fxeCJ30yVdImXDoIjsMxjrDgpvUC+e8EVGjswl0JANALuJQvO8opz+W+tbDH85lAJLnt
         4NELhjtCNxOMOEe9TXkExei9b3u4Z2BiylyAIL5dUDlrT4bXw6g24QAuuYM69KH8OWcT
         eMNRoUZeiuG/P3l48RFtACIpm4O0A1u4XUn7wLezGCCywmCgUNhMGHsOngBWIXWvMJ/G
         HVAL8LBwrwd16DuP/eNiJmbsJR95h9UeG5YRDLSFHR9NK9R1trMH0RPcqLl+AVfguqzu
         WHeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116762; x=1784721562;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DulTGTw97uMRHQPlm6xWX2ICmo+Sh9dZV8TFaDf+QVU=;
        b=CNOJJc8MOjQnvV3y8EdC47nSAno6eDItysqNLPph/4H6MhC0utSoun4yp6jz+3HaQ+
         QwwXZa69rnZ8q3M7BhWIMwDhYz8czXUgTKJirhtOCAowHlXPS/65fe6C6e6KsdcN+4K5
         N9IudSx1s/pnSvwY5u7uzbjo8ghQ3T8O5pz9ydwVk9TmdiSJoWsVCld1D8Oed9P9FXoe
         UjV1VHdf1JVkMCD9d44XI3DfU48V+0jzXxYWVTRMSB6LoNZIKVOFZlMKkjvwJ/BMBui/
         VyDL3jrIeyWkvQfaST1wy2Mg/MISn5K8Y0R5yguagcrq86AFwRGZYslYD7D44rxfsN+o
         ve9g==
X-Forwarded-Encrypted: i=1; AHgh+Rqlu1rUq7ogUt5QxG/hll+ICxzQ3S0VA3PQj2FAHCCxzRtzR/1QniQ1yxjP+9ZPXezzkQxkFUY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYsLK1ipPeT6ibKMLsyBxN7OYzMdnPWtMq4rXSFr3Nlad6rPtR
	1hu127EZ9Fl4q8RC7FvkbeTvlDfyrTXp/0NaPxsc0F2iZxwUypHf6MR6bYACecIBUwuNEdx+SiD
	y2MW1KaSG/IybCw==
X-Received: from wmby15.prod.google.com ([2002:a05:600c:c04f:b0:493:bdba:620b])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:e557:20b0:493:f822:ac5e with SMTP id 5b1f17b1804b1-493f8818052mr132724075e9.23.1784116761502;
 Wed, 15 Jul 2026 04:59:21 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:58:48 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-8-smostafa@google.com>
Subject: [PATCH v7 07/24] KVM: arm64: iommu: Shadow host stage-2 page table
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
 arch/arm64/kvm/hyp/include/nvhe/iommu.h       |   4 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   1 +
 arch/arm64/kvm/hyp/nvhe/iommu.c               | 129 +++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  27 ++--
 4 files changed, 145 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index df3d0cc5d4db..857d7dd2ebc3 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -3,11 +3,15 @@
 #define __ARM64_KVM_NVHE_IOMMU_H__
 
 #include <asm/kvm_host.h>
+#include <asm/kvm_pgtable.h>
 
 struct pkvm_iommu_ops {
 	int (*init)(void);
+	int (*host_stage2_idmap)(phys_addr_t start, phys_addr_t end, int prot);
 };
 
 int pkvm_iommu_init(void);
 
+int pkvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
+				 enum kvm_pgtable_prot prot);
 #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 51b0eb3844a9..99b821b3cf65 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -59,6 +59,7 @@ int __pkvm_host_test_clear_young_guest(u64 gfn, u64 nr_pages, bool mkold, struct
 int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu);
 
 bool addr_is_memory(phys_addr_t phys);
+
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
 int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id);
 int kvm_host_prepare_stage2(void *pgt_pool_base);
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu.c
index ef456eff42d2..08009609ec59 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu.c
@@ -4,16 +4,137 @@
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
+	u64 start = ctx->addr;
+	u64 block_end = ALIGN_DOWN(ctx->addr, kvm_granule_size(ctx->level)) +
+			kvm_granule_size(ctx->level);
+	u64 end = min(ctx->end, block_end);
+	kvm_pte_t pte = *ctx->ptep;
+	bool is_memory = *(bool *)ctx->arg;
+	int prot;
+
+	/*
+	 * Keep annotated PTEs unmapped, and map everything else even lazily
+	 * mapped PTEs(0), as the IOMMU can't handle page faults.
+	 * That maps the whole address space which can be large, but that doesn't
+	 * use a lot of memory as it will be mostly large block (1 GB with 4kb pages)
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
+	return pkvm_iommu_snapshot_host_stage2();
+}
+
+int pkvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
+				enum kvm_pgtable_prot prot)
+{
+	hyp_assert_lock_held(&host_mmu.lock);
+
+	if (!pkvm_idmap_initialized)
+		return 0;
+
+	return pkvm_iommu_ops->host_stage2_idmap(start, end, pkvm_to_iommu_prot(prot));
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index d803b3dd4cb4..ce610274bda0 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -17,6 +17,7 @@
 
 #include <nvhe/arm-smccc.h>
 #include <nvhe/gfp.h>
+#include <nvhe/iommu.h>
 #include <nvhe/memory.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -596,16 +597,15 @@ static int host_stage2_set_owner_metadata_locked(phys_addr_t addr, u64 size,
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
+	return pkvm_iommu_host_stage2_idmap(addr, addr + size, 0);
 }
 
 int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
@@ -618,8 +618,10 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
 			return -EPERM;
 
 		ret = host_stage2_idmap_locked(addr, size, PKVM_HOST_MEM_PROT);
-		if (!ret)
-			__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
+		if (ret)
+			break;
+		__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
+		ret = pkvm_iommu_host_stage2_idmap(addr, addr + size, PKVM_HOST_MEM_PROT);
 		break;
 	case PKVM_ID_HYP:
 		ret = host_stage2_set_owner_metadata_locked(addr, size,
@@ -1022,6 +1024,7 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
 				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED),
 				       &vcpu->vcpu.arch.pkvm_memcache, 0));
 	WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED));
+	WARN_ON(pkvm_iommu_host_stage2_idmap(phys, phys + PAGE_SIZE, PKVM_HOST_MEM_PROT));
 unlock:
 	guest_unlock_component(vm);
 	host_unlock_component();
-- 
2.55.0.141.g00534a21ce-goog

