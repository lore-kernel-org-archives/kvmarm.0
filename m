Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018121A0B15
	for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 14:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733842606; cv=none; b=MSfQfwZ563TPSeNpein2BI5PvvpkasJnYu59xiObR4K4Vb79KCPMt6IqQ/5VsSmNpaFpAE3IEzFdUuPPpY4lU2wBFavcEM+54IRoZKOIiQXIuTFLgg14t66l8UkftKi8emB5dEg9FNzeWTOgPEFW3gq33zgkZ12PckJPt5/xbRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733842606; c=relaxed/simple;
	bh=36l5sqTsyGB+zahHlHiYJEOq2y50QnU/gLvSH/lBzlc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WIazYbOZAHvIHzUunKNq+TiX+bTOWDFWQwWc94+f9CFyWB+aUpRE0RsFNz4YXc/fPoYSF8MnzeuW38UY8ywCMcprAy4rcpGqq/U/jAy7/znFxZEebQSivyQXjlZITv1c6Hh10L6Cp5ZNVtnrBWmOsAXXObX1XLOxWl5A1QKuzYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vwH6q9gK; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vwH6q9gK"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-434fa6bf6e4so42295e9.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Dec 2024 06:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733842602; x=1734447402; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CPwwSGhVOWXHBjvSfy9QVGaBSD0H0DxOIeEJkupGNUU=;
        b=vwH6q9gKKS9LQJIsMnopzLkDaD7i15CWPAYXsah913VsChHtGtYoJ0CXr23nYlGtr8
         0Okx29JKjZEI0N+RNoXMpqGbiOhl+8QNrFtCuenRRxZwd2D1EqjVd5yArtU7i5M5lVhO
         N52YPczFWrpFbg8fiM5aBrG3HmMxDgx9GWox4pWdTQLtEJYhHwgvc71sYVYClpe8wYlp
         y4YTC+UV30/+u+6W7ZNLYW8fB6o9cMR9OP04GX9KPJbwgEA+2fM5KeR0jFXYRkwS4ad5
         EzRMUfgfp4U2hxloV31327RHGcL/rHWlfBlv5S9JJJ8u12s31Vqua7GzlP6aQHTXxCh6
         thWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733842602; x=1734447402;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CPwwSGhVOWXHBjvSfy9QVGaBSD0H0DxOIeEJkupGNUU=;
        b=Yn6140um8M76M5+FUQ5Bdmm+SpkNtVpxhdu6pc5Jx4sYADBXl8IJCw18xV8ZYV/Jvc
         y/qz1li/CEo7KUpC7SnwfskKOhapHhBFoHM1J1OyrBG6CCnRlc9CqBVhrTHN7MQgCrBe
         TGARBE6bgHkk6CINgZPReD5JoOhOwFClo/CG6WOWuqQbZjFHnz5pv/sh93jTZcznfbpO
         ORj2n+1KibOogVZ9JrRzHwGAGzC4hbPu5kcJ9nTkII5rGxD8Y9KIEWrIYlShQDxMwS39
         3W28Nl5QRj78ySoyHOgjEa7g4irIXlkDyqhIRxUBPKPH1JqUM5hruzAFTcXZevlSn43Y
         F+qg==
X-Forwarded-Encrypted: i=1; AJvYcCVBLRGGOeKyl0a800y6K5EflNVTu4gIZjOawSZiDIVxU3Dy+pXHL5z0bY/VQZRNaR1x1f0SQEo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyaNjWnkdU8kHE0BIS048KMATsX+79dTeSxKid+sO9Oawe4v9qP
	prslqfY+hbiMr/uYNaVORSZ/+6892la0gFR8Ggv9TFSLMdFBIj1x6gJwDD8BQPAdkwymaXlRZXe
	kyPTDl+EByAiFH5K9Ku/0nCDP2rBRExfWP4kx
X-Gm-Gg: ASbGncssnBKpRHtLleRqiZr1ZCDqrZ9YeSwOG7YVmnZ7NpPLmU5sNY16lcXBN526FL3
	FTubtG1VmWM5FYbXOERY5o3ES03t4/Phru3Wq+d5Ptd1+5aNuHGdSvyW+6MiMM4UV
X-Google-Smtp-Source: AGHT+IFrek7ZOXFjbieOK3Z+KiuRhmB/JQIfCUTikq2lGnXrH/9Y4kZOz9Oyane5oNuACjRRiOYBT3El9OhjG5oV6Sc=
X-Received: by 2002:a05:600c:898:b0:436:1811:a79c with SMTP id
 5b1f17b1804b1-4361811a993mr606625e9.5.1733842602227; Tue, 10 Dec 2024
 06:56:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203103735.2267589-1-qperret@google.com> <20241203103735.2267589-13-qperret@google.com>
