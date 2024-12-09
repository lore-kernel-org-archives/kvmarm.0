Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A31214809
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 08:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733731626; cv=none; b=VoOaBNgkc9Z243x/Yn0kwxsKBd9ZyU8vkErxb6nmFvgTMa6ydgti8kiPI5tmj9aYsL/gU0jsIJUslO+xDZR3FGV9nsEQNk+mFvs5iwPx12FMCGVpuEj6eMP6mWgll34w97y+yqcKKuGV0x8Rxj08IlYL7fkB+C7dpZa2jy8Sdhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733731626; c=relaxed/simple;
	bh=I+CZQxwwIDwJytfpHHBP+hlx0lJosL6xfdX5C2+VbgY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fmMbkI1dasRGUm9TQP3Or71VcMcBU4tJ0avAy1JqKZ3m4O1alCE4EhUtVEgdR8xJ79H8kQnA1glMC+9BHRK2bKe4490G6rNwBxKe6UYZUKfcIfxZtQOEe+WVF7GezBeiCJEPKTVSTjwtbT43+st3L0nsHWwmSCvqJVZcPCAhqOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UAPnRH1v; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UAPnRH1v"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-434ed674047so62295e9.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Dec 2024 00:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733731623; x=1734336423; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=82S7PbDe0oe1fScv2wnm6abSAjxVCV0v9XILXewfqtQ=;
        b=UAPnRH1vThkB8kF+ULQkDGzMpTucvakC59B9IaMoU/4XN0yh0TbI7gKxZMbCmf+bb+
         a0szkYk4QvqFhLoDvhwTdTmv/0zYDgs83IJ1IyfdHQPjENb1rG22ysJQ2Y5hN9Heu0Ui
         EDeTE+zNkt2VQMUHBv+oR+n3g0ShUjg6jlVbp6B+wvNaZ2fJGkj10niDYqUQLTEwbP7N
         YozSFtdidGcu+dUiLnS1JI6g6nyzKceBKZcKo9ad+FruprCYjyaoPG1NLpSTX8KP190k
         aIHLX5QycQox+ikRA3x2qNXhSr4/+j5etGpt7DH3vJ3pifI23xQgqIMjQbdA/4h2Frwy
         p9kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733731623; x=1734336423;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=82S7PbDe0oe1fScv2wnm6abSAjxVCV0v9XILXewfqtQ=;
        b=FV+7dQfHNKKyjQH8kh8VGulNGZxc5Pn4cu+QSzmRO+fUS214pM7kwVo83BhVG1Ie5B
         UDAO00E4d3I4SaOMn6ulfyNJuZ1UmO7sqrTIcZzkBFRC60nUkcOsIGgM+Yt8ZnFHyUJ+
         OALz6/YyBfFoqyJ20LpR/q4ehk0QDbjEmbpm4hxSF/Ux02cxLCK6beEjwELFOWOHRNFb
         wCnaxDPZfGz0hx9aQDKCZG6w8zFwDPfJFs3VwZxtVdrqMFi8Mt5E0BCr19wenKQuW7ol
         4GayCYrLLmPWSJtnYP9eUZn6IQqjzO3dlTZRP2NLzAcD8o6iCuKvTHFy9G87xMojFq3F
         eWuQ==
X-Gm-Message-State: AOJu0YyIMmJmFj8irz0aWnsqHijQ37j3kJbR7u16gz2uOQjxIgqC6NFC
	Eaf607fx2dwqAn1DCPg+A3kJzWjoWZk5ujj/61E8gQdI8FIDFi9+5RsH8E7G9+3CWaey2PmcR2H
	Dqzt8l6AE4y8q+pePy7QgPhVeBcnXZrhBMGlH
X-Gm-Gg: ASbGncsTTmpsemQmHpG1rxDWRWAxnsmFUHfg6rf7ZAWVQTuqhDFJoqMlMBtud6xLlYZ
	GcKpPHFYzUtlbmU/6GRK0A44xHivGeQ==
X-Google-Smtp-Source: AGHT+IFHPISoszHs24tCysjuD8a25wVHcJsjEOG5WotyQnhYTjm7sOA+Rb4A/vSCrQZbyHT4VvtHjyFj9CA292vpIGQ=
X-Received: by 2002:a05:600c:332a:b0:434:9e01:cac1 with SMTP id
 5b1f17b1804b1-434e92dbcbbmr2217355e9.7.1733731623312; Mon, 09 Dec 2024
 00:07:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241202154742.3611749-1-tabba@google.com> <20241202154742.3611749-3-tabba@google.com>
 <Z1Mp4zmZRL_8QEmb@google.com>
In-Reply-To: <Z1Mp4zmZRL_8QEmb@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 Dec 2024 08:06:26 +0000
Message-ID: <CA+EHjTwzDDPTyqs-VgGvPK+gk-+fDsD8WdQN1cJjzNcCYWBJFw@mail.gmail.com>
Subject: Re: [PATCH v4 02/14] KVM: arm64: Group setting traps for protected
 VMs by control register
