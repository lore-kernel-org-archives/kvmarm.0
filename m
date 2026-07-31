Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7140A340A7F
	for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 14:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785508574; cv=none; b=PgYnz2gGFPiJPZgZEYZk+Vkxrp2+m9J0ULTixw4apPsWr97EFOxS7I9uaChfOrixIFOcP/vqayTp9G0wa1/N47RhOo7wNiS7cYtNxKeMhsZiSvUf20zXm4mgp0JW4NFYC0qbzsIoK5wWIBisG9LD8ocpt8Xg2NsSrDUWZEQRjwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785508574; c=relaxed/simple;
	bh=hx9dUeE58mqEQx4ZFquRlKLVarpXqhmubgX62sdm22s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u7jUhgX8BqVWJiEK82eCxT/p9LOCqk8hWqeun0YFScgQfGpb8NHo/uLU6o1Nj+xDPJjwkUzz6lLT6inwVmDUGdnSMaJ/KL+uc2PQ8qZBo+5ZXJn0fmhtEc6rqvPpwHVdkj0SQoxtaIAm+A/vv7n9QROH0PtzzXiDRBPaBDQ5kAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dKPMDQEd; arc=none smtp.client-ip=209.85.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dKPMDQEd"
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6983e9c028dso1074544a12.3
        for <kvmarm@lists.linux.dev>; Fri, 31 Jul 2026 07:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785508571; x=1786113371; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aI0+Hi/djXmMPb+x1nojj/XrCI3K8+CQmKXAZ7dP3bY=;
        b=dKPMDQEdKv/SFC20KzROyQdw359peQN4puV4ymey5hUyNvDpr8ZeqSPMFzNE1HyRL+
         r3b8cKFie6Aqm0e4+eYpA2aeeDRFbBGFOHkyQoo93BXz3DTgJD8igU1E3HGET2Ur8MxU
         4hHK2lLReBGHM5Q/euaOLZ1l0m//fYp1fNIrZdK6sXZrDvQ7SupoVCUMyXJksPOa5IKd
         bCK9p5j6xa694YZ5pn6pnRkwDKmyTJDmKa5muWoThIKT7rvijUcarSgKpFX7gZ5qX+uz
         F+eMJAdse8qbAn+DQoscCfixx4mbqzzXZQ5WxFm2+7lBCZklLm9TB3TJLLzW+b3A0WpS
         ggOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785508571; x=1786113371;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aI0+Hi/djXmMPb+x1nojj/XrCI3K8+CQmKXAZ7dP3bY=;
        b=NZtrmFKwLnFY8T3ZrXVBr0dsMNA9Vrgaxvl2YKjQ1Wxsdlrax2byL7eQmsvIBuu372
         Lu9MtkFYf22s6tvPab/bHW3h151yGH/lc0TFinUi9KKR3hilJg9reIM+YGpWNh//7ie7
         wpFeLbhbUp2HUEv9U7icrWEvnx0VWiwKrAV6cGr7XafoKmh84rbk+eWYWgXZliJLiWCh
         G18nMbQezvVMB0bvIs6oiVkwzmo8oNSlJ/oM32ktbcalKHFMZ4TU8LeZA7U77BQSMaqP
         DFg9zHGTASzSh7yhs1XsY3UlMwgkUQwaAaIAGqBYU8+DtkbClpenvSyGetZDfEhhC5Au
         IMJg==
X-Forwarded-Encrypted: i=1; AHgh+RrtZUag2gwiA51TJ5FfBxM4MzxTX0MR8VbMKUuFt58cbpnDBlpx+upWM9LelwQ8lTmZ+UpRLJM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwFmIacPNQSHnXjDUGp18dzwrlnpnCZsndwcBZYK+k7H4L3sdg5
	lxQnj4Lo2AMyypRANJPS2VObHHQIFP4SRuJBYGzowgEKbWdk0mROL3XtvKiE3UUpK8BjIO+mpG2
	9EviO3RMDbqauyBfnaKfGiA==
