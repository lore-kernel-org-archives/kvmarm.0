Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39D637FF4F
	for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 10:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769682695; cv=pass; b=M+YWZoizKK8YUouKOxCUFBmrcdqaYXON9LMddrzTEqAVRFvmHNM3fkqVhubadfqBjbB/ATgxeADgtEG75/J6MKkGeCyq/H+6sK52Rz416joemJN/+KhR19paEZz0AcDg7UymB0CoodGF3oqqo6kOWMWwvWCeReAcOdVqDGueqWk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769682695; c=relaxed/simple;
	bh=kvQm0PMPge02EX/21kcgDn7eBjAxgiKovy6R6OS32r8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A6oOsd1DjUCYX2zje8ROQ7DPKzHV7kS7brITkEPKMSJ+jvXBdss14Ihwtta4jGCMxyu/TwkCRhPiriwmtgX4fZX038oPpa011Do6VaVPmxH4kPqMmW2MG8GSeVIvyGuwLgImAwcUyHltE8weISPddVQQ2Hm/CYezJOf9MDLuOBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L/YIKZJ8; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L/YIKZJ8"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5014b5d8551so317271cf.0
        for <kvmarm@lists.linux.dev>; Thu, 29 Jan 2026 02:31:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769682693; cv=none;
        d=google.com; s=arc-20240605;
        b=gzG/p2qZjfCxvCeb5LIHmGi+9c7svQ59Z+q5UdtV4eAzHdkL1o4t+ro8DYqwEAkDUB
         OaCgKgn0yWTxvXxmr6XkN3q1WCyCmOmZosF7WyjcfUa1DK2Fi4T8SngJuGT04k0q4dgw
         sKZ5lgSXOS7tSr68GyVVmL4JjQduJ6XDFI9wjN9mq14QMoAhNCCbD1fnNM26QTpgyD63
         JALFLd8N4bN5cPWK9r5xbkT9OXzWVij3EBuMzkzuWt5Pv1+fuCEAY61N/huAgIDzy6dz
         Cd8CnUIF35vZOoVPGVmV0lsEb32O0LdoTtMsfy5mh1RrPq5scymcvsYIWgE7aFjJ0CzR
         BdRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zO6ULjWkwKOa6nt1pqPrr7dCq2tIVIRxD42Sn5fil18=;
        fh=cKTbDbQYTc+pleUDsHasQv4LjIooAs3OE4CRw2/lzRk=;
        b=GEBAnyuEPqPqViMqcEshpzMbF6mCY+Fq6+0EeVvV5T83WlXgznjYvwUb0TzHJ085L2
         u+ftPnwQzdrM7uNIFCJk0iR8dP3tbJpTXsDxzCe8ZVPk4TrJ2soapW+XMBNRxtppr9xp
         omIiVcSd9Lsx/Zc5bUP3RvbC5FWoYTn9t41qfOWVT1g8pO+PjGuI5ad/rkKvNKsYBQON
         IB5QKp9VIU3d6zLYC+dLAvqTxXrtvRERMOy8nD4ykAbp1WQ/nyYMEfNC63UcJar0vx81
         0pCqqbnhL+D1aNGgLH6L5Ky4f04U0lx0vmiSmU7hW4FGFvuz/+yrkJTPxaWUWI99b0jM
         GSvQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769682693; x=1770287493; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zO6ULjWkwKOa6nt1pqPrr7dCq2tIVIRxD42Sn5fil18=;
        b=L/YIKZJ8AMu4OzqeyhdND4H8EZWAnad44Ao5WGkQoHJdsZHDer4Zz0CP2SCOpOBn9L
         UUOyfkoPJ/ksxr0201BaF5Ohvtl81fh20HCPnU6dvKbufCeTqNw6QUWmVf/BnqcLvZPX
         rvmlnKp+U3U9+L13drfAUxL0T+1rEwWzPq7BXpU5Zw77iz4/5/woZeiRmH8KYqx8wxRC
         i801QbIx0ukp14m5cY6jTWw5Yx8fduPhrq6bXnXUGJtzi/AO+ksfG4a2nFn0bE+5wGIG
         M9yC4kfu/C57rRcEzIqKo8macTGd7IN4YrB+O/ycyU7d+Lms7ysuJwcwEWqyxI/oUWoZ
         D2cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769682693; x=1770287493;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zO6ULjWkwKOa6nt1pqPrr7dCq2tIVIRxD42Sn5fil18=;
        b=V2xXEetq4T4Cz84Jn5aMOwENJRSOqYtdsTjRVvUMwD7ecO28pQP8lNHBcRvZOilD/G
         KwWYSVeXtrAs58Va4RaVIuWdtobHhqRtWAdpEVQulDxNO/zfjpld1HltX1BLtFqYPdAh
         tjK9zEsxs5Pq4hB+buVfYFkiDM4l/OKwaIgD6aw93zsTx32AyTcokvugmkSC0uOTGIDV
         Ed0+5ZGbxD5kABu/r6MfNmCp1Pl6kWnW/0iBw6Cym16jqieVEBVf5bC1jnNubPvAJ/Vs
         TLASgl6/JnQLHilh2Wu3foLjEJdp+bTT/MXDzqL1cSnvUukoep4U6ZNUnHd5F4T6mdCJ
         cUeA==
