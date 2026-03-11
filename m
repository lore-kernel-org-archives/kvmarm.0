Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19793C8721
	for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 10:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773224602; cv=pass; b=iqPXFPIHZ1EhUv0aGRGPKYOeDj249whQM3cNi6+QungdOpBBAR3EX4T7E1OaFB1PF+YaceJHLn017fEY6uPXmM1hWBJi+J3GNil0E4bobGTTy8ftV36zUxgulB8GWx2SKsPmZKn+PlWQR7l7zis1bnyO+u4M6R4EKcJkh0ElYuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773224602; c=relaxed/simple;
	bh=Pq9KhLOhbAw3l7T1zR9SPBQlmzrTy1scC3EJZ7OpsfU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UZw/fEWXBqDVaX9NT0N+JoPdWQzGyM5jKbB2h3uBpuuXjTjoKm97vpWiR6DXtgbvBf0Usbot3KVFQe1PC8D6+Jx6AiXMaybFlu/pvYcYf+CJD6Bjt7ZdV845+DzJG0k+WUR7UvORwNcl94ipSRV9y9UgfYfdbctobl1A86holZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XB9sR2Sz; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XB9sR2Sz"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5091ed02c54so403911cf.1
        for <kvmarm@lists.linux.dev>; Wed, 11 Mar 2026 03:23:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773224600; cv=none;
        d=google.com; s=arc-20240605;
        b=X0be8laBfvCn8hucLlhcHWaIpl9LymmeMOcSBI52VVB22wqvYA6KNxCsuNjcUtivIj
         tOeVDz2i9eHxlqwpvG8uZhKxVijmVoy0Xx3DaJZY8aTFuC/bCQvDZntnKZ7TmuKvLsea
         k0tsT3nKdvI8u5/SxGuJPARyqqixJQsVLF7Yb4GLlI4vT5MotBVAJUaifsFj0qyqDoBM
         bkxUxffmCOY3khMmiS8dxO5WscuObPJ+15N21WowbDG9NxpS/Iw37JCuWtzN1hAm+1fu
         h/am9m9edbeRposNDaEcqJ9PvY40gAtu+JLyofJgwN3YRwzD1ByyVgV8Ja/h8bBoQvsi
         cx2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=/mMgJgBp5NGPUR+UeJAWPbefuAnvnCqo/QYTM57YQHk=;
        fh=Jxzwzg3laewSUvCA2a09gOOd6H1o1mMdzeS5XgaaAVk=;
        b=iL/bHlqPKT60bPYFjMcTAgpCXPyYVzPF44HSdIi6e8xtZGfJhMpIx2o+34RdQQM4gX
         EBlatycWrdliRRUueaZl3NcySaQgRBy1EtJPW1jxTLzZikArtPX3164wDKTpxpHNx9tj
         dsrKWnMRk1HfmX38p1Yb+cfjJmQds1K3H9xN9QGzZr2n62Kx/LZzb9RCF3R9loDDMVeA
         XF20S8x1xehl/BFe+KhtcuFYgvvLEo0JJBTNnI52M9VqoReB/x7MtnyEEgD1oIN15t7n
         VBIIrv6JyLeTOyH7WzIXx+7/zdwq7EfD4dMiAxRO1fktaw9WJkyDRj7Pr7P7E5SnX29f
         Hotg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773224600; x=1773829400; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/mMgJgBp5NGPUR+UeJAWPbefuAnvnCqo/QYTM57YQHk=;
        b=XB9sR2SzIAhFCEMZdbLxcGYGh7UKsv1Exxk3uzCBMorQDcVY4U4mRND9dkQCPpwr4l
         5WDMi490iMsDF7c60ZwgEpEqcFVtHV/LP+UxoYXi1nnFJ65cWyABUTqv5ph00eLb6Oq+
         fPRjKkjXs69o+w2gTVi3gxFenaiNJZfgHokzH38yXfjbkQwO136Q3cwt1G10Esbp9h81
         2ja1GPSQi/4s0/eO4SCjZai6yZJxwiV4jS2Vyrzl/urXodm596ftCIP8FIGDvoScPbkw
         0vuS3srxWqav2srdX4xQcvtx23h/GrmPjJWI5joBnLnx6HvVmoexSax0KB/UtuM9ANVN
         Jz+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773224600; x=1773829400;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/mMgJgBp5NGPUR+UeJAWPbefuAnvnCqo/QYTM57YQHk=;
        b=qYCSRa2QEB5lgFVl8MPrrNZKPuUIN9mT/qWj1cOzLxEvwj4cjcUYDaiRRt3puM/4/H
         DFqacvpbgxHNVT6wSkh/Mv31uKWBTtq8WtE+rns8x7phNYK7d7lAu+U4dBwgrWo5BtUN
         K0Ca82XjSQ4ei56+2ym0lulbjj+WAecrYtMMmdA4TTiIvADZ8x7wMoGAMxLgW94Yk7eK
         bu42N7ah/Vj/mhnmN2MYr1AGPFDlhkPK/nKee/U+LyX7PI4Xc9j8/FpO9cY6qZ50eCXz
         Drm3t6E9L9KzmaEZQgG4Ph7SXsuy+pDqfFSdYcdnhkXxrEKZaYzCmS7NsKjNFm5hSoR0
         bIcA==
