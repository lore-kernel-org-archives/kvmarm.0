Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6325199FAB
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 08:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734425527; cv=none; b=nZeUhkrHBypd3YMlA6HHiqPv5WsckfXyD4F4+B8PYTyG59KIFv387wKS2St6PTDUoZIhKymLBI5TLgz/Or7kw63lX7taxp32RnWyYQ2wa/bL6njdcpXjAunyba2vXMPRFLjDmZ4FhJh3dyTYM9KGxJKmNEqBCUJASRGVhfJnFGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734425527; c=relaxed/simple;
	bh=8W0AOFA3uX4AnxAjH+vtoBESwUXW8Fvc30u6Fti0J5c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tQfQO3Sx3930jxR/Q3TtQZZ2siWhu7J8wTeOIvxsZV1N93Pd7BVRvKtnWZWxrDMKJwTAXJPKOHdpe2EraHpBqUUPDB0pLzgfxbk4Mh+KsGvrrlzokwrq96u4kbGbPPWX6NhtmZ70dapyKDdc+RPcOLYP7w/epFIwJCrxQ1RiYEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NDPuXydV; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NDPuXydV"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43622893c3cso26995e9.1
        for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 00:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734425524; x=1735030324; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8VfnCtkNw4jCGOBfbSUZBMbz7UB1Wp2d0C172FE8Ags=;
        b=NDPuXydVSZdFFbC9xg9F+WaHmGUTM41uU7wkbFdgPl/H0LM/BVlQTlIa0wfZWLfkGw
         EcQ9kBzC1mTSJbZs5orMxUUuuQ3w2wqnUlf06leEHJedz9ESSfBif3IfO5OsPNG2Em77
         bpKYBwgoqk+vqCtquZa7/3L1Vhf9K90g7uDFgT2W3G7O5WjGCIIHvJ2kpil6GSS8NlWt
         Dd5t/X8LIKDB3vH8ghNql1ypMhGUzTPFnDLLuPz15oQEki3sx1HXbkGm5eUhTmKrLVH9
         Fug8Qbab+VsMs6iEdvLFUL/Z2Xs/nq6cYpwUVk6ENHJMwuVUVq90xwjQ71aeUsJuvRXN
         m3CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734425524; x=1735030324;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8VfnCtkNw4jCGOBfbSUZBMbz7UB1Wp2d0C172FE8Ags=;
        b=sAKEDXYbjVXECo2UWronHjzK4gKnVjTAOJrgNj2vzPp/mJBAsvXOaCiqfjZrARhWK8
         ioxA9OySLdvzRgMSrGgNIHy35qKFNK09mNToq++dGKG0ROYOACqjX5DmqbIH+wIyZYyd
         G8z17MvBFaHXS0bVUmSnfdksuwR1LEOFpdyjQRqslrbFlrs6esNU1zeDqlxiU/WR5UWU
         DHhpW11euibxidRzhPAf19cnT7wxKNeM7wBF0vfJ/vwxkt94sFmZQzLiEf+kRsugOXCu
         p/+onQD87btf7L5yYtOs+lE9izFxpcjU4o9ga592tGxIZCukXIGFk6P2rpMeyC4Sdjhu
         31cw==
X-Forwarded-Encrypted: i=1; AJvYcCWFsrR9NHWPCpLlU/H5rux5tWeQMmZkAFvKzjTtsEVtMPNbYcze4GzrDHb693/5EuJqXKb6+4Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBTQ1luQNBjK3INbj9T4jcuf4cQWBnKRHHZEzu4RlT0eL8QoIq
	4mpVruZ51sfBcXN0OdJUTL3vti4lK+Xf8deVQ4FrxQtIcAYPBSS+g5l+rayVNPBpTNNxC9/NjdR
	yMsiS7vO26DzAXNXWP1iRssnwHc8aU6CJuA8L
X-Gm-Gg: ASbGncsMI97tfcwsE3yRaH9kPWypqP6pRZkRf3CecVVuTWc48oG7iE+vOIzs3BCZemd
	T36B3G7ejhrCttbmWjX1/cF9HeOs/6b2HMg7LizJQPb10LIQsp8qqEsDc0JdnjtLaPqg=
