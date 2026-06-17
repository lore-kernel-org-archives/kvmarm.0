Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73D026ED3C
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 14:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781707952; cv=pass; b=dQAwl+TM1pHfXOe/nKZ69YBBTcWujFoaCho3z0AWnpj6Jhtxna+ohgLJxG6S74NTmVb9cn/5tah2w3pQGAEwMlpiK8kfEZ6mLXwJPmBQaOG4rT8omTh6cEiirAdcOnGLn9kTDBmN+IW5lgoL1GTmEPJjX9kXSITvi6BuY5u8Nuc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781707952; c=relaxed/simple;
	bh=svG5VUeLWXcFadC9nMYewsobyw3y4iSJPkBxx3gavIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i/De9QGGoV+kEgXg+QUCkzWrkAPV4cWUmVZRG7CmH5hbp+2Ge0vv/U1H9GsHnw/12Bt+XimRIfja02p4F23ocw9R2TA8vihmmvoSl73yRi7PmEU2IwTCpoG1uNqp3SqKRKTSZOyEGsSyElQweU62mdpBBgFir1Gjn8lYUI69MOU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IdZWu9pj; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IdZWu9pj"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51765531803so311161cf.0
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 07:52:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781707949; cv=none;
        d=google.com; s=arc-20240605;
        b=VQFpt/6/r8qGLqiFmgi5nV+nwzfgjmbX+i0W5o1oJOPN2fHY63R8HL6lJ2l52frQ5I
         8rpZUElDPPxd5PwXIibchesGMmfyVVw3Yg7gVzK3J5VztbGCxTWtmYC0b4ap34UeV2DV
         +lNfXng7FlDdBgvAs9bQiLVtkZzPFkOuV849hBIgpb4DkvYbk4PxIA/Pz7GzRfL/sRjT
         k0tsq7OoHm9+9a08O3nkeWKri7xxucMM++koVU+mW+KLYXSOeUSABD/gJTLLs4Slgfpe
         64cy+M/nzShNWl+afhwQ1f620Q2YaOFd2fEL+2w+N+v0yNzGmUnvhclUEY04N7SxZLeT
         w1DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=rRL5oribGYZKW3GCbWudAKMbSR10/FVZtjDSZUF5qUc=;
        fh=j6ypZro6JR7BSWFtEq+9Owqc8URAISbTEaWLS30iv1c=;
        b=crGFVlJsHCn9kJelGJwIXc8PnHb/CPcxqnajzsZza55cd/ZXWXaW1LaMiDnx4uH6IJ
         cgrQTpeZHKjkaOLCW11bYhDO3izxkUd+HEC0mWRuuj5YHc3SIYLygX3EEI3GPQmhEmlh
         9AFBUxLdZ/PIcbF24ZcR2YXNzPa5mAwWFttTyadn1f/OsWYh8Yd6dPBsgYK3OCGrkJI7
         GOBok/lyiPKRKdPYoROdWBgGHf+ds+qgSUByI20eamkS6YBTlCrAXr0Gp76XmV2JU+U3
         k28uIqH/vkU802zrVM4i59iBEj1tdP4JPcgiC8ctPApuVLXKW912MKdjweOFWnmzKFd+
         TGjA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781707949; x=1782312749; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rRL5oribGYZKW3GCbWudAKMbSR10/FVZtjDSZUF5qUc=;
        b=IdZWu9pj1BXYXox1F2vuzn+6N9amITcUz/Dql+8DdGTxGilfHKqeMhhgy0J/pWSqEW
         J7wE1OJ6yi786DNq+9mw6E8Nu90wEfHRSMvDPdJqK0NAUeAxG2mpOx13Bmf7179du7HY
         8whhxXp9YlkUZ4AxgsFU9iBrdoU5kPNhlrdSG9pMRDiCxPpQyE+EQug13G5e9fZQaNdX
         JtanltPluJPC3fqjOQhLrd5+tWnflT46mYFMKOQ7Yd/cIkevfW27b6ZaCj2GqnNotHaL
         MmSvoSBpaFxRR//IwaVlK9k0qByeJiu2ss8VyCarrrGNauU81YOiiDV5Q3Nyqs8apwv1
         DgEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781707949; x=1782312749;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rRL5oribGYZKW3GCbWudAKMbSR10/FVZtjDSZUF5qUc=;
        b=sCcrNzPvSlYjKQWjaiLlyfPL21SmYPKb58zmug8GhUcpAscGDaMmyQgxNk1QsE2gU4
         MfmO8KiZ679vE1qMNR6ZpcdAsyUHoG4GNyjOnxK1QHESvhw/OtY/zfxqXXNcS0XeWVDe
         jklTeP2W7PyrgcLm9T8YH86z5MhSq1kA0f/t726oVKIhiZEuaJcK9sK5vWecp59I9Zh+
         Tozs/23BAMXiDQkWQpcSjnU+pbuBgsAceaTnzJwbEEtbmTtH7pPJhESGhtL2CnzIbLcP
         3CPM+4R7l+aTtgUGN5SioVqc72sSMNWkWZHFT/jszgm5QiMhofZYV333YRfNglMuLdtx
         2QEg==
X-Forwarded-Encrypted: i=1; AFNElJ/iIVTpLS/8hvFz+qkT9rBIfnSvO39qwlxvNoCTUqQHuYzZQpJVRnR5qJ+jQUZbyPLBLMSzZ6E=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSGI38vlqa0sVmgSeTZTDhVfj2tfMM89kshyArvqwdkegkjQmx
	WUjMyaenZdxBBVIeC+qnIJR8AcSXDQIo7X2rPdjUgdQvv6TJinLpP57esC23iXiRpmOl+DGXl5K
	JH85x7CHqPGl3DG+V9203SlAEXhRJH4WinTZ4K58Ki8HlZzTVlDHOXS5cntY=
