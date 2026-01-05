Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A503446A7
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628252; cv=none; b=e8QlxFPWvxbRjgyIeb8lUaHWgP6RHO9Kcs90hD1e+OHgthI3qEGQkCBEIGRaNWHnGquQY0VV5D5Gw1TgFhmJP4Zs17hBk1h40gxYPDctO6n5AVTkyXA0Uxs152DU4FAL6WEqwAywfMaDwl8ITaUlOg5Tw8MzrlOuyLety3GNs3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628252; c=relaxed/simple;
	bh=6WZxWcIve1tFoVrjVwtXUcKy1YRiVG8fY5WeaDSrfqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkEIF6OiCcaZJquGu5SJ87kBEU9l2q29h5zpiUu3isj1XROMZYkFkBEkVWYfjzhpI1v+6JIwevRxebqG09i5APnuZYRVZWcR1/FRRpFPLrrkD5W6P9Bq1LUpEm0jO8lZAiUt+K3HQuKu76eV1wWiJnZwS/ca7rEYXZHz6WX73as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qd1LPOic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qd1LPOic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D04C116D0;
	Mon,  5 Jan 2026 15:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628252;
	bh=6WZxWcIve1tFoVrjVwtXUcKy1YRiVG8fY5WeaDSrfqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qd1LPOichsO5lPNGiX5RNymwizTm9mQ9L0hKKP1l374ZPNppvz0gdCWHm+tNzvhs3
	 mb9uI0vOuXZFY3ZwBKoR64KAmZlX7zP9cG+O8Dh+zsG3lc7TzAtqWenpZ7fyOuGNDq
	 1aydwGqVlEy/GRFIcmOOkMX7gMmkyuS6YMJ2U890pw4uzRUoiNGQbVJar4ULQkyEzj
	 ZKzwh+oXEad3iUNQQI43abUcfgepPPx66uf5FfAav7XJ119MWlNZvYBdyBZb30HcEG
	 Ewqc3aJu1Gcg5a093F8DnIl7oCnp+IKOn1onsOcpdxOSp9ZI/Nmd3kqS6bdzfkwB+V
	 vr/gseMe2KYUQ==
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
Subject: [PATCH 20/30] KVM: arm64: Introduce hypercall to force reclaim of a protected page
Date: Mon,  5 Jan 2026 15:49:28 +0000
Message-ID: <20260105154939.11041-21-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260105154939.11041-1-will@kernel.org>
References: <20260105154939.11041-1-will@kernel.org>
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
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   1 +
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |   6 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |   1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |   8 ++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 118 +++++++++++++++++-
 arch/arm64/kvm/hyp/nvhe/pkvm.c                |   4 +-
 7 files changed, 137 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index f14f845aeedd..286a7379a368 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -86,6 +86,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_unreserve_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
+	__KVM_HOST_SMCCC_FUNC___pkvm_force_reclaim_guest_page,
 	__KVM_HOST_SMCCC_FUNC___pkvm_reclaim_dying_guest_page,
 	__KVM_HOST_SMCCC_FUNC___pkvm_start_teardown_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_finalize_teardown_vm,
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
index b1940e639ad3..7d66cdd7de57 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -570,6 +570,13 @@ static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
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
@@ -630,6 +637,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_unreserve_vm),
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
+	HANDLE_FUNC(__pkvm_force_reclaim_guest_page),
 	HANDLE_FUNC(__pkvm_reclaim_dying_guest_page),
 	HANDLE_FUNC(__pkvm_start_teardown_vm),
 	HANDLE_FUNC(__pkvm_finalize_teardown_vm),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 1a341337b272..5d6028c41125 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -768,8 +768,17 @@ static int __hyp_check_page_state_range(phys_addr_t phys, u64 size, enum pkvm_pa
 	return 0;
 }
 
+#define KVM_GUEST_INVALID_PTE_POISONED	FIELD_PREP(KVM_INVALID_PTE_ANNOT_MASK, 1)
+static bool guest_pte_is_poisoned(kvm_pte_t pte)
+{
+	return pte == KVM_GUEST_INVALID_PTE_POISONED;
+}
+
 static enum pkvm_page_state guest_get_page_state(kvm_pte_t pte, u64 addr)
 {
+	if (guest_pte_is_poisoned(pte))
+		return PKVM_POISON;
+
 	if (!kvm_pte_valid(pte))
 		return PKVM_NOPAGE;
 
@@ -798,6 +807,8 @@ static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep,
 	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
 	if (ret)
 		return ret;
+	if (guest_pte_is_poisoned(pte))
+		return -EHWPOISON;
 	if (!kvm_pte_valid(pte))
 		return -ENOENT;
 	if (level != KVM_PGTABLE_LAST_LEVEL)
@@ -1076,6 +1087,107 @@ static u64 host_stage2_encode_gfn_meta(struct pkvm_hyp_vm *vm, u64 gfn)
 	       FIELD_PREP(KVM_HOST_INVALID_PTE_GUEST_GFN_MASK, gfn);
 }
 
+static int host_stage2_decode_gfn_meta(kvm_pte_t pte, struct pkvm_hyp_vm **vm,
+				       u64 *gfn)
+{
+	pkvm_handle_t handle;
+	u64 meta;
+
+	if (kvm_pte_valid(pte))
+		return -EINVAL;
+
+	if (FIELD_GET(KVM_INVALID_PTE_OWNER_MASK, pte) != PKVM_ID_GUEST)
+		return -EPERM;
+
+	meta = FIELD_GET(KVM_INVALID_PTE_EXTRA_MASK, pte);
+	handle = FIELD_GET(KVM_HOST_INVALID_PTE_GUEST_HANDLE_MASK, meta);
+	*vm = get_vm_by_handle(handle);
+	if (!*vm) {
+		/* We probably raced with teardown; try again */
+		return -EAGAIN;
+	}
+
+	*gfn = FIELD_GET(KVM_HOST_INVALID_PTE_GUEST_GFN_MASK, meta);
+	return 0;
+}
+
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
+					  KVM_GUEST_INVALID_PTE_POISONED);
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
@@ -1110,7 +1222,11 @@ int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm)
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
index 9f0997150cf5..df340de59eed 100644
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
2.52.0.351.gbe84eed79e-goog

