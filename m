Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9750A34D389
	for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 17:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781716802; cv=pass; b=WTXttkxLOTq/i/VhkCMsbTJVIUuUq2yLqH7Gdkv1HdDOGnNed+ptWKZI4ibPn1zag65YpTQAxzMtZ7rPcYFUJD2U2XbajB1ZmADaHfMBfpnPTHU5YxAK3sCE/FIkDgpgPP4lRDge2DOe2hTq7sVQYl6NGxX5LgZWEs7h6MoXoMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781716802; c=relaxed/simple;
	bh=C9hFbRekoszdbWXkvD6vZit4kCdzFsqxocdngZdXekc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GkVkT2O/xVCvRXwCID2HB+kczlQEI1ODfs5NHpI6pTK+qTyaliOyqidnN9vUHqPbIxRsZ5SbCF/tV/5bi8APeYNYeTzKzkae5csBzc5VlUfsg554a8IQNpfaJCm5g98lxEAbw+CU72yy0d3mQM/HvxWM9sqDQl9F82/z5vYHuGg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QAIiYPQP; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QAIiYPQP"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5177d1ff061so14061cf.1
        for <kvmarm@lists.linux.dev>; Wed, 17 Jun 2026 10:19:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781716798; cv=none;
        d=google.com; s=arc-20260327;
        b=MCr2p1UABGkJGJ80HmTPGGkk6pSvKomlngsk1xFpJ5JLVPxVAJrf1D6Wzd0R4kqz5j
         14aPH97PRZc+Tn0O7gcJIXpPpXPxuli9oeMgMhT0rWf35MhIVTc5EMnIzSdEWuITtq62
         TB7/YOle7CGauApAKdShECzHzdXw+WFoWnMqSH0cEx30bvmBsVfPBRT8yZVBN92dyn2+
         rdYHiMQ7nQ3sRgXAYc+XzTB7ln4CqyMffxz5GWD2baWoTU//2cAnUa9Cn3ITQ7Uxfg4w
         Nk+9y4uEpL50YUR+b75YjVve01qbUYftSNgVniACGYkIPRCJBy7Xe6+0FfzzEYyzuz5k
         ODnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=i5AuHa12lkUBfYhiINFlt22UCH0oA/1yHIWHNN85vbE=;
        fh=d0rWcySBfLt9CKW0skMDRoYtm2FXu3HIA9yhsp+DE6o=;
        b=Al3smZDAcHoQsPMJLEIx/1LjKnqps7OdtxlvFbcjUhj9nvD0iULwqScn4arDBNbRzc
         +5nJ6DxdA0zDUrcG+DMSxEspR6d61Zj+wR2VGsoY8K9QwD0EnCRmk1XlbN/tbgYyIitW
         HXpoeSaDEimTN8mXXNroa2mPK/EkGMrPsm8kld+sAhd0fsGn9zd8MA0tXkh/O/TRkKqA
         mqdwJku258nCmPMAH+C4uFoWo7NadRoB8gnJ4cOiMAPrnkNE1LaFVQUTj9sDnLlMprEk
         gkk9ldC94Q029glOrjtFOep3l8TCaZ9NJ2bLYYBwcIVt2pytAWgXvDYdPWO6UIqr5Wav
         IpAw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781716798; x=1782321598; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i5AuHa12lkUBfYhiINFlt22UCH0oA/1yHIWHNN85vbE=;
        b=QAIiYPQPauHgDGd8GoiZpkGQbKf8N2+rmEqiCLIden0nO/Qf6nNIHg70WXOaiSzPqo
         7C1m3E32Oc1CULryp/90b3IBQYQWdJIQ319zaCqmGQYXAZ3f7vN5K5OXal1uT3BxM6HT
         r22TNBm0hilF2SLDUaOqdKHhRFxuLHX5yC6D8/5JHkIh0TY3pKWDNTH+Mm5v40C+DQPp
         uPwGo5W0T1KHcfdRNIf5BERfTRjaFkH7Rv8r/Gzta+t0B+n3w3e2EGtYkDQoAjOSX6cw
         Rz/MoaVQNqJtMOGY8eLJ8znohpuFQa/L4BT7tOJ7b0W3ntn7pEfryzQoxjDuw4n6zRqL
         LzVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781716798; x=1782321598;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=i5AuHa12lkUBfYhiINFlt22UCH0oA/1yHIWHNN85vbE=;
        b=oFZZmw18EZpsQnHwWQtbgwBzaQ6BGabOY+zhnxRxJZWDhd4Xwv39zjBAlkt1GHopXa
         3byKKCEfv806lpRwEYDyc5wQA8WUzHWxq0ZroDOsNJAlIBxe73zK/+jNqnX9ZgkGoiPc
         H5RLY3kBwyXseeJBp3JasT2m8TM70XXTFgVIpDXw4/vhU+IvHLNibt6U9BraWUYI/m1x
         Cxm5Xrm0ELFNM+FZro2X1Qpi2tVsE+vdfOBwJAuwONaAUtTmury26CaB48zlvWp4sMhe
         c2m5m/imebPxLpiGejrI7kMLzTD6Qsfc3sUYvekzUcmN49zFeFkd4wl3dnpeyVBWQTRR
         4Cxg==
