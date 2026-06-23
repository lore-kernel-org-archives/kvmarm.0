Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4A838C433
	for <kvmarm@lists.linux.dev>; Tue, 23 Jun 2026 18:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782240127; cv=none; b=LEqwnxl/89dcCOB3lIC7RDXtE7/Ug/lp03nmcD/kdkQfaBjIMnxjfasFrbhKf2DUNDwoD8vO5i6TWnwGBElCAn1BuAzuXiB51j4rZYlmlNbDzf91Tu3cTeUFCJS1X1djYFac9iW8WVxoHjDCNto2Bm1j3i5f6ScKn9KJx8IOS4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782240127; c=relaxed/simple;
	bh=SgYjSxLmGm/hsof8eLwKJOs3qe1EDj2KzjSDLToh9gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RD+3Ps/MqPZnq77n5RDCrgtbZ170i5OJqD1vzv0dj3lLtuyH0KMHU/Liw64HHXDM85YLIV6pE9wHMoVzvNkzj9rqdu/u4MSsNcnmmJ5j+T3KP41WsUGDO3Y1TdPdKelxI6Gxjo4R16mSNtgaD+LkGT9Y4Q09MhvNoSjt0SrF7Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jFDDlTZI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jFDDlTZI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AB21F00ACA;
	Tue, 23 Jun 2026 18:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782240125;
	bh=U8oy23ksSpQx4aH884C4lRGDOHj96WiAdZgOvx/4+Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jFDDlTZIP5dTTPTJQE2Y6ZVArEXwLEiCHzhu6LxhjRI//+LNq9kuNzTgPPfZMmIeW
	 jVMeexsnm9oxauGBVxqfJaypl7d1mqv4WR9FG7ipVrts3hqaBFasrFRQU8BAYYI9Ta
	 ortn+CRvlRU6Ct//LgZUXwztCSJxiPDIVMEvK3vVdhgAeFzJLrEToYPXLTMKDUqi0E
	 GdQNigwHkXvT/N1qr6dvhr/fsCZguE2bANCf02vUnJV/X6NpihIicMhqQAzOK84TPG
	 3bn602OCnORTKTo17G4R7wbEvQSvc2AdF9awY69JHpRp3MUHz26d+b5jGY++ACXpqz
	 Bj+pCI1NQ6Exw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 03/22] KVM: arm64: nv: Get rid of kvm_s2_trans*() accessors
Date: Tue, 23 Jun 2026 11:41:42 -0700
Message-ID: <20260623184201.1518871-4-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260623184201.1518871-1-oupton@kernel.org>
References: <20260623184201.1518871-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Access the aptly named fields in kvm_s2_trans directly rather than
indirecting through useless getters.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 35 -----------------------------
 arch/arm64/kvm/at.c                 |  6 ++---
 arch/arm64/kvm/mmu.c                | 20 ++++++++---------
 arch/arm64/kvm/nested.c             |  4 ++--
 4 files changed, 15 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index aa27f12cf2d4..3b36ed7c7608 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -98,47 +98,12 @@ struct kvm_s2_trans {
 	bool		ux;
 };
 
-static inline phys_addr_t kvm_s2_trans_output(struct kvm_s2_trans *trans)
-{
-	return trans->output;
-}
-
-static inline unsigned long kvm_s2_trans_size(struct kvm_s2_trans *trans)
-{
-	return trans->block_size;
-}
-
-static inline u32 kvm_s2_trans_esr(struct kvm_s2_trans *trans)
-{
-	return trans->esr;
-}
-
-static inline bool kvm_s2_trans_readable(struct kvm_s2_trans *trans)
-{
-	return trans->readable;
-}
-
-static inline bool kvm_s2_trans_writable(struct kvm_s2_trans *trans)
-{
-	return trans->writable;
-}
-
 static inline bool kvm_has_xnx(struct kvm *kvm)
 {
 	return cpus_have_final_cap(ARM64_HAS_XNX) &&
 		kvm_has_feat(kvm, ID_AA64MMFR1_EL1, XNX, IMP);
 }
 
-static inline bool kvm_s2_trans_exec_el0(struct kvm *kvm, struct kvm_s2_trans *trans)
-{
-	return trans->ux;
-}
-
-static inline bool kvm_s2_trans_exec_el1(struct kvm *kvm, struct kvm_s2_trans *trans)
-{
-	return trans->px;
-}
-
 extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 			      struct kvm_s2_trans *result);
 extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 8263c648207b..86b499e7a9a0 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -494,14 +494,14 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 				return ret;
 			}
 
