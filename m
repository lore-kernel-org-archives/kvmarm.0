Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7203EEACB
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 16:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121024; cv=none; b=NyyQWq48/HCk4y1oGRK2wmbm4sw3tfBrkc6adrcGqvhj4NULpMJc4RlGoRJ01c5sG501hRko2y9RNd8W7YeVTikK0qTJBv1iHwwlZzmKrJEqr1E8KIndARxMjuwW2jcK9Mcpi5nM5fxYXxeGCwts31wj+Y7KxFfommpbmcUJ9kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121024; c=relaxed/simple;
	bh=WoOZLp8mrxOOu0Pc3Lyh8+preRrxVya03MwTvMjg4l4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D6UKY80v6uQtBXiUBk2kTgdZumPpFdMCbScEA9iRNc5T7ovPb5HyWor/UCA/1EotAMWCimydFaf9dkgtwnpu6gRP0nx55XDL6T0IDu+V2HsqK1otEcPfg1NL3LItCMCrazEvP4WsZq2Pri2/AW00QMJtFOJ8M04qyy/2VWT9J8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jt3WkX1b; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jt3WkX1b"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4955ce558d8so30735615e9.3
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 09:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786121020; x=1786725820; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8GYrEvMvff5zvEdtopJDUiIvGuJM4d42FcGqOwQV2a4=;
        b=jt3WkX1bzCpUvqRvEly4AHGCPuEbnhL5HmrSYLRkpO6YtedTH5jRzFGYAihxDZMrcQ
         44ZT3BkfEUwpWrM2O4FMqWrjP4l41hudborvnihp+b3lsv7aQDygSGUQUaMA1pb+kSI7
         NEbTPcQrHFVSxpqXhl5yIvfgzgDFQGlc+JAoWua8ho0oo4bIRTDHhWja72GevEzfvg/f
         AuEZPEovU4kbx4Xr3vL9SoQsOxU4jOhrfIK3WzR6ZN+13sP/w8FGX/z0pxSdJyUq8oSb
         mUWk1YoTzgk3JMrWbhcERbwzgKmhLoliImqHOvjROUV+WktO+mJl+uHJ+RJpekwdBA4Q
         x+Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121020; x=1786725820;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8GYrEvMvff5zvEdtopJDUiIvGuJM4d42FcGqOwQV2a4=;
        b=ADA0dPfRrX8B/XFc4MKFzBitTNpBKW0ennnXHzsOVJ0rvoxsUExaD7/PbR1VeaYypK
         rAYYT0qvACVRy4azAoJZJyS2DaTPLc7yO5sYs7TbrJWOEA/Dst/uWeawr85AB6I/CAhq
         sFZWSndqBj1d6yZp039/tRYDq9fe3796M3tnVntNNKLeGZBYRnmczmloxZIZFj2CyrqM
         NRdvwsRuEgQg2NVb+2fGElubcbxBPFrx+iOKKblYwtVZfzb+SJTXwpeNRvgqTepZz/GX
         Qk7RycD8y8wel4DkW4lCZFA05CXIyZ9jsfMV35JGQ6fN5cFVjsjfQ/42H05YZuns1L51
         1n+A==
X-Gm-Message-State: AOJu0YxBPbM2fS/DXD3xv7abYX0lG6wn4CaTu2J3Qy5UXhWuuB8eV7k9
	PKQ4ZM46yZ52VeXJtPCGSA0VzMPd35c5CnBioOxut7ktdu9oVNkfEqBLklOik7O2XYAXfQa35RD
	OqcxoR4c+/vJ2bv3EAn6L29DQFLPUjg==
X-Received: from wmbb14.prod.google.com ([2002:a05:600c:588e:b0:495:4a25:69f7])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d23:b0:499:51cc:4e57 with SMTP id 5b1f17b1804b1-499617f7699mr13301535e9.0.1786121019899;
 Fri, 07 Aug 2026 09:43:39 -0700 (PDT)
