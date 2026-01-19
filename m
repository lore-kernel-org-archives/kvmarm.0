Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B719221543
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826847; cv=none; b=bbAGyKZBMQzfbO9BbCAl3T3oZyWl/TFHXYo90xwLfCnxj78ZI7ihn+PPDbUnQY8vdRolxUAFREWBN+0YLc+3jk3shHb3twzD5Cu340pL4KVgXDVpAgxIaUoW2OW/Vs4cqGFSkYLdv8/8GNShlqK5W7dzxqzL+RSOzhqAHuIzvss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826847; c=relaxed/simple;
	bh=sj0PHhGA6HVZgodozBCDNdcLTVOzrmTlBuolnKH+y2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXpOnl9EUTCgJNCaVaolO2XoNjMWCnFeFIsWStKW6j2Zxl3u/RC8Z9QtUttlBY/KqZN/N92AcAfX+lURB4JnNP7QcxRsOB9y/VAUPcEJ7bSWIbBe8BiifGJ7hhEK9N7nAEYW+D+04tYFMOQ7qJ1qRbE7oTbDTyNHNOHjCKpG+pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mXUG/Pej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mXUG/Pej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F971C116C6;
	Mon, 19 Jan 2026 12:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826847;
	bh=sj0PHhGA6HVZgodozBCDNdcLTVOzrmTlBuolnKH+y2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXUG/PejDyH/xjXwmJo0vtspMvE277de8CQtSKWmYVQMpNDtQMjXNfTq6evV9Kht/
	 cgqH0Cp908MBHpjriAeZna0GzGrtiIdRDGufoFClOgDANmjtOgXltKhJX8ka3x27tR
	 ODiYNGVQr8MZ3BjGeqAGbBhgDpm/z1W1PPxPKgNsC2p+0WGGHYoek6TwbCiOkHNkpw
	 cBzKxzF7JrMeDFdzBSeJxr03P2M7LXT/iUXThrRLEAFFYYGUqn4StH7UviXgcYVNbN
	 pHfz5h7yRnhTxiQJiwJ84FP+jjwAqns2wllp+8NR4mAosqj38kLXOuNtjgIs62occT
	 NtKZofTIZrC7Q==
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
Subject: [PATCH v2 11/35] KVM: arm64: Split teardown hypercall into two phases
Date: Mon, 19 Jan 2026 12:46:04 +0000
Message-ID: <20260119124629.2563-12-will@kernel.org>
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

In preparation for reclaiming protected guest VM pages from the host
during teardown, split the current 'pkvm_teardown_vm' hypercall into
separate 'start' and 'finalise' calls.

The 'pkvm_start_teardown_vm' hypercall puts the VM into a new 'is_dying'
state, which is a point of no return past which no vCPU of the pVM is
allowed to run any more.  Once in this new state,
'pkvm_finalize_teardown_vm' can be used to reclaim meta-data and
page-table pages from the VM. A subsequent patch will add support for
reclaiming the individual guest memory pages.

Co-developed-by: Quentin Perret <qperret@google.com>
Signed-off-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h       |  3 ++-
 arch/arm64/include/asm/kvm_host.h      |  7 +++++
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  4 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     | 14 +++++++---
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 36 ++++++++++++++++++++++----
 arch/arm64/kvm/pkvm.c                  |  7 ++++-
 6 files changed, 60 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 2076005e9253..2b5ceaed0d7e 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -89,7 +89,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___pkvm_unreserve_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
-	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
+	__KVM_HOST_SMCCC_FUNC___pkvm_start_teardown_vm,
+	__KVM_HOST_SMCCC_FUNC___pkvm_finalize_teardown_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
 	__KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
 	__KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ac7f970c7883..3191d10a2622 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -255,6 +255,13 @@ struct kvm_protected_vm {
 	struct kvm_hyp_memcache stage2_teardown_mc;
 	bool is_protected;
 	bool is_created;
+
+	/*
+	 * True when the guest is being torn down. When in this state, the
+	 * guest's vCPUs can't be loaded anymore, but its pages can be
+	 * reclaimed by the host.
+	 */
+	bool is_dying;
 };
 
 struct kvm_mpidr_data {
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 184ad7a39950..04c7ca703014 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -73,7 +73,9 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 		   unsigned long pgd_hva);
 int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 		     unsigned long vcpu_hva);
