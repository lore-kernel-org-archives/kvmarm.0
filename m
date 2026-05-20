Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2208A3F0A83
	for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 15:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779290855; cv=none; b=UXHp7HnLikHfpJ2Oe3T00/D1lfUPHutIII1Lxf4uzfuIIjz+OtPKs31sb6xXsoCrKacn9pcCU8YviXAzYcBVu96K0s4b9qs1NaNJs7GCMsvSVGGhB++bTdetPZ/AkPEzj1E5kb1oDIMlekcebnxhOC4KsaGenJyP1mMLVTTvVns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779290855; c=relaxed/simple;
	bh=oWsTRU2gcybZm0t06/N84eIGptfhFROLWjlhOmAVCkU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BzeF1TW0KrknDMHSmJg64spz8N8HodJJhSvDNz3AbhGCGC9DkN5idumB+QP0UZitFb1Zzo4JYEOkgVXLW7gwD3WWhJbEbPNNLkGcUjicWm1zRl9zyx4OMs7fm1oZiQeBb4zTqL+ywtXusyu9C273bv1YFWX/ZHABVfpox1BgZ/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nvQAKJk3; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nvQAKJk3"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48e79219704so35414595e9.1
        for <kvmarm@lists.linux.dev>; Wed, 20 May 2026 08:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779290852; x=1779895652; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aHeEKF2lnPePtRIDEx7t4QMIhDc5F/CHK14oAcruyjE=;
        b=nvQAKJk3jY2mhw4RTfamU/AJfQfObCMGnDl7KMCoKOoibjQ722TbDhuoudbz1YIL9h
         bv+xjmWx0yivjjSd8X6GPIOi4kWv/aAk46mqqZTW7f2ZlRH4/8+0zSnVdPOpjEqNJEVC
         UwsSOdqc7+90VwBVbr7hqMMcwDew02r8o1lqHVmZP+dlbI6H7glm1y5RrqTPTN8IxyE3
         YkbQB/CbGZyWmQD9eCnsHxkmrdaWOBrgAZtXr1oj23L2+tZTs6Ba/R0esEFnJVUVcJIu
         twVMSuWbGZfcY7lIRhgWEYwTjPlxwhVn1W9pvVkFD5hj93HHfBlpIA3dlpqVP/xvZKbt
         rW4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779290852; x=1779895652;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aHeEKF2lnPePtRIDEx7t4QMIhDc5F/CHK14oAcruyjE=;
        b=HDSYp9RoU7EydY4NqgwntF5KSUvpgZukFCuEh7Dr45oXo1PzH9iFvyPIFLUYbk8W/z
         BaMKvlgSCazrmJY1glJUhXZaxNNyFZftojQmJi627YfvKO78onTXApa1YDGT/rlr/Cr3
         RZv/UbQcLgtApwi2RIXS9j9UwXooQsdSQoHWGTUjzT8GY1+MqAcQxk4jBqA+ggy/r9SX
         UB9NMtb07L7zf49HuPe+OLIpaE2cjcIrgMDaK95pfn8fv5rWXZ0DaC9Ynm1zuMMYWmEO
         oHCACNDct719Q+F3Grt61auUiv5rc+UOxKFCs4eemMAvv5J/SxZCoGGgQAKGRd9bsLGt
         cG9g==
X-Forwarded-Encrypted: i=1; AFNElJ81XHp5oCKCHFLpStzWBRo1cO1ZPNF0K4F8va5cP1iIoNnthWEXjH/j9XVaqcUVdETFOFNQ/YM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzihTq3Y5XrjL6sW+z4hDYJGDdPJyudRxSNo1sfnaHnrN6ZpAmj
	gXnJDD/CQTDH9Xjy/dOdiG/pf52QIRxk6T7eoxqpck2klRLFrSzaxCFUnlmJIbIx7mQKBbTTw9v
	PiXFivZfkUvhZW7ITnEhIHg==
X-Received: from wmnk6.prod.google.com ([2002:a05:600c:1686:b0:488:7c5a:b238])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fc9:b0:48e:706b:53e3 with SMTP id 5b1f17b1804b1-48fe60e51eamr343615215e9.1.1779290852340;
 Wed, 20 May 2026 08:27:32 -0700 (PDT)
Date: Wed, 20 May 2026 16:26:49 +0100
In-Reply-To: <20260520152650.4107895-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260520152650.4107895-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Message-ID: <20260520152650.4107895-17-vdonnefort@google.com>
Subject: [PATCH 16/17] KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
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

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 15c5378b70a0..d7286f2944f3 100644
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
index ebd6b5c09928..8d7e44e657eb 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -586,10 +586,9 @@ static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
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
index 7405626e103a..5932e8afce3e 100644
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
@@ -676,15 +652,6 @@ static void __unmap_donated_memory(void *va, size_t size)
 				       PAGE_ALIGN(size) >> PAGE_SHIFT));
 }
 
-static void unmap_donated_memory(void *va, size_t size)
-{
-	if (!va)
-		return;
-
-	memset(va, 0, size);
-	__unmap_donated_memory(va, size);
-}
-
 static void unmap_donated_memory_noclear(void *va, size_t size)
 {
 	if (!va)
@@ -880,16 +847,15 @@ static int register_hyp_vcpu(struct pkvm_hyp_vm *hyp_vm,
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
 
@@ -910,22 +876,10 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
 	}
 unlock:
 	hyp_spin_unlock(&vm_table_lock);
-
 	if (ret)
-		unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
-	return ret;
-}
-
-static void
-teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr, size_t size)
-{
-	size = PAGE_ALIGN(size);
-	memset(addr, 0, size);
-
-	for (void *start = addr; start < addr + size; start += PAGE_SIZE)
-		push_hyp_memcache(mc, start, hyp_virt_to_phys);
+		hyp_free(hyp_vcpu);
 
-	unmap_donated_memory_noclear(addr, size);
+	return ret;
 }
 
 int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn)
@@ -977,7 +931,7 @@ int __pkvm_start_teardown_vm(pkvm_handle_t handle)
 
 int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 {
-	struct kvm_hyp_memcache *mc, *stage2_mc;
+	struct kvm_hyp_memcache *stage2_mc;
 	struct pkvm_hyp_vm *hyp_vm;
 	struct kvm *host_kvm;
 	unsigned int idx;
@@ -998,7 +952,6 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 	hyp_spin_unlock(&vm_table_lock);
 
 	/* Reclaim guest pages (including page-table pages) */
-	mc = &host_kvm->arch.pkvm.teardown_mc;
 	stage2_mc = &host_kvm->arch.pkvm.stage2_teardown_mc;
 	reclaim_pgtable_pages(hyp_vm, stage2_mc);
 	unpin_host_vcpus(hyp_vm->vcpus, hyp_vm->kvm.created_vcpus);
@@ -1020,7 +973,7 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 			unmap_donated_memory_noclear(addr, PAGE_SIZE);
 		}
 
-		teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
+		hyp_free(hyp_vcpu);
 	}
 
 	hyp_free(hyp_vm);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8fc2e954d382..5e389099d1b6 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -178,28 +178,19 @@ static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
 
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
2.54.0.631.ge1b05301d1-goog

