Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA0620B0E
	for <kvmarm@lists.linux.dev>; Fri,  8 Mar 2024 17:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709920126; cv=none; b=BxOOw6CnKXzUdY4evbLKliR8ecBEBGePzIpHKmR/VCGmaRkNN4SBCijZ7/NCKQ/zavveFIN1WgsLo9WNPaA6KsmTAfYxuwl+7PC97taS3/2+UfaMxZ+UvR8xKyyJqHdV2YayaSJA/fFOxaet1weE+FrqvwPUiF++Kt+s0wFRkto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709920126; c=relaxed/simple;
	bh=eg7AYpEbK2NlGF33NSqJViSum65hZETVGpUibsACD4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hvcl2C57aeZjAlWL5rWt2VE+mHNJ93BcdpxsYsBfLnSdHL9vQzF2Oy3Chl1wqZVpnKTtDPMgYJathmO+5DT89VeI4bdNpqwcDP3S7QI7ZviZDVkADWy7Z0xoVH2SSaCsG20uCF1iAGkPQtbPwR9FHwbnSNqdmKFfveohz2q8UA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CtoyRC1A; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CtoyRC1A"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2d33986dbc0so24918991fa.2
        for <kvmarm@lists.linux.dev>; Fri, 08 Mar 2024 09:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709920123; x=1710524923; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eg7AYpEbK2NlGF33NSqJViSum65hZETVGpUibsACD4o=;
        b=CtoyRC1A+OjTAtFbNFtVLaNbd+PI8bAY+770GrbJTjhnMEgunPV7pXsdIj+2dQKo9p
         QS+vapucEZqs4AtsIH8nCIPNpTx1PO6OeQ6JnPZSOB5xGEDLBT0DzPHOFaDezUjsjPrH
         RvNH8MN8+N+O73ppSWJdWBAJQj0Mr1yBCPPgi7A/YAOr3QrEIK3ftqob+ey3zWEZzpEJ
         Z+xq0hXZNVGXniCIo3QsUIiuwR8Cda1biipveDCL0fvEBJDo577cIg/d0HXJPO7dD2+N
         p08ZMAqFo+qUS/S6/Oru7cIs3QRQf1ff2rvi1TLhvmzGUbSWGK4zcFi5Tqi0wzh+KUNn
         Ldlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709920123; x=1710524923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eg7AYpEbK2NlGF33NSqJViSum65hZETVGpUibsACD4o=;
        b=UxIvmLWOdz31A5witNewYnB5VN5CU43lOP5UYcQq0UasnAJN5flfERuGX6fMj2/0MB
         gTt/vv4g75w1IG0BQ7oRaipqkPiFLVeHE8eZOcFqGThMLqSFtK7wpuIzXJGfdb9QZqOr
         SNtzErJavITkPjuhfhJe/XsUKXdyZ0EuBVfCniMBwpqkG+26QqhrhkjoCTD9wOG+HHAR
         lOqtL2vkC9J7uOU8F3p18qD4ELIJmTYP94LPmP0CO2hyI7YugySnMe6GnisG5kNM7XU9
         E9yteeQxIDQFEe7rnHc/ojDmR0jeluweRBJOsxZSvLEg70m7hWNkYnwUn4rtXb/A1zYO
         mlpA==
X-Forwarded-Encrypted: i=1; AJvYcCVmIbTxrDQOImvMljVr5VtUCRvbPVsYos89hgC4xvC9KUPvM9VI0Qh4sMl66sZ+WEKpDfYr3SxA3VFQRfMgAk6PWGS57/Cb
X-Gm-Message-State: AOJu0Yy3oi4ExX1ng4cstzl5495NcIEd+Nxxrr1cAHeHKnxrGXoHIhDf
	lZB6MzZFcpI5kKnTz0KNBAef5GUvwUhGhCK8h5pry00VOsJ+KKN7mg2NTnn0L8Sk8X+IBgNhmoU
	iKx/9Bl5lbqEyub/vtvxXcnfSxeKwGNX0dhRo
X-Google-Smtp-Source: AGHT+IEPBynRMHTbGiNCHfkAEBAnFTM/utzuMZjv9yJKypOxhApm2NaGzLIYnTTQ7vfOdVVpvnnq2R66XM2GgBR0Hb8=
X-Received: by 2002:a05:651c:1049:b0:2d2:4474:2e69 with SMTP id
 x9-20020a05651c104900b002d244742e69mr4074164ljm.9.1709920122526; Fri, 08 Mar
 2024 09:48:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231207150804.3425468-1-james.morse@arm.com> <ZXoTG1Y4O16Cjq39@linux.dev>
 <f06ed418-922d-54c5-22a0-bde127146b5a@arm.com> <ZbAMxyGcSZY7Kl7Z@linux.dev>
In-Reply-To: <ZbAMxyGcSZY7Kl7Z@linux.dev>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 8 Mar 2024 09:48:30 -0800
Message-ID: <CAAdAUtgr-AmQKUhAf4Dbg+jurzzDJ1xCzJkptwACuWAnZv_d_A@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] KVM: arm64: Hide unsupported MPAM from the guest
To: Oliver Upton <oliver.upton@linux.dev>
Cc: James Morse <james.morse@arm.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi James,

Will you have a new version for this patch series?

Jing

On Tue, Jan 23, 2024 at 11:06=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Fri, Jan 19, 2024 at 05:15:59PM +0000, James Morse wrote:
>
> [...]
>
> > > We've already done something similar to hide our mistakes with IMP DE=
F
> > > PMU versions in commit f90f9360c3d7 ("KVM: arm64: Rewrite IMPDEF PMU
> > > version as NI"), and I think MPAM may be a good candidate for somethi=
ng
> > > similar.
> >
> > As there is precedent, I feel less dirty doing that!
> >
> > This also solves the problem of the VMM re-writing the broken value aft=
er the vCPU has
> > started running, and getting a surprise error. A weird side effect of d=
oing this would be
> > you can write MPAM=3D1 on A53 and KVM will ignore it, I don't want user=
-space to start
> > relying on that! I'll add a final-cap check so this can only be ignored=
 on hardware that
> > actually has MPAM, and could have been exposed to the bug.
>
> Ah, good idea. I probably should've done something similar in the PMU
> case.
>
> --
> Thanks,
> Oliver
>
