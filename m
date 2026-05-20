Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FE73F23CC
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290854; cv=none; b=cjGwakE/0PzDNObSqZMOs8rNizfm3uy5ffpAudWitK3nw8waX4DBaWW2j8W4hhmCnQDpoStiZgx1e9YQKJ4rO+mzLe/caYPupOu3gHZ8iSZoRTGFhnTa0/Vo4sGqdI6Y/3vzexLQw19hMPZATV9GdiaZxVMDttUAC4s4HzmnH/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290854; c=relaxed/simple;
	bh=lyPgZ1hgTdRtofAMtq5RU0UVO16L0nT+0qEoqjJyDGY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aCoqR/kGD205VLPYXOx2Iqi99dfwxFsALfEL/TlzhL11mJp4cUZPFqAffGYEmIvBM41esVf3y+5LFIziB1A02Puar0cxQ3fDF3wv31Smj/0avocRUGNy3Fuk8aNJjU5RhwS3c/YjNbpVl3qDD/TBkoUnFkh7jkCAkJyMMD9KuTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pBcSJENB; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pBcSJENB"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43d7b7bacddso3770083f8f.0
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290851; x=1779895651; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tpWpj3dv5OUE+vpY373CnggGjNL8Kcfew3TEOiqcEjU=;
        b=pBcSJENB59aCQwg9fMSFD+1x7xizpzaFjA0RlYfbLIww52DpU1MhwySmbZZ9tkM9fx
         78FSdcISNWXLdyFFkQ9hy1iohXExkmp/MWqUbYRO5nxvQqvgPqw9agFo3d4qcV95RnLz
         NrLQdbQvqPoirq3rw/JjnCCLJ9ST8E0IEA0HPqZ3q4yuZw5oRL7Ed1Kuu3zqM57Wk5TP
         yK7/Ln3oRCpxfhA42jWSzJ+sVbYxxc7CGpJ9gsqfXMucS8KeWCeaY4nHicSWJEqS2FwS
         WD3IJMGZzh8/WBvSFnY18NuGcuaiUAbcEuG21bJJde8vS1lXRGEXqN3Zkw60ekjX0zqd
         o+9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290851; x=1779895651;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tpWpj3dv5OUE+vpY373CnggGjNL8Kcfew3TEOiqcEjU=;
        b=CLb9UFKhp9ByjrRqqCA9TKMT5ZVmbbo3+bMxn7BZtZa71y9+Iasj3xIj5J2w1qy1Gz
         1NmSJKr1sKW7YjgUm4hG1/wO9MYKr5FKH2KjX0dqiRq5FfYba3+nnl9dUA64iDZVZ9a1
         z8e3cpKFuAF+zGzuJwTx1porfsx00DWs8XHOch9Snck//JL2JMZhfvaCJdi9nMKNksYh
         sRlrCDqto8i71EhUQ2YwSoWX6a0o/Lxq0nDHm+WF+zVCe185nTCKS/Rj7vR5s3/DYwJ0
         wdvJxf3G20cOzXpNUQJ2PPN4uxbJd/NGO7XcL49tkR3PolKiOvFQNlxAYRKRg0gUq+qB
         fc1A==
X-Forwarded-Encrypted: i=1; AFNElJ+veAwXkU4D4KmWqq1jqnZF67a+a5ASQ4csTjtsH+H330hBGX84L8LRaPoe9o7w5zVDEdDxlgI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwiIpt3upqYsMPYEaTz3ISmnWOVZkhpWf6J7BY+k766OJr/nceR
	cGGJ7yqmPHZdgndG6hqoWBYfA5BZFBH7bkGbuFw4+e3cK9M+PehTSCsOkqQ8r5fd+2KJVT5/7JB
	a3e7WK2dJ3OPUfZW8NWd8aQ==
X-Received: from wrzq17.prod.google.com ([2002:a05:6000:1371:b0:44c:2531:86ce])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:400d:b0:449:af52:6167 with SMTP id ffacd0b85a97d-45e5c58fd33mr40232381f8f.8.1779290850878;
 Wed, 20 May 2026 08:27:30 -0700 (PDT)
Date: Wed, 20 May 2026 16:26:48 +0100
In-Reply-To: <20260520152650.4107895-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520152650.4107895-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Message-ID: <20260520152650.4107895-16-vdonnefort@google.com>
Subject: [PATCH 15/17] KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Transition the allocation of the hypervisor VM state structure
(pkvm_hyp_vm) from the host to the hypervisor using
the new pKVM heap allocator (hyp_alloc()).

