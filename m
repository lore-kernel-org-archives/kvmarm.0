Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE04F35E53A
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826834; cv=none; b=nfb4IIwkqzqJTvfGes4Q6aDJX8Ix9wHR9OecWqZwi8fTHtVO37b36MANMfKcDtePYSteM+6sx7AoIyjEPqokjFCiGaGxvNlJkk0LU46J3o9mF7tkCjktdCnjicsFcSaYXVP6kh1VypGu+otTUQf5QnlMsdRraKtvq9wrgZXZom0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826834; c=relaxed/simple;
	bh=P7Vff0Obnl6BtDLStarEz9HORF4Lb3Pvc5GIzS9FZ0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAbBd2iazt3+h6uOCm7dZiBSWmEUcGYKbKE1/3Yx5yZji8hdBFzxEPORfhKWJqcEQPgRBWUfX0q0Dl9jmOKmaPX4ADeFEyfE8Kd9UJTJpQfqvRywMntH4ErFmIKFM4n2sdXyDTVSP4kJXl+N+njQyEvGIh+0OHJ65jTxi2YCaGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dU3sDfPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dU3sDfPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1C8C4AF09;
	Mon, 19 Jan 2026 12:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826834;
	bh=P7Vff0Obnl6BtDLStarEz9HORF4Lb3Pvc5GIzS9FZ0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dU3sDfPmyxUQ/8jekbaREwhQTrQOHl9CcjNwOt7gB/M0FQOd1bWgd7yFit3GmM8EF
	 Lb1y6bMae6sH0J346bkRazF1RL6gsE1WK6SSGYmhIjIyia8zKcQ4o1aLgjjydPHmCO
	 69KryBYEngFZHeOwdvD64vyARezhNiorCzPze4u8YPs1JuxV7rkP5Bqjm9F0vGzxBi
	 goSuDBgMZMJS1w9seN5r6yfvHq57NpFc4Zq2n/Pc6MTjF9jAjy8Y4wED/oOpW7RzQA
	 gmiJnrhgN4B8zSwwnHD4zVAdj2oDU+Ol4Ad9Yqalc1of/lBJmbGV1vIAwG+Ntj/DyA
	 +aGMTkMe7t4Dw==
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
Subject: [PATCH v2 07/35] KVM: arm64: Remove is_protected_kvm_enabled() checks from hypercalls
Date: Mon, 19 Jan 2026 12:46:00 +0000
Message-ID: <20260119124629.2563-8-will@kernel.org>
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

When pKVM is not enabled, the host shouldn't issue pKVM-specific
hypercalls and so there's no point checking for this in the pKVM
hypercall handlers.

Remove the redundant is_protected_kvm_enabled() checks from each
hypercall and instead rejig the hypercall table so that the
pKVM-specific hypercalls are unreachable when pKVM is not being used.

Reviewed-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h   | 20 ++++++----
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 63 ++++++++++--------------------
 2 files changed, 32 insertions(+), 51 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index a1ad12c72ebf..2076005e9253 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -60,16 +60,9 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config,
 	__KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
+	__KVM_HOST_SMCCC_FUNC_MIN_PKVM = __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
 
 	/* Hypercalls available after pKVM finalisation */
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_relax_perms_guest,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_test_clear_young_guest,
-	__KVM_HOST_SMCCC_FUNC___pkvm_host_mkyoung_guest,
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
 	__KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
 	__KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
@@ -81,6 +74,17 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
+	__KVM_HOST_SMCCC_FUNC_MAX_NO_PKVM = __KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
+
+	/* Hypercalls available only when pKVM has finalised */
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
index a7c689152f68..eb5cfe32b2c9 100644
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
@@ -185,12 +182,8 @@ static void handle___pkvm_vcpu_load(struct kvm_cpu_context *host_ctxt)
 
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
@@ -254,9 +247,6 @@ static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	int ret = -EINVAL;
 
-	if (!is_protected_kvm_enabled())
-		goto out;
-
 	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 	if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
 		goto out;
@@ -278,9 +268,6 @@ static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
 	struct pkvm_hyp_vm *hyp_vm;
 	int ret = -EINVAL;
 
-	if (!is_protected_kvm_enabled())
-		goto out;
-
 	hyp_vm = get_np_pkvm_hyp_vm(handle);
 	if (!hyp_vm)
 		goto out;
@@ -298,9 +285,6 @@ static void handle___pkvm_host_relax_perms_guest(struct kvm_cpu_context *host_ct
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	int ret = -EINVAL;
 
-	if (!is_protected_kvm_enabled())
-		goto out;
-
 	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 	if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
 		goto out;
@@ -318,9 +302,6 @@ static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt
 	struct pkvm_hyp_vm *hyp_vm;
 	int ret = -EINVAL;
 
-	if (!is_protected_kvm_enabled())
-		goto out;
-
 	hyp_vm = get_np_pkvm_hyp_vm(handle);
 	if (!hyp_vm)
 		goto out;
@@ -340,9 +321,6 @@ static void handle___pkvm_host_test_clear_young_guest(struct kvm_cpu_context *ho
 	struct pkvm_hyp_vm *hyp_vm;
 	int ret = -EINVAL;
 
-	if (!is_protected_kvm_enabled())
-		goto out;
-
 	hyp_vm = get_np_pkvm_hyp_vm(handle);
 	if (!hyp_vm)
 		goto out;
@@ -359,9 +337,6 @@ static void handle___pkvm_host_mkyoung_guest(struct kvm_cpu_context *host_ctxt)
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	int ret = -EINVAL;
 
-	if (!is_protected_kvm_enabled())
-		goto out;
-
 	hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
 	if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
 		goto out;
@@ -421,12 +396,8 @@ static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
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
 
@@ -600,14 +571,6 @@ static const hcall_t host_hcall[] = {
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
@@ -619,6 +582,15 @@ static const hcall_t host_hcall[] = {
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
@@ -632,7 +604,7 @@ static const hcall_t host_hcall[] = {
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(unsigned long, id, host_ctxt, 0);
-	unsigned long hcall_min = 0;
+	unsigned long hcall_min = 0, hcall_max = -1;
 	hcall_t hfn;
 
 	/*
@@ -644,14 +616,19 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
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
2.52.0.457.g6b5491de43-goog

