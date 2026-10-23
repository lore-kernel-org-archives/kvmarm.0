Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792788976;
	b=OvnZoPQUjj1cXsp4zTr7ygIYvx3GYhji+wx4cbOZi9jaqqPLiZgyPZDN8s2aS2N1tqya
	 ZY0xXyN1UJtK97shwSzItsYnDroRkWyZU7NjoVtn2Qv4ycWNV7jRO9+gfg4VCcinIJyUi
	 ZcGehjAohspi05K9vwODS2iNCETKQ+PfL1EWvoIdj3HbtS+XR6j4sdFnS9kt9SB5JLgnX
	 EB9dyL0zshNUQ0J+rKKGA9KKpzlJdKy4wG8H6wsvWnGI32sENopD/s7ef5t8Jedogba2D
	 74vS3+lhYSeVY57egba/LIAvU3RjUuxniib/JfLB6FJtnzuH7Dy2aL9gO+DUEz5YtQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792788976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=wQ31pGMontFNxGs8aizPDVvi3hOkwgw44ORan/oU774=;
	b=GissQ+zwmU8sp3omyL9DEp2OmK3sHJCqbSZfOW7iaQ+F6rnURFzMTevmub02wUmMjfGB
	 r4kds0Jl65PHZWu5u4hMRxi1HCKdlJ/kYuLlfhEL5NMFf9mys4nBR39xNg/1/NoyMyTxq
	 VK2nLBjQe/2agJiy4ypsMjgjEkLLUT8Wfbemq3IvtNzGudg85VdK8Wdm6PBhpDxphP/Fk
	 6pAqe3UEPwHBEJorMvu6OdHGFY3KRNIuDmcrO4XtIUeb7EEP4mldQfvv1gotHqSYFy6q5
	 LYsntq1a28jI3VWRUkUgv341hpABfLpvbSsnz3LKmrikh11/ZgY+DwSYBdrc9MFS4ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=coIDd4YU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959F4606A320
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 20:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=coIDd4YU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495DC1F031E4;
	Fri, 23 Oct 2026 20:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792788976;
	bh=wQ31pGMontFNxGs8aizPDVvi3hOkwgw44ORan/oU774=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=coIDd4YUJwJn3VzCzh7rl0GkE0q4gJojNI4QLgE7pyIOOCO7IgIben3ocMKodyJhN
	 opwV+g46bcNYjXYhCk3fhNTbyKrwWCEMbPVM8rNVrEH+hStpxzhaDKBdGd1GUfB+Hc
	 PSwcLrPCCCVAzNEvnV4TVTEyFxQN5M+C9T17tqiky6182nH14xkOmFIHTN0bym3RO8
	 IP2Vsz1Vk4c7CIcJMGQIUC/65heRyRIk9gSXwDQnuls3b/ZjwukV7XI0K6FUm79QbC
	 g/IqWXo3XkJEKZNOBCmDOLlRuyfIpZOYBmfmrvg40SLKTi/i+paIJC3ghYo3ff+O3Y
	 f3SUge66ijJcw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Wei-Lin Chang <weilin.chang@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Leonardo Bras <leo.bras@arm.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 03/28] KVM: arm64: nv: Get rid of kvm_s2_trans*() accessors
Date: Fri, 23 Oct 2026 13:55:45 -0700
Message-ID: <20261023205610.1044532-4-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023205610.1044532-1-oupton@kernel.org>
References: <20261023205610.1044532-1-oupton@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Access the aptly named fields in kvm_s2_trans directly rather than
indirecting through useless getters.

Reviewed-by: Leonardo Bras <leo.bras@arm.com>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 35 -----------------------------
 arch/arm64/kvm/at.c                 |  6 ++---
 arch/arm64/kvm/mmu.c                | 25 ++++++++++-----------
 arch/arm64/kvm/nested.c             |  4 ++--
 4 files changed, 17 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index ba628d5bbe6e..01645a5b224f 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -104,47 +104,12 @@ struct kvm_s2_trans {
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
index 0926426b8798..12ffd54be2b8 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -492,14 +492,14 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
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
@@ -580,7 +580,7 @@ static int walk_s1(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 		new_desc |= PTE_AF;
 
 	if (new_desc != desc) {
-		if (wi->s2 && !kvm_s2_trans_writable(&s2_trans)) {
+		if (wi->s2 && !s2_trans.writable) {
 			fail_s1_walk(wr, ESR_ELx_FSC_PERM_L(level), true);
 			return -EPERM;
 		}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a48f3f531e82..cbf3cfb426ba 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1703,21 +1703,20 @@ static int topup_mmu_memcache(struct kvm_s2_mmu *mmu, void *memcache)
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
 }
 
-static enum kvm_pgtable_prot adjust_nested_exec_perms(struct kvm *kvm,
-						      struct kvm_s2_trans *nested,
+static enum kvm_pgtable_prot adjust_nested_exec_perms(struct kvm_s2_trans *nested,
 						      enum kvm_pgtable_prot prot)
 {
-	if (!kvm_s2_trans_exec_el0(kvm, nested))
+	if (!nested->ux)
 		prot &= ~KVM_PGTABLE_PROT_UX;
-	if (!kvm_s2_trans_exec_el1(kvm, nested))
+	if (!nested->px)
 		prot &= ~KVM_PGTABLE_PROT_PX;
 
 	return prot;
@@ -1814,7 +1813,7 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd,
 		prot |= KVM_PGTABLE_PROT_X;
 
 	if (s2fd->nested)
-		prot = adjust_nested_exec_perms(kvm, s2fd->nested, prot);
+		prot = adjust_nested_exec_perms(s2fd->nested, prot);
 
 	kvm_fault_lock(kvm);
 	if (mmu_invalidate_retry(kvm, s2vi.mmu_seq)) {
@@ -1985,7 +1984,7 @@ static short kvm_s2_resolve_vma_size(const struct kvm_s2_fault_desc *s2fd,
 		 * can only create a block mapping if the guest stage 2 page
 		 * table uses at least as big a mapping.
 		 */
-		max_map_size = min(kvm_s2_trans_size(s2fd->nested), max_map_size);
+		max_map_size = min(s2fd->nested->block_size, max_map_size);
 
 		/*
 		 * Be careful that if the mapping size falls between
@@ -2054,7 +2053,7 @@ static gfn_t get_canonical_gfn(const struct kvm_s2_fault_desc *s2fd,
 	if (!s2fd->nested)
 		return s2vi->gfn;
 
-	ipa = kvm_s2_trans_output(s2fd->nested);
+	ipa = s2fd->nested->output;
 	return ALIGN_DOWN(ipa, s2vi->vma_pagesize) >> PAGE_SHIFT;
 }
 
@@ -2158,7 +2157,7 @@ static int kvm_s2_fault_compute_prot(const struct kvm_s2_fault_desc *s2fd,
 		*prot |= KVM_PGTABLE_PROT_X;
 
 	if (s2fd->nested)
-		*prot = adjust_nested_exec_perms(kvm, s2fd->nested, *prot);
+		*prot = adjust_nested_exec_perms(s2fd->nested, *prot);
 
 	if (!kvm_s2_fault_is_perm(s2fd) && !s2vi->map_non_cacheable && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
@@ -2529,19 +2528,19 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
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
index 7bed32c43ea2..15c22a218609 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1089,9 +1089,9 @@ int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu, struct kvm_s2_trans *trans)
 
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