X-Gm-Message-State: AOJu0YwhqXHWE1UfA+o4ywFAarNgJ5SQCD46qjCz+GoM9bBuZgF3Gfuj
	hKIS5EnodpYxZPUgsvqHGuMO993yFgS0FZdlIYf3qntSxKL1h6biC2nH7Z9bsdGGXEV+LV37HXG
	XbsQs/6KZRgm+BufQ4JKKDNqIVVP5qoOHabpJ+T4H
X-Gm-Gg: AZuq6aJnz4KkO0P/RdxYmUx6NU/UdIcv7FcFXjRAe0jSKetad+vdfViOqfRij16IARp
	IMcwwfLyJ1kceVdOtV2ya7Lg+YVOXuEVk7stFsDAaikpX6jdvxpMMHRqO12YxDofwRxbXK06h8b
	NELFEBhE2OC1lfxR5GDFEyStGd9zm6Qz8Pfm90oV8Mn08ZDDfAqq5boKzMFmGy5mnbtIFc40iu6
	SWwv2C++Z8Pp8HVwkKTGgSjyWxaDNT20NKSwb1dV4/Fgms4bVfgza1Nt/yMPSoa3f+Vc8eW
X-Received: by 2002:ac8:7c47:0:b0:503:2d8f:4cd9 with SMTP id
 d75a77b69052e-503b67573e4mr10564691cf.16.1769682692446; Thu, 29 Jan 2026
 02:31:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260126121655.1641736-1-maz@kernel.org> <20260126121655.1641736-13-maz@kernel.org>
 <CA+EHjTzL6bNZ=sZoub3GY=VZ2bJ+4bFr4jkuiMMBCEqXuAkQPA@mail.gmail.com> <86bjicbu9f.wl-maz@kernel.org>
