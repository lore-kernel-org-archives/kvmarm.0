Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59D749505E
	for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 09:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790589315; cv=none; b=SKuVynsXzNGbXa7GXMibhYHbrxVrLJO62NzjlaS1xVgiVo5Li6LdWAb40zQT2GnV1FooKUJ+iGrljdgNN19Trb/aZVU26Mj1pxW1zI03GITQ+nHm6TQPRAal6+j86fJC8tx/tTVC0asYudwrfGoAmOtM3A0bmpniAUiN9ZajIHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790589315; c=relaxed/simple;
	bh=Uldbn5En6OPYyPLfYVtNtO8VmxfuNH8N0epTnTlvnCE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=INblx4UCI+pMca0d84y9E2M2Nvpd6Gs8Sc8iRVrjegXisCYLLzxov7weRFxEU3YbSucuccHHGgeXkMqjgi0jd0CuQ7o7VdVp/1C3BDBezghIqyBLRLtyH6aaeoE9rcSG6X3EHzMOq+TMbXmFMcMCvuFP3gfgsq63pTTA5KVyxHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KR5Nxs1q; arc=none smtp.client-ip=209.85.221.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KR5Nxs1q"
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48aec0407daso267307f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 28 Sep 2026 02:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790589311; x=1791194111; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6s7TcQLiDAVUqK9xqyJD7OqTbOBJcpTyEcdem8epSWc=;
        b=KR5Nxs1qOIAfCJMLz4EI5W02oSIU4d2bPHzhwHUwSSpHr4hePv3eEHIwXRvdDA1EIw
         xtVrctvjP0vlvAtaCzTnqxJEcYCTYPbtSv1jx14FoxwLyWJ2mDjwMaRm96l9JBlcgm6j
         t3vQ93KOL4CLAh8EoVYT+pSPr+Na0kIvN9T3V1fIfpZCG9D7B4b1NIgbpDdvWHiWxJE6
         pIF/CgqdKtyFAQ3O23llBjSSrBd9/TZhvjbWfg2oZbIg4L51dyvkyP3oDcG+Lp0+C0l8
         fBVEWbHs/a+pJLfo1assrC8TSK/tqFp66UJW5Y1jxyF+QBWHn8f0bgdJx8zIBwjoQfOI
         4YoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790589311; x=1791194111;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6s7TcQLiDAVUqK9xqyJD7OqTbOBJcpTyEcdem8epSWc=;
        b=zFZI9OGFSKK3PDcQPc52RsLgpn6/zdeZfd0swrxZ01xEM3krkcoqJJtGB02z3iE7p2
         FQ9gh7ZgGTGhAEjOwzU27+hgRqnHwiScKskXw+9v8gxGnCCkngWOqcVkV26kcDn5lu+f
         RjK7idhRYC1V0v0+H8SA/rQHqkAlI6iephHgMt5X85dGqLW+QO6ZFMwc9kpibc4VdpwY
         kOV3RFNdKAEE/jhatUMN+3X52JX6877T1egV4NVJmN0Wp8Mv82Za8SgQtykzhB/BN/Fk
         q75C3hPwWHdlXbm0LikbHfdoOZosiHqj66ivtW0880FL80ZVfts5EPQZ8mjgT16UIR/O
         HjuA==
X-Forwarded-Encrypted: i=1; AKwUvBzjzPhMDzvHVPGlf0+JyeFigFRkfLN7rB7hDkVHVjNGqWfIQQTP5Ji4rqnRNJKQFc0XZ7CtVf0=@lists.linux.dev
X-Gm-Message-State: AFuF++ndr2nkrRMnm4vZDgFrUsDs96aSIPqnzlkm1C/10CNfv876Q7iu
	wLXjyPpG++e4sjpt+po1JI/Ms0Z9Ygt7yR7LdThku3LNDTtP3HiwaPAQ/eWHodnVU9rksLUW+qV
	deqOo3gdD5e6RH3lm1ifZPA==
X-Received: from wmgb3.prod.google.com ([2002:a05:600c:1503:b0:49f:fec8:8e56])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:548e:b0:49f:ddc0:6e8f with SMTP id 5b1f17b1804b1-49fe66c86a2mr210815735e9.5.1790589307514;
 Mon, 28 Sep 2026 02:55:07 -0700 (PDT)
Date: Mon, 28 Sep 2026 10:54:52 +0100
In-Reply-To: <20260928095454.3255918-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260928095454.3255918-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928095454.3255918-4-vdonnefort@google.com>
Subject: [PATCH v2 3/4] KVM: arm64: Use kvm_s2_fault_vma_info in gmem_abort()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Fuad Tabba <fuad.tabba@linux.dev>

