Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729283876DB;
	Fri, 27 Mar 2026 11:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611387; cv=none; b=JtLFam2tu9Ze8+4NuVFyOnOtzNz46E6n678XcwodFu5KdSU4nsv2WIqTHAapKryQg/TIbFU/z0gRZv1jAPddLoeiM4OQjnQup2uryFv+/0AKhyDZxtn2t6COsCw6HK0oj1NMzL06YckMMNQiFU30+3rt347GwvZ/Mn4Z4LYYbf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611387; c=relaxed/simple;
	bh=0KZY79rrIwhmD1/ZcFx/WLYtTWN4TDvRZH2ZU+QeGvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrlky7iLXbeS52N28Fq8FqVP2Mzz0QK9tdneFIVEOnHcpGyFSl9jf9SZm41e2ECOpBtJzm3DnDEfOpuSOQFm/8lufY+SIzfg3kmS4GdRd0Vv5nQrk6EtZEf6/Tj8cRJTfLWwwJx/1KqoyN0VnsVkKJGlWxecAQgEr/DvDKgMUr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q4U66Vkt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q4U66Vkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E82C4AF09;
	Fri, 27 Mar 2026 11:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611387;
	bh=0KZY79rrIwhmD1/ZcFx/WLYtTWN4TDvRZH2ZU+QeGvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q4U66Vktx1eYLhPfrGJQOc+bMdhILUx3Vc3eT3EBHwxOYrylPjScymXp+ynQVkSbK
	 EzK0aKvZqiJUyVxFl2B5GVXSrWNdUxzs4HAgKlAjVy+vhYfmcv47K62TwA3EioqjRP
	 0+1go/Z7Sv20+JW9IgFYZXbwfyy9xJ4FReO/EMbv3ETfcsh/xKXS0+Bgxb8XxZi7P5
	 ZU8JHYavb1AcqBE+QWG2y+l2DtEyDmAM46vbHA4x3PTxh5SetctIWMsklB7Pp87MN0
	 DMs+4J2UfoOcJ+FPHfB332MDPfhwdQJb38m68cGCpb8DaC371kirbA9flCfKZoRUTJ
	 9KTwBVY/Zfxvw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UH-00000006K4a-1zJL;
	Fri, 27 Mar 2026 11:36:25 +0000
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
Subject: [PATCH v2 14/30] KVM: arm64: Kill fault->ipa
Date: Fri, 27 Mar 2026 11:36:02 +0000
Message-ID: <20260327113618.4051534-15-maz@kernel.org>
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

fault->ipa, in a nested contest, represents the output of the guest's
S2 translation for the fault->fault_ipa input, and is equal to
fault->fault_ipa otherwise,

Given that this is readily available from kvm_s2_trans_output(),
drop fault->ipa and directly compute fault->gfn instead, which
is really what we want.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c6cd6ce5254be..67e5e867e01dc 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1643,7 +1643,7 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
 				     unsigned long hva,
 				     struct kvm_memory_slot *memslot,
 				     struct kvm_s2_trans *nested,
-				     bool *force_pte, phys_addr_t *ipa)
+				     bool *force_pte)
 {
 	short vma_shift;
 
@@ -1681,8 +1681,6 @@ static short kvm_s2_resolve_vma_size(struct vm_area_struct *vma,
 
 		max_map_size = *force_pte ? PAGE_SIZE : PUD_SIZE;
 
-		*ipa = kvm_s2_trans_output(nested);
-
 		/*
 		 * If we're about to create a shadow stage 2 entry, then we
 		 * can only create a block mapping if the guest stage 2 page
@@ -1722,7 +1720,6 @@ struct kvm_s2_fault {
 	bool is_vma_cacheable;
 	bool s2_force_noncacheable;
 	unsigned long mmu_seq;
-	phys_addr_t ipa;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active;
@@ -1738,6 +1735,7 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
 {
 	struct vm_area_struct *vma;
 	struct kvm *kvm = fault->vcpu->kvm;
+	phys_addr_t ipa;
 
 	mmap_read_lock(current->mm);
 	vma = vma_lookup(current->mm, fault->hva);
@@ -1748,8 +1746,7 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
 	}
 
 	fault->vma_pagesize = 1UL << kvm_s2_resolve_vma_size(vma, fault->hva, fault->memslot,
-							     fault->nested, &fault->force_pte,
-							     &fault->ipa);
+							     fault->nested, &fault->force_pte);
 
 	/*
 	 * Both the canonical IPA and fault IPA must be aligned to the
@@ -1757,9 +1754,9 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
 	 * mapping in the right place.
 	 */
 	fault->fault_ipa = ALIGN_DOWN(fault->fault_ipa, fault->vma_pagesize);
-	fault->ipa = ALIGN_DOWN(fault->ipa, fault->vma_pagesize);
+	ipa = fault->nested ? kvm_s2_trans_output(fault->nested) : fault->fault_ipa;
+	fault->gfn = ALIGN_DOWN(ipa, fault->vma_pagesize) >> PAGE_SHIFT;
 
-	fault->gfn = fault->ipa >> PAGE_SHIFT;
 	fault->mte_allowed = kvm_vma_mte_allowed(vma);
 
 	fault->vm_flags = vma->vm_flags;
@@ -1970,7 +1967,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		.memslot = memslot,
 		.hva = hva,
 		.fault_is_perm = fault_is_perm,
-		.ipa = fault_ipa,
 		.logging_active = logging_active,
 		.force_pte = logging_active,
 		.prot = KVM_PGTABLE_PROT_R,
-- 
2.47.3