X-Gm-Message-State: AOJu0YyOuquvAWk6VL/n6nXST6hdIL7wr+VnMUz1sXA462/erZibDTbI
	IBFPYh0bBrhTliADUlwSWlCNTuFze6pZtZD87jpuY2wNIH4KIgDLnGH6+bCikXH9EK05jw08f1j
	sBwZERO/8sGo8NmGEMX3H3IK3q/r15+bDSiizvgzz
X-Gm-Gg: ATEYQzwFjftQmXzVKn/XNuJurQtlSIYPDrRXqQqrHSFfPmjXmpn4LbrTfsVR6a4byp0
	UZNYeYvXaQl9p6iFM+rtTR//VMe/DOT6QmV7oM4nIxPuLNT3f+DZSoZuWywBPZKaefPOWJu/40e
	i5DxqvsAFGLF0vxkZqLVNSUyROcEVQ0Rkn4YqSe72zHczwVqJBOSSbNdBKke4Lb1SuLFVC60Ofw
	ix4tzZeQhoWJIqYjOnRXU6tG81KmkSgpYclLdA9Yo/FBHvGc6hDA8WL81O5W+cwkeEDb3hH2l3z
	92FTO5VtsPMSu6bBKdRYEjjeYlcx65JkHCqG6w==
X-Received: by 2002:a05:622a:28c:b0:509:45f:fdd2 with SMTP id
 d75a77b69052e-50939a712c1mr9774361cf.15.1773224599463; Wed, 11 Mar 2026
 03:23:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260305144351.17071-1-will@kernel.org> <20260305144351.17071-11-will@kernel.org>
In-Reply-To: <20260305144351.17071-11-will@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 11 Mar 2026 10:22:42 +0000
X-Gm-Features: AaiRm53QOriN6Gt_aOTc2-7qjZSAT70BFViqYooL3P-uIiVREeASlFd3nnmxw4E
Message-ID: <CA+EHjTygODdT5tKs7qx_8a0NwWpw7x8LRmH26bt685N7N6_iVg@mail.gmail.com>
Subject: Re: [PATCH v3 10/36] KVM: arm64: Split teardown hypercall into two phases
To: Will Deacon <will@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Mostafa Saleh <smostafa@google.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 5 Mar 2026 at 14:44, Will Deacon <will@kernel.org> wrote:
>
> In preparation for reclaiming protected guest VM pages from the host
> during teardown, split the current 'pkvm_teardown_vm' hypercall into
> separate 'start' and 'finalise' calls.
>
> The 'pkvm_start_teardown_vm' hypercall puts the VM into a new 'is_dying'
> state, which is a point of no return past which no vCPU of the pVM is
> allowed to run any more.  Once in this new state,
> 'pkvm_finalize_teardown_vm' can be used to reclaim meta-data and
> page-table pages from the VM. A subsequent patch will add support for
> reclaiming the individual guest memory pages.
>
> Co-developed-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>

