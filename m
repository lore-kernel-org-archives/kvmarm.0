Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B15329373
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 11:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763380132; cv=none; b=cbH90LCqbgVOnAslACV6Dc9aRl3za2QxK/5i/ZojiDr5LTb2/Oqi7IHBUuEvEPR8ZuJJ+2OhgEc2pyAEvXVvLpWAysjxeuh+B6c3PDtDmhCXv2FWHFXjer3/6P2bscaDww2Mq6+3XK0f+URhkc2GHie0wL+oQPydovnziehxpNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763380132; c=relaxed/simple;
	bh=sRlq8ZsHJ8wENkGdYQx+aafifaQb0Y8TbYSZjuDARps=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OhDYzM4gL7dEKnP/2YMcCL57Bux6leb60qWtLYt4FhGupyE1BtvSrWhq4BYXspT3gjXVpf7p2aCE6HeqCcjCTZr6UB/cJIOeZHMFQs9zUlLkHwre2L3lmHsUwi49IRT1C0FOorvuK++NYykXDciHxEx2e2ucgTIIU9+4JRov8ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1jkt4Sj+; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1jkt4Sj+"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ee243b98caso191311cf.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 03:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763380130; x=1763984930; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wtFMwliyeURMAMFY1byC+UBdCK6dtQy078PTE9BuABk=;
        b=1jkt4Sj+THzaUhxLkOBrjKViPCXffvl3Z83dMrVT9vICh4KUcTKrjxS1vntVBX6d4y
         VcLmmWbFwVHHbvrAEwP47YFhfglxXanLwHjJhetaLbHD4Jvtd4Qkyz9BxO9pxIhID2c+
         cB0T1IIdwvrxq4u7yWAlwlnM92sicjf6JlyDB3F0N948qRuiUTakTIVGwt7Edoo7czVl
         OqM9BUc23ZSSvs0hIB2xxGEWK1bhPPGcdQacRQl/6Wz+4Hdu9C1FebwHES05FYrp1LyG
         UZ3PmpTH0LM2ue/3AQXvfUtq7mwET9tS5WcFmgHFmleUVd4ULvZPGc6Tn8OcTokA4skH
         01Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763380130; x=1763984930;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wtFMwliyeURMAMFY1byC+UBdCK6dtQy078PTE9BuABk=;
        b=faIz7UCz+g+RAsetETU9oN5l50wtx3nENaIR3MkCWPC7wqYGCAuShVqFeXL3BcJnEF
         daVG0JGVWmsEMyLY3FkhdP7bUHlcMF2AbtgDycRmGelEE+QQllRxs5XoE5n1Xoo5qHfx
         7eQP2VMVF+JUv08GlFnn4O0/k/LL1A0Hj7G5eKjw726ffMYannRa0l0irTE2D+EoefL6
         xhO/QBen4UBw0FMfboudhhu/iyiJvaiyqc/Ho942sK8EyrvEQScII6CeE59GJZyDb4Y8
         7lZPAiqEgrttL9p/hqTlj0rSlyPa1ormYmKkz+9apNCgcwdUqcBDEp4hNKiiEakLx6Fp
         WHVA==
X-Gm-Message-State: AOJu0YxzKDRNbF1JFkRW9YKasVv3UaG1R/m+jFaPmpLeY5IgE6XbB/dn
	iMYrVA0ASv27vqvT+mVnOd2NaSu762bRVb7SJdTzWhE9V+sKBBrJRT5mxhIE5HJIbZB7MmDfmKy
	TBtj/bB16wLVjScy12hOLC1kmpynqTlzhLHnLj2pq