Date: Fri,  7 Aug 2026 16:43:11 +0000
In-Reply-To: <20260807164322.2970811-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260807164322.2970811-3-sebastianene@google.com>
Subject: [PATCH v2 01/13] KVM: arm64: Donate MMIO to the hypervisor
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, fuad.tabba@linux.dev, joey.gouly@arm.com, 
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, rananta@google.com, 
	Sascha.Bischoff@arm.com, suzuki.poulose@arm.com, will@kernel.org
Cc: kvmarm@lists.linux.dev, android-kvm@google.com, bgrzesik@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	nathan@kernel.org, perlarsen@google.com, sebastianene@google.com, 
	seiden@linux.ibm.com, smostafa@google.com, tglx@kernel.org, 
	vdonnefort@google.com, vladimir.murzin@arm.com, yuzenghui@huawei.com, 
	zenghui.yu@linux.dev
Content-Type: text/plain; charset="UTF-8"

From: Mostafa Saleh <smostafa@google.com>

Extend the pKVM API to allow the donation of MMIO from the host
address space to the hypervisor linear map.
Initialize the host s2 page table with an invalid leaf with the owner ID
of the hypervisor to prevent the host from mapping the page on faults.
Prevent kvm_pgtable_stage2_unmap() from removing owner ID from
stage-2 PTEs, as this can be triggered from recycle logic under memory
pressure.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   7 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 137 +++++++++++++++++-
 arch/arm64/kvm/hyp/pgtable.c                  |  11 +-
 3 files changed, 148 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 29935c7da1de..6aa83b129e61 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -36,6 +36,13 @@ int __pkvm_guest_share_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
 int __pkvm_guest_unshare_host(struct pkvm_hyp_vcpu *vcpu, u64 gfn);
 int __pkvm_host_unshare_hyp(u64 pfn);
 int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
+/*
+ * Donate MMIO range to the hypervisor, it will be mapped in the hypervisor's
+ * linea map and unmapped from the host stage-2.
+ */
+int __pkvm_host_donate_hyp_mmio(phys_addr_t addr, size_t size);
+/* Remaps MMIO range in the host, typically used in error path. */
+int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size);
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 4e329e39a695..5cf7c4a0ed20 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -378,7 +378,11 @@ static int host_stage2_unmap_dev_all(void)
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
@@ -1119,6 +1123,137 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages)
 	return ret;
 }
 
