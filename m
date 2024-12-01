Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6611D6DA9
	for <kvmarm@lists.linux.dev>; Sun,  1 Dec 2024 16:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733068940; cv=none; b=NWrkXX8qhGNh+MUmtupYrGt3nJCX3ClWzjk3OdboqMqbyC453WJQ2yjcBVzH20PChnXcAqBDGHNmpZ0tyLtxYVvgvs459E8BNmg9rVQ/5bmmoeGumSSOK5rLwW2YJqmk62EiETgJlPZf2KzTQzxMbDGM1gxd2rm7LKc8nRZCqb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733068940; c=relaxed/simple;
	bh=ngpU8aEJo1361PAUjYKws5935JWQaXEmFskEnt+jJ8I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VjapoM+s6EBWaC7aF91WUgCB93qYwjNvXIyqIjRiO+LDDKH9nXsJSZxxaBEFLUn1zg1eJBXTI1LoqN4Zvgo5xuRhiVKXEv0BahQI4lnlZWinhL8irSCGRCmOOt03cVz82vMqXFXcGVVplHYCb0NVV7HBctVrj6lcw9NCpFYax1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nSP/QBul; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nSP/QBul"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-434a9f9a225so176365e9.1
        for <kvmarm@lists.linux.dev>; Sun, 01 Dec 2024 08:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733068936; x=1733673736; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CZ1CESpB4fm9nTPKw9g3foXLvDoZ3jjWEbaLo3SnRIU=;
        b=nSP/QBulWvXrEScReuNVRb0DTmujiOm/YdQ7s/WIzwt+YG/kqj5KsFwq3CQ060VjYN
         KPoWbE4z/F//0qbfaWZ+hI15q7N8IR+7iw6+EMP+j2gXzOAMUMc4F2VRfF3IUHrWEEBb
         2Hjm3lNH61L3IWu2umvpXPJlp4uwI2lzjkiOqcVgbcfEPV45eyzrkEpZH2hOOVgBm/jj
         ssihZW3PJ3WaGiIURIfhau4Jt/PWe3zbFSEuxPwfryrcGX2+71h/E29mcE2X7egQsZvN
         1/k7NGu/mBlXlW9wnmsn+vK0AFB8FbFMzoRYSfEHfKC7ckkBclaw9ZaDyOrLcOxN/ClP
         Qs8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733068936; x=1733673736;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CZ1CESpB4fm9nTPKw9g3foXLvDoZ3jjWEbaLo3SnRIU=;
        b=xEk7wSvheE5Ha/Z12QY4HTNCrmSHUOdjUxnHORVHf/SxbC6vPCZ3dpx9esqE7TDhsl
         Fxp32//OLeK/623o6/hhIUHTFChuHUkEcJ9kRJJd9qDlttLrBiB9AfZ0wOop+QkcLPsu
         gZ9eC4LJFEP3w+dInx8VT4X6QI5Ujr2C5PimhXujP17nNWiAGrQ4uJbGUoD6TuruZt+n
         HkTU6avD3nbCF7hncXdqVGiA5yA/gP80HW8OBbTI2robSM5iskS4/ZuhLpC0YBIpXnAR
         Jp6pNgJ7+O67AqY5v2/RsjkSmGbNKgS96/LC2Kg+vsn1HM0PsyHSyWtLdgmWFz5/BwvU
         RbZg==
X-Gm-Message-State: AOJu0YwmYaM0SvjIDTbC5OQrZ/BRScHbCZKN7MEJL7pbVA/lyeKgmLo9
	MuN/RA2WTBewD0wS7NIgkALF+vjywsiIeb3v8MkbFv1b8+Be49izchEq4ImCWbAvcdFWO95A3KV
	RdfNL9EJh5jJW0AiOQmSSa7PmqWON1fO2Qjow
X-Gm-Gg: ASbGncsduQ7hgyaddNs871Pxjb1G4JM+3TxQ3G0r56WFqKbRXZmZXxqVBvdV907fumm
	AF7CnQdkQ6AGoLhAmGGcFHQPWZVGWVQ==
X-Google-Smtp-Source: AGHT+IGW5b1DQsiotNdqt/lX2Hk9Xn2EVhD7QZScnNyTLEOFgXrhCuq82/E84CNnzkZNrJkP2V8LMYX3xSz4yxswe1s=
X-Received: by 2002:a7b:cb92:0:b0:434:9e1d:44ef with SMTP id
 5b1f17b1804b1-434b1310e99mr3778495e9.7.1733068936174; Sun, 01 Dec 2024
 08:02:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241128123515.1709777-1-tabba@google.com> <20241128123515.1709777-15-tabba@google.com>
 <864j3nv9tk.wl-maz@kernel.org>
In-Reply-To: <864j3nv9tk.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Sun, 1 Dec 2024 16:01:39 +0000
Message-ID: <CA+EHjTyXj6NhUcxTfER=zPz3VOtd+HgqpfmyfR88cVyiXoxqwA@mail.gmail.com>
Subject: Re: [PATCH v3 14/15] KVM: arm64: Convert the SVE guest vcpu flag to a
 vm flag
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, james.clark@linaro.org, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, qperret@google.com, 
	kristina.martsenko@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,


