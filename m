Received: from mta1.migadu.com (out-38.mta1.migadu.com [95.215.58.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECEA3EDAB8
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 13:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974014; cv=none; b=qV3bNgfdKanxxmpSzjet7MLCQV/SZktREZMdT/RDvIlo1FVNLYGnVn6d0MTafXObgl36keyE/x/JQwS3e0KoquSJApk/ysBjwBYfmmDasSzLd9KMpOIFQpjmgHTHo446di4U8YGyMJwy8pF/nxRPktpy+StIKLnLzkTA7BZYwuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974014; c=relaxed/simple;
	bh=oIqhYYCQ42thzV4no1HyBU1GFI5X3kNrT8tmjn8e7Es=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hGqsXKxGN7pBLHcpTj00o1XNXC762x/OZOPzALm6alC02bbUFov1ZMp8jXRTpbo7Ejn78L8RiD6ntuEv606YXA8p+unZwkDPmpvxMWqpzDp4sWbZRrZC9RPVULiDqZrsaJ6gnf9mZ9nTu6NaRaAErV3tNIfhjJmC1tRYYt2UXgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iU5j1rJ9; arc=none smtp.client-ip=95.215.58.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iU5j1rJ9"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=oIqhYYCQ42thzV4no1HyBU1GFI5X3kNrT8tmjn8e7Es=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786974010; v=1; x=1787578810;
 b=iU5j1rJ9/pp5FG9j9YTbP/A3XcltElZC6mmRsbyD1KZss3kVhsfwHKagnhKGKwEqOWi12Q55
 +zyTah0gZf0bGiMLu2b9mwuJZPj2RXxV/YRTWYguTV+YgCMKGo772+ko5F5Yetf1rvWONHCC8XJ
 x/4o/r411E/DQXnE5O5Ol+Y0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f45.google.com (209.85.167.45)
	by smtp.migadu.com with ESMTPS id c3e34dac1045d302;
	Mon, 17 Aug 2026 13:40:06 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so18663e87.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 06:40:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RodTesIc1wapuEMfok3k9ldm455WOw95aNm8rETo1ll3MXhbYz+Ce4cHbXmKM2vvo5gq2HwZ44=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzfhbr5O4EdXnPIDBcc2l38n/zxnXuiPTqlP29RUYVM3xwX82Rd
	l1i9qrrYstAmc5HSmSIEXtEsAQ9XtVargPastSZIEuZ+PIlYUlh9hjAhWTzP5/Ys3dFP0dKHV18
	i179FYimvK8mZrgY67m2mu7odTcy4xx5AoUNMaCGP
X-Received: by 2002:a05:6512:3d8c:b0:5aa:79d6:b559 with SMTP id
 2adb3069b0e04-5b4707819c5mr10435e87.0.1786974004934; Mon, 17 Aug 2026
 06:40:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com> <20260731143541.956291-15-vdonnefort@google.com>
In-Reply-To: <20260731143541.956291-15-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 17 Aug 2026 14:39:28 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwf+nh2ogqe2iV8PrtZtSXXB58GHuj8YywSkkV6H8mBYQ@mail.gmail.com>
X-Gm-Features: AcwNN1U7UGTnIOj5WRITq592LKY8QcwtciRniCjB9moUCxtIEA3KXLFqaUm5XLA
Message-ID: <CA+EHjTwf+nh2ogqe2iV8PrtZtSXXB58GHuj8YywSkkV6H8mBYQ@mail.gmail.com>
Subject: Re: [PATCH v4 14/17] KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 31 Jul 2026 at 15:36, 'Vincent Donnefort' via kernel-team
<kernel-team@android.com> wrote:
>
> Transition the allocation of the hypervisor vCPU state structure
> (pkvm_hyp_vcpu) from the host to the hypervisor using the new pKVM heap
> allocator (hyp_alloc()).
>
> Previously, the host was responsible for calculating the size of,
> allocating, and donating memory for pkvm_hyp_vcpu during VM creation.
> With the heap allocator in place, the hypervisor now allocates this
> structure dynamically at EL2.
>
> Use the pkvm_call_hyp_req() wrapper in the host to invoke
> __pkvm_create_hyp_vcpu, which automatically handles any top-up requests
> if the hypervisor runs out of heap memory during allocation.
>
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad


>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index caea8e9986d1..95e05cee0f3a 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -268,7 +268,6 @@ typedef u16 pkvm_handle_t;
>
>  struct kvm_protected_vm {
>         pkvm_handle_t handle;
> -       struct kvm_hyp_memcache teardown_mc;
>         struct kvm_hyp_memcache stage2_teardown_mc;
>         bool is_protected;
>         bool is_created;
> diff --git a/arch/arm64/kvm/hyp/hyp-constants.c b/arch/arm64/kvm/hyp/hyp-constants.c
> index 501ab35a3840..b2caae21f271 100644
> --- a/arch/arm64/kvm/hyp/hyp-constants.c
> +++ b/arch/arm64/kvm/hyp/hyp-constants.c
> @@ -7,6 +7,5 @@
>  int main(void)
>  {
>         DEFINE(STRUCT_HYP_PAGE_SIZE,    sizeof(struct hyp_page));
> -       DEFINE(PKVM_HYP_VCPU_SIZE,      sizeof(struct pkvm_hyp_vcpu));
>         return 0;
>  }
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> index 8e930c8729af..cfb6e409bf49 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -83,8 +83,7 @@ void pkvm_hyp_vm_table_init(void *tbl);
>  int __pkvm_reserve_vm(void);
>  void __pkvm_unreserve_vm(pkvm_handle_t handle);
>  int __pkvm_init_vm(struct kvm *host_kvm, void *pgd);
> -int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
> -                    unsigned long vcpu_hva);
> +int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu);
>
>  int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn);
>  int __pkvm_start_teardown_vm(pkvm_handle_t handle);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index c1aa6d773c26..9bab1e802281 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -610,10 +610,9 @@ static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
>         DECLARE_REG(struct kvm_vcpu *, host_vcpu, host_ctxt, 2);
> -       DECLARE_REG(unsigned long, vcpu_hva, host_ctxt, 3);
>
>         host_vcpu = kern_hyp_va(host_vcpu);
> -       cpu_reg(host_ctxt, 1) = __pkvm_init_vcpu(handle, host_vcpu, vcpu_hva);
> +       errno_to_smccc(__pkvm_init_vcpu(handle, host_vcpu), host_ctxt);
>  }
>
>  static void handle___pkvm_vcpu_in_poison_fault(struct kvm_cpu_context *host_ctxt)
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 09f609db8556..fffd2f4bc071 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -645,30 +645,6 @@ static size_t pkvm_get_hyp_vm_size(unsigned int nr_vcpus)
>                 size_mul(sizeof(struct pkvm_hyp_vcpu *), nr_vcpus));
>  }
>
> -static void *map_donated_memory_noclear(unsigned long host_va, size_t size)
> -{
> -       void *va = (void *)kern_hyp_va(host_va);
> -
> -       if (!PAGE_ALIGNED(va))
> -               return NULL;
> -
> -       if (__pkvm_host_donate_hyp(hyp_virt_to_pfn(va),
> -                                  PAGE_ALIGN(size) >> PAGE_SHIFT))
> -               return NULL;
> -
> -       return va;
> -}
> -
> -static void *map_donated_memory(unsigned long host_va, size_t size)
> -{
> -       void *va = map_donated_memory_noclear(host_va, size);
> -
> -       if (va)
> -               memset(va, 0, size);
> -
> -       return va;
> -}
> -
>  static void __unmap_donated_memory(void *va, size_t size)
>  {
>         kvm_flush_dcache_to_poc(va, size);
> @@ -896,16 +872,15 @@ static int register_hyp_vcpu(struct pkvm_hyp_vm *hyp_vm,
>         return 0;
>  }
>
> -int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
> -                    unsigned long vcpu_hva)
> +int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu)
>  {
>         struct pkvm_hyp_vcpu *hyp_vcpu;
>         struct pkvm_hyp_vm *hyp_vm;
>         int ret;
>
> -       hyp_vcpu = map_donated_memory(vcpu_hva, sizeof(*hyp_vcpu));
> +       hyp_vcpu = hyp_alloc(sizeof(*hyp_vcpu));
>         if (!hyp_vcpu)
> -               return -ENOMEM;
> +               return hyp_alloc_errno();
>
>         hyp_spin_lock(&vm_table_lock);
>
> @@ -926,24 +901,12 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
>         }
>  unlock:
>         hyp_spin_unlock(&vm_table_lock);
> -
>         if (ret)
> -               unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
> +               hyp_free(hyp_vcpu);
> +
>         return ret;
>  }
>
> -static void
> -teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr, size_t size)
> -{
> -       size = PAGE_ALIGN(size);
> -       memset(addr, 0, size);
> -
> -       for (void *start = addr; start < addr + size; start += PAGE_SIZE)
> -               push_hyp_memcache(mc, start, hyp_virt_to_phys);
> -
> -       unmap_donated_memory_noclear(addr, size);
> -}
> -
>  int __pkvm_reclaim_dying_guest_page(pkvm_handle_t handle, u64 gfn)
>  {
>         struct pkvm_hyp_vm *hyp_vm = get_pkvm_hyp_vm(handle);
> @@ -993,7 +956,7 @@ int __pkvm_start_teardown_vm(pkvm_handle_t handle)
>
>  int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
>  {
> -       struct kvm_hyp_memcache *mc, *stage2_mc;
> +       struct kvm_hyp_memcache *stage2_mc;
>         struct pkvm_hyp_vm *hyp_vm;
>         struct kvm *host_kvm;
>         unsigned int idx;
> @@ -1014,7 +977,6 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
>         hyp_spin_unlock(&vm_table_lock);
>
>         /* Reclaim guest pages (including page-table pages) */
> -       mc = &host_kvm->arch.pkvm.teardown_mc;
>         stage2_mc = &host_kvm->arch.pkvm.stage2_teardown_mc;
>         reclaim_pgtable_pages(hyp_vm, stage2_mc);
>         unpin_host_vcpus(hyp_vm->vcpus, hyp_vm->kvm.created_vcpus);
> @@ -1036,7 +998,7 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
>                         unmap_donated_memory_noclear(addr, PAGE_SIZE);
>                 }
>
> -               teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
> +               hyp_free(hyp_vcpu);
>         }
>
>         hyp_free(hyp_vm);
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index a9b85ad37787..3b29b3f43ffa 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -153,28 +153,19 @@ static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
>
>         kvm->arch.pkvm.handle = 0;
>         kvm->arch.pkvm.is_created = false;
> -       free_hyp_memcache(&kvm->arch.pkvm.teardown_mc);
>         free_hyp_memcache(&kvm->arch.pkvm.stage2_teardown_mc);
>  }
>
>  static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
>  {
> -       size_t hyp_vcpu_sz = PAGE_ALIGN(PKVM_HYP_VCPU_SIZE);
>         pkvm_handle_t handle = vcpu->kvm->arch.pkvm.handle;
> -       void *hyp_vcpu;
>         int ret;
>
>         init_hyp_stage2_memcache(&vcpu->arch.pkvm_memcache);
>
> -       hyp_vcpu = alloc_pages_exact(hyp_vcpu_sz, GFP_KERNEL_ACCOUNT);
> -       if (!hyp_vcpu)
> -               return -ENOMEM;
> -
> -       ret = kvm_call_hyp_nvhe(__pkvm_init_vcpu, handle, vcpu, hyp_vcpu);
> +       ret = pkvm_call_hyp_req(__pkvm_init_vcpu, handle, vcpu);
>         if (!ret)
>                 vcpu_set_flag(vcpu, VCPU_PKVM_FINALIZED);
> -       else
> -               free_pages_exact(hyp_vcpu, hyp_vcpu_sz);
>
>         return ret;
>  }
> --
> 2.55.0.508.g3f0d502094-goog
>
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
