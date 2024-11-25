Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41089139D0A
	for <kvmarm@lists.linux.dev>; Mon, 25 Nov 2024 11:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732535978; cv=none; b=TPShQyNmDg1Yi1y6mQEqEfrnVJ6TOAW7DsQbXbAzZF64i3H6yLfyw8FkKhfQ2AfgN+BK4cMZOMAOV4l7/NOCuQ+Q1H1vCIp6rIh0ZEwatfwiqNNd5SR4DZvYMs3V+7rvSBUCMy8mix8KwocTLzE8Z7glDOFAuZMdOI5V0OGkUf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732535978; c=relaxed/simple;
	bh=sWEZis+HllN8xXiRngEweTCgeMy41PlLQZdIDo3zYxs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YZ+X8tlVqimmEPa76coDhPw6yzs37nfsg/HJen/jxYb+G9Ebjg6QtToTWsTolyYRyGgM37LJnrnOdhdwdscom1tAhtvy5h4rDd9RKSAeQAoxBQzd2Abl+0hEnkGPj3SjzjOhxxK8QJCF9Tj6umXL712/xs/YI7frvWRzQrN7/10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cMhsUu1I; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cMhsUu1I"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4349c7b6b0dso52865e9.1
        for <kvmarm@lists.linux.dev>; Mon, 25 Nov 2024 03:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732535974; x=1733140774; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ww3YlZzRzljXfiIGG34NOz7jVp5FZwnBv4kjnYFxh18=;
        b=cMhsUu1Ioj2Q08ocglqB91INrt0PCHd0TNhLmWsofCpBY/0je8QG8XV/10iqQEFxDD
         xGR9RfC0yKRujogyPdlwOpH6F/nlhZg0P9NjOAEE9kw3xXRzQrj3+XXBOyPnKqKV/Xvk
         zdt/JPJsY1mhv3YIMP4BG4BNHunxlndNh5urqhRunlV6x57AIgPf1921s7GvZdV6BUqn
         5RSsjtQKAMctP7GuvLo6TJ5gn7bzKuVMwUyrg0W2p/Bkq5ASDxFLGwD0JKAJrBqMh06y
         Fa9HJBoD1a+ixtby5siYWnyH5GEVkdx9l9HrvCjHD5X5yLj4CnfwasyJd3HghcB4+9eT
         nwpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732535974; x=1733140774;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ww3YlZzRzljXfiIGG34NOz7jVp5FZwnBv4kjnYFxh18=;
        b=FSwwbe2UeulixT9F1T8wsqZn0sRmaPNAT7de+kHkXJPdbKYtrmnoB+CbXNyg+dYSHt
         fesiBxz/n2fZAj1ou5ynTaODoY5xcZV7Y7wiYwXnycXRJqgaZoZ7S5UYMBja4zH0SpQZ
         btJAg1eyyeDit+9RwppHB9/I0bOagP/gil+Yqfb7sL7q19+YcYANGttOl69LCs7efjwv
         ql1Z8W84hyNb8Zqmh4cW25fLILH4o61ijs0Z3mQUPqQK7rcLIeF7NqumQWRLLVgOEpbs
         u3ni9tJOQA0+CML4YqlxRxQudDKEQJ4zRfHurjrIwReAwAPTvTdb7ZRubqndJtqtsBoD
         s+fg==
X-Gm-Message-State: AOJu0YzBag4mEz0nTc8qn1qGokzxwN2R6Y7DaIeKIzvBW2h5UperT1Kh
	I5qBiN1++eMQxdIu3v+scFSogY3aVFlL8wq3Hb5XT+gB4Uhmwcij1EXE8gBcYUuloQ2dcrxNKBS
	lm5AxBSYRmsP3LrMqpYD9qr8miLOfxSfaxVAW
X-Gm-Gg: ASbGncu2taAaBhMJXCsNQO4cv2zyviY173Y8C/5vLR1dLMg7l/Q1HS9myDzKTNJsa3C
	SJK/8HQZNixxAFe+Mu7ykkyphhScWXg==
X-Google-Smtp-Source: AGHT+IGu8CTtX0DwI9l42eo6hCR0G+gNVNebSmIzHE1Pb7TY8/8FCpvE/ag1zS55FnP4k8HK+qQSBBiN0gPZJz3+WEg=
X-Received: by 2002:a05:600c:5248:b0:431:43a1:4cac with SMTP id
 5b1f17b1804b1-4348c991304mr2570645e9.3.1732535974462; Mon, 25 Nov 2024
 03:59:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241122110622.3010118-1-tabba@google.com> <20241122110622.3010118-6-tabba@google.com>
 <86ldx8vni5.wl-maz@kernel.org>
