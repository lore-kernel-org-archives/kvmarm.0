Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3703E8340
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508573; cv=none; b=JoqRwrH7YKjiVqy1Vzy6quLWw/mGB/PLfsTHChdXTWH8OxNMIQibpvpjEmPFdy7D5fl+Gd/LY4Qy5CiDGPIAw43g+7IyorL81EtnUw82g+dfBIN8TjAjqndAMI9QxpmkKhPsA3kQakbswcPAfcjhklj2yKs2ZgwZTyjO1SWfWbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508573; c=relaxed/simple;
	bh=Vkpdeo2DLNlW6KXlnHyS4b2fRY4rJpt8C+QAM58GUs0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mhq3JKacpj6KwX+gtkPY6W4WhSHiVvOWrQuRAisoyMCL7FZ7Jt/F4+yeX0YmMGfuA+X5r25Pab2W3dpjdStLQvPMai42gAudcpinEr04NFgqUSoggtC4TIwMHzUXaKa3kgeydcTJqm+sdkw0YEChlVKl5J5KyRU5ObJ+fMCDV4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UAu0bl8O; arc=none smtp.client-ip=209.85.221.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UAu0bl8O"
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47f90dbaf84so1133426f8f.1
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 07:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785508570; x=1786113370; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rC7P//Si5Syi6+suIs8g5/9Mikv3hK7Eoc6xXVkZp5o=;
        b=UAu0bl8O4riUPuTwQK9ShnXxMiQUjHYSnt34J5vVosikObqVbo+ML9JeJLCKJRwwiO
         OnklarbMfash7L8jy4vjJy2TgjaWtr0r18zG1UHtVKhxCUtwaW0G+vQrFIBPSn71nk6c
         Oae77Uz0dkn1/5seAjygFPR4yQFd3OJPb3gVaLXScSSoLowaoeffMUI9NXhEHmEVC/Og
         aqeh59+b6A7VqmCkD9uSSs2ipJcutKCFCZaIeWwe2aKW2kJLgMIlrSPlHYX/IrmX2x6P
         P/jRYBUXS2ajbrLBwBk+XW9t7W/3Vsq1uR/hp8c8N7STqT5oUhN2/nWbRIIZOWYoZgP/
         okAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785508570; x=1786113370;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rC7P//Si5Syi6+suIs8g5/9Mikv3hK7Eoc6xXVkZp5o=;
        b=RfpTAxme7uO+oioBUH3CSgUhM4Y0KT+8NeCzPkAzdNXFUO1+/b6DqxM5iiQIKpVDxX
         oCdTDdjr1QZQs/1s5YjGnXtgiTj9c3J59w0+RW+IWTywDS2n+c1uIWreFK90qDyrxAHS
         2kiFO7nYsKe5nrLYhqkdIOJel++eYKhwtWYgs6ENXr283IurAh9AMJmR8JPNlwSC4Vgs
         ZUAEpYwBc4yi/xi0FE/ngLYrHNYypeHHIunqCV2QWsz+MdRb0N4tH72vsBWwHsLiI7s8
         CvAcK+K+SP4Rkv1T/6oz8zGLdmsqyFkI01/ktfpKtQi+6Qrnhf7qZ9egGG8MfRYA52oM
         JRhA==
X-Forwarded-Encrypted: i=1; AHgh+Rri2M4xKFo/nUVFWBQfD8f/nBDAtx4lDnPFIrH3Hp5LjWyuI9bs+Z9dnfqVzA5/cCRQpSLe5b8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzM05kCv4fl7jHdv7aMBXMMwz60CDSTDf7VYu06WSYQqDXkN8ZD
	1vlczUbGcsaTj+NKkrOMViwk7+F9WjiyEzR5L6e/Y0G3ITewdkUNuyGZjqMYnbqvaY8QPnQANh8
	tMpnRPHAw+HKr5vInTsymIg==
X-Received: from wrbbs10.prod.google.com ([2002:a05:6000:70a:b0:47f:5283:bee3])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:29c2:b0:47f:bef8:d559 with SMTP id ffacd0b85a97d-47fd2b55dfbmr3469292f8f.45.1785508569324;
 Fri, 31 Jul 2026 07:36:09 -0700 (PDT)
Date: Fri, 31 Jul 2026 15:35:37 +0100
In-Reply-To: <20260731143541.956291-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731143541.956291-14-vdonnefort@google.com>
Subject: [PATCH v4 13/17] KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
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

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
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
index d99c9b1b0c82..c1aa6d773c26 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -575,14 +575,35 @@ static void handle___pkvm_unreserve_vm(struct kvm_cpu_context *host_ctxt)
 	__pkvm_unreserve_vm(handle);
 }
 
+static void errno_to_smccc(int ret, struct kvm_cpu_context *host_ctxt)
+{
+	struct pkvm_hyp_req req = { .type = PKVM_HYP_NO_REQ };
+
+	switch (ret) {
+	case -ENOMEM: {
+		u32 nr_pages = hyp_alloc_topup_needed();
+
+		if (nr_pages) {
+			req.type = PKVM_HYP_REQ_HYP_ALLOC;
+			req.mem.nr_pages = nr_pages;
+		}
+		break;
+	}
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
2.55.0.508.g3f0d502094-goog

