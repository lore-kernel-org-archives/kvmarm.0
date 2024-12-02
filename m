Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51971205E28
	for <kvmarm@lists.linux.dev>; Mon,  2 Dec 2024 12:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733144305; cv=none; b=AL+5NNpMka+6zIp0veA6NGYkcWoRNMcy4+z+PCkjibq5jtuGaB2NUXyJKFe2XG/fdVYq7rWttxEvREoaIPPX9ILC7XzCHrDGhLNQE81Nq5LrXjt8RVA9TUR2XADoyiW6HMD+MseWjJJDdqFkiN56MW+Mg3XNvT0SXGQDZFtOgmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733144305; c=relaxed/simple;
	bh=KfxeECr/IEoyVbfoxOF+XRuHkALco2nrvvqeg8gvhTA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OQMaF21B7J/maw10gtxllsWXsjK3C3COS/jwu8qjBgjbyucHh7wxmsuyWTMqP+dLyNLFXQifqCl1545c4gdg6QJM46WmqGMSNW/4eP0nWkFKxOF4cfUTWaL3EToAYiAQferCkvn3aZJkZ+kWvSABOluBgLt0M1G9pAZXtNxU2tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VRUDsCKc; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VRUDsCKc"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-434a9f9a225so218935e9.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Dec 2024 04:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733144301; x=1733749101; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oT65BursDv9acFz36h76HkD1KU1Ehu2gLor/dQ9bFwQ=;
        b=VRUDsCKcownfgD8+d1ndzVdZhVUGqz1+iERoJrso34h83NSxmRu2U4MqSGzWQOYAJB
         Ff/H+kk5v9xcYlqwVVfA+DxGW1J8Od/l00VUMZ9c+MoQc9lc/oikQMrQzlsM6Pq3lRIl
         qHKtMYFt2KfuV+mSmxPY80NFQxvKpf/El414KZy0+7+LUBDTm9q1Q8CBNhWnGpBCX/z/
         ZRC9wvU4ya8pNahjU68hNe9DrJ5YODeYwRWZmargB5IV/0dWDGMG6yNHOiTZlyvg9DEf
         +7yhlzYJOjEQtZoClkcRF2pBAg0/jq5cswzf2GWWsAWWbEMh+btrejGPWQq/YL/HpkqS
         04ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733144301; x=1733749101;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oT65BursDv9acFz36h76HkD1KU1Ehu2gLor/dQ9bFwQ=;
        b=Hha11BCkuSrRAU5DJUGpcSqSF3HIWiM0PzxE75F6QsQx9YpaHxp86fSmg0jKfpCoF8
         Q1ELjV7tvLYcXWJjIjV7SKUxCBlXciOAbqQ/KqsVGJ63tOtoDfhXJ4QBO6zS/gJJwLDt
         pvu5e8TYlbp0TCnF0uflRinZGnxyfkqwasyC3G69DPaZuUSozgjICOM50T4juYk82Xkk
         wa4Sj7NCG7gghl45SCls7lPzhaMcuomRJuEFGBsAaLT0Hr4G+kZQbkIrkhWIk5+x1BXM
         fVsAvAgy3CuuY5eKybk+MRpaifHtpUEpKMe9emeaTnRMip1M3R9W7GKhuP7JobxR3UxS
         nd+w==
X-Gm-Message-State: AOJu0YzPwgDcvcp32k99fYjzmjqEQobSq79CGXQHt2/DJTYPGwlcDX+e
	jIlrW9e3KzfhcZAEVbeJRkKqdmtF5kTwNgdRof6AD8e7I1C34IVaRxnD9yY2FEi+k6fMi5MUhJO
	M8CPoWqn0WjfGqHiTWl580HBhAtAPvmsf/mAl
X-Gm-Gg: ASbGncuJMfLlFKF/cdMjwTu0GZMN8afuOk+6zOaY3vnw+GRpxh2ijRsuIJVugOfny3o
	2chW+oBoipNQCvk66pO0UKIAFejBq/g==
