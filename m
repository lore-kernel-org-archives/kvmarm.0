Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB78135EDA5
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826893; cv=none; b=B46GboTVRXKYl6WbuOqYkea4mSRMKNkv7g8GWyllNx/6sYsZcnjJGO2Cot6u4HAtSe7PVts9STF4/0zDIjihehA4xNfxG2mjnH4w5zYLmutf1zpgwDJDBnjE4QFtAAZvgsaqFAC6R3trMAZgesFUU5EUHPodUB1yIzIG1xZX48c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826893; c=relaxed/simple;
	bh=UQUllBTQ8Fml1Y40H7PVGQk/wyiPPN6essaiC/9DWTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZ8/ZdmES7aqNnbPMxzuPQmZ9LgFineuO0PGK6GfxyB9257CbYr2Z6ViVRE+Db+fMU6mw+bbnaMLhZmrESQ1ijiuPR+F/45K9mOj5GDdUwr5Uc5oBq09Fsv6XVEFuGNlNAM2vUqjpc7ZcRlhUZgD5Bx/t5Kr4Dq08aonmiA4HH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cQJdEh4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cQJdEh4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C02B2C19424;
	Mon, 19 Jan 2026 12:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826893;
	bh=UQUllBTQ8Fml1Y40H7PVGQk/wyiPPN6essaiC/9DWTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQJdEh4nn/ZruAH1oCJz0XkK8kgIyXlTicM3yeWMgaLQHpb/DI7STK/RtvBfUurpf
	 EJnNnpAyTwKhLC7PhRTMqch2I90CvHGD9KDzxEkhvXzBIr1t+9tSfkaRFV9cgOwqum
	 VXvUrxHd/P5XYZu91cX/OsM/x5CIqnDf109w1+7t1BMUAGRQM7/Iqp5c4zzPlNx0g7
	 rELe5cxInmiw1O957AuCu3KbTATEvpP2VARVuvXVJ17koOpeB58WKwOYgseyJa7wPD
	 5Hm5bvAt4FWrLfKC7TmMzkcoT1O/UFGgIeUaV+SnJuc+M7lTzs+Uhyhu43b9zyUQfh
	 fAJAdU6StB25g==
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
Subject: [PATCH v2 26/35] KVM: arm64: Return -EFAULT from VCPU_RUN on access to a poisoned pte
Date: Mon, 19 Jan 2026 12:46:19 +0000
Message-ID: <20260119124629.2563-27-will@kernel.org>
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

If a protected vCPU faults on an IPA which appears to be mapped, query
the hypervisor to determine whether or not the faulting pte has been
poisoned by a forceful reclaim. If the pte has been poisoned, return
-EFAULT back to userspace rather than retrying the instruction forever.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h              |  1 +
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 10 +++++
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 43 +++++++++++++++++++
 arch/arm64/kvm/pkvm.c                         |  9 ++--
 5 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 39e4e588ca4f..c4246c34509a 100644
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
index f27b037abaf3..5e6cdafcdd69 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -41,6 +41,7 @@ int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
 int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
 int __pkvm_host_donate_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu);
+int __pkvm_vcpu_in_poison_fault(struct pkvm_hyp_vcpu *hyp_vcpu);
 int __pkvm_host_force_reclaim_page_guest(phys_addr_t phys);
 int __pkvm_host_reclaim_page_guest(u64 gfn, struct pkvm_hyp_vm *vm);
 int __pkvm_host_share_guest(u64 pfn, u64 gfn, u64 nr_pages, struct pkvm_hyp_vcpu *vcpu,
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e68b5d24bdad..4ecde9662111 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -570,6 +570,15 @@ static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
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
@@ -638,6 +647,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_unreserve_vm),
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
+	HANDLE_FUNC(__pkvm_vcpu_in_poison_fault),
 	HANDLE_FUNC(__pkvm_force_reclaim_guest_page),
 	HANDLE_FUNC(__pkvm_reclaim_dying_guest_page),
 	HANDLE_FUNC(__pkvm_start_teardown_vm),
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 49b309b8d7d2..914b373cfb56 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -898,6 +898,49 @@ static int get_valid_guest_pte(struct pkvm_hyp_vm *vm, u64 ipa, kvm_pte_t *ptep,
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
+	ipa |= kvm_vcpu_get_hfar(&hyp_vcpu->vcpu) & GENMASK(11, 0);
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
index d1926cb08c76..14865907610c 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -417,10 +417,13 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
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
2.52.0.457.g6b5491de43-goog

