Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DB13B7B79
	for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 09:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787734938; cv=none; b=n8OaDJnGT7gAJ+EAs4EEcHxuy085/b8Us0Zl6fSUnCmPvdUZPsmk32Gq92xmUq3WAuKxdvuvu5E4/fxWq7aEPiXRhmnEurKyFJWDmwX24lUbZSiSC6IvWpFG9+xwPDmsUWcR2LpOISMzmluWUCJE/dumlWD7489DQTYhTOosbRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787734938; c=relaxed/simple;
	bh=EuG4Bw/IwxonT7NoYlGbm2ezLAZ4QQJbygHjHjvFx1U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cZZv+soYA2RLVRRq7Kim+xowaBgepIJ22zOIHMQvcmBB+0SCx+LkzxpfySaGTM0iI255ALP1DZpv6euJGTOct+TvXn9cTaMlZjhVgr6VndeTvRsrp/eTx5FapQMBFyTx0e4q9yuV2rXPeXfHeVNSOWNlFdfBohzsSmd7NrKZ8VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qY0tyHA8; arc=none smtp.client-ip=209.85.214.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qY0tyHA8"
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d6f75c1219so16960585ad.3
        for <kvmarm@lists.linux.dev>; Wed, 26 Aug 2026 02:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787734931; x=1788339731; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jLtAYTqZ8m2gVWkFMzaTBxqNZtYSobzX0FvE5dD3wNU=;
        b=qY0tyHA8Uyz5QXvoF59mymr7mZCCCaOxiqqFOAfm7iU0z2igNi5rQqHlDpwolt47ne
         rTEYCnNO/BTjHlv1xFvDTQbKRiqHVGrrxPFzX9EM8zkl9LeBuONMoKgdb6a4EmtiMDMt
         6m4TwGbHnIadr+dZISoCZBJVWC6JYm0RGQyiVyIyEnIp3aX0NO94bRlAdoLLiKU+1Qdw
         JrxxtY74LmHfUEBvQgJR3GcOa7vBd+Yh6kSsKUUvWXeW9HGEAp8QUe3VRTi82aB6rOKV
         HkKhI5+CG/6F30+JKjhu3hHayiUr6cMDSZEUht45ogaSMPZjnSg79niV6UPLjS+kGiEV
         wq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787734931; x=1788339731;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jLtAYTqZ8m2gVWkFMzaTBxqNZtYSobzX0FvE5dD3wNU=;
        b=Oj/BAjTPZJKBQQKNDyWkzHWxVQfefe4fKgaRSEbplXdIi0LmctsyjN0Z1KQH8TgO9F
         pIJk2HiPG4GEmgBLcJoeQfNhx5ZQKzg+SpO0d/m+DaRwJtPumC4GDYrc3A9QLSvp5MuA
         NIMhaK1bI8K+56S8W6sQZFVNttTYRFCwUAdeKRY2OCyFnpmtqes0j1xUJDkFanvBaCS6
         GA3TIdVbD7SQtRhRCwWBxGAOdOmz3DyHJYETGmk4QkVZc/z0kGKi9XnJCMx0ab57pxP+
         5jiGSEbp8ZXdxg0uPeNZQSS8GZeysZfLnIDeLT9Oob2cvgu78vx+nKJ+2BCk8wEM7y2l
         YaaA==
X-Forwarded-Encrypted: i=1; AHgh+Rq+JvBYxxJxP3rCRz16yJ4enQTdjzv+2PZGegpq2JBdFScReBBZYJwPdQd4SBp838TWXgp9Ylc=@lists.linux.dev
X-Gm-Message-State: AFuF++kL1Zx4VJ3TyoId72uWuozs+hUmeNiepFsgePetvOZ70VMj9R9N
	4VKoGIn6UiHF4HjwXBqwbyyXK5bqUu2qBgWXcmcAiH96S5HxqxTHfvfGzPBJATPWeIsMY8Yp2dW
	NNYu718rPAz+etOQRZoEFmp2uXQ==
X-Received: from plkq13.prod.google.com ([2002:a17:902:edcd:b0:2cb:6ca0:1248])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:cf0f:b0:2cf:ccc2:6088 with SMTP id d9443c01a7336-2d7079d7abdmr97226905ad.4.1787734930475;
 Wed, 26 Aug 2026 02:02:10 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:01:50 +0000
In-Reply-To: <20260826-gmem-no-return-page-v4-0-3bb9c1ddb4e3@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260826-gmem-no-return-page-v4-0-3bb9c1ddb4e3@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787734920; l=8731;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=nQHQvdfVTe8YWF07i/KIfGAKndM7sUZ07Zir0Zm3JhM=; b=7O/YDRidiYyfgNPRedNkaCXKwFh2juYusyUvJu78qdc3QMByvSs6i/jUYXaHo7huBUVQkQgYa
 OlaPL1guJ3aBqO9gSzVN8dFDMXou2keyNE93y8J56B67HXEqHhNIYMx
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-no-return-page-v4-5-3bb9c1ddb4e3@google.com>
Subject: [PATCH v4 5/5] KVM: guest_memfd: Stop returning struct page from PFN lookup
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"

From: Sean Christopherson <seanjc@google.com>

KVM currently expects guest_memfd PFN lookups to return a refcounted struct
page, which callers hold across fault handling.

Drop the page's refcount before returning from kvm_gmem_get_pfn() to
prepare for the in-place conversions series.

CoCo shared-to-private conversion handling must inspect folio refcounts to
ensure exclusive ownership by guest_memfd. A concurrent guest page fault
taking a temporary reference on the folio causes conversions to fail due to
an elevated refcount.