gmem_abort() maps at s2fd->fault_ipa, which HPFAR_EL2 holds at 4K
granularity whatever the page size. The generic page-table code aligns
it, but pkvm_pgtable_stage2_map() looks up existing mappings over
[addr, addr + size), so on a pKVM host with pages larger than 4K a
guest_memfd-backed guest that faults past the first 4K of a page can
find its neighbour's mapping, get -EAGAIN and take the same fault
forever.

The memory fault exit reports s2fd->fault_ipa too, which for a nested
guest's fault is the nested IPA rather than the canonical one
kvm_gmem_get_pfn() failed on.

Take the addresses from kvm_s2_fault_vma_info instead, as
user_mem_abort() does, and report the canonical gfn in the memory fault
exit. kvm_s2_fault_get_vma_info() itself isn't called: a guest_memfd
memslot's userspace_addr doesn't need to be backed by a VMA.

Fixes: a7b57e0995927 ("KVM: arm64: Handle guest_memfd-backed guest page faults")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/20260913175105.A57AC1F000FF@smtp.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/mmu.c | 67 ++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index dc55b0792e34..5c89b6684b02 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1615,6 +1615,24 @@ static enum kvm_pgtable_prot adjust_nested_exec_perms(struct kvm *kvm,
 	return prot;
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
+static gfn_t get_canonical_gfn(const struct kvm_s2_fault_desc *s2fd,
+			       const struct kvm_s2_fault_vma_info *s2vi);
+
 static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	bool write_fault, exec_fault;
@@ -1622,12 +1640,10 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
-	unsigned long mmu_seq;
-	struct page *page;
+	struct kvm_s2_fault_vma_info s2vi = {};
 	struct kvm *kvm = s2fd->vcpu->kvm;
 	void *memcache = NULL;
-	kvm_pfn_t pfn;
-	gfn_t gfn;
+	gfn_t canonical_gfn;
 	int ret;
 
 	if (!perm_fault) {
@@ -1637,24 +1653,23 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 			return ret;
 	}
 
-	if (s2fd->nested)
-		gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
-	else
-		gfn = s2fd->fault_ipa >> PAGE_SHIFT;
+	s2vi.vma_pagesize = PAGE_SIZE;
+	s2vi.gfn = ALIGN_DOWN(s2fd->fault_ipa, s2vi.vma_pagesize) >> PAGE_SHIFT;
+	canonical_gfn = get_canonical_gfn(s2fd, &s2vi);
 
 	write_fault = kvm_is_write_fault(s2fd->vcpu);
 	exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu);
 
 	VM_WARN_ON_ONCE(write_fault && exec_fault);
 
-	mmu_seq = kvm->mmu_invalidate_seq;
+	s2vi.mmu_seq = kvm->mmu_invalidate_seq;
 	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
 	smp_rmb();
 
-	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
+	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, canonical_gfn, &s2vi.pfn, &s2vi.page, NULL);
 	if (ret) {
-		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
-					      write_fault, exec_fault, false);
+		kvm_prepare_memory_fault_exit(s2fd->vcpu, gfn_to_gpa(canonical_gfn),
+					      s2vi.vma_pagesize, write_fault, exec_fault, false);
 		return ret;
 	}
 
@@ -1671,7 +1686,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 		prot = adjust_nested_exec_perms(kvm, s2fd->nested, prot);
 
 	kvm_fault_lock(kvm);
-	if (mmu_invalidate_retry(kvm, mmu_seq)) {
+	if (mmu_invalidate_retry(kvm, s2vi.mmu_seq)) {
 		ret = -EAGAIN;
 		goto out_unlock;
 	}
@@ -1682,39 +1697,25 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 		 * PTE, which will be preserved.
 		 */
 		prot &= ~KVM_NV_GUEST_MAP_SZ;
-		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, s2fd->fault_ipa,
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, gfn_to_gpa(s2vi.gfn),
 								 prot, flags);
 	} else {
-		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
-							 __pfn_to_phys(pfn), prot,
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(s2vi.gfn),
+							 s2vi.vma_pagesize,
+							 __pfn_to_phys(s2vi.pfn), prot,
 							 memcache, flags);
 	}
 
 out_unlock:
-	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
+	kvm_release_faultin_page(kvm, s2vi.page, !!ret, prot & KVM_PGTABLE_PROT_W);
 	kvm_fault_unlock(kvm);
 
 	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
-		mark_page_dirty_in_slot(kvm, s2fd->memslot, gfn);
+		mark_page_dirty_in_slot(kvm, s2fd->memslot, canonical_gfn);
 
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
-- 
2.56.0.rc1.315.gc6ed9934b7-goog

