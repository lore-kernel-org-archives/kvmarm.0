Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A363D3C1090
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360482; cv=none; b=Jw17pHYaqn/9U/+Nr0RmtX6kmboXoWFw+0zoCvGz38bP12eJuPuzXCc4o5f+l3cU8pgI4Lf2OT9qbZWaqVBbf6P7JmUvCG9TyOJocLVelaWw+kf+VQ90H7rDFsn463XIh+MuvRHCVaXYnchD6HW/t4kxmodAbw3GhAXzHjL126A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360482; c=relaxed/simple;
	bh=BX8X5tO3dLGC6RnCJGcw/LajjIjTiacPgjdDxeATbM4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZDovmL8L37fnJU1ugZ/Ufq6qHts4CCvyfwGNZrg4iAnYSh+vHOvE8hkxyRl0D/j3vFMuyuzBrnW8J8grS5/VLf+RXwBEEpmfRAKMaG3FWNcKcxiy/3GPPoT/47zNflu8snM3HGbfyBkjgHl22F4xGQ/JKmq/yxIIvCW3E5DJj8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RqLqr682; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RqLqr682"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-493bd52dae6so21382485e9.0
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360479; x=1783965279; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PjJgRrx78t/lBCpPTJuBHDAUINVF1PcqHelNBPrxiL8=;
        b=RqLqr682wOo1U6ElWkW/cBM8+R4kfHFwmzfX8WzGN7YO+i/a2my1z46Eqhx9VDYncG
         brV2VjISFkrsYZddJroFD5yV1b1P8g0jkNhpzztV2VUB74KSo1YWfIsFS2ehyepiXcvP
         KuIDfbNM6vN1uNvPiCqfxv8p3BLcPvG2sdMnR26+tsi9praTBxlYeS8G6I42g8BiE5HR
         mPZsCxlSOhBFx46Tj8wbaIsdaq1m6mQBbC26reXhZpZrpIj+LgAJmgiITtdnt/Ty0k/u
         ESH7FwRjPkwG/XskiDFUjlRxsUx2z+INV9DQwKywFmgrOni6xhV5WmXinkGagPL+9lU4
         YlAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360479; x=1783965279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PjJgRrx78t/lBCpPTJuBHDAUINVF1PcqHelNBPrxiL8=;
        b=FsGTzdZgcoHzsq6cSWNrwft2tUFUk3VYLtFHMtc1nh3Nh9JNhuOumjVLgnmxlT0MPo
         ss5jDGP34dAJWy44FHcraw8OgC+Z3k35UohLqYGTqoKzQv/6f4Nr67fANx+qnEqX0i+9
         vRiQVsRk8jbup3dzq+0m2cKbezTd80KQzQHWw8O95lSGPf5D5A7W13ozVFeuhBhduJpd
         +Oew/3Kr9Kwmq77rDJXvrUuxWJDNouwIZY9B7gu+pAJ/WPcxIVU2u/KsUk3Mu0JstO4g
         4Se1wX2/tuT9XODYv7Ig7Ya6Sej9ds91xLlfpx+qONBjAlIB+/XSVa1KSdVu1vZxp3EU
         RPIA==
X-Forwarded-Encrypted: i=1; AHgh+RpuoCsdzbDNhw8JrxOdOn9EDMe9Q8GodX3IWBucijUOPgGiDflXGdT7q+a+JjmdKJg0o7vyLa8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4geegFzYJPFe30uDbUoTIqCojHbMqZFy9xsdFGh18kihDi1Qw
	0neusOcKQDWg3ohVyGxaIT0ekYuW8oR6DoBq21hUkmaLQRJzmckY2tWSa1tuEJy+AWHK+WfIQOG
	NPwKx3PbRLXUbtNeq2mlwOw==
X-Received: from wmxb3-n2.prod.google.com ([2002:a05:600d:8443:20b0:493:bb7e:d1fd])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b17:b0:492:43d2:9e6e with SMTP id 5b1f17b1804b1-493df04a73bmr19613005e9.9.1783360478801;
 Mon, 06 Jul 2026 10:54:38 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:54:12 +0100
In-Reply-To: <20260706175415.2604046-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-16-vdonnefort@google.com>
Subject: [PATCH v2 15/18] KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator
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
index 105313bb3dd9..16f963aedd70 100644
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
index 0c82f1ddb93d..2f616a89f8b3 100644
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
 	unmap_donated_memory_noclear(pgd, pgd_size);
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
index f7e1846d6093..8a8b5b84825c 100644
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
2.55.0.rc2.803.g1fd1e6609c-goog

