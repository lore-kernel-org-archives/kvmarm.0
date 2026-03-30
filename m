Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2458324B31
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882154; cv=none; b=umOyQelT6x+r23i93w92nzNiwCDnxGDQgCYPSVwOoMq4U70DTGdbDPSQ3LqP1AScAhzEVmQ2TtFjgpFefGlcE1Q1lca3mNRS8FD2ABp4MmApYWkzQQWOvYLV2HgV73hMM4fRMwqPcoisNriW8X2Y/5u+33vHSs3fKmloF2RIPPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882154; c=relaxed/simple;
	bh=rDtTWruZKEqwde2X4Z+08wvET5r6e2sZSwrkchgbKoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCArB6ACkHip0Sp/aGajKrD1ckZL3FxQChv7Q5Sc7YSM5hM24QjfeQm1Kt9cLuvGVDFzsiFayjEEdbrAwmwKBwUdmd2r33JFxPr6NfZXbl4McGIro2sdkJMp5lBC7kjCxKdj+x2D/i6t2pqGhVPobCWCPgTk/cJcgfThHCeWWKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZxAHPUho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZxAHPUho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B9AC19423;
	Mon, 30 Mar 2026 14:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882154;
	bh=rDtTWruZKEqwde2X4Z+08wvET5r6e2sZSwrkchgbKoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZxAHPUhowJOnlyNpOSYlP0uwLboxv0DDSNvOeUWy1YvuH2TPC05XbNf6DbPooQsnN
	 K/fRapCAmL3xIDIMdIPPlkpnPA+yAqgctIRPTi5igHLuOOzDTYiHLj7sqa9iXfW0Ku
	 /MJK9ODTT61RAc8U7MwzhhyRn+QbIakjeIBydm16lo2euxWJCxgsZraMPJgV22x6Pg
	 GeqFy0rtYkwow6MNca2A87ymYoDZYCGrsWABhmTTi5e9oghwnLM6U88BFE4GJOzKj0
	 hg0DSngVfAL7i1b3qahqZTa4kcXBOb6hqdmDW7YvcYU39+v7YfjrKGS42xr90YmcDI
	 8n0g3XgmrU/Ww==
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
Subject: [PATCH v5 07/38] KVM: arm64: Remove is_protected_kvm_enabled() checks from hypercalls
Date: Mon, 30 Mar 2026 15:48:08 +0100
Message-ID: <20260330144841.26181-8-will@kernel.org>
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

When pKVM is not enabled, the host shouldn't issue pKVM-specific
hypercalls and so there's no point checking for this in the pKVM
hypercall handlers.

Remove the redundant is_protected_kvm_enabled() checks from each
hypercall and instead rejig the hypercall table so that the
pKVM-specific hypercalls are unreachable when pKVM is not being used.

