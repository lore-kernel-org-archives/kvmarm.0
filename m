Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FAD3914F8;
	Fri, 27 Mar 2026 11:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611390; cv=none; b=I1wfm4fCSmB3BN5gcDCOSzk6AyyldpbrZRkWZf50q0jnqZ+nXEnWXi5GmDqmtOcqaApdY1xxa6SEvJM5XdseAj757+Xk6vxGMHF0IXAyTlk5g0ARMeevovccwEbO4n+bLTfFJMm+t6Kfp6wM9YbXY0Alh48SDk/JZVMjHDUwXkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611390; c=relaxed/simple;
	bh=1bQKCb7BXL+xYOOVLaQxMZMRHM4eHSQAOwXHhv1tOy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dbUq6vsTCR2V+CVpqV6OtqTvKhfFz3FaFamQRAvDZ6JvEDdc0oMQwt6cOTtC+6YlbdutqUPiXUrNisgjm037/T5BJahSrUtxtVmmypCWT8BCarjZT3YP0bmjh1vuWYSlslIJEji/Nq/ZK2nZjzDZrGYMgAMMgv93L3Vd6/GIv5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ppfO8GET; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ppfO8GET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31052C2BCB6;
	Fri, 27 Mar 2026 11:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611390;
	bh=1bQKCb7BXL+xYOOVLaQxMZMRHM4eHSQAOwXHhv1tOy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppfO8GETBMFvNrHjeLHbRq33crNyZbj2RYmYCDWQY59W0hZA6JAQ7S4l4sWmSEpmK
	 c/0OMkUkiB7ZJDvolcZ31/Zc2PYpyqXCZxVA+kTCh0m5J3jt6eGOedk9RQeDdaRcdx
	 hBumsHQhkaq5FRPKhc0ImD6+pkGKBI0H/H3EAU+Yw+oXYPbT0KlVH1d7WY/DaqypPd
	 XGVodam+q5ZdWNf3CEYfEjkdSamb1KB6xo74kzhv8PDF+gYWkEVJjRCtMm7uzSjAiL
	 p4H3OQnDVWmVTtKES9asBR02A6VcpyIJfLz1oof5JvgOzNBRLonZefb7C2e3psTURO
	 nwHFiO+2FsvKA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UK-00000006K4a-0iRS;
	Fri, 27 Mar 2026 11:36:28 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH v2 25/30] KVM: arm64: Move kvm_s2_fault.{pfn,page} to kvm_s2_vma_info
Date: Fri, 27 Mar 2026 11:36:13 +0000
Message-ID: <20260327113618.4051534-26-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327113618.4051534-1-maz@kernel.org>
References: <20260327113618.4051534-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Continue restricting the visibility/mutability of some attributes
by moving kvm_s2_fault.{pfn,page} to kvm_s2_vma_info.

This is a pretty mechanical change.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 91767a2e6e9f2..39f01dd59259c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1652,6 +1652,8 @@ struct kvm_s2_fault_vma_info {
 	unsigned long	mmu_seq;
 	long		vma_pagesize;
 	vm_flags_t	vm_flags;
+	struct page	*page;
+	kvm_pfn_t	pfn;
 	gfn_t		gfn;
 	bool		mte_allowed;
 	bool		is_vma_cacheable;
@@ -1722,10 +1724,8 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 
 struct kvm_s2_fault {
 	bool s2_force_noncacheable;
-	kvm_pfn_t pfn;
 	bool force_pte;
 	enum kvm_pgtable_prot prot;
-	struct page *page;
 };
 
 static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
@@ -1799,11 +1799,11 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
 	if (ret)
 		return ret;
 
-	fault->pfn = __kvm_faultin_pfn(s2fd->memslot, get_canonical_gfn(s2fd, s2vi),
-				       kvm_is_write_fault(s2fd->vcpu) ? FOLL_WRITE : 0,
-				       &s2vi->map_writable, &fault->page);
-	if (unlikely(is_error_noslot_pfn(fault->pfn))) {
-		if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
+	s2vi->pfn = __kvm_faultin_pfn(s2fd->memslot, get_canonical_gfn(s2fd, s2vi),
+				      kvm_is_write_fault(s2fd->vcpu) ? FOLL_WRITE : 0,
+				      &s2vi->map_writable, &s2vi->page);
+	if (unlikely(is_error_noslot_pfn(s2vi->pfn))) {
+		if (s2vi->pfn == KVM_PFN_ERR_HWPOISON) {
 			kvm_send_hwpoison_signal(s2fd->hva, __ffs(s2vi->vma_pagesize));
 			return 0;
 		}
@@ -1824,7 +1824,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 	 * Check if this is non-struct page memory PFN, and cannot support
 	 * CMOs. It could potentially be unsafe to access as cacheable.
 	 */
-	if (s2vi->vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(fault->pfn)) {
+	if (s2vi->vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(s2vi->pfn)) {
 		if (s2vi->is_vma_cacheable) {
 			/*
 			 * Whilst the VMA owner expects cacheable mapping to this
@@ -1912,6 +1912,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	struct kvm_pgtable *pgt;
 	long perm_fault_granule;
 	long mapping_size;
+	kvm_pfn_t pfn;
 	gfn_t gfn;
 	int ret;
 
@@ -1924,6 +1925,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	perm_fault_granule = (kvm_s2_fault_is_perm(s2fd) ?
 			      kvm_vcpu_trap_get_perm_fault_granule(s2fd->vcpu) : 0);
 	mapping_size = s2vi->vma_pagesize;
+	pfn = s2vi->pfn;
 	gfn = s2vi->gfn;
 
 	/*
@@ -1936,7 +1938,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 			mapping_size = perm_fault_granule;
 		} else {
 			mapping_size = transparent_hugepage_adjust(kvm, s2fd->memslot,
-								   s2fd->hva, &fault->pfn,
+								   s2fd->hva, &pfn,
 								   &gfn);
 			if (mapping_size < 0) {
 				ret = mapping_size;
@@ -1946,7 +1948,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	}
 
 	if (!perm_fault_granule && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
-		sanitise_mte_tags(kvm, fault->pfn, mapping_size);
+		sanitise_mte_tags(kvm, pfn, mapping_size);
 
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
@@ -1963,12 +1965,12 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 								 fault->prot, flags);
 	} else {
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), mapping_size,
-							 __pfn_to_phys(fault->pfn), fault->prot,
+							 __pfn_to_phys(pfn), fault->prot,
 							 memcache, flags);
 	}
 
 out_unlock:
-	kvm_release_faultin_page(kvm, fault->page, !!ret, writable);
+	kvm_release_faultin_page(kvm, s2vi->page, !!ret, writable);
 	kvm_fault_unlock(kvm);
 
 	/*
@@ -2021,7 +2023,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 
 	ret = kvm_s2_fault_compute_prot(s2fd, &fault, &s2vi);
 	if (ret) {
-		kvm_release_page_unused(fault.page);
+		kvm_release_page_unused(s2vi.page);
 		return ret;
 	}
 
-- 
2.47.3

