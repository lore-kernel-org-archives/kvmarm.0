Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5309437A493
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 08:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781252131; cv=pass; b=FOpcWcMA43BEqN64+wYPJDokdAxyYS7SPTrwZBDRMGuqxtWeRH1frQlRYTW5O3/WmYFlVpC4BRMvBpQyle+JRFRqxPul7Fl83v6MtjVpbp7EPwB6+0HRA1JhBp7zZ5QnTyq4Iciq0uzF6tE3ZXOGNE3BYwWBMrWg84d1qpcVVUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781252131; c=relaxed/simple;
	bh=MzEFp4pjBpUyzQQecCLTxwctjZloQpf3KVzIOs2W6ms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CTEuFK4RaMmFWDMbyUYSf1eVhOoSsLaDEvYzZYJAz2v0NHEd6g3L65Oiyq8mYUGm2JIjD3v4HTOG9l4VqYBoGambhaUsh8HSR8HCyc57HbGllZo4y1k/aofazJuC1B2bvHZJWWeHGHZJSmsQDA3LZJnU1bj9P9HrY2SJO5sRwhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hz1oRjn+; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hz1oRjn+"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5175d339e8bso413021cf.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 01:15:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781252128; cv=none;
        d=google.com; s=arc-20240605;
        b=PJWZ2Qy4Y76aw+b7S/VkRblkEXlbaN8wH/ivlpiWTzNR/euviS8/fv6UjPHZ05hiJN
         7gkgBKMtRGY9ZJUW49d4IpgeM9V9tw40dfvvtL1EjZqAdbYgC5z1eNxHBSxIZJTwYAd1
         b0YGBQ6vVXmQz27uW9+V7+n5UjHnJ7Av9qIyhhDJPqTFuYuAZxS9+eJt7LPEnV7Wfkl5
         CBrGqwn3FekjyRf+wy23Ilz7I8owi/QQdqK8x4FYIbEmkh+BskOcJw4Lz+PnyIbvlrpj
         jOatrn0v/ogflKBcMuMVk7t9gclhcGd10U6lIHgX6wmHYIq+MKCOyuo7tYmzdQ5wvZv0
         M9Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h3wU5q8stR3D4hTYWLM9ySnSvxIpdYSTYFtemeb7EEw=;
        fh=TRHesZtT0j8x9zeKDK1YGlf93I58XOyUA3yvjU9LhKw=;
        b=Ti9gCuS3rstiKLNnPmzlTFLFPO1kHmVYOAxn8sWkxudcgAOer2cJhsHaHHBwPGaXMU
         HG626+n3ruaD54+t+CywY+YmssBLb44IG5onUWRziF1h9bLnH12p9KbzF4zBfND422WT
         pAJM1xgjfHoIUfERmQUMTIdKU0+OCAQzB7EkHF7Q3oTz89hY5KXuqbU0q+WDBZdRU6L3
         6CKz38z8OzAEIvsi3kYwy+RRZc6wzzdVSn32Kfneu2j7Pw9wbVTOyEvzaTtMv5L3wRbX
         elyJDyaq4hoT+pm0auEBjWIJwDe7lU9oGHWzGo4u68w081lHv6klMt0bDBVhfeeyoOrT
         XmPQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781252128; x=1781856928; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3wU5q8stR3D4hTYWLM9ySnSvxIpdYSTYFtemeb7EEw=;
        b=hz1oRjn+0wnbcheS6z6+B07zhz7hhg/I7tWm/I+k8u5+w25aq2mbNR+EVSuOU0BLr+
         MGS7XQjlHoaO3eudxKlzUNDcZXMJFbv5r95sLqOEdB/UoLmzqcfqbVsswQJ7DbCMsOE0
         Dt/AMFTKAzJ215EyFgZ1amJlXqxp9gDObvsJeCNVeDDSkSpD2AR3yEmfPzJJwWf42hTS
         XOIE9+OfWoRL/BVsXrGw/1SaVi6IAl8Ist4j9TjpUeC44WY6/JOKGbl/L+1fMZAYTYB7
         PRfKDYjHvSnFLm+ue7tFxLB5D0F9GG3hq4v0OWRggB+JcIArw8MKk2Jw26F0OCJcNUBf
         edPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781252128; x=1781856928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h3wU5q8stR3D4hTYWLM9ySnSvxIpdYSTYFtemeb7EEw=;
        b=YyYub9OB1ZKstZsPdBPreseH22X1N/B8mgjP/odSREeY8xtVfqYc5u54UDbkHP78oG
         VqDTR0yrexx7UMv32mXIdHr6GgryQ0eL1PAEKdf4njT/GFiNtSzHuY20uzLqBwBQPtqU
         C/m58Kn9OvSsi/xTvmO1K88ebiFcfPRCPi6YDlrSGixgV1a4O34f3v753m5saPT1p/Qb
         wFI4sCZzljIgFRF3AN1xrUqZAFXuX3SeCwCIA/LdqFHEJiu+IAysnaJExttC4x65GtGV
         WL+fiH/4zrLp6Fx7SI/b/ZodHe0TQcPoS3Rxn1Zkg7xyVtS3IwiGzHwN9jaJpZtzIYsc
         s8Fw==
X-Forwarded-Encrypted: i=1; AFNElJ/wJUdEiZs8/mEJ6dJwYrFRZnenF+x870D8YZi9ku1OP2nOzOi2RXnU/JzGI4KkJdocv3nGauw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxfe6HM/zt/nu6sU/6Q2h/befHfsQG9ptTG6jBlaEXUGis0LUyQ
	cVfTAIedp5glY9MvnnZhP5m6Rk60z7EXVXAm74vXOZOq9n2JhYPuIIEHN8DgScsr0HK+1oHVDEk
	ERPNaXFhpv1H1JDpor3EMCEoq+6279uxKvWCvU1PX