-			if (!kvm_s2_trans_readable(&s2_trans)) {
+			if (!s2_trans.readable) {
 				fail_s1_walk(wr, ESR_ELx_FSC_PERM_L(level),
 					     true);
 
 				return -EPERM;
 			}
 
-			ipa = kvm_s2_trans_output(&s2_trans);
+			ipa = s2_trans.output;
 		}
 
 		if (wi->filter) {
@@ -582,7 +582,7 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		new_desc |= PTE_AF;
 
 	if (new_desc != desc) {
-		if (wi->s2 && !kvm_s2_trans_writable(&s2_trans)) {
+		if (wi->s2 && !s2_trans.writable) {
 			fail_s1_walk(wr, ESR_ELx_FSC_PERM_L(level), true);
 			return -EPERM;
 		}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8811ad60cf72..07bd1e3ae9fb 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1572,9 +1572,9 @@ static int topup_mmu_memcache(struct kvm_vcpu *vcpu, void *memcache)
 static enum kvm_pgtable_prot adjust_nested_fault_perms(struct kvm_s2_trans *nested,
 						       enum kvm_pgtable_prot prot)
 {
-	if (!kvm_s2_trans_writable(nested))
+	if (!nested->writable)
 		prot &= ~KVM_PGTABLE_PROT_W;
-	if (!kvm_s2_trans_readable(nested))
+	if (!nested->readable)
 		prot &= ~KVM_PGTABLE_PROT_R;
 
 	return prot | kvm_encode_nested_level(nested);
@@ -1584,9 +1584,9 @@ static enum kvm_pgtable_prot adjust_nested_exec_perms(struct kvm *kvm,
 						      struct kvm_s2_trans *nested,
 						      enum kvm_pgtable_prot prot)
 {
-	if (!kvm_s2_trans_exec_el0(kvm, nested))
+	if (!nested->ux)
 		prot &= ~KVM_PGTABLE_PROT_UX;
-	if (!kvm_s2_trans_exec_el1(kvm, nested))
+	if (!nested->px)
 		prot &= ~KVM_PGTABLE_PROT_PX;
 
 	return prot;
@@ -1623,7 +1623,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 	}
 
 	if (s2fd->nested)
-		gfn = kvm_s2_trans_output(s2fd->nested) >> PAGE_SHIFT;
+		gfn = s2fd->nested->output >> PAGE_SHIFT;
 	else
 		gfn = s2fd->fault_ipa >> PAGE_SHIFT;
 
@@ -1817,7 +1817,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 		 * can only create a block mapping if the guest stage 2 page
 		 * table uses at least as big a mapping.
 		 */
-		max_map_size = min(kvm_s2_trans_size(s2fd->nested), max_map_size);
+		max_map_size = min(s2fd->nested->block_size, max_map_size);
 
 		/*
 		 * Be careful that if the mapping size falls between
@@ -1891,7 +1891,7 @@ static gfn_t get_canonical_gfn(const struct kvm_s2_fault_desc *s2fd,
 	if (!s2fd->nested)
 		return s2vi->gfn;
 
-	ipa = kvm_s2_trans_output(s2fd->nested);
+	ipa = s2fd->nested->output;
 	return ALIGN_DOWN(ipa, s2vi->vma_pagesize) >> PAGE_SHIFT;
 }
 
@@ -2322,19 +2322,19 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 		}
 
 		if (ret) {
-			esr = kvm_s2_trans_esr(&nested_trans);
+			esr = nested_trans.esr;
 			kvm_inject_s2_fault(vcpu, esr);
 			goto out_unlock;
 		}
 
 		ret = kvm_s2_handle_perm_fault(vcpu, &nested_trans);
 		if (ret) {
-			esr = kvm_s2_trans_esr(&nested_trans);
+			esr = nested_trans.esr;
 			kvm_inject_s2_fault(vcpu, esr);
 			goto out_unlock;
 		}
 
-		ipa = kvm_s2_trans_output(&nested_trans);
+		ipa = nested_trans.output;
 		nested = &nested_trans;
 	}
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index c9300703bd0d..b247bc1d83fa 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -954,9 +954,9 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
 
 	if (kvm_vcpu_trap_is_iabt(vcpu)) {
 		if (vcpu_mode_priv(vcpu))
-			forward_fault = !kvm_s2_trans_exec_el1(vcpu->kvm, trans);
+			forward_fault = !trans->px;
 		else
-			forward_fault = !kvm_s2_trans_exec_el0(vcpu->kvm, trans);
+			forward_fault = !trans->ux;
 	} else {
 		bool write_fault = kvm_is_write_fault(vcpu);
 
-- 
2.47.3

