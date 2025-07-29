Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9DC226D1F
	for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 16:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753808188; cv=none; b=jaJ9/qf8GQdHJh9cHIDQ6PJSLpry0UWKmRV3C9a4MWURW3rtfHTuv66Ize4+sBZXQ3gQCtaIb1LEMNE4mXX+Fq2SKpvHfsTcjYhhP/cdGFkdEoRa04wo2vs42OjDkjbhRuHOb9UE8UgkWs752UZc82Mr28LQZUzDhHFH0bAOLU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753808188; c=relaxed/simple;
	bh=kON6HUGmUgYLxRRJ0S8Z3HHLshtp9BfTE/UxoH0kH1s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=djo1QTfj3ujVtukUDx3m2gb4U9m/EMElKehJrQk3ZbHs+ktxenIBTsfbwXOFqlsfLuUG4Q73qq098PJ+Fb1/PtDOqiZNEv3Ch3AYnuSY7wcR3lXfdvsgIFijKm3lGUeZuRaz4HhYhEfym2rhy7CZ+RyCtANskQBwP5ILL3xQ6iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t3ySX4Rz; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t3ySX4Rz"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso18951cf.0
        for <kvmarm@lists.linux.dev>; Tue, 29 Jul 2025 09:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753808184; x=1754412984; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1/uIe95x5lZqYdBnQQKG7OEQU1TEeF9VXSEERIroTJo=;
        b=t3ySX4RznM2dbubu3MtigpDfK0wXp1ZGyQWvdCMwKJ13t7KX7/aC5yz8LJWby3eYW8
         cE/6cer3YSlMvC4QidKTlSj0dRWvvYi/5hUtXypwVPxWTclFm6xfSxSUEBLMHkcTS8I+
         tx6tYiM/4Dqqox78Oih2uDObvlUJhnQKTkF+Ji5bmah4A2uyIpgnB1Abp86uaVeL2V2E
         EhhjM7nCcF53hSlP4G27XLGmt/HgyuHirCmAguscAKQMlYJZZx4Ct7F3ov9bUVv5DdfW
         7Fbfo/aJ4lJT7sDxAWvtHEAWMMvmWWkrZX8jvRpvV9VIurWPYXe/duLn9ZasGmU6cfxi
         Sdyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753808184; x=1754412984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1/uIe95x5lZqYdBnQQKG7OEQU1TEeF9VXSEERIroTJo=;
        b=bHk8Fm4h7FcuXEjmDEyQtsakSZxI4BGK3ZBHPl04tcn9xZNXbF1MdhchbjoW/jyNqF
         A0qRs7WWPcJR/JpVLO7N8hhkfS/80KbWKjNPgw3MOBVYayjdsyWB6pTko3OLR/iUA1Hy
         HmcyOqnj8UXOIKEk942uTk2GN4bg3LIstYmPiXsAuHebwkdccPd4jFqqEv2GEGbcA/91
         kZsTkqPySrCdwq1+m2R1jmTz7Lz9C7JjBrdCfBBJUYO7FFpAGQYqbFac8RlwcP1JxNsH
         AnTH5o7MiKeYlA24azY87Vr5CksFlf7F/dnMTJgGWP1gJZyzVKfKe37QztHZ90dY7hfU
         bO2A==
X-Forwarded-Encrypted: i=1; AJvYcCUL1pQc1c2+9fXtIbs30MGZ4FzeYBgEQpgIwsEPhecLxfyNtcpFHDpdyYB07V7ei/5OTAersYk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7PPL8+kcrJLYZ2+s/f9F9cnIeq3cqHfPAAUqjpv1icm99zC2n
	XC5ey0Ftmwyjrdb7m03H/QUq8/aVDE/dCtQcz4EdnGRyEIspwvT6SpqZTP/HrHiAsexKyZp7lb5
	nIvp9Ekvyt7Jgo6qWJc6ec2woyVJNXCk2WTL978Da
X-Gm-Gg: ASbGnctwE2dbvFiDdbM3Qhf2HZ458p2HM7d/JnPlp8RBWi7UmT5rNN1QxGpDsB0/SPN
	BsJzHCiLywl305LYdvkNWtNmjr+LJ1GozZ2F9G0KUdm5DKrqd1RtiFbeyZjIdKFwPca7AybeouV
	VX6fRSTppZlJA3qhHI7qB5UQ85t9YVLd6i1DkUdwrELgCu8rOxNdCQGeuQJjFDhoEBy8cCSpz0i
	1Rbzz4=