X-Gm-Gg: Acq92OHuvQv2uJMEyIfn6HmUMvG6di7Sr4uKezQYZ54664jtccfZDsI+nKmHitJbQBT
	qygkZKsWtMYa1gOWfEJyPN9sPZNFzIGtj6ucvxwINihET1I2ExMRyCF8rPoJPNyOslHOka/ZG+t
	eMTp1BZT3QXgkVKl+C378p4twbgvSSLpqDY2Cz4/Xmb8XCQkU1w9vJGSTpBsbqj6HYACPFmJyhq
	jNPD6F0LxOmXS1MzLtoRecbkYQAd0I8iOq0H57nYZIj97xv3KYCVoetliq3uV9n1mRnE7irM6Zs
	hxEyvARY
X-Received: by 2002:ac8:690b:0:b0:516:4f62:85f1 with SMTP id
 d75a77b69052e-517fb1606cemr6428911cf.22.1781252127654; Fri, 12 Jun 2026
 01:15:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260612065925.755562-11-tabba@google.com> <20260612072328.BC6B31F000E9@smtp.kernel.org>
In-Reply-To: <20260612072328.BC6B31F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Fri, 12 Jun 2026 09:14:50 +0100
X-Gm-Features: AVVi8CcVBD_Hdo8p6kcAKqp6Vo8QUt2p-qrb9GQkidVFjzCzDoYy_ynQaltaxv8
Message-ID: <CA+EHjTxO_mQ1PznEgE3AP0YvLu1bQO9S+DiNRb8Cj89TkyGwsw@mail.gmail.com>
Subject: Re: [PATCH v1 10/11] KVM: arm64: Add primitives to flush/sync the
 VGIC state at EL2
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 12 Jun 2026 at 08:23, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] Unconditional pinning of vgic_sre to SRE=3D1 breaks GICv2 emulat=
ion for non-protected guests.
> --
>
> commit 3d9e59afaa5e29a6ce57ece8ccacae434b38915d
> Author: Marc Zyngier <maz@kernel.org>
>
> KVM: arm64: Add primitives to flush/sync the VGIC state at EL2
>
> This commit adds flush_hyp_vgic_state() and sync_hyp_vgic_state()
> primitives to move per-vCPU VGIC state between the host and hypervisor
> contexts for pKVM.
>
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nv=
he/hyp-main.c
> > index 2f165b6c7b071..23e644c24a03a 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> [ ... ]
> > @@ -99,6 +99,46 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
> [ ... ]
> > +static void flush_hyp_vgic_state(struct pkvm_hyp_vcpu *hyp_vcpu)
> > +{
> > +     struct kvm_vcpu *host_vcpu =3D hyp_vcpu->host_vcpu;
> > +     struct vgic_v3_cpu_if *host_cpu_if, *hyp_cpu_if;
> > +     unsigned int used_lrs, max_lrs, i;
> > +
> > +     host_cpu_if     =3D &host_vcpu->arch.vgic_cpu.vgic_v3;
> > +     hyp_cpu_if      =3D &hyp_vcpu->vcpu.arch.vgic_cpu.vgic_v3;
> > +
> > +     max_lrs         =3D (read_gicreg(ICH_VTR_EL2) & ICH_VTR_EL2_ListR=
egs) + 1;
> > +     used_lrs        =3D host_cpu_if->used_lrs;
> > +     used_lrs        =3D min(used_lrs, max_lrs);
> > +
> > +     hyp_cpu_if->vgic_hcr    =3D host_cpu_if->vgic_hcr;
> > +     /* Should be a one-off */
> > +     hyp_cpu_if->vgic_sre    =3D (ICC_SRE_EL1_DIB |
> > +                                ICC_SRE_EL1_DFB |
> > +                                ICC_SRE_EL1_SRE);
>
> [Severity: High]
> Does hardcoding ICC_SRE_EL1_SRE here break GICv2 emulation for non-protec=
ted
> guests?

No. GICv2 is not supported under pKVM. vgic_v2_probe() (vgic-v2.c)
returns -ENXIO when is_protected_kvm_enabled(), so no GICv2 guest can
be created. Every guest reaching flush_hyp_vgic_state is GICv3.

> When __vgic_v3_restore_state() executes on guest entry, it will program
> ICC_SRE_EL1 with this value. Setting the SRE bit to 1 disables the GICv2
> memory-mapped interface (GICV) for EL1. Non-protected guests configured t=
o
> use GICv2 rely on vgic_sre =3D=3D 0 to keep the memory-mapped interface e=
nabled.
>
> Should this value be copied from the host-set values for non-protected VM=
s
> rather than being unconditionally pinned?

The host sets the same value for GICv3 guests (vgic-v3.c),
so copying and hardcoding produce the same result. GICv2 is blocked
under pKVM (vgic_v2_probe returns -ENXIO), so the vgic_sre=3D0 branch
is unreachable. Hardcoding is intentional for the protected case
(EL2 must not trust the host value) and harmless for non-protected
(the values are identical).

Cheers,
/fuad

>
> > +     hyp_cpu_if->used_lrs    =3D used_lrs;
> > +
> > +     for (i =3D 0; i < used_lrs; i++)
> > +             hyp_cpu_if->vgic_lr[i] =3D host_cpu_if->vgic_lr[i];
> > +}
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612065925.75=
5562-1-tabba@google.com?part=3D10