X-Gm-Gg: ASbGncvnZ+cdmJHW61MJYjvdCdMuZDjzpVcmZMWb1EYHUdE5kSt+QXScK4xAGxN/nSp
	pBh/aI0xyGt+lGB+YDn87Y4nQu8tlAilowXB0WoxrnydinXPFipn0l6yz3+N5gG0fHgzJKmX/Zr
	EBpLfFfUHox0woh0Irl1nM+SmeFYOQBVIbVfI8EnMYGTBgByL+RE62RK+lNtA+u25mJo+YCsf63
	4itJKildS6SXlcYdx2LiNf26gSAiW87C3hzHDLu8y7tfmD12boPeSXFCQ6Km91P8omU/Hs=
X-Google-Smtp-Source: AGHT+IEHIBrDsl1tNBXJlZjvy3Cf3bvvIt0plNzv8yp90Dy54B0sd0uogGQ1BYNz1nQ2J5pl3F6LJlVNsJl1l4fGJHA=
X-Received: by 2002:a05:622a:4f13:b0:4ed:ff77:1a87 with SMTP id
 d75a77b69052e-4ee02a994a9mr8359641cf.19.1763380129366; Mon, 17 Nov 2025
 03:48:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251117091527.1119213-1-maz@kernel.org> <20251117091527.1119213-6-maz@kernel.org>
 <CA+EHjTxVr7uk8Ofhb2VHjDw+LfC4ZSz4dDun5+xLcnRQy5AKaQ@mail.gmail.com> <86346cubqo.wl-maz@kernel.org>
In-Reply-To: <86346cubqo.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 17 Nov 2025 11:48:11 +0000
X-Gm-Features: AWmQ_bnWedPYEhHQPg2C4X-v3VYqSp4JpRxkKgnh4axAij7gQDfBobnagYWNTiE
Message-ID: <CA+EHjTxB6qf80zLYQJnpr=beJWg2CiqcbTwPhodgtBceEGLVUw@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] KVM: arm64: GICv3: Force exit to sync ICH_HCR_EL2.En
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 17 Nov 2025 at 11:42, Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 17 Nov 2025 11:35:18 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Mon, 17 Nov 2025 at 09:22, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > FEAT_NV2 is pretty terrible for anything that tries to enforce immediate
> > > effects, and writing to ICH_HCR_EL2 in the hope to disable a maintenance
> > > interrupt is vain. This only hits memory, and the guest hasn't cleared
> > > anything -- the MI will fire.
> > >
> > > For example, running the vgic_irq test under NV results in about 800
> > > maintenance interrupts being actually handled by the L1 guest,
> > > when none were expected.
> > >
> > > As a cheap workaround, read back ICH_MISR_EL2 after writing 0 to
> > > ICH_HCR_EL2. This is very cheap on real HW, and causes a trap to
> > > the host in NV, giving it the opportunity to retire the pending
> > > MI. With this, the above test tuns to completion without any MI
> > > being actually handled.
> >
> > nit: tuns->runs
> >
> >
> > >
> > > Yes, this is really poor...
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/hyp/vgic-v3-sr.c      | 7 +++++++
> > >  arch/arm64/kvm/vgic/vgic-v3-nested.c | 6 ++++--
> > >  2 files changed, 11 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> > > index 99342c13e1794..f503cf01ac82c 100644
> > > --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
> > > +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
> > > @@ -244,6 +244,13 @@ void __vgic_v3_save_state(struct vgic_v3_cpu_if *cpu_if)
> > >         }
> > >
> > >         write_gicreg(0, ICH_HCR_EL2);
> > > +
> > > +       /*
> > > +        * Hack alert: On NV, this results in a trap so that the above
> > > +        * write actually takes effect...
> > > +        */
> > > +       isb();
> > > +       read_gicreg(ICH_MISR_EL2);
> > >  }
> >
> > nit: is it worth gating this with "ARM64_HAS_NESTED_VIRT"?
>
> This is in a *guest*, which knows nothing about being virtualised!

Nested makes my head hurt :D

Cheers,
/fuad

>
> > Otherwise,
> > Reviewed-by: Fuad Tabba <tabba@google.com>
>
> Thanks!
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
