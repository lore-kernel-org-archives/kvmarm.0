Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8632E221572
	for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 10:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754907599; cv=none; b=eoYgPw3h6HTp3Gixl7gcn1nwiJCZ+x1Fr2fZC4X6Hw6SOLnT0qI5YQDBUY+M3Q5rA0CzzOeG8hRjAmi1MCIuWBbAkdVxB/e+nJbG+D8kRAH/Yo38dCVRBbK1jz55ChtvVoOgQx6pN6VdPN4mJLZrs4Lt9LnBJaQDRb8NT+JSQgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754907599; c=relaxed/simple;
	bh=dTSszWTCnJpktp/ZfGytGKbeNpW5MSkRLrUSeximKxs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O9Jk+lmKeR6bhVHZ1U+/D/WLX+RIwHvzirGMwaPpTZV658RTpyK43c5/SbNhvLvrlO2+7XLkswCq87z1kCp6oO1SULczPWOHYooj5Bv3+o1JVKeTeHkL17ekD77ZvtewqczbfsLiBTdsBnK0yaK+2sjrZOFjMJ713UkyJje1XnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pXMzqCpY; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pXMzqCpY"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-459f53d29d2so16236025e9.1
        for <kvmarm@lists.linux.dev>; Mon, 11 Aug 2025 03:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754907596; x=1755512396; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o5pueCS/fOKzSfjilkexBjLA2W5Qyk3xjYogerS4TTw=;
        b=pXMzqCpYP0CXOizkNzyXiS9XQNFZ/ltC3Dwxla4P57mLBx9U4007DkPlKg+kQrX9SX
         WfBoIfpzkwAnZFwZcOdYVde7CJ5FTgj7A/EzHFSB/mnQ8nKI5g61pZiY3J9s1ptUd18g
         amyNO3jPUKh1bD7wXMdob6RSzf4Fn8ie1P98+626SiRlnn8sqX19/dktgpYMceXL5A5k
         C0xXhkEXvAFOsSr1FktW+PHSCoNIUnGqmOYw2h2Gs0ZLxm93nVyO9v0ImjoRc0jJ6wo4
         XHrx74gKU2BnRolyPJOaY+VInZc2cIMo3lVLvdKMt97aadbRyV2+zZviYeoRAOzSf0zs
         ZEqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754907596; x=1755512396;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o5pueCS/fOKzSfjilkexBjLA2W5Qyk3xjYogerS4TTw=;
        b=R6OHIvvtPhzWDeKVBd/d/MigbaK6PshUIJ7/NND0oOgK0qYdR1LEkU8o904xV5RneK
         fw8oQ4camnhMS9dnnelbrwY05oPRs1bhbtYCnbaHngnAVqrYm2+9pdkdHQDjE5iji3LH
         vFOLCTYyFn9LoJAMo8QE9Ti5wIKlVaLrF3DSKKkGwUXTNBam9P0W/bq/wcn1wuTu19Tn
         s9MEyKJiJrv7wxKcro3ooStmBUm6GbQOaD7IYOxeaW1YOHQZEPRUTVS6XgRNzwC4ZEvS
         dVrM2vYPqkPCSAkE3drBZ9puCY10amBMN9rh55lYKgfhBdVCbIssIwjSQ64o9v3De8/P
         SqSA==
X-Gm-Message-State: AOJu0YzKeliygpYyV+3Sacw5OxAG2vXJHFNGw6JIx3uVdxW/dKdZ6r1r
	oeUT0uukyead1oBVVpvumWVUpO0dY7JvFoPggY/00/MwmO8nKIMRzgb4ZW5nZ8bzvjm9ZNjJMBw
	yErABpBHyf4LbrHOCqGyByqpn/DiZ4JGiwSPj8BHCF7hTjcbsD9dnMDuVK86pDQ6aY+mCLLH5QP
	u1nq6ViF43Vpp2bTY4tQpxhGoNlfW+P/A=
X-Google-Smtp-Source: AGHT+IG7Rf2ElACunViDhHTs5/DZrmdq4PJ5ccV6rbZRo22WHLycgSwQYG5QQOCxwbIhnogxb8EoXIW2Dg==
X-Received: from wmc1.prod.google.com ([2002:a05:600c:6001:b0:459:db29:1efa])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:190c:b0:456:2b4d:d752
 with SMTP id 5b1f17b1804b1-459f4f98064mr85404075e9.20.1754907595820; Mon, 11
 Aug 2025 03:19:55 -0700 (PDT)
Date: Mon, 11 Aug 2025 11:19:46 +0100
In-Reply-To: <20250811101947.3637632-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250811101947.3637632-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
Message-ID: <20250811101947.3637632-8-tabba@google.com>
Subject: [PATCH v2 7/8] KVM: arm64: Introduce separate hypercalls for pKVM VM
 reservation and initialization
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org, 
	mark.rutland@arm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	vdonnefort@google.com, qperret@google.com, sebastianene@google.com, 
	keirf@google.com, smostafa@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

