Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B154825A0
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094965; cv=none; b=nEkIvF1bGpvwlgyYFVBId7yYBC0VrrdrAI72FfulhNoAhAxI/uY48aQ4nDYJV9LF0fUfqL+fGlpqacJYJrAlKNnIbChfkFJqRCG8iLp7NCtd34ckpgMfn2Ce3F8YB8RCDYl47hxMZoGWXd4yQHrPSyBOTv3sqyOx7FI1LckCNzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094965; c=relaxed/simple;
	bh=nN7afVMv9gWA7IKhNgInm6BMrfDGvDudnzhw9n7dBpY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tKREnfW0IwcMPlQBtycMHHWVwxIkOaFA4WWacoFxRERpM6BcxGD+g0Q5eRfb7A8+Xq3lcLK8xxECOfp1OuW0OfECXMkMOoAfH4CR+Zy3rxZwy5bcL+CPOhkO3Msq4GFysY9hhBrDTj8FWvAe20v8WevjUwt3HBMNA2Zndx5Ss24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n/iRNB0f; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n/iRNB0f"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a027f2e364so39420965e9.3
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792094959; x=1792699759; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WtEQd+Mbv2A+20oTamxspD6VLu1dz9WsK6wgSsf9W6U=;
        b=n/iRNB0famaEmRANGgY+Pk/frrUX1DpIARTWHWZNERehzVn35qwkydlKgSTOgwld9g
         Yvl8D9t+V5HfD9qq4TgD6Zqd9ykDt4WhGk3h4ABhO+i5ru3WucjAmm3qgxp6M7+sxRhZ
         cpPVtfKckrzVrgsYIUvZcKS7zr1arYvObTIqY8cv2iv/iUzbEeA4DZoE4Gjot/KhV5gf
         p9hUThzQadgFdZXZFFF3Oc+na28E3X5+dybthJT+/NBgLKCNSSHkUCbyPTMYZwGJnLPj
         RMa8pcgevkXMjMa9Kfi+nBK54WkFrrFO4RJH4qQAse72yY5C9QVfYM1Qzi4yIx3EDc+w
         zweQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792094959; x=1792699759;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WtEQd+Mbv2A+20oTamxspD6VLu1dz9WsK6wgSsf9W6U=;
        b=poB49N5b3sPxYZevgTPEhJh/LxQiFVtxCfK02FCU3xgsGkvqLR01pUqABauhtXmH25
         wyKeLEqUNj+D2hJy7CxKM17HTSLlB/XyHqJ+ZbIevIfk8IzHFHncwSmQsQFNgfvkQqpA
         Zs5rdQGGALCync81d4X1d3DNgphJ8eE1xyZKpUXkD1pcEKwx/KlIKf6FNsUlIW+eEqP4
         7Pw/EGjNfw4JT7FzVfiKLFuDt5xlcsTsq+XZR0VP1AR8VMw6MluECYYWMoWyOb/PRFc6
         isWpTeX9Zn7whmJqCuSsr70t8PKeXmdtAl5kSF+0cjyiFzTIjZZRmWt9U3gP0aDo6T/o
         ijIg==
X-Forwarded-Encrypted: i=1; AKwUvBzCcqUqet+Tz5/e/L6QqZT6c5CB790IxS+ycBqppA2RYR9k6njtyf8Vz7kK/O1xiszOmIwgt9Q=@lists.linux.dev
X-Gm-Message-State: AFq9FYK2Acr5BLgl2100XWASZMdfSWQamEEVA+nuOQsk4p8GESwB0Fkr
	AAVoaD2rL4oHZu9aP0I//XKOpPiXd/Eh0MDupCx7/LRg7xlSsIO9PQ41r6hHV2v7/Pzh2HCiQlG
	hYUvmgv+m5PbN1w==
X-Received: from wmjs9.prod.google.com ([2002:a7b:c389:0:b0:4a1:8be5:4018])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6207:b0:49f:ff73:9971 with SMTP id 5b1f17b1804b1-4a18e4aff66mr402752955e9.18.1792094959086;
 Thu, 15 Oct 2026 13:09:19 -0700 (PDT)
Date: Thu, 15 Oct 2026 20:08:38 +0000
In-Reply-To: <20261015200903.2735565-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261015200903.2735565-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261015200903.2735565-8-smostafa@google.com>
Subject: [PATCH v9 07/25] KVM: arm64: iommu: Shadow host stage-2 page table
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	nicolinc@nvidia.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Create a page table for the IOMMU that shadows the host CPU stage-2 to
establish DMA isolation.

