Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B893368AA
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721934; cv=none; b=AxMryoH+ghrrJ5YJH/TbH8ysaxsZlIoJJYsyyaRZtGNlKzAMv14s9dWtDGyHrTOxZjRpvxojqX23XuzrOheApkX68YP8fxJVBUnGNju0ddc002o2DyS9wO+miEeqqowvsvccwDTV+zEi9Qxkbwb4h1KptyrE1j0POB86a2lLSPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721934; c=relaxed/simple;
	bh=N6nFoMphH3d+OnEjp6yGTS6YWtq4UDhXX0JrNv5d1NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qU8ErKAo/ev9xvoRbcFMnyysEeZ8cTyvvQu/IX2p9y3EZKgk2KEd24gE0iGt1el1g+obyNwulz0+RlqKh6V2T1ShD+AEFYp2eE+56Zyii01sMzh/qyX3J3qx1IvW1eYo3rmgSZkgSir3cxNgC0Wncbwy/7QZ2++mCn7qNudrXNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UAIJMaAB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UAIJMaAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BADC2BC87;
	Thu,  5 Mar 2026 14:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721934;
	bh=N6nFoMphH3d+OnEjp6yGTS6YWtq4UDhXX0JrNv5d1NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UAIJMaABydL1U1jNgTCeiGk6wKWGQ1j8AeZi8M1QHo++BbnD/tIQ3Tconlp5jbUJT
	 vlt9uGQCek2/sqy2dF+z4Ic8HsrQ04260xtijmGjoo2sUhmwFkfvsGhaCSNTFRFvi9
	 sARtuihT3lKpQOqpjLHjLxNMGoXpL2/VZ8E/E7sefLz3cuYXfnILAFL3JiH/ENpZXa
	 +GcBuz950j4MVxSbgejIDESRy/pNy3CXt5cui2xDOBKSjDBsr2UTaR7KpeYRApfPZG
	 /lgndUcm9EzONOGkd0uuwb1gILRGOcSgEgeOvXBb91xJQR7fgjGFBlLxi9xHurDIQ1
	 NHzPne8Tbs+cA==
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
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v3 24/36] KVM: arm64: Introduce hypercall to force reclaim of a protected page
Date: Thu,  5 Mar 2026 14:43:37 +0000
Message-ID: <20260305144351.17071-25-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305144351.17071-1-will@kernel.org>
References: <20260305144351.17071-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a new hypercall, __pkvm_force_reclaim_guest_page(), to allow
the host to forcefully reclaim a physical page that was previous donated
to a protected guest. This results in the page being zeroed and the
previous guest mapping being poisoned so that new pages cannot be
subsequently donated at the same IPA.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h              |   1 +
 arch/arm64/include/asm/kvm_pgtable.h          |   6 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   1 +
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |   6 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   8 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 127 +++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |   4 +-
 8 files changed, 152 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index b6df8f64d573..04a230e906a7 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -90,6 +90,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_unreserve_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
+	__KVM_HOST_SMCCC_FUNC___pkvm_force_reclaim_guest_page,
 	__KVM_HOST_SMCCC_FUNC___pkvm_reclaim_dying_guest_page,
 	__KVM_HOST_SMCCC_FUNC___pkvm_start_teardown_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_finalize_teardown_vm,
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 2df22640833c..41a8687938eb 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -116,6 +116,12 @@ enum kvm_invalid_pte_type {
 	 * ownership.
 	 */
 	KVM_HOST_INVALID_PTE_TYPE_DONATION,
+
+	/*
+	 * The page has been forcefully reclaimed from the guest by the
+	 * host.
+	 */
+	KVM_GUEST_INVALID_PTE_TYPE_POISONED,
 };
 
 static inline bool kvm_pte_valid(kvm_pte_t pte)
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index cde38a556049..f27b037abaf3 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -41,6 +41,7 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu);
+int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys);
 int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm);
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
 			    enum kvm_pgtable_prot prot);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index dee1a406b0c2..4cedb720c75d 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -30,6 +30,12 @@ enum pkvm_page_state {
 	 * struct hyp_page.
 	 */
 	PKVM_NOPAGE			= BIT(0) | BIT(1),
+
+	/*
+	 * 'Meta-states' which aren't encoded directly in the PTE's SW bits (or
+	 * the hyp_vmemmap entry for the host)
+	 */
+	PKVM_POISON			= BIT(2),
 };
 #define PKVM_PAGE_STATE_MASK		(BIT(0) | BIT(1))
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 506831804f64..a5a7bb453f3e 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -78,6 +78,7 @@ int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn);
 int __pkvm_start_teardown_vm(pkvm_handle_t handle);
 int __pkvm_finalize_teardown_vm(pkvm_handle_t handle);
 
