Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC7F33BBBA
	for <kvmarm@lists.linux.dev>; Mon, 16 Mar 2026 17:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773683704; cv=none; b=qtXuCRtz7xKG7+7cH/mwSVX+IqSoTg05rs7xPKZOFcmYw90C8C5W8WMUlMvWik4K/ymrh9TIc4PpAfFQFJpEi1yGR9S+JQkCG2bMKWghQvNXSj2eiiWBnQUYBNsnwiEo0btkoZ9O4ZqTIKBDWLPgtepzSEEEHvhUJuCOgWSo8bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773683704; c=relaxed/simple;
	bh=Yhcoi82LDcFIJ95YljMG/cgOkIvsAJkNqfTlNH0oGkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pP5X1U9/QJmxxQjs6tNZTLTlf0jHMo7jpyKVOvEOjYsFtCN3n4A0Gx4lZ5Ne7+Df+gj2hY4gpK5CePTh9FCJghCVFQIqnVnFp0wsW4DVsXQvNnNiGED9qRkV6P9KXjaehRRuaRJI/v2jDujXe7OIyzdsJMvEPoqhooSCEAJmv4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qAR03LhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qAR03LhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A978C19425;
	Mon, 16 Mar 2026 17:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773683704;
	bh=Yhcoi82LDcFIJ95YljMG/cgOkIvsAJkNqfTlNH0oGkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAR03LhDFV3kpzjK+ixo1mZWgNxg4KNv7qXd3SQQCVq+6hMiyigYNfTJRJiu71S8t
	 oSQ43y6jAyIh4P0WvOflWSJ2N9P6LZdWrJCSlgsS0HEpnym5ucZIS3kk/1Y7Fn6eqq
	 4sbc0FC4Tag/iSCFve2hB73DZYV93nHFK+/U30mHEDnEtM7N3zzVl6zNKhIxpEOzFJ
	 I7qHypPMDSJQ/S3+3MDc7pvKNh6Tf3Z7GXqLk/i2KGJup4RGBTJqbXlvteqYAWeQnz
	 Ml3+wW10eldd8NjzXb7YmqFPW3Zz/P5GSUJDmoT3/L/dLecJJ2jihUh3rCAC7IbT6y
	 oBKHFPE7H0aSg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w2C9e-00000002XDx-31wW;
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
Subject: [PATCH 15/17] KVM: arm64: Directly expose mapping prot and kill kvm_s2_fault
Date: Mon, 16 Mar 2026 17:54:48 +0000
Message-ID: <20260316175451.1866175-16-maz@kernel.org>
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

The 'prot' field is the only one left in kvm_s2_fault. Expose it
directly to the functions needing it, and get rid of kvm_s2_fault.

It has served us well during this refactoring, but it is now no
longer needed.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 45 +++++++++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 97cb3585eba03..9b5df70807875 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1729,10 +1729,6 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 	return vma_shift;
 }
 
-struct kvm_s2_fault {
-	enum kvm_pgtable_prot prot;
-};
-
 static bool kvm_s2_fault_is_perm(const struct kvm_s2_fault_desc *s2fd)
 {
 	return kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
@@ -1856,8 +1852,8 @@ static int kvm_s2_fault_pin_pfn(const struct kvm_s2_fault_desc *s2fd,
 }
 
 static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
-				     struct kvm_s2_fault *fault,
-				     const struct kvm_s2_fault_vma_info *s2vi)
+				     const struct kvm_s2_fault_vma_info *s2vi,
+				     enum kvm_pgtable_prot *prot)
 {
 	struct kvm *kvm = s2fd->vcpu->kvm;
 	bool writable = s2vi->map_writable;
@@ -1885,23 +1881,25 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 		return 1;
 	}
 
+	*prot = KVM_PGTABLE_PROT_R;
+
 	if (s2fd->nested)
-		adjust_nested_fault_perms(s2fd->nested, &fault->prot, &writable);
+		adjust_nested_fault_perms(s2fd->nested, prot, &writable);
 
 	if (writable)
-		fault->prot |= KVM_PGTABLE_PROT_W;
+		*prot |= KVM_PGTABLE_PROT_W;
 
 	if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu))
-		fault->prot |= KVM_PGTABLE_PROT_X;
+		*prot |= KVM_PGTABLE_PROT_X;
 
 	if (s2vi->map_non_cacheable)
-		fault->prot |= (s2vi->vm_flags & VM_ALLOW_ANY_UNCACHED) ?
-			       KVM_PGTABLE_PROT_NORMAL_NC : KVM_PGTABLE_PROT_DEVICE;
+		*prot |= (s2vi->vm_flags & VM_ALLOW_ANY_UNCACHED) ?
+			KVM_PGTABLE_PROT_NORMAL_NC : KVM_PGTABLE_PROT_DEVICE;
 	else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
-		fault->prot |= KVM_PGTABLE_PROT_X;
+		*prot |= KVM_PGTABLE_PROT_X;
 
 	if (s2fd->nested)
-		adjust_nested_exec_perms(kvm, s2fd->nested, &fault->prot);
+		adjust_nested_exec_perms(kvm, s2fd->nested, prot);
 
 	if (!kvm_s2_fault_is_perm(s2fd) && !s2vi->map_non_cacheable && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
@@ -1913,11 +1911,12 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 }
 
 static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
-			    struct kvm_s2_fault *fault,
-			    const struct kvm_s2_fault_vma_info *s2vi, void *memcache)
+			    const struct kvm_s2_fault_vma_info *s2vi,
+			    enum kvm_pgtable_prot prot,
+			    void *memcache)
 {
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
-	bool writable = fault->prot & KVM_PGTABLE_PROT_W;
+	bool writable = prot & KVM_PGTABLE_PROT_W;
 	struct kvm *kvm = s2fd->vcpu->kvm;
 	struct kvm_pgtable *pgt;
 	long perm_fault_granule;
@@ -1970,12 +1969,12 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 		 * Drop the SW bits in favour of those stored in the
 		 * PTE, which will be preserved.
 		 */
-		fault->prot &= ~KVM_NV_GUEST_MAP_SZ;
+		prot &= ~KVM_NV_GUEST_MAP_SZ;
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, gfn_to_gpa(gfn),
-								 fault->prot, flags);
+								 prot, flags);
 	} else {
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), mapping_size,
-							 __pfn_to_phys(pfn), fault->prot,
+							 __pfn_to_phys(pfn), prot,
 							 memcache, flags);
 	}
 
@@ -1999,9 +1998,7 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 {
 	bool perm_fault = kvm_vcpu_trap_is_permission_fault(s2fd->vcpu);
 	struct kvm_s2_fault_vma_info s2vi = {};
-	struct kvm_s2_fault fault = {
-		.prot = KVM_PGTABLE_PROT_R,
-	};
+	enum kvm_pgtable_prot prot;
 	void *memcache;
 	int ret;
 
@@ -2026,13 +2023,13 @@ static int user_mem_abort(const struct kvm_s2_fault_desc *s2fd)
 	if (ret != 1)
 		return ret;
 
-	ret = kvm_s2_fault_compute_prot(s2fd, &fault, &s2vi);
+	ret = kvm_s2_fault_compute_prot(s2fd, &s2vi, &prot);
 	if (ret) {
 		kvm_release_page_unused(s2vi.page);
 		return ret;
 	}
 
-	return kvm_s2_fault_map(s2fd, &fault, &s2vi, memcache);
+	return kvm_s2_fault_map(s2fd, &s2vi, prot, memcache);
 }
 
 /* Resolve the access fault by making the page young again. */
-- 
2.47.3

