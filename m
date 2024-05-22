Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42421208A4
	for <kvmarm@lists.linux.dev>; Wed, 22 May 2024 14:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716389360; cv=none; b=fssAMA+RKJXWmWBFJdkQ3qGaNPH+SG21ogiO6ohaTh5FsRvR4mZDly2Ocm5FCWHqlGFZqiq3wXu0RhVzp2ieXNQU3obt77fpl3rkHlK9LN+Io8XS70Sf0c8lG/2KYsROHXr+SSdv6lnGR/N+ivGiEHrMrOwpwoa5P9PsDZYEWh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716389360; c=relaxed/simple;
	bh=lt+DaUCWS/LT6T+mjtGH0kyfNisSRPwRjoK1Y0XFQHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q4nadhsft5caP2Ri+JWgUaInYKL0pz+SZ1g3a4gL5z5PoOqF1VJZheAJaKERM/fJzHfzrTXi3c1E5Rtnbql1vviNIvXBHNes9IU5rUK3N0ktA+JSL4wbfi2mFPi0euuDuA/8Qm2fS5lTHyebR6QkM4v3a0gTSkmtP2vw0H5DbIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2nYDjo9v; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2nYDjo9v"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-7f3aee7c531so316769241.0
        for <kvmarm@lists.linux.dev>; Wed, 22 May 2024 07:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716389357; x=1716994157; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QGKd9eVSG+eS1JvakJcbFoHy6iD/Q7N5MqLfWISbj1A=;
        b=2nYDjo9vg2RGV8PgmYvQLTIPm6kXGXKv9bkMeX03/3tbiAgv4UO/1+4l8kEAaNTrpv
         Z1jVEZPjSQs4WaHEcpC8BdMwxie3txXcsV1hTToq40iB7Rr0TGyh8ntGhIw6bJ+HjVV2
         mYWF572Yodx9ee///v/DeojNnbBfvlMzesAEwKfgTrRDxfjERW0jvEpBhYFQiCw4x00y
         kAOD/Yhk4TfiOu+AYdawk9AHoeHzup6TSAfxTgSj6dYKO2GCP3ebLmEFEX+nprKZe7Aw
         LXo5K69g1e3K1QB1veymQ/M/gRHgFVPIdFFDyV7r93Q0xOc+NwJqQnYYVD95xDvFX/xx
         1vow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716389357; x=1716994157;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QGKd9eVSG+eS1JvakJcbFoHy6iD/Q7N5MqLfWISbj1A=;
        b=PwD4+t854Zcw9jIBk/5AeasxIcGVZ8JdwZRJ+K7Mkj6ZeP+4t1Im9qVeq3z7EmyCU4
         KpIZrkmTzCxb0xBobqeYcQ7EEzkJaDcT0SpK8fzPpDy5KWvrad3wOikOq71GJ3DQxpOZ
         Y4ehKCLDLxNXiU/71v0jAPIaaMnZJTKrKUw93lzy+mUe9YwPa6msUtePL756DZ42EuiJ
         JjlKAOUt0By4KfPEgzuO9CRyG2OvwgzPXrW3itRv25d/5nPm6/RGemgAHxnaJdLjm5Xj
         jYbKLSp2dx7ZaKQHSiwG5J7Oabae5hHU5ERgu6wGzeDcxe+5JAicQsPWCF6af7osTdxS
         uv+g==
X-Gm-Message-State: AOJu0YwEe3xFdWO9wegm5InKNiApHcBCBjfMUss4tKTgZj06T2hLMLQE
	n0TCaE3ptFlsJpHFt1qo1NzL5qjk0AlAt3aqNM30QrIwEN+e2HMyiwxOWNJY1rmg6rMTQqQ32Ln
	REbPpmBAMxOPfBMfHdNvXG14ukggL2LXITbJI
