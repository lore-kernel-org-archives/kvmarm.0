Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1E039EF07
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634415; cv=none; b=D6Gn2oQqJ0+lqY+6bRxXR0qI8bEggmMx6c6JVvrOBi2FpUIDDlQgCPgWVJqyFn0kEa5hMcfVpFSrMVsKPlCT14K4HVMbp4vX08zMHrtFcAU8lS+37LYsSqQPU/8Juoyy94yacxHJNwLEmvsaffp0u221zq9N0Ba3jV0bIUE9ro4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634415; c=relaxed/simple;
	bh=4dvaQhefj/gLOS6fMysm6OEgJIPg+rENa3gunBbX4+k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VU0Z7I8D4pmTyDYFEqmjdsuFkNkSH6O6aDqlYDcJxV/sTlr8FcgqCWt+n7xCjIqr0ssph/y6RSk/GJaPpFx+zcFCXjdjSiYXg8OkaNCth+C/NQe+HESxBiMc2szCU9HT5j2F9O2SrvVU3m5MYOhM5ZRPxMQy+6v8CiVN16A/sZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ivh8PHUI; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ivh8PHUI"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4440c5944fbso1561414f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634409; x=1778239209; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FN4paQwo2ROc1ZHKgUwjGYJd1quRshkryUW2WW7y3qE=;
        b=Ivh8PHUIH5QlHC+20CDOXnYXXRwk59218WU6twhXtLR+mNhvY7uRWXw4DezPf71rvT
         ZDhXYo1MpiBMoi2Ed6IaBSTDw7HWHHNSIVL470iJygnKMB8yk+oBtIvyAf5KZ3MYgVEi
         QXGK9IkMhjS9Ba0ZttqRTAgpKIAzPUnYyjnX007u7umN2NJY2xxN7OXl8iGRTAO86iTD
         ir/dbmTvsM1K7tXC+Dtfu/wz526/3elkskCEbRj+hrBO2X/5aBmSRy7pe7l/3abvNXcA
         MV9P8b9rQREM56wkUI0f4C79Z5N6rKuNsBswtmqSFbw8SvwEL91T4uoJX7nJrKaKaFZ1
         8ODQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634409; x=1778239209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FN4paQwo2ROc1ZHKgUwjGYJd1quRshkryUW2WW7y3qE=;
        b=dQr9e91ie9mKsGk3ftaftgVWItW877nlxepexVPUuLGuI00hNDAsEtccz+nHH/kEGy
         ioYAxcFoM+2TK2VHqkkcAbGZyowNx69F9I+cP4PfGbFizy0CIfBH6xO/4v9ODahnQz9J
         EYI9me4lJUR+4WOCdkYrKnKTgsIClSdhiuYd7q3LcMqKOIok+XkBrrzxNhppjaM5aUnd
         l18JL7/cfvd8jNLXAHiSV/5zNzoaRxWWLjtEQNQk4uUKfwQm7S7kMmDVhb7VZKiZOaYq
         PBPfsPQCQz2C36m7q55NHnhY7fHnQiuRj8NVKPSWUN+/uy75fH4qnYarzk+wECdf6+3G
         96+w==
X-Forwarded-Encrypted: i=1; AFNElJ+l4wXBX79W4jWqfdz4UbPNTcxRplbWiUxk1tF1SgEyDVv8BjsLc07A/NxR0vDjLlgrqNuezOs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzyOfAPAERYPMboAYAVURfcXgmJR8ODXxOQCwXws0AibQNPfhUN
	aVZsVnPFdEo8wdMc0PbnHhnzkhlWVB7OB05cBRK/gWTm/PUaAwXhIJPG69lvcNlwatobzpAhzev
	6n1+8BclPKako6A==
X-Received: from wmlc6.prod.google.com ([2002:a7b:c846:0:b0:48a:8963:49ee])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:818c:b0:48a:5c23:cab with SMTP id 5b1f17b1804b1-48a8eb985b1mr43676235e9.19.1777634408826;
 Fri, 01 May 2026 04:20:08 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:10 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-9-smostafa@google.com>
