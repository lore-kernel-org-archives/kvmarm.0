Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45C1380FD7
	for <kvmarm@lists.linux.dev>; Tue,  1 Sep 2026 08:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788250208; cv=none; b=WJK2cTfIMCBZuEEgEwGrDztydX3KtF6CPtZMgsmHs9wL24EE2SUwFUinGCwrcwNxInho5FLw1JlK+ER7KKvuCxdktJE0l+6Vda1W7/QQDqop8eY+5Pdnr3BkGfHVV2Bb0lNZj9FddmRjcG39Yb+QLsrdJhB7gqtQnwb4kM54WN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788250208; c=relaxed/simple;
	bh=cvohk036/odPe7edaENSdlBgQP75rS1X64gv2X/3OWA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qyM7WrRpqAKvHOXlvr3RaI5RVtTWIsNbceZ5LgBRhGW42EbngBxU+d+fpAc3D8hyyz0sC2Km3pCjLusetrNunIFtvrjaCwu8cYNEWy9+F4x4hkYXggMhwYTncyNpzJhXInsBekfUgDge6nXGcRkAtWQftd3wWed1nc7NmDzfSdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jsONPBDw; arc=none smtp.client-ip=209.85.208.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jsONPBDw"
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6a5f96426b9so4938365a12.1
        for <kvmarm@lists.linux.dev>; Tue, 01 Sep 2026 01:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788250205; x=1788855005; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bjcSVwbVLsAT4JeBPjMW/8NzKi2n/DkRjc8BGUj88V4=;
        b=jsONPBDw/t+kvIs55rjOlBe28q34Pg5oT/X1EpvL3hOlotpAoSY5zfvO2an3wwihX0
         gLTONTsHRlSueR9xgukzvfElopWhTMzQJBLUhKX27D1AAY1MN4tqcy6i98Ou//i3Kr2t
         OlcJ5DYmjQb9VNHRVOSQc5xNjdUxM1fvYr5+CvLXL8E0BckMes7hP0jC5Tg0TnKyv8xR
         63YNxcC5MHod9to66iDU/TYtTjqvyKvtY5PiP1KwwDnQ8MVBiZGeVu3E9Trpzvi3GKwR
         kFXfR88m64us5/rzRApSHnvt2c36cH8+zGi/06Xp6gwMcY4CyHLFydojrh4+6kapP+3H
         nW4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250205; x=1788855005;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bjcSVwbVLsAT4JeBPjMW/8NzKi2n/DkRjc8BGUj88V4=;
        b=YyF5fbWvQ8n/lwIIgsiUlT4/v67YwSCLCyyrybLH62elKSc/XwVTXrRnRttyOVYiPg
         9W8AEXZBQay2u7P2OKDnw0oUpA8TtTzQq6bOuTJgZusX7oxWhqW8JW0QkUP1gWyAckd1
         H0G4y+TaOPcwDJzGfatixcfC8N/cvuNH7VYtJnGWI/ngTHPlHxzrVzIQsk7jDlI8O0Wf
         17R1zw1xce5E6Zut3icTW918dzNpwrdNdkEaVBxorlhH/LfUPdnp1Yc1riemHaYhV1qp
         G9v1aOspM8h599E+anWYtgo1Fh7P+33kg1YQqEg8eQ6AN+Xz+Bi/RbgH7imQM+PSbcP9
         Zi8w==
X-Forwarded-Encrypted: i=1; AKwUvBwNWXofEJi99csF68KKrNj+2GR0PW6FOVgbR9AIIrib5VXDanA1eSdjKwMcS3VbHPfSbDC6PlA=@lists.linux.dev
X-Gm-Message-State: AFuF++lCKcJN2yAMnzar7wVlJUxAMIzjkZ8w/oT2ZPKomC65K1IWYvtf
	J/5JjKKFrG/oJBS4+KOSAXJxuTXFdlW7IcVLdXEQT7W5pnxUC31YKAhenDvsBZ9RL1gcpoXrBD/
	14D5dqgFXTzlpWIOU8nP2uA==
X-Received: from edaa16.prod.google.com ([2002:a05:6402:24d0:b0:6a1:2464:d8d1])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3223:b0:6a6:584:d9e7 with SMTP id 4fb4d7f45d1cf-6a60d3bc75fmr20508329a12.15.1788250204777;
 Tue, 01 Sep 2026 01:10:04 -0700 (PDT)
Date: Tue,  1 Sep 2026 09:09:37 +0100
In-Reply-To: <20260901080941.997769-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260901080941.997769-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260901080941.997769-15-vdonnefort@google.com>
Subject: [PATCH v5 14/18] KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator
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
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3ab41330c94f..fe5364b507f9 100644
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
index c9960ac1a803..bc54f477c147 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -804,10 +804,9 @@ static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
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
index cabcfb59a89d..ee2060aa1131 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -658,30 +658,6 @@ static size_t pkvm_get_hyp_vm_size(unsigned int nr_vcpus)
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
@@ -909,16 +885,15 @@ static int register_hyp_vcpu(struct pkvm_hyp_vm *hyp_vm,
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
 
@@ -939,24 +914,12 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
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
@@ -1006,7 +969,7 @@ int __pkvm_start_teardown_vm(pkvm_handle_t handle)
 
 int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 {
-	struct kvm_hyp_memcache *mc, *stage2_mc;
+	struct kvm_hyp_memcache *stage2_mc;
 	struct pkvm_hyp_vm *hyp_vm;
 	struct kvm *host_kvm;
 	unsigned int idx;
@@ -1027,7 +990,6 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
 	hyp_spin_unlock(&vm_table_lock);
 
 	/* Reclaim guest pages (including page-table pages) */
-	mc = &host_kvm->arch.pkvm.teardown_mc;
 	stage2_mc = &host_kvm->arch.pkvm.stage2_teardown_mc;
 	reclaim_pgtable_pages(hyp_vm, stage2_mc);
 	unpin_host_vcpus(hyp_vm->vcpus, hyp_vm->kvm.created_vcpus);
@@ -1049,7 +1011,7 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
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
2.55.0.897.gb25b4bd76c-goog