X-Received: from wmbil26.prod.google.com ([2002:a05:600c:a59a:b0:48f:dc9f:6f1a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:548f:b0:699:f3b8:165c with SMTP id 4fb4d7f45d1cf-6a098d1bbd7mr1468467a12.28.1785508570397;
 Fri, 31 Jul 2026 07:36:10 -0700 (PDT)
Date: Fri, 31 Jul 2026 15:35:38 +0100
In-Reply-To: <20260731143541.956291-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260731143541.956291-15-vdonnefort@google.com>
Subject: [PATCH v4 14/17] KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Transition the allocation of the hypervisor vCPU state structure
(pkvm_hyp_vcpu) from the host to the hypervisor using the new pKVM heap
allocator (hyp_alloc()).

Previously, the host was responsible for calculating the size of,
allocating, and donating memory for pkvm_hyp_vcpu during VM creation.
With the heap allocator in place, the hypervisor now allocates this
structure dynamically at EL2.

Use the pkvm_call_hyp_req() wrapper in the host to invoke
__pkvm_create_hyp_vcpu, which automatically handles any top-up requests
if the hypervisor runs out of heap memory during allocation.

Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index caea8e9986d1..95e05cee0f3a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -268,7 +268,6 @@ typedef u16 pkvm_handle_t;
 
 struct kvm_protected_vm {
 	pkvm_handle_t handle;
-	struct kvm_hyp_memcache teardown_mc;
 	struct kvm_hyp_memcache stage2_teardown_mc;
 	bool is_protected;
 	bool is_created;
diff --git a/arch/arm64/kvm/hyp/hyp-constants.c b/arch/arm64/kvm/hyp/hyp-constants.c
index 501ab35a3840..b2caae21f271 100644
--- a/arch/arm64/kvm/hyp/hyp-constants.c
+++ b/arch/arm64/kvm/hyp/hyp-constants.c
@@ -7,6 +7,5 @@
 int main(void)
 {
 	DEFINE(STRUCT_HYP_PAGE_SIZE,	sizeof(struct hyp_page));
-	DEFINE(PKVM_HYP_VCPU_SIZE,	sizeof(struct pkvm_hyp_vcpu));
 	return 0;
 }
diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
index 8e930c8729af..cfb6e409bf49 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -83,8 +83,7 @@ void pkvm_hyp_vm_table_init(void *tbl);
 int __pkvm_reserve_vm(void);
 void __pkvm_unreserve_vm(pkvm_handle_t handle);
 int __pkvm_init_vm(struct kvm *host_kvm, void *pgd);
-int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
-		     unsigned long vcpu_hva);
+int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu);
 
 int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn);
 int __pkvm_start_teardown_vm(pkvm_handle_t handle);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index c1aa6d773c26..9bab1e802281 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -610,10 +610,9 @@ static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
 	DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 2);
-	DECLARE_REG(unsigned long, vcpu_hva, host_ctxt, 3);
 
 	host_vcpu = kern_hyp_va(host_vcpu);
-	cpu_reg(host_ctxt, 1) = __pkvm_init_vcpu(handle, host_vcpu, vcpu_hva);
+	errno_to_smccc(__pkvm_init_vcpu(handle, host_vcpu), host_ctxt);
 }
 
 static void handle___pkvm_vcpu_in_poison_fault(struct kvm_cpu_context *host_ctxt)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 09f609db8556..fffd2f4bc071 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -645,30 +645,6 @@ static size_t pkvm_get_hyp_vm_size(unsigned int nr_vcpus)
 		size_mul(sizeof(struct pkvm_hyp_vcpu *), nr_vcpus));
 }
 