Subject: [PATCH v6 08/25] KVM: arm64: iommu: Shadow host stage-2 page table
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	mark.rutland@arm.com, qperret@google.com, tabba@google.com, 
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com, 
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

Option #3 was implemented here.

For some cases, an SMMUv3 may be able to share the same page-table
used with the host CPU stage-2 directly.

However, this is too strict and requires changes to the core hypervisor
page-table code, plus it would require the hypervisor to handle IOMMU
page-faults. This can be added later as an optimization for SMMUV3.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/iommu.h       |   4 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +
 arch/arm64/kvm/hyp/nvhe/iommu/iommu.c         | 108 +++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  35 ++++++
 4 files changed, 146 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/iommu.h b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
index 1ac70cc28a9e..6277d845cdcf 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/iommu.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/iommu.h
@@ -3,11 +3,15 @@
 #define __ARM64_KVM_NVHE_IOMMU_H__
 
 #include <asm/kvm_host.h>
+#include <asm/kvm_pgtable.h>
 
 struct kvm_iommu_ops {
 	int (*init)(void);
+	int (*host_stage2_idmap)(phys_addr_t start, phys_addr_t end, int prot);
 };
 
 int kvm_iommu_init(void);
 
+int kvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
+				enum kvm_pgtable_prot prot);
 #endif /* __ARM64_KVM_NVHE_IOMMU_H__ */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index ff440204d2c7..f7faecc3b70a 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -54,6 +54,8 @@ int __pkvm_host_test_clear_young_guest(u64 gfn, u64 nr_pages, bool mkold, struct
 int __pkvm_host_mkyoung_guest(u64 gfn, struct pkvm_hyp_vcpu *vcpu);
 
 bool addr_is_memory(phys_addr_t phys);
+u64 find_mem_range_from(u64 start, bool *is_memory);
+
 int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
 int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id);
 int kvm_host_prepare_stage2(void *pgt_pool_base);
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
index 406c8fb9b3b9..1db52bd87c38 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/iommu.c
@@ -4,17 +4,119 @@
  *
  * Copyright (C) 2022 Linaro Ltd.
  */
+#include <linux/iommu.h>
+
 #include <nvhe/iommu.h>
+#include <nvhe/mem_protect.h>
+#include <nvhe/spinlock.h>
 
 /* Only one set of ops supported */
 struct kvm_iommu_ops *kvm_iommu_ops;
 
