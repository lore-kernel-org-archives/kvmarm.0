Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19AA042907
	for <kvmarm@lists.linux.dev>; Wed, 18 Oct 2023 21:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kOmBjWFn"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1c9b70b9671so18875ad.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Oct 2023 14:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697663808; x=1698268608; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZXQl4FJeerso8xaHvPc0My2Nlc3lIxYNlXOld63T454=;
        b=kOmBjWFnZbb5zw2Ub5iAP1Ky/aog7x4un1VGOk7iQH/6261YBNGpb973HQK74qdCiL
         mj1vGgXQj4BdCI5FRqrKUYYQrcXytpFEIyN19i1OpiXbaE8lacdFjI+wFjdz09WFkWUM
         4/84Eo4UYFa0irDsNCtoBKKVD7EB35eQT0/hiy/hCndqHQalve8sYW6NmOgKTW0QhmRB
         UnLMml4z2/pRcuMgY1qtXv2Cz7tOkc6MNBSYCsGM2jB1pG8JoXwgApbfj1A+4lH5P+zq
         SLsF/FVucccEy042jX6mCLdvBzber5wnYlnXIX/IrMIGGy9JQserVp11qLxlKMCfkJYe
         lI+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697663808; x=1698268608;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZXQl4FJeerso8xaHvPc0My2Nlc3lIxYNlXOld63T454=;
        b=GZxLsfrBHoNyaop6NgwKajTF75wZE8l/W3htozTTNyEAb8Lm8fIl9/gWeNykF2zgXV
         afUQM1fKXD4AmtmuT/u6ZmFdd1lqyAVWmyuxbLNYnqA50QScc+r6/IaiY4oAcCmrd3D+
         z8LwE5zxi2gKhiygXGnavg8T5Pk57ZLtv4hn4jZHS2hYiRcEdhlilxdmc/wOScsA2QFP
         Od/KhXmvzS2gPFuJOEhqPDVZSdYXM1D1aArQLUUxlivx0ESGw1pTZCh/OwBHzu/1KT3q
         mMrT7bpOCTf3bzLHIbi2GohKYtiOq7ocYoEBYc06HV9gQb/PXANoUr9n1fFiodfXV2Kr
         +EAA==
X-Gm-Message-State: AOJu0Yxo/RQJulnYgaggz0c+ucvewHTrXIA2LS65ThBk1HqVLtLletTe
	G+44F5HY7STPlc7ZBOna2GwFWAVPbUQY2k1FEWQhXg==
X-Google-Smtp-Source: AGHT+IFzKplRYoJdUaTdcUCowK6L66Ecq0Itp8rFun8vs+Mg/TDUC2gIcoUvRR2muiumjzezn7dhjMM5tw6RhMP1Prg=
X-Received: by 2002:a17:903:138a:b0:1c1:f658:7d05 with SMTP id
 jx10-20020a170903138a00b001c1f6587d05mr80341plb.18.1697663808064; Wed, 18 Oct
 2023 14:16:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-4-rananta@google.com>
 <53546f35-f2cc-4c75-171c-26719550f7df@redhat.com> <CAJHc60wYyfsJPiFEyLYLyv9femNzDUXy+xFaGx59=2HrUGScyw@mail.gmail.com>
 <34959db4-01e9-8c1e-110e-c52701e2fb19@redhat.com> <CAJHc60xc1dM_d4W+hOOnM5+DceF45htTfrbmdv=Q4vPf8T04Ow@mail.gmail.com>
In-Reply-To: <CAJHc60xc1dM_d4W+hOOnM5+DceF45htTfrbmdv=Q4vPf8T04Ow@mail.gmail.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Wed, 18 Oct 2023 14:16:36 -0700
Message-ID: <CAJHc60yr5U+sxSAaZipei_4TNaU0_EAWKLG8cr+5v_Z1WYRMuw@mail.gmail.com>
Subject: Re: [PATCH v7 03/12] KVM: arm64: PMU: Clear PM{C,I}NTEN{SET,CLR} and
 PMOVS{SET,CLR} on vCPU reset