While this refcount is also taken on host userspace page faults, that
refcount is taken on behalf of the host userspace page tables. This
refcount will be dropped when conversions unmaps the page. Either way, once
there's an mmap() or userspace mapping, the pages are open to way more
refcounts, transient or not. This patch focuses on just dropping refcounts
before handing KVM a page.

guest_memfd already notifies KVM of page invalidations, so callers within
KVM only need to respect the MMU invalidation protocol to safely rely on
guest_memfd for page presence.

Since the page refcounts are dropped, don't return the struct page pointer.

Not returning the struct page from the guest_memfd PFN lookup moves KVM
closer toward supporting memory backends that are not backed by struct
page.

Here are some notes on the cleanup in the callers of kvm_gmem_get_pfn():

kvm_release_faultin_page() in ARM's gmem_abort() originally also serves to
set the page dirty and accessed under some conditions. The dirty and
accessed flags don't matter for guest_memfd anyway, so it is safe to just
drop the call to kvm_release_faultin_page().

For ARM's kvm_translate_vncr(), the local page pointer must be initialized
to NULL so that the shared cleanup path that releases faulted-in pages
safely no-ops for guest_memfd.

For x86, no additional changes are required in the MMU fault path because
the page fault tracking structure is zero-initialized at the start of page
fault handling, ensuring the refcounted page pointer is already NULL.

Reported-by: Yan Zhao <yan.y.zhao@intel.com>
Closes: https://lore.kernel.org/all/anZ4W9o5pTWIEgMY@yzhao56-desk.sh.intel.com/
Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Michael Roth <michael.roth@amd.com>
Tested-by: Michael Roth <michael.roth@amd.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/arm64/kvm/mmu.c     | 4 +---
 arch/arm64/kvm/nested.c  | 4 ++--
 arch/x86/kvm/mmu/mmu.c   | 2 +-
 arch/x86/kvm/svm/sev.c   | 8 ++------
 include/linux/kvm_host.h | 6 ++----
 virt/kvm/guest_memfd.c   | 9 ++-------
 6 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9ba86450fe4af..d57f8181f1b7d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1613,7 +1613,6 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
 	unsigned long mmu_seq;
-	struct page *page;
 	struct kvm *kvm = s2fd->vcpu->kvm;
 	void *memcache = NULL;
 	kvm_pfn_t pfn;
@@ -1641,7 +1640,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
 	smp_rmb();
 
-	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
+	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, NULL);
 	if (ret) {
 		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
 					      write_fault, exec_fault, false);
@@ -1681,7 +1680,6 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	}
 
 out_unlock:
-	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
 	kvm_fault_unlock(kvm);
 
 	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 17123f0b6daba..dd62840d36741 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1415,7 +1415,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 	bool write_fault, writable;
 	unsigned long mmu_seq;
 	struct vncr_tlb *vt;
-	struct page *page;
+	struct page *page = NULL;
 	u64 va, pfn, gfn;
 	int ret;
 
@@ -1471,7 +1471,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 			return -EFAULT;
 		}
 	} else {
-		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
+		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, NULL);
 		if (ret) {
 			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
 					      write_fault, false, false);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 064ecc33b9267..947c9cd843450 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4628,7 +4628,7 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
 	}
 
 	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
-			     &fault->refcounted_page, &max_order);
+			     &max_order);
 	if (r) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return r;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f094b19226b92..0a887f8e05d3a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4032,7 +4032,6 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	struct kvm *kvm = vcpu->kvm;
 	gfn_t gfn = gpa_to_gfn(gpa);
 	unsigned long mmu_seq;
-	struct page *page;
 	kvm_pfn_t pfn;
 
 	lockdep_assert_held(&svm->sev_es.snp_vmsa_mutex);
@@ -4076,9 +4075,8 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	 * The new VMSA will be private memory guest memory, so retrieve the
 	 * PFN from the gmem backend.
 	 */
-	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL))
+	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, NULL))
 		return;
-	kvm_release_page_clean(page);
 
 	read_lock(&kvm->mmu_lock);
 	/*
@@ -5019,7 +5017,6 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	struct kvm *kvm = vcpu->kvm;
 	int order, rmp_level, ret;
 	unsigned long mmu_seq;
-	struct page *page;
 	bool assigned;
 	kvm_pfn_t pfn;
 	gfn_t gfn;
@@ -5049,13 +5046,12 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	mmu_seq = kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &page, &order);
+	ret = kvm_gmem_get_pfn(kvm, slot, gfn, &pfn, &order);
 	if (ret) {
 		pr_warn_ratelimited("SEV: Unexpected RMP fault, no backing page for private GPA 0x%llx\n",
 				    gpa);
 		return;
 	}
-	kvm_release_page_unused(page);
 
 	ret = snp_lookup_rmpentry(pfn, &assigned, &rmp_level);
 	if (ret || !assigned) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 03bfc92864b6e..502465119ca0c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2586,13 +2586,11 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
-		     int *max_order);
+		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order);
 #else
 static inline int kvm_gmem_get_pfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
-				   kvm_pfn_t *pfn, struct page **page,
-				   int *max_order)
+				   kvm_pfn_t *pfn, int *max_order)
 {
 	KVM_BUG_ON(1, kvm);
 	return -EIO;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b596486d184ca..589762140c3ef 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -751,8 +751,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 }
 
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
-		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
-		     int *max_order)
+		     gfn_t gfn, kvm_pfn_t *pfn, int *max_order)
 {
 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
 	struct folio *folio;
@@ -780,11 +779,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 #endif
 
 	folio_unlock(folio);
-
-	if (!r)
-		*page = folio_file_page(folio, index);
-	else
-		folio_put(folio);
+	folio_put(folio);
 
 	return r;
 }

-- 
2.55.0.887.g758fc8c411-goog

