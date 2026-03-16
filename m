Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F3633A9DD
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773683705; cv=none; b=Trcypy2jZDcg0ErziIHVDelMPkGnSEMSSuLnWfl5JrRPjiygUptnEC9ii431CFvxbruSpX5enPUXRLBFjEfcLjBPZU8o/eAGUMgcw9wDKfXyS1fZLSsc621ULsBS69MC9f8emjoaGgjPSwJJStmfN+yC3ez3EQwDLBsvcq0wmOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773683705; c=relaxed/simple;
	bh=Pvjh0AUsyMGimq0mjyKa4oCBCOcqYdbMF6v3IKCf7Hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltnihlCampqlSaFK67OZvk4ZI8KB4GpXzFfqnUPRHVP9RTWxy7hMJ5VL08tP2kIo4bZUFlEH3mSn/Jvugh/KtjZafSi8f4s+62b8mZK64H6CxSKodEOykREcarsOqzTY6dnyEp3ZgTs8+jAYh4lucnrCA6irSKAwmuh35yGGd2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QSKaPU4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QSKaPU4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D993FC2BCB4;
	Mon, 16 Mar 2026 17:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773683704;
	bh=Pvjh0AUsyMGimq0mjyKa4oCBCOcqYdbMF6v3IKCf7Hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QSKaPU4UToJvenGSVEOhbttA4wQXA3yOEltwiZUV51COGf+Aqkc6Euk/rXEn6Hs17
	 5M4H3LW4fj3ZfL/NR+vU7FNIvygo6tf9xr96jX2N+TP+s86PTIwcOa2TN1wG73v81S
	 xXzQSzV03NggPe5Fg9yPUNNhVThBrwN/QQcxykW1eiyFhzMe3tu9iq0IV9KVD08Ari
	 afTul/H+0VAsCuHVhMzeyZrjqYtleDXfo+L+JRgq77ZoLWtX063izhPXgIIu0H94kU
	 aaG5kajaLxAN+/VtMylQomsLaNbe10ax0V3Ju55K+xkUOPhPAdxId4RK+tJdGvbovM
	 SuKi9UYmaUMEg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w2C9f-00000002XDx-0kJo;
	Mon, 16 Mar 2026 17:55:03 +0000
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
Subject: [PATCH 17/17] KVM: arm64: Convert gmem_abort() to struct kvm_s2_fault_desc
Date: Mon, 16 Mar 2026 17:54:50 +0000
Message-ID: <20260316175451.1866175-18-maz@kernel.org>
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

Having fully converted user_mem_abort() to kvm_s2_fault_desc and
co, convert gmem_abort() to it as well. The change is obviously
much simpler.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 57 +++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 18cf7e6ba786d..e14b8b7287192 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1567,33 +1567,39 @@ static enum kvm_pgtable_prot adjust_nested_exec_perms(struct kvm *kvm,
 	return prot;
 }
 
-static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
-		      struct kvm_s2_trans *nested,
-		      struct kvm_memory_slot *memslot, bool is_perm)
+struct kvm_s2_fault_desc {
+	struct kvm_vcpu		*vcpu;
+	phys_addr_t		fault_ipa;
+	struct kvm_s2_trans	*nested;
+	struct kvm_memory_slot	*memslot;
+	unsigned long		hva;
+};
+
+static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	bool write_fault, exec_fault;
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
-	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
+	struct kvm_pgtable *pgt = s2fd->vcpu->arch.hw_mmu->pgt;
 	unsigned long mmu_seq;
 	struct page *page;
-	struct kvm *kvm = vcpu->kvm;
+	struct kvm *kvm = s2fd->vcpu->kvm;
 	void *memcache;
 	kvm_pfn_t pfn;
 	gfn_t gfn;
 	int ret;
 
-	ret = prepare_mmu_memcache(vcpu, true, &memcache);
+	ret = prepare_mmu_memcache(s2fd->vcpu, true, &memcache);
 	if (ret)
 		return ret;
 
-	if (nested)
-		gfn = kvm_s2_trans_output(nested) >> PAGE_SHIFT;
+	if (s2fd->nested)
+		gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
 	else
-		gfn = fault_ipa >> PAGE_SHIFT;
+		gfn = s2fd->fault_ipa >> PAGE_SHIFT;
 
-	write_fault = kvm_is_write_fault(vcpu);
-	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
+	write_fault = kvm_is_write_fault(s2fd->vcpu);
+	exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu);
 
 	VM_WARN_ON_ONCE(write_fault && exec_fault);
 
@@ -1601,24 +1607,24 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
 	smp_rmb();
 
-	ret = kvm_gmem_get_pfn(kvm, memslot, gfn, &pfn, &page, NULL);
+	ret = kvm_gmem_get_pfn(kvm, s2fd->memslot, gfn, &pfn, &page, NULL);
 	if (ret) {
-		kvm_prepare_memory_fault_exit(vcpu, fault_ipa, PAGE_SIZE,
+		kvm_prepare_memory_fault_exit(s2fd->vcpu, s2fd->fault_ipa, PAGE_SIZE,
 					      write_fault, exec_fault, false);
 		return ret;
 	}
 
-	if (!(memslot->flags & KVM_MEM_READONLY))
+	if (!(s2fd->memslot->flags & KVM_MEM_READONLY))
 		prot |= KVM_PGTABLE_PROT_W;
 
-	if (nested)
-		prot = adjust_nested_fault_perms(nested, prot);
+	if (s2fd->nested)
+		prot = adjust_nested_fault_perms(s2fd->nested, prot);
 
 	if (exec_fault || cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
 		prot |= KVM_PGTABLE_PROT_X;
 
-	if (nested)
-		prot = adjust_nested_exec_perms(kvm, nested, prot);
+	if (s2fd->nested)
+		prot = adjust_nested_exec_perms(kvm, s2fd->nested, prot);
 
 	kvm_fault_lock(kvm);
 	if (mmu_invalidate_retry(kvm, mmu_seq)) {
@@ -1626,7 +1632,7 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		goto out_unlock;
 	}
 
-	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
+	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
 						 __pfn_to_phys(pfn), prot,
 						 memcache, flags);
 
@@ -1635,19 +1641,11 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	kvm_fault_unlock(kvm);
 
 	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
-		mark_page_dirty_in_slot(kvm, memslot, gfn);
+		mark_page_dirty_in_slot(kvm, s2fd->memslot, gfn);
 
 	return ret != -EAGAIN ? ret : 0;
 }
 
-struct kvm_s2_fault_desc {
-	struct kvm_vcpu		*vcpu;
-	phys_addr_t		fault_ipa;
-	struct kvm_s2_trans	*nested;
-	struct kvm_memory_slot	*memslot;
-	unsigned long		hva;
-};
-
 struct kvm_s2_fault_vma_info {
 	unsigned long	mmu_seq;
 	long		vma_pagesize;
@@ -2296,8 +2294,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	};
 
 	if (kvm_slot_has_gmem(memslot))
-		ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
-				 esr_fsc_is_permission_fault(esr));
+		ret = gmem_abort(&s2fd);
 	else
 		ret = user_mem_abort(&s2fd);
 
-- 
2.47.3

