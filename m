Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA331FF7A8
	for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 15:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731424342; cv=none; b=pcwfSKdwfIQnYkHpuSZ/nbri7ewEkaTenp5DVBkk3pyQ9Ealr4xIvYdvFDz9UIaxE20ncjJgyDVpwP4QsWnST7E0QNFP1F9fx+LaZDNU7S4zvMr7+UasgLoDUFIY6hflLV3WDGK4Fq+2bKM+Qg1AbAAjCAuN993zwy4mekURC8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731424342; c=relaxed/simple;
	bh=9wF6tTg205YmPGn3VOm3qDqUJhPIhge8PfjW0tNtfVA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r3IxS4XVqjf+HxeVHsr+vMjYgon2Qs9P1LJczdJUHN+nPWO+T5NRMFgFOrVPnqSF7gvwtaKbXoi1xwYVOYNYtEhFQs8Mlo8dTXwWFOskvIyWMqDWm1hRxbmQai6RYqr+ke5C4wJSjv3qpbGD35Zlneliitq6H7SlfXRGoRkMEoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J2uZu4KH; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J2uZu4KH"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4315ee633dcso126245e9.1
        for <kvmarm@lists.linux.dev>; Tue, 12 Nov 2024 07:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731424339; x=1732029139; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AZJf54hz7xE0bBIr2JsyytkNQasf60PHx9P3JAB4nkQ=;
        b=J2uZu4KH5RSbxxecUciQSOxCib0tY+LXMktzOjV/1MjKp3xVLoZpBpsh6DgWmy2+6A
         /6e5In9fQVtHYx/el93fO0tcZuDClRN7kR3+RwtDoU1wUv3U/6t8YlWaRvxG0Lg4l3de
         xkIZC6tg/fvxaV0uHyBvJKRc2cJ7uXfd5tCp8suMkaG1vkMiMgEub8sUFgljJ2MhPeIi
         8FJ96sN1XlgWT1L+RK0wD3mjzcaBlFHOgt/z84IowKmBEvsaZhPh7JLdfcG7LDm2d5I1
         6E4Qd+qyz1KxA9l4GTtcxBDQGwojL/dg5rdLmK4CCAK3gIGB//xXYX47gTgmyDia+t1h
         gKdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731424339; x=1732029139;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AZJf54hz7xE0bBIr2JsyytkNQasf60PHx9P3JAB4nkQ=;
        b=Va+i/SsCYSbdwSKmTLW8se7hHXThTepVcEjq+7vF4PKX6OGhmLPVXNEZMz6Od616WU
         qU42/MrNXL8+zQDOLroDkl6yhJA58C9veBmfZdc70TLzaJDft2YBev/fpQHQ4rGwYzFx
         LrmsQT3059xYg4RNDNVGDH84pJKoGgn30wyBocht6Adpkxv3EZ2emkICocKW3jUTScG3
         CxHPqZ+/qIfDqGpXsP910HaXSOHP1X6ITpEITfGOxMWVPekH7WO3+b2K3vRGMxFpaWTl
         0q3iywwDhdSpqWF1gkhjr33jN6u9g0+DLmV09+OGCsX+UQVvBrMmOYof/vT5Yg81IImh
         XsMA==
X-Forwarded-Encrypted: i=1; AJvYcCWdIqMb+WPBzf+ZHyJ6+vxyfdrLBRqPxmPEbRSWwx3RTyzxiUlPttsMSgVVhouDsfEZ2FDtOjs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzC2b3CqHi2e/4ijdkpJfwArxVFh0URdF/zjrjQtrMh6yu8kVP1
	pTOSDiv4uRbWvuZt7XcFIklPq/xMPlTUuzikPnKPXUZ7UJaHxTzgABUNCzP4AFIhVk4MA582wAe
	+f9rvd3/AiqtSBeu1345ZEht1i+/1mYEXbEcB
X-Gm-Gg: ASbGnctFYLSGq1UcS7zlAObGRrlGubBr+c7AiDurDWi2l0UG/xLivLRwYnoCudToQxI
	UazuLxTJEBC53rOpWtuBxyj+apac9dDJg3/7u+a13RAYDbkVpmrbubIPWI4gS
X-Google-Smtp-Source: AGHT+IFh1KG/4r/Jpj1n/ObwJscWvvtlsw0RsVTQkd1D68bpc9mkzBX4Z2VDq640KrO3IpXCu88faLISFm3MEsJl7tM=
X-Received: by 2002:a05:600c:1395:b0:431:43a1:4cac with SMTP id
 5b1f17b1804b1-432cf0fbec4mr2190145e9.3.1731424338902; Tue, 12 Nov 2024
 07:12:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241112105032.793274-1-james.clark@linaro.org> <875xosts24.wl-maz@kernel.org>
In-Reply-To: <875xosts24.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 12 Nov 2024 15:11:42 +0000
Message-ID: <CA+EHjTyqunj19TLcaSp5DacRNWDsh-OpdRjpFOJfp0t8CBGEUw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Don't save FP traps in default cptr_el2 value
To: Marc Zyngier <maz@kernel.org>
Cc: James Clark <james.clark@linaro.org>, broonie@kernel.org, kvmarm@lists.linux.dev, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc and James,

