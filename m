Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0E62D03D
	for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 16:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3fygzlDv"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1c9c496c114so5615ad.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Oct 2023 09:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697561992; x=1698166792; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5yMNU4rPFpkkiYfIDqG4Wx36aOJ+fPY9zqBtHEee9ps=;
        b=3fygzlDvtwk10pl7rCCOkYQ7btJvw7/0XEP6I2G3l2Az4uAF3gtklsbdu7yC+JaudB
         ktKrsJTsDypDY9ZtgBYQGeHWxvA7POUc1Yduu5hmw/IRLjCzjVld3FG6yGrHzwQ7Ggim
         v97dkF8mhzFop7JpJd23Vw138X1eLdsIIGoFnJB1Jjf/ooXNJv0A5Ww8z5MCn0YVHQ7v
         wEovqkPehIh9Fk+4mIFG4iCwLROuzUCcq5kiL2FBzWbS78dCG7q+zA5Z1HQpnPwvQG+5
         vYl4jJoONojPH+0Ea4ISZg0wgth6urGXyQxXnleYXpXpNoTxdeQrv82cz05m/zSO07/R
         FGVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697561992; x=1698166792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5yMNU4rPFpkkiYfIDqG4Wx36aOJ+fPY9zqBtHEee9ps=;
        b=WrgBBn8Rc5psUMSy6clKf+RWbbdW/3614N1f2BqJeg/EECbdNu03Rs3WOcqPiRoNya
         3w3N1o+Z/rA9iV4ao58lmItU5A/EeBcWBIducqYQ9ktThD7mtiUhOelOxK79bZSQSC2f
         pa6qHvDbIG4HUb+aTJXTPhDDvyzbGZn5kdc/e7IOK0tnkWRX7ojx6qlyEE5RfeZ3ReaV
         T74DlQ6vdOjLA3lHXe9Ax80FawRomlvRA0Ex0BEPRF2Zz/Q5wGldPrm3RM9gk3MI4AFz
         Hl1I8KZsHf5Z5EMXLmLHheaGonm4IwXoaSCJte2RnFekDYKuNR4zM8HpJjnPV0faYWSy
         7UrQ==
X-Gm-Message-State: AOJu0YyoeQOOLM+gVeZe7nE85UcOVFOy0zAs81HE/5IleDEAku2Aq6Ex
	Cey+U0QPi5wuz70lOnmYHNY8khd3cCIhwbN+24XgDQ==
X-Google-Smtp-Source: AGHT+IEwRmI28DmtYEWCZFKuGUo5CoFAqIKSbqXw7iZ5appdMW5bDM7BRVBP4wf/lwdI59wdYM4cFsO+Yk5Xpfh0Cd0=
X-Received: by 2002:a17:902:9b98:b0:1c7:1fbc:b9e8 with SMTP id
 y24-20020a1709029b9800b001c71fbcb9e8mr10033plp.10.1697561991580; Tue, 17 Oct
 2023 09:59:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-4-rananta@google.com>
 <53546f35-f2cc-4c75-171c-26719550f7df@redhat.com> <CAJHc60wYyfsJPiFEyLYLyv9femNzDUXy+xFaGx59=2HrUGScyw@mail.gmail.com>
 <34959db4-01e9-8c1e-110e-c52701e2fb19@redhat.com>
In-Reply-To: <34959db4-01e9-8c1e-110e-c52701e2fb19@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 17 Oct 2023 09:59:39 -0700
Message-ID: <CAJHc60xc1dM_d4W+hOOnM5+DceF45htTfrbmdv=Q4vPf8T04Ow@mail.gmail.com>
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

Hi Eric,
On Tue, Oct 17, 2023 at 2:23=E2=80=AFAM Eric Auger <eauger@redhat.com> wrot=
e:
>
> Hi,
> On 10/16/23 23:28, Raghavendra Rao Ananta wrote:
> > On Mon, Oct 16, 2023 at 12:45=E2=80=AFPM Eric Auger <eauger@redhat.com>=
 wrote:
