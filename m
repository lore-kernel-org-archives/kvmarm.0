Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BFB221264
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620100; cv=none; b=D/BmG56SR9AfneNcmNP2iFl10DYr92ye7W5I+D5K6hvQKWH6zZo1QJvqnqUzchkNjpHcdXeDwdiBpTbHcH8QhgivixjURlUwdlRRr68g3Pf0VhdcEIeIXw6mWfLGuo/EruMsC9Z8PvYrYZkHL7EJe7bODzvUUP3u0keY2SXw5P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620100; c=relaxed/simple;
	bh=Rp+N8urKP/Q8NkGjQdMtQTHDAU6LAwOWkT9yPwaFqf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQE8TtrezZOKKYwralCmsu2/Ilw/dherVV2I7jgX9hjcNCEWS9c4Ax8XpmWDuJS/djvged+yx+TSWpEgkq9x3l5JQWgcSNI2CO8QlWkWGOUiCkWqisCWnZuG9Ea+p8XkZgnllBKvaSG5HuW/2VKp8XgaiTB9FM2/afb2Ap+y7uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=spSDCEGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="spSDCEGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4118C19423;
	Fri, 27 Mar 2026 14:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620100;
	bh=Rp+N8urKP/Q8NkGjQdMtQTHDAU6LAwOWkT9yPwaFqf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spSDCEGff02Pf+s07WfYZDKlsVgJSBN06xPpjyD4WHd56vDZpXEWPBRmNa6zwjRql
	 Wejg6isQXpzZiO3hM57ODLpi3FOAMqYxDZLetvagnewO3qIQOsA06LT1PK+UY9bnxf
	 VfTifKh2toKPNNSIhMyrxQ1xf+64yQzHdQ5ux4WYYXdjlHDdX4/LgpWbvM/WP91FEd
	 Oh0/6bolXZJZD/jLcKd7/+fW9np8flXjLuZWxAWXBDYP76qszK8hrG0E19rr1vPwhk
	 guqRwwpS+C14st2oVrHSAoIBznAf6Ux0K+Ydsx07+tMzlgjn5DN2ubcooKcFzCsGuy
	 Lgk86HCXskXMA==
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
Subject: [PATCH v4 15/38] KVM: arm64: Introduce __pkvm_reclaim_dying_guest_page()
Date: Fri, 27 Mar 2026 14:00:14 +0000
Message-ID: <20260327140039.21228-16-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327140039.21228-1-will@kernel.org>
References: <20260327140039.21228-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To enable reclaim of pages from a protected VM during teardown,
introduce a new hypercall to reclaim a single page from a protected
guest that is in the dying state.

Since the EL2 code is non-preemptible, the new hypercall deliberately
acts on a single page at a time so as to allow EL1 to reschedule
frequently during the teardown operation.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Co-developed-by: Quentin Perret <qperret@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  9 +++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 79 +++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c                | 14 ++++
 6 files changed, 105 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index dfc6625c8269..b6df8f64d573 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -90,6 +90,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_unreserve_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
+	__KVM_HOST_SMCCC_FUNC___pkvm_reclaim_dying_guest_page,
 	__KVM_HOST_SMCCC_FUNC___pkvm_start_teardown_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_finalize_teardown_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 7061b0be340a..29f81a1d9e1f 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -40,6 +40,7 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu);
+int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm);
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
 			    enum kvm_pgtable_prot prot);
 int __pkvm_host_unshare_guest(u64 gfn, u64 nr_pages, struct pkvm_hyp_vm *hyp_vm);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 04c7ca703014..506831804f64 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -74,6 +74,7 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 		     unsigned long vcpu_hva);
 
+int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn);
 int __pkvm_start_teardown_vm(pkvm_handle_t handle);
 int __pkvm_finalize_teardown_vm(pkvm_handle_t handle);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 970656318cf2..7294c94f9296 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -573,6 +573,14 @@ static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_init_vcpu(handle, host_vcpu, vcpu_hva);
 }
 
