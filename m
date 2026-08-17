Received: from mta1.migadu.com (out-26.mta1.migadu.com [95.215.58.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E993EDAB8
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 13:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973977; cv=none; b=ZW7agyk4vC3FwexTTkjA1n5+4/WdryyQKcb/o6RBbiakk8D0kLsWr4+e7NBqvDZnlaKEQmGOcrTfse0k7A7ZMr5SaVGyozaXO1IQmrsVf+dPrQYmk6kpPFWHKgtCUtxVSFFU7yghZBIDE7chNbNKmcxVZVOCoqIv5q2d3g1Uz4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973977; c=relaxed/simple;
	bh=KcVp/1fJnqJBuaB0ZDe7+Nc6xjwsaG94W8vZoTy51xg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hKrZ/b23IfBSggAVtO6VBBNaPa/w0JXWvan9BA6VtuQknlc0avdEXJsWlbADfdNBfRbgCmD4f8/CcG1cv0R9pOnNRo3Ihl1E5uXuB7CNCoCokvzvIheBN83dBZmRrusAgpbQJgG7vnr271tvIzuLnm++DY4yT++hF66yyUrtBBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v1la8P3F; arc=none smtp.client-ip=95.215.58.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v1la8P3F"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=KcVp/1fJnqJBuaB0ZDe7+Nc6xjwsaG94W8vZoTy51xg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786973973; v=1; x=1787578773;
 b=v1la8P3FLnvAV5d5lr2At8GmCcjf+N7pM4DMSFRqlZhyrCYpFspRsE1F6lL4fjjGRYu5inrs
 p+IaLi9jhJ6T9s9DLwxw++s8yTVUZUAjcj+MdOoZBKZahjJQXGKnTy5QBcpdO4zy4fxUkYeiMHZ
 89Clw01Mv9/FQbHE2WfWQYO8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: from mail-lf1-f52.google.com (209.85.167.52)
	by smtp.migadu.com with ESMTPS id 8c71b45fe9de89e5;
	Mon, 17 Aug 2026 13:39:33 +0000
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b2a8173142so2479e87.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 06:39:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpKCSp0yWhjad95hDq32cBnIBZGWoh+zpJr2emzf02KCxHgiEA2Eh/tV62DjWCV7C9e9DoCMBo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0O6wu9qYm2rT7oxv3UESwCefWJsGqOIZT2+KUD2CAsud3zPBx
	OJll3dQqB04egUl2BAmAzyuPdqQKhFZBts1mio8ZdVnuWMvXXs10G9E6d7b+2WiK++fW2WgfVoE
	mew1yW3RRFOsfPojXt6Ok7nQwXjavyKLMk0vtiFMa
X-Received: by 2002:a05:6512:3b8b:b0:5b1:ca0b:25d2 with SMTP id
 2adb3069b0e04-5b4707f7928mr7180e87.4.1786973968367; Mon, 17 Aug 2026 06:39:28
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260731143541.956291-1-vdonnefort@google.com> <20260731143541.956291-14-vdonnefort@google.com>
In-Reply-To: <20260731143541.956291-14-vdonnefort@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 17 Aug 2026 14:38:51 +0100
X-Gmail-Original-Message-ID: <CA+EHjTzutNyarb02Hf89i_hy7AvHJax7ntPP4Vutvv+55-DEYA@mail.gmail.com>
X-Gm-Features: AcwNN1XK3sFQsVm12Mp4_homFe-Y3YvqYEb_xPrUoMLUgRmukyJty_u1Q8KT9xM
Message-ID: <CA+EHjTzutNyarb02Hf89i_hy7AvHJax7ntPP4Vutvv+55-DEYA@mail.gmail.com>
Subject: Re: [PATCH v4 13/17] KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 31 Jul 2026 at 15:36, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> Transition the allocation of the hypervisor VM state structure
> (pkvm_hyp_vm) from the host to the hypervisor using
> the new pKVM heap allocator (hyp_alloc()).
>
> Previously, the host was responsible for calculating the size of,
> allocating, and donating memory for pkvm_hyp_vm during VM creation. With
> the heap allocator in place, the hypervisor now allocates this structure
> dynamically at EL2.
>
> Use the pkvm_call_hyp_req() wrapper in the host to invoke
> __pkvm_init_vm, which automatically handles any top-up requests if the
> hypervisor runs out of heap memory during allocation.
>
> Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>

Cheers,
/fuad
>
> diff --git a/arch/arm64/kvm/hyp/hyp-constants.c b/arch/arm64/kvm/hyp/hyp-constants.c
> index b257a3b4bfc5..501ab35a3840 100644
> --- a/arch/arm64/kvm/hyp/hyp-constants.c
> +++ b/arch/arm64/kvm/hyp/hyp-constants.c
> @@ -7,7 +7,6 @@
>  int main(void)
>  {
>         DEFINE(STRUCT_HYP_PAGE_SIZE,    sizeof(struct hyp_page));
> -       DEFINE(PKVM_HYP_VM_SIZE,        sizeof(struct pkvm_hyp_vm));
>         DEFINE(PKVM_HYP_VCPU_SIZE,      sizeof(struct pkvm_hyp_vcpu));
>         return 0;
>  }
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> index 624367d0ef5b..8e930c8729af 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -82,8 +82,7 @@ void pkvm_hyp_vm_table_init(void *tbl);
>
>  int __pkvm_reserve_vm(void);
>  void __pkvm_unreserve_vm(pkvm_handle_t handle);
> -int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
> -                  unsigned long pgd_hva);
> +int __pkvm_init_vm(struct kvm *host_kvm, void *pgd);
>  int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
>                      unsigned long vcpu_hva);
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index d99c9b1b0c82..c1aa6d773c26 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -575,14 +575,35 @@ static void handle___pkvm_unreserve_vm(struct kvm_cpu_context *host_ctxt)
>         __pkvm_unreserve_vm(handle);
>  }
>
> +static void errno_to_smccc(int ret, struct kvm_cpu_context *host_ctxt)
> +{
> +       struct pkvm_hyp_req req = { .type = PKVM_HYP_NO_REQ };
> +
> +       switch (ret) {
> +       case -ENOMEM: {
> +               u32 nr_pages = hyp_alloc_topup_needed();
> +
> +               if (nr_pages) {
> +                       req.type = PKVM_HYP_REQ_HYP_ALLOC;
> +                       req.mem.nr_pages = nr_pages;
> +               }
> +               break;
> +       }
> +       }
> +
> +       cpu_reg(host_ctxt, 1) = ret;
> +       pkvm_hyp_req_to_smccc(host_ctxt, &req);
> +}
> +
>  static void handle___pkvm_init_vm(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(struct kvm *, host_kvm, host_ctxt, 1);
> -       DECLARE_REG(unsigned long, vm_hva, host_ctxt, 2);
> -       DECLARE_REG(unsigned long, pgd_hva, host_ctxt, 3);
> +       DECLARE_REG(unsigned long, pgd_hva, host_ctxt, 2);
> +       void *pgd;
>
>         host_kvm = kern_hyp_va(host_kvm);
> -       cpu_reg(host_ctxt, 1) = __pkvm_init_vm(host_kvm, vm_hva, pgd_hva);
> +       pgd = (void *)kern_hyp_va(pgd_hva);
> +       errno_to_smccc(__pkvm_init_vm(host_kvm, pgd), host_ctxt);
>  }
>
>  static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 079d6f397893..09f609db8556 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -11,6 +11,7 @@
>
>  #include <asm/kvm_emulate.h>
>
> +#include <nvhe/alloc.h>
>  #include <nvhe/mem_protect.h>
>  #include <nvhe/memory.h>
>  #include <nvhe/pkvm.h>
> @@ -797,24 +798,22 @@ void teardown_selftest_vm(void)
>   * Unmap the donated memory from the host at stage 2.
>   *
>   * host_kvm: A pointer to the host's struct kvm.
> - * vm_hva: The host va of the area being donated for the VM state.
> - *        Must be page aligned.
> - * pgd_hva: The host va of the area being donated for the stage-2 PGD for
> - *         the VM. Must be page aligned. Its size is implied by the VM's
> - *         VTCR.
> + * pgd: The va of the area being donated for the stage-2 PGD for the VM. Must
> + *      be page aligned. Its size is implied by the VM's VTCR.
>   *
>   * Return 0 success, negative error code on failure.
>   */
> -int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
> -                  unsigned long pgd_hva)
> +int __pkvm_init_vm(struct kvm *host_kvm, void *pgd)
>  {
>         struct pkvm_hyp_vm *hyp_vm = NULL;
>         size_t vm_size, pgd_size;
>         unsigned int nr_vcpus;
>         pkvm_handle_t handle;
> -       void *pgd = NULL;
>         int ret;
>
> +       if (!PAGE_ALIGNED(pgd))
> +               return -EINVAL;
> +
>         ret = hyp_pin_shared_mem(host_kvm, host_kvm + 1);
>         if (ret)
>                 return ret;
> @@ -834,15 +833,15 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
>         vm_size = pkvm_get_hyp_vm_size(nr_vcpus);
>         pgd_size = kvm_pgtable_stage2_pgd_size(host_mmu.arch.mmu.vtcr);
>
> -       ret = -ENOMEM;
> +       hyp_vm = hyp_alloc(vm_size);
> +       if (!hyp_vm) {
> +               ret = hyp_alloc_errno();
> +               goto err_unpin_kvm;
> +       }
>
> -       hyp_vm = map_donated_memory(vm_hva, vm_size);
> -       if (!hyp_vm)
> -               goto err_remove_mappings;
> -
> -       pgd = map_donated_memory_noclear(pgd_hva, pgd_size);
> -       if (!pgd)
> -               goto err_remove_mappings;
> +       ret = __pkvm_host_donate_hyp(hyp_virt_to_pfn(pgd), PAGE_ALIGN(pgd_size) >> PAGE_SHIFT);
> +       if (ret)
> +               goto err_free_hyp_vm;
>
>         init_pkvm_hyp_vm(host_kvm, hyp_vm, nr_vcpus, handle);
>
> @@ -860,8 +859,9 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
>  err_destroy_stage2:
>         kvm_guest_destroy_stage2(hyp_vm);
>  err_remove_mappings:
> -       unmap_donated_memory(hyp_vm, vm_size);
>         unmap_donated_memory(pgd, pgd_size);
> +err_free_hyp_vm:
> +       hyp_free(hyp_vm);
>  err_unpin_kvm:
>         hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
>         return ret;
> @@ -997,7 +997,6 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
>         struct pkvm_hyp_vm *hyp_vm;
>         struct kvm *host_kvm;
>         unsigned int idx;
> -       size_t vm_size;
>         int err;
>
>         hyp_spin_lock(&vm_table_lock);
> @@ -1040,8 +1039,7 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
>                 teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
>         }
>
> -       vm_size = pkvm_get_hyp_vm_size(hyp_vm->kvm.created_vcpus);
> -       teardown_donated_memory(mc, hyp_vm, vm_size);
> +       hyp_free(hyp_vm);
>         hyp_unpin_shared_mem(host_kvm, host_kvm + 1);
>         return 0;
>
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index bfbb1266491d..a9b85ad37787 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -191,8 +191,8 @@ static int __pkvm_create_hyp_vcpu(struct kvm_vcpu *vcpu)
>   */
>  static int __pkvm_create_hyp_vm(struct kvm *kvm)
>  {
> -       size_t pgd_sz, hyp_vm_sz;
> -       void *pgd, *hyp_vm;
> +       size_t pgd_sz;
> +       void *pgd;
>         int ret;
>
>         if (kvm->created_vcpus < 1)
> @@ -209,28 +209,15 @@ static int __pkvm_create_hyp_vm(struct kvm *kvm)
>         if (!pgd)
>                 return -ENOMEM;
>
> -       /* Allocate memory to donate to hyp for vm and vcpu pointers. */
> -       hyp_vm_sz = PAGE_ALIGN(size_add(PKVM_HYP_VM_SIZE,
> -                                       size_mul(sizeof(void *),
> -                                                kvm->created_vcpus)));
> -       hyp_vm = alloc_pages_exact(hyp_vm_sz, GFP_KERNEL_ACCOUNT);
> -       if (!hyp_vm) {
> -               ret = -ENOMEM;
> -               goto free_pgd;
> -       }
> -
> -       /* Donate the VM memory to hyp and let hyp initialize it. */
> -       ret = kvm_call_hyp_nvhe(__pkvm_init_vm, kvm, hyp_vm, pgd);
> +       ret = pkvm_call_hyp_req(__pkvm_init_vm, kvm, pgd);
>         if (ret)
> -               goto free_vm;
> +               goto free_pgd;
>
>         kvm->arch.pkvm.is_created = true;
>         init_hyp_stage2_memcache(&kvm->arch.pkvm.stage2_teardown_mc);
>         kvm_account_pgtable_pages(pgd, pgd_sz / PAGE_SIZE);
>
>         return 0;
> -free_vm:
> -       free_pages_exact(hyp_vm, hyp_vm_sz);
>  free_pgd:
>         free_pages_exact(pgd, pgd_sz);
>         return ret;
> --
> 2.55.0.508.g3f0d502094-goog
>
