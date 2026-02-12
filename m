Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3242DCF7B
	for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 09:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770889322; cv=pass; b=ULtXR77nBxqZCtUv9Dvy/2yzI1YdkyIbJO5ZPBfWabHJK13Ij0d+fWUkQnxPLRlA/8fWqKrxWsXWBpgCt+3+ZEWR7n43Y0yqMmR6PuXpWOkewSaY5CZ93OuM7/pNqLeaNY8EK6t/+DEkdCPX6Ds9qviJu03Hs5UniplZjLsBv94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770889322; c=relaxed/simple;
	bh=zmTrhOt5I67WnfOpJVUIewScgn5nhORqAKcL5d/sLMk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dZkCDeGx7ADmsY1bC7q7yJ8Ykg7a3sZIEngINjTPxoZL+B8KuyJAzbxxK9XRfg7uPSV9hDPx92bIW5KwjqJNw+zwwMijmCc35ZP+ghPghzwAK8FMfjSI0Xf9OkVnTbt1hVVne/QJFDzh6AGOwkietuwHduFWRln4OnNyXsolyfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=H0wTSELb; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H0wTSELb"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-505d3baf1a7so315171cf.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Feb 2026 01:42:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770889319; cv=none;
        d=google.com; s=arc-20240605;
        b=UQHBNjSVx73y1Jl7H+e43GBqXM7qG5swMnu2sH3i9GtDiOlZbmpSe1v0AKiRul/xHp
         V4SZVcKYB2TTmEKxleYNXcr7hG8axaeMp2GzIxAmthmKV352x4oCBu7QuHeqGaGGfS6v
         JhqThl4puKGg1yfQdAlxsw5pwj4Pj4n39SvnwYUwKsrB2sALCOgsOtLwdxWLy74O1qLW
         0T48bX2GwSHpO26t5+NFvKGdsJbZKnO/Omrm7iSd8p8LvtrBuQYb5If+y0glMySZWfIK
         SSg7kuJtLr9vp1ZcneL4Dm7RcUj0iu0IfEp2FhC0M6ZVT9Oxwr79A4C9TRwV0mi1o3Uz
         K/JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=VcH9GZLlhn0MK8AoO+gKd8YN91XeUHOY861U71nMAN8=;
        fh=eHCW/NkhluEwAKmi47YtEZ5iXbxUC1WQmRBp1rmh8Bs=;
        b=BsTjjlnAoDMKzruNadBiCEF1EjB79ms1aC1ZlFBR+PantW3mpAjAFzma5lKSWEwF2I
         4sEBBOqK3PqNhRgXAPvcAxMyth6WEDspi9dVqrnSq5v675QMTU04W3a1OgVBr/QirMO/
         MJ84W1pd6a3o/hslU3XwWalq2WiVOwvsfPiI593eUnJIPOiFywlJ9dom0L2XUi5kDKjH
         ZzL9Tx9O53y593MHj8ur+2NnT5K4ShZSoB/21mMmZAIUOixrp6w8bYcOVDJ3mN9g4T2j
         MHocBiE0DAlGPC5oI5Opbh8iM4RoEtCHVLdExi/9hXEVAaFYrphS7Q22h6qI+7ScTqBx
         cKkA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770889319; x=1771494119; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VcH9GZLlhn0MK8AoO+gKd8YN91XeUHOY861U71nMAN8=;
        b=H0wTSELbI4EKYl4C6ZoLOJ9EDXoJE9wSWXkre6dIb/T/ox4rzbx8EisxyBtP0lGVJX
         rXnb3B2Kk13/yl04afhxt2izlcoc8c8jb/T71Lytlyv50g6A6cw2TKivBC49nlfDO+uG
         nmWBIBP8KljWRS5aI4AhJ1xu7wTVHOm6qRV10regmFXBreq7DGtnESJ1fV5uhFFu0QVf
         lMyhluSHhWxfg2fHXwkiOdAQACgqtOfjY6eF1vZ5kRzKrbpxVuEQIGPaQFY3aXcL4N2N
         eai5OPzEmppuMHQpjihu2uVK6oPq05Lvf93hCU+gVyU2ASBGVZGX9Gm+fd0+euQyTIDC
         j8nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770889319; x=1771494119;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VcH9GZLlhn0MK8AoO+gKd8YN91XeUHOY861U71nMAN8=;
        b=MMjVH/MtCSgpRFDQAn0NFXMkoo4xQ0UMz1UTZeFXT3KsyvQ07R0oAIJQ4+0qbYGd6y
         4NzIRfE/n5Gxoad0+UqEv7qrFEtkzPafIcKpn5qsCEvau10TJJdLtIPdJnlafAu+ivUi
         0seehhISe2U8jpm8cdM73dLTf3PkmB0sHTgu/yS5vH5IA24frDsCkk+xRchODyCt12ie
         MBtf2DIqv3K+QPfAxOuNV6alatBgdiMJq38ykrmgFl26ERSH3+61NqMJfrDtzTZRfbzA
         GnV3Awriva89OvN91AIOVoQWIueqwIQO3N2Ibjo/FXrNJ5TSzYckEVpXNymljchetqEU
         abfA==