-int __pkvm_teardown_vm(pkvm_handle_t handle);
+
+int __pkvm_start_teardown_vm(pkvm_handle_t handle);
+int __pkvm_finalize_teardown_vm(pkvm_handle_t handle);
 
 struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 					 unsigned int vcpu_idx);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index eb5cfe32b2c9..ebcbdd1cb232 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -550,11 +550,18 @@ static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_init_vcpu(handle, host_vcpu, vcpu_hva);
 }
 
-static void handle___pkvm_teardown_vm(struct kvm_cpu_context *host_ctxt)
+static void handle___pkvm_start_teardown_vm(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
 
-	cpu_reg(host_ctxt, 1) = __pkvm_teardown_vm(handle);
+	cpu_reg(host_ctxt, 1) = __pkvm_start_teardown_vm(handle);
+}
+
+static void handle___pkvm_finalize_teardown_vm(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
+
+	cpu_reg(host_ctxt, 1) = __pkvm_finalize_teardown_vm(handle);
 }
 
 typedef void (*hcall_t)(struct kvm_cpu_context *);
@@ -595,7 +602,8 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__pkvm_unreserve_vm),
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
-	HANDLE_FUNC(__pkvm_teardown_vm),
+	HANDLE_FUNC(__pkvm_start_teardown_vm),
+	HANDLE_FUNC(__pkvm_finalize_teardown_vm),
 	HANDLE_FUNC(__pkvm_vcpu_load),
 	HANDLE_FUNC(__pkvm_vcpu_put),
 	HANDLE_FUNC(__pkvm_tlb_flush_vmid),
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 8911338961c5..7f8191f96fc3 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -256,7 +256,10 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
 
 	hyp_spin_lock(&vm_table_lock);
 	hyp_vm = get_vm_by_handle(handle);
-	if (!hyp_vm || hyp_vm->kvm.created_vcpus <= vcpu_idx)
+	if (!hyp_vm || hyp_vm->kvm.arch.pkvm.is_dying)
+		goto unlock;
+
+	if (hyp_vm->kvm.created_vcpus <= vcpu_idx)
 		goto unlock;
 
 	hyp_vcpu = hyp_vm->vcpus[vcpu_idx];
@@ -829,7 +832,32 @@ teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr, size_t size)
 	unmap_donated_memory_noclear(addr, size);
 }
 
-int __pkvm_teardown_vm(pkvm_handle_t handle)
+int __pkvm_start_teardown_vm(pkvm_handle_t handle)
+{
+	struct pkvm_hyp_vm *hyp_vm;
+	int ret = 0;
+
+	hyp_spin_lock(&vm_table_lock);
+	hyp_vm = get_vm_by_handle(handle);
+	if (!hyp_vm) {
+		ret = -ENOENT;
+		goto unlock;
+	} else if (WARN_ON(hyp_page_count(hyp_vm))) {
+		ret = -EBUSY;
+		goto unlock;
+	} else if (hyp_vm->kvm.arch.pkvm.is_dying) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	hyp_vm->kvm.arch.pkvm.is_dying = true;
+unlock:
+	hyp_spin_unlock(&vm_table_lock);
+
+	return ret;
+}
+
+int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 {
 	struct kvm_hyp_memcache *mc, *stage2_mc;
 	struct pkvm_hyp_vm *hyp_vm;
@@ -843,9 +871,7 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
 	if (!hyp_vm) {
 		err = -ENOENT;
 		goto err_unlock;
-	}
-
-	if (WARN_ON(hyp_page_count(hyp_vm))) {
+	} else if (!hyp_vm->kvm.arch.pkvm.is_dying) {
 		err = -EBUSY;
 		goto err_unlock;
 	}
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 20d50abb3b94..a39dacd1d617 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -88,7 +88,7 @@ void __init kvm_hyp_reserve(void)
 static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
 {
 	if (pkvm_hyp_vm_is_created(kvm)) {
-		WARN_ON(kvm_call_hyp_nvhe(__pkvm_teardown_vm,
+		WARN_ON(kvm_call_hyp_nvhe(__pkvm_finalize_teardown_vm,
 					  kvm->arch.pkvm.handle));
 	} else if (kvm->arch.pkvm.handle) {
 		/*
@@ -350,6 +350,11 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
 	if (!handle)
 		return;
 
+	if (pkvm_hyp_vm_is_created(kvm) && !kvm->arch.pkvm.is_dying) {
+		WARN_ON(kvm_call_hyp_nvhe(__pkvm_start_teardown_vm, handle));
+		kvm->arch.pkvm.is_dying = true;
+	}
+
 	__pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
 }
 
-- 
2.52.0.457.g6b5491de43-goog

