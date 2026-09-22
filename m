Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C893BF67A
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082787; cv=none; b=XkBWhV/Iv0rtqz7Hdg5IUYApeuMbTJIQiRWbOt8gmk0faIo20tOIceB6PBkIHp8derHDDIb84R1oGEQFhrdsxufxAbswxK2fXl2M1IEumXjHfV/OOVk+oFOYmXDd9qe/dSgt9TRXySRpRcIMqjfcMu7TefmOvSGXkjohmPYi9f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082787; c=relaxed/simple;
	bh=HJH2QXUBPgqpUJclWdNcfGheaL3rmVaX/VKNBzUznxo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=J3vo3thFTieGkIGY4Ec06QYz++wp+BfCOYbpQyCGrO2NrJzYQnq7T0pIuqPQhrEAm6Igy3K5QZWMZOJL+taGf20wveAUH3ezqB1HnOVPhe6zzGP56/nGgxpPNdkXPiWjadw3htYSws4UFipQg5NFRStuld1n/0pEo+vj/2WYEc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UwS7Zu+Z; arc=none smtp.client-ip=209.85.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UwS7Zu+Z"
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a615ab0c06so5302775a12.2
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082784; x=1790687584; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9k+hwbqCNy5PVLo73PwdABXDaZg+KPi4NbbBgA/NyFU=;
        b=UwS7Zu+Z50V2ckIlb/YHRoEFRGJeXX6MD+RoiT/aIc2AQNbzBK9I4gUkQawmejgMbi
         yF9xuxSwXupoExYwbyNTocs+JnrAied6Lft+PrmnPS+BoWXeGbREh6RLB29J3pZY+5Lx
         eMrbhjUmLHI1L+RQFGmWz/H/R75GdQyyeVyeNWL2pgXaqneTRo214dgBtz6R6bdmS1Qn
         ldxvi+vw13s7uxMhX7QhtMbQrF4SHStrq2ID9dRpcg6GOJaDuNATI7t6r4+HZH5aQgUZ
         mJVMdFqmnSzdgc6vWjnyZ2KqgGC/zEX4xiPeeTl5KplhIm7/fsCxe9YhOYWdNVpQij/g
         mcaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082784; x=1790687584;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9k+hwbqCNy5PVLo73PwdABXDaZg+KPi4NbbBgA/NyFU=;
        b=ZnKfw2rZIybn3f9BegPoQAOvzMkF9RMdcmhESyG01YCqnAfraBMaF662DDbYRWEXng
         bSHeTFmtB4mv42jW+RzgH+ZS28wvyWc4o+Edam5heJwH2Z5tvVAWt9ziv6ZxtiCPd6PW
         zpaodISQLnbJpzC1S7vazG9C2nrahlC3QHp4ueFC0vTm88yRHq/Fpdv/XVEtR8AwZZYQ
         hXOXMxjluSOmkmDNjpX1ra80c4b1HalEaoWU6/f644XhA29s8f039WfARfLIZJLrVqVt
         dcaYebhRleP15POnVAUmv3zVz503YRRsUItBt5wMRz9HO6MnkswfTyGlPe96B2UApu+4
         NUsA==
X-Forwarded-Encrypted: i=1; AKwUvBxee5tPbYRAFJIdu45/6gEnKJ67WAlcL4CdMcGdbEFn+AiZJ+RXtM9WNAJH0L//gSNVIpCJnJE=@lists.linux.dev
X-Gm-Message-State: AFuF++nPdviiZe/KAwIYq0/CUCBkBk0qFXHdKTqMZpIBhGu5/Kmhoxqd
	wn7SuzxLN/usPhGWtX5R1s3s8BlpVyjqrsLt0BsMfDc7IG3FIg694O3vTxqvNEA+z78lVZPhwcW
	O4BD59DdABmo5EQ==
X-Received: from edqi12.prod.google.com ([2002:aa7:c70c:0:b0:6a6:8910:5903])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:354f:b0:6a6:21d9:541f with SMTP id 4fb4d7f45d1cf-6aa57808b40mr13962900a12.6.1790082783578;
 Tue, 22 Sep 2026 06:13:03 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:12:34 +0000
In-Reply-To: <20260922131259.2975334-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922131259.2975334-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922131259.2975334-2-smostafa@google.com>
Subject: [PATCH v8 01/25] KVM: arm64: Donate MMIO to the hypervisor
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

Add a function to donate MMIO to the hypervisor so IOMMU hypervisor
drivers can protect and access the MMIO of IOMMUs.

As donating MMIO is very rare, and we don't need to encode the full
state, it's reasonable to have a separate function to do this.
It will init the host s2 page table with an invalid leaf with the owner ID
to prevent the host from mapping the page on faults.

Also, prevent kvm_pgtable_stage2_unmap() from removing owner ID from
stage-2 PTEs, as this can be triggered from recycle logic under memory
pressure. There is no code relying on this, as all ownership changes are
done via host_stage2_set_owner_locked().

For the error path in IOMMU drivers, add a function to donate MMIO
back from hyp to host. However, that leaks the hypervisor virtual
address range which should be acceptable as this is quite rare and
it matches the behaviour of fix_map/block.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h          |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  7 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 93 ++++++++++++++++++-
 arch/arm64/kvm/hyp/pgtable.c                  | 11 +--
 4 files changed, 105 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 41a8687938eb..223072b3e2cd 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -712,6 +712,7 @@ int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
  * containing the cleared entry is decremented, with unreferenced pages being
  * freed. Unmapping a cacheable page will ensure that it is clean to the PoC if
  * FWB is not supported by the CPU.