X-Google-Smtp-Source: AGHT+IG8U03UpiLYKbtFizbKfv9yB5x8yYCq7RDDBBmKtZwiOn8gG/X4U3tVssvjQCIruMENSE23SwYyH5DXYbZYSsw=
X-Received: by 2002:a05:622a:1884:b0:4a9:e34a:58a1 with SMTP id
 d75a77b69052e-4aecf9d1b90mr4112341cf.21.1753808183683; Tue, 29 Jul 2025
 09:56:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250728223710.129440-1-rananta@google.com> <aIjcmquPNOdE5l4K@linux.dev>
In-Reply-To: <aIjcmquPNOdE5l4K@linux.dev>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Tue, 29 Jul 2025 09:56:12 -0700
X-Gm-Features: Ac12FXzGVONWVZtJXMRcendx58YZR793CWu4R9YnCYvWGKAJQzZFsbX55XCdkxs
Message-ID: <CAJHc60xPKgVn96azWhP1NbfKioEZj68APQPf=zKRMuHB7-goqA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Set/unset vGIC v4 forwarding if direct IRQs
 are supported
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2025 at 7:37=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Raghu,
>
> Thanks for reporting this so quickly :)
>
> On Mon, Jul 28, 2025 at 10:37:10PM +0000, Raghavendra Rao Ananta wrote:
> > diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v=
4.c
> > index e7e284d47a77..873a190bcff7 100644
> > --- a/arch/arm64/kvm/vgic/vgic-v4.c
> > +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> > @@ -433,7 +433,7 @@ int kvm_vgic_v4_set_forwarding(struct kvm *kvm, int=
 virq,
> >       unsigned long flags;
> >       int ret =3D 0;
> >
> > -     if (!vgic_supports_direct_msis(kvm))
> > +     if (!vgic_supports_direct_irqs(kvm))
> >               return 0;
> >
> >       /*
> > @@ -533,7 +533,7 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, i=
nt host_irq)
> >       unsigned long flags;
> >       int ret =3D 0;
> >
> > -     if (!vgic_supports_direct_msis(kvm))
> > +     if (!vgic_supports_direct_irqs(kvm))
> >               return 0;
>
> I'm not sure this is what we want, since a precondition of actually
> doing vLPI injection is the guest having an ITS. Could you try the
> following?
>
> Thanks,
> Oliver
>
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgi=
c-mmio-v3.c
> index a3ef185209e9..70d50c77e5dc 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -50,6 +50,14 @@ bool vgic_has_its(struct kvm *kvm)
>
>  bool vgic_supports_direct_msis(struct kvm *kvm)
>  {
> +       /*
> +        * Deliberately conflate vLPI and vSGI support on GICv4.1 hardwar=
e,
> +        * indirectly allowing userspace to control whether or not vPEs a=
re
> +        * allocated for the VM.
> +        */
> +       if (system_supports_direct_sgis() && !vgic_supports_direct_sgis(k=
vm))
> +               return false;
> +
>         return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
>  }
>
> diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
> index 1384a04c0784..de1c1d3261c3 100644
> --- a/arch/arm64/kvm/vgic/vgic.h
> +++ b/arch/arm64/kvm/vgic/vgic.h
> @@ -396,15 +396,7 @@ bool vgic_supports_direct_sgis(struct kvm *kvm);
>
>  static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
>  {
> -       /*
> -        * Deliberately conflate vLPI and vSGI support on GICv4.1 hardwar=
e,
> -        * indirectly allowing userspace to control whether or not vPEs a=
re
> -        * allocated for the VM.
> -        */
> -       if (system_supports_direct_sgis())
> -               return vgic_supports_direct_sgis(kvm);
> -
> -       return vgic_supports_direct_msis(kvm);
> +       return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgi=
s(kvm);
>  }
>
>  int vgic_v4_init(struct kvm *kvm);

Yes, the diff seems fine (tested as well). Would you be pushing a v2
or do you want me to (on your behalf)?

Thank you.
Raghavendra
