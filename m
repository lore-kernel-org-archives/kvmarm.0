Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214EA2E92BC
	for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 21:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810068; cv=none; b=KFo1LNKktSTaMFzrNDRgiLbHK3uKwH1OSyAAyjWbZrVVZ+eTD619ZOv+axCP5ijazDEp1JNBYz9+S/a6ncSfTogWUnf8xiKjw7RSJ1Syn1TAy2aMOhYg+tYiBgldP1z+fIq0kaNTAMJw8bflogMjq6J5tEUKVzvvKPHXUhfRh+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810068; c=relaxed/simple;
	bh=nhSJVCmpiZAnQ9J/ToSaIbV5daafVSbDeh26hRnQmc4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JcYV5b98MVCTGttwBVB8PE6b4MT17K0co5UNkdA/YU2XtqRes14sRVyQUaqeN8K7YUV9D4K0aODDOtshmMkg6hHfS3UdWgnMmiUZ1RhxdEpTIrfT7KMuicDI0j4gJL6owGwbBmyVgSKf//UP3iA58rbjJhXnprNmj5BBFOrYDu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EczFbYi2; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EczFbYi2"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-323267b6c8eso2697157a91.1
        for <kvmarm@lists.linux.dev>; Thu, 21 Aug 2025 14:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755810066; x=1756414866; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=t56KCQK2GXd4bcu8tEhPvChuR1HmDcWVAdoQ7kOw4Pg=;
        b=EczFbYi2lEh4iK0Rp/OxuwbL0u1q/cThcH3UeWoKIyAV/yvUhEx8M6//+zSMEOfEG9
         7Ngg3iIqxAFrciWzcajoNvYAIAW3t6PN+VeXY1HIf3W7z3XQRAlOrXtFdb1flpCUTqwu
         aWv4UKdfdhxDUWD2MFyRUYm0KietplCBdx3j9HuXwxu3MsCDWo0pS8hh7/tZ4IpT18S9
         uIcvpoLsRQ8pjnOcaNYtaDG4GjjqqXZX2y0GDVZU3LL2bLPcZHBfFcaaqEaGzG1OiS+D
         xel4DvDiKtBCXzdUstEVt27oC79wFkLj/+mFL6zLdP+is2sp6rp7nw+KQpJkO//OJ8pJ
         zmOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810066; x=1756414866;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t56KCQK2GXd4bcu8tEhPvChuR1HmDcWVAdoQ7kOw4Pg=;
        b=ut2btfgTCIrmxbO1TigBLayhNKLKzXns7ya8dJidYXywqs5T8lDMD32PuJqYWK2YcV
         iF2ye+e+PDqBivpQhbUEKiZJbaRWAHjjccDDkZ+CPIavCkYa3Zix4C1yJWG3HtdTDij1
         hbxnuQAJua7z0WgHOootnXbfrD4UfRLFoc+pvC4OVvFA7Ye3TXJDQvcvSvDQBBgTYu6y
         YdTEAm8r3a5+b+y5pra8IRJy0BkK7ZUTAIK2xpCfuAbZeZr5wRx8u/Wo9elTIHTxNQAS
         xoFK9gtxJPxGbpxF4IOZ6RjYV5/10RNmzpE/AAMn7N+ck8LhHPBj1KsK8vjL2iGFGJmR
         Ul2A==
X-Forwarded-Encrypted: i=1; AJvYcCWghBzi4tQn9agpsect2S8iFZtH8Ezn3FsOod/9b1zf4CGjGo6A17kVIqIzpunPqNVux2fJEsQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwZlU25Og0jVxdGJnq2orWZNxVhT06R5IODVCxevS1+UiVfPGEy
	eZid+MgvCCY8ijFwtt4HFoquDuDQtQyKuJf5WklY78nfLGl6hxS3YMn0sZNXZxRQKbjeLcR8As9
	IXNMY4Q==
