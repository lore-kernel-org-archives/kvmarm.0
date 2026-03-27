Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709FC38B13E;
	Fri, 27 Mar 2026 11:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611388; cv=none; b=gE2eHvAQuTQVA2uNBYNb9tobSrp5h8RPTEoj3iiQi2RcXCkEFh9qr2RFUYFFOsAd+CkPJhyGBvrx9pMryHtARmaR367p2dGVlHpLy4e4YytTD+7CCPwXzVbypS21wiPY1BLo0b1aM0WvlJbL7hJiMM/YDYig5WAbl3Fdy5yDu4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611388; c=relaxed/simple;
	bh=tKlJeqRs+lNAXLMbIZCSYajfPwVkHyxypi6fRUMjj6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSli4NBd2T7HzhlivuGRHgWW3JTxNjS/V7sulk+ReVz006HDtJFKb+IqPBf/IRe/sN+B4YdquYgit5JF5Za8wqgdRatMprj8T6zXXGFD45TCnZzEar8U/TrCxbpAW1ptaGaaVuLRm3ZE25l8RHThfX3N5a54TiU4jJit0NuMGso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CHBdEFSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CHBdEFSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2F8C2BCB0;
	Fri, 27 Mar 2026 11:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611388;
	bh=tKlJeqRs+lNAXLMbIZCSYajfPwVkHyxypi6fRUMjj6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHBdEFSmhB/Xv6AbxhEoul2ahdd54LgFkWOfo+sCfOL05Y/4tzRjW7i/B2yNhlTpO
	 WTPqcIGN0rR1aa5wyJn/3yj+x9LDVvFxQ3Y0EudsrMi0dy+YN/BCw0oSJpFuX1hzlh
	 6vIvXjtNhtoeNItC8pfOSq2TRXSMN6UKDgZbHalfUfC4mvg7RZhMqCN8TelHJnfexf
	 g7tesUUzYtvNTrPAQtsXmv+1I0AOXlRHYaSrQAKBwxdyGXO/zjqW38HZ9qloEHTStJ
	 D7wSlDqQHBvINVv/Mi2oKqHbDdw+5tyGyr5PNnlYgr3M3D5cyHmbAv8WwjLCJ4h/BU
	 qzSaqlk2Lcy4A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UI-00000006K4a-1vdP;
	Fri, 27 Mar 2026 11:36:26 +0000
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
Subject: [PATCH v2 18/30] KVM: arm64: Constrain fault_granule to kvm_s2_fault_map()
Date: Fri, 27 Mar 2026 11:36:06 +0000
Message-ID: <20260327113618.4051534-19-maz@kernel.org>
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

The notion of fault_granule is specific to kvm_s2_fault_map(), and
is unused anywhere else.

Move this variable locally, removing it from kvm_s2_fault.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1e0d93d6d265a..981c04a74ab7a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1724,7 +1724,6 @@ struct kvm_s2_fault {
 	bool logging_active;
 	bool force_pte;
 	long vma_pagesize;
-	long fault_granule;
 	enum kvm_pgtable_prot prot;
 	struct page *page;
 	vm_flags_t vm_flags;
@@ -1908,9 +1907,9 @@ static phys_addr_t get_ipa(const struct kvm_s2_fault *fault)
 static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 			    struct kvm_s2_fault *fault, void *memcache)
 {
-	bool fault_is_perm = kvm_s2_fault_is_perm(s2fd);
 	struct kvm *kvm = s2fd->vcpu->kvm;
 	struct kvm_pgtable *pgt;
+	long perm_fault_granule;
 	int ret;
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 
@@ -1920,14 +1919,17 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	if (mmu_invalidate_retry(kvm, fault->mmu_seq))
 		goto out_unlock;
 
+	perm_fault_granule = (kvm_s2_fault_is_perm(s2fd) ?
+			      kvm_vcpu_trap_get_perm_fault_granule(s2fd->vcpu) : 0);
+
 	/*
 	 * If we are not forced to use page mapping, check if we are
 	 * backed by a THP and thus use block mapping if possible.
 	 */
 	if (fault->vma_pagesize == PAGE_SIZE &&
 	    !(fault->force_pte || fault->s2_force_noncacheable)) {
-		if (fault_is_perm && fault->fault_granule > PAGE_SIZE) {
-			fault->vma_pagesize = fault->fault_granule;
+		if (perm_fault_granule > PAGE_SIZE) {
+			fault->vma_pagesize = perm_fault_granule;
 		} else {
 			fault->vma_pagesize = transparent_hugepage_adjust(kvm, s2fd->memslot,
 									  s2fd->hva, &fault->pfn,
@@ -1940,15 +1942,15 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 		}
 	}
 
-	if (!fault_is_perm && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
+	if (!perm_fault_granule && !fault->s2_force_noncacheable && kvm_has_mte(kvm))
 		sanitise_mte_tags(kvm, fault->pfn, fault->vma_pagesize);
 
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
-	 * permissions only if fault->vma_pagesize equals fault->fault_granule. Otherwise,
+	 * permissions only if vma_pagesize equals perm_fault_granule. Otherwise,
 	 * kvm_pgtable_stage2_map() should be called to change block size.
 	 */
-	if (fault_is_perm && fault->vma_pagesize == fault->fault_granule) {
+	if (fault->vma_pagesize == perm_fault_granule) {
 		/*
 		 * Drop the SW bits in favour of those stored in the
 		 * PTE, which will be preserved.
@@ -1984,7 +1986,6 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 		.logging_active = logging_active,
 		.force_pte = logging_active,
 		.prot = KVM_PGTABLE_PROT_R,
-		.fault_granule = perm_fault ? kvm_vcpu_trap_get_perm_fault_granule(s2fd->vcpu) : 0,
 		.write_fault = write_fault,
 		.exec_fault = kvm_vcpu_trap_is_exec_fault(s2fd->vcpu),
 		.topup_memcache = !perm_fault || (logging_active && write_fault),
-- 
2.47.3

