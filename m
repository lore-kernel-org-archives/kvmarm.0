Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACA0C2EC
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 09:20:18 +0000 (UTC)
Received: by mail-lj1-f176.google.com with SMTP id q14so18898746ljm.11
        for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 02:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680168016; x=1682760016;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+gJXQnvpOUTO45W9NA/nvCLejMrE+YZtgbjw8d7LVn8=;
        b=YCqJ5SegIp1K4GEzUpXEopx+TIrzM10n/ziuoNMTzgLTuDqRa9TK5Qy3wPprjXgGQy
         L8AmaNjiwersgns7nGudUJlDCLKS7wFPiGvnGf5mCl93l3c6x7JsG8xSChDIUqNiWku6
         qv/nmHAMJFlZAc1wOUKEW1A27LombGz9R7/2C5S/UJhyey0yulgl81kmwj0ijMC3fuAU
         Ili7o/3Swbd/QovfX6w/S6CNGkXlevmNL4dMjZLCyq0EvrUnfE2M+PurMiuaAnG4HiS5
         LLWQwR22iBs7fnglhEuybltzB+RKX+g/cipJw9h7DGZ/LRglP/gFdKyk5Zb6tRsn4VQW
         OuIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680168016; x=1682760016;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+gJXQnvpOUTO45W9NA/nvCLejMrE+YZtgbjw8d7LVn8=;
        b=ETJAe2iiMUDgNBttJgkNMfHTy6dp6L7gxifRxCZUVlj5+jCn9UpH68QOogVbwRooW6
         x2Fpp+G35zb21vO1CO/H0MDMXps+qt0Bp68Z0MgKLuZDFVtlBDMka3GWRk9i+JhqxFWh
         ROsAlXK+ij0lTqpH8iqw6RFt+4PJ3nlhf3j3yZGz2xrNLYvll1V7carmlGooTTE2RT+s
         axyeKe1+f90TkMpiVXwWXBdLG3It4g3qkTAaOlkgZ/nNu0QVSb9m+BggqSrY0aZM2DxT
         4wKejuXtvR2Q0ocePou/Z+Yo7BhgPAe2NXFEKaY0KmVBfMKeWr/+2dTtogB6uJ8hIec1
         4FNQ==
X-Gm-Message-State: AAQBX9c6s18zBxu1C23BG9UeDJyZ2WQdyPPkm8dUYYnfxtiHknzGAUqe
	+u8UNmP51LaLU41Z9+TsyO8eL7iPVt2YiNpjAWoZxA==
X-Google-Smtp-Source: AKy350akt7tTJBT/MQILtJHqXw8MGlDgkXlJlr8tXkrW5YnBfZNJFYdrSw7Du+5IGUPQ7ys0oRH5nZ00jHjdi7vyIJI=
X-Received: by 2002:a05:651c:10e:b0:295:a82e:ec06 with SMTP id
 a14-20020a05651c010e00b00295a82eec06mr6838294ljb.3.1680168016127; Thu, 30 Mar
 2023 02:20:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230329121526.1168242-1-tabba@google.com> <86ilejwv0s.wl-maz@kernel.org>
In-Reply-To: <86ilejwv0s.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 30 Mar 2023 10:19:39 +0100
Message-ID: <CA+EHjTxt2xxBJvR1HY504VAN1SU-qoVE-aFaYQ2SVgAeuqGW7Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, oupton@google.com, will@kernel.org, 
	pbonzini@redhat.com, james.morse@arm.com, alexandru.elisei@arm.com, 
	suzuki.poulose@arm.com, reijiw@google.com, ricarkol@google.com, 
	rananta@google.com, jingzhangos@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Wed, Mar 29, 2023 at 2:24=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Wed, 29 Mar 2023 13:15:26 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > The existing pKVM code attempts to do that using a value that's
