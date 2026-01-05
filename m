Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F083321A1
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628209; cv=none; b=nF8JWoQ9gN6+vohSCGbSJoFOYK+8KDReQGparDw2UWi4vG2sEVQ0JThgnhJFA1OVqQZeOHXbSyewo/7H9CIx9wnhbP4W8K9fPwZsSp+DssSSrZeprCaM88p8fnMYXEKla87HlBN4ETNY+1lraFueQBsfS5CslLP9XQB2XHhvq3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628209; c=relaxed/simple;
	bh=+/NGTWZlDwhdjhF3q+DED2fDBv7biV9jEmodadqNXiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wa7aqbdBJSSLQHCO/d9LAwNuHlF4RqewbH+CbfGSD8Uv/8WsYYy0BQ4RLaEupkqvTWkZfmBU7ns4GWUzm6I7srqfJgx9pf4/c75s1+488SyZPb+Rfx1a9IEMLnxsAp4UVk5SC+6ZgWnSJJKssYqCVMqJcIXSmmjq0dAQvPVIlDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZuBtfQQe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZuBtfQQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F11EC19425;
	Mon,  5 Jan 2026 15:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628208;
	bh=+/NGTWZlDwhdjhF3q+DED2fDBv7biV9jEmodadqNXiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZuBtfQQeDu1/vsq//9QEnHF2dav6VCABvdxvsKA7R3TEQNCLuloTxL6HzWy4lIxT8
	 GY3AZVyMKsREO/yHfcCmKvRw3vML71EUmv4eE4kYytjLGOj4pgdthy5PWi58YNnSj0
	 JOBLAY09Ww5S8cOg0iZDuIX6nqBUYMu1nrfVA4yXD8Hfj3/V1LqA/r4cuO9nD1NRYw
	 3+ZSMrkCawRIfX7u0omxoEtgoYETnXrGYwsTB+Vd8+a043rOWfsHz2GEh4F9JlebU3
	 SmCk91v+uB3EXrbCtPwJNmTcoq/jgUyKhkh4HFAPCm6QL3V9Zo35cXnFa3/0eaptkr
	 3SY8O9QOdCC/g==
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
Subject: [PATCH 06/30] KVM: arm64: Remove pointless is_protected_kvm_enabled() checks from hyp
Date: Mon,  5 Jan 2026 15:49:14 +0000
Message-ID: <20260105154939.11041-7-will@kernel.org>
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

When pKVM is not enabled, the host shouldn't issue pKVM-specific
hypercalls and so there's no point checking for this in the EL2
hypercall handling code.

Remove the redundant is_protected_kvm_enabled() checks.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 33 ++----------------------------
 1 file changed, 2 insertions(+), 31 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index a7c689152f68..62a56c6084ca 100644
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
 
-- 
2.52.0.351.gbe84eed79e-goog

