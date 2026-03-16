Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C563246EF
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773683701; cv=none; b=nIEc0l/VosUdzQUmP5vs58yMs7xi10WFhmfhXvKK8ZCswfFUxCjqzqHU8xkw9iqfL5kJpeyeVxJTi1hJWfB0moE8PfOSO/swkbT5MD0m7W5/nOGSuvywmS53sGPOXttEYt0h0y4c35IesADha7rzDvcflH+F7GUhHPh4eMORpjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773683701; c=relaxed/simple;
	bh=Pl0Pwj7+U5z2wAmFgzrIjWC6VG4ReNm4HEw/QYVyO2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXezhazOadOBnr3KV4mBWBjyMlrKeQwwum/rujQeqb2pgSZSDLH2Pgwza/fh/Fi3J0Kka+C5T05K/8pYZEk8uaa14F2bRc1IM4zKEX77T67CVpdQ5svPztbeITuvAuLcgnvRGA8dsKfQVdTHneaAO1heNK2q+yRDWg+EayT1Vbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oy51kqWo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oy51kqWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE5FC2BC9E;
	Mon, 16 Mar 2026 17:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773683701;
	bh=Pl0Pwj7+U5z2wAmFgzrIjWC6VG4ReNm4HEw/QYVyO2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oy51kqWo3qjZRznYVBJC1E65dGCOUDL3h2hazt8D4kBD3bfMp0VC5CSaVTQLu0bPS
	 nd6n0TBuaQildmJcuoz8HEKZ0I15E8HWAGN2XVL0vQ1P7njMnSTsa2Y5Ax0rM1t4hz
	 82anovLvirad3Zd2Yi1Hiijt0m1QTq79IGABx0BGPTaGj0WNmiSK/ljUrSRCEib2E9
	 He5DU6jFCL32GugGCH7bF7TYiU7AlikRKZKiK4qjVAB/aLnqS2/GGy+CUV2Oc5P97W
	 B4/zEhaIoj6mpGIG5ylhthO8PGu5VY3fTYfoqDODmf8tje3MwvA77mCi04irVTTn+z
	 DRREvHDHKvxig==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w2C9b-00000002XDx-1GQ7;
	Mon, 16 Mar 2026 17:54:59 +0000
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
Subject: [PATCH 01/17] KVM: arm64: Kill fault->ipa
Date: Mon, 16 Mar 2026 17:54:34 +0000
Message-ID: <20260316175451.1866175-2-maz@kernel.org>
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

fault->ipa, in a nested contest, represents the output of the guest's
S2 translation for the fault->fault_ipa input, and is equal to
fault->fault_ipa otherwise,

Given that this is readily available from kvm_s2_trans_output(),
drop fault->ipa and directly compute fault->gfn instead, which
is really what we want.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5542a50dc8a65..fe8f8057cf412 100644
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