-static void *map_donated_memory_noclear(unsigned long host_va, size_t size)
-{
-	void *va = (void *)kern_hyp_va(host_va);
-
-	if (!PAGE_ALIGNED(va))
-		return NULL;
-
-	if (__pkvm_host_donate_hyp(hyp_virt_to_pfn(va),
-				   PAGE_ALIGN(size) >> PAGE_SHIFT))
-		return NULL;
-
-	return va;
-}
-
-static void *map_donated_memory(unsigned long host_va, size_t size)
-{
-	void *va = map_donated_memory_noclear(host_va, size);
-
-	if (va)
-		memset(va, 0, size);
-
-	return va;
-}
-
 static void __unmap_donated_memory(void *va, size_t size)
 {
 	kvm_flush_dcache_to_poc(va, size);
@@ -896,16 +872,15 @@ static int register_hyp_vcpu(struct pkvm_hyp_vm *hyp_vm,
 	return 0;
 }
 
-int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
-		     unsigned long vcpu_hva)
+int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu)
 {
 	struct pkvm_hyp_vcpu *hyp_vcpu;
 	struct pkvm_hyp_vm *hyp_vm;
 	int ret;
 
-	hyp_vcpu = map_donated_memory(vcpu_hva, sizeof(*hyp_vcpu));
+	hyp_vcpu = hyp_alloc(sizeof(*hyp_vcpu));
 	if (!hyp_vcpu)
-		return -ENOMEM;
+		return hyp_alloc_errno();
 
 	hyp_spin_lock(&vm_table_lock);
 
@@ -926,24 +901,12 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 	}
 unlock:
 	hyp_spin_unlock(&vm_table_lock);
-
 	if (ret)
-		unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
+		hyp_free(hyp_vcpu);
+
 	return ret;
 }
 
-static void
-teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr, size_t size)
-{
-	size = PAGE_ALIGN(size);
-	memset(addr, 0, size);
-
-	for (void *start = addr; start < addr + size; start += PAGE_SIZE)
-		push_hyp_memcache(mc, start, hyp_virt_to_phys);
-
-	unmap_donated_memory_noclear(addr, size);
-}
-
 int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn)
 {
 	struct pkvm_hyp_vm *hyp_vm = get_pkvm_hyp_vm(handle);
@@ -993,7 +956,7 @@ int __pkvm_start_teardown_vm(pkvm_handle_t handle)
 
 int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 {
-	struct kvm_hyp_memcache *mc, *stage2_mc;
+	struct kvm_hyp_memcache *stage2_mc;
 	struct pkvm_hyp_vm *hyp_vm;
 	struct kvm *host_kvm;
 	unsigned int idx;
@@ -1014,7 +977,6 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 	hyp_spin_unlock(&vm_table_lock);
 
 	/* Reclaim guest pages (including page-table pages) */
-	mc = &host_kvm->arch.pkvm.teardown_mc;
 	stage2_mc = &host_kvm->arch.pkvm.stage2_teardown_mc;
 	reclaim_pgtable_pages(hyp_vm, stage2_mc);
 	unpin_host_vcpus(hyp_vm->vcpus, hyp_vm->kvm.created_vcpus);
@@ -1036,7 +998,7 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 			unmap_donated_memory_noclear(addr, PAGE_SIZE);
 		}
 
-		teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
+		hyp_free(hyp_vcpu);
 	}
 
 	hyp_free(hyp_vm);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index a9b85ad37787..3b29b3f43ffa 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -153,28 +153,19 @@ static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
 
 	kvm->arch.pkvm.handle = 0;
 	kvm->arch.pkvm.is_created = false;
-	free_hyp_memcache(&kvm->arch.pkvm.teardown_mc);
 	free_hyp_memcache(&kvm->arch.pkvm.stage2_teardown_mc);
 }
 
 static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
 {
-	size_t hyp_vcpu_sz = PAGE_ALIGN(PKVM_HYP_VCPU_SIZE);
 	pkvm_handle_t handle = vcpu->kvm->arch.pkvm.handle;
-	void *hyp_vcpu;
 	int ret;
 
 	init_hyp_stage2_memcache(&vcpu->arch.pkvm_memcache);
 
-	hyp_vcpu = alloc_pages_exact(hyp_vcpu_sz, GFP_KERNEL_ACCOUNT);
-	if (!hyp_vcpu)
-		return -ENOMEM;
-
-	ret = kvm_call_hyp_nvhe(__pkvm_init_vcpu, handle, vcpu, hyp_vcpu);
+	ret = pkvm_call_hyp_req(__pkvm_init_vcpu, handle, vcpu);
 	if (!ret)
 		vcpu_set_flag(vcpu, VCPU_PKVM_FINALIZED);
-	else
-		free_pages_exact(hyp_vcpu, hyp_vcpu_sz);
 
 	return ret;
 }
-- 
2.55.0.508.g3f0d502094-goog

