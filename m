Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410E9634
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 12:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740573928; cv=none; b=C4a8+4vntyIYAw+UkFFOflAeKgN/x6GqpZevI+Xzuw1sIjF6JThF2vyaKHqwyI2NuDwTwdn9isRi7QpmlzreTJZDj/mWJOYr1dpWuYcqsU9DWJNFDmeKFEqhi0KiEux88x6eiWpa2TsDTF7ZC4ralR3tQvRyMMRYDMPcoIEGdSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740573928; c=relaxed/simple;
	bh=QPinphoFTyt6j48XE2vnq7+nJ/E7MaCl0BM2e3HVE0o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XomRzRAhJwGaC6r77Y2V5iR427N7UwpMHtmDGKIoSl2H1xOmGcXYGIeuIlyxQCq7ETlqr9JyG+ibgwn8e4qd6RsWImOhy1Tra6fdFZqqcPXV9Fwu1qLm+qZY4ary+geI/e5kc+ENb/vYhB/TFuudyHWsxrMpZeQic8mHQbPQr3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eRQbf+ys; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eRQbf+ys"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-471fbfe8b89so325861cf.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 04:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740573926; x=1741178726; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FnZ58QpNpvBwycojF2nbwIbKbRZbutG5CaI6EccsGVE=;
        b=eRQbf+ysrF6YGtQ5jgM2vwmh+z+ORRhc5MBSXgEa3A+9CBThMZwz6Yv02lRvIorRe4
         GPa40HmmZ9fGVcMegzpRp6E6+eu+CWGccTM/W7akN9z0NRs57X86O2C1ZxfcK155LeFi
         F1u18S/VxvXk3NyHjN2SFc2DAkrzLtccC82b76GhBaJDimuO+/cadGdiaUFs17QLq/ab
         IGF8BKYe7oxJTRfXG2MwTemV4dwWKK0e8e1d4+P7rCLhudg5fEviEzQ2cyaAbWNvjJed
         WQnORvVdoLO94/SULHz1pnyN/TvXnZ5/HYwKdUdWj4elJeALcA0AMay7EPq7zKUm9DDs
         iNlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740573926; x=1741178726;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FnZ58QpNpvBwycojF2nbwIbKbRZbutG5CaI6EccsGVE=;
        b=fkHsV6ZDFe4DoyyeYTChjHN6nnE8rQB34jdg98M3w1xEVhCmmNL8Oz9wM0FPj859HG
         FwEdYD/8tbKsQG2vGtNLw2UPPPznWonKbEYTc0i0JiHTEN1zHBdAwnxWyVb6X8PXMHVk
         YqVDg8IGL8qfCocE+7SIeYpthRT8V2PSZ0b2CnQ8vupSrMzNhH1aXiFcMyyCqgbtpQCT
         xaKlTNh2TH2ysGVHtCk5TfdS3EoIZDWFdWAQbfHk543mLXrNvK0TWwjPNRXPvFwj3GIg
         9jdWvAQ7LfMaD1TEH7sa+YJSsZbq73QOt2STqq1fR34JpGwk0ex6PupcXVcFV6o0W+Nm
         TteQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIeTMwZGm9aO2GlBH50iDl0pNbRf9gCkj1+X56ZHgoXoTczRPj39DrO30kszGidfjRS1JrJjc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxbsR4O81U7Rw900EyZDeHLBAaasCCiOTNeqBCqnF2+VS1518FF
	6S5oYtI4nEVgJlmT9jcnDqi3HIsIgn5uANa+CTiFbJckcoeZgkjm56RL5/k9tqt1Qdx/pODN0NF
	rHgicwsO7NI3thRvTIbKl3Uc5sAN6WKbkSHja