X-Google-Smtp-Source: AGHT+IHw3LANQDrDBKlkNtf6KJxEKR/eCogvGRPA0UduHlT9s+jfszYqmwrEB+leKuJDHCpQZAg5jVQxoNk=
X-Received: from pjbof13.prod.google.com ([2002:a17:90b:39cd:b0:31f:6a10:6ea6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:17d2:b0:311:f684:d3cd
 with SMTP id 98e67ed59e1d1-32515ef7240mr1204526a91.12.1755810066413; Thu, 21
 Aug 2025 14:01:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 21 Aug 2025 14:00:38 -0700
In-Reply-To: <20250821210042.3451147-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250821210042.3451147-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
Message-ID: <20250821210042.3451147-13-seanjc@google.com>
Subject: [RFC PATCH 12/16] KVM: arm64: Move VMA-related information into
 "struct kvm_page_fault"
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Stash the "outputs" from parsing the VMA associated with an abort in
kvm_page_fault.  This will allow moving the mmap_lock-protected section to
a separate helper without needing a pile of out-parameters.

Deliberately place "pagesize" outside of the "vma" sub-structure, as KVM
manipulates (restricts) the pagesize based on other state, i.e. it's not a
strict representation of the VMA.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  9 +++++
 arch/arm64/kvm/mmu.c              | 67 +++++++++++++++----------------
 2 files changed, 41 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ec6473007fb9..4d131be08d8d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -430,6 +430,15 @@ struct kvm_page_fault {
 	unsigned long hva;
 	kvm_pfn_t pfn;
 	struct page *page;
+
+	struct {
+		vm_flags_t vm_flags;
+		short pageshift;
+
+		bool is_cacheable;
+	} vma;
+
+	long pagesize;
 };
 
 /*
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b85968019dd4..aa6ee72bef51 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1470,18 +1470,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	int ret = 0;
 	bool writable, force_pte = false;
-	bool is_vma_cacheable;
 	bool s2_force_noncacheable = false;
 	unsigned long mmu_seq;
 	struct kvm *kvm = vcpu->kvm;
 	struct vm_area_struct *vma;
-	short vma_shift;
 	void *memcache;
 	bool logging_active = memslot_is_logging(fault->slot);
-	long vma_pagesize;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
-	vm_flags_t vm_flags;
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
 
 	VM_BUG_ON(fault->write && fault->exec);
@@ -1532,12 +1528,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	 */
 	if (logging_active) {
 		force_pte = true;
-		vma_shift = PAGE_SHIFT;
+		fault->vma.pageshift = PAGE_SHIFT;
 	} else {
-		vma_shift = get_vma_page_shift(vma, fault->hva);
+		fault->vma.pageshift = get_vma_page_shift(vma, fault->hva);
 	}
 
-	switch (vma_shift) {
+	switch (fault->vma.pageshift) {
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SHIFT:
 		if (fault_supports_stage2_huge_mapping(fault, PUD_SIZE))
@@ -1545,23 +1541,23 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		fallthrough;
 #endif
 	case CONT_PMD_SHIFT:
-		vma_shift = PMD_SHIFT;
+		fault->vma.pageshift = PMD_SHIFT;
 		fallthrough;
 	case PMD_SHIFT:
 		if (fault_supports_stage2_huge_mapping(fault, PMD_SIZE))
 			break;
 		fallthrough;
 	case CONT_PTE_SHIFT:
-		vma_shift = PAGE_SHIFT;
+		fault->vma.pageshift = PAGE_SHIFT;
 		force_pte = true;
 		fallthrough;
 	case PAGE_SHIFT:
 		break;
 	default:
-		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
+		WARN_ONCE(1, "Unknown VMA page shift %d", fault->vma.pageshift);
 	}
 
-	vma_pagesize = 1UL << vma_shift;
+	fault->pagesize = 1UL << fault->vma.pageshift;
 
 	if (fault->nested) {
 		unsigned long max_map_size;
@@ -1587,7 +1583,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			max_map_size = PAGE_SIZE;
 
 		force_pte = (max_map_size == PAGE_SIZE);
-		vma_pagesize = min(vma_pagesize, (long)max_map_size);
+		fault->pagesize = min(fault->pagesize, (long)max_map_size);
 	}
 
 	/*
@@ -1595,16 +1591,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	 * ensure we find the right PFN and lay down the mapping in the right
 	 * place.
 	 */
-	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE) {
-		fault->fault_ipa &= ~(vma_pagesize - 1);
-		fault->ipa &= ~(vma_pagesize - 1);
+	if (fault->pagesize == PMD_SIZE || fault->pagesize == PUD_SIZE) {
+		fault->fault_ipa &= ~(fault->pagesize - 1);
+		fault->ipa &= ~(fault->pagesize - 1);
 	}
 
 	fault->gfn = fault->ipa >> PAGE_SHIFT;
 
-	vm_flags = vma->vm_flags;
-
-	is_vma_cacheable = kvm_vma_is_cacheable(vma);
+	fault->vma.vm_flags = vma->vm_flags;
+	fault->vma.is_cacheable = kvm_vma_is_cacheable(vma);
 
 	/* Don't use the VMA after the unlock -- it may have vanished */
 	vma = NULL;
@@ -1624,7 +1619,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 				       fault->write ? FOLL_WRITE : 0,
 				       &writable, &fault->page);
 	if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
-		kvm_send_hwpoison_signal(fault->hva, vma_shift);
+		kvm_send_hwpoison_signal(fault->hva, fault->vma.pageshift);
 		return 0;
 	}
 	if (is_error_noslot_pfn(fault->pfn))
@@ -1634,8 +1629,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	 * Check if this is non-struct page memory PFN, and cannot support
 	 * CMOs. It could potentially be unsafe to access as cachable.
 	 */
-	if (vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(fault->pfn)) {
-		if (is_vma_cacheable) {
+	if (fault->vma.vm_flags & (VM_PFNMAP | VM_MIXEDMAP) &&
+	    !pfn_is_map_memory(fault->pfn)) {
+		if (fault->vma.is_cacheable) {
 			/*
 			 * Whilst the VMA owner expects cacheable mapping to this
 			 * PFN, hardware also has to support the FWB and CACHE DIC
@@ -1653,9 +1649,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		} else {
 			/*
 			 * If the page was identified as device early by looking at
-			 * the VMA flags, vma_pagesize is already representing the
+			 * the VMA flags, fualt->pagesize is already representing the
 			 * largest quantity we can map.  If instead it was mapped
-			 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
+			 * via __kvm_faultin_pfn(), fualt->pagesize is set to PAGE_SIZE
 			 * and must not be upgraded.
 			 *
 			 * In both cases, we don't let transparent_hugepage_adjust()
@@ -1704,22 +1700,22 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	 * If we are not forced to use page mapping, check if we are
 	 * backed by a THP and thus use block mapping if possible.
 	 */
-	if (vma_pagesize == PAGE_SIZE && !(force_pte || s2_force_noncacheable)) {
+	if (fault->pagesize == PAGE_SIZE && !(force_pte || s2_force_noncacheable)) {
 		if (fault->is_perm && fault->granule > PAGE_SIZE)
-			vma_pagesize = fault->granule;
+			fault->pagesize = fault->granule;
 		else
-			vma_pagesize = transparent_hugepage_adjust(kvm, fault);
+			fault->pagesize = transparent_hugepage_adjust(kvm, fault);
 
-		if (vma_pagesize < 0) {
-			ret = vma_pagesize;
+		if (fault->pagesize < 0) {
+			ret = fault->pagesize;
 			goto out_unlock;
 		}
 	}
 
 	if (!fault->is_perm && !s2_force_noncacheable && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
-		if (vm_flags & VM_MTE_ALLOWED) {
-			sanitise_mte_tags(kvm, fault->pfn, vma_pagesize);
+		if (fault->vma.vm_flags & VM_MTE_ALLOWED) {
+			sanitise_mte_tags(kvm, fault->pfn, fault->pagesize);
 		} else {
 			ret = -EFAULT;
 			goto out_unlock;
@@ -1733,7 +1729,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		prot |= KVM_PGTABLE_PROT_X;
 
 	if (s2_force_noncacheable) {
-		if (vm_flags & VM_ALLOW_ANY_UNCACHED)
+		if (fault->vma.vm_flags & VM_ALLOW_ANY_UNCACHED)
 			prot |= KVM_PGTABLE_PROT_NORMAL_NC;
 		else
 			prot |= KVM_PGTABLE_PROT_DEVICE;
@@ -1747,7 +1743,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	 * permissions only if vma_pagesize equals fault->granule. Otherwise,
 	 * kvm_pgtable_stage2_map() should be called to change block size.
 	 */
-	if (fault->is_perm && vma_pagesize == fault->granule) {
+	if (fault->is_perm && fault->pagesize == fault->granule) {
 		/*
 		 * Drop the SW bits in favour of those stored in the
 		 * PTE, which will be preserved.
@@ -1755,9 +1751,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		prot &= ~KVM_NV_GUEST_MAP_SZ;
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault->fault_ipa, prot, flags);
 	} else {
-		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault->fault_ipa, vma_pagesize,
-					     __pfn_to_phys(fault->pfn), prot,
-					     memcache, flags);
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault->fault_ipa,
+							 fault->pagesize,
+							 __pfn_to_phys(fault->pfn),
+							 prot, memcache, flags);
 	}
 
 out_unlock:
-- 
2.51.0.261.g7ce5a0a67e-goog

