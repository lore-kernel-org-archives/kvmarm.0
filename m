Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB7A1F4E4F
	for <kvmarm@lists.linux.dev>; Mon, 16 Dec 2024 07:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734334664; cv=none; b=rdYWJGL1gqigRwHaky0n2oUGhRbn6QTh/tzcNXpmcD0vJAmrvxdgtK4yNwWgrJyhUjFFOAVrTnjVUeLDuFiSAartdoHMPmgJHaQhdcQqQ5qKMarRdgTlqvNvr6z+zm5jvd43CPIP6VFcsNgND3l07N7dNcIJBXbyh7EfVv3Meys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734334664; c=relaxed/simple;
	bh=YHUFA9xaQ6bsnplQVZac7SfeAp7cYlfroZAmph+ZtNk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CLKMu7PZYW/NCmDPmH4U2zMyj13U7vD+ELHHqTijYwXqlaC3q6Hua202hBWsglXKC42qe4B+04uooUL5k0gUwv7ovJywwHscEGuKiDFDmrmECGL6gxl1QYE0GOJq92GxveO5DsgVI20SClRwNFtXNOl7XvtHLUPANCZ9XoupOsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KePyV4r+; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KePyV4r+"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3022c61557cso40064981fa.0
        for <kvmarm@lists.linux.dev>; Sun, 15 Dec 2024 23:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734334660; x=1734939460; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5iPuGa5HCPzSMoHYKVJCU6quqj6Ftm6FTmJ8Y7jrKjY=;
        b=KePyV4r+tk7T4geFVPLPLcA7hI69YLOddbIFMZ2eibCm21qCs+EuYe2f55+kXv+W9c
         Uwdb9g2K1Dl6sj5FXLjaL008SyCkhNnnLn4KOOR2kAtuXBIaBk6x5sxW5B6tnWTyqfD4
         eHO0fT/a6Cl0RJDOYPWfr70y15ErzbE450lZMs13PBa4QIEj9lQVBl6+A1MxqiJFKoOL
         2CJ9a0pf+6F/ap9C3MJGeV64Sl2xyHK/bxjOk/1cshjcmj2AKR0H+OSE3DlxOIbAE2Jk
         ldHMHSigInSc5hZT7AP+dNHYtSbvEnPVIUw8UrxkIf9AeUE4aqk8nX7adQcy+TVbTew1
         avnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734334660; x=1734939460;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5iPuGa5HCPzSMoHYKVJCU6quqj6Ftm6FTmJ8Y7jrKjY=;
        b=dDyTZJQ+dqZA1+dqoAzLbAZKqRGhH0k7AClt7YnnM/7jT/smnxqkIKrRD7HQbPrAbA
         EOCqz9Foi/xnZX0Ddl2j2uLiTaHnWJKUB44mVfnwjeRHDfIRGkaflRC3tVszTAH2lLB2
         KHH1/Gtn9EcREfykV6/34ocGKFbW/OnApAGvv7wA0VHJ3YGWnNIrhytrU65VZcEXxrRF
         CJUrMsa2T5M0SkhfGD39qAEXKyk+av7NcKfUHhPslAWhvWQqjoUfyOKolSoNQ5Il2ZqS
         Qh2cVIlzAz/yZazItrGAFsWSr0dkRPCvV0b56mfoQTvAx+XKeiFiTrru1NXJ/sewUMRL
         LGiw==
X-Forwarded-Encrypted: i=1; AJvYcCWgqkZSo4knY20RhYg2XPpf7lJDLfgeMy+mQtUTJprGR1q58+HN3OfJ4ZOdxCX9iECM31FsWnE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzbn5R5uoweo80PWLh8RUWDtpUiVXDxSRVnovVmHgvCqygTX0gR
	vYi4+AC6pID51M7ZiRsoeVZf9iBGodZaLt02VIjk75iL6QbcOHkgU9tYgNZ9ZhoNRTBNFWIUQBt
	lj0KsOZeAfB85WJchlIRRd2npBFE=
X-Gm-Gg: ASbGnctvy0hQHeH704QlR3UFIJCCp2hTQPyFepfnrZ6aR562/MioQKA/sjy1Xtnwk2x
	Ezqr+sRalw6dwy9JhpQgqHJMTGHvvcqD62i6MvA==