+static void handle___pkvm_reclaim_dying_guest_page(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
+	DECLARE_REG(u64, gfn, host_ctxt, 2);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_reclaim_dying_guest_page(handle, gfn);
+}
+
 static void handle___pkvm_start_teardown_vm(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
@@ -626,6 +634,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_unreserve_vm),
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
+	HANDLE_FUNC(__pkvm_reclaim_dying_guest_page),
 	HANDLE_FUNC(__pkvm_start_teardown_vm),
 	HANDLE_FUNC(__pkvm_finalize_teardown_vm),
 	HANDLE_FUNC(__pkvm_vcpu_load),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 03e6fa124253..ca266a4d9d50 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -738,6 +738,32 @@ static int __guest_check_page_state_range(struct pkvm_hyp_vm *vm, u64 addr,
 	return check_page_state_range(&vm->pgt, addr, size, &d);
 }
 
+static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep, u64 *physp)
+{
+	kvm_pte_t pte;
+	u64 phys;
+	s8 level;
+	int ret;
+
+	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
+	if (ret)
+		return ret;
+	if (!kvm_pte_valid(pte))
+		return -ENOENT;
+	if (level != KVM_PGTABLE_LAST_LEVEL)
+		return -E2BIG;
+
+	phys = kvm_pte_to_phys(pte);
+	ret = check_range_allowed_memory(phys, phys + PAGE_SIZE);
+	if (WARN_ON(ret))
+		return ret;
+
+	*ptep = pte;
+	*physp = phys;
+
+	return 0;
+}
+
 int __pkvm_host_share_hyp(u64 pfn)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
@@ -971,6 +997,59 @@ static int __guest_check_transition_size(u64 phys, u64 ipa, u64 nr_pages, u64 *s
 	return 0;
 }
 
+static void hyp_poison_page(phys_addr_t phys)
+{
+	void *addr = hyp_fixmap_map(phys);
+
+	memset(addr, 0, PAGE_SIZE);
+	/*
+	 * Prefer kvm_flush_dcache_to_poc() over __clean_dcache_guest_page()
+	 * here as the latter may elide the CMO under the assumption that FWB
+	 * will be enabled on CPUs that support it. This is incorrect for the
+	 * host stage-2 and would otherwise lead to a malicious host potentially
+	 * being able to read the contents of newly reclaimed guest pages.
+	 */
+	kvm_flush_dcache_to_poc(addr, PAGE_SIZE);
+	hyp_fixmap_unmap();
+}
+
+int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm)
+{
+	u64 ipa = hyp_pfn_to_phys(gfn);
+	kvm_pte_t pte;
+	u64 phys;
+	int ret;
+
+	host_lock_component();
+	guest_lock_component(vm);
+
+	ret = get_valid_guest_pte(vm, ipa, &pte, &phys);
+	if (ret)
+		goto unlock;
+
+	switch (guest_get_page_state(pte, ipa)) {
+	case PKVM_PAGE_OWNED:
+		WARN_ON(__host_check_page_state_range(phys, PAGE_SIZE, PKVM_NOPAGE));
+		hyp_poison_page(phys);
+		break;
+	case PKVM_PAGE_SHARED_OWNED:
+		WARN_ON(__host_check_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_BORROWED));
+		break;
+	default:
+		ret = -EPERM;
+		goto unlock;
+	}
+
+	WARN_ON(kvm_pgtable_stage2_unmap(&vm->pgt, ipa, PAGE_SIZE));
+	WARN_ON(host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HOST));
+
+unlock:
+	guest_unlock_component(vm);
+	host_unlock_component();
+
+	return ret;
+}
+
 int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu)
 {
 	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index c4e05ab8b605..a2d45f4b0cf6 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -862,6 +862,20 @@ teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr, size_t size)
 	unmap_donated_memory_noclear(addr, size);
 }
 
+int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn)
+{
+	struct pkvm_hyp_vm *hyp_vm;
+	int ret = -EINVAL;
+
+	hyp_spin_lock(&vm_table_lock);
+	hyp_vm = get_vm_by_handle(handle);
+	if (hyp_vm && hyp_vm->kvm.arch.pkvm.is_dying)
+		ret = __pkvm_host_reclaim_page_guest(gfn, hyp_vm);
+	hyp_spin_unlock(&vm_table_lock);
+
+	return ret;
+}
+
 int __pkvm_start_teardown_vm(pkvm_handle_t handle)
 {
 	struct pkvm_hyp_vm *hyp_vm;
-- 
2.53.0.1018.g2bb0e51243-goog