Previously, the host was responsible for calculating the size of,
allocating, and donating memory for pkvm_hyp_vm during VM creation. With
the heap allocator in place, the hypervisor now allocates this structure
dynamically at EL2.

Use the pkvm_call_hyp_req() wrapper in the host to invoke
__pkvm_init_vm, which automatically handles any top-up requests if the
hypervisor runs out of heap memory during allocation.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/hyp-constants.c b/arch/arm64/kvm/hyp/hyp-constants.c
index b257a3b4bfc5..501ab35a3840 100644
--- a/arch/arm64/kvm/hyp/hyp-constants.c
+++ b/arch/arm64/kvm/hyp/hyp-constants.c
@@ -7,7 +7,6 @@
 int main(void)
 {
 	DEFINE(STRUCT_HYP_PAGE_SIZE,	sizeof(struct hyp_page));
-	DEFINE(PKVM_HYP_VM_SIZE,	sizeof(struct pkvm_hyp_vm));
 	DEFINE(PKVM_HYP_VCPU_SIZE,	sizeof(struct pkvm_hyp_vcpu));
 	return 0;
 }
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 624367d0ef5b..8e930c8729af 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -82,8 +82,7 @@ void pkvm_hyp_vm_table_init(void *tbl);
 
 int __pkvm_reserve_vm(void);
 void __pkvm_unreserve_vm(pkvm_handle_t handle);
-int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
-		   unsigned long pgd_hva);
+int __pkvm_init_vm(struct kvm *host_kvm, void *pgd);
 int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 		     unsigned long vcpu_hva);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 4e7db8b48614..ebd6b5c09928 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -556,14 +556,30 @@ static void handle___pkvm_unreserve_vm(struct kvm_cpu_context *host_ctxt)
 	__pkvm_unreserve_vm(handle);
 }
 
+static void errno_to_smccc(int ret, struct kvm_cpu_context *host_ctxt)
+{
+	struct pkvm_hyp_req req = { .type = PKVM_HYP_NO_REQ };
+
+	switch (ret) {
+	case -ENOMEM:
+		req.type = PKVM_HYP_REQ_HYP_ALLOC;
+		req.mem.nr_pages = hyp_alloc_topup_needed();
+		break;
+	}
+
+	cpu_reg(host_ctxt, 1) = ret;
+	pkvm_hyp_req_to_smccc(host_ctxt, &req);
+}
+
 static void handle___pkvm_init_vm(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm *, host_kvm, host_ctxt, 1);
-	DECLARE_REG(unsigned long, vm_hva, host_ctxt, 2);
-	DECLARE_REG(unsigned long, pgd_hva, host_ctxt, 3);
+	DECLARE_REG(unsigned long, pgd_hva, host_ctxt, 2);
+	void *pgd;
 
 	host_kvm = kern_hyp_va(host_kvm);
-	cpu_reg(host_ctxt, 1) = __pkvm_init_vm(host_kvm, vm_hva, pgd_hva);
+	pgd = (void *)kern_hyp_va(pgd_hva);
+	errno_to_smccc(__pkvm_init_vm(host_kvm, pgd), host_ctxt);
 }
 
 static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 3e7f7606a3da..7405626e103a 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -11,6 +11,7 @@
 
 #include <asm/kvm_emulate.h>
 
+#include <nvhe/alloc.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/memory.h>
 #include <nvhe/pkvm.h>
@@ -783,24 +784,22 @@ void teardown_selftest_vm(void)
  * Unmap the donated memory from the host at stage 2.
  *
  * host_kvm: A pointer to the host's struct kvm.
- * vm_hva: The host va of the area being donated for the VM state.
- *	   Must be page aligned.
- * pgd_hva: The host va of the area being donated for the stage-2 PGD for
- *	    the VM. Must be page aligned. Its size is implied by the VM's
- *	    VTCR.
+ * pgd: The va of the area being donated for the stage-2 PGD for the VM. Must
+ *      be page aligned. Its size is implied by the VM's VTCR.
  *
  * Return 0 success, negative error code on failure.
  */