The existing __pkvm_init_vm hypercall performs both the reservation of a
VM table entry and the initialization of the hypervisor VM state in a
single operation. This design prevents the host from obtaining a VM
handle from the hypervisor until all preparation for the creation and
the initialization of the VM is done, which is on the first vCPU run
operation.

To support more flexible VM lifecycle management, the host needs the
ability to reserve a handle early, before the first vCPU run.

Refactor the hypercall interface to enable this, splitting the single
hypercall into a two-stage process:

- __pkvm_reserve_vm: A new hypercall that allocates a slot in the
  hypervisor's vm_table, marks it as reserved, and returns a unique
  handle to the host.

- __pkvm_unreserve_vm: A corresponding cleanup hypercall to safely
  release the reservation if the host fails to proceed with full
  initialization.

- __pkvm_init_vm: The existing hypercall is modified to no longer
  allocate a slot. It now expects a pre-reserved handle and commits the
  donated VM memory to that slot.

For now, the host-side code in __pkvm_create_hyp_vm calls the new
reserve and init hypercalls back-to-back to maintain existing behavior.
This paves the way for subsequent patches to separate the reservation
and initialization steps in the VM's lifecycle.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_asm.h       |   2 +
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |   2 +
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  14 ++++
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 102 +++++++++++++++++++------
 arch/arm64/kvm/pkvm.c                  |  12 ++-
 5 files changed, 108 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index bec227f9500a..9da54d4ee49e 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -81,6 +81,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_save_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
+	__KVM_HOST_SMCCC_FUNC___pkvm_reserve_vm,
+	__KVM_HOST_SMCCC_FUNC___pkvm_unreserve_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
 	__KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
 	__KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 4540324b5657..184ad7a39950 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -67,6 +67,8 @@ static inline bool pkvm_hyp_vm_is_protected(struct pkvm_hyp_vm *hyp_vm)
 
 void pkvm_hyp_vm_table_init(void *tbl);
 
+int __pkvm_reserve_vm(void);
+void __pkvm_unreserve_vm(pkvm_handle_t handle);
 int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 		   unsigned long pgd_hva);
 int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 3206b2c07f82..29430c031095 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -546,6 +546,18 @@ static void handle___pkvm_prot_finalize(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) = __pkvm_prot_finalize();
 }
 
+static void handle___pkvm_reserve_vm(struct kvm_cpu_context *host_ctxt)
+{
+	cpu_reg(host_ctxt, 1) = __pkvm_reserve_vm();
+}
+
+static void handle___pkvm_unreserve_vm(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
+
+	__pkvm_unreserve_vm(handle);
+}
+
 static void handle___pkvm_init_vm(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm *, host_kvm, host_ctxt, 1);
@@ -606,6 +618,8 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
 	HANDLE_FUNC(__vgic_v3_save_vmcr_aprs),
 	HANDLE_FUNC(__vgic_v3_restore_vmcr_aprs),
+	HANDLE_FUNC(__pkvm_reserve_vm),
+	HANDLE_FUNC(__pkvm_unreserve_vm),
 	HANDLE_FUNC(__pkvm_init_vm),
 	HANDLE_FUNC(__pkvm_init_vcpu),
 	HANDLE_FUNC(__pkvm_teardown_vm),
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index a9abbeb530f0..05774aed09cb 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -542,6 +542,33 @@ static int allocate_vm_table_entry(void)
 	return idx;
 }
 