> > initialized to 0 but never set. To advertise csv2/3 to a
> > protected guest, store them at the hypervisor and use them for
> > setting csv2/3.
> >
> > Similar to non-protected KVM, these are tracked as a system-wide
> > variable, rather than per cpu, for simplicity.
> >
> > Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System =
Registers")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_hyp.h   |  3 +++
> >  arch/arm64/kvm/arm.c               |  2 ++
> >  arch/arm64/kvm/hyp/nvhe/sys_regs.c | 15 ++++++++++++---
> >  3 files changed, 17 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/=
kvm_hyp.h
> > index bdd9cf546d95..723a645af191 100644
> > --- a/arch/arm64/include/asm/kvm_hyp.h
> > +++ b/arch/arm64/include/asm/kvm_hyp.h
> > @@ -127,4 +127,7 @@ extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
> >  extern unsigned long kvm_nvhe_sym(__icache_flags);
> >  extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
> >
> > +extern bool kvm_nvhe_sym(spectre_unaffected);
> > +extern bool kvm_nvhe_sym(meltdown_unaffected);
> > +
> >  #endif /* __ARM64_KVM_HYP_H__ */
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 3bd732eaf087..364a4440ae54 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1902,6 +1902,8 @@ static void kvm_hyp_init_symbols(void)
> >       kvm_nvhe_sym(id_aa64smfr0_el1_sys_val) =3D read_sanitised_ftr_reg=
(SYS_ID_AA64SMFR0_EL1);
> >       kvm_nvhe_sym(__icache_flags) =3D __icache_flags;
> >       kvm_nvhe_sym(kvm_arm_vmid_bits) =3D kvm_arm_vmid_bits;
> > +     kvm_nvhe_sym(spectre_unaffected) =3D (arm64_get_spectre_v2_state(=
) =3D=3D SPECTRE_UNAFFECTED);
> > +     kvm_nvhe_sym(meltdown_unaffected) =3D (arm64_get_meltdown_state()=
 =3D=3D SPECTRE_UNAFFECTED);
> >  }
> >
> >  static int __init kvm_hyp_init_protection(u32 hyp_va_bits)
> > diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nv=
he/sys_regs.c
> > index 08d2b004f4b7..3f647a2f4c96 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
> > @@ -28,6 +28,16 @@ u64 id_aa64mmfr1_el1_sys_val;
> >  u64 id_aa64mmfr2_el1_sys_val;
> >  u64 id_aa64smfr0_el1_sys_val;
> >
> > +/*
> > + * Track whether the system isn't affected by spectre/meltown.
> > + * Although this is per-CPU, we make it global for simplicity, e.g., n=
ot to have
> > + * to worry about migration.
> > + *
> > + * Unlike for non-protected VMs, userspace cannot override this.
> > + */
> > +bool spectre_unaffected;
> > +bool meltdown_unaffected;
> > +
> >  /*
> >   * Inject an unknown/undefined exception to an AArch64 guest while mos=
t of its
> >   * sysregs are live.
> > @@ -85,7 +95,6 @@ static u64 get_restricted_features_unsigned(u64 sys_r=
eg_val,
> >
> >  static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
> >  {
> > -     const struct kvm *kvm =3D (const struct kvm *)kern_hyp_va(vcpu->k=
vm);
> >       u64 set_mask =3D 0;
> >       u64 allow_mask =3D PVM_ID_AA64PFR0_ALLOW;
> >
> > @@ -94,9 +103,9 @@ static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu=
 *vcpu)
> >
> >       /* Spectre and Meltdown mitigation in KVM */
> >       set_mask |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2)=
,
> > -                            (u64)kvm->arch.pfr0_csv2);
> > +                            spectre_unaffected);
> >       set_mask |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3)=
,
> > -                            (u64)kvm->arch.pfr0_csv3);
> > +                            meltdown_unaffected);
>
> Since you already have a sanitised version of ID_AA64PFR0_EL1, it
> would seem more straightforward to directly perform this adjustment at
> the point where you export the value, rather than doing it at runtime.

That makes more sense, and results in cleaner code. I'll do that.
>
> Ideally, the proton-pack code would perform the update and set the
> sanitised values directly in the cpufeature repository, but this would
> involve me looking at it again, and I really don't want to do that.

You won't have to :) I'll post v2 soon.

Thanks!
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
