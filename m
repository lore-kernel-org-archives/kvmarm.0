Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FD03932F7;
	Fri, 27 Mar 2026 11:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611391; cv=none; b=SvDJx9xukrC98ghO0sAddu9nTBTIJcDRn6NaQzh3D7GFkuENH3aN076EexIRCCCTmBzNRyZLe5eg2XHZGV6nyPCzxKDXTULlCaYDIN6qtUVUCUGtDceASjLReTXBHhoK2ka99XBis9B1jSt1pOZ/T24wyXf/Jt+3BURJwDB733M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611391; c=relaxed/simple;
	bh=DX7aaCvaBWxdbCRuXoGc5YzRwc4DA18NuzPAQdjcd0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFBwGekaB4dn+Qwvf6OcGeTwbp+Tcxb05A56uwGmnRsXi/B4BGuhZuPUaMEiDM+kvjVGHSnJ3Ppx6Xaisat13OUKuqEJDodh3KO8n1CQPWU5NK5ljPyo7KU0IQe7Gq4Oc8M8v4O1gufqlxChjHe9CCoWDNfeJbobCKRRKpKJp88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZIpdiGBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZIpdiGBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E85CC2BCB5;
	Fri, 27 Mar 2026 11:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611391;
	bh=DX7aaCvaBWxdbCRuXoGc5YzRwc4DA18NuzPAQdjcd0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIpdiGBrKxpULDWAqEXqsGUizeVPFrS2LckaFMPTszUTCMO4dTzmFnhhZteX4ZxoR
	 iijcGCBOOpJTWamqzf5sCWqKlQC7Sx/qX3vkmYhOGWI6BzepVFuOd2FOZzBINRlheV
	 5suedTlyUcWHY1kKevszZbNpzAjr8OYIhtyfwDWqccwTygmOUX3Hk0oJ5wQEzYi0YD
	 NeOruieJJSLmBTd9DqhUmF2HQQOhh0ugCw1ZcgI8L1gl9KFBoTFLGnTkqHiqv0VDCO
	 T7N2cZ8Li5BAFSBMa3cCzSc8Am/dK9oMccXesf0d2JzFfCgFqGtM+b2nCHbaoDqE4a
	 glfTEJXVhUwhA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UL-00000006K4a-1XHZ;
	Fri, 27 Mar 2026 11:36:29 +0000
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
Subject: [PATCH v2 30/30] KVM: arm64: Convert gmem_abort() to struct kvm_s2_fault_desc
Date: Fri, 27 Mar 2026 11:36:18 +0000
Message-ID: <20260327113618.4051534-31-maz@kernel.org>
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

Having fully converted user_mem_abort() to kvm_s2_fault_desc and
co, convert gmem_abort() to it as well. The change is obviously
much simpler.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f4c8f72642e02..1fe7182be45ac 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1575,33 +1575,31 @@ struct kvm_s2_fault_desc {
 	unsigned long		hva;
 };
 
-static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
-		      struct kvm_s2_trans *nested,
-		      struct kvm_memory_slot *memslot, bool is_perm)
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
 
@@ -1609,24 +1607,24 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
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
@@ -1634,7 +1632,7 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		goto out_unlock;
 	}
 
-	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
+	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
 						 __pfn_to_phys(pfn), prot,
 						 memcache, flags);
 
@@ -1643,7 +1641,7 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	kvm_fault_unlock(kvm);
 
 	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
-		mark_page_dirty_in_slot(kvm, memslot, gfn);
+		mark_page_dirty_in_slot(kvm, s2fd->memslot, gfn);
 
 	return ret != -EAGAIN ? ret : 0;
 }
@@ -2300,8 +2298,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 	};
 
 	if (kvm_slot_has_gmem(memslot))
-		ret = gmem_abort(vcpu, fault_ipa, nested, memslot,
-				 esr_fsc_is_permission_fault(esr));
+		ret = gmem_abort(&s2fd);
 	else
 		ret = user_mem_abort(&s2fd);
 
-- 
2.47.3

