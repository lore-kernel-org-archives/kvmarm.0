Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98BC44471D
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 17:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567742; cv=none; b=DglpH/2r2YUHlK82m+XyEM8E5yiDYO0YZKZAcAawJbklnULuUjUFtm9XyBvD6mPae+pWoBx+r5w0OkM6BBAWUS0R78jqKZmT4SQn1vC9YyyXW6QFj+G7rjntf9Wh3YhTbrDIXanzJ+jmpy+OVqFvljZWEw9u9CCTQtWCNkE1qxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567742; c=relaxed/simple;
	bh=ElKvCBpRN36HD5IL3mLtKEao5mBln+kjoOlR5pScR80=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YLMMKQBbHWlN0UmojPulbOuWfo2L69oYNCuESemxWHj2rboiwXtwhFSX47mQHvSNGGbHO3kCX3XN05LV6+SkSP/Kj06aR7Y9adZPnmAF8EMIWYMlyKQQ92I5hsUO1fnFFPRYrUjTt1BFrK9F+iE+kpml01bblEljjiG9yGiQyjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fn3mWnni; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fn3mWnni"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49554715277so22503965e9.1
        for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 10:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784567735; x=1785172535; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GrkVKpMCNwf2RBxoYUD5/4JMkkJy9zAl+fNvXzk+gok=;
        b=fn3mWnni8SYwPzCMYHe8/5+bYB67sffb5UiHq8pwG6aVrMS4kNV8DMmvvE1jhB1+oG
         5cGBMQ18doUjThzKhnmAMKkhYv9HTAncoWdNOpLap4hPS5Rv/5HJccZvo3Loc6xgig1T
         g/I5WzKT62W/ATeUmHPSUY65O4ojBcRwspI9miGGt9+9jZZvdsOV9jpf/BuQblSmtoJv
         BnagMFuv7cjlgFIHQMgyS5VyGBR8r3RfEURAoRNFwmUYFxgCMgJYz+zRWQD8kkp7moqr
         2HgfTHvETx3em8e1/ZwoBFUSiZwTTlubJwB5LCX9hr/JlIygIRTOtn2SPIyJiBv1noI1
         AD0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784567735; x=1785172535;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GrkVKpMCNwf2RBxoYUD5/4JMkkJy9zAl+fNvXzk+gok=;
        b=I8tFA3Qds+pmCDyPyQLOKmcxLlXAB8rDg/NrNFVKZ8ggna+f9Wipg0Bg5/MLFaY+rz
         +dgPchahJ7HNyWMaVi4TBXakI3f7YrcVw7mrUpUkVc1EhC/1vE6BH3FLhrkbkRXB0nz6
         jWYFaS2mXBgZa5njA4TmVB8tkhvnf/ivaNbf5o1SdIgb5w24lH4Ci+8WF2o4NJGONivt
         1nEhQ7FpbYp6P81qoPBTDSBfqONrfIuWBTwjiqm1Ou641IImOLk9Z7UiWISlaKbhnKfm
         b3ArdtrMTTwJESmy7y5idG6mJRV+SZBZ4/nKhNQabHPDGdFOhUVYU5L+pOhuj/zNwfkb
         bCqg==
X-Forwarded-Encrypted: i=1; AHgh+RpqCwwHT9KSkzab5yFHeewtpvDNss//e9jlqTeTE27yQokBFabHVsuEWs8LgZ48eFpqpNu8unk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyHk8LxB3RJ66eWvJNZ+qCsVl+vO449e2UfzM0oAbcxarfT8LlS
	ySxxHIrnARJmOe9dUh4rOPN63sC+bXavFu3Lvl1n/GJ0hnCrleqcbZNcDCe1vd1xZ8ern6FUGtg
	lpB6RNgystIEdT0i0inR1AQ==
X-Received: from wmbjl1.prod.google.com ([2002:a05:600c:6a81:b0:495:571e:e5e2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3107:b0:495:6400:ab62 with SMTP id 5b1f17b1804b1-4956400ab9dmr24534985e9.20.1784567734912;
 Mon, 20 Jul 2026 10:15:34 -0700 (PDT)
Date: Mon, 20 Jul 2026 18:15:09 +0100
In-Reply-To: <20260720171513.1415357-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260720171513.1415357-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260720171513.1415357-14-vdonnefort@google.com>
Subject: [PATCH v3 13/17] KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, tabba@google.com, qperret@google.com, 
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
index d99c9b1b0c82..595db3a936fe 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -575,14 +575,30 @@ static void handle___pkvm_unreserve_vm(struct kvm_cpu_context *host_ctxt)
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
index 079d6f397893..09f609db8556 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -11,6 +11,7 @@
 
 #include <asm/kvm_emulate.h>
 
+#include <nvhe/alloc.h>
 #include <nvhe/mem_protect.h>
 #include <nvhe/memory.h>
 #include <nvhe/pkvm.h>
@@ -797,24 +798,22 @@ void teardown_selftest_vm(void)
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
@@ -834,15 +833,15 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 	vm_size = pkvm_get_hyp_vm_size(nr_vcpus);
 	pgd_size = kvm_pgtable_stage2_pgd_size(host_mmu.arch.mmu.vtcr);
 
-	ret = -ENOMEM;
+	hyp_vm = hyp_alloc(vm_size);
+	if (!hyp_vm) {
+		ret = hyp_alloc_errno();
+		goto err_unpin_kvm;
+	}
 
-	hyp_vm = map_donated_memory(vm_hva, vm_size);
-	if (!hyp_vm)
-		goto err_remove_mappings;
-
-	pgd = map_donated_memory_noclear(pgd_hva, pgd_size);
-	if (!pgd)
-		goto err_remove_mappings;
+	ret = __pkvm_host_donate_hyp(hyp_virt_to_pfn(pgd), PAGE_ALIGN(pgd_size) >> PAGE_SHIFT);
+	if (ret)
+		goto err_free_hyp_vm;
 
 	init_pkvm_hyp_vm(host_kvm, hyp_vm, nr_vcpus, handle);
 
@@ -860,8 +859,9 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
 err_destroy_stage2:
 	kvm_guest_destroy_stage2(hyp_vm);
 err_remove_mappings:
-	unmap_donated_memory(hyp_vm, vm_size);
 	unmap_donated_memory(pgd, pgd_size);
+err_free_hyp_vm:
+	hyp_free(hyp_vm);
 err_unpin_kvm:
 	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
 	return ret;
@@ -997,7 +997,6 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 	struct pkvm_hyp_vm *hyp_vm;
 	struct kvm *host_kvm;
 	unsigned int idx;
-	size_t vm_size;
 	int err;
 
 	hyp_spin_lock(&vm_table_lock);
@@ -1040,8 +1039,7 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 		teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
 	}
 
-	vm_size = pkvm_get_hyp_vm_size(hyp_vm->kvm.created_vcpus);
-	teardown_donated_memory(mc, hyp_vm, vm_size);
+	hyp_free(hyp_vm);
 	hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
 	return 0;
 
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index bfbb1266491d..a9b85ad37787 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -191,8 +191,8 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
  */
 static int __pkvm_create_hyp_vm(struct kvm *kvm)
 {
-	size_t pgd_sz, hyp_vm_sz;
-	void *pgd, *hyp_vm;
+	size_t pgd_sz;
+	void *pgd;
 	int ret;
 
 	if (kvm->created_vcpus < 1)
@@ -209,28 +209,15 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
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
2.55.0.229.g6434b31f56-goog

