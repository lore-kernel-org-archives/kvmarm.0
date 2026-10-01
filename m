Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CB05208CD
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 14:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790864967; cv=none; b=UCb+F3bY+TE/FXnhrMp+iuRNA/MlZV0U/Fm6BHQkupVQvrTZA51dviPqw+WSF83KGojJfpkIbmmOZeIF+7+B50gkSqkbslaqrDJfGo9XEmbr875fGkDTRNUWYwIJ/em/FQhUo7iMFZb+O8C3i/pbDiGElEQz68DzQ5+JFB8FG14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790864967; c=relaxed/simple;
	bh=3KvHY+caGljUR3djZRkzGuNT0yRoB6Z4+OgPOQL16aM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z6vtteXq8w7AO4pt68FlO+123auvxhAyH/GPD6pTtBg9Y/Ao+faCl5L9ltixq1l3iUHONgx6SHelo/Nq98KJe+Zcj5n7Ibih87sk/sKWfZan3fWTd1417ofOgtlDF+ordW6C5eZIWzLIpy2UxBgFEw5/wHcHBg0+FpR/UvNmXM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wZJAuVCv; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wZJAuVCv"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a01b112fa2so19137345e9.1
        for <kvmarm@lists.linux.dev>; Thu, 01 Oct 2026 07:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790864955; x=1791469755; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IgB8IIPXmAJrVZAPAshZMvG1RwUCRUSQ4TIIxFuHVGE=;
        b=wZJAuVCvtPB19HZ/AAj9WR0wqTaKvi1aXpzRgBCWYfrF2DWe5QpePozqMzDGbG3fYD
         eoIyNsCPDBAAVx3yXC5xlNCsYXz4RE1G/7es2yy+1m1FfWnj+qhyXmdhRMaKNyPagOCH
         UsG3g6gv53MzToMEj1UDCtA93SH5XvI22f6Cbj0u4iGXqt936vwPOaSJVclzCJQWpeWJ
         qKq8Nz5ynC1wpiLrPZxLbmyYJvZNLyhYDN0eA36EVBaOqBOwdUWZbjFghTCoQecuEoB1
         TrWVEbiBPcDwq47x+HBKC1km9ayu4vzoiZC4uEEXjt+SSg5Qvhc8xi+6vXpv1DGj+u4R
         2/QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790864955; x=1791469755;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IgB8IIPXmAJrVZAPAshZMvG1RwUCRUSQ4TIIxFuHVGE=;
        b=twHgoT2FzFtsorLyjSZfo53hNZtvRzRdfv8DLT13DV6ztWWuRoY8/XxzFKAMTFDq93
         w2Wto2KmdEFBF//JQm+3Wzf4ZdC5GVZTSbhl4WgA2qBV4a5LEEm5iaZL0zJfEk0uzplJ
         8/YphqfPwQ4wGGQ2yGt7RnhtW9sbK7g0ukNGzCplRd+FfM4VV1wMYxF5S+E1cEvKvUxf
         21syIcFFkbeI73vuYl9UlZadfJx/3OYybvoYTTaLxKSzik+ewsAUUK6JeMNpTWtBol4R
         LGRkTG6bqrkF4w8/VUagxMboX7ZnmmkOc91S/xVLvoOhXcu4ILdbWxSdXj7Ki39gCYEQ
         +XDQ==
X-Forwarded-Encrypted: i=1; AKwUvBxTjl11yFhPARraJrg+N3yBoKHjKTHTaX6tRR6zXvAenOtn2sK1kfbvun1+A04i2RxtHmfgXeU=@lists.linux.dev
X-Gm-Message-State: AFuF++lAFHxBQsXbQwWHTN9IccOyP19CeQHopOr8f/692A0oVM5XXTPt
	KSPns8KHXATOXNRksyAphH+jlUhUE7eQXrkbEjaS4ymMLDZANBYHtVbGrSPRGj35BgDeBUHPF6k
	SltEman0TT7C4ylesQmuHpA==
X-Received: from wmdv11.prod.google.com ([2002:a05:600c:12cb:b0:4a0:2a5:ce1a])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c16f:b0:49f:c1a1:5222 with SMTP id 5b1f17b1804b1-4a0257b13c2mr15444775e9.33.1790864954623;
 Thu, 01 Oct 2026 07:29:14 -0700 (PDT)
Date: Thu,  1 Oct 2026 15:28:45 +0100
In-Reply-To: <20261001142849.3367614-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261001142849.3367614-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001142849.3367614-15-vdonnefort@google.com>
Subject: [PATCH v6 14/18] KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Transition the allocation of the hypervisor vCPU state structure
(pkvm_hyp_vcpu) from the host to the hypervisor using the new pKVM heap
allocator (hyp_alloc()).

Previously, the host was responsible for calculating the size of,
allocating, and donating memory for pkvm_hyp_vcpu during vCPU creation.
With the heap allocator in place, the hypervisor now allocates this
structure dynamically at EL2.