X-Google-Smtp-Source: AGHT+IHS63Q6kudZHLBAZ4BJhW4K+vF5Mpn4FrFYNUREmn4GTgSj6jzvQ7PEVfOwJXgStCjHnEBU1/pcbfhxC5Tz9oc=
X-Received: by 2002:a2e:8608:0:b0:300:1bf1:df23 with SMTP id
 38308e7fff4ca-3025443fccbmr27413781fa.12.1734334660233; Sun, 15 Dec 2024
 23:37:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241213145809.2918-1-ubizjak@gmail.com> <86bjxfsdw0.wl-maz@kernel.org>
In-Reply-To: <86bjxfsdw0.wl-maz@kernel.org>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Mon, 16 Dec 2024 08:37:28 +0100
Message-ID: <CAFULd4YY0BvbjtF=6wG9CoZo7ZLpAOFCk_fzuQ5gVOQ2D3SR=A@mail.gmail.com>
Subject: Re: [PATCH 1/3] KVM: arm64: timers: Fix percpu address space issues
 in kvm_timer_hyp_init()
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 13, 2024 at 6:15=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 13 Dec 2024 14:57:52 +0000,
> Uros Bizjak <ubizjak@gmail.com> wrote:
> >
> > Cast return value from kvm_get_running_vcpus() in the __percpu
> > address space to the generic address space via uintptr_t [1]
> > to fix a couple of:
> >
> > arch_timer.c:1395:66: warning: incorrect type in argument 2 (different =
address spaces)
> > arch_timer.c:1395:66:    expected void *vcpu_info
> > arch_timer.c:1395:66:    got struct kvm_vcpu *[noderef] __percpu *
> >
> > sparse warnings.
> >
> > There were no changes in the resulting object files.
> >
> > [1] https://sparse.docs.kernel.org/en/latest/annotations.html#address-s=
pace-name
> >
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > Cc: Marc Zyngier <maz@kernel.org>
> > Cc: Oliver Upton <oliver.upton@linux.dev>
> > Cc: Joey Gouly <joey.gouly@arm.com>
> > Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Cc: Zenghui Yu <yuzenghui@huawei.com>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > ---
> >  arch/arm64/kvm/arch_timer.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
> > index 1215df590418..a13bb9e8dc19 100644
> > --- a/arch/arm64/kvm/arch_timer.c
> > +++ b/arch/arm64/kvm/arch_timer.c
> > @@ -1392,7 +1392,7 @@ int __init kvm_timer_hyp_init(bool has_gic)
> >
> >       if (has_gic) {
> >               err =3D irq_set_vcpu_affinity(host_vtimer_irq,
> > -                                         kvm_get_running_vcpus());
> > +                                         (void *)(uintptr_t)kvm_get_ru=
nning_vcpus());
> >               if (err) {
> >                       kvm_err("kvm_arch_timer: error setting vcpu affin=
ity\n");
> >                       goto out_free_vtimer_irq;
> > @@ -1416,7 +1416,7 @@ int __init kvm_timer_hyp_init(bool has_gic)
> >
> >               if (has_gic) {
> >                       err =3D irq_set_vcpu_affinity(host_ptimer_irq,
> > -                                                 kvm_get_running_vcpus=
());
> > +                                                 (void *)(uintptr_t)kv=
m_get_running_vcpus());
> >                       if (err) {
> >                               kvm_err("kvm_arch_timer: error setting vc=
pu affinity\n");
> >                               goto out_free_ptimer_irq;
>
> I think the fix is worse than the current code, because there is no
> real semantics behind the pointer being passed to
> irq_set_vcpu_affinity(). All that is required is that it is a non-NULL
> pointer.
>
> I expect the following hack to work just as well and not suffer from
> any sparse indigestion. Untested though.

The proposed hack also fixes sparse warnings and fixes my percpu
checker errors, but as a functional change, I have no means of testing
the proposed change on a target processor. So, I can just give:

Acked-by: Uros Bizjak <ubizjak@gmail.com>

from a percpu checker perspective.

Thanks,
Uros.