+ * This function can't be used to clear invalid counted PTEs (annotations).
  *
  * Return: 0 on success, negative error code on failure.
  */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 29935c7da1de..072f4b0e72c2 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -36,6 +36,13 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
 int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
+/*
+ * Donate MMIO range to the hypervisor, it will be mapped in the hypervisor's
+ * private range and unmapped from the host stage-2.
+ */
+int __pkvm_host_donate_hyp_mmio(u64 pfn, u64 nr_pages, unsigned long *haddr);
+/* Remaps MMIO range in the host, typically used in error path. */
+int __pkvm_hyp_donate_host_mmio(u64 pfn, u64 nr_pages);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 39aa8911f62c..c1a8fd811c0f 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -385,7 +385,11 @@ static int host_stage2_unmap_dev_all(void)
 	u64 addr = 0;
 	int i, ret;
 
-	/* Unmap all non-memory regions to recycle the pages */
+	/*
+	 * Unmap all non-memory regions to recycle the pages.
+	 * That relies on kvm_pgtable_stage2_unmap() not clearing
+	 * counted PTEs which include hypervisor MMIO.
+	 */
 	for (i = 0; i < hyp_memblock_nr; i++, addr = reg->base + reg->size) {
 		reg = &hyp_memory[i];
 		ret = kvm_pgtable_stage2_unmap(pgt, addr, reg->base - addr);
@@ -1126,6 +1130,93 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 	return ret;
 }
 
+int __pkvm_host_donate_hyp_mmio(u64 pfn, u64 nr_pages, unsigned long *haddr)
+{
+	u64 phys = hyp_pfn_to_phys(pfn);
+	u64 size = PAGE_SIZE * nr_pages;
+	kvm_pte_t pte;
+	u64 offset;
+	int ret;
+
+	/* Only before de-privilege. */
+	if (static_branch_unlikely(&kvm_protected_mode_initialized))
+		return -EPERM;
+
+	if (!pfn_range_is_valid(pfn, nr_pages))
+		return -EINVAL;
+
+	ret = __pkvm_create_private_mapping(phys, size, PAGE_HYP_DEVICE, haddr);
+	if (ret)
+		return ret;
+
+	host_lock_component();
+	for (offset = 0; offset < size; offset += PAGE_SIZE) {
+		if (addr_is_memory(phys + offset)) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+		ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys + offset, &pte, NULL);
+		if (ret)
+			goto unlock;
+		if (pte && !kvm_pte_valid(pte)) {
+			ret = -EPERM;
+			goto unlock;
+		}
+	}
+	/*
+	 * We set HYP as the owner of the MMIO pages in the host stage-2, for:
+	 * - host aborts: host_stage2_adjust_range() would fail for invalid non zero PTEs.
+	 * - recycle under memory pressure: host_stage2_unmap_dev_all() would call
+	 *   kvm_pgtable_stage2_unmap() which will not clear non zero invalid ptes (counted).
+	 * - other MMIO donation: Would fail as we check that the PTE is valid or empty.
+	 */
+	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
+			      phys, size, &host_s2_pool,
+			      KVM_HOST_INVALID_PTE_TYPE_DONATION,
+			      FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, PKVM_ID_HYP));
+unlock:
+	host_unlock_component();
+	return ret;
+}
+
+int __pkvm_hyp_donate_host_mmio(u64 pfn, u64 nr_pages)
+{
+	u64 phys = hyp_pfn_to_phys(pfn);
+	u64 size = PAGE_SIZE * nr_pages;
+	kvm_pte_t pte;
+	u64 offset;
+	int ret = 0;
+
+	if (static_branch_unlikely(&kvm_protected_mode_initialized))
+		return -EPERM;
+
+	if (!pfn_range_is_valid(pfn, nr_pages))
+		return -EINVAL;
+
+	host_lock_component();
+	for (offset = 0; offset < size; offset += PAGE_SIZE) {
+		if (addr_is_memory(phys + offset)) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+		ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys + offset, &pte, NULL);
+		if (ret)
+			goto unlock;
+		if (!pte || kvm_pte_valid(pte)) {
+			ret = -EINVAL;
+			goto unlock;
+		}
+		if (FIELD_GET(KVM_HOST_DONATION_PTE_OWNER_MASK, pte) != PKVM_ID_HYP) {
+			ret = -EPERM;
+			goto unlock;
+		}
+	}
+	WARN_ON(host_stage2_idmap_locked(phys, size, PKVM_HOST_MMIO_PROT));
+unlock:
+	host_unlock_component();
+	return ret;
+}
+
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b74dd5ce1efd..25af105855e5 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1161,13 +1161,12 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	kvm_pte_t *childp = NULL;
 	bool need_flush = false;
 
-	if (!kvm_pte_valid(ctx->old)) {
-		if (stage2_pte_is_counted(ctx->old)) {
-			kvm_clear_pte(ctx->ptep);
-			mm_ops->put_page(ctx->ptep);
-		}
+	/*
+	 * This check ignores stage2_pte_is_counted() instead of clearing
+	 * the PTE as it might be MMIO owned by the hypervisor.
+	 */
+	if (!kvm_pte_valid(ctx->old))
 		return 0;
-	}
 
 	if (kvm_pte_table(ctx->old, ctx->level)) {
 		childp = kvm_pte_follow(ctx->old, mm_ops);
-- 
2.55.0.1082.g2b9226bbc0-goog

