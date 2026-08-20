Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C73390CB0
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 23:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787268772; cv=none; b=PGCClH1Ca1drEiFm/7RdUUIP6YN7+Ot19/jBJ+ABBI0MUwltmoszvpa77WriElBUi1XgRYqm9zruweQuC3+Nq3XhiG4y6B11OqbaUQxvudRasoRKadcpt1XXtALHwdPHGZ9zwjo0b77/HsMRMw9F6Q72pu3eZQwBpi4/zXumUj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787268772; c=relaxed/simple;
	bh=V0844XDUaiC4ETf5m0/3GwaxcmEs1sPKQ6XCUhjT6uU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rU56jAG2mmuHnSbVhBRWK/31MhHdww++WtaLWD4jPC4wX7CYmkiFGpNdXPK7aKAuurqbKX9V3bbheS0mbt38GBo4gZczY7UhB0KLU/bXqTcBTYIiN7EHP55GzKEjB3qtcaiZhMlh2w1VvaFh6Z9/WHNocNQr//1Zi7zxFKNAh08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l0qj8Gii; arc=none smtp.client-ip=209.85.215.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l0qj8Gii"
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-ca6bd8a190cso566845a12.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 16:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787268767; x=1787873567; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9NvhMH8LFCh3/0u1wEtokGC4+3va98pYMprwb3y631M=;
        b=l0qj8GiiMmbJaf2Lu8MxrsTtZdenztKya/Ch790v4KTYPWsGQodx0QBy6Ioo/laUJu
         oS5g/RkGi/BMrz78o+2X+gR6o2VlkKzlD+OwdjZcreAOFMOlCnyD4228Et6WvW0hrNoI
         eHm6Nd251fxSQshzUneR0HtTwWtS/ru745LPsuvj8UdahJ0mp1AU7z4HORLvFUlvuiwn
         zju12h9tX61IZvE02apD3gpgzoYjARcDrRY7CXPDvgXxRupKBrwMVWdbW3r+xeRhhgwW
         gZMBzbq5B0CnokGgMJ7eCHniVsP4fumS3+6AEFEOkXt3XMn4DITCZIU7I3lFTxyybtO8
         LO9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787268767; x=1787873567;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9NvhMH8LFCh3/0u1wEtokGC4+3va98pYMprwb3y631M=;
        b=TIerxVNPsk27Dl07F4h4tUmlvi/QBpLSDk4wnZZDrGmL9TGsBXtDf6AI9Oh2T99k29
         t6H6qfFZa93VF5bxiQFR5n7vIZYHB9TlIihKG4/B5y9wUN5uKkj7nHH+D9JvQE7WPHgM
         59g+54S77DP0RjzLgt4v3STTU1K5PYkg6RIbg2QGtlQJOOnYNzWP1Qsacrx+6WSotljX
         0IspzQkO8e5iBpehyq98f5FRVoi3UKq0WNa6iaqTLWGzPtqfRrTQ32rCX24sBMXqS29z
         PaT5nm3yJXki+VxmdEl+99X7acg+cnHnATr45UEZHPnywqAFU5JQ6I+ZDVALUzGNjR/r
         ISlg==
X-Forwarded-Encrypted: i=1; AHgh+RqZ4Q4w1A/k36VmOA5OyEwPiJVKuglcCudz12iQogwMXiYIdxokWDsI0XeHlhX/mKjT2GXIRjQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9OqVRZZ93iR04ZSiAw9HkFx0jKa4VauyHwRHmry9KVg+2aCcA
	g1qSwQBWTUwqqwlZwDSueTo6fSNOgR3iXVdRuOkYI+ApMzmj3o6Yqx71jg9GRcGZzHKLWwZWUpr
	ooWL+UYIOvs9HLdDDtKlPP3Ti2A==
