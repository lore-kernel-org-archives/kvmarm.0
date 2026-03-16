Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3B533B95A
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773683703; cv=none; b=Ou8ADqtFG6PMihmOKdOKlMMitYeUBrMEMvmelCiZN7679rSUV3XDbrrjrX/5agzY9/Vw62GMXwbkNy8MNe2xEljLln1VT82fTVBTM+BWrppYS6ou0PFln1v/p99yZbKzXfxF4QeSpCqLx01vKt9kvSPAGeZnWitwvUXyWcht/QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773683703; c=relaxed/simple;
	bh=cvE1z8lorC1RF6rgkXTsGeUvZNPlHNmMijZGRMZd0bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJgRwmUi7BarNFrUBtxC74xxpZxU+mwCopCGkzztL0LWzaVgmxIXj88eWlspxb8Lq/l3ikYpX23r2LfupVgXr/Uw3FqyvNaGnAwCzQvyJA2QlvwQVFg7llR2gifip2PeNyPsIIMxkKIyixsUGk2IzSvPjoVFpN+pwxFpJtExWjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h6/VbXDw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h6/VbXDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCA7C2BCB1;
	Mon, 16 Mar 2026 17:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773683703;
	bh=cvE1z8lorC1RF6rgkXTsGeUvZNPlHNmMijZGRMZd0bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6/VbXDwYii+GfFVDmGzvmgf8shVcex3r3QyEcJQPpYzqdHIfRfs6l0hlCzAqBE0M
	 R3E3JfPID/q4s25dABAe0cBgAJHrOo14QmVD/jo47JJ5p9WgQJC02PCfXpwmgOwhac
	 xY80tH1PAuTH+3KcX8CsXada7nH79BUwqmTHzZMMwTbWzFr6usBlZjMXJIJ3uphjUM
	 iqPuDkVsJLLi13NzagVBqHDYPDaWq8kka0KJTINYnWTxP63RCV1Q97+goB8Q3GQGl0
	 JhXnCwreJ2waa+vEd3JGpAFStM1a2ze0kQV4xE/Aw7T5GkYXiatdQPkg+ykoXME3Ph
	 PzUY5U9choAsg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w2C9d-00000002XDx-3Jop;
	Mon, 16 Mar 2026 17:55:01 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH 11/17] KVM: arm64: Restrict the scope of the 'writable' attribute
Date: Mon, 16 Mar 2026 17:54:44 +0000
Message-ID: <20260316175451.1866175-12-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260316175451.1866175-1-maz@kernel.org>
References: <20260316175451.1866175-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The 'writable' field is ambiguous, and indicates multiple things:

- whether the underlying memslot is writable

- whether we are resolving the fault with writable attributes

Add a new field to kvm_s2_fault_vma_info (map_writable) to indicate
the former condition, and have local writable variables to track
the latter.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index caa5bedc79e19..3cfb8f2a6d186 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1717,10 +1717,10 @@ struct kvm_s2_fault_vma_info {
 	gfn_t		gfn;
 	bool		mte_allowed;
 	bool		is_vma_cacheable;
+	bool		map_writable;
 };
 
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
@@ -1966,11 +1968,11 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	}
 
 out_unlock:
-	kvm_release_faultin_page(kvm, fault->page, !!ret, fault->writable);
+	kvm_release_faultin_page(kvm, fault->page, !!ret, writable);
 	kvm_fault_unlock(kvm);
 
 	/* Mark the page dirty only if the fault is handled successfully */
-	if (fault->writable && !ret) {
+	if (writable && !ret) {
 		phys_addr_t ipa = gfn_to_gpa(get_canonical_gfn(s2fd, s2vi));
 		ipa &= ~(mapping_size - 1);
 		mark_page_dirty_in_slot(kvm, s2fd->memslot, gpa_to_gfn(ipa));
-- 
2.47.3