On Sun, 1 Dec 2024 at 12:58, Marc Zyngier <maz@kernel.org> wrote:
>
> On Thu, 28 Nov 2024 12:35:14 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > The vcpu flag GUEST_HAS_SVE is per-vcpu, but it is based on what
> > is now a per-vm feature. Make the flag per-vm.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_emulate.h    |  6 +++---
> >  arch/arm64/include/asm/kvm_host.h       | 10 ++++++----
> >  arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  2 +-
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c          | 11 +++++++----
> >  arch/arm64/kvm/hyp/nvhe/switch.c        |  8 ++++----
> >  arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
> >  arch/arm64/kvm/reset.c                  |  2 +-
> >  8 files changed, 24 insertions(+), 19 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > index 406e99a452bf..ae6d0dc0e4ff 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -620,7 +620,7 @@ static __always_inline void kvm_write_cptr_el2(u64 val)
> >  }
> >
> >  /* Resets the value of cptr_el2 when returning to the host. */
> > -static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
> > +static __always_inline void kvm_reset_cptr_el2(struct kvm *kvm)
>
> I'd rather you avoid the resulting churn:
>
> static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
> {
>         struct kvm *kvm = kern_hyp_va(vcpu->kvm);
>         [...]
>
> which does the trick at zero cost. It is also more logical to keep the
> vcpu as a parameter, as the per-VM-ness is only an implementation
> detail.

The reason for the churn (here and below for vcpu_has_sve()), which in
hindsight I should have mentioned in the commit message or as a note,
is that this code is called by the host kernel (e.g., in reset.c), and
by the hypervisor). For nvhe, we need kern_hyp_va(), but not for the
host. Should I gate the va conversion with is_hyp_nvhe()?

> >  {
> >       u64 val;
> >
> > @@ -631,14 +631,14 @@ static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
> >       } else if (has_hvhe()) {
> >               val = CPACR_ELx_FPEN;
> >
> > -             if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs())
> > +             if (!kvm_has_sve(kvm) || !guest_owns_fp_regs())
> >                       val |= CPACR_ELx_ZEN;
> >               if (cpus_have_final_cap(ARM64_SME))
> >                       val |= CPACR_ELx_SMEN;
> >       } else {
> >               val = CPTR_NVHE_EL2_RES1;
> >
> > -             if (vcpu_has_sve(vcpu) && guest_owns_fp_regs())
> > +             if (kvm_has_sve(kvm) && guest_owns_fp_regs())
> >                       val |= CPTR_EL2_TZ;
> >               if (!cpus_have_final_cap(ARM64_SME))
> >                       val |= CPTR_EL2_TSM;
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index 680ecef1d7aa..c5c80c789ad0 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -331,6 +331,8 @@ struct kvm_arch {
> >  #define KVM_ARCH_FLAG_ID_REGS_INITIALIZED            7
> >       /* Fine-Grained UNDEF initialised */
> >  #define KVM_ARCH_FLAG_FGU_INITIALIZED                        8
> > +     /* SVE exposed to guest */
> > +#define KVM_ARCH_FLAG_GUEST_HAS_SVE                  9
> >       unsigned long flags;
> >
> >       /* VM-wide vCPU feature set */
> > @@ -862,8 +864,6 @@ struct kvm_vcpu_arch {
> >  #define vcpu_set_flag(v, ...)        __vcpu_set_flag((v), __VA_ARGS__)
> >  #define vcpu_clear_flag(v, ...)      __vcpu_clear_flag((v), __VA_ARGS__)
> >
> > -/* SVE exposed to guest */
> > -#define GUEST_HAS_SVE                __vcpu_single_flag(cflags, BIT(0))
> >  /* SVE config completed */
> >  #define VCPU_SVE_FINALIZED   __vcpu_single_flag(cflags, BIT(1))
> >  /* KVM_ARM_VCPU_INIT completed */
> > @@ -956,8 +956,10 @@ struct kvm_vcpu_arch {
> >                                KVM_GUESTDBG_USE_HW | \
> >                                KVM_GUESTDBG_SINGLESTEP)
> >
> > -#define vcpu_has_sve(vcpu) (system_supports_sve() &&                 \
> > -                         vcpu_get_flag(vcpu, GUEST_HAS_SVE))
> > +#define kvm_has_sve(kvm)     \
> > +     test_bit(KVM_ARCH_FLAG_GUEST_HAS_SVE, &(kvm)->arch.flags)
> > +#define vcpu_has_sve(vcpu)   \
> > +     kvm_has_sve((vcpu)->kvm)
>
> Two things:
>
> - it is definitely worth keeping the system_supports_sve() helper, so
>   that we avoid checking flags for nothing

Ack

> - Since you preserve the vcpu_has_sve(), how about writing it as:
>
> #ifdef __KVM_NVHE_HYPERVISOR__
> #define vcpu_has_sve(v)         kvm_has_sve(kern_hyp_va((v)->kvm))
> #else
> #define vcpu_has_sve(v)         kvm_has_sve((v)->kvm)
> #endif
>
>   which will avoid the churn in this patch, and makes it hard to get
>   it wrong?

Same as I mentioned above. This macro is even used in more places by
the host kernel.

Thanks,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