X-Gm-Gg: Acq92OF3lwUUdzfnougFdYyBIuxYFjlKFtuK+04rThVV0FHYDUhPgaH7UI7TX4fIBab
	ovapP0FZh+pehWLIy7W5H/CfrYEOiIoPFp4V3UyrynJcOzGBufZPerTF5KxDVHh0pd2phIdzgIp
	tdEdlI2o/651OUmWgnNnf5m8fh8hnbW6iY8j3BkLDctZxjrmm7y9a38znmzKg0yFOituz/k/J8b
	NelAkMdrHgphJ/3tm7xC0kUESQMwu4fnjhpBLCFbAJ+wjUzYenW9bvHKZ0ek5G06liJldM7bSHW
	qly525dnDjPe3KSHXVKS4ina9+g=
X-Received: by 2002:a05:622a:1143:b0:519:56a8:2693 with SMTP id
 d75a77b69052e-519aad18b33mr10178591cf.24.1781707948213; Wed, 17 Jun 2026
 07:52:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260614163336.3490925-5-tabba@google.com> <20260614164547.D398B1F000E9@smtp.kernel.org>
 <CA+EHjTwHoveK6FT0CGcKuj97aUaHpv7vk=DQjRxT9c6UkkSeoA@mail.gmail.com>
 <86wlvxs5r0.wl-maz@kernel.org> <CA+EHjTzWpLBxy=Pi=K0G-9JU0cPTsGSNB4Esy+K+vFYNM0DnNw@mail.gmail.com>
 <86v7bhs0af.wl-maz@kernel.org>
In-Reply-To: <86v7bhs0af.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 17 Jun 2026 15:51:51 +0100
X-Gm-Features: AVVi8Ce476niaO8Z4RT83x1LhKP1vNSFXlSVYznEqkjoo5qVPP39l7ZYDE5bAKw
Message-ID: <CA+EHjTy_t2SR7yeehg3JDV5+1pa=BpREQ2-UuinZ2SQAgj3JZw@mail.gmail.com>
Subject: Re: [PATCH 4/7] KVM: arm64: Set IL for injected FPAC exceptions
 during ERET emulation
To: Marc Zyngier <maz@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, 17 Jun 2026 at 15:34, Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 17 Jun 2026 13:39:14 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > On Wed, 17 Jun 2026 at 13:36, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > On Mon, 15 Jun 2026 13:42:23 +0100,
> > > Fuad Tabba <tabba@google.com> wrote:
> > > >
> > > > On Sun, 14 Jun 2026 at 17:45, <sashiko-bot@kernel.org> wrote:
> > > > >
> > > > One thing I noticed while looking at this:
> > > > kvm_check_illegal_exception_return() preserves {N,Z,C,V,D,A,I,F} from
> > > > the current PSTATE, but the Arm ARM says these should come from
> > > > SPSR_ELx on an illegal exception return (EL and SP are unchanged, but
> > > > the flags and masks are taken from SPSR). PAN and ALLINT should also
> > > > come from SPSR_ELx if their respective features are implemented.
> > > >
> > > > Marc, is the current behavior intentional, or should we be
> > > > constructing PSTATE from the original SPSR_EL2 for those fields?
> > >
> > > This looks like a long standing bug for something we really never
> > > tested. I reckon the patch below would do the trick.
> > >
> > >         M.
> > >
> > > +++ b/arch/arm64/kvm/emulate-nested.c
> > > @@ -2746,17 +2746,29 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
> > >             (spsr & PSR_MODE32_BIT) ||
> > >             (vcpu_el2_tge_is_set(vcpu) && (mode == PSR_MODE_EL1t ||
> > >                                            mode == PSR_MODE_EL1h))) {
> > > +               u64 mask;
> > > +
> > >                 /*
> > >                  * The guest is playing with our nerves. Preserve EL, SP,
> > > -                * masks, flags from the existing PSTATE, and set IL.
> > > -                * The HW will then generate an Illegal State Exception
> > > -                * immediately after ERET.
> > > +                * masks, flags from the existing SPSR, and set IL (see
> > > +                * R_VWJHB). The HW will then generate an Illegal State
> > > +                * Exception immediately after ERET.
> > >                  */
> > > -               spsr = *vcpu_cpsr(vcpu);
> > > -
> > > -               spsr &= (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
> > > +               mask  = (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
> > >                          PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT | PSR_V_BIT |
> > >                          PSR_MODE_MASK | PSR_MODE32_BIT);
> > > +
> > > +               if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, PAN, IMP))
> > > +                       mask |= PSR_PAN_BIT;
> > > +               if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, NMI, IMP))
> > > +                       mask |= ALLINT_ALLINT;
> > > +               /* Account for FEAT_SPE_EXC and FEAT_TRBE_EXC one day... */
> > > +               if (kvm_has_feat(vcpu->kvm, ID_AA64DFR1_EL1, EBEP, IMP))
> > > +                       mask |= BIT_ULL(32);
> > > +               if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
> > > +                       mask |= BIT_ULL(34);
> > > +
> > > +               spsr &= mask;
> >
> > I'm on it...
>
> Sorry, in what sense?

Writing up the fix:
https://lore.kernel.org/all/20260617144907.2972095-1-tabba@google.com/

which deviated slightly from your suggestion above.

Cheers,
/fuad
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