+int __pkvm_host_donate_hyp_mmio(phys_addr_t addr, size_t size)
+{
+	kvm_pte_t pte;
+	u64 offset;
+	void *virt;
+	int ret;
+
+	/* Only before de-privilege. */
+	if (static_branch_unlikely(&kvm_protected_mode_initialized))
+		return -EPERM;
+
+	if (!PAGE_ALIGNED(addr | size) ||
+	    !pfn_range_is_valid(hyp_phys_to_pfn(addr), size >> PAGE_SHIFT))
+		return -EINVAL;
+
+	host_lock_component();
+	hyp_lock_component();
+
+	for (offset = 0; offset < size; offset += PAGE_SIZE) {
+		if (addr_is_memory(addr + offset)) {
+			ret = -EINVAL;
+			goto err_with_mapping;
+		}
+
+		ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr + offset, &pte, NULL);
+		if (ret)
+			goto err_with_mapping;
+
+		if (pte && !kvm_pte_valid(pte)) {
+			ret = -EPERM;
+			goto err_with_mapping;
+		}
+
+		virt = __hyp_va(addr + offset);
+		ret = kvm_pgtable_get_leaf(&pkvm_pgtable, (u64)virt, &pte, NULL);
+		if (ret)
+			goto err_with_mapping;
+		if (pte) {
+			ret = -EBUSY;
+			goto err_with_mapping;
+		}
+
+		ret = pkvm_create_mappings_locked(virt, virt + PAGE_SIZE, PAGE_HYP_DEVICE);
+		if (ret)
+			goto err_with_mapping;
+	}
+
+	/*
+	 * We set HYP as the owner of the MMIO pages in the host stage-2, for:
+	 * - host aborts: host_stage2_adjust_range() would fail for invalid non zero PTEs.
+	 * - recycle under memory pressure: host_stage2_unmap_dev_all() would call
+	 *   kvm_pgtable_stage2_unmap() which will not clear non zero invalid ptes (counted).
+	 * - other MMIO donation: Would fail as we check that the PTE is valid or empty.
+	 */
+	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
+			      addr, size, &host_s2_pool,
+			      KVM_HOST_INVALID_PTE_TYPE_DONATION,
+			      FIELD_PREP(KVM_HOST_DONATION_PTE_OWNER_MASK, PKVM_ID_HYP));
+	if (ret)
+		goto err_with_mapping;
+unlock:
+	hyp_unlock_component();
+	host_unlock_component();
+	return ret;
+err_with_mapping:
+	if (!offset)
+		goto unlock;
+
+	while (offset) {
+		offset -= PAGE_SIZE;
+		virt = __hyp_va(addr + offset);
+		WARN_ON(kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)virt, PAGE_SIZE) != PAGE_SIZE);
+	}
+	goto unlock;
+}
+
+int __pkvm_hyp_donate_host_mmio(phys_addr_t addr, size_t size)
+{
+	kvm_pte_t pte;
+	u64 offset;
+	int ret = 0;
+	void *virt;
+
+	if (static_branch_unlikely(&kvm_protected_mode_initialized))
+		return -EPERM;
+
+	if (!PAGE_ALIGNED(addr | size) ||
+	    !pfn_range_is_valid(hyp_phys_to_pfn(addr), size >> PAGE_SHIFT))
+		return -EINVAL;
+
+	host_lock_component();
+	hyp_lock_component();
+
+	for (offset = 0; offset < size; offset += PAGE_SIZE) {
+		if (addr_is_memory(addr + offset)) {
+			ret = -EINVAL;
+			goto err_with_unmap;
+		}
+		ret = kvm_pgtable_get_leaf(&host_mmu.pgt, addr + offset, &pte, NULL);
+		if (ret)
+			goto err_with_unmap;
+		if (!pte || kvm_pte_valid(pte)) {
+			ret = -EINVAL;
+			goto err_with_unmap;
+		}
+		if (FIELD_GET(KVM_HOST_DONATION_PTE_OWNER_MASK, pte) != PKVM_ID_HYP) {
+			ret = -EPERM;
+			goto err_with_unmap;
+		}
+
+		virt = __hyp_va(addr + offset);
+		if (kvm_pgtable_hyp_unmap(&pkvm_pgtable, (u64)virt, PAGE_SIZE) != PAGE_SIZE)
+			goto err_with_unmap;
+	}
+	WARN_ON(host_stage2_idmap_locked(addr, size, PKVM_HOST_MMIO_PROT));
+unlock:
+	hyp_unlock_component();
+	host_unlock_component();
+	return ret;
+err_with_unmap:
+	if (!offset)
+		goto unlock;
+
+	while (offset) {
+		offset -= PAGE_SIZE;
+		virt = __hyp_va(addr + offset);
+		WARN_ON(pkvm_create_mappings_locked(virt, virt + PAGE_SIZE, PAGE_HYP_DEVICE));
+	}
+	goto unlock;
+}
+
 int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b74dd5ce1efd..7638213bd893 100644
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
+	 * That also ignores stage2_pte_is_counted() instead of clearing
+	 * the PTE as the MMIO can be owned by the hypervisor.
+	 */
+	if (!kvm_pte_valid(ctx->old))
 		return 0;
-	}
 
 	if (kvm_pte_table(ctx->old, ctx->level)) {
 		childp = kvm_pte_follow(ctx->old, mm_ops);
-- 
2.55.0.654.g21b8a5bc05-goog