+struct pkvm_hyp_vm *get_vm_by_handle(pkvm_handle_t handle);
 struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 					 unsigned int vcpu_idx);
 void pkvm_put_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 6db5aebd92dc..456c83207717 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -573,6 +573,13 @@ static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_init_vcpu(handle, host_vcpu, vcpu_hva);
 }
 
+static void handle___pkvm_force_reclaim_guest_page(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_host_force_reclaim_page_guest(phys);
+}
+
 static void handle___pkvm_reclaim_dying_guest_page(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
@@ -634,6 +641,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_unreserve_vm),
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
+	HANDLE_FUNC(__pkvm_force_reclaim_guest_page),
 	HANDLE_FUNC(__pkvm_reclaim_dying_guest_page),
 	HANDLE_FUNC(__pkvm_start_teardown_vm),
 	HANDLE_FUNC(__pkvm_finalize_teardown_vm),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 3b2f7d4c4936..4ff31947579b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -616,6 +616,35 @@ static u64 host_stage2_encode_gfn_meta(struct pkvm_hyp_vm *vm, u64 gfn)
 	       FIELD_PREP(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, gfn);
 }
 
+static int host_stage2_decode_gfn_meta(kvm_pte_t pte, struct pkvm_hyp_vm **vm,
+				       u64 *gfn)
+{
+	pkvm_handle_t handle;
+	u64 meta;
+
+	if (WARN_ON(kvm_pte_valid(pte)))
+		return -EINVAL;
+
+	if (FIELD_GET(KVM_INVALID_PTE_TYPE_MASK, pte) !=
+	    KVM_HOST_INVALID_PTE_TYPE_DONATION) {
+		return -EINVAL;
+	}
+
+	if (FIELD_GET(KVM_HOST_DONATION_PTE_OWNER_MASK, pte) != PKVM_ID_GUEST)
+		return -EPERM;
+
+	meta = FIELD_GET(KVM_HOST_DONATION_PTE_EXTRA_MASK, pte);
+	handle = FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_HANDLE_MASK, meta);
+	*vm = get_vm_by_handle(handle);
+	if (!*vm) {
+		/* We probably raced with teardown; try again */
+		return -EAGAIN;
+	}
+
+	*gfn = FIELD_GET(KVM_HOST_PTE_OWNER_GUEST_GFN_MASK, meta);
+	return 0;
+}
+
 static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
 {
 	/*
@@ -801,8 +830,20 @@ static int __hyp_check_page_state_range(phys_addr_t phys, u64 size, enum pkvm_pa
 	return 0;
 }
 
+static bool guest_pte_is_poisoned(kvm_pte_t pte)
+{
+	if (kvm_pte_valid(pte))
+		return false;
+
+	return FIELD_GET(KVM_INVALID_PTE_TYPE_MASK, pte) ==
+	       KVM_GUEST_INVALID_PTE_TYPE_POISONED;
+}
+
 static enum pkvm_page_state guest_get_page_state(kvm_pte_t pte, u64 addr)
 {
+	if (guest_pte_is_poisoned(pte))
+		return PKVM_POISON;
+
 	if (!kvm_pte_valid(pte))
 		return PKVM_NOPAGE;
 
@@ -831,6 +872,8 @@ static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep,
 	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
 	if (ret)
 		return ret;
+	if (guest_pte_is_poisoned(pte))
+		return -EHWPOISON;
 	if (!kvm_pte_valid(pte))
 		return -ENOENT;
 	if (level != KVM_PGTABLE_LAST_LEVEL)
@@ -1096,6 +1139,84 @@ static void hyp_poison_page(phys_addr_t phys)
 	hyp_fixmap_unmap();
 }
 
+static int host_stage2_get_guest_info(phys_addr_t phys, struct pkvm_hyp_vm **vm,
+				      u64 *gfn)
+{
+	enum pkvm_page_state state;
+	kvm_pte_t pte;
+	s8 level;
+	int ret;
+
+	if (!addr_is_memory(phys))
+		return -EFAULT;
+
+	state = get_host_state(hyp_phys_to_page(phys));
+	switch (state) {
+	case PKVM_PAGE_OWNED:
+	case PKVM_PAGE_SHARED_OWNED:
+	case PKVM_PAGE_SHARED_BORROWED:
+		/* The access should no longer fault; try again. */
+		return -EAGAIN;
+	case PKVM_NOPAGE:
+		break;
+	default:
+		return -EPERM;
+	}
+
+	ret = kvm_pgtable_get_leaf(&host_mmu.pgt, phys, &pte, &level);
+	if (ret)
+		return ret;
+
+	if (WARN_ON(level != KVM_PGTABLE_LAST_LEVEL))
+		return -EINVAL;
+
+	return host_stage2_decode_gfn_meta(pte, vm, gfn);
+}
+
+int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys)
+{
+	struct pkvm_hyp_vm *vm;
+	u64 gfn, ipa, pa;
+	kvm_pte_t pte;
+	int ret;
+
+	hyp_spin_lock(&vm_table_lock);
+	host_lock_component();
+
+	ret = host_stage2_get_guest_info(phys, &vm, &gfn);
+	if (ret)
+		goto unlock_host;
+
+	ipa = hyp_pfn_to_phys(gfn);
+	guest_lock_component(vm);
+	ret = get_valid_guest_pte(vm, ipa, &pte, &pa);
+	if (ret)
+		goto unlock_guest;
+
+	WARN_ON(pa != phys);
+	if (guest_get_page_state(pte, ipa) != PKVM_PAGE_OWNED) {
+		ret = -EPERM;
+		goto unlock_guest;
+	}
+
+	/* We really shouldn't be allocating, so don't pass a memcache */
+	ret = kvm_pgtable_stage2_annotate(&vm->pgt, ipa, PAGE_SIZE, NULL,
+					  KVM_GUEST_INVALID_PTE_TYPE_POISONED,
+					  0);
+	if (ret)
+		goto unlock_guest;
+
+	hyp_poison_page(phys);
+	WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HOST));
+unlock_guest:
+	guest_unlock_component(vm);
+unlock_host:
+	host_unlock_component();
+	hyp_spin_unlock(&vm_table_lock);
+
+	return ret;
+}
+
 int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm)
 {
 	u64 ipa = hyp_pfn_to_phys(gfn);
@@ -1130,7 +1251,11 @@ int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm)
 	guest_unlock_component(vm);
 	host_unlock_component();
 
-	return ret;
+	/*
+	 * -EHWPOISON implies that the page was forcefully reclaimed already
+	 * so return success for the GUP pin to be dropped.
+	 */
+	return ret && ret != -EHWPOISON ? ret : 0;
 }
 
 int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index a7253a884163..5269ac20d2fb 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -230,10 +230,12 @@ void pkvm_hyp_vm_table_init(void *tbl)
 /*
  * Return the hyp vm structure corresponding to the handle.
  */
-static struct pkvm_hyp_vm *get_vm_by_handle(pkvm_handle_t handle)
+struct pkvm_hyp_vm *get_vm_by_handle(pkvm_handle_t handle)
 {
 	unsigned int idx = vm_handle_to_idx(handle);
 
+	hyp_assert_lock_held(&vm_table_lock);
+
 	if (unlikely(idx >= KVM_MAX_PVMS))
 		return NULL;
 
-- 
2.53.0.473.g4a7958ca14-goog