> >>
> >> Hi Raghavendra,
> >>
> >> On 10/10/23 01:08, Raghavendra Rao Ananta wrote:
> >>> From: Reiji Watanabe <reijiw@google.com>
> >>>
> >>> On vCPU reset, PMCNTEN{SET,CLR}_EL0, PMINTEN{SET,CLR}_EL1, and
> >>> PMOVS{SET,CLR}_EL1 for a vCPU are reset by reset_pmu_reg().
> >> PMOVS{SET,CLR}_EL0?
> > Ah, yes. It should be PMOVS{SET,CLR}_EL0.
> >
> >>> This function clears RAZ bits of those registers corresponding
> >>> to unimplemented event counters on the vCPU, and sets bits
> >>> corresponding to implemented event counters to a predefined
> >>> pseudo UNKNOWN value (some bits are set to 1).
> >>>
> >>> The function identifies (un)implemented event counters on the
> >>> vCPU based on the PMCR_EL0.N value on the host. Using the host
> >>> value for this would be problematic when KVM supports letting
> >>> userspace set PMCR_EL0.N to a value different from the host value
> >>> (some of the RAZ bits of those registers could end up being set to 1)=
.
> >>>
> >>> Fix this by clearing the registers so that it can ensure
> >>> that all the RAZ bits are cleared even when the PMCR_EL0.N value
> >>> for the vCPU is different from the host value. Use reset_val() to
> >>> do this instead of fixing reset_pmu_reg(), and remove
> >>> reset_pmu_reg(), as it is no longer used.
> >> do you intend to restore the 'unknown' behavior at some point?
> >>
> > I believe Reiji's (original author) intention was to keep them
> > cleared, which would still imply an 'unknown' behavior. Do you think
> > there's an issue with this?
> Then why do we bother using reset_unknown in the other places if
> clearing the bits is enough here?
>
Hmm. Good point. I can bring back reset_unknown to keep the original behavi=
or.

Thank you.
Raghavendra
> Thanks
>
> Eric
> >
> > Thank you.
> > Raghavendra
> >> Thanks
> >>
> >> Eric
> >>>
> >>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> >>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> >>> ---
> >>>  arch/arm64/kvm/sys_regs.c | 21 +--------------------
> >>>  1 file changed, 1 insertion(+), 20 deletions(-)
> >>>
> >>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> >>> index 818a52e257ed..3dbb7d276b0e 100644
> >>> --- a/arch/arm64/kvm/sys_regs.c
> >>> +++ b/arch/arm64/kvm/sys_regs.c
> >>> @@ -717,25 +717,6 @@ static unsigned int pmu_visibility(const struct =
kvm_vcpu *vcpu,
> >>>       return REG_HIDDEN;
> >>>  }
> >>>
> >>> -static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg=
_desc *r)
> >>> -{
> >>> -     u64 n, mask =3D BIT(ARMV8_PMU_CYCLE_IDX);
> >>> -
> >>> -     /* No PMU available, any PMU reg may UNDEF... */
> >>> -     if (!kvm_arm_support_pmu_v3())
> >>> -             return 0;
> >>> -
> >>> -     n =3D read_sysreg(pmcr_el0) >> ARMV8_PMU_PMCR_N_SHIFT;
> >>> -     n &=3D ARMV8_PMU_PMCR_N_MASK;
> >>> -     if (n)
> >>> -             mask |=3D GENMASK(n - 1, 0);
> >>> -
> >>> -     reset_unknown(vcpu, r);
> >>> -     __vcpu_sys_reg(vcpu, r->reg) &=3D mask;
> >>> -
> >>> -     return __vcpu_sys_reg(vcpu, r->reg);
> >>> -}
> >>> -
> >>>  static u64 reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_re=
g_desc *r)
> >>>  {
> >>>       reset_unknown(vcpu, r);
> >>> @@ -1115,7 +1096,7 @@ static bool access_pmuserenr(struct kvm_vcpu *v=
cpu, struct sys_reg_params *p,
> >>>         trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
> >>>
> >>>  #define PMU_SYS_REG(name)                                           =
 \
> >>> -     SYS_DESC(SYS_##name), .reset =3D reset_pmu_reg,                =
   \
> >>> +     SYS_DESC(SYS_##name), .reset =3D reset_val,                    =
   \
> >>>       .visibility =3D pmu_visibility
> >>>
> >>>  /* Macro to expand the PMEVCNTRn_EL0 register */
> >>
> >
>
