Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D0B378D79;
	Fri, 27 Mar 2026 11:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774611391; cv=none; b=XK9BzXHamKCPIhoE3MMl/5NMfKLM0apATFleHNRc9idDuUVO5+eHdNd7wSBLO4BFU3W0MaCXoeYBfmn9O6HGQQ7gU9Uu1mF/YQc12CHbqDWuqI2Cj7boB3wbsyVqrPcCSwXYX2rMMD5FNU83OsF4FH+Oo/bL78HXNLwTkSEykJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774611391; c=relaxed/simple;
	bh=3sULViFBwb8iDIFx/07Bmp87d4dmSZdmqkQ2Ygvi1Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxhIwfKumDRJVviiPiH5HmZBpQOvfAkLcB9MHGHXiGnOes1310pOz0du0yJuwVEtVLtS4nfpjtehP4GVcMU3Yc9jFjDTBpYJC+kU/IsuU12UEErAWnAfkk+/MBS6fmos2g7mvOz/pYcI2+u7EwxIwVmYURiBwYCjkt/pj+IsnrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aR3MB367; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aR3MB367"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CE7C2BC9E;
	Fri, 27 Mar 2026 11:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774611391;
	bh=3sULViFBwb8iDIFx/07Bmp87d4dmSZdmqkQ2Ygvi1Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aR3MB367R7e97Q/+YGnBZu5YRACXWEzAWqqjr45ARtsJLsV6/KD9lJXHY2tqypage
	 fHLbTWtooWSVd+vdyR7aqYfNQkdlUuyUgomtF9crrSLe+vW5vII2oM6MWHfFayr767
	 fookpBT4Hks9285Cxp4So0H9EXW8cEWvXsWBsg5bT1GqqE8X17jW1g5bC/On13WrBi
	 jY3z68EgXho7ZUUPgs8/SCkNC75PLCzMfs+NtIFyZodfubaHN35aGVkhYIhJfrtHVt
	 TWaEwMbJqYW8nalVCOXYkoXxhyfzoe7jgLV+nL7xyDmirWP3hYgdDOCZskNzBeogRz
	 s0LKEX+x/i/UQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1w65UL-00000006K4a-0YEp;
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
Subject: [PATCH v2 29/30] KVM: arm64: Simplify integration of adjust_nested_*_perms()
Date: Fri, 27 Mar 2026 11:36:17 +0000
Message-ID: <20260327113618.4051534-30-maz@kernel.org>
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

Instead of passing pointers to adjust_nested_*_perms(), allow
them to return a new set of permissions.

With some careful moving around so that the canonical permissions
are computed before the nested ones are applied, we end-up with
a bit less code, and something a bit more readable.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 62 +++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0fbdac77b1140..f4c8f72642e02 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1544,25 +1544,27 @@ static int prepare_mmu_memcache(struct kvm_vcpu *vcpu, bool topup_memcache,
  * TLB invalidation from the guest and used to limit the invalidation scope if a
  * TTL hint or a range isn't provided.
  */
-static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
-				      enum kvm_pgtable_prot *prot,
-				      bool *writable)
+static enum kvm_pgtable_prot adjust_nested_fault_perms(struct kvm_s2_trans *nested,
+						       enum kvm_pgtable_prot prot)
 {
-	*writable &= kvm_s2_trans_writable(nested);
+	if (!kvm_s2_trans_writable(nested))
+		prot &= ~KVM_PGTABLE_PROT_W;
 	if (!kvm_s2_trans_readable(nested))
-		*prot &= ~KVM_PGTABLE_PROT_R;
+		prot &= ~KVM_PGTABLE_PROT_R;
 
-	*prot |= kvm_encode_nested_level(nested);
+	return prot | kvm_encode_nested_level(nested);
 }
 
