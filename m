Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FAD1A072A
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 15:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733843253; cv=none; b=AvHSqwQxr2JohPV1EdrH6ePzIU+eJYEhBrBaboxQCxSN4y1qOWWDP9V4WS1GE1U8utJUfYXhEyGrgEG68qcfY14gOGwM70b4t85oSWiEVgBecRNSONi1Zfc7NWuKJx2Pcg5T0OD5Ufd0EBYMURqmG025LXBUbN+d/1FW3PNUQZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733843253; c=relaxed/simple;
	bh=NNnB1DyfuoKzm2DmRXnXHiJG8hZpHzLTuRmfrd+D8Ls=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YRz3oMFSVd+StJGxWcYGJc9Km+xURJz8OXT84ObV4eBUalM/C0vCmZE2Ne+ttZ764so04PnNyKsGUhyCe9eKVoue6E3rw6HGW81PDRbPHpmLgbhF3dNbiSaxBA0NQBhfCrA6Ya/CE9idUXUvnsvIGmcKDvpLSOHsVFpgC2gfD/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IzL4ztqb; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IzL4ztqb"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-434e5e71a08so43865e9.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 07:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733843250; x=1734448050; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tmhmaaJdV6eQOFANMqIcIt0l8XrMzMUTFt9zdpoB/Zc=;
        b=IzL4ztqbZrILNO2LlD0jM66uAsG4dZvEU4pss18M97Zrz7/7UHiIJZx485vwtYvgV2
         XsGErBqOvAa+Iv4oL+yvWjvK1eOaLbxDg6kqLZLodOi56hxgKRBBp+2c/RrP99tbzqAL
         SzI9lQoXrOcjdR/wKyk4EDVfm++fStpfOJo1lXmvwe/nI8GiLgll0bF2mtAyCYicvsTJ
         XofPSbDWRThZYFdif08tteBIdmSjHHiHSZdv/cZA86289LgVIuMkEtbRBGo8ALoiokWF
         brQdrhFOuQW0gjyl0HYyYzLPmijPvWE/wfFMigaZHV6dYLFapa6jS183UPnt7roofwQP
         eRyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733843250; x=1734448050;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tmhmaaJdV6eQOFANMqIcIt0l8XrMzMUTFt9zdpoB/Zc=;
        b=DyBKVyao9eDCJ20UP3SUlwV8bTSK3W3Ya1cDaDVGoNZnEORFZ6tGPquGDk0xeFyl7y
         LxtXYMYs5yJDitrZpG1dVE0oLKgss9cAx/jv3y3PJ2UFA4Iyri1hS6vObr9kEKMF43Nc
         lq5Bkup609p65F/fBUUvs0Jl9faVWfhrlaQoLFfyA/F/YXbi8iN7up7R5QCENya+kV6d
         qwPzohc4M0YEORHJAgS00yUzmLEr4RNX+2p350mIFdtG3wqMzwgR9a18EatYzpRBtry7
         nKsvAmx8sUnIr4XkJem1K1bGgGNLyUhLU1xgjLNY9nivmi2PFU4qBAqOsap3ZvV48JAB
         6k1w==
X-Forwarded-Encrypted: i=1; AJvYcCX1ogyxDsUWVxtd2wujXKzUuNdAo60vU/6vquf2CyWjnrinLqZYm/992aQWlVfLNHEn4p9QI9A=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz9qxaA975R361vD0ZnVTSmUexh0kV0UrCnCKpJc8FTH6FUk3tf
	Ol7ljKGojxliYuVNfbnjqnknzjDfTL+TuG3NpSg386AN78d4VpkMBXx7LatBZUKoHsQbwmfCYvV
	h423gOMFU2ykeNIrIJIj0n7BhukTM4X9dcCNq
X-Gm-Gg: ASbGnctrcz4PDUpzKozleZmbZcIOVpVCUe8E0BaOocDjdQgF2cfLt42Sxl3yj/di6zN
	qhKO/pC1ROE1jzAjOED2IWo+/vMLWXamPCBuGtgGzRazuiogK9321PD0Zk+aaU7kd
X-Google-Smtp-Source: AGHT+IF0v/8FkIfUp8V2WvAH5E1CeHZD7x+qAjIRtMSeRZsWGkiFZVc6N2lek4jfdw4f++/UM2MaP8BhSMOlA5+0cTs=
X-Received: by 2002:a05:600c:4595:b0:434:a0fd:95d9 with SMTP id
 5b1f17b1804b1-43539dd9c68mr1171885e9.5.1733843249949; Tue, 10 Dec 2024
 07:07:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com> <20241203103735.2267589-14-qperret@google.com>