Use the pkvm_call_hyp_req() wrapper in the host to invoke
__pkvm_create_hyp_vcpu, which automatically handles any top-up requests
if the hypervisor runs out of heap memory during allocation.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_hcall.h     |  3 +-
 arch/arm64/include/asm/kvm_host.h      |  1 -
 arch/arm64/kvm/hyp/hyp-constants.c     |  1 -
 arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  3 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c     |  5 ++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c         | 38 +++++---------------------
 arch/arm64/kvm/pkvm.c                  | 11 +-------
 7 files changed, 12 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hcall.h b/arch/arm64/include/asm/kvm_hcall.h
index c98243e79e31..7dd176b4bea4 100644
--- a/arch/arm64/include/asm/kvm_hcall.h
+++ b/arch/arm64/include/asm/kvm_hcall.h
@@ -232,8 +232,7 @@ DECLARE_KVM_HOST_HCALL(void, __pkvm_unreserve_vm,
 DECLARE_KVM_HOST_HCALL(int, __pkvm_init_vm,
 	struct kvm __kern *, host_kvm, void __kern *, pgd_hva)
 DECLARE_KVM_HOST_HCALL(int, __pkvm_init_vcpu,
-	pkvm_handle_t, handle, struct kvm_vcpu __kern *, host_vcpu,
-	void __kern *, vcpu_hva)
+	pkvm_handle_t, handle, struct kvm_vcpu __kern *, host_vcpu)
 DECLARE_KVM_HOST_HCALL0(int, __pkvm_vcpu_in_poison_fault)
 DECLARE_KVM_HOST_HCALL(int, __pkvm_force_reclaim_guest_page,
 	phys_addr_t, phys)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 64cd6233b439..3cca9f3b2eeb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -267,7 +267,6 @@ struct kvm_smccc_features {
 
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
index c5fd7315c0e3..866961c3bacb 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
@@ -84,8 +84,7 @@ void pkvm_hyp_vm_table_init(void *tbl);
 int __pkvm_reserve_vm(void);
 void __pkvm_unreserve_vm(pkvm_handle_t handle);
 int __pkvm_init_vm(struct kvm *host_kvm, void __kern *pgd_hva);
-int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
-		     void __kern *vcpu_hva);
+int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu);
 
 int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn);
 int __pkvm_start_teardown_vm(pkvm_handle_t handle);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 7eecac7c7fbe..281d1359606a 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -789,10 +789,9 @@ DEFINE_KVM_HOST_HCALL(int, __pkvm_init_vm,
 }
 
 DEFINE_KVM_HOST_HCALL(int, __pkvm_init_vcpu,
-	pkvm_handle_t, handle, struct kvm_vcpu __kern *, host_vcpu,
-	void __kern *, vcpu_hva)
+	pkvm_handle_t, handle, struct kvm_vcpu __kern *, host_vcpu)
 {
-	return __pkvm_init_vcpu(handle, kern_hyp_va_host(host_vcpu), vcpu_hva);
+	return errno_to_smccc(__pkvm_init_vcpu(handle, kern_hyp_va_host(host_vcpu)));
 }
 
 DEFINE_KVM_HOST_HCALL0(int, __pkvm_vcpu_in_poison_fault)
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index c29a25cae8e8..5031ef9e6fe9 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -672,16 +672,6 @@ static void *map_donated_memory_noclear(void __kern *host_va, size_t size)
 	return va;
 }
 
-static void *map_donated_memory(void __kern *host_va, size_t size)
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
@@ -910,16 +900,15 @@ static int register_hyp_vcpu(struct pkvm_hyp_vm *hyp_vm,
 	return 0;
 }
 
-int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
-		     void __kern *vcpu_hva)
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
 
@@ -940,24 +929,12 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
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
@@ -1007,7 +984,7 @@ int __pkvm_start_teardown_vm(pkvm_handle_t handle)
 
 int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 {
-	struct kvm_hyp_memcache *mc, *stage2_mc;
+	struct kvm_hyp_memcache *stage2_mc;
 	struct pkvm_hyp_vm *hyp_vm;
 	struct kvm *host_kvm;
 	unsigned int idx;
@@ -1028,7 +1005,6 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 	hyp_spin_unlock(&vm_table_lock);
 
 	/* Reclaim guest pages (including page-table pages) */
-	mc = &host_kvm->arch.pkvm.teardown_mc;
 	stage2_mc = &host_kvm->arch.pkvm.stage2_teardown_mc;
 	reclaim_pgtable_pages(hyp_vm, stage2_mc);
 	unpin_host_vcpus(hyp_vm->vcpus, hyp_vm->kvm.created_vcpus);
@@ -1050,7 +1026,7 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 			unmap_donated_memory_noclear(addr, PAGE_SIZE);
 		}
 
-		teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
+		hyp_free(hyp_vcpu);
 	}
 
 	hyp_free(hyp_vm);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 8505965dbfb2..36e677e51f7d 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -174,28 +174,19 @@ static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
 
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
2.56.0.rc1.315.gc6ed9934b7-goog