X-Google-Smtp-Source: AGHT+IHJJFz6JqADai1NvA0AUirrevbk29ApkBCofFsaGh6xzxfVcudD1jFv6Y77lhY2GY8LObLArRWqB58KKkJnw78=
X-Received: by 2002:a05:600c:1d0e:b0:42c:9e35:cde6 with SMTP id
 5b1f17b1804b1-434b04bfb20mr4739105e9.2.1733144301487; Mon, 02 Dec 2024
 04:58:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241128123515.1709777-1-tabba@google.com> <20241128123515.1709777-15-tabba@google.com>
 <864j3nv9tk.wl-maz@kernel.org> <CA+EHjTyXj6NhUcxTfER=zPz3VOtd+HgqpfmyfR88cVyiXoxqwA@mail.gmail.com>
In-Reply-To: <CA+EHjTyXj6NhUcxTfER=zPz3VOtd+HgqpfmyfR88cVyiXoxqwA@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Dec 2024 12:57:44 +0000
Message-ID: <CA+EHjTysFaaxGBo212e8kSHi_VkpXx6N6ddxwB0UGC6bSoK0gA@mail.gmail.com>
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

On Sun, 1 Dec 2024 at 16:01, Fuad Tabba <tabba@google.com> wrote:
>
> Hi Marc,
>
>
> On Sun, 1 Dec 2024 at 12:58, Marc Zyngier <maz@kernel.org> wrote:
> >
> > On Thu, 28 Nov 2024 12:35:14 +0000,
> > Fuad Tabba <tabba@google.com> wrote:
> > >
> > > The vcpu flag GUEST_HAS_SVE is per-vcpu, but it is based on what
> > > is now a per-vm feature. Make the flag per-vm.
> > >
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_emulate.h    |  6 +++---
> > >  arch/arm64/include/asm/kvm_host.h       | 10 ++++++----
> > >  arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
> > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  2 +-
> > >  arch/arm64/kvm/hyp/nvhe/pkvm.c          | 11 +++++++----
> > >  arch/arm64/kvm/hyp/nvhe/switch.c        |  8 ++++----
> > >  arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
> > >  arch/arm64/kvm/reset.c                  |  2 +-
> > >  8 files changed, 24 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > > index 406e99a452bf..ae6d0dc0e4ff 100644
> > > --- a/arch/arm64/include/asm/kvm_emulate.h
> > > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > > @@ -620,7 +620,7 @@ static __always_inline void kvm_write_cptr_el2(u64 val)
> > >  }
> > >
> > >  /* Resets the value of cptr_el2 when returning to the host. */
> > > -static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
> > > +static __always_inline void kvm_reset_cptr_el2(struct kvm *kvm)
> >
> > I'd rather you avoid the resulting churn:
> >
> > static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
> > {
> >         struct kvm *kvm = kern_hyp_va(vcpu->kvm);
> >         [...]
> >
> > which does the trick at zero cost. It is also more logical to keep the
> > vcpu as a parameter, as the per-VM-ness is only an implementation
> > detail.
>
> The reason for the churn (here and below for vcpu_has_sve()), which in
> hindsight I should have mentioned in the commit message or as a note,
> is that this code is called by the host kernel (e.g., in reset.c), and
> by the hypervisor). For nvhe, we need kern_hyp_va(), but not for the
> host. Should I gate the va conversion with is_hyp_nvhe()?

I spoke too soon. Your suggestion results in less churn, and of
course, solves the issue I had with kern_hyp_va.

I did have to convert kvm_reset_cptr_el2() into a macro, because it
now needs kern_hyp_va(), defined in kvm_mmu.h, which in turn includes
kvm_emulate.h. But since it's __always_inline, it shouldn't make any
difference in practice.

If this conversion to a macro is alright by you, I'll respin this.