Reviewed-by: Quentin Perret <qperret@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h   | 24 +++++++-----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 63 ++++++++++--------------------
 2 files changed, 34 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index a1ad12c72ebf..7b72aac4730d 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -51,7 +51,7 @@
 #include <linux/mm.h>
 
 enum __kvm_host_smccc_func {
-	/* Hypercalls available only prior to pKVM finalisation */
+	/* Hypercalls that are unavailable once pKVM has finalised. */
 	/* __KVM_HOST_SMCCC_FUNC___kvm_hyp_init */
 	__KVM_HOST_SMCCC_FUNC___pkvm_init = __KVM_HOST_SMCCC_FUNC___kvm_hyp_init + 1,
 	__KVM_HOST_SMCCC_FUNC___pkvm_create_private_mapping,
@@ -60,16 +60,9 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config,
 	__KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
+	__KVM_HOST_SMCCC_FUNC_MIN_PKVM = __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
 
-	/* Hypercalls available after pKVM finalisation */
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_relax_perms_guest,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_test_clear_young_guest,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_mkyoung_guest,
+	/* Hypercalls that are always available and common to [nh]VHE/pKVM. */
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
@@ -81,6 +74,17 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
+	__KVM_HOST_SMCCC_FUNC_MAX_NO_PKVM = __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
+
+	/* Hypercalls that are available only when pKVM has finalised. */
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_relax_perms_guest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_test_clear_young_guest,
+	__KVM_HOST_SMCCC_FUNC___pkvm_host_mkyoung_guest,
 	__KVM_HOST_SMCCC_FUNC___pkvm_reserve_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_unreserve_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index e7790097db93..127decc2dd2b 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -169,9 +169,6 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
 	DECLARE_REG(u64, hcr_el2, host_ctxt, 3);
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 
-	if (!is_protected_kvm_enabled())
-		return;
-
 	hyp_vcpu = pkvm_load_hyp_vcpu(handle, vcpu_idx);
 	if (!hyp_vcpu)
 		return;
@@ -188,12 +185,8 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
 
 static void handle___pkvm_vcpu_put(struct kvm_cpu_context *host_ctxt)
 {
-	struct pkvm_hyp_vcpu *hyp_vcpu;
+	struct pkvm_hyp_vcpu *hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 
-	if (!is_protected_kvm_enabled())
-		return;
-
-	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 	if (hyp_vcpu)
 		pkvm_put_hyp_vcpu(hyp_vcpu);
 }
@@ -257,9 +250,6 @@ static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	int ret = -EINVAL;
 
-	if (!is_protected_kvm_enabled())
-		goto out;
-
 	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 	if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
 		goto out;
@@ -281,9 +271,6 @@ static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
 	struct pkvm_hyp_vm *hyp_vm;
 	int ret = -EINVAL;
 
-	if (!is_protected_kvm_enabled())
-		goto out;
-
 	hyp_vm = get_np_pkvm_hyp_vm(handle);
 	if (!hyp_vm)
 		goto out;
@@ -301,9 +288,6 @@ static void handle___pkvm_host_relax_perms_guest(struct kvm_cpu_context *host_ct
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	int ret = -EINVAL;
 
-	if (!is_protected_kvm_enabled())
-		goto out;
-
 	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 	if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
 		goto out;
@@ -321,9 +305,6 @@ static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt
 	struct pkvm_hyp_vm *hyp_vm;
 	int ret = -EINVAL;
 
-	if (!is_protected_kvm_enabled())
-		goto out;
-
 	hyp_vm = get_np_pkvm_hyp_vm(handle);
 	if (!hyp_vm)
 		goto out;
@@ -343,9 +324,6 @@ static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *ho
 	struct pkvm_hyp_vm *hyp_vm;
 	int ret = -EINVAL;
 
-	if (!is_protected_kvm_enabled())
-		goto out;
-
 	hyp_vm = get_np_pkvm_hyp_vm(handle);
 	if (!hyp_vm)
 		goto out;
@@ -362,9 +340,6 @@ static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	int ret = -EINVAL;
 
-	if (!is_protected_kvm_enabled())
-		goto out;
-
 	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 	if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
 		goto out;
@@ -424,12 +399,8 @@ static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 static void handle___pkvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
-	struct pkvm_hyp_vm *hyp_vm;
+	struct pkvm_hyp_vm *hyp_vm = get_np_pkvm_hyp_vm(handle);
 
-	if (!is_protected_kvm_enabled())
-		return;
-
-	hyp_vm = get_np_pkvm_hyp_vm(handle);
 	if (!hyp_vm)
 		return;
 
@@ -603,14 +574,6 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__vgic_v3_get_gic_config),
 	HANDLE_FUNC(__pkvm_prot_finalize),
 
-	HANDLE_FUNC(__pkvm_host_share_hyp),
-	HANDLE_FUNC(__pkvm_host_unshare_hyp),
-	HANDLE_FUNC(__pkvm_host_share_guest),
-	HANDLE_FUNC(__pkvm_host_unshare_guest),
-	HANDLE_FUNC(__pkvm_host_relax_perms_guest),
-	HANDLE_FUNC(__pkvm_host_wrprotect_guest),
-	HANDLE_FUNC(__pkvm_host_test_clear_young_guest),
-	HANDLE_FUNC(__pkvm_host_mkyoung_guest),
 	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_vcpu_run),
 	HANDLE_FUNC(__kvm_flush_vm_context),
@@ -622,6 +585,15 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
 	HANDLE_FUNC(__vgic_v3_save_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
+
+	HANDLE_FUNC(__pkvm_host_share_hyp),
+	HANDLE_FUNC(__pkvm_host_unshare_hyp),
+	HANDLE_FUNC(__pkvm_host_share_guest),
+	HANDLE_FUNC(__pkvm_host_unshare_guest),
+	HANDLE_FUNC(__pkvm_host_relax_perms_guest),
+	HANDLE_FUNC(__pkvm_host_wrprotect_guest),
+	HANDLE_FUNC(__pkvm_host_test_clear_young_guest),
+	HANDLE_FUNC(__pkvm_host_mkyoung_guest),
 	HANDLE_FUNC(__pkvm_reserve_vm),
 	HANDLE_FUNC(__pkvm_unreserve_vm),
 	HANDLE_FUNC(__pkvm_init_vm),
@@ -635,7 +607,7 @@ static const hcall_t host_hcall[] = {
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(unsigned long, id, host_ctxt, 0);
-	unsigned long hcall_min = 0;
+	unsigned long hcall_min = 0, hcall_max = -1;
 	hcall_t hfn;
 
 	/*
@@ -647,14 +619,19 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 	 * basis. This is all fine, however, since __pkvm_prot_finalize
 	 * returns -EPERM after the first call for a given CPU.
 	 */
-	if (static_branch_unlikely(&kvm_protected_mode_initialized))
-		hcall_min = __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize;
+	if (static_branch_unlikely(&kvm_protected_mode_initialized)) {
+		hcall_min = __KVM_HOST_SMCCC_FUNC_MIN_PKVM;
+	} else {
+		hcall_max = __KVM_HOST_SMCCC_FUNC_MAX_NO_PKVM;
+	}
 
 	id &= ~ARM_SMCCC_CALL_HINTS;
 	id -= KVM_HOST_SMCCC_ID(0);
 
-	if (unlikely(id < hcall_min || id >= ARRAY_SIZE(host_hcall)))
+	if (unlikely(id < hcall_min || id > hcall_max ||
+		     id >= ARRAY_SIZE(host_hcall))) {
 		goto inval;
+	}
 
 	hfn = host_hcall[id];
 	if (unlikely(!hfn))
-- 
2.53.0.1018.g2bb0e51243-goog

