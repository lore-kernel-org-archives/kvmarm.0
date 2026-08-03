Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3985377AA0
	for <kvmarm@lists.linux.dev>; Mon,  3 Aug 2026 10:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785751883; cv=none; b=KWqQIYqD/U2Sx12RrzO9FLxz37U5a7X5M+MdYRwXfHZeOGarEzH+fxkWV7dpA6raNwh+O/QMAOR8ZFlDdgfyuNWuQEV2/LJVpzV1Vvdi5au/5nW/mVgNWzLjbc1D9Ntph9or3zUmCdLqY9kqyMboAwiKGs9RUZXhN56xwTeqLLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785751883; c=relaxed/simple;
	bh=qwSBlVUKzBvWM/p8QTL925sw3ZwMPNJKC2Wq8lix4n8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j3cbN+/fmnx4rSVFCRqZLTAKy1BMZ6iAsdkC3AdVCKhLkj47Je03KkU0DZ/h9TfwThMwR4aaawqa+XfT8KlTv7xJ5axc/dIIyUhzECEJGRMbKtQu8wQFqdhExNWopWb6oaVOff8rYDIF88w2Q0M2W0kYN411tITSMEdO5gtoG9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FUQ4dLsw; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FUQ4dLsw"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-495517d39fbso10545555e9.2
        for <kvmarm@lists.linux.dev>; Mon, 03 Aug 2026 03:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785751880; x=1786356680; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DWJpQyl/g2RqJgCgTY6pf6J8qG4fWAUjdjE8mT7VVHo=;
        b=FUQ4dLswU+i+QQPdrIwDBg5PAT00NFMyq9X++d2jOhJoeu+ZpXI1kEc+Vos9Q1kGw6
         VldPwpU76SDzkH9SvMrl9x4rS9jZz8hn9y390Pqj3HcpnZMiE3ZGLpqgsspKLKumRs9O
         XrSeO1oT/morRSGzczm/VL/MYnV3qqHIg3QaslVVzT8DfXuPfPn8vtDjkukS+rlbIGI6
         OEC36YP3+t9wlIF3K6hlsS2aSbL2rziQQE6vbUIyhGzl5je+D2LzG5g0DJCIRwnsAFPx
         PR0raaFonTEssxRJYV3+8pedMBZ1rhyzrzV/nZqcSuhfx6vVB7+IiJmqbSXxJLToMd5g
         FYkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785751880; x=1786356680;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DWJpQyl/g2RqJgCgTY6pf6J8qG4fWAUjdjE8mT7VVHo=;
        b=lnjE/CWBRRyro5ZEcQ+NSbdyXGIz2x8Z/4EKbypaCw3ordCV7BW4tOEd4jZg/GIVtf
         QK+IyUqjHSlyDSj+xUXhCqWFdu3WQzuTl+/Lz1MJKgUrf+fi4xy0yrsU1WSni50ANEVO
         pPZG4ExJ06phwY2FFzaCct+Ap/bh31Quv/ywHlF8v1SxfkCOm7RKiQJttj6V5Zg0QgJh
         CmNJOnvgsUudNchGbQuVzA0A6xFWtPCaZAFWGeLLxwAG1Po/Tet+M07G3e7E9uFg6syW
         sdFNjhyK743EPhJim2LIV3B9rM4EpCFHi/ii6ZqKvQb8fUukmuWMCwf7VT42n4Al7zIz
         /XFw==
X-Forwarded-Encrypted: i=1; AHgh+RpknUCkgq35jNz3tbYTXg1yWSDg7dP4W4EYpUTUpYAQdjgFE/nQEFnMK8Yz4r74c2kgdHf3RPw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLcJiQ0tM9O/e2LZy+jwe2byLpNURHu67ufZ4D6lDjT+9FdFOi
	lLil04cPK4TkkleG4cbNA6wYKiPdDpS+l5aAupuDvlJ7ISpIvwt0gjk/p2kAy70zthnlif+cPln
	/4Ig+pYHDp7kQ+t7ayGtbuQ==
X-Received: from wmpo6.prod.google.com ([2002:a05:600c:3386:b0:495:7ebf:e5b1])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3507:b0:496:cb48:5eb8 with SMTP id 5b1f17b1804b1-4980c6747fdmr128650365e9.15.1785751879451;
 Mon, 03 Aug 2026 03:11:19 -0700 (PDT)
Date: Mon,  3 Aug 2026 11:09:04 +0100
In-Reply-To: <20260803100904.3563942-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260803100904.3563942-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260803100904.3563942-21-vdonnefort@google.com>
Subject: [PATCH 20/20] KVM: arm64: Stage-2 huge mappings for protected VMs
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	keirf@google.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Enable PMD-sized stage-2 block mappings for protected VMs. This is
possible whenever the stage-1 mapping allows it, that is if it itself
backed by THPs.

When a THP is found, an entire PMD_SIZE mapping is donated to the guest.
This mapping can only be broken down via the HVC
__pkvm_host_split_guest() which the hypervisor can request with
PKVM_HYP_REQ_SPLIT.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6c941aaa10c6..46820240d233 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1690,21 +1690,6 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	return ret != -EAGAIN ? ret : 0;
 }
 
-struct kvm_s2_fault_vma_info {
-	unsigned long	mmu_seq;
-	long		vma_pagesize;
-	vm_flags_t	vm_flags;
-	unsigned long	max_map_size;
-	struct page	*page;
-	kvm_pfn_t	pfn;
-	gfn_t		gfn;
-	bool		device;
-	bool		mte_allowed;
-	bool		is_vma_cacheable;
-	bool		map_writable;
-	bool		map_non_cacheable;
-};
-
 static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