To: Eric Auger <eauger@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Colton Lewis <coltonlewis@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 17, 2023 at 9:59=E2=80=AFAM Raghavendra Rao Ananta
<rananta@google.com> wrote:
>
> Hi Eric,
> On Tue, Oct 17, 2023 at 2:23=E2=80=AFAM Eric Auger <eauger@redhat.com> wr=
ote:
> >
> > Hi,
> > On 10/16/23 23:28, Raghavendra Rao Ananta wrote:
> > > On Mon, Oct 16, 2023 at 12:45=E2=80=AFPM Eric Auger <eauger@redhat.co=
m> wrote:
> > >>
> > >> Hi Raghavendra,
> > >>
> > >> On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> > >>> From: Reiji Watanabe <reijiw@google.com>
> > >>>
> > >>> On vCPU reset, PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
> > >>> PMOVS{SET,CLR}_EL1 for a vCPU are reset by reset_pmu_reg().
> > >> PMOVS{SET,CLR}_EL0?
> > > Ah, yes. It should be PMOVS{SET,CLR}_EL0.
> > >
> > >>> This function clears RAZ bits of those registers corresponding
> > >>> to unimplemented event counters on the vCPU, and sets bits
> > >>> corresponding to implemented event counters to a predefined
> > >>> pseudo UNKNOWN value (some bits are set to 1).
> > >>>
> > >>> The function identifies (un)implemented event counters on the
> > >>> vCPU based on the PMCR_EL0.N value on the host. Using the host
> > >>> value for this would be problematic when KVM supports letting
> > >>> userspace set PMCR_EL0.N to a value different from the host value
> > >>> (some of the RAZ bits of those registers could end up being set to =
1).
> > >>>
> > >>> Fix this by clearing the registers so that it can ensure
> > >>> that all the RAZ bits are cleared even when the PMCR_EL0.N value
> > >>> for the vCPU is different from the host value. Use reset_val() to
> > >>> do this instead of fixing reset_pmu_reg(), and remove
> > >>> reset_pmu_reg(), as it is no longer used.
> > >> do you intend to restore the 'unknown' behavior at some point?
> > >>
> > > I believe Reiji's (original author) intention was to keep them
> > > cleared, which would still imply an 'unknown' behavior. Do you think
> > > there's an issue with this?
> > Then why do we bother using reset_unknown in the other places if
> > clearing the bits is enough here?
> >
> Hmm. Good point. I can bring back reset_unknown to keep the original beha=
vior.
>
I had a brief discussion about this with Oliver, and it looks like we
might need a couple of additional changes for these register accesses:
- For the userspace accesses, we have to implement explicit get_user
and set_user callbacks that to filter out the unimplemented counters
using kvm_pmu_valid_counter_mask().
- For the guest accesses to be correct, we might have to apply the
same mask while serving KVM_REQ_RELOAD_PMU.

Thank you.
Raghavendra

> Thank you.
> Raghavendra
> > Thanks
> >
> > Eric
> > >
> > > Thank you.
> > > Raghavendra
> > >> Thanks
> > >>
> > >> Eric
> > >>>
> > >>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > >>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > >>> ---
> > >>>  arch/arm64/kvm/sys_regs.c | 21 +--------------------
> > >>>  1 file changed, 1 insertion(+), 20 deletions(-)
> > >>>
> > >>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > >>> index 818a52e257ed..3dbb7d276b0e 100644
> > >>> --- a/arch/arm64/kvm/sys_regs.c
> > >>> +++ b/arch/arm64/kvm/sys_regs.c
> > >>> @@ -717,25 +717,6 @@ static unsigned int pmu_visibility(const struc=
t kvm_vcpu *vcpu,
> > >>>       return REG_HIDDEN;
> > >>>  }
> > >>>
> > >>> -static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_r=
eg_desc *r)
> > >>> -{
> > >>> -     u64 n, mask =3D BIT(ARMV8_PMU_CYCLE_IDX);
> > >>> -
> > >>> -     /* No PMU available, any PMU reg may UNDEF... */
> > >>> -     if (!kvm_arm_support_pmu_v3())
> > >>> -             return 0;
> > >>> -
> > >>> -     n =3D read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
> > >>> -     n &=3D ARMV8_PMU_PMCR_N_MASK;
> > >>> -     if (n)
> > >>> -             mask |=3D GENMASK(n - 1, 0);
> > >>> -
> > >>> -     reset_unknown(vcpu, r);
> > >>> -     __vcpu_sys_reg(vcpu, r->reg) &=3D mask;
> > >>> -
> > >>> -     return __vcpu_sys_reg(vcpu, r->reg);
> > >>> -}
> > >>> -
> > >>>  static u64 reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_=
reg_desc *r)
> > >>>  {
> > >>>       reset_unknown(vcpu, r);
> > >>> @@ -1115,7 +1096,7 @@ static bool access_pmuserenr(struct kvm_vcpu =
*vcpu, struct sys_reg_params *p,
> > >>>         trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
> > >>>
> > >>>  #define PMU_SYS_REG(name)                                         =
   \
> > >>> -     SYS_DESC(SYS_##name), .reset =3D reset_pmu_reg,              =
     \
> > >>> +     SYS_DESC(SYS_##name), .reset =3D reset_val,                  =
     \
> > >>>       .visibility =3D pmu_visibility
> > >>>
> > >>>  /* Macro to expand the PMEVCNTRn_EL0 register */
> > >>
> > >
> >
