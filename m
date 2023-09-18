Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDAF14AA9
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 16:54:01 +0000 (UTC)
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-34fa117f92bso1715ab.1
        for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 09:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695056041; x=1695660841; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oHHBXB7OiO4Q0/ZpersSkTeisz2ge4lrD5qNMR0qqNg=;
        b=28KQdnyR4jQYRmsupGdYYvnmYMYLvH4TmNgxofDcLfnzxhSQIIxz6aZ8CVrlrnhunq
         kkIECccA9BaV3rvAQFadtM7LzT9urAj0OxgTLVMMlXgCZlKN98loRZBjyl/vTU192vor
         kSFEHg/YZIoWS7inS8NNSdUsl3mxA5Pap27WLU2k+zwrwbxygX92RkcUZHxjzEcjDMnH
         2JhA0JRNvqtyycXDAi561z2boxY7X5EAmM8JasvMO56FZ3C3g7o4zLQsMDvuoWjriji9
         yUMYXk/63SXMnK1/UHL1qUaF0+mZMSipsXrK9ZSKbKDmLSrv69x0vT80WC4Z23J/eAlX
         qEIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695056041; x=1695660841;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oHHBXB7OiO4Q0/ZpersSkTeisz2ge4lrD5qNMR0qqNg=;
        b=eMzSwR4ZWjgb9dl6gtPydsUpspHXAk3+/D5Vn7gQ0aFnz0tzdGuO059RUUMOtBWQUa
         4i0/l/n3oXUuVLnY+/lROCXW5oYTRhC/yfrcOfMHKTe3ZymmV61NzD4a1kQcnW3ijEyz
         HxEy9KUXmhn8LPGbbFvoIYwtYqtw0HX8rkJlHexd0JeZumMlGFrFjV+wtehSL+DRCB0/
         qlWT/qWJTwnXJ1FXiCqElQMLwm7hm7UB4QlAXxc4kmdwc+dOBL0F9VegppUwnY8dAG8v
         S6As578NXpKR1/OT4Td05iXZSJNA4/wjJc3u/S6VG/hrBRC+a+MSfT7d28nYltfG3Ix7
         77Fg==
X-Gm-Message-State: AOJu0YwN2SGRkxi+azlqce5I4Mob4N/rcXTEutMSz83EmVAQQGvzuSCy
	Lm/aKzI9rUCsM11wrrpTqm8NCeqRENAAHtQJSImTzw==
X-Google-Smtp-Source: AGHT+IFKf7h1uNj8BiP8RqPjkOv3MhSdNsSVQ14+FdOeI1tARZhJZsMLggVxJqfdfJSHsDQPLgg4E6V1ESmorUtar5Y=
X-Received: by 2002:a05:6e02:1947:b0:34f:21e9:7239 with SMTP id
 x7-20020a056e02194700b0034f21e97239mr549614ilu.23.1695056040706; Mon, 18 Sep
 2023 09:54:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-6-rananta@google.com>
 <ZQS28e8b4YduMkdE@linux.dev>
In-Reply-To: <ZQS28e8b4YduMkdE@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 18 Sep 2023 09:53:48 -0700
Message-ID: <CAJHc60wisqXL52U_2852kbep8qQmDY7bnpbQJFP4pX9gR=Aarg@mail.gmail.com>
Subject: Re: [PATCH v5 05/12] KVM: arm64: PMU: Simplify extracting PMCR_EL0.N
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Fri, Sep 15, 2023 at 12:56=E2=80=AFPM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> +cc will, rutland
>
> Hi Raghu,
>
> Please make sure you cc the right folks for changes that poke multiple
> subsystems.
>
> The diff looks OK, but I'm somewhat dubious of the need for this change
> in the context of what you're trying to accomplish for KVM. I'd prefer
> we either leave the existing definition/usage intact or rework *all* of
> the PMUv3 masks to be of the shifted variety.
>
I believe the original intention was to make accessing the PMCR.N
field simple. However, if you feel its redundant and is unnecessary
for this series I'm happy to drop the patch.