X-Gm-Gg: ASbGncsjPJBG10E7kBpj/w8oL/WiawWoEMb24OJO1t7t8J3Vg2MVSBqen8KE5QysdcV
	dT/QS95/0l0DFJoUyGx5weRX4Zvx4YKIVhVhrdziezMtbphyLpgENJd+s8+Zs25eibBt4MBZsC/
	zAs0I=
X-Google-Smtp-Source: AGHT+IFPsfyVxDmOk5bhhOwAYkW0RuBl+C5BgE8AvC3sWrJRgsvEpg0IbCAel4g627Ak8eyzVdEUrJ5bLuAAKop36/c=
X-Received: by 2002:a05:622a:4a:b0:466:8f39:fc93 with SMTP id
 d75a77b69052e-47376e5e3aamr8364681cf.3.1740573925849; Wed, 26 Feb 2025
 04:45:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250214150258.464798-1-tabba@google.com> <20250214150258.464798-2-tabba@google.com>
 <Z77n_Gv0X0bolONW@linux.dev> <86a5a9q90z.wl-maz@kernel.org>
In-Reply-To: <86a5a9q90z.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 26 Feb 2025 04:44:49 -0800
X-Gm-Features: AQ5f1JpXLWze3ZsKcg1F1ITEjoOVRMUPQeTV9gjFFgka2SqDslZdnyDLB_yzXd8
Message-ID: <CA+EHjTwRNj6z_TTCXR8UNiB0ty=85_VKWDVsFOLke31UGnBE7A@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] KVM: arm64: Initialize HCRX_EL2 traps in pKVM
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, will@kernel.org, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, broonie@kernel.org, qperret@google.com, 
	vdonnefort@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Wed, 26 Feb 2025 at 02:45, Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 26 Feb 2025 10:07:56 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> >
> > Hi Fuad,
> >
> > Series LGTM overall, one comment:
> >
> > On Fri, Feb 14, 2025 at 03:02:56PM +0000, Fuad Tabba wrote:
> > > Initialize and set the traps controlled by the HCRX_EL2 in pKVM
> > > when the register is supported by the system.
> > >
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/pkvm.c | 46 ++++++++++++++++++++++++++++++++++
> > >  1 file changed, 46 insertions(+)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > index 3927fe52a3dd..668ebec27f1b 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> > > @@ -58,6 +58,30 @@ static void pkvm_vcpu_reset_hcr(struct kvm_vcpu *vcpu)
> > >             vcpu->arch.hcr_el2 |= HCR_ATA;
> > >  }
> > >
> > > +static void pkvm_vcpu_reset_hcrx(struct pkvm_hyp_vcpu *hyp_vcpu)
> > > +{
> > > +   struct kvm_vcpu *host_vcpu = hyp_vcpu->host_vcpu;
> > > +   struct kvm_vcpu *vcpu = &hyp_vcpu->vcpu;
> > > +
> > > +   if (!cpus_have_final_cap(ARM64_HAS_HCX))
> > > +           return;
> > > +
> > > +   /*
> > > +    * In general, all HCRX_EL2 bits are gated by a feature.
> > > +    * The only reason we can set SMPME without checking any
> > > +    * feature is that its effects are not directly observable
> > > +    * from the guest.
> > > +    */
> > > +   vcpu->arch.hcrx_el2 = HCRX_EL2_SMPME;
> > > +
> >
> > The comment isn't wrong, but we don't support SME at all in KVM at this
> > point.
>
> This is a copy/paste of what we have in kvm_calculate_traps(), and the
> result of the removal of the dreaded HCRX_GUEST_FLAGS.
>
> > Any objection to dropping this bit? I can fix it when applying the
> > series, no need to respin.
>
> Whatever we do, I think we should keep the two side of the trap
> configuration in sync, as this is otherwise a cause of bugs.

I could take the initialization of hcrx part from
kvm_calculate_traps() and place it in an inline function in
kvm_emulate.h. This then would be called by kvm_calculate_traps() and
pkvm_vcpu_init_traps().

What do you think?

Thanks,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>
