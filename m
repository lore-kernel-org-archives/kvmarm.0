Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99E1494A1F
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 13:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785332515; cv=none; b=dB6+kuskkJBYY+WGdsM+rcz5WW+DpSZjosqXgug/gUzjbXzsOh5Vrazb9dwpFOSF6T0QYeN27Jarc0RWQHs5V3vI9H90YHr60C2N9M927k5FEX+JD0Ts4M4ASaFHxp4vJZ7rFS4uzQMXjxGYG1kK2b7UdNQp9eDC4Z32jSF2zvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785332515; c=relaxed/simple;
	bh=Kg42fHqL294PSP2icdDW5mIzpKB/nQB/6qB2WFRmg7c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EZBZ97XgHj1+4SXLk/jgGeOtNg6aEJiOFtnUOXgYl+anq5XxDHfh3GyeBhGR6NyU6eJ+OVBKZNd64Uh9Ga1Kz3XM88jW/tfOnhFpiZJCr5qY/E3nexTcFpAnTq1R4w9SyaH24SHt+eBftzXeCh8I/0Uh+d49TFKDknnoex+e2oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Rw6tyTGP; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Rw6tyTGP"
X-Forwarded-Encrypted: i=1; AHgh+RqT9ZSkB4fX0kU7PaIbJcM6KTxZhiOg0m6bUd2KDwRumOOVpr61cF1/aCuUxBrf9zKgq9rTmEw=@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785332512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TlpoDjaUiwDhEUS7H/6UoO0K/9RhPT3BmhhNeUQ64Fc=;
	b=Rw6tyTGPPojLec4RrUgjCS93BXtcTmvS1KFY4HZTMMFq2kmUSIxY4BkFWFaRKQRCtv1DSD
	nZpEG7QcDyjgc5FrG9gaB2hPrYhJUFUOg0Pm9XV+vqbqaU0qtYzHTGgTZmG6iq11A3KWke
	gFo+QUGpRVIIvPJRTDEzZY+J4oLd8aA=
X-Gm-Message-State: AOJu0YxK1H5tmIKkfWnagTgBpG1tGn0mnkxe4F+wk2hx21cZjlwkSeIJ
	zBQVE4lyHyLn9ud+rvLXVQz3CgMsN1/1PLM59c/18anp2yQ0hICV5U5ajQVcg6hJGGL3i7EBxPz
	MoeVuEctSm8tMxCGmV2yeARi04uB+UOto/LerJ5FO
X-Received: by 2002:a05:622a:2287:b0:519:b82d:fe62 with SMTP id
 d75a77b69052e-52b2cb626ecmr9306911cf.7.1785332489713; Wed, 29 Jul 2026
 06:41:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260729131823.2021516-1-fuad.tabba@linux.dev>
 <20260729131823.2021516-3-fuad.tabba@linux.dev> <20260729133403.C4DC51F000E9@smtp.kernel.org>
In-Reply-To: <20260729133403.C4DC51F000E9@smtp.kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 29 Jul 2026 14:40:52 +0100
X-Gmail-Original-Message-ID: <CA+EHjTyHm8L9rFFBd5fYPzpCxiFg=0DgGWrA9PAVdgNOFCt9yw@mail.gmail.com>
X-Gm-Features: AUfX_my_sBsJlNTklZvnGDHSn893IG6Nuhr4fFcHF1n_mLMryz3BFEwiS9JMmT0
Message-ID: <CA+EHjTyHm8L9rFFBd5fYPzpCxiFg=0DgGWrA9PAVdgNOFCt9yw@mail.gmail.com>
Subject: Re: [PATCH v7 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg
 available to HYP code
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT

On Wed, 29 Jul 2026 at 14:34, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Pre-existing bug: `enter_exception64` reads stale `SCTLR_EL1` du=
ring early trap handling in nVHE/pKVM.

Already fixed:
https://lore.kernel.org/all/20260612102347.914994-1-tabba@google.com/.


/fuad

> --
>
> --- Patch [2]: [PATCH v7 2/8] KVM: arm64: Make vcpu_{read,write}_sys_reg =
available to HYP code ---
> commit e62bbea08d3143161297d701776a47e619a76db1
> Author: Fuad Tabba <fuad.tabba@linux.dev>
>
> KVM: arm64: Make vcpu_{read,write}_sys_reg available to HYP code
>
> This commit replaces the locally open-coded __vcpu_read_sys_reg and
> __vcpu_write_sys_reg wrappers in exception.c with the canonical
> vcpu_{read,write}_sys_reg accessors. For nVHE builds, it maps these
> accessors directly to the raw in-memory context accessors, allowing HYP
> code to reuse helpers without function duplication.
>
> > diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/except=
ion.c
> > index bef40ddb16dbc..754e2dc1df54a 100644
> > --- a/arch/arm64/kvm/hyp/exception.c
> > +++ b/arch/arm64/kvm/hyp/exception.c
>
> [ ... ]
>
> > @@ -101,14 +85,14 @@ static void enter_exception64(struct kvm_vcpu *vcp=
u, unsigned long target_mode,
> >
> >       switch (target_mode) {
> >       case PSR_MODE_EL1h:
> > -             vbar =3D __vcpu_read_sys_reg(vcpu, VBAR_EL1);
> > -             sctlr =3D __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
> > -             __vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
> > +             vbar =3D vcpu_read_sys_reg(vcpu, VBAR_EL1);
> > +             sctlr =3D vcpu_read_sys_reg(vcpu, SCTLR_EL1);
>
> [Severity: High]
> This is a pre-existing issue, but does enter_exception64() read a stale
> SCTLR_EL1 value from the in-memory context here?
>
> When a protected VM triggers an early EL2 trap, the hypervisor handles it
> via the kvm_handle_pvm_sysreg() -> inject_undef64() -> inject_sync64() ca=
ll
> chain. At that point, the guest's system registers aren't fully saved to =
the
> in-memory vcpu->arch.ctxt.
>
> While inject_sync64() explicitly synchronizes VBAR_EL1 from hardware to m=
emory:
>
> arch/arm64/kvm/hyp/nvhe/sys_regs.c:inject_sync64() {
>     ...
>     __vcpu_assign_sys_reg(vcpu, VBAR_EL1, read_sysreg_el1(SYS_VBAR));
>     ...
> }
>
> It doesn't appear to synchronize SCTLR_EL1 before triggering exception
> injection.
>
> Since nVHE builds map vcpu_read_sys_reg() directly to the memory context,
> enter_exception64() seems to use a stale SCTLR_EL1 value to calculate the
> PSR_PAN_BIT and PSR_SSBS_BIT for the exception's PSTATE.
>
> This corrupted PSTATE is then written directly to the hardware SYS_SPSR_E=
L2
> by inject_sync64(), potentially poisoning the guest's state upon ERET.
>
> Should SCTLR_EL1 also be synchronized from hardware before injection?
>
> > +             vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
> >               break;
> >       case PSR_MODE_EL2h:
> > -             vbar =3D __vcpu_read_sys_reg(vcpu, VBAR_EL2);
> > -             sctlr =3D __vcpu_read_sys_reg(vcpu, SCTLR_EL2);
> > -             __vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
> > +             vbar =3D vcpu_read_sys_reg(vcpu, VBAR_EL2);
> > +             sctlr =3D vcpu_read_sys_reg(vcpu, SCTLR_EL2);
> > +             vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL2);
> >               break;
> >       default:
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260729131823.20=
21516-1-fuad.tabba@linux.dev?part=3D2