X-Forwarded-Encrypted: i=1; AJvYcCU5wFpYqnfhWT6/Fk+8/ukyM0PN3ID5q60t7H9IyrmxFytOwpGl9fzJljRYcVfFmHwhde4TfFk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwX+xsa0SjtqAbfv45g6nJGh4Qhq5k+A6RyXhzpqT9sLNfyiDhN
	y9p6p40IxcoCZNk2Jy8u8ZMVb26o9s0JplwxCSOm9aNQdiPPHqO9Yf7HYJnIDbY/OobhmmzTiyv
	O5fAK3Cnp5Y9my4zP3Sz7Ii5VwmC2YOwF7CdDZnz2
X-Gm-Gg: AZuq6aIGQk8+sRMxqiR7sWld2w+cud5FwEjB0j51sg1r267IgEXHOfeLBy4RIWmt0OI
	1XhjYH1SeoBTwWHPWdz0nz/9Au7cyQPNwF3L0yrE44kfzo+bA+98t9+god85Z/L49b0fd79gF0U
	U0MMBK1FHpe3gPZiUGhrlzJ/o8Bq4bQNm4lR6uH3fEhhLAqaJNHExq3hn3e6YgYRUq/QyV3Y/Vh
	p3noA7+OoxBotqreAXGT+H4cAeQbry1anULZqXrtmBl/kUvCHdfkgn3hAecomU4AU1l+yuatz4D
	qDSDjyNk
X-Received: by 2002:a05:622a:4f8e:b0:506:9852:75ec with SMTP id
 d75a77b69052e-506985282abmr2869311cf.9.1770889318777; Thu, 12 Feb 2026
 01:41:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260212090252.158689-1-tabba@google.com> <20260212090252.158689-2-tabba@google.com>
 <86jywib98e.wl-maz@kernel.org>
In-Reply-To: <86jywib98e.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 12 Feb 2026 09:41:22 +0000
X-Gm-Features: AZwV_QiSeFqGPiRC70jpUcnw67INjoq4qSM1niKSMpmtbfB7i8EWB8CCB6Ry2n4
Message-ID: <CA+EHjTz-JU2gDfziCY2SguK9=6gGSCL5TN_U_C7FiZ5i0JTZqQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] KVM: arm64: Hide S1POE from guests when not
 supported by the host
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, oliver.upton@linux.dev, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Marc,

On Thu, 12 Feb 2026 at 09:29, Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Fuad,
>
> On Thu, 12 Feb 2026 09:02:50 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > When CONFIG_ARM64_POE is disabled, KVM does not save/restore POR_EL1.
> > However, ID_AA64MMFR3_EL1 sanitisation currently exposes the feature to
> > guests whenever the hardware supports it, ignoring the host kernel
> > configuration.
>
> This is the umpteenth time we get caught by this. PAN was the latest
> instance until this one. Maybe an approach would be to have a default
> override when a config option is not enabled, so that KVM is
> consistent with the rest of the kernel?

I spoke to Will about this, and one thing he'll look into is whether
this value in `struct arm64_ftr_reg` can be made consistent with the
cpu configuration itself (in cpufeature.c itself) . This would avoid
the problem altogether if possible. The question is whether the kernel
needs to somehow know that a certain feature exists even if it's
disabled in the config...

If he thinks it's not doable at that level, I'll look into
alternatives to make it correct by construction.

> >
> > If a guest detects this feature and attempts to use it, the host will
> > fail to context-switch POR_EL1, potentially leading to state corruption.
> >
> > Fix this by masking ID_AA64MMFR3_EL1.S1POE and preventing KVM from
> > advertising the feature when the host does not support it, i.e.,
> > system_supports_poe() is false.
> >
> > Fixes: 70ed7238297f ("KVM: arm64: Sanitise ID_AA64MMFR3_EL1")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 3 ++-
> >  arch/arm64/kvm/sys_regs.c         | 3 +++
> >  2 files changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index ac7f970c7883..7af72ca749a6 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -1592,7 +1592,8 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
> >       (kvm_has_feat((k), ID_AA64MMFR3_EL1, S1PIE, IMP))
> >
> >  #define kvm_has_s1poe(k)                             \
> > -     (kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
> > +     (system_supports_poe() &&                       \
> > +      kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
>
> Why do we need to further key this on system_supports_poe()? I can see
> this is a potential optimisation, but I don't think this is part of
> the minimal fix.

I did this to be consistent with similar checks, e.g., kvm_has_fpmr().
I can remove it or put it in a separate patch, whichever you prefer.

>
> >
> >  #define kvm_has_ras(k)                                       \
> >       (kvm_has_feat((k), ID_AA64PFR0_EL1, RAS, IMP))
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 88a57ca36d96..237e8bd1cf29 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1816,6 +1816,9 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
> >                      ID_AA64MMFR3_EL1_SCTLRX |
> >                      ID_AA64MMFR3_EL1_S1POE |
> >                      ID_AA64MMFR3_EL1_S1PIE;
> > +
> > +             if (!system_supports_poe())
> > +                     val &= ~ID_AA64MMFR3_EL1_S1POE;
>
> How about S1PIE? It seems to have a similar problem, in the sense that
> it has extra state. But I guess because we don't put it behind a
> config option, we context-switch it anyway and all is good?

Like you said, S1PIE doesn't have a config option. I thought if I were
to add one to S1PIE, then why not add one to the other features that
don't have config options... It is conceivable that a config option
might be added in the future, but like you noted above, I think we
need a deeper fix that nips this problem in the bud.

Let's see if Will thinks that we can fix this at the `arm64`
cpufeature layer, rather than somewhere in KVM.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
