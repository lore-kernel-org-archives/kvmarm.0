Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A253195EA
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773683704; cv=none; b=mxsqlTlmzn1pZzE0QJese0ez+mcwvAEbVrGBLpGS6tX9Groud0NM49x+RUc2IWGcZ6b1f8ekpvV5z4p4bQ1nwel00zjj0xTiTxhlZ2LpxtDd+aL8PCViTc2pHGUCg+6tSbWgLmytSpDerFrJRUj15iPJZjrET8KXocd/Bkgwhys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773683704; c=relaxed/simple;
	bh=OmbUlU61vJq74z4PFbIuXavskMoKCq6TKw93G2ZPuD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgJrDIOAtgrxTD1RNxWDTNugHYvItMx2FwgV6X21CGqkbc1Ja1sJD3m01GVziNKoxzeiyLjjjYB1knurf9xzyfMmUWzBVbkkxhRe9kVZWNES6nzt/Q7le/nCXu7dXFFIVMAzlDXd8YTYIUXLXYwGq/F4wGPDzFGBzp0Y93l7bWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j5DEc7Ex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j5DEc7Ex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09705C2BC87;
	Mon, 16 Mar 2026 17:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773683704;
	bh=OmbUlU61vJq74z4PFbIuXavskMoKCq6TKw93G2ZPuD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j5DEc7ExC1XOH0f28aQPZjzgD/Aj4ce5a2yuw9jcA74HveyUKeMSk8tWLkq2F5LM4
	 r6Arv98GM9j6sW5Gfv7eR86Q4nV0RxMQlXewlAzTV9R5SFV7ZC3Z8767MD31S9H3dY
	 h3NCTUt7ewnGl8lVJaz2qzIARrx4Zw63X316kedTgdGjf2+PicThdfyDRnjBkcen5D
	 iSV7gDK42xPlDtTefYQ68gNMLfCCoh53snF3/ilHgkgi+qLD7t39G4QaLV12YuYe9b
	 LiLiVYuLas2hhkPbN6gByHSr4381lMe7PxUZo5oJoKBAMf2stQhhvI1xqPKjX7ueS5
	 FVMx1nBGzvdAw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w2C9e-00000002XDx-12eA;
	Mon, 16 Mar 2026 17:55:02 +0000
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
Subject: [PATCH 13/17] KVM: arm64: Replace force_pte with a max_map_size attribute
Date: Mon, 16 Mar 2026 17:54:46 +0000
Message-ID: <20260316175451.1866175-14-maz@kernel.org>
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

force_pte is annoyingly limited in what it expresses, and we'd
be better off with a more generic primitive. Introduce max_map_size
instead, which does the trick and can be moved into the vma_info
structure. This firther allows it to reduce the scopes in which
it is mutable.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 47 +++++++++++++++++++++++---------------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ccdc9398e4ce2..ac4bfcc33aeb1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1648,15 +1648,32 @@ struct kvm_s2_fault_desc {
 	unsigned long		hva;
 };
 
+struct kvm_s2_fault_vma_info {
+	unsigned long	mmu_seq;
+	long		vma_pagesize;
+	vm_flags_t	vm_flags;
+	unsigned long	max_map_size;
+	struct page	*page;
+	kvm_pfn_t	pfn;
+	gfn_t		gfn;
+	bool		mte_allowed;
+	bool		is_vma_cacheable;
+	bool		map_writable;
+};
+
 static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
-				     struct vm_area_struct *vma, bool *force_pte)
+				     struct kvm_s2_fault_vma_info *s2vi,
+				     struct vm_area_struct *vma)
 {
 	short vma_shift;
 
-	if (*force_pte)
+	if (memslot_is_logging(s2fd->memslot)) {
+		s2vi->max_map_size = PAGE_SIZE;
 		vma_shift = PAGE_SHIFT;
-	else
+	} else {
+		s2vi->max_map_size = PUD_SIZE;
 		vma_shift = get_vma_page_shift(vma, s2fd->hva);
+	}
 
 	switch (vma_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
@@ -1674,7 +1691,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 		fallthrough;
 	case CONT_PTE_SHIFT:
 		vma_shift = PAGE_SHIFT;
-		*force_pte = true;
+		s2vi->max_map_size = PAGE_SIZE;
 		fallthrough;
 	case PAGE_SHIFT:
 		break;
@@ -1685,7 +1702,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 	if (s2fd->nested) {
 		unsigned long max_map_size;
 
-		max_map_size = *force_pte ? PAGE_SIZE : PUD_SIZE;
+		max_map_size = min(s2vi->max_map_size, PUD_SIZE);
 
 		/*
 		 * If we're about to create a shadow stage 2 entry, then we
@@ -1703,28 +1720,15 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 		else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
 			max_map_size = PAGE_SIZE;
 
-		*force_pte = (max_map_size == PAGE_SIZE);
+		s2vi->max_map_size = max_map_size;
 		vma_shift = min_t(short, vma_shift, __ffs(max_map_size));
 	}
 
 	return vma_shift;
 }
 
-struct kvm_s2_fault_vma_info {
-	unsigned long	mmu_seq;
-	long		vma_pagesize;
-	vm_flags_t	vm_flags;
-	struct page	*page;
-	kvm_pfn_t	pfn;
-	gfn_t		gfn;
-	bool		mte_allowed;
-	bool		is_vma_cacheable;
-	bool		map_writable;
-};
-
 struct kvm_s2_fault {
 	bool s2_force_noncacheable;
-	bool force_pte;
 	enum kvm_pgtable_prot prot;
 };
 
@@ -1748,7 +1752,7 @@ static int kvm_s2_fault_get_vma_info(const struct kvm_s2_fault_desc *s2fd,
 		return -EFAULT;
 	}
 
-	s2vi->vma_pagesize = BIT(kvm_s2_resolve_vma_size(s2fd, vma, &fault->force_pte));
+	s2vi->vma_pagesize = BIT(kvm_s2_resolve_vma_size(s2fd, s2vi, vma));
 
 	/*
 	 * Both the canonical IPA and fault IPA must be aligned to the
@@ -1933,7 +1937,7 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 	 * backed by a THP and thus use block mapping if possible.
 	 */
 	if (mapping_size == PAGE_SIZE &&
-	    !(fault->force_pte || fault->s2_force_noncacheable)) {
+	    !(s2vi->max_map_size == PAGE_SIZE || fault->s2_force_noncacheable)) {
 		if (perm_fault_granule > PAGE_SIZE) {
 			mapping_size = perm_fault_granule;
 		} else {
@@ -1990,7 +1994,6 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
 	struct kvm_s2_fault_vma_info s2vi = {};
 	struct kvm_s2_fault fault = {
-		.force_pte = memslot_is_logging(s2fd->memslot),
 		.prot = KVM_PGTABLE_PROT_R,
 	};
 	void *memcache;
-- 
2.47.3