-int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
-		   unsigned long pgd_hva)
+int __pkvm_init_vm(struct kvm *host_kvm, void *pgd)
 {
 	struct pkvm_hyp_vm *hyp_vm = NULL;
 	size_t vm_size, pgd_size;
 	unsigned int nr_vcpus;
 	pkvm_handle_t handle;
-	void *pgd = NULL;
 	int ret;
 
+	if (!PAGE_ALIGNED(pgd))
+		return -EINVAL;
+
 	ret = hyp_pin_shared_mem(host_kvm, host_kvm + 1);
 	if (ret)
 		return ret;
@@ -820,15 +819,15 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 	vm_size = pkvm_get_hyp_vm_size(nr_vcpus);
 	pgd_size = kvm_pgtable_stage2_pgd_size(host_mmu.arch.mmu.vtcr);
 
-	ret = -ENOMEM;
-
-	hyp_vm = map_donated_memory(vm_hva, vm_size);
-	if (!hyp_vm)
-		goto err_remove_mappings;
+	hyp_vm = hyp_alloc(vm_size);
+	if (!hyp_vm) {
+		ret = hyp_alloc_errno();
+		goto err_unpin_kvm;
+	}
 
-	pgd = map_donated_memory_noclear(pgd_hva, pgd_size);
-	if (!pgd)
-		goto err_remove_mappings;
+	ret = __pkvm_host_donate_hyp(hyp_virt_to_pfn(pgd), PAGE_ALIGN(pgd_size) >> PAGE_SHIFT);
+	if (ret)
+		goto err_free_hyp_vm;
 
 	init_pkvm_hyp_vm(host_kvm, hyp_vm, nr_vcpus, handle);
 
@@ -844,8 +843,9 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 	return 0;
 
 err_remove_mappings:
-	unmap_donated_memory(hyp_vm, vm_size);
 	unmap_donated_memory_noclear(pgd, pgd_size);
+err_free_hyp_vm:
+	hyp_free(hyp_vm);
 err_unpin_kvm:
 	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
 	return ret;
@@ -981,7 +981,6 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 	struct pkvm_hyp_vm *hyp_vm;
 	struct kvm *host_kvm;
 	unsigned int idx;
-	size_t vm_size;
 	int err;
 
 	hyp_spin_lock(&vm_table_lock);
@@ -1024,8 +1023,7 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 		teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
 	}
 
-	vm_size = pkvm_get_hyp_vm_size(hyp_vm->kvm.created_vcpus);
-	teardown_donated_memory(mc, hyp_vm, vm_size);
+	hyp_free(hyp_vm);
 	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
 	return 0;
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 15281ae1be39..8fc2e954d382 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -216,8 +216,8 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
  */
 static int __pkvm_create_hyp_vm(struct kvm *kvm)
 {
-	size_t pgd_sz, hyp_vm_sz;
-	void *pgd, *hyp_vm;
+	size_t pgd_sz;
+	void *pgd;
 	int ret;
 
 	if (kvm->created_vcpus < 1)
@@ -234,28 +234,15 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
 	if (!pgd)
 		return -ENOMEM;
 
-	/* Allocate memory to donate to hyp for vm and vcpu pointers. */
-	hyp_vm_sz = PAGE_ALIGN(size_add(PKVM_HYP_VM_SIZE,
-					size_mul(sizeof(void *),
-						 kvm->created_vcpus)));
-	hyp_vm = alloc_pages_exact(hyp_vm_sz, GFP_KERNEL_ACCOUNT);
-	if (!hyp_vm) {
-		ret = -ENOMEM;
-		goto free_pgd;
-	}
-
-	/* Donate the VM memory to hyp and let hyp initialize it. */
-	ret = kvm_call_hyp_nvhe(__pkvm_init_vm, kvm, hyp_vm, pgd);
+	ret = pkvm_call_hyp_req(__pkvm_init_vm, kvm, pgd);
 	if (ret)
-		goto free_vm;
+		goto free_pgd;
 
 	kvm->arch.pkvm.is_created = true;
 	init_hyp_stage2_memcache(&kvm->arch.pkvm.stage2_teardown_mc);
 	kvm_account_pgtable_pages(pgd, pgd_sz / PAGE_SIZE);
 
 	return 0;
-free_vm:
-	free_pages_exact(hyp_vm, hyp_vm_sz);
 free_pgd:
 	free_pages_exact(pgd, pgd_sz);
 	return ret;
-- 
2.54.0.631.ge1b05301d1-goog