To: Quentin Perret <qperret@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	kristina.martsenko@arm.com
Content-Type: text/plain; charset="UTF-8"

Hi Quentin,

On Fri, 6 Dec 2024 at 16:44, Quentin Perret <qperret@google.com> wrote:
>
> On Monday 02 Dec 2024 at 15:47:29 (+0000), Fuad Tabba wrote:
> > +static void pvm_init_traps_cptr(struct kvm_vcpu *vcpu)
> >  {
> > -     const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
> > -     u64 mdcr_set = 0;
> > -     u64 mdcr_clear = 0;
> > -     u64 cptr_set = 0;
> > +     const u64 id_aa64pfr0 = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR0_EL1);
> > +     const u64 id_aa64pfr1 = pvm_read_id_reg(vcpu, SYS_ID_AA64PFR1_EL1);
> > +     const u64 id_aa64dfr0 = pvm_read_id_reg(vcpu, SYS_ID_AA64DFR0_EL1);
> > +     u64 val = vcpu->arch.cptr_el2;
> >
> > -     /* Trap/constrain PMU */
> > -     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), feature_ids)) {
> > -             mdcr_set |= MDCR_EL2_TPM | MDCR_EL2_TPMCR;
> > -             mdcr_clear |= MDCR_EL2_HPME | MDCR_EL2_MTPME |
> > -                           MDCR_EL2_HPMN_MASK;
> > +     if (!has_hvhe()) {
> > +             val |= CPTR_NVHE_EL2_RES1;
> > +             val &= ~(CPTR_NVHE_EL2_RES0);
>
> It's a bit odd to do that at the beginning of the function no? Perhaps
> do it last to be sure to overwrite all the changes below?
>
> Also, not sure we need the RES1 part here, kvm_get_reset_cptr_el2()
> should have set those for us.

I agree on both, and by the end of this series they end up being as
you suggest. The purpose of this particular patch is just the grouping
of the traps, while keeping everything else the way it is.

Cheers,
/fuad

>
> >       }
> >
> > -     /* Trap Debug */
> > -     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), feature_ids))
> > -             mdcr_set |= MDCR_EL2_TDRA | MDCR_EL2_TDA | MDCR_EL2_TDE;
> > -
> > -     /* Trap OS Double Lock */
> > -     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DoubleLock), feature_ids))
> > -             mdcr_set |= MDCR_EL2_TDOSA;
> > +     /* Trap AMU */
> > +     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU), id_aa64pfr0))
> > +             val |= CPTR_EL2_TAM;
> >
> > -     /* Trap SPE */
> > -     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer), feature_ids)) {
> > -             mdcr_set |= MDCR_EL2_TPMS;
> > -             mdcr_clear |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
> > +     /* Trap SVE */
> > +     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_SVE), id_aa64pfr0)) {
> > +             if (has_hvhe())
> > +                     val &= ~(CPACR_ELx_ZEN);
> > +             else
> > +                     val |= CPTR_EL2_TZ;
> >       }
> >
> > -     /* Trap Trace Filter */
> > -     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceFilt), feature_ids))
> > -             mdcr_set |= MDCR_EL2_TTRF;
> > +     /* No SME support in KVM. */
> > +     BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR1_EL1_SME), id_aa64pfr1));
> > +     if (has_hvhe())
> > +             val &= ~(CPACR_ELx_SMEN);
> > +     else
> > +             val |= CPTR_EL2_TSM;
> >
> >       /* Trap Trace */
> > -     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceVer), feature_ids)) {
> > +     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_TraceVer), id_aa64dfr0)) {
> >               if (has_hvhe())
> > -                     cptr_set |= CPACR_EL1_TTA;
> > +                     val |= CPACR_EL1_TTA;
> >               else
> > -                     cptr_set |= CPTR_EL2_TTA;
> > +                     val |= CPTR_EL2_TTA;
> >       }
> >
> > -     /* Trap External Trace */
> > -     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_ExtTrcBuff), feature_ids))
> > -             mdcr_clear |= MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
> > -
> > -     vcpu->arch.mdcr_el2 |= mdcr_set;
> > -     vcpu->arch.mdcr_el2 &= ~mdcr_clear;
> > -     vcpu->arch.cptr_el2 |= cptr_set;
> > -}
> > -
> > -/*
> > - * Set trap register values based on features in ID_AA64MMFR0.
> > - */
> > -static void pvm_init_traps_aa64mmfr0(struct kvm_vcpu *vcpu)
> > -{
> > -     const u64 feature_ids = pvm_read_id_reg(vcpu, SYS_ID_AA64MMFR0_EL1);
> > -     u64 mdcr_set = 0;
> > -
> > -     /* Trap Debug Communications Channel registers */
> > -     if (!FIELD_GET(ARM64_FEATURE_MASK(ID_AA64MMFR0_EL1_FGT), feature_ids))
> > -             mdcr_set |= MDCR_EL2_TDCC;
> > -
> > -     vcpu->arch.mdcr_el2 |= mdcr_set;
> > +     vcpu->arch.cptr_el2 = val;
> >  }
