Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A205F221543
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826816; cv=none; b=QGFq/Y1X1Jym42wI6l5vUH2pPvdwXI8fbqC99bqj9v4GYLVEN14e20yDwqi3h+g7psv85x8tlyjRVYQyUIChIaZKTPFJZ66rJH04rTf3T4iIRKGlOmfbt3qpnbkH4GSbO+NFa/1teNXTkmUnu17EhNW7G9U3rn3Ji4N3hdqT9wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826816; c=relaxed/simple;
	bh=wcUh9Jeo8vzDrECNG1l870sx8DJEXMhkcinW83yQyzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXw0rq57rGqgXddNsbtKCAgt469AgTe9XtUFNImbJ/Pd6jZC7Ozjs/+j1UkhzTYFoVO+VLeTOsWpAaBJjAZbMqLQpjDm0NoSiDUG2r8ls99xCJvYxX8Rv6pOzTWP9yCBBqbFRYjEN1KpHfDg/5k4Pql4LbClkQAHiSKkAFaL7jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=amyi/wuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="amyi/wuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E87C116C6;
	Mon, 19 Jan 2026 12:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826816;
	bh=wcUh9Jeo8vzDrECNG1l870sx8DJEXMhkcinW83yQyzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amyi/wuClJdMgiMcm66dOk4jP3W9uqQNRq1DX6z5ohxxllOZRr1NBm2jz7E6xWaci
	 bTpOsYbhWWi6xpk9BOGz5bkLtk55/EnQvX7zQc5wBGLfoXN0EkJoL9wy/gviIb5Fi4
	 I42eV/vJQsT+/djL1eUjQoPMUp5sPtUP+FURrCroHcnT9D+UmMAfENX9wAT21V2qGi
	 9kvn5+OpFFNP2nRfC9r9LZaSmcxA1tZjw7b0vYznlSULshnR8gSVlFaEc5tM0p0o0D
	 6v79EW08qmiO40oRSupHLJxdUENrRQ6Q8/Cbn6ehsfMulxqHDOR9f0lbFEJrC1WlOB
	 VQaoxXO6U+R6A==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 01/35] KVM: arm64: Invert KVM_PGTABLE_WALK_HANDLE_FAULT to fix pKVM walkers
Date: Mon, 19 Jan 2026 12:45:54 +0000
Message-ID: <20260119124629.2563-2-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119124629.2563-1-will@kernel.org>
References: <20260119124629.2563-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit ddcadb297ce5 ("KVM: arm64: Ignore EAGAIN for walks outside of a
fault") introduced a new walker flag ('KVM_PGTABLE_WALK_HANDLE_FAULT')
to KVM's page-table code. When set, the walk logic maintains its
previous behaviour of terminating a walk as soon as the visitor callback
returns an error. However, when the flag is clear, the walk will
continue if the visitor returns -EAGAIN and the error is then suppressed
and returned as zero to the caller.

Clearing the flag is beneficial when write-protecting a range of IPAs
with kvm_pgtable_stage2_wrprotect() but is not useful in any other
cases, either because we are operating on a single page (e.g.
kvm_pgtable_stage2_mkyoung() or kvm_phys_addr_ioremap()) or because the
early termination is desirable (e.g. when mapping pages from a fault in
user_mem_abort()).

Subsequently, commit e912efed485a ("KVM: arm64: Introduce the EL1 pKVM
MMU") hooked up pKVM's hypercall interface to the MMU code at EL1 but
failed to propagate any of the walker flags. As a result, page-table
walks at EL2 fail to set KVM_PGTABLE_WALK_HANDLE_FAULT even when the
early termination semantics are desirable on the fault handling path.

Rather than complicate the pKVM hypercall interface, invert the flag so
that the whole thing can be simplified and only pass the new flag
('KVM_PGTABLE_WALK_IGNORE_EAGAIN') from the wrprotect code.

Cc: Fuad Tabba <tabba@google.com>
Cc: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Quentin Perret <qperret@google.com>
Fixes: fce886a60207 ("KVM: arm64: Plumb the pKVM MMU in KVM")
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h | 6 +++---
 arch/arm64/kvm/hyp/pgtable.c         | 5 +++--
 arch/arm64/kvm/mmu.c                 | 8 +++-----
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index fc02de43c68d..8b78d573fbcf 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -293,8 +293,8 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
  *					children.
  * @KVM_PGTABLE_WALK_SHARED:		Indicates the page-tables may be shared
  *					with other software walkers.
- * @KVM_PGTABLE_WALK_HANDLE_FAULT:	Indicates the page-table walk was
- *					invoked from a fault handler.
+ * @KVM_PGTABLE_WALK_IGNORE_EAGAIN:	Don't terminate the walk early if
+ *					the walker returns -EAGAIN.
  * @KVM_PGTABLE_WALK_SKIP_BBM_TLBI:	Visit and update table entries
  *					without Break-before-make's
  *					TLB invalidation.
@@ -307,7 +307,7 @@ enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_TABLE_PRE		= BIT(1),
 	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
 	KVM_PGTABLE_WALK_SHARED			= BIT(3),
-	KVM_PGTABLE_WALK_HANDLE_FAULT		= BIT(4),
+	KVM_PGTABLE_WALK_IGNORE_EAGAIN		= BIT(4),
 	KVM_PGTABLE_WALK_SKIP_BBM_TLBI		= BIT(5),
 	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(6),
 };
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 947ac1a951a5..9abc0a6cf448 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -144,7 +144,7 @@ static bool kvm_pgtable_walk_continue(const struct kvm_pgtable_walker *walker,
 	 * page table walk.
 	 */
 	if (r == -EAGAIN)
-		return !(walker->flags & KVM_PGTABLE_WALK_HANDLE_FAULT);
+		return walker->flags & KVM_PGTABLE_WALK_IGNORE_EAGAIN;
 
 	return !r;
 }
@@ -1262,7 +1262,8 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	return stage2_update_leaf_attrs(pgt, addr, size, 0,
 					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
-					NULL, NULL, 0);
+					NULL, NULL,
+					KVM_PGTABLE_WALK_IGNORE_EAGAIN);
 }
 
 void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 48d7c372a4cd..2b260bdf3202 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1563,14 +1563,12 @@ static void adjust_nested_exec_perms(struct kvm *kvm,
 		*prot &= ~KVM_PGTABLE_PROT_PX;
 }
 
-#define KVM_PGTABLE_WALK_MEMABORT_FLAGS (KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED)
-
 static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		      struct kvm_s2_trans *nested,
 		      struct kvm_memory_slot *memslot, bool is_perm)
 {
 	bool write_fault, exec_fault, writable;
-	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt = vcpu->arch.hw_mmu->pgt;
 	unsigned long mmu_seq;
@@ -1665,7 +1663,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	struct kvm_pgtable *pgt;
 	struct page *page;
 	vm_flags_t vm_flags;
-	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1933,7 +1931,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 /* Resolve the access fault by making the page young again. */
 static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 {
-	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	struct kvm_s2_mmu *mmu;
 
 	trace_kvm_access_fault(fault_ipa);
-- 
2.52.0.457.g6b5491de43-goog