+static int __insert_vm_table_entry(pkvm_handle_t handle,
+				   struct pkvm_hyp_vm *hyp_vm)
+{
+	unsigned int idx;
+
+	hyp_assert_lock_held(&vm_table_lock);
+
+	/*
+	 * Initializing protected state might have failed, yet a malicious
+	 * host could trigger this function. Thus, ensure that 'vm_table'
+	 * exists.
+	 */
+	if (unlikely(!vm_table))
+		return -EINVAL;
+
+	idx = vm_handle_to_idx(handle);
+	if (unlikely(idx >= KVM_MAX_PVMS))
+		return -EINVAL;
+
+	if (unlikely(vm_table[idx] != RESERVED_ENTRY))
+		return -EINVAL;
+
+	vm_table[idx] = hyp_vm;
+
+	return 0;
+}
+
 /*
  * Insert a pointer to the initialized VM into the VM table.
  *
@@ -550,13 +577,13 @@ static int allocate_vm_table_entry(void)
 static int insert_vm_table_entry(pkvm_handle_t handle,
 				 struct pkvm_hyp_vm *hyp_vm)
 {
-	unsigned int idx;
+	int ret;
 
-	hyp_assert_lock_held(&vm_table_lock);
-	idx = vm_handle_to_idx(handle);
-	vm_table[idx] = hyp_vm;
+	hyp_spin_lock(&vm_table_lock);
+	ret = __insert_vm_table_entry(handle, hyp_vm);
+	hyp_spin_unlock(&vm_table_lock);
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -622,8 +649,45 @@ static void unmap_donated_memory_noclear(void *va, size_t size)
 	__unmap_donated_memory(va, size);
 }
 
+/*
+ * Reserves an entry in the hypervisor for a new VM in protected mode.
+ *
+ * Return a unique handle to the VM on success, negative error code on failure.
+ */
+int __pkvm_reserve_vm(void)
+{
+	int ret;
+
+	hyp_spin_lock(&vm_table_lock);
+	ret = allocate_vm_table_entry();
+	hyp_spin_unlock(&vm_table_lock);
+
+	if (ret < 0)
+		return ret;
+
+	return idx_to_vm_handle(ret);
+}
+
+/*
+ * Removes a reserved entry, but only if is hasn't been used yet.
+ * Otherwise, the VM needs to be destroyed.
+ */
+void __pkvm_unreserve_vm(pkvm_handle_t handle)
+{
+	unsigned int idx = vm_handle_to_idx(handle);
+
+	if (unlikely(!vm_table))
+		return;
+
+	hyp_spin_lock(&vm_table_lock);
+	if (likely(idx < KVM_MAX_PVMS && vm_table[idx] == RESERVED_ENTRY))
+		remove_vm_table_entry(handle);
+	hyp_spin_unlock(&vm_table_lock);
+}
+
 /*
  * Initialize the hypervisor copy of the VM state using host-donated memory.
+ *
  * Unmap the donated memory from the host at stage 2.
  *
  * host_kvm: A pointer to the host's struct kvm.
@@ -633,8 +697,7 @@ static void unmap_donated_memory_noclear(void *va, size_t size)
  *	    the VM. Must be page aligned. Its size is implied by the VM's
  *	    VTCR.
  *
- * Return a unique handle to the VM on success,
- * negative error code on failure.
+ * Return 0 success, negative error code on failure.
  */
 int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 		   unsigned long pgd_hva)
@@ -656,6 +719,12 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 		goto err_unpin_kvm;
 	}
 
+	handle = READ_ONCE(host_kvm->arch.pkvm.handle);
+	if (unlikely(handle < HANDLE_OFFSET)) {
+		ret = -EINVAL;
+		goto err_unpin_kvm;
+	}
+
 	vm_size = pkvm_get_hyp_vm_size(nr_vcpus);
 	pgd_size = kvm_pgtable_stage2_pgd_size(host_mmu.arch.mmu.vtcr);
 
@@ -669,30 +738,19 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 	if (!pgd)
 		goto err_remove_mappings;
 
-	hyp_spin_lock(&vm_table_lock);
-	ret = allocate_vm_table_entry();
-	if (ret < 0)
-		goto err_unlock;
-
-	handle = idx_to_vm_handle(ret);
-
 	init_pkvm_hyp_vm(host_kvm, hyp_vm, nr_vcpus, handle);
 
 	ret = kvm_guest_prepare_stage2(hyp_vm, pgd);
 	if (ret)
-		goto err_remove_vm_table_entry;
+		goto err_remove_mappings;
 
+	/* Must be called last since this publishes the VM. */
 	ret = insert_vm_table_entry(handle, hyp_vm);
 	if (ret)
-		goto err_remove_vm_table_entry;
-	hyp_spin_unlock(&vm_table_lock);
+		goto err_remove_mappings;
 
-	return handle;
+	return 0;
 
-err_remove_vm_table_entry:
-	remove_vm_table_entry(handle);
-err_unlock:
-	hyp_spin_unlock(&vm_table_lock);
 err_remove_mappings:
 	unmap_donated_memory(hyp_vm, vm_size);
 	unmap_donated_memory(pgd, pgd_size);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 45d699bba96a..082bc15f436c 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -160,17 +160,25 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
 		goto free_pgd;
 	}
 
-	/* Donate the VM memory to hyp and let hyp initialize it. */
-	ret = kvm_call_hyp_nvhe(__pkvm_init_vm, kvm, hyp_vm, pgd);
+	/* Reserve the VM in hyp and obtain a hyp handle for the VM. */
+	ret = kvm_call_hyp_nvhe(__pkvm_reserve_vm);
 	if (ret < 0)
 		goto free_vm;
 
 	kvm->arch.pkvm.handle = ret;
+
+	/* Donate the VM memory to hyp and let hyp initialize it. */
+	ret = kvm_call_hyp_nvhe(__pkvm_init_vm, kvm, hyp_vm, pgd);
+	if (ret)
+		goto unreserve_vm;
+
 	kvm->arch.pkvm.is_created = true;
 	kvm->arch.pkvm.stage2_teardown_mc.flags |= HYP_MEMCACHE_ACCOUNT_STAGE2;
 	kvm_account_pgtable_pages(pgd, pgd_sz / PAGE_SIZE);
 
 	return 0;
+unreserve_vm:
+	kvm_call_hyp_nvhe(__pkvm_unreserve_vm, kvm->arch.pkvm.handle);
 free_vm:
 	free_pages_exact(hyp_vm, hyp_vm_sz);
 free_pgd:
-- 
2.50.1.703.g449372360f-goog