In-Reply-To: <86ldx8vni5.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 25 Nov 2024 11:58:58 +0000
Message-ID: <CA+EHjTyEOgedbeiaiNKSxxE9CNaSWLh4nQONMem+bgbrxnkCZA@mail.gmail.com>
Subject: Re: [PATCH v2 05/12] KVM: arm64: Initialize feature id registers for
 protected VMs
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	oliver.upton@linux.dev, james.clark@linaro.org, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Sun, 24 Nov 2024 at 12:12, Marc Zyngier <maz@kernel.org> wrote:
>
> On Fri, 22 Nov 2024 11:06:15 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > The hypervisor maintains the state of protected VMs. Initialize
> > the values for feature ID registers for protected VMs, to be used
> > when setting traps and when advertising features to protected
> > VMs.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  .../arm64/kvm/hyp/include/nvhe/fixed_config.h |  1 +
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c                |  4 ++
> >  arch/arm64/kvm/hyp/nvhe/sys_regs.c            | 54 +++++++++++++++++--
> >  3 files changed, 56 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
> > index d1e59b88ff66..69e26d1a0ebe 100644
> > --- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
> > +++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
> > @@ -201,6 +201,7 @@
> >  u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
> >  bool kvm_handle_pvm_sysreg(struct kvm_vcpu *vcpu, u64 *exit_code);
> >  bool kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu, u64 *exit_code);
> > +void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu);
> >  int kvm_check_pvm_sysreg_table(void);
> >
> >  #endif /* __ARM64_KVM_FIXED_CONFIG_H__ */
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > index 59ff6aac514c..4ef03294b2b4 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -381,6 +381,7 @@ static void init_pkvm_hyp_vm(struct kvm *host_kvm, struct pkvm_hyp_vm *hyp_vm,
> >       hyp_vm->kvm.created_vcpus = nr_vcpus;
> >       hyp_vm->kvm.arch.mmu.vtcr = host_mmu.arch.mmu.vtcr;
> >       hyp_vm->kvm.arch.pkvm.enabled = READ_ONCE(host_kvm->arch.pkvm.enabled);
> > +     hyp_vm->kvm.arch.flags = 0;
> >       pkvm_init_features_from_host(hyp_vm, host_kvm);
> >  }
> >
> > @@ -419,6 +420,9 @@ static int init_pkvm_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu,
> >       hyp_vcpu->vcpu.arch.cflags = READ_ONCE(host_vcpu->arch.cflags);
> >       hyp_vcpu->vcpu.arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
> >
> > +     if (pkvm_hyp_vcpu_is_protected(hyp_vcpu))
> > +             kvm_init_pvm_id_regs(&hyp_vcpu->vcpu);
> > +
> >       ret = pkvm_vcpu_init_traps(hyp_vcpu);
> >       if (ret)
> >               goto done;
> > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > index 59fb2f056177..7008e9641f41 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > @@ -204,8 +204,7 @@ static u64 get_pvm_id_aa64mmfr2(const struct kvm_vcpu *vcpu)
> >       return id_aa64mmfr2_el1_sys_val & PVM_ID_AA64MMFR2_ALLOW;
> >  }
> >
> > -/* Read a sanitized cpufeature ID register by its encoding */
> > -u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> > +static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> >  {
> >       switch (id) {
> >       case SYS_ID_AA64PFR0_EL1:
> > @@ -240,10 +239,25 @@ u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> >       }
> >  }
> >
> > +/* Read a sanitized cpufeature ID register by its encoding */
> > +u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id)
> > +{
> > +     return pvm_calc_id_reg(vcpu, id);
> > +}
> > +
>
> Whatever reason you have to keep this per-CPU, it really needs to
> change to be VM-scoped. Maybe not immediately, but that should be on
> your list.

Ack.

> >  static u64 read_id_reg(const struct kvm_vcpu *vcpu,
> >                      struct sys_reg_desc const *r)
> >  {
> > -     return pvm_read_id_reg(vcpu, reg_to_encoding(r));
> > +     struct kvm *kvm = vcpu->kvm;
> > +     u32 reg = reg_to_encoding(r);
> > +
> > +     if (WARN_ON_ONCE(!test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags)))
> > +             return 0;
> > +
> > +     if (reg >= sys_reg(3, 0, 0, 4, 0) && reg <= sys_reg(3, 0, 0, 7, 7))
> > +             return kvm->arch.id_regs[IDREG_IDX(reg)];
>
> Why the limit to the AA64 idregs? Aren't the other shadow sysreg
> values correctly initialised to 0?

Yes they are. Will expand this to cover those too.


> > +
> > +     return 0;
> >  }
> >
> >  /* Handler to RAZ/WI sysregs */
> > @@ -448,6 +462,40 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
> >       /* Performance Monitoring Registers are restricted. */
> >  };
> >
> > +/*
> > + * Initializes feature registers for protected vms.
> > + */
> > +void kvm_init_pvm_id_regs(struct kvm_vcpu *vcpu)
> > +{
> > +     const u32 pvm_feat_id_regs[] = {
>
> static?

Yes, and see below.

> > +             SYS_ID_AA64PFR0_EL1,
> > +             SYS_ID_AA64PFR1_EL1,
> > +             SYS_ID_AA64ISAR0_EL1,
> > +             SYS_ID_AA64ISAR1_EL1,
> > +             SYS_ID_AA64ISAR2_EL1,
> > +             SYS_ID_AA64ZFR0_EL1,
> > +             SYS_ID_AA64MMFR0_EL1,
> > +             SYS_ID_AA64MMFR1_EL1,
> > +             SYS_ID_AA64MMFR2_EL1,
> > +             SYS_ID_AA64MMFR4_EL1,
> > +             SYS_ID_AA64DFR0_EL1,
> > +     };
> > +     struct kvm *kvm = vcpu->kvm;
> > +     unsigned long i;
> > +
> > +     if (WARN_ON_ONCE(test_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags)))
> > +             return;
> > +
> > +     for (i = 0; i < ARRAY_SIZE(pvm_feat_id_regs); i++) {
>
> But do you really need this array? Can't you just iterate over the
> idreg space and compute the value? Sure, that'd be a bit longer, but
> at least you would define the idregs you care about in a single place.

Like you said, I was trying to save a couple of cycles, but I'll
change it as you suggest.

> > +             struct kvm_arch *ka = &kvm->arch;
> > +             u32 reg = pvm_feat_id_regs[i];
> > +
> > +             ka->id_regs[IDREG_IDX(reg)] = pvm_calc_id_reg(vcpu, reg);
> > +     }
> > +
> > +     set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
> > +}
> > +
> >  /*
> >   * Checks that the sysreg table is unique and in-order.
> >   *
>
> Thanks,

Thank you!


/fuad

>         M.
>
> --
> Without deviation from the norm, progress is not possible.
