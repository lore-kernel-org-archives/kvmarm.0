Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B9D483BC4
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134693; cv=none; b=Cg8UxsOtHGo5wnKOFUkdnO1KATYNWaFgeGk0W622o/peGc33EhwM681jPTDHY96QNHlx/vudMwTWSxw5DItXql57DcIPc1mzLM7OV2MI6G4i8aaQaVKfYYBAzM3CoS//OZRzQ5xA8ZsqTz2mIMe0VVCNUdIHqKKov7fxDz9L+Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134693; c=relaxed/simple;
	bh=TE0cAbKkNONSltje7XKw6k0J1f52Sh0F4GqaUCYKuJE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Cfgu///wLlNccEwD5TWhMyHDSjI/mfXtRmMrEjKpjslnIpioJ1aPQ5YdoMbCLMI/xG8+aXfhCzvgHMw/z6A1zliABV/09E4cfBYx+It1SGslQpHt3q0RZW52En1777Htsax0QrhDqaEGc4CpVZXZpzof7BvtFiTrVnj3isNxLhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vojz6R/9; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vojz6R/9"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49cf9df1eadso9505855e9.3
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134688; x=1789739488; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rScGuJuSO3ZHRVhTtYzpAHUJbBJSFdkIzxRCkOokAS0=;
        b=Vojz6R/9AN0GIWBHVqOeawP7KQjHNmDN7NLFaIosJGZ7CsTbYTOh8arJSLaI5hBdqg
         3sG7L7CQ8dFbKFhWqOiLEre/ukS/rt0rJeMv3tojCnse18L/dycmWfYrir0Hf9A0yUA+
         nrXMsMmCWDTSYFel37EbVqhmindi+lYxK4uhuxrpN2DwVdsBzaY3HudusWYXtRISC+wD
         pBu3HJ1pl8Af2m6e+D4LUCZdk6MLzn1E/0nEONo/H7eeYprXdqmAXRULPQTdpxV5VbFm
         3DUGyMwh05v8yD212wNayn3A8PISzB+jDav4cgZEg/6LpgK5s7CzysLHY6n2zVHCwtie
         P8dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134688; x=1789739488;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rScGuJuSO3ZHRVhTtYzpAHUJbBJSFdkIzxRCkOokAS0=;
        b=Fr7de8UW483WYJE+utRcihCLThf6wPENalqECgzh4rvHx/HPTetae+zfrlhuRi+g+P
         MyaNEE8nJLVLaKV0+//k54/xLdxJVwYqtQr/+iLPLoYAiNmdP16pXm4e0m/yLicfwvDF
         Fhdax7fNpxMidB+nqpXDzyG0FodvYRPBBs9qg37k/N8in2YSHMtu+kfuoUGZujO8hNTw
         4/C2vKr4Sm4zzvOyXDvfjrtUxlF/oUd/l8BVS3eldS57Nq+1dhpntroAr0Y9l/jAGbXE
         RTGmwseoIvZlfnu+STZorpB9MzK4IOPp7FIIl4G3YfF6Xl8piOZ/3Sg/Y1Q1EWZWKZ6o
         NCIQ==
X-Forwarded-Encrypted: i=1; AKwUvBy5he7e69AUD3qjbaVAt4Olfpr+8fH+VnezQhyBwNfhF5lmYxEQIWYcFSpSswv3+eVQfBngML8=@lists.linux.dev
X-Gm-Message-State: AFuF++nXGI1qGLLdbqH3FhhQizc/q3MftmSPYsl4YxJL9auHMicxb8Is
	TJDFxvSqkNMB5+nxigk2TeO/iKHgSuyk4etj+Au6+PpPsodmWgfjtige/Xhh3qTXSE1W2ze74xm
	kdg4/O/mc66C3rd/cdC2JjQ==
X-Received: from wmoz7.prod.google.com ([2002:a05:600c:787:b0:49d:2665:3786])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d08:b0:49d:17d4:d6ad with SMTP id 5b1f17b1804b1-49e619c6178mr56309445e9.23.1789134687852;
 Fri, 11 Sep 2026 06:51:27 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:53 +0100
In-Reply-To: <20260911135053.146435-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260911135053.146435-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-23-vdonnefort@google.com>
Subject: [PATCH v2 22/22] KVM: arm64: Stage-2 huge mappings for protected VMs
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Enable PMD-sized stage-2 block mappings for protected VMs. This is
possible whenever the stage-1 mapping allows it, that is, if it is
itself backed by THPs.