Thanks again, and sorry for the noise.
/fuad

>
> > >  {
> > >       u64 val;
> > >
> > > @@ -631,14 +631,14 @@ static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
> > >       } else if (has_hvhe()) {
> > >               val = CPACR_ELx_FPEN;
> > >
> > > -             if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs())
> > > +             if (!kvm_has_sve(kvm) || !guest_owns_fp_regs())
> > >                       val |= CPACR_ELx_ZEN;
> > >               if (cpus_have_final_cap(ARM64_SME))
> > >                       val |= CPACR_ELx_SMEN;
> > >       } else {
> > >               val = CPTR_NVHE_EL2_RES1;
> > >
> > > -             if (vcpu_has_sve(vcpu) && guest_owns_fp_regs())
> > > +             if (kvm_has_sve(kvm) && guest_owns_fp_regs())
> > >                       val |= CPTR_EL2_TZ;
> > >               if (!cpus_have_final_cap(ARM64_SME))
> > >                       val |= CPTR_EL2_TSM;
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > index 680ecef1d7aa..c5c80c789ad0 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -331,6 +331,8 @@ struct kvm_arch {
> > >  #define KVM_ARCH_FLAG_ID_REGS_INITIALIZED            7
> > >       /* Fine-Grained UNDEF initialised */
> > >  #define KVM_ARCH_FLAG_FGU_INITIALIZED                        8
> > > +     /* SVE exposed to guest */
> > > +#define KVM_ARCH_FLAG_GUEST_HAS_SVE                  9
> > >       unsigned long flags;
> > >
> > >       /* VM-wide vCPU feature set */
> > > @@ -862,8 +864,6 @@ struct kvm_vcpu_arch {
> > >  #define vcpu_set_flag(v, ...)        __vcpu_set_flag((v), __VA_ARGS__)
> > >  #define vcpu_clear_flag(v, ...)      __vcpu_clear_flag((v), __VA_ARGS__)
> > >
> > > -/* SVE exposed to guest */
> > > -#define GUEST_HAS_SVE                __vcpu_single_flag(cflags, BIT(0))
> > >  /* SVE config completed */
> > >  #define VCPU_SVE_FINALIZED   __vcpu_single_flag(cflags, BIT(1))
> > >  /* KVM_ARM_VCPU_INIT completed */
> > > @@ -956,8 +956,10 @@ struct kvm_vcpu_arch {
> > >                                KVM_GUESTDBG_USE_HW | \
> > >                                KVM_GUESTDBG_SINGLESTEP)
> > >
> > > -#define vcpu_has_sve(vcpu) (system_supports_sve() &&                 \
> > > -                         vcpu_get_flag(vcpu, GUEST_HAS_SVE))
> > > +#define kvm_has_sve(kvm)     \
> > > +     test_bit(KVM_ARCH_FLAG_GUEST_HAS_SVE, &(kvm)->arch.flags)
> > > +#define vcpu_has_sve(vcpu)   \
> > > +     kvm_has_sve((vcpu)->kvm)
> >
> > Two things:
> >
> > - it is definitely worth keeping the system_supports_sve() helper, so
> >   that we avoid checking flags for nothing
>
> Ack
>
> > - Since you preserve the vcpu_has_sve(), how about writing it as:
> >
> > #ifdef __KVM_NVHE_HYPERVISOR__
> > #define vcpu_has_sve(v)         kvm_has_sve(kern_hyp_va((v)->kvm))
> > #else
> > #define vcpu_has_sve(v)         kvm_has_sve((v)->kvm)
> > #endif
> >
> >   which will avoid the churn in this patch, and makes it hard to get
> >   it wrong?
>
> Same as I mentioned above. This macro is even used in more places by
> the host kernel.
>
> Thanks,
> /fuad
>
> > Thanks,
> >
> >         M.
> >
> > --
> > Without deviation from the norm, progress is not possible.