X-Forwarded-Encrypted: i=1; AFNElJ/YVQDZRXhiNSzqhs0UKbcLhnAVWtLAVy1IU4t/SeBBTr9RzCs2tEaNCsk7x/3bEeAcbfcX3Rg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBgnuSLBUXAQdhvbL/fKuns//y0sAETKhtetMX6ZxL+FH1ilUt
	SjAVNeK9RT3FcqcZ/3aqsRnaD/xCurQhWs25NxRFzzsyntK+oHliovoqwYRG9IBf6IIjU7nzMgP
	4enVf2NMlG8IbOyO9CifrG785MvAtwOhJWos8GeS2
X-Gm-Gg: Acq92OHUHEqFlrZQw2OqybYmmmSwvLRPsnvMZE+dwhST870e+kvcYyFHKN5qE4ewFQo
	OejxJhweEJLigi24c+NDwy8Yf6tfyOCdzyqRbo7mBKsnw3wr5vlDZG4RJi6JflysQ3/lbHySeqN
	cKx4AueOEG3/KQ7Tzi8wh+dGmozsdulYNfLykd9CJyAmWdLNsWcsU79pY/B1zH5KBsegC/yY+PR
	hx7zMqHMpElN/hehnxLe6ajD+YyuHQRDM4te3DjB3OrCeYHMjn+tNIQJfOv3hq/wwWczrKTGQ==
X-Received: by 2002:a05:622a:5a12:b0:516:4f62:85eb with SMTP id
 d75a77b69052e-519c661aee8mr160121cf.22.1781716797721; Wed, 17 Jun 2026
 10:19:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260617144907.2972095-1-tabba@google.com> <86se6lru7w.wl-maz@kernel.org>