When a THP is found, an entire PMD_SIZE mapping is donated to the guest.
This mapping can only be broken down via the HVC
__pkvm_host_split_guest() which the hypervisor can request with
PKVM_HYP_REQ_SPLIT.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/mmu.c  | 119 +++++++++++++++++++++++++++---------------
 arch/arm64/kvm/pkvm.c |  21 ++++----
 2 files changed, 89 insertions(+), 51 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ba86450fe4a..218df096c72e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1690,52 +1690,26 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
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
-static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
+static int pkvm_pin_user_pages(const struct kvm_s2_fault_desc *s2fd, struct page **__page,
+			       unsigned long *__size, kvm_pfn_t *__pfn, gfn_t *__gfn)
 {
 	unsigned int flags = FOLL_HWPOISON | FOLL_LONGTERM | FOLL_WRITE;
 	struct kvm_vcpu *vcpu = s2fd->vcpu;
-	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
 	struct mm_struct *mm = current->mm;
 	struct kvm *kvm = vcpu->kvm;
-	void *hyp_memcache;
 	struct page *page;
-	int ret;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+	long ret;
 
-	hyp_memcache = get_mmu_memcache(vcpu);
-	ret = topup_mmu_memcache(vcpu, hyp_memcache);
-	if (ret)
-		return -ENOMEM;
+	guard(mmap_read_lock)(mm);
 
-	ret = account_locked_vm(mm, 1, true);
-	if (ret)
-		return ret;
-
-	mmap_read_lock(mm);
 	ret = pin_user_pages(s2fd->hva, 1, flags, &page);
-	mmap_read_unlock(mm);
-
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
@@ -1751,29 +1725,90 @@ static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 		 * pages backed by swap in the knowledge that the GUP pin will
 		 * prevent try_to_unmap() from succeeding.
 		 */
-		ret = -EIO;
-		goto unpin;
+		unpin_user_page(page);
+		return -EIO;
 	}
 
+	pfn = page_to_pfn(page);
+	gfn = gpa_to_gfn(s2fd->fault_ipa);
+
+	ret = transparent_hugepage_adjust(kvm, s2fd->memslot, s2fd->hva, &pfn, &gfn);
+	if (ret < 0) {
+		unpin_user_page(page);
+		return ret;
+	} else if (ret == PMD_SIZE && WARN_ON_ONCE(folio_size(page_folio(page)) < PMD_SIZE)) {
+		unpin_user_page(page);
+		return -EINVAL;
+	}
+
+	*__page = page;
+	*__size = ret;
+	*__pfn = pfn;
+	*__gfn = gfn;
+
+	return 0;
+}
+
+static int pkvm_mem_abort(const struct kvm_s2_fault_desc *s2fd)
+{
+	struct kvm_vcpu *vcpu = s2fd->vcpu;
+	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
+	struct mm_struct *mm = current->mm;
+	struct kvm *kvm = vcpu->kvm;
+	unsigned long size;
+	void *hyp_memcache;
+	struct page *page;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+	int ret;
+
+	hyp_memcache = get_mmu_memcache(vcpu);
+	ret = topup_mmu_memcache(vcpu, hyp_memcache);
+	if (ret)
+		return -ENOMEM;
+
+	ret = pkvm_pin_user_pages(s2fd, &page, &size, &pfn, &gfn);
+	if (ret)
+		return ret;
+
+	ret = account_locked_vm(mm, size / PAGE_SIZE, true);
+	if (ret)
+		goto unpin;
+
 	write_lock(&kvm->mmu_lock);
-	ret = pkvm_pgtable_stage2_map(pgt, s2fd->fault_ipa, PAGE_SIZE,
-				      page_to_phys(page), KVM_PGTABLE_PROT_RWX,
-				      hyp_memcache, 0);
+	ret = pkvm_pgtable_stage2_map(pgt, gfn_to_gpa(gfn), size, __pfn_to_phys(pfn),
+				      KVM_PGTABLE_PROT_RWX, hyp_memcache, 0);
 	write_unlock(&kvm->mmu_lock);
 	if (ret) {
 		if (ret == -EAGAIN)
 			ret = 0;
+
+		account_locked_vm(mm, size / PAGE_SIZE, false);
 		goto unpin;
 	}
 
 	return 0;
+
 unpin:
-	unpin_user_pages(&page, 1);
-dec_account:
-	account_locked_vm(mm, 1, false);
+	unpin_user_page(page);
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
index 2840053ef2f4..6a4f35067642 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -446,9 +446,8 @@ static int __pkvm_pgtable_stage2_reclaim(struct kvm_pgtable *pgt, u64 start, u64
 			continue;
 
 		page = pfn_to_page(mapping->pfn);
-		WARN_ON_ONCE(mapping->nr_pages != 1);
 		unpin_user_pages_dirty_lock(&page, 1, true);
-		account_locked_vm(kvm->mm, 1, false);
+		account_locked_vm(kvm->mm, mapping->nr_pages, false);
 		pkvm_mapping_remove(mapping, &pgt->pkvm_mappings);
 		kfree(mapping);
 	}
@@ -513,17 +512,23 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
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
 
+		/*
+		 * If a huge mapping overlaps an existing PAGE_SIZE one,
+		 * then the VMM has played games with the stage-1. Abort.
+		 */
+		if (WARN_ON_ONCE(mapping && mapping->nr_pages == 1 && size > PAGE_SIZE))
+			return -EFAULT;
+
 		/*
 		 * We either raced with another vCPU or the guest PTE
 		 * has been poisoned by an erroneous host access.
@@ -533,10 +538,8 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
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
2.55.0.1007.g17ff1f9808-goog