Reviewed-by: Fuad Tabba <tabba@google.com>

Cheers,
/fuad

> ---
>  arch/arm64/include/asm/kvm_asm.h       |  3 ++-
>  arch/arm64/include/asm/kvm_host.h      |  7 +++++
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h |  4 ++-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c     | 14 +++++++---
>  arch/arm64/kvm/hyp/nvhe/pkvm.c         | 36 ++++++++++++++++++++++----
>  arch/arm64/kvm/pkvm.c                  |  7 ++++-
>  6 files changed, 60 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 7b72aac4730d..df6b661701b6 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -89,7 +89,8 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___pkvm_unreserve_vm,
>         __KVM_HOST_SMCCC_FUNC___pkvm_init_vm,
>         __KVM_HOST_SMCCC_FUNC___pkvm_init_vcpu,
> -       __KVM_HOST_SMCCC_FUNC___pkvm_teardown_vm,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_start_teardown_vm,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_finalize_teardown_vm,
>         __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_load,
>         __KVM_HOST_SMCCC_FUNC___pkvm_vcpu_put,
>         __KVM_HOST_SMCCC_FUNC___pkvm_tlb_flush_vmid,
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 2ca264b3db5f..911819e6e757 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -255,6 +255,13 @@ struct kvm_protected_vm {
>         struct kvm_hyp_memcache stage2_teardown_mc;
>         bool is_protected;
>         bool is_created;
> +
> +       /*
> +        * True when the guest is being torn down. When in this state, the
> +        * guest's vCPUs can't be loaded anymore, but its pages can be
> +        * reclaimed by the host.
> +        */
> +       bool is_dying;
>  };
>
>  struct kvm_mpidr_data {
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> index 184ad7a39950..04c7ca703014 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/pkvm.h
> @@ -73,7 +73,9 @@ int __pkvm_init_vm(struct kvm *host_kvm, unsigned long vm_hva,
>                    unsigned long pgd_hva);
>  int __pkvm_init_vcpu(pkvm_handle_t handle, struct kvm_vcpu *host_vcpu,
>                      unsigned long vcpu_hva);
> -int __pkvm_teardown_vm(pkvm_handle_t handle);
> +
> +int __pkvm_start_teardown_vm(pkvm_handle_t handle);
> +int __pkvm_finalize_teardown_vm(pkvm_handle_t handle);
>
>  struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
>                                          unsigned int vcpu_idx);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 127decc2dd2b..634ea2766240 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -553,11 +553,18 @@ static void handle___pkvm_init_vcpu(struct kvm_cpu_context *host_ctxt)
>         cpu_reg(host_ctxt, 1) = __pkvm_init_vcpu(handle, host_vcpu, vcpu_hva);
>  }
>
> -static void handle___pkvm_teardown_vm(struct kvm_cpu_context *host_ctxt)
> +static void handle___pkvm_start_teardown_vm(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
>
> -       cpu_reg(host_ctxt, 1) = __pkvm_teardown_vm(handle);
> +       cpu_reg(host_ctxt, 1) = __pkvm_start_teardown_vm(handle);
> +}
> +
> +static void handle___pkvm_finalize_teardown_vm(struct kvm_cpu_context *host_ctxt)
> +{
> +       DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
> +
> +       cpu_reg(host_ctxt, 1) = __pkvm_finalize_teardown_vm(handle);
>  }
>
>  typedef void (*hcall_t)(struct kvm_cpu_context *);
> @@ -598,7 +605,8 @@ static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__pkvm_unreserve_vm),
>         HANDLE_FUNC(__pkvm_init_vm),
>         HANDLE_FUNC(__pkvm_init_vcpu),
> -       HANDLE_FUNC(__pkvm_teardown_vm),
> +       HANDLE_FUNC(__pkvm_start_teardown_vm),
> +       HANDLE_FUNC(__pkvm_finalize_teardown_vm),
>         HANDLE_FUNC(__pkvm_vcpu_load),
>         HANDLE_FUNC(__pkvm_vcpu_put),
>         HANDLE_FUNC(__pkvm_tlb_flush_vmid),
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index 2f029bfe4755..c4e05ab8b605 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -255,7 +255,10 @@ struct pkvm_hyp_vcpu *pkvm_load_hyp_vcpu(pkvm_handle_t handle,
>
>         hyp_spin_lock(&vm_table_lock);
>         hyp_vm = get_vm_by_handle(handle);
> -       if (!hyp_vm || hyp_vm->kvm.created_vcpus <= vcpu_idx)
> +       if (!hyp_vm || hyp_vm->kvm.arch.pkvm.is_dying)
> +               goto unlock;
> +
> +       if (hyp_vm->kvm.created_vcpus <= vcpu_idx)
>                 goto unlock;
>
>         hyp_vcpu = hyp_vm->vcpus[vcpu_idx];
> @@ -859,7 +862,32 @@ teardown_donated_memory(struct kvm_hyp_memcache *mc, void *addr, size_t size)
>         unmap_donated_memory_noclear(addr, size);
>  }
>
> -int __pkvm_teardown_vm(pkvm_handle_t handle)
> +int __pkvm_start_teardown_vm(pkvm_handle_t handle)
> +{
> +       struct pkvm_hyp_vm *hyp_vm;
> +       int ret = 0;
> +
> +       hyp_spin_lock(&vm_table_lock);
> +       hyp_vm = get_vm_by_handle(handle);
> +       if (!hyp_vm) {
> +               ret = -ENOENT;
> +               goto unlock;
> +       } else if (WARN_ON(hyp_page_count(hyp_vm))) {
> +               ret = -EBUSY;
> +               goto unlock;
> +       } else if (hyp_vm->kvm.arch.pkvm.is_dying) {
> +               ret = -EINVAL;
> +               goto unlock;
> +       }
> +
> +       hyp_vm->kvm.arch.pkvm.is_dying = true;
> +unlock:
> +       hyp_spin_unlock(&vm_table_lock);
> +
> +       return ret;
> +}
> +
> +int __pkvm_finalize_teardown_vm(pkvm_handle_t handle)
>  {
>         struct kvm_hyp_memcache *mc, *stage2_mc;
>         struct pkvm_hyp_vm *hyp_vm;
> @@ -873,9 +901,7 @@ int __pkvm_teardown_vm(pkvm_handle_t handle)
>         if (!hyp_vm) {
>                 err = -ENOENT;
>                 goto err_unlock;
> -       }
> -
> -       if (WARN_ON(hyp_page_count(hyp_vm))) {
> +       } else if (!hyp_vm->kvm.arch.pkvm.is_dying) {
>                 err = -EBUSY;
>                 goto err_unlock;
>         }
> diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
> index 20d50abb3b94..a39dacd1d617 100644
> --- a/arch/arm64/kvm/pkvm.c
> +++ b/arch/arm64/kvm/pkvm.c
> @@ -88,7 +88,7 @@ void __init kvm_hyp_reserve(void)
>  static void __pkvm_destroy_hyp_vm(struct kvm *kvm)
>  {
>         if (pkvm_hyp_vm_is_created(kvm)) {
> -               WARN_ON(kvm_call_hyp_nvhe(__pkvm_teardown_vm,
> +               WARN_ON(kvm_call_hyp_nvhe(__pkvm_finalize_teardown_vm,
>                                           kvm->arch.pkvm.handle));
>         } else if (kvm->arch.pkvm.handle) {
>                 /*
> @@ -350,6 +350,11 @@ void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
>         if (!handle)
>                 return;
>
> +       if (pkvm_hyp_vm_is_created(kvm) && !kvm->arch.pkvm.is_dying) {
> +               WARN_ON(kvm_call_hyp_nvhe(__pkvm_start_teardown_vm, handle));
> +               kvm->arch.pkvm.is_dying = true;
> +       }
> +
>         __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
>  }
>
> --
> 2.53.0.473.g4a7958ca14-goog
>