X-Google-Smtp-Source: AGHT+IGlIrn4G9a90tMAsKM4fvr1vytW/08Sa+lUQydxhaX8eXjj7jYP4cP5iQ9EqtltsBLvRXGWYHahmr5/6N9cnWQ=
X-Received: by 2002:a05:6102:54a1:b0:47e:f8c0:c453 with SMTP id
 ada2fe7eead31-48900975fc0mr2258548137.19.1716389356882; Wed, 22 May 2024
 07:49:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240521163720.3812851-1-tabba@google.com> <20240521163720.3812851-7-tabba@google.com>
 <86o78yn5ga.wl-maz@kernel.org>
In-Reply-To: <86o78yn5ga.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 22 May 2024 15:48:39 +0100
Message-ID: <CA+EHjTzUSnFpcTzBYt5fvoDAKAMNnvW4MY_9JQdoJUpwfC=Nuw@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] KVM: arm64: Eagerly restore host fpsimd/sve state
 in pKVM
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	will@kernel.org, qperret@google.com, seanjc@google.com, 
	alexandru.elisei@arm.com, catalin.marinas@arm.com, philmd@linaro.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, 
	mark.rutland@arm.com, broonie@kernel.org, joey.gouly@arm.com, 
	rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Tue, May 21, 2024 at 11:52=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Tue, 21 May 2024 17:37:19 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > When running in protected mode we don't want to leak protected
> > guest state to the host, including whether a guest has used
> > fpsimd/sve. Therefore, eagerly restore the host state on guest
> > exit when running in protected mode, which happens only if the
> > guest has used fpsimd/sve.
> >
> > As a future optimisation, we could go back to lazy restoring
> > state at the host after exiting non-protected guests.
>
> No. This sort of things is way too invasive and would require mapping
> the VHE host data at EL2. If we need to optimise this crap, then we
> apply the same techniques as we use for guests. If that's good enough
> for the guests, that's good enough for the host.

:D

> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 13 +++++-
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c      | 53 +++++++++++++++++++++++--
> >  arch/arm64/kvm/hyp/nvhe/pkvm.c          |  2 +
> >  arch/arm64/kvm/hyp/nvhe/switch.c        | 16 +++++++-
> >  4 files changed, 79 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/h=
yp/include/hyp/switch.h
> > index 1897b73e635c..2fa29bfec0b6 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -320,6 +320,16 @@ static inline void __hyp_sve_restore_guest(struct =
kvm_vcpu *vcpu)
> >       write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
> >  }
> >
> > +static inline void __hyp_sve_save_host(void)
> > +{
> > +     struct user_sve_state *sve_state =3D *host_data_ptr(sve_state);
> > +
> > +     sve_state->zcr_el1 =3D read_sysreg_el1(SYS_ZCR);
> > +     sve_cond_update_zcr_vq(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
> > +     __sve_save_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sv=
e_max_vl),
> > +                      &sve_state->fpsr);
> > +}
> > +
> >  static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu);
> >
> >  /*
> > @@ -356,7 +366,8 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *=
vcpu, u64 *exit_code)
> >
> >       /* First disable enough traps to allow us to update the registers=
 */
> >       reg =3D CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_EL1EN;
> > -     if (sve_guest)
> > +     if (sve_guest ||
> > +         (is_protected_kvm_enabled() && system_supports_sve()))
>
> This looks really ugly. Why can't we just compute sve_guest to take
> these conditions into account?

Because this is just for disabling the SVE traps, which we would need
to do even in the case where the guest doesn't support SVE in order to
be able to store the host sve state.

sve_guest is also used later in the function to determine whether we
need to restore the guest's sve state, and earlier to determine
whether an SVE trap from a non-sve guest should result in injecting an
undef instruction.

That said, maybe the following is a bit less ugly?

    if (sve_guest || (is_protected_kvm_enabled() && system_supports_sve()))
        cpacr_clear_set(0, CPACR_ELx_FPEN|CPACR_ELx_ZEN);
    else
        cpacr_clear_set(0, CPACR_ELx_FPEN);

