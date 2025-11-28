Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A7B770FE
	for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 14:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764339438; cv=none; b=Sp5yv/h2OOaJb49o0+VD5rVW5AXabLRVT4J1EAsezurjj0Yw5DdbLPgMmk9Nhyg6B1hgosj4TtwnASIOOEz3Befk/y9RKnQcd+525xput186Z1mH9sYbhIoqnUHAilx/13C7IC3nSRSb89lilI/8SJB9y2U0r0LDOSPJ1qrXjT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764339438; c=relaxed/simple;
	bh=znVfCnkhwZOTtHLotYIU8+PsWT8Kzfud0OeYCNQfrvs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tEjMVc2Pafs2MxXZrjNZ4Ius247vML6AaDhSG0lF6dPKaEe3dMTDOqMPPWv4BJVwaiMg5Vwsq22F4wINjTCWWyZKnGjYYvK/e4QElRcve6hDDbopLluVF102fkSZRXBcErzCC0+Dr+zcuFTZLeVrd+bzIQaMRqcX2u84kQx5Avs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HEl/7Xxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HEl/7Xxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A2AC4CEF1;
	Fri, 28 Nov 2025 14:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764339437;
	bh=znVfCnkhwZOTtHLotYIU8+PsWT8Kzfud0OeYCNQfrvs=;
	h=From:To:Cc:Subject:Date:From;
	b=HEl/7XxesWwAfgOWhEYHKoTC4KlbzK9fAI/KwmXjwJUlRnFQTeoaDmEQLNT2Mjc+y
	 BhFeUbyzRiOPPYPfWE6L988ZjMWeemCQYRfeMjxCe2Qxgw4d+unGJX1koBrNVic71T
	 cIWCKI8fxwds3+chFJGpv8ZARX2o0dwpTErZK8fvUQrfNWBhassjsxx2spq8F/sz9b
	 Eocje6FDYghx3FRAALpuLUKfz7tYmKzPthG8lx3+KYedPJJecUwu8LNThjnLIm1gYh
	 ZM8fRRkZSpufsrnig0hAAtl3XCD5KwkZd8CBDeHd8brsGEZwnRTV6qEhxRaHsbk1pl
	 hpwQCt3Hl/fxA==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Quentin Perret <qperret@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH] KVM: arm64: Invert KVM_PGTABLE_WALK_HANDLE_FAULT to fix pKVM walkers
Date: Fri, 28 Nov 2025 14:17:10 +0000
Message-Id: <20251128141710.19472-1-will@kernel.org>
X-Mailer: git-send-email 2.39.5
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
Fixes: fce886a60207 ("KVM: arm64: Plumb the pKVM MMU in KVM")
Signed-off-by: Will Deacon <will@kernel.org>
---

I found this by inspection and it's a bit fiddly to see what could
actually go wrong in practice because the 'mappings' tree will return
-EAGAIN if it finds a pre-existing entry. The permission relaxing path
looks more problematic, as we'll return 0 instead of -EAGAIN and I
think we can mark the page dirty twice etc.

 arch/arm64/include/asm/kvm_pgtable.h | 6 +++---
 arch/arm64/kvm/hyp/pgtable.c         | 5 +++--
 arch/arm64/kvm/mmu.c                 | 8 +++-----
 3 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 2888b5d03757..c69a9462fc79 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -288,8 +288,8 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
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
@@ -302,7 +302,7 @@ enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_TABLE_PRE		= BIT(1),
 	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
 	KVM_PGTABLE_WALK_SHARED			= BIT(3),
-	KVM_PGTABLE_WALK_HANDLE_FAULT		= BIT(4),
+	KVM_PGTABLE_WALK_IGNORE_EAGAIN		= BIT(4),
 	KVM_PGTABLE_WALK_SKIP_BBM_TLBI		= BIT(5),
 	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(6),
 };
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c351b4abd5db..3eca720ff8eb 100644
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
@@ -1223,7 +1223,8 @@ int kvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	return stage2_update_leaf_attrs(pgt, addr, size, 0,
 					KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
-					NULL, NULL, 0);
+					NULL, NULL,
+					KVM_PGTABLE_WALK_IGNORE_EAGAIN);
 }
 
 void kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7cc964af8d30..c3cd6abfa06e 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1521,14 +1521,12 @@ static void adjust_nested_fault_perms(struct kvm_s2_trans *nested,
 	*prot |= kvm_encode_nested_level(nested);
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
@@ -1622,7 +1620,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	struct kvm_pgtable *pgt;
 	struct page *page;
 	vm_flags_t vm_flags;
-	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_MEMABORT_FLAGS;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 
 	if (fault_is_perm)
 		fault_granule = kvm_vcpu_trap_get_perm_fault_granule(vcpu);
@@ -1888,7 +1886,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 /* Resolve the access fault by making the page young again. */
 static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 {
-	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_HANDLE_FAULT | KVM_PGTABLE_WALK_SHARED;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 	struct kvm_s2_mmu *mmu;
 
 	trace_kvm_access_fault(fault_ipa);
-- 
2.52.0.487.g5c8c507ade-goog

