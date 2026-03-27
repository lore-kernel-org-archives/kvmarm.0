Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F088379EFE;
	Fri, 27 Mar 2026 11:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611390; cv=none; b=nuNP+xCMihRYIO5u6/cGi9uRNnu10IPl2zrnb9Eulg0za5H3PPTTqi0K4qkgZEBAYFkiQaKSQV4kvBEBDuE1OaXrd9zMppdyrkM9u/rnIXqGbr4uKh6p8d7E5Tv8PstJ9znLXihGfG9O1brBVsUJVFjspXc0kl2cq68WaWji/Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611390; c=relaxed/simple;
	bh=3OfrA9uRh9uQmzOFOsa8ijQ60jgqHYTvRLxz/uPMQc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7FnAbEuP7cPN6AkmdUnKOVVqWnkpKrv9tg6S0/yUGHSTeKF6y/kgA94hZD+9Y5fVOBSCHaloRE3NgxdLFwZec3umNPoAPnJhp+AWG6GVWGpqrXSGcL8BCTVnJuyNqNLhrv8mJLc3uP6gsYiktOip2s2fp0qYq7wd/zse1c1qMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mLf6f3uZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mLf6f3uZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F130FC2BCB9;
	Fri, 27 Mar 2026 11:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611390;
	bh=3OfrA9uRh9uQmzOFOsa8ijQ60jgqHYTvRLxz/uPMQc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mLf6f3uZ3TJsfvGtQB5ftAG2WgKZE5tbHGKYg4WFgUip4Bo5hovlh95fWwO5hENdS
	 sb7o2zP+DPXVxE4yZjsItx7hYr4aUgyVU66Fmki/ZxhuGM7DhLo2j8206x0zTBAw/N
	 Z3Q6UNplVS4dXh0lvzgWuxJEueLAAK2IyW2hxrgGU1j08M/2+lVXELgVK9VHIatftW
	 VQf84BDqqKH9/WqAauFi1qTIdop4JC17PXkAESMYD1F0yWa95X05KrqEyXAC5TcprR
	 ZFFfx+yi9bQXoBf0jmM53RVfhaDOmiDCaNffv9cXih/CadYer7KmPRZdEYa5/F3faq
	 3nrz6MJj/Kr3A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UJ-00000006K4a-3wbA;
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
Subject: [PATCH v2 24/30] KVM: arm64: Restrict the scope of the 'writable' attribute
Date: Fri, 27 Mar 2026 11:36:12 +0000
Message-ID: <20260327113618.4051534-25-maz@kernel.org>
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

The 'writable' field is ambiguous, and indicates multiple things:

- whether the underlying memslot is writable

- whether we are resolving the fault with writable attributes

Add a new field to kvm_s2_fault_vma_info (map_writable) to indicate
the former condition, and have local writable variables to track
the latter.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 26313e0b40c25..91767a2e6e9f2 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1655,6 +1655,7 @@ struct kvm_s2_fault_vma_info {
 	gfn_t		gfn;
 	bool		mte_allowed;
 	bool		is_vma_cacheable;
+	bool		map_writable;
 };
 
 static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
@@ -1720,7 +1721,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 }
 
 struct kvm_s2_fault {
-	bool writable;
 	bool s2_force_noncacheable;
 	kvm_pfn_t pfn;
 	bool force_pte;
@@ -1801,7 +1801,7 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
 
 	fault->pfn = __kvm_faultin_pfn(s2fd->memslot, get_canonical_gfn(s2fd, s2vi),
 				       kvm_is_write_fault(s2fd->vcpu) ? FOLL_WRITE : 0,
-				       &fault->writable, &fault->page);
+				       &s2vi->map_writable, &fault->page);
 	if (unlikely(is_error_noslot_pfn(fault->pfn))) {
 		if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
 			kvm_send_hwpoison_signal(s2fd->hva, __ffs(s2vi->vma_pagesize));
@@ -1818,6 +1818,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 				     const struct kvm_s2_fault_vma_info *s2vi)
 {
 	struct kvm *kvm = s2fd->vcpu->kvm;
+	bool writable = s2vi->map_writable;
 
 	/*
 	 * Check if this is non-struct page memory PFN, and cannot support
@@ -1857,7 +1858,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 		 * Only actually map the page as writable if this was a write
 		 * fault.
 		 */
-		fault->writable = false;
+		writable = false;
 	}
 
 	if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu) && fault->s2_force_noncacheable)
@@ -1875,9 +1876,9 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 	}
 
 	if (s2fd->nested)
-		adjust_nested_fault_perms(s2fd->nested, &fault->prot, &fault->writable);
+		adjust_nested_fault_perms(s2fd->nested, &fault->prot, &writable);
 
-	if (fault->writable)
+	if (writable)
 		fault->prot |= KVM_PGTABLE_PROT_W;
 
 	if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu))
@@ -1906,6 +1907,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 			    const struct kvm_s2_fault_vma_info *s2vi, void *memcache)
 {
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
+	bool writable = fault->prot & KVM_PGTABLE_PROT_W;
 	struct kvm *kvm = s2fd->vcpu->kvm;
 	struct kvm_pgtable *pgt;
 	long perm_fault_granule;
@@ -1966,7 +1968,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	}
 
 out_unlock:
-	kvm_release_faultin_page(kvm, fault->page, !!ret, fault->writable);
+	kvm_release_faultin_page(kvm, fault->page, !!ret, writable);
 	kvm_fault_unlock(kvm);
 
 	/*
@@ -1974,7 +1976,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	 * making sure we adjust the canonical IPA if the mapping size has
 	 * been updated (via a THP upgrade, for example).
 	 */
-	if (fault->writable && !ret) {
+	if (writable && !ret) {
 		phys_addr_t ipa = gfn_to_gpa(get_canonical_gfn(s2fd, s2vi));
 		ipa &= ~(mapping_size - 1);
 		mark_page_dirty_in_slot(kvm, s2fd->memslot, gpa_to_gfn(ipa));
-- 
2.47.3