In-Reply-To: <86bjicbu9f.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 29 Jan 2026 10:30:56 +0000
X-Gm-Features: AZwV_QgqI3U9H1Cbj8nMPhTIPfiH9Gdegl3zrhuYCGMvoUDbuda-PJQ9wfvc9AI
Message-ID: <CA+EHjTwjTa6QbKONdSNKR2GP8L8qy2q8yF-eyomQBkamUykc+Q@mail.gmail.com>
Subject: Re: [PATCH 12/20] KVM: arm64: Add RESx_WHEN_E2Hx constraints as
 configuration flags
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Thu, 29 Jan 2026 at 10:14, Marc Zyngier <maz@kernel.org> wrote:
>
> Hey Fuad,
>
> On Wed, 28 Jan 2026 17:43:40 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Mon, 26 Jan 2026 at 12:17, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > "Thanks" to VHE, SCTLR_EL2 radically changes shape depending on the
> > > value of HCR_EL2.E2H, as a lot of the bits that didn't have much
> > > meaning with E2H=0 start impacting EL0 with E2H=1.
> > >
> > > This has a direct impact on the RESx behaviour of these bits, and
> > > we need a way to express them.
> > >
> > > For this purpose, introduce a set of 4 new constaints that, when
> > > the controlling feature is not present, force the RESx value to
> > > be either 0 or 1 depending on the value of E2H.
> > >
> > > This allows diverging RESx values depending on the value of E2H,
> > > something that is required by a bunch of SCTLR_EL2 bits.
> > >
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > ---
> > >  arch/arm64/kvm/config.c | 24 +++++++++++++++++++++---
> > >  1 file changed, 21 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> > > index 1990cebc77c66..7063fffc22799 100644
> > > --- a/arch/arm64/kvm/config.c
> > > +++ b/arch/arm64/kvm/config.c
> > > @@ -26,6 +26,10 @@ struct reg_bits_to_feat_map {
> > >  #define        MASKS_POINTER   BIT(3)  /* Pointer to fgt_masks struct instead of bits */
> > >  #define        AS_RES1         BIT(4)  /* RES1 when not supported */
> > >  #define        REQUIRES_E2H1   BIT(5)  /* Add HCR_EL2.E2H RES1 as a pre-condition */
> > > +#define        RES0_WHEN_E2H0  BIT(6)  /* RES0 when E2H=0 and not supported */
> > > +#define        RES0_WHEN_E2H1  BIT(7)  /* RES0 when E2H=1 and not supported */
> > > +#define        RES1_WHEN_E2H0  BIT(8)  /* RES1 when E2H=0 and not supported */
> > > +#define        RES1_WHEN_E2H1  BIT(9)  /* RES1 when E2H=1 and not supported */
> > >
> > >         unsigned long   flags;
> > >
> > > @@ -1298,10 +1302,24 @@ struct resx compute_resx_bits(struct kvm *kvm,
> > >                         match &= !e2h0;
> > >
> > >                 if (!match) {
> > > +                       u64 bits = reg_feat_map_bits(&map[i]);
> > > +
> > > +                       if (e2h0) {
> > > +                               if      (map[i].flags & RES1_WHEN_E2H0)
> > > +                                       resx.res1 |= bits;
> > > +                               else if (map[i].flags & RES0_WHEN_E2H0)
> > > +                                       resx.res0 |= bits;
> > > +                       } else {
> > > +                               if      (map[i].flags & RES1_WHEN_E2H1)
> > > +                                       resx.res1 |= bits;
> > > +                               else if (map[i].flags & RES0_WHEN_E2H1)
> > > +                                       resx.res0 |= bits;
> > > +                       }
> > > +
> > >                         if (map[i].flags & AS_RES1)
> > > -                               resx.res1 |= reg_feat_map_bits(&map[i]);
> > > -                       else
> > > -                               resx.res0 |= reg_feat_map_bits(&map[i]);
> > > +                               resx.res1 |= bits;
> > > +                       else if (!(resx.res1 & bits))
> > > +                               resx.res0 |= bits;
> >
> > The logic here feels a bit more complex than necessary, specifically
> > regarding the interaction between the E2H checks and the fallthrough
> > to AS_RES1.
> >
> > Although AS_RES1 and RES0_WHEN_E2H0 are mutually exclusive in
> > practice, the current structure technically permits a scenario where
> > both res0 and res1 get set if the flags are mixed (the e2h0 block sets
> > res0, and the AS_RES1 block falls through and sets res1). This cannot
> > be ruled out by looking at this function alone.
> >
> >   It might be cleaner (and safer) to determine the res1 first, and
> > then apply the masks. Something like:
> >
> > +                       bool is_res1 = false;
> > +
> > +                       if (map[i].flags & AS_RES1)
> > +                               is_res1 = true;
> > +                       else if (e2h0)
> > +                               is_res1 = (map[i].flags & RES1_WHEN_E2H0);
> > +                       else
> > +                               is_res1 = (map[i].flags & RES1_WHEN_E2H1);
> > ...
>
> I think you have just put your finger on something that escaped me so
> far. You are totally right that the code as written today is ugly, and
> the trick to work out that we need to account the bits as RES0 is
> awful.
>
> But it additionally outlines something else: since RES0 is an implicit
> property (we don't specify a flag for it), RES0_WHEN_E2Hx could also
> be implicit properties. I couldn't find an example where anything
> would break. This would also avoid the combination with AS_RES1 by
> construction.
>
> >
> > This also brings up a side point: given the visual similarity of these
> > flags, it is quite easy to make a typo and accidentally combine
> > incompatible flags (e.g., AS_RES1 | RESx_WHEN_E2Hx, or RES0_WHEN_E2H0
> > | RES1_WHEN_E2H0), would it be worth adding a check to warn on
> > obviously invalid combinations?
> >
> > Or maybe even redefining AS_RES1 to be
> > (RES1_WHEN_E2H1|RES1_WHEN_E2H0), which is what it is conceptually.
> > That could simplify this code even further:
> >
> > +                       if (e2h0)
> > +                               is_res1 = (map[i].flags & RES1_WHEN_E2H0);
> > +                       else
> > +                               is_res1 = (map[i].flags & RES1_WHEN_E2H1);
>
> While that would work, I think this is a step too far. Eventually, we
> should be able to sanitise things outside of NV, and RES1 should not
> depend on E2H at all in this case.
>
> I ended up with the following hack, completely untested (needs
> renumbering, and the rest of SCTLR_EL2 repainted). Let me know what
> you think.
>
> Thanks,
>
>         M.
>
> diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
> index 562513a4683e2..204e5aeda4d24 100644
> --- a/arch/arm64/kvm/config.c
> +++ b/arch/arm64/kvm/config.c
> @@ -26,8 +26,6 @@ struct reg_bits_to_feat_map {
>  #define        MASKS_POINTER   BIT(3)  /* Pointer to fgt_masks struct instead of bits */
>  #define        AS_RES1         BIT(4)  /* RES1 when not supported */
>  #define        REQUIRES_E2H1   BIT(5)  /* Add HCR_EL2.E2H RES1 as a pre-condition */
> -#define        RES0_WHEN_E2H0  BIT(6)  /* RES0 when E2H=0 and not supported */
> -#define        RES0_WHEN_E2H1  BIT(7)  /* RES0 when E2H=1 and not supported */
>  #define        RES1_WHEN_E2H0  BIT(8)  /* RES1 when E2H=0 and not supported */
>  #define        RES1_WHEN_E2H1  BIT(9)  /* RES1 when E2H=1 and not supported */
>
> @@ -1375,22 +1373,15 @@ struct resx compute_resx_bits(struct kvm *kvm,
>
>                 if (!match) {
>                         u64 bits = reg_feat_map_bits(&map[i]);
> +                       bool res1;
>
> -                       if (e2h0) {
> -                               if      (map[i].flags & RES1_WHEN_E2H0)
> -                                       resx.res1 |= bits;
> -                               else if (map[i].flags & RES0_WHEN_E2H0)
> -                                       resx.res0 |= bits;
> -                       } else {
> -                               if      (map[i].flags & RES1_WHEN_E2H1)
> -                                       resx.res1 |= bits;
> -                               else if (map[i].flags & RES0_WHEN_E2H1)
> -                                       resx.res0 |= bits;
> -                       }
> -
> -                       if (map[i].flags & AS_RES1)
> +                       res1  = (map[i].flags & AS_RES1);
> +                       res1 |= e2h0 && (map[i].flags & RES1_WHEN_E2H0);
> +                       res1 |= !e2h0 && (map[i].flags & RES1_WHEN_E2H1);
> +
> +                       if (res1)
>                                 resx.res1 |= bits;
> -                       else if (!(resx.res1 & bits))
> +                       else
>                                 resx.res0 |= bits;
>                 }
>         }

LGTM. Treating RES0 as the implicit default simplifies the logic and
makes invalid combinations impossible by construction, which is what
we want, as well as being easier to read.

Thanks,
/fuad

>
> --
> Without deviation from the norm, progress is not possible.