-static void adjust_nested_exec_perms(struct kvm *kvm,
-				     struct kvm_s2_trans *nested,
-				     enum kvm_pgtable_prot *prot)
+static enum kvm_pgtable_prot adjust_nested_exec_perms(struct kvm *kvm,
+						      struct kvm_s2_trans *nested,
+						      enum kvm_pgtable_prot prot)
 {
 	if (!kvm_s2_trans_exec_el0(kvm, nested))
-		*prot &= ~KVM_PGTABLE_PROT_UX;
+		prot &= ~KVM_PGTABLE_PROT_UX;
 	if (!kvm_s2_trans_exec_el1(kvm, nested))
-		*prot &= ~KVM_PGTABLE_PROT_PX;
+		prot &= ~KVM_PGTABLE_PROT_PX;
+
+	return prot;
 }
 
 struct kvm_s2_fault_desc {
@@ -1577,7 +1579,7 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		      struct kvm_s2_trans *nested,
 		      struct kvm_memory_slot *memslot, bool is_perm)
 {
-	bool write_fault, exec_fault, writable;
+	bool write_fault, exec_fault;
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
@@ -1614,19 +1616,17 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return ret;
 	}
 
-	writable = !(memslot->flags & KVM_MEM_READONLY);
+	if (!(memslot->flags & KVM_MEM_READONLY))
+		prot |= KVM_PGTABLE_PROT_W;
 
 	if (nested)
-		adjust_nested_fault_perms(nested, &prot, &writable);
-
-	if (writable)
-		prot |= KVM_PGTABLE_PROT_W;
+		prot = adjust_nested_fault_perms(nested, prot);
 
 	if (exec_fault || cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
 		prot |= KVM_PGTABLE_PROT_X;
 
 	if (nested)
-		adjust_nested_exec_perms(kvm, nested, &prot);
+		prot = adjust_nested_exec_perms(kvm, nested, prot);
 
 	kvm_fault_lock(kvm);
 	if (mmu_invalidate_retry(kvm, mmu_seq)) {
@@ -1639,10 +1639,10 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 						 memcache, flags);
 
 out_unlock:
-	kvm_release_faultin_page(kvm, page, !!ret, writable);
+	kvm_release_faultin_page(kvm, page, !!ret, prot & KVM_PGTABLE_PROT_W);
 	kvm_fault_unlock(kvm);
 
-	if (writable && !ret)
+	if ((prot & KVM_PGTABLE_PROT_W) && !ret)
 		mark_page_dirty_in_slot(kvm, memslot, gfn);
 
 	return ret != -EAGAIN ? ret : 0;
@@ -1856,16 +1856,6 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 				     enum kvm_pgtable_prot *prot)
 {
 	struct kvm *kvm = s2fd->vcpu->kvm;
-	bool writable = s2vi->map_writable;
-
-	if (!s2vi->device && memslot_is_logging(s2fd->memslot) &&
-	    !kvm_is_write_fault(s2fd->vcpu)) {
-		/*
-		 * Only actually map the page as writable if this was a write
-		 * fault.
-		 */
-		writable = false;
-	}
 
 	if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu) && s2vi->map_non_cacheable)
 		return -ENOEXEC;
@@ -1883,12 +1873,14 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 
 	*prot = KVM_PGTABLE_PROT_R;
 
-	if (s2fd->nested)
-		adjust_nested_fault_perms(s2fd->nested, prot, &writable);
-
-	if (writable)
+	if (s2vi->map_writable && (s2vi->device ||
+				   !memslot_is_logging(s2fd->memslot) ||
+				   kvm_is_write_fault(s2fd->vcpu)))
 		*prot |= KVM_PGTABLE_PROT_W;
 
+	if (s2fd->nested)
+		*prot = adjust_nested_fault_perms(s2fd->nested, *prot);
+
 	if (kvm_vcpu_trap_is_exec_fault(s2fd->vcpu))
 		*prot |= KVM_PGTABLE_PROT_X;
 
@@ -1899,7 +1891,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 		*prot |= KVM_PGTABLE_PROT_X;
 
 	if (s2fd->nested)
-		adjust_nested_exec_perms(kvm, s2fd->nested, prot);
+		*prot = adjust_nested_exec_perms(kvm, s2fd->nested, *prot);
 
 	if (!kvm_s2_fault_is_perm(s2fd) && !s2vi->map_non_cacheable && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
-- 
2.47.3

