Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056BA34B1A5
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 13:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784121202; cv=none; b=k53x8VxCt5zq1EEol+xGF4j5CwC0zfjV/BkSLK8R2JtthIBuisIAcy7yux3CAasIBvfEn8ZQuOj1Q1sAQiLPdtwHTDvTuTR7mDbIMbg5tjl+Xko+4Uxl9t/+kWecLcEWnP9BAZce+eBqsY19Zg1DbKBYZIEnXHiawQjnKFKOjSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784121202; c=relaxed/simple;
	bh=cQ9OFkNLW4RmYO2nHSzK3uDmwIpY+p05r9pBXxsbdJA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nUH9749ruPVEoYajmymix/nAkOjsU4sItezC17RCSzeIDnGam1OOuEbCMjJ95m6gHgH04UaX5v6LQA9xkzHhfhO/COT03tH0gY+gv8YisDKuVvrk2Q1ljfCYwWw81uwnQHXwxcN8G0paI6dNDA2qJE7du0Izr95LiCY7VKdboZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zntsn3xF; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zntsn3xF"
X-Forwarded-Encrypted: i=1; AHgh+RrfEzzonl1v5WiUy0DBu0jaLsyZBFPZWlUvzRZ3bu+JaX91SwwgxycAqDR8gQBVrEXCSWVEFU8=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784121197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qXQqRrfSMAyOpnqI+nXSErAlrjOy9m1anxQWfZHMfi4=;
	b=Zntsn3xFLWq9Hvd8639V+T4AcoMHymeG2kLRBJFKKAQr8YYYFUvPZvoOsFLv4WqR+tuaFb
	Z9/Oz7Y6kD+4fEym88+0KoOY88DlhZWIgY6HspZOqkMoOsWfUaVaDWNpXKrCFgywhPT85Z
	ZEy63GkLn50xJZG0KwlCD8lunQNW2+4=
X-Gm-Message-State: AOJu0Yyy9s5/M3CU1VCzSLvtNMw8bCXr3EhYwJtrnDh7II3OGHi5tr6E
	4X4hEx7rAD+Ee7EEHAidP5VGdufd79lBr+JaYGRksmC7AvlDbjKhyc0Z3aRsKUAkDHXppHEh5nb
	QQQkiN1U18c2YKgfaURTRs2Fh0ZxffMnwT+k4YDMC
X-Received: by 2002:a05:622a:53cb:b0:51c:7a90:a79a with SMTP id
 d75a77b69052e-51d83860d08mr27396621cf.26.1784121194870; Wed, 15 Jul 2026
 06:13:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260706175415.2604046-1-vdonnefort@google.com> <20260706175415.2604046-17-vdonnefort@google.com>
In-Reply-To: <20260706175415.2604046-17-vdonnefort@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 15 Jul 2026 14:12:37 +0100
X-Gmail-Original-Message-ID: <CA+EHjTxhKBeTf1QvdjHm7MDG654ct2Et2X9trA1bGdZiJj_sEQ@mail.gmail.com>
X-Gm-Features: AUfX_mx7GarJDmJkKq7zMzXRvynC3BwHr2gkth2ZeAGOpnvLMG6dIWBJ2r8WH88
Message-ID: <CA+EHjTxhKBeTf1QvdjHm7MDG654ct2Et2X9trA1bGdZiJj_sEQ@mail.gmail.com>
Subject: Re: [PATCH v2 16/18] KVM: arm64: Alloc pkvm_hyp_vcpu using pKVM heap allocator
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com
Content-Type: text/plain; charset="UTF-8"
X-Migadu-Flow: FLOW_OUT

On Mon, 6 Jul 2026 at 18:54, Vincent Donnefort <vdonnefort@google.com> wrote:

...
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

On Sashiko's alignment point: hyp_alloc only guarantees 8-byte
alignment while pkvm_hyp_vcpu wants 16 (the __uint128_t vregs[32]),
and the old map_donated_memory path was page-aligned, so it's a real
reduction.

But if my understanding of the ARM ARM is correct, and please note
that I just consulted the spec when replying to this, so it's a big
*if*: I don't think it faults. We run EL2 with SCTLR_EL2.A == 0
(INIT_SCTLR_EL2_MMU_ON has SA but not A), and FPSIMD save/restore is
plain LDR/STR/LDP/STP of Q registers. From the ARM ARM (DDI 0487M.c,
B2.8.2.1.1):

"When the value of SCTLR_ELx.A applicable to the current Exception
level is 0: An unaligned access is performed."

and, covering LDP/STP:

"For these instructions, the definition of an unaligned access is
based on the size of the accessed elements, not the overall size of
the memory access. This affects SIMD and SVE element and structure
loads and stores, and also load/store pair instructions."

However, the alignment here is still weaker than the
kmalloc/alloc_pages callers relied on , so it might be cleaner to give
hyp_alloc a 16-byte minimum alignment at the allocator level rather
than per-caller. What do you think?

Cheers,
/fuad


>         if (!hyp_vcpu)
> -               return -ENOMEM;
> +               return hyp_alloc_errno();
>
>         hyp_spin_lock(&vm_table_lock);
>
> @@ -926,24 +892,12 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
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
> @@ -993,7 +947,7 @@ int __pkvm_start_teardown_vm(pkvm_handle_t handle)
>
>  int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
>  {
> -       struct kvm_hyp_memcache *mc, *stage2_mc;
> +       struct kvm_hyp_memcache *stage2_mc;
>         struct pkvm_hyp_vm *hyp_vm;
>         struct kvm *host_kvm;
>         unsigned int idx;
> @@ -1014,7 +968,6 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
>         hyp_spin_unlock(&vm_table_lock);
>
>         /* Reclaim guest pages (including page-table pages) */
> -       mc = &host_kvm->arch.pkvm.teardown_mc;
>         stage2_mc = &host_kvm->arch.pkvm.stage2_teardown_mc;
>         reclaim_pgtable_pages(hyp_vm, stage2_mc);
>         unpin_host_vcpus(hyp_vm->vcpus, hyp_vm->kvm.created_vcpus);
> @@ -1036,7 +989,7 @@ int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
>                         unmap_donated_memory_noclear(addr, PAGE_SIZE);
>                 }
>
> -               teardown_donated_memory(mc, hyp_vcpu, sizeof(*hyp_vcpu));
> +               hyp_free(hyp_vcpu);
>         }
>
>         hyp_free(hyp_vm);
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 8a8b5b84825c..1899b05d9fc2 100644
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
> 2.55.0.rc2.803.g1fd1e6609c-goog
>