+/* Protected by host_mmu.lock */
+static bool kvm_idmap_initialized;
+
+static inline int pkvm_to_iommu_prot(enum kvm_pgtable_prot prot)
+{
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
+static int __snapshot_host_stage2(const struct kvm_pgtable_visit_ctx *ctx,
+				  enum kvm_pgtable_walk_flags visit)
+{
+	u64 start = ctx->addr;
+	u64 end = start + kvm_granule_size(ctx->level);
+	kvm_pte_t pte = *ctx->ptep;
+	bool is_memory;
+	u64 region_end;
+	int prot;
+	int ret;
+
+	/*
+	 * Keep annotated PTEs unmapped, and map everything else even lazily
+	 * mapped MMIO with pte == 0, as the IOMMU can't handle page faults.
+	 * That maps the whole address space which can be large, but that doesn't
+	 * use a lot of memory as it will be mostly large block (1 GB with 4kb pages)
+	 */
+	if (pte && !kvm_pte_valid(pte))
+		return 0;
+
+	if (kvm_pte_valid(pte)) {
+		prot = pkvm_to_iommu_prot(kvm_pgtable_stage2_pte_prot(pte));
+		/* If the range is mapped in a single PTE, it must be the same type.*/
+		if (!addr_is_memory(start))
+			prot |= IOMMU_MMIO;
+
+		return kvm_iommu_ops->host_stage2_idmap(start, end, prot);
+	}
+
+	/* In case of invalid PTE, we need to figure out which part of it is MMIO */
+	do {
+		prot = IOMMU_READ | IOMMU_WRITE;
+		region_end = find_mem_range_from(start, &is_memory);
+		region_end = min(end, region_end);
+		if (!is_memory)
+			prot |= IOMMU_MMIO;
+
+		ret = kvm_iommu_ops->host_stage2_idmap(start, region_end, prot);
+		if (ret)
+			return ret;
+
+		start = region_end;
+	} while (start < end);
+
+	return 0;
+}
+
+static int kvm_iommu_snapshot_host_stage2(void)
+{
+	int ret;
+	struct kvm_pgtable_walker walker = {
+		.cb	= __snapshot_host_stage2,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+	};
+	struct kvm_pgtable *pgt = &host_mmu.pgt;
+
+	hyp_spin_lock(&host_mmu.lock);
+	ret = kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker);
+	/* Start receiving calls to host_stage2_idmap. */
+	kvm_idmap_initialized = !ret;
+	hyp_spin_unlock(&host_mmu.lock);
+
+	return ret;
+}
 
 int kvm_iommu_init(void)
 {
-	/* Keep DMA isolation optional. */
-	if (!kvm_iommu_ops || !kvm_iommu_ops->init)
+	int ret;
+
+	if (!kvm_iommu_ops || !kvm_iommu_ops->init ||
+	    !kvm_iommu_ops->host_stage2_idmap)
+		return 0;
+
+	ret = kvm_iommu_ops->init();
+	if (ret)
+		return ret;
+
+	return kvm_iommu_snapshot_host_stage2();
+}
+
+int kvm_iommu_host_stage2_idmap(phys_addr_t start, phys_addr_t end,
+				enum kvm_pgtable_prot prot)
+{
+	hyp_assert_lock_held(&host_mmu.lock);
+
+	if (!kvm_idmap_initialized)
 		return 0;
 
-	return kvm_iommu_ops->init();
+	return kvm_iommu_ops->host_stage2_idmap(start, end, pkvm_to_iommu_prot(prot));
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2fb20a63a417..b54cb72ed88c 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -15,6 +15,7 @@
 #include <hyp/fault.h>
 
 #include <nvhe/gfp.h>
+#include <nvhe/iommu.h>
 #include <nvhe/memory.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/mm.h>
@@ -481,6 +482,14 @@ static int check_range_allowed_memory(u64 start, u64 end)
 	return 0;
 }
 
+u64 find_mem_range_from(u64 start, bool *is_memory)
+{
+	struct kvm_mem_range r;
+
+	*is_memory = !!find_mem_range(start, &r);
+	return r.end;
+}
+
 static bool range_is_memory(u64 start, u64 end)
 {
 	struct kvm_mem_range r;
@@ -577,8 +586,34 @@ int host_stage2_idmap_locked(phys_addr_t addr, u64 size,
 
 static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_state state)
 {
+	enum pkvm_page_state old = get_host_state(hyp_phys_to_page(addr));
+	enum kvm_pgtable_prot prot = 0;
+
 	for_each_hyp_page(page, addr, size)
 		set_host_state(page, state);
+
+	/*
+	 * Any transition to PKVM_NOPAGE, unmaps the page from the host
+	 * Any transition to PKVM_PAGE_SHARED_BORROWED, maps the page in the host
+	 * Any transition to PKVM_PAGE_SHARED_OWNED is ignored as page is already mapped.
+	 * Transitions to PKVM_PAGE_OWNED from anything but PKVM_NOPAGE are ignored.
+	 * Transitions to PKVM_PAGE_OWNED from PKVM_NOPAGE will map the page.
+	 */
+	if ((state == PKVM_PAGE_SHARED_OWNED) ||
+		((state == PKVM_PAGE_OWNED) && (old != PKVM_NOPAGE)))
+		return;
+
+	if ((state == PKVM_PAGE_SHARED_BORROWED) ||
+		(state == PKVM_PAGE_OWNED))
+		prot = PKVM_HOST_MEM_PROT;
+
+	/*
+	 * Only update the IOMMU from here, as MMIO can't transition after
+	 * de-privilege, that will need to change when device assignment
+	 * is supported.
+	 * And WARN on failure as we can't unroll at this point.
+	 */
+	WARN_ON(kvm_iommu_host_stage2_idmap(addr, addr + size, prot));
 }
 
 #define KVM_HOST_DONATION_PTE_OWNER_MASK	GENMASK(3, 1)
-- 
2.54.0.545.g6539524ca2-goog