On Tue, 12 Nov 2024 at 15:01, Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 12 Nov 2024 10:50:31 +0000,
> James Clark <james.clark@linaro.org> wrote:
> >
> > kvm_get_reset_cptr_el2() is called at vcpu init before the vcpu is
> > loaded. Since the linked commit, the fp state was moved from the vcpu to
> > host data but it shouldn't be accessed at this point.
> >
> > Move the bits that require guest_owns_fp_regs() out of the default value
> > and into just before they're used in activate and deactivate traps. This
> > fixes the following bug when nvhe && vcpu_has_sve() == true:
> >
> >  BUG: using smp_processor_id() in preemptible [00000000] code: lkvm/118
> >  caller is debug_smp_processor_id+0x20/0x30
> >  CPU: 0 UID: 0 PID: 118 Comm: lkvm Not tainted 6.12.0-rc1+ #35
> >  Hardware name: FVP Base RevC (DT)
> >  Call trace:
> >   dump_backtrace+0xfc/0x120
> >   show_stack+0x24/0x38
> >   dump_stack_lvl+0x3c/0x98
> >   dump_stack+0x18/0x28
> >   check_preemption_disabled+0xe0/0xe8
> >   debug_smp_processor_id+0x20/0x30
> >   guest_owns_fp_regs+0x1c/0xb0
> >   kvm_arch_vcpu_ioctl+0xcfc/0xe10
> >   kvm_vcpu_ioctl+0x6c4/0x8a0
> >   __arm64_sys_ioctl+0x9c/0xe0
> >   invoke_syscall+0x4c/0x110
> >   el0_svc_common+0xb8/0xf0
> >   do_el0_svc+0x28/0x40
> >   el0_svc+0x4c/0xc0
> >   el0t_64_sync_handler+0x84/0x100
> >   el0t_64_sync+0x190/0x198
> >
> > Fixes: 5294afdbf45a ("KVM: arm64: Exclude FP ownership from kvm_vcpu_arch")
> > Signed-off-by: James Clark <james.clark@linaro.org>
> > ---
> >
> > I'm only mildly confident that the logic here is equivalent to before.
> > Someone with a bit more context about the FP stuff can say, or if there
> > is a neater way to fix this issue altogether.
> >
> >  arch/arm64/include/asm/kvm_emulate.h | 15 +++++++++------
> >  arch/arm64/kvm/hyp/nvhe/switch.c     |  3 ++-
> >  2 files changed, 11 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> > index cf811009a33c..0eefb9fb08a0 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -629,16 +629,12 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
> >                       val |= CPACR_EL1_SMEN_EL1EN;
> >       } else if (has_hvhe()) {
> >               val = CPACR_ELx_FPEN;
> > -
> > -             if (!vcpu_has_sve(vcpu) || !guest_owns_fp_regs())
> > +             if (!vcpu_has_sve(vcpu))
> >                       val |= CPACR_ELx_ZEN;
> >               if (cpus_have_final_cap(ARM64_SME))
> >                       val |= CPACR_ELx_SMEN;
> >       } else {
> >               val = CPTR_NVHE_EL2_RES1;
> > -
> > -             if (vcpu_has_sve(vcpu) && guest_owns_fp_regs())
> > -                     val |= CPTR_EL2_TZ;
> >               if (cpus_have_final_cap(ARM64_SME))
> >                       val &= ~CPTR_EL2_TSM;
> >       }
> > @@ -648,8 +644,15 @@ static __always_inline u64 kvm_get_reset_cptr_el2(struct kvm_vcpu *vcpu)
> >
> >  static __always_inline void kvm_reset_cptr_el2(struct kvm_vcpu *vcpu)
> >  {
> > -     u64 val = kvm_get_reset_cptr_el2(vcpu);
> > +     u64 val = vcpu->arch.cptr_el2;
> >
> > +     if (has_hvhe()) {
> > +             if (!guest_owns_fp_regs())
> > +                     val |= CPACR_ELx_ZEN;
> > +     } else if (!has_vhe()) {
> > +             if (vcpu_has_sve(vcpu) && guest_owns_fp_regs())
> > +                     val |= CPTR_EL2_TZ;
> > +     }
> >       kvm_write_cptr_el2(val);
> >  }
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
> > index cc69106734ca..296c4155e1fc 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -60,7 +60,8 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
> >                       val |= CPTR_EL2_TFP | CPTR_EL2_TZ;
> >
> >               __activate_traps_fpsimd32(vcpu);
> > -     }
> > +     } else if (!has_hvhe() && vcpu_has_sve(vcpu))
> > +             val |= CPTR_EL2_TZ;
> >
> >       kvm_write_cptr_el2(val);
> >       write_sysreg(__this_cpu_read(kvm_hyp_vector), vbar_el2);
>
> I think this is papering over the real issue, which is that we
> conflate reset value for the host and what is required for the guest
> to run.
>
> CPTR_EL2 is state-dependent, as you found out. And that really only
> means one single thing: it cannot be initialised outside of the vcpu
> being either loaded or run, both of which require being in a
> non-preemptible section.
>
> There is also another thing: VHE rebuilds the guest's CPTR_EL2 view
> from scratch, while the nVHE takes the saved state, mutates it in
> funny ways before applying it, and pKVM does all sorts of interesting
> manipulations before hitting the nVHE code.
>
> What I would really like to see is:
>
> - when entering the guest, we recompute the run-time value of CPTR_EL2
>   from scratch, just like VHE does.
>
> - when exiting the guest, we reset the value using the current helper,
>   which takes the guest state into account.
>
> - pKVM should be converted to using the plain nVHE code.
>
> - vcpu->arch.cptr_el2 should be killed.
>
> I think Fuad has already started on some of that. Fuad, do you mind
> adding that to your current rework and post something shortly?

Yes, this is a bit of a mess currently. I've been reworking it as part
of the work on pKVM. I'll post something shortly that will make it
more inline with how VHE handles this.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