X-Received: from pgjy4.prod.google.com ([2002:a63:e244:0:b0:cbe:e120:3788])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:398f:b0:3cc:927e:354c with SMTP id adf61e73a8af0-3cd2ff856eemr3908156637.9.1787268766599;
 Thu, 20 Aug 2026 16:32:46 -0700 (PDT)
Date: Thu, 20 Aug 2026 23:32:37 +0000
In-Reply-To: <20260820-gmem-no-return-page-v3-0-3bf8f80a7b4d@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260820-gmem-no-return-page-v3-0-3bf8f80a7b4d@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787268758; l=8695;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=lcx/24pBzxlhDBLvNFneOWtKer1iGrC3lCfSbNoE1G0=; b=L25LalXat+4IJQtZBKTQDY5PKYB5/a2gKB/oT9uzNrzfjgKHFT0zNxAKJrMso425248SEaQnV
 1i6Mmgk5aOtDARee023YcLu9d5IyDft7uGiLX3IsGph58jOXZ2ousBY
X-Mailer: b4 0.16.0
Message-ID: <20260820-gmem-no-return-page-v3-4-3bf8f80a7b4d@google.com>
Subject: [PATCH v3 4/4] KVM: guest_memfd: Stop returning struct page from PFN lookup
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Michael Roth <michael.roth@amd.com>, Brijesh Singh <brijesh.singh@amd.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>, Fuad Tabba <tabba@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>
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
index 6c941aaa10c63..d5aa197d2cbfd 100644
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
index fb54f6dad995c..43523bb17621a 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1360,7 +1360,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 	bool write_fault, writable;
 	unsigned long mmu_seq;
 	struct vncr_tlb *vt;
-	struct page *page;
+	struct page *page = NULL;
 	u64 va, pfn, gfn;
 	int ret;
 
@@ -1411,7 +1411,7 @@ static int kvm_translate_vncr(struct kvm_vcpu *vcpu, bool *is_gmem)
 		if (is_error_noslot_pfn(pfn) || (write_fault && !writable))
 			return -EFAULT;
 	} else {
-		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, &page, NULL);
+		ret = kvm_gmem_get_pfn(vcpu->kvm, memslot, gfn, &pfn, NULL);
 		if (ret) {
 			kvm_prepare_memory_fault_exit(vcpu, vt->wr.pa, PAGE_SIZE,
 					      write_fault, false, false);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c519e8e8d646f..129d403308051 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4604,7 +4604,7 @@ static int kvm_mmu_faultin_pfn_gmem(struct kvm_vcpu *vcpu,
 	}
 
 	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
-			     &fault->refcounted_page, &max_order);
+			     &max_order);
 	if (r) {
 		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
 		return r;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0375ef709ee2c..0c91c904573cc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4016,7 +4016,6 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	struct kvm *kvm = vcpu->kvm;
 	gfn_t gfn = gpa_to_gfn(gpa);
 	unsigned long mmu_seq;
-	struct page *page;
 	kvm_pfn_t pfn;
 
 	lockdep_assert_held(&svm->sev_es.snp_vmsa_mutex);
@@ -4060,9 +4059,8 @@ static void __sev_snp_reload_vmsa(struct kvm_vcpu *vcpu, gpa_t gpa)
 	 * The new VMSA will be private memory guest memory, so retrieve the
 	 * PFN from the gmem backend.
 	 */
-	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, &page, NULL))
+	if (kvm_gmem_get_pfn(vcpu->kvm, slot, gfn, &pfn, NULL))
 		return;
-	kvm_release_page_clean(page);
 
 	read_lock(&kvm->mmu_lock);
 	/*
@@ -5003,7 +5001,6 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
 	struct kvm *kvm = vcpu->kvm;
 	int order, rmp_level, ret;
 	unsigned long mmu_seq;
-	struct page *page;
 	bool assigned;
 	kvm_pfn_t pfn;
 	gfn_t gfn;
@@ -5033,13 +5030,12 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code)
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
2.55.0.766.g2966f0265a-goog

