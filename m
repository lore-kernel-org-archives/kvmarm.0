Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B183BADA2
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 17:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360483; cv=none; b=T2rpoSIYjivPDAOkUQWrRIRQtg79waM2SIy6MY5GF5w05Q8UpR9NoQ0/hJEXUwB5UZWtsUPOoe6EhIOYOZenf/TXbI+53btdE0CZ0Jgq41gwgnc6HNenDGe9IpLP/6Q5QU8t2u92ZwUxHj9Dnhsyh8FBf4+MTuHpEmyfRUsNVME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360483; c=relaxed/simple;
	bh=y/rmV4LPK3grKrzjqurrOccNME+O08NlSW6weqQ4PIU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gphmhnsA5ylV942vFpwBVPRwhM3p/QJNv550uvSNMcJwaOKeN1/fKkn95WZh93zq1IdyFzE5Yu4nIVee7grLbSvz+EQa+SdopE1xDsPdTNtFe5Bp68+vimAyPFho8I6iyBdBKRS+kaaIYDHKJXgVL9CT30r5LBNTXvp03MKimfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KqBEjlxp; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KqBEjlxp"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493c588b6f2so22937505e9.0
        for <kvmarm@lists.linux.dev>; Mon, 06 Jul 2026 10:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783360480; x=1783965280; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZS9uKd3cEwAmOnLh1MV9E8XR17kXmjyzBD/yH7Jx8qA=;
        b=KqBEjlxprjn8LOxrePrsFJrttOzSDBMRf2elye8WsmLGRoWQcor1uxa9FIMmend/Jb
         CL/67KsRk8QVD9wMReCBONZ/dW1+lYaqUkhE+y3m51pft9LnMM3TAbBKVnt/oFlHdBuX
         uS4R0uWIoseM+5ldiTMmkaA+VdsJMAlGyKUU+lax75I5XwRuXo6p/6bZCHMYQziElXb7
         vokt3J7ObmKKohOYYXitDZym523+rFcesxZzhTsfBWz22Dl5L3BpmdVxrLnRipcjLNQG
         3m15+cYROBjfq57FEfk7uNklsR/54mH9Kb8hTZ3Z4K3f7YGEBJ8RCAJzEyuVuh5AZbmF
         Y4/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783360480; x=1783965280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZS9uKd3cEwAmOnLh1MV9E8XR17kXmjyzBD/yH7Jx8qA=;
        b=b8PBYVzn+vxLw/N6utEU8o1LPjR4aqPw73Av65iqF2sujNpJofJjq+KZguH4dFZ4+g
         afZwPMQuMKXN9hvN36oD6gsui3uLUcGYKdJ6/u0XvLhB6u1mDhkT6W1XMYapZl0oTlCa
         8Q1rUNswArDSmeJYw25O43vHhHMNQXxQtgCeQOrGJt1IcUhzFoqNKQz7R9x38Nps94RY
         84Wsa2js84I6FVwFz8qb8Vv/pMRQA53RaJWyP1ko6dkyrEAAA1rfmvTTWf4F8mAAJHTU
         wfJwjLiiQ7md7RXR7uTg+qAhCFTaPD6Yw68txkIyS4EdNJoS+J0eLVVh/+Ul+QQhK8qP
         Wxxw==
X-Forwarded-Encrypted: i=1; AHgh+RoJNAIr9JZP4IH4ERrtBuSESqv7ZhpSL3QJzfiWmKY3Oso+WjUSqk5v3cC1QW0geerGI+/JMx4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwlTCH6p6Lkky7oXRKpjFISL5y4xjL96F9MKJ4AjjkFrGfgmPdw
	dVfLAbFfDJ0h4AY6cuhucICC60T5chgENyKlojYzBed+UrWFOw76maxpbd619vP8Fkr51IUScOJ
	QhNknJ6kc0zxu2m5mDh0/kw==
X-Received: from wmth11.prod.google.com ([2002:a05:600c:8b6b:b0:492:4e77:8950])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6994:b0:490:9588:bdb6 with SMTP id 5b1f17b1804b1-493df09a21dmr17691335e9.33.1783360479836;
 Mon, 06 Jul 2026 10:54:39 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:54:13 +0100
In-Reply-To: <20260706175415.2604046-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260706175415.2604046-17-vdonnefort@google.com>
Subject: [PATCH v2 16/18] KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator
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
index 16f963aedd70..1315129dcd1f 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -605,10 +605,9 @@ static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
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
index 2f616a89f8b3..45ec77e9eca8 100644
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
@@ -896,16 +863,15 @@ static int register_hyp_vcpu(struct pkvm_hyp_vm *hyp_vm,
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
 
@@ -926,24 +892,12 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
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
@@ -993,7 +947,7 @@ int __pkvm_start_teardown_vm(pkvm_handle_t handle)
 
 int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 {
-	struct kvm_hyp_memcache *mc, *stage2_mc;
+	struct kvm_hyp_memcache *stage2_mc;
 	struct pkvm_hyp_vm *hyp_vm;
 	struct kvm *host_kvm;
 	unsigned int idx;
@@ -1014,7 +968,6 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 	hyp_spin_unlock(&vm_table_lock);
 
 	/* Reclaim guest pages (including page-table pages) */
-	mc = &host_kvm->arch.pkvm.teardown_mc;
 	stage2_mc = &host_kvm->arch.pkvm.stage2_teardown_mc;
 	reclaim_pgtable_pages(hyp_vm, stage2_mc);
 	unpin_host_vcpus(hyp_vm->vcpus, hyp_vm->kvm.created_vcpus);
@@ -1036,7 +989,7 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 			unmap_donated_memory_noclear(addr, PAGE_SIZE);
 		}
 
-		teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
+		hyp_free(hyp_vcpu);
 	}
 
 	hyp_free(hyp_vm);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8a8b5b84825c..1899b05d9fc2 100644
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
2.55.0.rc2.803.g1fd1e6609c-goog

