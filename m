Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10F93242BD
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882221; cv=none; b=fDUkXca6ldFlroNe+aWB2ZrfwyDMdADCMCZGl55ppL/dKndINF9tKwmnbTqHR6SySe8GYOqke3uILMC8L8qY4J1GR6m6MwTI57kd/8LpNK6fgLGkiJ3lHJh1ZbrIMOZ4dX1fQzvrfbjWCaVMm6Bvz9SmvpRwZXDGhJhTfIOeAjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882221; c=relaxed/simple;
	bh=P2ScSQMbJtD+Al4wWyuqaUZdN8VaNDfUc0aFrvqpQI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLVhmrTz2BgC1uhPrGVV5VaGxnoJKc0T0g2/P+rhy5JMrBvRRmKxj1M9tyI+LgAdjkIWCa4MiJd/RCBdj3+xgQ4FuRF7413kJhZr217y8Fdd9ROxWBmEek6WPHuXh/8qQfBXRCzWfTCbFF8VNnhUGwYnMHuzYRDHf5Z6X9NJUKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VPY+9aom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VPY+9aom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBB5C2BCB4;
	Mon, 30 Mar 2026 14:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882220;
	bh=P2ScSQMbJtD+Al4wWyuqaUZdN8VaNDfUc0aFrvqpQI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPY+9aomVCNafSXJyn7xlYyPG52Okcp192D3cAD+R+bLZJjo5326w8mDiRZu33TK4
	 4zocgoC+UZ77m81hcjRmtSltj4pQ/xjnHZPrGovXxqyQjnGtys2oXF8B7e5120VBNI
	 opzUERZUMYz2IL2njDHJCaNPI9RC5b7LYHkIrnVbaxZO27LVazyDy0ybSJSoekmT4k
	 rY4PyBGrse92Vrrta5dKn93Iz588Itmvf3elewXEcTAjySlnCZgWIuzmNabvOr3E5n
	 7YzDq43KIf7gr8D1zq+ap7eMi7NzNsI7sVneqzPSiiEqw6lNdOjxc8QOlKm1QPtQ92
	 s0GvFunsUcqfQ==
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
Subject: [PATCH v5 27/38] KVM: arm64: Return -EFAULT from VCPU_RUN on access to a poisoned pte
Date: Mon, 30 Mar 2026 15:48:28 +0100
Message-ID: <20260330144841.26181-28-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330144841.26181-1-will@kernel.org>
References: <20260330144841.26181-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If a protected vCPU faults on an IPA which appears to be mapped, query
the hypervisor to determine whether or not the faulting pte has been
poisoned by a forceful reclaim. If the pte has been poisoned, return
-EFAULT back to userspace rather than retrying the instruction forever.

Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 10 +++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 43 +++++++++++++++++++
 arch/arm64/kvm/pkvm.c                         |  9 ++--
 5 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 04a230e906a7..6c79f7504d80 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -90,6 +90,7 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_unreserve_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
+	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_in_poison_fault,
 	__KVM_HOST_SMCCC_FUNC___pkvm_force_reclaim_guest_page,
 	__KVM_HOST_SMCCC_FUNC___pkvm_reclaim_dying_guest_page,
 	__KVM_HOST_SMCCC_FUNC___pkvm_start_teardown_vm,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index acc031103600..8bc9a2489298 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -40,6 +40,7 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu);
+int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu);
 int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys);
 int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm);
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 456c83207717..90e3b14fe287 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -573,6 +573,15 @@ static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_init_vcpu(handle, host_vcpu, vcpu_hva);
 }
 
+static void handle___pkvm_vcpu_in_poison_fault(struct kvm_cpu_context *host_ctxt)
+{
+	int ret;
+	struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
+
+	ret = hyp_vcpu ? __pkvm_vcpu_in_poison_fault(hyp_vcpu) : -EINVAL;
+	cpu_reg(host_ctxt, 1) = ret;
+}
+
 static void handle___pkvm_force_reclaim_guest_page(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(phys_addr_t, phys, host_ctxt, 1);
@@ -641,6 +650,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_unreserve_vm),
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
+	HANDLE_FUNC(__pkvm_vcpu_in_poison_fault),
 	HANDLE_FUNC(__pkvm_force_reclaim_guest_page),
 	HANDLE_FUNC(__pkvm_reclaim_dying_guest_page),
 	HANDLE_FUNC(__pkvm_start_teardown_vm),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 73bdbd4a508e..31ca3db26fb5 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -890,6 +890,49 @@ static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep,
 	return 0;
 }
 
+int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu)
+{
+	struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(hyp_vcpu);
+	kvm_pte_t pte;
+	s8 level;
+	u64 ipa;
+	int ret;
+
+	switch (kvm_vcpu_trap_get_class(&hyp_vcpu->vcpu)) {
+	case ESR_ELx_EC_DABT_LOW:
+	case ESR_ELx_EC_IABT_LOW:
+		if (kvm_vcpu_trap_is_translation_fault(&hyp_vcpu->vcpu))
+			break;
+		fallthrough;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * The host has the faulting IPA when it calls us from the guest
+	 * fault handler but we retrieve it ourselves from the FAR so as
+	 * to avoid exposing an "oracle" that could reveal data access
+	 * patterns of the guest after initial donation of its pages.
+	 */
+	ipa = kvm_vcpu_get_fault_ipa(&hyp_vcpu->vcpu);
+	ipa |= FAR_TO_FIPA_OFFSET(kvm_vcpu_get_hfar(&hyp_vcpu->vcpu));
+
+	guest_lock_component(vm);
+	ret = kvm_pgtable_get_leaf(&vm->pgt, ipa, &pte, &level);
+	if (ret)
+		goto unlock;
+
+	if (level != KVM_PGTABLE_LAST_LEVEL) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	ret = guest_pte_is_poisoned(pte);
+unlock:
+	guest_unlock_component(vm);
+	return ret;
+}
+
 int __pkvm_host_share_hyp(u64 pfn)
 {
 	u64 phys = hyp_pfn_to_phys(pfn);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 10edd4965936..7f35df29e984 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -423,10 +423,13 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			return -EINVAL;
 
 		/*
-		 * We raced with another vCPU.
+		 * We either raced with another vCPU or the guest PTE
+		 * has been poisoned by an erroneous host access.
 		 */
-		if (mapping)
-			return -EAGAIN;
+		if (mapping) {
+			ret = kvm_call_hyp_nvhe(__pkvm_vcpu_in_poison_fault);
+			return ret ? -EFAULT : -EAGAIN;
+		}
 
 		ret = kvm_call_hyp_nvhe(__pkvm_host_donate_guest, pfn, gfn);
 	} else {
-- 
2.53.0.1018.g2bb0e51243-goog