An initial snapshot is taken after the driver init, then on every
ownership change a callback is called for the IOMMU driver to update
its page table. The callback runs under host_mmu.lock, prot 0 unmaps,
and a range may already be mapped with the same prot.

There are 3 different ways to add the callback:
1) In the high level memory transitions (__pkvm_host_donate_hyp(),
   __pkvm_host_donate_guest(), ...).

2) In lower level functions covering all transitions:
   - host_stage2_set_owner_metadata_locked(), which covers
     __pkvm_host_donate_hyp(), __pkvm_host_donate_guest() and
     __pkvm_guest_unshare_host().
   - host_stage2_set_owner_locked() for PKVM_ID_HOST, which covers
     __pkvm_hyp_donate_host(), __pkvm_host_force_reclaim_page_guest()
     and __pkvm_host_reclaim_page_guest().
   - __pkvm_guest_share_host().

3) In the lowest level function __host_update_page_state(), which
   requires only one callback. However, the page state is not enough
   there as the old state is needed as well.

Option 2 is implemented here.

IOMMUs can't handle faults, so the snapshot maps everything the host
owns, including what it has not faulted in yet. Failures to update the
shadow are fatal, as WARN_ON() at EL2 panics, so a driver must
guarantee the update cannot fail. The SMMUv3 driver does so by mapping
memory at page granularity, so ownership changes never split a block,
and by sizing its page table pool accordingly.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/iommu.h |   9 ++
 arch/arm64/kvm/hyp/nvhe/iommu.c         | 123 +++++++++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c   |  27 +++---
 3 files changed, 143 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index df3d0cc5d4db..6cbcc9d65b4b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -3,11 +3,20 @@
 #define __ARM64_KVM_NVHE_IOMMU_H__
 
 #include <asm/kvm_host.h>
+#include <asm/kvm_pgtable.h>
 
 struct pkvm_iommu_ops {
 	int (*init)(void);
+	/*
+	 * Mirror [start, end) of the host stage-2 with IOMMU_* @prot, where 0
+	 * unmaps. Called with host_mmu.lock held. A range may already be mapped
+	 * with the same @prot, which must succeed.
+	 */
+	int (*host_stage2_idmap)(phys_addr_t start, phys_addr_t end, int prot);
 };
 
 int pkvm_iommu_init(void);
 
+int pkvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
+				 enum kvm_pgtable_prot prot);
 #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu.c
index f4572b2dba76..662b1ed2330f 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu.c
@@ -4,16 +4,131 @@
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
 struct pkvm_iommu_ops *pkvm_iommu_ops __ro_after_init;
 
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
+static int pkvm_iommu_snapshot_walker(const struct kvm_pgtable_visit_ctx *ctx,
+				      enum kvm_pgtable_walk_flags visit)
+{
+	bool is_memory = *(bool *)ctx->arg;
+	kvm_pte_t pte = ctx->old;
+	u64 start = ctx->addr;
+	u64 block_end, end;
+	int prot;
+
+	block_end = ALIGN_DOWN(ctx->addr, kvm_granule_size(ctx->level)) +
+			kvm_granule_size(ctx->level);
+	end = min(ctx->end, block_end);
+	/*
+	 * Annotated PTEs stay unmapped. Everything else is mapped, including
+	 * PTEs the host has not faulted in yet (0) to avoid page faults.
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
+		.cb	= pkvm_iommu_snapshot_walker,
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
index 75d250ca809c..c14af6a4877c 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -17,6 +17,7 @@
 
 #include <nvhe/arm-smccc.h>
 #include <nvhe/gfp.h>
+#include <nvhe/iommu.h>
 #include <nvhe/memory.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -611,16 +612,15 @@ static int host_stage2_set_owner_metadata_locked(phys_addr_t addr, u64 size,
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
@@ -633,8 +633,10 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
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
@@ -1049,6 +1051,7 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn)
 				       pkvm_mkstate(KVM_PGTABLE_PROT_RWX, PKVM_PAGE_SHARED_OWNED),
 				       &vcpu->vcpu.arch.pkvm_memcache, 0));
 	WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED));
+	WARN_ON(pkvm_iommu_host_stage2_idmap(phys, phys + PAGE_SIZE, PKVM_HOST_MEM_PROT));
 unlock:
 	guest_unlock_component(vm);
 	host_unlock_component();
-- 
2.56.0.176.g3575e65682-goog