In-Reply-To: <20241203103735.2267589-14-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Dec 2024 15:06:53 +0000
Message-ID: <CA+EHjTx-MZHKwkGYPU+yN-CDkNh1kxTXN8FWTeaPfM95OSkjcQ@mail.gmail.com>
Subject: Re: [PATCH v2 13/18] KVM: arm64: Introduce __pkvm_host_wrprotect_guest()
To: Quentin Perret <qperret@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Vincent Donnefort <vdonnefort@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Quentin,

On Tue, 3 Dec 2024 at 10:38, Quentin Perret <qperret@google.com> wrote:
>
> Introduce a new hypercall to remove the write permission from a
> non-protected guest stage-2 mapping. This will be used for e.g. enabling
> dirty logging.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h              |  1 +
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 24 +++++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 19 +++++++++++++++
>  4 files changed, 45 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 5d51933e44fb..4d7d20ea03df 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -68,6 +68,7 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_relax_guest_perms,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_wrprotect_guest,
>         __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
>         __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
>         __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index db0dd83c2457..8658b5932473 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -42,6 +42,7 @@ int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
>  int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
>  int __pkvm_host_relax_guest_perms(u64 gfn, enum kvm_pgtable_prot prot, struct pkvm_hyp_vcpu *vcpu);
> +int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
>
>  bool addr_is_memory(phys_addr_t phys);
>  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 60dd56bbd743..3feaf2119e51 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -286,6 +286,29 @@ static void handle___pkvm_host_relax_guest_perms(struct kvm_cpu_context *host_ct
>         cpu_reg(host_ctxt, 1) = ret;
>  }
>
> +static void handle___pkvm_host_wrprotect_guest(struct kvm_cpu_context *host_ctxt)
> +{
> +       DECLARE_REG(pkvm_handle_t, handle, host_ctxt, 1);
> +       DECLARE_REG(u64, gfn, host_ctxt, 2);
> +       struct pkvm_hyp_vm *hyp_vm;
> +       int ret = -EINVAL;
> +
> +       if (!is_protected_kvm_enabled())
> +               goto out;
> +
> +       hyp_vm = get_pkvm_hyp_vm(handle);
> +       if (!hyp_vm)
> +               goto out;
> +       if (pkvm_hyp_vm_is_protected(hyp_vm))
> +               goto put_hyp_vm;

These checks are (unsurprisingly) the same for all these functions.
Does it make sense to have a helper do these checks?

Cheers,
/fuad

> +       ret = __pkvm_host_wrprotect_guest(gfn, hyp_vm);
> +put_hyp_vm:
> +       put_pkvm_hyp_vm(hyp_vm);
> +out:
> +       cpu_reg(host_ctxt, 1) = ret;
> +}
> +
>  static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> @@ -498,6 +521,7 @@ static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__pkvm_host_share_guest),
>         HANDLE_FUNC(__pkvm_host_unshare_guest),
>         HANDLE_FUNC(__pkvm_host_relax_guest_perms),
> +       HANDLE_FUNC(__pkvm_host_wrprotect_guest),
>         HANDLE_FUNC(__kvm_adjust_pc),
>         HANDLE_FUNC(__kvm_vcpu_run),
>         HANDLE_FUNC(__kvm_flush_vm_context),
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index d4b28e93e790..89312d7cde2a 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1503,3 +1503,22 @@ int __pkvm_host_relax_guest_perms(u64 gfn, enum kvm_pgtable_prot prot, struct pk
>
>         return ret;
>  }
> +
> +int __pkvm_host_wrprotect_guest(u64 gfn, struct pkvm_hyp_vm *vm)
> +{
> +       u64 ipa = hyp_pfn_to_phys(gfn);
> +       u64 phys;
> +       int ret;
> +
> +       host_lock_component();
> +       guest_lock_component(vm);
> +
> +       ret = __check_host_unshare_guest(vm, &phys, ipa);
> +       if (!ret)
> +               ret = kvm_pgtable_stage2_wrprotect(&vm->pgt, ipa, PAGE_SIZE);
> +
> +       guest_unlock_component(vm);
> +       host_unlock_component();
> +
> +       return ret;
> +}
> --
> 2.47.0.338.g60cca15819-goog
>
