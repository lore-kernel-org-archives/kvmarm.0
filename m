Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE5C2770A
	for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 21:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AXAAZOZd"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1c9c145bb5bso22585ad.1
        for <kvmarm@lists.linux.dev>; Mon, 16 Oct 2023 14:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697491751; x=1698096551; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AFn29vyvgA1T7ugFUC1SqB09r0OPYYGNgXPaVYLCKMU=;
        b=AXAAZOZdBHl3FX5wXvTYwGQwg4YBVblVVrAm+0ILbIb/lFYWDOWEfAtQLq/gH9I6wa
         D89i657PqE8Rol0H6yjy3M3St4OLZx5Jmz97taB4HCJFkTH8/hBiglTwVNfRjIkw/syb
         DkpgN/+B0P1ZK+nx+gD7yRg7MTj+msPaHliFHu+FRsy01H2LBttBw4qghSO3JY8GjuvO
         b25VTCAyWeNzac6j28sb2y8nAIHA5YNTi+4WGW81IZQc/UEpZPnmWRt8J9c4vt65t1Ra
         6IAyj4V8qFBarcz5PzWhUpJWII2P+hSvhaR6/COe9bdjcMQdVwWLLTOUo7VYp6uSiEyw
         /t+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697491751; x=1698096551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AFn29vyvgA1T7ugFUC1SqB09r0OPYYGNgXPaVYLCKMU=;
        b=mrdfLJla5GQ//YSN052dFqico5rciNWlDgar5RDQ3fJ6v3ZrQDS0QA+IIWLru2AEy3
         CjRL8o9SrbWLW+R7eYjhTqlIHL3EkfmKgV2rcgnuRI0mcwIafxmeYJJl9oStNgpJ+nwA
         03KmjtOP75L6dls2wGWQ92s6FfYfurmdtLeVkphX+Ho5emqGjcSEIXplEE941n+6eSX2
         DZRhX4dDqPLyFNKDFBEsJrOdWFWP+aH70MaWE2T5Cgyx24F0srz0hPiiYd+4Sz6E9v/q
         LrjaRDJBW6P0snBgOjg3+czFUizLQszGrJmpoonVmnZyrBzOYk3IldQyFKPJfaf77I+F
         JyYQ==
X-Gm-Message-State: AOJu0Yz6vW17b/TzMfVjj3yuqXB5du7tPo7B4X+XCybyuDszl4hhyGi1
	1tZQXJ2DB/aDarMtPEXiOXP2v6m5fcxdO5GA/R+mRw==
X-Google-Smtp-Source: AGHT+IFsGl+8wNrA/ks0sS6VjqWheVjAe9z1hr9ReqDQIpul5xTW2Yy7iep+rQKRrsQYLhY6pzJauQHVj9HrMBR78ss=
X-Received: by 2002:a17:903:28d:b0:1c5:ca8d:136b with SMTP id
 j13-20020a170903028d00b001c5ca8d136bmr71796plr.14.1697491750564; Mon, 16 Oct
 2023 14:29:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-4-rananta@google.com>
 <53546f35-f2cc-4c75-171c-26719550f7df@redhat.com>
In-Reply-To: <53546f35-f2cc-4c75-171c-26719550f7df@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 16 Oct 2023 14:28:58 -0700
Message-ID: <CAJHc60wYyfsJPiFEyLYLyv9femNzDUXy+xFaGx59=2HrUGScyw@mail.gmail.com>
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

On Mon, Oct 16, 2023 at 12:45=E2=80=AFPM Eric Auger <eauger@redhat.com> wro=
te:
>
> Hi Raghavendra,
>
> On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > On vCPU reset, PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
> > PMOVS{SET,CLR}_EL1 for a vCPU are reset by reset_pmu_reg().
> PMOVS{SET,CLR}_EL0?
Ah, yes. It should be PMOVS{SET,CLR}_EL0.

> > This function clears RAZ bits of those registers corresponding
> > to unimplemented event counters on the vCPU, and sets bits
> > corresponding to implemented event counters to a predefined
> > pseudo UNKNOWN value (some bits are set to 1).
> >
> > The function identifies (un)implemented event counters on the
> > vCPU based on the PMCR_EL0.N value on the host. Using the host
> > value for this would be problematic when KVM supports letting
> > userspace set PMCR_EL0.N to a value different from the host value
> > (some of the RAZ bits of those registers could end up being set to 1).
> >
> > Fix this by clearing the registers so that it can ensure
> > that all the RAZ bits are cleared even when the PMCR_EL0.N value
> > for the vCPU is different from the host value. Use reset_val() to
> > do this instead of fixing reset_pmu_reg(), and remove
> > reset_pmu_reg(), as it is no longer used.
> do you intend to restore the 'unknown' behavior at some point?
>
I believe Reiji's (original author) intention was to keep them
cleared, which would still imply an 'unknown' behavior. Do you think
there's an issue with this?

Thank you.
Raghavendra
> Thanks
>
> Eric
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 21 +--------------------
> >  1 file changed, 1 insertion(+), 20 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 818a52e257ed..3dbb7d276b0e 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -717,25 +717,6 @@ static unsigned int pmu_visibility(const struct kv=
m_vcpu *vcpu,
> >       return REG_HIDDEN;
> >  }
> >
> > -static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_d=
esc *r)
> > -{
> > -     u64 n, mask =3D BIT(ARMV8_PMU_CYCLE_IDX);
> > -
> > -     /* No PMU available, any PMU reg may UNDEF... */
> > -     if (!kvm_arm_support_pmu_v3())
> > -             return 0;
> > -
> > -     n =3D read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
> > -     n &=3D ARMV8_PMU_PMCR_N_MASK;
> > -     if (n)
> > -             mask |=3D GENMASK(n - 1, 0);
> > -
> > -     reset_unknown(vcpu, r);
> > -     __vcpu_sys_reg(vcpu, r->reg) &=3D mask;
> > -
> > -     return __vcpu_sys_reg(vcpu, r->reg);
> > -}
> > -
> >  static u64 reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_=
desc *r)
> >  {
> >       reset_unknown(vcpu, r);
> > @@ -1115,7 +1096,7 @@ static bool access_pmuserenr(struct kvm_vcpu *vcp=
u, struct sys_reg_params *p,
> >         trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
> >
> >  #define PMU_SYS_REG(name)                                            \
> > -     SYS_DESC(SYS_##name), .reset =3D reset_pmu_reg,                  =
 \
> > +     SYS_DESC(SYS_##name), .reset =3D reset_val,                      =
 \
> >       .visibility =3D pmu_visibility
> >
> >  /* Macro to expand the PMEVCNTRn_EL0 register */
>