>
> >               reg |=3D CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1EN;
> >       cpacr_clear_set(0, reg);
> >       isb();
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index b07d44484f42..f79f0f7b2759 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -23,20 +23,66 @@ DEFINE_PER_CPU(struct kvm_nvhe_init_params, kvm_ini=
t_params);
> >
> >  void __kvm_hyp_host_forward_smc(struct kvm_cpu_context *host_ctxt);
> >
> > +static void __hyp_sve_save_guest(struct kvm_vcpu *vcpu)
> > +{
> > +     __vcpu_sys_reg(vcpu, ZCR_EL1) =3D read_sysreg_el1(SYS_ZCR);
> > +     sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
> > +     __sve_save_state(vcpu_sve_pffr(vcpu), &vcpu->arch.ctxt.fp_regs.fp=
sr);
> > +     sve_cond_update_zcr_vq(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
> > +}
> > +
> > +static void __hyp_sve_restore_host(void)
> > +{
> > +     struct user_sve_state *sve_state =3D *host_data_ptr(sve_state);
> > +
> > +     sve_cond_update_zcr_vq(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
> > +     __sve_restore_state(sve_state->sve_regs + sve_ffr_offset(kvm_host=
_sve_max_vl),
>
> This is what I was worried about in a previous patch.
> kvm_host_sve_max_vl represents the max VL across all CPUs. if CPU0
> supports 128bit SVE and CPU1 256bit, the value is 256. but on CPU0,
> ZCR_ELx_LEN_MASK will results in using 128bit accesses, and the offset
> will be wrong. I can't convince myself that anything really goes wrong
> as long as we're consistent between save and restore, but that's at
> best ugly and needs extensive documenting.

As I mentioned in my reply to the previous patch, I _think_ that it
represents the maximum common VL across CPUs. Since the value comes
from vl_info.vq_map, which is calculated by filtering out all the VQs
not supported.

In kvm_arch_vcpu_put_fp(), we always assume the maximum VL supported
by the guest, regardless of which cpu this happens to be running on.
That said, there's a comment there outlining that. I'll add a comment
here to document it.

> On top of that, a conditional update of ZCR_EL2 with ZCR_ELx_LEN_MASK
> is unlikely to be beneficial, since nobody implements 2k vectors. A
> direct write followed by an ISB is likely to be better.

Will do.

> > +                         &sve_state->fpsr);
> > +     write_sysreg_el1(sve_state->zcr_el1, SYS_ZCR);
> > +}
> > +
> > +static void fpsimd_sve_flush(void)
> > +{
> > +     *host_data_ptr(fp_owner) =3D FP_STATE_HOST_OWNED;
> > +}
> > +
> > +static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
> > +{
> > +     if (!guest_owns_fp_regs())
> > +             return;
> > +
> > +     cpacr_clear_set(0, (CPACR_EL1_ZEN_EL1EN | CPACR_EL1_ZEN_EL0EN |
> > +                         CPACR_EL1_FPEN_EL1EN | CPACR_EL1_FPEN_EL0EN))=
;
> > +     isb();
> > +
> > +     if (vcpu_has_sve(vcpu))
> > +             __hyp_sve_save_guest(vcpu);
> > +     else
> > +             __fpsimd_save_state(&vcpu->arch.ctxt.fp_regs);
> > +
> > +     if (system_supports_sve())
> > +             __hyp_sve_restore_host();
> > +     else
> > +             __fpsimd_restore_state(*host_data_ptr(fpsimd_state));
> > +
> > +     *host_data_ptr(fp_owner) =3D FP_STATE_HOST_OWNED;
> > +}
> > +
> >  static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
> >  {
> >       struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> >
> > +     fpsimd_sve_flush();
> > +
> >       hyp_vcpu->vcpu.arch.ctxt        =3D host_vcpu->arch.ctxt;
> >
> >       hyp_vcpu->vcpu.arch.sve_state   =3D kern_hyp_va(host_vcpu->arch.s=
ve_state);
> > -     hyp_vcpu->vcpu.arch.sve_max_vl  =3D host_vcpu->arch.sve_max_vl;
> > +     hyp_vcpu->vcpu.arch.sve_max_vl  =3D min(host_vcpu->arch.sve_max_v=
l, kvm_host_sve_max_vl);
> >
> >       hyp_vcpu->vcpu.arch.hw_mmu      =3D host_vcpu->arch.hw_mmu;
> >
> >       hyp_vcpu->vcpu.arch.hcr_el2     =3D host_vcpu->arch.hcr_el2;
> >       hyp_vcpu->vcpu.arch.mdcr_el2    =3D host_vcpu->arch.mdcr_el2;
> > -     hyp_vcpu->vcpu.arch.cptr_el2    =3D host_vcpu->arch.cptr_el2;
> >
> >       hyp_vcpu->vcpu.arch.iflags      =3D host_vcpu->arch.iflags;
> >
> > @@ -54,10 +100,11 @@ static void sync_hyp_vcpu(struct pkvm_hyp_vcpu *hy=
p_vcpu)
> >       struct vgic_v3_cpu_if *host_cpu_if =3D &host_vcpu->arch.vgic_cpu.=
vgic_v3;
> >       unsigned int i;
> >
> > +     fpsimd_sve_sync(&hyp_vcpu->vcpu);
> > +
> >       host_vcpu->arch.ctxt            =3D hyp_vcpu->vcpu.arch.ctxt;
> >
> >       host_vcpu->arch.hcr_el2         =3D hyp_vcpu->vcpu.arch.hcr_el2;
> > -     host_vcpu->arch.cptr_el2        =3D hyp_vcpu->vcpu.arch.cptr_el2;
> >
> >       host_vcpu->arch.fault           =3D hyp_vcpu->vcpu.arch.fault;
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/p=
kvm.c
> > index 25e9a94f6d76..feb27b4ce459 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > @@ -588,6 +588,8 @@ int __pkvm_init_vcpu(pkvm_handle_t handle, struct k=
vm_vcpu *host_vcpu,
> >       if (ret)
> >               unmap_donated_memory(hyp_vcpu, sizeof(*hyp_vcpu));
> >
> > +     hyp_vcpu->vcpu.arch.cptr_el2 =3D kvm_get_reset_cptr_el2(&hyp_vcpu=
->vcpu);
> > +
>
> Eventually, we need to rename this to cpacr_el2 and make sure we
> consistently use the VHE format everywhere. I'm starting to be worried
> that we mix things badly.

Would you like me to do that in this patch series, or should I submit
another one after this that does this cleanup?

> >       return ret;
> >  }
> >
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe=
/switch.c
> > index 019f863922fa..5bf437682b94 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -184,7 +184,21 @@ static bool kvm_handle_pvm_sys64(struct kvm_vcpu *=
vcpu, u64 *exit_code)
> >
> >  static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
> >  {
> > -     __fpsimd_save_state(*host_data_ptr(fpsimd_state));
> > +     /*
> > +      * Non-protected kvm relies on the host restoring its sve state.
> > +      * Protected kvm restores the host's sve state as not to reveal t=
hat
> > +      * fpsimd was used by a guest nor leak upper sve bits.
> > +      */
> > +     if (unlikely(is_protected_kvm_enabled() && system_supports_sve())=
) {
> > +             __hyp_sve_save_host();
> > +
> > +             /* Re-enable SVE traps if not supported for the guest vcp=
u. */
> > +             if (!vcpu_has_sve(vcpu))
> > +                     cpacr_clear_set(CPACR_EL1_ZEN_EL0EN | CPACR_EL1_Z=
EN_EL1EN, 0);
> > +
>
> nit: spurious new line

Ack.

Thank you!


/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