In-Reply-To: <20241203103735.2267589-13-qperret@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 10 Dec 2024 14:56:05 +0000
Message-ID: <CA+EHjTwNgf5fPuWMaPaN4mcdd5y4uydJsXi-zEBatFnbwoaLLQ@mail.gmail.com>
Subject: Re: [PATCH v2 12/18] KVM: arm64: Introduce __pkvm_host_relax_guest_perms()
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
> Introduce a new hypercall allowing the host to relax the stage-2
> permissions of mappings in a non-protected guest page-table. It will be
> used later once we start allowing RO memslots and dirty logging.
>
> Signed-off-by: Quentin Perret <qperret@google.com>
> ---
>  arch/arm64/include/asm/kvm_asm.h              |  1 +
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            | 20 ++++++++++++++++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 23 +++++++++++++++++++
>  4 files changed, 45 insertions(+)
>
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 0b6c4d325134..5d51933e44fb 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -67,6 +67,7 @@ enum __kvm_host_smccc_func {
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_hyp,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_share_guest,
>         __KVM_HOST_SMCCC_FUNC___pkvm_host_unshare_guest,
> +       __KVM_HOST_SMCCC_FUNC___pkvm_host_relax_guest_perms,
>         __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
>         __KVM_HOST_SMCCC_FUNC___kvm_vcpu_run,
>         __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context,
> diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> index e528a42ed60e..db0dd83c2457 100644
> --- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> +++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
> @@ -41,6 +41,7 @@ int __pkvm_host_share_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_unshare_ffa(u64 pfn, u64 nr_pages);
>  int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu, enum kvm_pgtable_prot prot);
>  int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm);
> +int __pkvm_host_relax_guest_perms(u64 gfn, enum kvm_pgtable_prot prot, struct pkvm_hyp_vcpu *vcpu);

The parameters are the same as __pkvm_host_share_guest, but in a
different order. I looked ahead at later patches in the series, and similar
issues regarding parameter type and ordering, so I won't mention it
for the later patches.


>  bool addr_is_memory(phys_addr_t phys);
>  int host_stage2_idmap_locked(phys_addr_t addr, u64 size, enum kvm_pgtable_prot prot);
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> index 04a9053ae1d5..60dd56bbd743 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> @@ -267,6 +267,25 @@ static void handle___pkvm_host_unshare_guest(struct kvm_cpu_context *host_ctxt)
>         cpu_reg(host_ctxt, 1) =  ret;
>  }
>
> +static void handle___pkvm_host_relax_guest_perms(struct kvm_cpu_context *host_ctxt)
> +{
> +       DECLARE_REG(u64, gfn, host_ctxt, 1);
> +       DECLARE_REG(enum kvm_pgtable_prot, prot, host_ctxt, 2);
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
> +       ret = __pkvm_host_relax_guest_perms(gfn, prot, hyp_vcpu);
> +out:
> +       cpu_reg(host_ctxt, 1) = ret;
> +}
> +
>  static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
>  {
>         DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
> @@ -478,6 +497,7 @@ static const hcall_t host_hcall[] = {
>         HANDLE_FUNC(__pkvm_host_unshare_hyp),
>         HANDLE_FUNC(__pkvm_host_share_guest),
>         HANDLE_FUNC(__pkvm_host_unshare_guest),
> +       HANDLE_FUNC(__pkvm_host_relax_guest_perms),
>         HANDLE_FUNC(__kvm_adjust_pc),
>         HANDLE_FUNC(__kvm_vcpu_run),
>         HANDLE_FUNC(__kvm_flush_vm_context),
> diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> index aa27a3e42e5e..d4b28e93e790 100644
> --- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> +++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
> @@ -1480,3 +1480,26 @@ int __pkvm_host_unshare_guest(u64 gfn, struct pkvm_hyp_vm *hyp_vm)
>
>         return ret;
>  }
> +
> +int __pkvm_host_relax_guest_perms(u64 gfn, enum kvm_pgtable_prot prot, struct pkvm_hyp_vcpu *vcpu)
> +{
> +       struct pkvm_hyp_vm *vm = pkvm_hyp_vcpu_to_hyp_vm(vcpu);
> +       u64 ipa = hyp_pfn_to_phys(gfn);
> +       u64 phys;
> +       int ret;
> +
> +       if ((prot & KVM_PGTABLE_PROT_RWX) != prot)
> +               return -EPERM;

Why not

+       if (prot & ~KVM_PGTABLE_PROT_RWX)

Simpler and consistent with similar checks in the file (e.g.,
__pkvm_host_share_guest)

Cheers,
/fuad


> +
> +       host_lock_component();
> +       guest_lock_component(vm);
> +
> +       ret = __check_host_unshare_guest(vm, &phys, ipa);
> +       if (!ret)
> +               ret = kvm_pgtable_stage2_relax_perms(&vm->pgt, ipa, prot, 0);
> +
> +       guest_unlock_component(vm);
> +       host_unlock_component();
> +
> +       return ret;
> +}
> --
> 2.47.0.338.g60cca15819-goog
>