X-Google-Smtp-Source: AGHT+IHQxcS2WDDQcqjQEb1uNK3uxjhDayYSkTEA5itU8N7dHvtpoKjI7ssPmQyDY4qKzGBHei1EI2b2iGBr8rLpiT0=
X-Received: by 2002:a05:600c:5741:b0:436:1811:a79c with SMTP id
 5b1f17b1804b1-4364ad4db33mr740075e9.5.1734425523885; Tue, 17 Dec 2024
 00:52:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216175803.2716565-1-qperret@google.com> <20241216175803.2716565-11-qperret@google.com>
In-Reply-To: <20241216175803.2716565-11-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 17 Dec 2024 08:51:27 +0000
Message-ID: <CA+EHjTz6W8YDKmk2Ga84CEYk46fyVXDPizXWbGqqq2Jn8JV0uQ@mail.gmail.com>
Subject: Re: [PATCH v3 10/18] KVM: arm64: Introduce __pkvm_host_share_guest()
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Dec 2024 at 17:58, Quentin Perret <qperret@google.com> wrote:
>
> In preparation for handling guest stage-2 mappings at EL2, introduce a
> new pKVM hypercall allowing to share pages with non-protected guests.
>
> Signed-off-by: Quentin Perret <qperret@google.com>

(Apart from a nit below)

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad


> ---
>  arch/arm64/include/asm/kvm_asm.h              |  1 +
>  arch/arm64/include/asm/kvm_host.h             |  3 +
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
>  arch/arm64/kvm/hyp/include/nvhe/memory.h      |  2 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 34 +++++++++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 72 +++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                |  7 ++
>  7 files changed, 120 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 89c0fac69551..449337f5b2a3 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -65,6 +65,7 @@ enum __kvm_host_smccc_func {
>         /* Hypercalls available after pKVM finalisation */
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
>         __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
>         __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
>         __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e18e9244d17a..1246f1d01dbf 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -771,6 +771,9 @@ struct kvm_vcpu_arch {
>         /* Cache some mmu pages needed inside spinlock regions */
>         struct kvm_mmu_memory_cache mmu_page_cache;
>
> +       /* Pages to top-up the pKVM/EL2 guest pool */
> +       struct kvm_hyp_memcache pkvm_memcache;
> +
>         /* Virtual SError ESR to restore when HCR_EL2.VSE is set */
>         u64 vsesr_el2;
>
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index 25038ac705d8..a7976e50f556 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -39,6 +39,7 @@ int __pkvm_host_donate_hyp(u64 pfn, u64 nr_pages);
>  int __pkvm_hyp_donate_host(u64 pfn, u64 nr_pages);
>  int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
> +int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
>
>  bool addr_is_memory(phys_addr_t phys);
>  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> index 8bd9a539f260..cc431820c6ce 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
> @@ -46,6 +46,8 @@ struct hyp_page {
>
>         /* Host (non-meta) state. Guarded by the host stage-2 lock. */
>         enum pkvm_page_state host_state : 8;
> +
> +       u32 host_share_guest_count;
>  };
>
>  extern u64 __hyp_vmemmap;
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 95d78db315b3..d659462fbf5d 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -211,6 +211,39 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
>         cpu_reg(host_ctxt, 1) =  ret;
>  }
>
> +static int pkvm_refill_memcache(struct pkvm_hyp_vcpu *hyp_vcpu)
> +{
> +       struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> +
> +       return refill_memcache(&hyp_vcpu->vcpu.arch.pkvm_memcache,
> +                              host_vcpu->arch.pkvm_memcache.nr_pages,
> +                              &host_vcpu->arch.pkvm_memcache);
> +}
> +
> +static void handle___pkvm_host_share_guest(struct kvm_cpu_context *host_ctxt)
> +{
> +       DECLARE_REG(u64, pfn, host_ctxt, 1);
> +       DECLARE_REG(u64, gfn, host_ctxt, 2);
> +       DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 3);
> +       struct pkvm_hyp_vcpu *hyp_vcpu;
> +       int ret = -EINVAL;
> +
> +       if (!is_protected_kvm_enabled())
> +               goto out;
> +
> +       hyp_vcpu = pkvm_get_loaded_hyp_vcpu();
> +       if (!hyp_vcpu || pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> +               goto out;
> +
> +       ret = pkvm_refill_memcache(hyp_vcpu);
> +       if (ret)
> +               goto out;
> +
> +       ret = __pkvm_host_share_guest(pfn, gfn, hyp_vcpu, prot);
> +out:
> +       cpu_reg(host_ctxt, 1) =  ret;
> +}
> +
>  static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> @@ -420,6 +453,7 @@ static const hcall_t host_hcall[] = {
>
>         HANDLE_FUNC(__pkvm_host_share_hyp),
>         HANDLE_FUNC(__pkvm_host_unshare_hyp),
> +       HANDLE_FUNC(__pkvm_host_share_guest),
>         HANDLE_FUNC(__kvm_adjust_pc),
>         HANDLE_FUNC(__kvm_vcpu_run),
>         HANDLE_FUNC(__kvm_flush_vm_context),
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index 12bb5445fe47..fb9592e721cf 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -867,6 +867,27 @@ static int hyp_complete_donation(u64 addr,
>         return pkvm_create_mappings_locked(start, end, prot);
>  }
>
> +static enum pkvm_page_state guest_get_page_state(kvm_pte_t pte, u64 addr)
> +{
> +       if (!kvm_pte_valid(pte))
> +               return PKVM_NOPAGE;
> +
> +       return pkvm_getstate(kvm_pgtable_stage2_pte_prot(pte));
> +}
> +
> +static int __guest_check_page_state_range(struct pkvm_hyp_vcpu *vcpu, u64 addr,
> +                                         u64 size, enum pkvm_page_state state)
> +{
> +       struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
> +       struct check_walk_data d = {
> +               .desired        = state,
> +               .get_page_state = guest_get_page_state,
> +       };
> +
> +       hyp_assert_lock_held(&vm->lock);
> +       return check_page_state_range(&vm->pgt, addr, size, &d);
> +}
> +
>  static int check_share(struct pkvm_mem_share *share)
>  {
>         const struct pkvm_mem_transition *tx = &share->tx;
> @@ -1349,3 +1370,54 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages)
>
>         return ret;
>  }
> +
> +int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
> +                           enum kvm_pgtable_prot prot)
> +{
> +       struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
> +       u64 phys = hyp_pfn_to_phys(pfn);
> +       u64 ipa = hyp_pfn_to_phys(gfn);
> +       struct hyp_page *page;
> +       int ret;
> +
> +       if (prot & ~KVM_PGTABLE_PROT_RWX)
> +               return -EINVAL;
> +
> +       ret = check_range_allowed_memory(phys, phys + PAGE_SIZE);
> +       if (ret)
> +               return ret;
> +
> +       host_lock_component();
> +       guest_lock_component(vm);
> +
> +       ret = __guest_check_page_state_range(vcpu, ipa, PAGE_SIZE, PKVM_NOPAGE);
> +       if (ret)
> +               goto unlock;
> +
> +       page = hyp_phys_to_page(phys);
> +       switch (page->host_state) {
> +       case PKVM_PAGE_OWNED:
> +               WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_OWNED));
> +               break;
> +       case PKVM_PAGE_SHARED_OWNED:
> +               if (page->host_share_guest_count)
> +                       break;
> +               /* Only host to np-guest multi-sharing is tolerated */
> +               WARN_ON(1);
> +               fallthrough;
> +       default:
> +               ret = -EPERM;
> +               goto unlock;
> +       }
> +
> +       WARN_ON(kvm_pgtable_stage2_map(&vm->pgt, ipa, PAGE_SIZE, phys,
> +                                      pkvm_mkstate(prot, PKVM_PAGE_SHARED_BORROWED),
> +                                      &vcpu->vcpu.arch.pkvm_memcache, 0));
> +       page->host_share_guest_count++;
> +
> +unlock:
> +       guest_unlock_component(vm);
> +       host_unlock_component();
> +
> +       return ret;
> +}
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 496d186efb03..f2e363fe6b84 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -795,6 +795,13 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
>         /* Push the metadata pages to the teardown memcache */
>         for (idx = 0; idx < hyp_vm->nr_vcpus; ++idx) {
>                 struct pkvm_hyp_vcpu *hyp_vcpu = hyp_vm->vcpus[idx];
> +               struct kvm_hyp_memcache *vcpu_mc = &hyp_vcpu->vcpu.arch.pkvm_memcache;
> +
> +               while (vcpu_mc->nr_pages) {
> +                       void *addr = pop_hyp_memcache(vcpu_mc, hyp_phys_to_virt);

nit: newline

> +                       push_hyp_memcache(mc, addr, hyp_virt_to_phys);
> +                       unmap_donated_memory_noclear(addr, PAGE_SIZE);
> +               }
>
>                 teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
>         }
> --
> 2.47.1.613.gc27f4b7a9f-goog
>