In-Reply-To: <86se6lru7w.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 17 Jun 2026 18:19:20 +0100
X-Gm-Features: AVVi8CekeI_lGuSPPCeiswsqcvt1h5ISzFMhZQqw1f94ExrSVGJodvqXM6iSYrs
Message-ID: <CA+EHjTyv107RDF_MG1AtqqpJsiRbFx=xbrp12TgSu_N8dS55oA@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: nv: Fix PSTATE construction on illegal
 exception return
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Jintack Lim <jintack.lim@linaro.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	Christoffer Dall <christoffer.dall@arm.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 17 Jun 2026 at 17:45, Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 17 Jun 2026 15:49:07 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > kvm_check_illegal_exception_return() sourced the flags {N,Z,C,V} and
> > masks {D,A,I,F} of the resulting PSTATE from the current PSTATE, but
> > R_VWJHB takes them from the SPSR being returned to and leaves
> > PSTATE.{EL,SP,nRW} (and EXLOCK when FEAT_GCS) unchanged. PAN, ALLINT
> > and PM were not applied at all.
> >
> > Build the PSTATE by taking those fields from the SPSR while preserving
> > EL, SP, nRW and EXLOCK from the current PSTATE, then set IL.
> >
> > Fixes: 47f3a2fc765a ("KVM: arm64: nv: Support virtual EL2 exceptions")
> > Suggested-by: Marc Zyngier <maz@kernel.org>
> > Link: https://lore.kernel.org/all/86wlvxs5r0.wl-maz@kernel.org/
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> > This is a modified version of Marc's suggested diff [1]. That diff applied
> > a single mask to the incoming SPSR, which also takes PSTATE.{EL,SP,nRW}
> > (and EXLOCK) from the SPSR. The ARM ARM leaves those fields unchanged on an
> > illegal exception return. This path is reached precisely because SPSR.M is
> > illegal (EL3, M[1]=1, AArch32, EL1 under TGE), so this version preserves
> > EL/SP/nRW/EXLOCK from the current PSTATE and takes only the flags, masks
> > and PAN/ALLINT/PM from the SPSR.
> >
> > [1] https://lore.kernel.org/all/86wlvxs5r0.wl-maz@kernel.org/
> > ---
> >  arch/arm64/kvm/emulate-nested.c | 33 +++++++++++++++++++++++----------
> >  1 file changed, 23 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> > index dba7ced74ca5..ace2b40cf875 100644
> > --- a/arch/arm64/kvm/emulate-nested.c
> > +++ b/arch/arm64/kvm/emulate-nested.c
> > @@ -2738,17 +2738,30 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
> >           (spsr & PSR_MODE32_BIT) ||
> >           (vcpu_el2_tge_is_set(vcpu) && (mode == PSR_MODE_EL1t ||
> >                                          mode == PSR_MODE_EL1h))) {
> > -             /*
> > -              * The guest is playing with our nerves. Preserve EL, SP,
> > -              * masks, flags from the existing PSTATE, and set IL.
> > -              * The HW will then generate an Illegal State Exception
> > -              * immediately after ERET.
> > -              */
> > -             spsr = *vcpu_cpsr(vcpu);
> > +             u64 cpsr = *vcpu_cpsr(vcpu);
> > +             u64 mask;
> >
> > -             spsr &= (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
> > -                      PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT | PSR_V_BIT |
> > -                      PSR_MODE_MASK | PSR_MODE32_BIT);
> > +             /*
> > +              * On an illegal exception return, PSTATE.{EL,SP,nRW} and,
> > +              * if FEAT_GCS, PSTATE.EXLOCK are unchanged, while the flags
> > +              * and masks are taken from the SPSR (R_VWJHB). Set IL so the
> > +              * HW generates an Illegal State Exception right after ERET.
> > +              */
> > +             mask = PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
> > +                    PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT | PSR_V_BIT;
> > +
> > +             if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, PAN, IMP))
> > +                     mask |= PSR_PAN_BIT;
> > +             if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, NMI, IMP))
> > +                     mask |= ALLINT_ALLINT;
> > +             /* FEAT_SPE_EXC and FEAT_TRBE_EXC also gate PSTATE.PM one day... */
> > +             if (kvm_has_feat(vcpu->kvm, ID_AA64DFR1_EL1, EBEP, IMP))
> > +                     mask |= BIT_ULL(32);    /* PSTATE.PM */
> > +
> > +             spsr &= mask;
> > +             spsr |= cpsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
> > +             if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
> > +                     spsr |= cpsr & BIT_ULL(34);     /* PSTATE.EXLOCK */
> >               spsr |= PSR_IL_BIT;
> >       }
>
> While I'm happy that you caught the bugs I left for you to address,
> the overall structure is a bit inconsistent. I'd like to have:
>
> - a mask of the bits we preserve from SPSR, and apply that to SPSR
>   itself
>
> - a mask of the bits we preserve from PSTATE, and transfer them to
>   SPSR
>
> - the comment at the top to describe this in that particular order.
>
> With that, I reworked your patch as follows:
>
> diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> index bb335fa16f7cc..243e5e26f7018 100644
> --- a/arch/arm64/kvm/emulate-nested.c
> +++ b/arch/arm64/kvm/emulate-nested.c
> @@ -2746,14 +2746,14 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
>             (spsr & PSR_MODE32_BIT) ||
>             (vcpu_el2_tge_is_set(vcpu) && (mode == PSR_MODE_EL1t ||
>                                            mode == PSR_MODE_EL1h))) {
> -               u64 cpsr = *vcpu_cpsr(vcpu);
>                 u64 mask;
>
>                 /*
> -                * On an illegal exception return, PSTATE.{EL,SP,nRW} and,
> -                * if FEAT_GCS, PSTATE.EXLOCK are unchanged, while the flags
> -                * and masks are taken from the SPSR (R_VWJHB). Set IL so the
> -                * HW generates an Illegal State Exception right after ERET.
> +                * On an illegal exception return, the flags and masks are
> +                * taken from the SPSR while PSTATE.{EL,SP,nRW} and, if
> +                * FEAT_GCS, PSTATE.EXLOCK are unchanged (R_VWJHB). Set IL
> +                * so the HW generates an Illegal State Exception right
> +                * after ERET.
>                  */
>                 mask = PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
>                        PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT | PSR_V_BIT;
> @@ -2767,9 +2767,12 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
>                         mask |= BIT_ULL(32);    /* PSTATE.PM */
>
>                 spsr &= mask;
> -               spsr |= cpsr & (PSR_MODE_MASK | PSR_MODE32_BIT);
> +
> +               mask = PSR_MODE_MASK | PSR_MODE32_BIT;
>                 if (kvm_has_feat(vcpu->kvm, ID_AA64PFR1_EL1, GCS, IMP))
> -                       spsr |= cpsr & BIT_ULL(34);     /* PSTATE.EXLOCK */
> +                       mask |= BIT_ULL(34);    /* PSTATE.EXLOCK */
> +
> +               spsr |= *vcpu_cpsr(vcpu) & mask;
>                 spsr |= PSR_IL_BIT;
>         }
>
> Does that work for you?

Yes, that's cleaner, thanks. The two-mask form (take from SPSR, then
preserve from PSTATE) reads better than my interleaved version.

Would you like me to send a v2 (which would be identical to the above?
:) ), or would you fold it in?

Cheers,
/fuad

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