Thank you.
Raghavendra
> On Thu, Aug 17, 2023 at 12:30:22AM +0000, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > Some code extracts PMCR_EL0.N using ARMV8_PMU_PMCR_N_SHIFT and
> > ARMV8_PMU_PMCR_N_MASK. Define ARMV8_PMU_PMCR_N (0x1f << 11),
> > and simplify those codes using FIELD_GET() and/or ARMV8_PMU_PMCR_N.
> > The following patches will also use these macros to extract PMCR_EL0.N.
>
> Changelog is a bit wordy:
>
>   Define a shifted mask for accessing PMCR_EL0.N amenable to the use of
>   bitfield accessors and convert the existing, open-coded mask shifts to
>   the new definition.
>
> > No functional change intended.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/pmu-emul.c      | 3 +--
> >  arch/arm64/kvm/sys_regs.c      | 7 +++----
> >  drivers/perf/arm_pmuv3.c       | 3 +--
> >  include/linux/perf/arm_pmuv3.h | 2 +-
> >  4 files changed, 6 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index b87822024828a..f7b5fa16341ad 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -245,9 +245,8 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
> >
> >  u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
> >  {
> > -     u64 val =3D __vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMU_PMCR_N_SH=
IFT;
> > +     u64 val =3D FIELD_GET(ARMV8_PMU_PMCR_N, __vcpu_sys_reg(vcpu, PMCR=
_EL0));
> >
> > -     val &=3D ARMV8_PMU_PMCR_N_MASK;
> >       if (val =3D=3D 0)
> >               return BIT(ARMV8_PMU_CYCLE_IDX);
> >       else
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 39e9248c935e7..30108f09e088b 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -750,7 +750,7 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, const =
struct sys_reg_desc *r)
> >               return 0;
> >
> >       /* Only preserve PMCR_EL0.N, and reset the rest to 0 */
> > -     pmcr =3D read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_=
PMU_PMCR_N_SHIFT);
> > +     pmcr =3D read_sysreg(pmcr_el0) & ARMV8_PMU_PMCR_N;
> >       if (!kvm_supports_32bit_el0())
> >               pmcr |=3D ARMV8_PMU_PMCR_LC;
> >
> > @@ -858,10 +858,9 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, s=
truct sys_reg_params *p,
> >
> >  static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
> >  {
> > -     u64 pmcr, val;
> > +     u64 val;
> >
> > -     pmcr =3D __vcpu_sys_reg(vcpu, PMCR_EL0);
> > -     val =3D (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
> > +     val =3D FIELD_GET(ARMV8_PMU_PMCR_N, __vcpu_sys_reg(vcpu, PMCR_EL0=
));
> >       if (idx >=3D val && idx !=3D ARMV8_PMU_CYCLE_IDX) {
> >               kvm_inject_undefined(vcpu);
> >               return false;
> > diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
> > index 08b3a1bf0ef62..7618b0adc0b8c 100644
> > --- a/drivers/perf/arm_pmuv3.c
> > +++ b/drivers/perf/arm_pmuv3.c
> > @@ -1128,8 +1128,7 @@ static void __armv8pmu_probe_pmu(void *info)
> >       probe->present =3D true;
> >
> >       /* Read the nb of CNTx counters supported from PMNC */
> > -     cpu_pmu->num_events =3D (armv8pmu_pmcr_read() >> ARMV8_PMU_PMCR_N=
_SHIFT)
> > -             & ARMV8_PMU_PMCR_N_MASK;
> > +     cpu_pmu->num_events =3D FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr=
_read());
> >
> >       /* Add the CPU cycles counter */
> >       cpu_pmu->num_events +=3D 1;
> > diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pm=
uv3.h
> > index e3899bd77f5cc..ecbcf3f93560c 100644
> > --- a/include/linux/perf/arm_pmuv3.h
> > +++ b/include/linux/perf/arm_pmuv3.h
> > @@ -216,7 +216,7 @@
> >  #define ARMV8_PMU_PMCR_LC    (1 << 6) /* Overflow on 64 bit cycle coun=
ter */
> >  #define ARMV8_PMU_PMCR_LP    (1 << 7) /* Long event counter enable */
> >  #define ARMV8_PMU_PMCR_N_SHIFT       11  /* Number of counters support=
ed */
> > -#define ARMV8_PMU_PMCR_N_MASK        0x1f
> > +#define      ARMV8_PMU_PMCR_N        (0x1f << ARMV8_PMU_PMCR_N_SHIFT)
> >  #define ARMV8_PMU_PMCR_MASK  0xff    /* Mask for writable bits */
> >
> >  /*
> > --
> > 2.41.0.694.ge786442a9b-goog
> >
> >
>
> --
> Thanks,
> Oliver