@@ -1714,6 +1699,9 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	struct kvm *kvm = vcpu->kvm;
 	void *hyp_memcache;
 	struct page *page;
+	long page_size;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
 	int ret;
 
 	hyp_memcache = get_mmu_memcache(vcpu);
@@ -1721,21 +1709,15 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	if (ret)
 		return -ENOMEM;
 
-	ret = account_locked_vm(mm, 1, true);
-	if (ret)
-		return ret;
-
 	mmap_read_lock(mm);
 	ret = pin_user_pages(s2fd->hva, 1, flags, &page);
 	mmap_read_unlock(mm);
 
 	if (ret == -EHWPOISON) {
 		kvm_send_hwpoison_signal(s2fd->hva, PAGE_SHIFT);
-		ret = 0;
-		goto dec_account;
+		return 0;
 	} else if (ret != 1) {
-		ret = -EFAULT;
-		goto dec_account;
+		return -EFAULT;
 	} else if (!folio_test_swapbacked(page_folio(page))) {
 		/*
 		 * We really can't deal with page-cache pages returned by GUP
@@ -1755,25 +1737,59 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 		goto unpin;
 	}
 
+	pfn = page_to_pfn(page);
+	gfn = gpa_to_gfn(s2fd->fault_ipa);
+
+	page_size = transparent_hugepage_adjust(kvm, s2fd->memslot, s2fd->hva, &pfn, &gfn);
+	if (page_size < 0) {
+		ret = page_size;
+		goto unpin;
+	} else if (page_size == PMD_SIZE) {
+		if (WARN_ON(!folio_test_large(page_folio(page)))) {
+			ret = -EINVAL;
+			goto unpin;
+		}
+	}
+
+	ret = account_locked_vm(mm, page_size / PAGE_SIZE, true);
+	if (ret)
+		goto unpin;
+
 	write_lock(&kvm->mmu_lock);
-	ret = pkvm_pgtable_stage2_map(pgt, s2fd->fault_ipa, PAGE_SIZE,
-				      page_to_phys(page), KVM_PGTABLE_PROT_RWX,
+	ret = pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(gfn), page_size,
+				      __pfn_to_phys(pfn), KVM_PGTABLE_PROT_RWX,
 				      hyp_memcache, 0);
 	write_unlock(&kvm->mmu_lock);
 	if (ret) {
 		if (ret == -EAGAIN)
 			ret = 0;
-		goto unpin;
+		goto dec_account;
 	}
 
 	return 0;
+
+dec_account:
+	account_locked_vm(mm, page_size / PAGE_SIZE, false);
 unpin:
 	unpin_user_pages(&page, 1);
-dec_account:
-	account_locked_vm(mm, 1, false);
 	return ret;
 }
 
+struct kvm_s2_fault_vma_info {
+	unsigned long	mmu_seq;
+	long		vma_pagesize;
+	vm_flags_t	vm_flags;
+	unsigned long	max_map_size;
+	struct page	*page;
+	kvm_pfn_t	pfn;
+	gfn_t		gfn;
+	bool		device;
+	bool		mte_allowed;
+	bool		is_vma_cacheable;
+	bool		map_writable;
+	bool		map_non_cacheable;
+};
+
 static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 				     struct kvm_s2_fault_vma_info *s2vi,
 				     struct vm_area_struct *vma)
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 089b77cf2f6a..0b591c44998d 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -454,9 +454,8 @@ static int __pkvm_pgtable_stage2_reclaim(struct kvm_pgtable *pgt, u64 start, u64
 			continue;
 
 		page = pfn_to_page(mapping->pfn);
-		WARN_ON_ONCE(mapping->nr_pages != 1);
 		unpin_user_pages_dirty_lock(&page, 1, true);
-		account_locked_vm(kvm->mm, 1, false);
+		account_locked_vm(kvm->mm, mapping->nr_pages, false);
 		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
 		kfree(mapping);
 	}
@@ -521,14 +520,13 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	u64 end = addr + size;
 	int ret;
 
+	if (WARN_ON_ONCE(size != PAGE_SIZE && size != PMD_SIZE))
+		return -EINVAL;
+
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	mapping = pkvm_mapping_iter_first(&pgt->pkvm_mappings, addr, end - 1);
 
 	if (kvm_vm_is_protected(kvm)) {
-		/* Protected VMs are mapped using RWX page-granular mappings */
-		if (WARN_ON_ONCE(size != PAGE_SIZE))
-			return -EINVAL;
-
 		if (WARN_ON_ONCE(prot != KVM_PGTABLE_PROT_RWX))
 			return -EINVAL;
 
@@ -541,10 +539,8 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			return ret ? -EFAULT : -EAGAIN;
 		}
 
-		ret = kvm_call_hyp_nvhe(__pkvm_host_donate_guest, pfn, gfn, 1);
+		ret = kvm_call_hyp_nvhe(__pkvm_host_donate_guest, pfn, gfn, size / PAGE_SIZE);
 	} else {
-		if (WARN_ON_ONCE(size != PAGE_SIZE && size != PMD_SIZE))
-			return -EINVAL;
 
 		/*
 		 * We either raced with another vCPU or we're changing between
-- 
2.55.0.508.g3f0d502094-goog

